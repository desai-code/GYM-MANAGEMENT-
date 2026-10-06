using System;
using System.Data.OleDb;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                Label3.Text = Count(con, "admin");
                Label4.Text = Count(con, "member");
                Label7.Text = Count(con, "membership");
                Label8.Text = Count(con, "trainer");
            }
        }
        catch (Exception ex)
        {
            DbHelper.Log(ex);
            UiHelper.Msg(this, "Could not load the dashboard numbers.", true);
        }
    }

    private static string Count(OleDbConnection con, string table)
    {
        using (OleDbCommand cmd = new OleDbCommand("SELECT COUNT(*) FROM [" + table + "]", con))
            return Convert.ToString(cmd.ExecuteScalar());
    }
}
