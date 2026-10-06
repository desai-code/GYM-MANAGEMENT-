using System;
using System.Data;
using System.IO;
using System.Web;
using System.Web.UI;

public partial class SiteMaster : System.Web.UI.MasterPage
{
    // Runs before the content page loads: every admin page uses this master, so every admin page is protected.
    protected void Page_Init(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetNoStore();

        if (Session["AdminData"] == null)
        {
            // Customers opening the bare site address land on the client site, admins go to the login screen.
            string page = Path.GetFileName(Request.Path);
            if (string.Equals(page, "Default.aspx", StringComparison.OrdinalIgnoreCase))
                Response.Redirect("~/client/index.aspx", true);
            else
                Response.Redirect("~/login.aspx", true);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        DataTable admin = Session["AdminData"] as DataTable;
        if (admin != null && admin.Rows.Count > 0)
            lblAdminName.Text = HttpUtility.HtmlEncode(Convert.ToString(admin.Rows[0]["fullname"]));
    }

    protected void lnkLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("~/login.aspx");
    }
}
