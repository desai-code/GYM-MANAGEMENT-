using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Web;
using System.Web.Hosting;

/// <summary>
/// Single place that opens the MS Access database for EVERY page (admin + client).
///
///  * Path comes from Web.config ("GymDb") -> App_Data\projectdatabase.mdb. No hard-coded drive paths.
///  * Tries the ACE provider first (works on 32 and 64-bit if the Access Database Engine
///    is installed) and falls back to the old Jet 4.0 provider (32-bit app pool only).
///  * On first use it makes sure every table/column the site needs exists (additive only -
///    it never deletes or changes your data). If the .mdb file is missing it creates a new one.
///  * ALWAYS use:  using (OleDbConnection con = DbHelper.GetConnection()) { ... }
///    so the connection is closed and the .mdb file lock is released.
/// </summary>
public static class DbHelper
{
    private static readonly object Sync = new object();
    private static bool _schemaChecked;
    private static string _provider;

    public static readonly string[] Providers = { "Microsoft.ACE.OLEDB.12.0", "Microsoft.Jet.OLEDB.4.0" };

    // ------------------------------------------------------------------ paths
    public static string DbPath
    {
        get
        {
            string cs = ConfigurationManager.ConnectionStrings["GymDb"].ConnectionString;
            string appData = HostingEnvironment.MapPath("~/App_Data");
            string expanded = cs.Replace("|DataDirectory|", appData);
            foreach (string part in expanded.Split(';'))
            {
                int i = part.IndexOf('=');
                if (i > 0 && part.Substring(0, i).Trim().Equals("Data Source", StringComparison.OrdinalIgnoreCase))
                    return part.Substring(i + 1).Trim();
            }
            return Path.Combine(appData, "projectdatabase.mdb");
        }
    }

    private static string BuildConnString(string provider)
    {
        return "Provider=" + provider + ";Data Source=" + DbPath + ";Persist Security Info=False";
    }

    // ------------------------------------------------------------- connection
    public static OleDbConnection GetConnection()
    {
        if (!_schemaChecked)
        {
            lock (Sync)
            {
                if (!_schemaChecked)
                {
                    _schemaChecked = true; // set first: EnsureSchema itself opens connections
                    try { EnsureDatabase(); }
                    catch (Exception ex) { Log(ex); }
                }
            }
        }
        return OpenRaw();
    }

    private static OleDbConnection OpenRaw()
    {
        List<string> errors = new List<string>();
        List<string> order = new List<string>();
        if (_provider != null) order.Add(_provider);
        foreach (string p in Providers) if (!order.Contains(p)) order.Add(p);

        foreach (string provider in order)
        {
            OleDbConnection con = new OleDbConnection(BuildConnString(provider));
            try
            {
                con.Open();
                _provider = provider;
                return con;
            }
            catch (Exception ex)
            {
                con.Dispose();
                errors.Add(provider + ": " + ex.Message);
            }
        }
        throw new Exception(
            "Database connection failed. Checklist: (1) 'Microsoft Access Database Engine 2016 Redistributable' installed " +
            "(or the app pool set to 32-bit for the Jet provider); (2) file exists: " + DbPath + "; " +
            "(3) the .mdb is not open in Microsoft Access; (4) the app pool identity has read/write (Modify) permission on App_Data. " +
            "Details: " + string.Join(" | ", errors.ToArray()));
    }

    // ----------------------------------------------------------------- schema
    private class Col
    {
        public string Name, Ddl;
        public Col(string n, string d) { Name = n; Ddl = d; }
    }

    private static Dictionary<string, Col[]> Schema()
    {
        Dictionary<string, Col[]> s = new Dictionary<string, Col[]>();
        s["admin"] = new[] { new Col("fullname", "TEXT(100)"), new Col("email", "TEXT(150)"), new Col("passwordd", "TEXT(255)"), new Col("lastlogin", "DATETIME") };
        s["member"] = new[] {
            new Col("fullname", "TEXT(100)"), new Col("email", "TEXT(150)"), new Col("passwordd", "TEXT(255)"),
            new Col("dateofbirth", "TEXT(30)"), new Col("mobileno", "TEXT(30)"), new Col("gender", "TEXT(20)"),
            new Col("address", "TEXT(255)"), new Col("joindate", "TEXT(30)"), new Col("height", "TEXT(20)"),
            new Col("weight", "TEXT(20)"), new Col("lastlogin", "DATETIME"),
            new Col("planid", "LONG"), new Col("planname", "TEXT(100)"), new Col("plandate", "DATETIME") };
        s["membership"] = new[] { new Col("planname", "TEXT(100)"), new Col("membershipduration", "TEXT(30)"), new Col("price", "TEXT(30)") };
        s["trainer"] = new[] {
            new Col("trainername", "TEXT(100)"), new Col("specialization", "TEXT(150)"), new Col("phoneno", "TEXT(30)"),
            new Col("salary", "TEXT(30)"), new Col("exprerience", "TEXT(30)"), new Col("photo", "TEXT(255)") };
        s["program"] = new[] { new Col("programname", "TEXT(100)"), new Col("description", "TEXT(255)"), new Col("icon", "TEXT(60)"), new Col("trainerid", "LONG") };
        s["programslot"] = new[] { new Col("programid", "LONG"), new Col("dayname", "TEXT(20)"), new Col("slottime", "TEXT(30)") };
        s["booking"] = new[] {
            new Col("memberid", "LONG"), new Col("programid", "LONG"), new Col("programname", "TEXT(100)"), new Col("trainername", "TEXT(100)"),
            new Col("bookingday", "TEXT(20)"), new Col("bookingslot", "TEXT(30)"), new Col("bookingdate", "DATETIME") };
        s["supplement"] = new[] {
            new Col("name", "TEXT(150)"), new Col("description", "TEXT(255)"), new Col("price", "CURRENCY"),
            new Col("size", "TEXT(50)"), new Col("imageurl", "TEXT(255)") };
        s["orderitem"] = new[] {
            new Col("memberid", "LONG"), new Col("supplementname", "TEXT(150)"), new Col("price", "CURRENCY"),
            new Col("quantity", "LONG"), new Col("orderdate", "DATETIME") };
        return s;
    }

    private static void EnsureDatabase()
    {
        string path = DbPath;
        bool created = false;
        if (!File.Exists(path))
        {
            Directory.CreateDirectory(Path.GetDirectoryName(path));
            CreateEmptyMdb(path);
            created = true;
        }

        using (OleDbConnection con = OpenRaw())
        {
            foreach (KeyValuePair<string, Col[]> t in Schema())
            {
                if (!TableExists(con, t.Key))
                {
                    StringBuilder sb = new StringBuilder("CREATE TABLE [" + t.Key + "] (id COUNTER PRIMARY KEY");
                    foreach (Col c in t.Value) sb.Append(", [" + c.Name + "] " + c.Ddl);
                    sb.Append(")");
                    Exec(con, sb.ToString());
                }
                else
                {
                    Dictionary<string, int> existing = ColumnLengths(con, t.Key);
                    foreach (Col c in t.Value)
                    {
                        if (!existing.ContainsKey(c.Name.ToLowerInvariant()))
                            Exec(con, "ALTER TABLE [" + t.Key + "] ADD COLUMN [" + c.Name + "] " + c.Ddl);
                    }
                    // password columns must be able to hold a salted hash
                    if (c_isPwd(t.Key))
                    {
                        int len;
                        if (existing.TryGetValue("passwordd", out len) && len > 0 && len < 255)
                        {
                            try { Exec(con, "ALTER TABLE [" + t.Key + "] ALTER COLUMN [passwordd] TEXT(255)"); }
                            catch (Exception ex) { Log(ex); }
                        }
                    }
                }
            }

            // Brand-new / empty admin table: seed a first admin so the panel can be opened.
            using (OleDbCommand cnt = new OleDbCommand("SELECT COUNT(*) FROM [admin]", con))
            {
                if (Convert.ToInt32(cnt.ExecuteScalar()) == 0)
                {
                    using (OleDbCommand ins = new OleDbCommand("INSERT INTO [admin] (fullname, email, passwordd, lastlogin) VALUES (?,?,?,?)", con))
                    {
                        ins.Parameters.AddWithValue("?", "Admin");
                        ins.Parameters.AddWithValue("?", "admin@haathifitness.com");
                        ins.Parameters.AddWithValue("?", Security.HashPassword("Admin@123"));
                        ins.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                        ins.ExecuteNonQuery();
                    }
                    Log(new Exception("INFO: no admin existed - created default admin admin@haathifitness.com / Admin@123 (change it after first login)." + (created ? " New database file created." : "")));
                }
            }
        }
    }

    private static bool c_isPwd(string table) { return table == "admin" || table == "member"; }

    private static bool TableExists(OleDbConnection con, string name)
    {
        using (DataTable dt = con.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[] { null, null, name, "TABLE" }))
            return dt != null && dt.Rows.Count > 0;
    }

    private static Dictionary<string, int> ColumnLengths(OleDbConnection con, string table)
    {
        Dictionary<string, int> map = new Dictionary<string, int>();
        using (DataTable dt = con.GetOleDbSchemaTable(OleDbSchemaGuid.Columns, new object[] { null, null, table, null }))
        {
            foreach (DataRow r in dt.Rows)
            {
                int len = 0;
                if (r["CHARACTER_MAXIMUM_LENGTH"] != DBNull.Value) len = Convert.ToInt32(r["CHARACTER_MAXIMUM_LENGTH"]);
                map[r["COLUMN_NAME"].ToString().ToLowerInvariant()] = len;
            }
        }
        return map;
    }

    private static void Exec(OleDbConnection con, string sql)
    {
        using (OleDbCommand cmd = new OleDbCommand(sql, con)) cmd.ExecuteNonQuery();
    }

    private static void CreateEmptyMdb(string path)
    {
        Type t = Type.GetTypeFromProgID("ADOX.Catalog");
        if (t == null) throw new Exception("ADOX.Catalog is not available, cannot create " + path + ". Copy your projectdatabase.mdb into App_Data.");
        List<string> errors = new List<string>();
        foreach (string provider in Providers)
        {
            object cat = Activator.CreateInstance(t);
            try
            {
                string cs = "Provider=" + provider + ";Data Source=" + path + ";" +
                            (provider.StartsWith("Microsoft.ACE") ? "Jet OLEDB:Engine Type=5;" : "");
                t.InvokeMember("Create", BindingFlags.InvokeMethod, null, cat, new object[] { cs });
                return;
            }
            catch (Exception ex) { errors.Add(provider + ": " + ex.Message); }
            finally { Marshal.ReleaseComObject(cat); }
        }
        throw new Exception("Could not create database file. " + string.Join(" | ", errors.ToArray()));
    }

    // --------------------------------------------------------------- logging
    public static void Log(Exception ex)
    {
        try
        {
            string dir = HostingEnvironment.MapPath("~/App_Data");
            string file = Path.Combine(dir, "error.log");
            FileInfo fi = new FileInfo(file);
            if (fi.Exists && fi.Length > 1024 * 1024) File.Delete(file);
            File.AppendAllText(file, DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss") + "  " + ex.ToString() + Environment.NewLine + Environment.NewLine);
        }
        catch { }
    }
}
