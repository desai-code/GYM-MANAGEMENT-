using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;

public partial class login : System.Web.UI.Page
{
    private const string Area = "admin";

    protected void Page_Load(object sender, EventArgs e)
    {
        // Already signed in -> straight to the dashboard
        if (!IsPostBack && Session["AdminData"] != null) Response.Redirect("~/Default.aspx");
    }

    private void ShowError(string text)
    {
        lblError.Text = System.Web.HttpUtility.HtmlEncode(text);
        lblError.Visible = true;
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        if (LoginThrottle.IsBlocked(Area))
        {
            ShowError("Too many failed attempts. Please wait 10 minutes and try again.");
            return;
        }

        try
        {
            string email = txtUsername.Text.Trim();
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd = new OleDbCommand("SELECT id, fullname, email, passwordd FROM [admin] WHERE email = ?", con);
                cmd.Parameters.AddWithValue("?", email);
                DataTable dt = new DataTable();
                new OleDbDataAdapter(cmd).Fill(dt);

                bool ok = false, upgrade = false;
                if (dt.Rows.Count > 0)
                    ok = Security.Verify(txtPassword.Text, Convert.ToString(dt.Rows[0]["passwordd"]), out upgrade);

                if (!ok)
                {
                    LoginThrottle.Fail(Area);
                    ShowError("Invalid email or password.");
                    return;
                }

                int id = Convert.ToInt32(dt.Rows[0]["id"]);

                // old plain-text password -> store it hashed from now on; also record the login time
                OleDbCommand upd = upgrade
                    ? new OleDbCommand("UPDATE [admin] SET lastlogin = ?, passwordd = ? WHERE id = ?", con)
                    : new OleDbCommand("UPDATE [admin] SET lastlogin = ? WHERE id = ?", con);
                upd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                if (upgrade) upd.Parameters.AddWithValue("?", Security.HashPassword(txtPassword.Text));
                upd.Parameters.Add("?", OleDbType.Integer).Value = id;
                upd.ExecuteNonQuery();

                // keep only non-secret data in the session
                DataTable me = new DataTable();
                me.Columns.Add("id", typeof(int));
                me.Columns.Add("fullname", typeof(string));
                me.Columns.Add("email", typeof(string));
                me.Rows.Add(id, Convert.ToString(dt.Rows[0]["fullname"]), Convert.ToString(dt.Rows[0]["email"]));

                LoginThrottle.Reset(Area);
                Session["AdminData"] = me;
            }
            Response.Redirect("~/Default.aspx", false);
            Context.ApplicationInstance.CompleteRequest();
        }
        catch (Exception ex)
        {
            DbHelper.Log(ex);
            ShowError(Request.IsLocal ? "Login failed: " + ex.Message : "Login is temporarily unavailable. Please try again.");
        }
    }
}
