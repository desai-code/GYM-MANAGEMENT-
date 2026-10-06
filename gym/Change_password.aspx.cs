using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI;

public partial class Change_password : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // The password can only be changed for the admin who is logged in right now.
            DataTable me = Session["AdminData"] as DataTable;
            if (me != null && me.Rows.Count > 0)
            {
                txtcemail.Text = Convert.ToString(me.Rows[0]["email"]);
                txtcemail.ReadOnly = true;
            }
        }
    }

    private void Show(string text, bool ok)
    {
        lblMsg.Style.Clear();
        lblMsg.CssClass = ok ? "d-block mb-3" : "d-block mb-3 validator-text";
        if (ok) lblMsg.Style.Add("color", "var(--success)");
        lblMsg.Text = System.Web.HttpUtility.HtmlEncode(text);
    }

    protected void btnchangepassword_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        DataTable me = Session["AdminData"] as DataTable;
        if (me == null || me.Rows.Count == 0) { Response.Redirect("~/login.aspx"); return; }

        if (txtnpassword.Text.Length < 6) { Show("Password must be at least 6 characters.", false); return; }

        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd = new OleDbCommand("UPDATE [admin] SET passwordd = ? WHERE id = ?", con);
                cmd.Parameters.AddWithValue("?", Security.HashPassword(txtnpassword.Text));
                cmd.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(me.Rows[0]["id"]);
                if (cmd.ExecuteNonQuery() == 0) { Show("Admin account not found.", false); return; }
            }
            txtnpassword.Text = "";
            txtccpassword.Text = "";
            Show("Password updated successfully.", true);
        }
        catch (Exception ex)
        {
            DbHelper.Log(ex);
            Show("Could not update the password. Please try again.", false);
        }
    }
}
