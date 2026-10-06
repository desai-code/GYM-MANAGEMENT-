using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI.WebControls;

public partial class Add_admin : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack) FillGridview();
    }

    private int CurrentAdminId()
    {
        DataTable me = Session["AdminData"] as DataTable;
        return (me != null && me.Rows.Count > 0) ? Convert.ToInt32(me.Rows[0]["id"]) : -1;
    }

    private void ResetForm()
    {
        txtfullname.Text = "";
        txtemail.Text = "";
        txtpassword.Text = "";
        txtchangepass.Text = "";
        HiddenField1.Value = "";
        btnaddadmin.Text = "Add Admin";
        RequiredFieldValidator3.Enabled = true;
        RequiredFieldValidator4.Enabled = true;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        string name = txtfullname.Text.Trim();
        string email = txtemail.Text.Trim();

        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                if (btnaddadmin.Text == "Add Admin")
                {
                    if (txtpassword.Text.Length < 6) { UiHelper.Msg(this, "Password must be at least 6 characters.", true); return; }

                    OleDbCommand dup = new OleDbCommand("SELECT COUNT(*) FROM [admin] WHERE email = ?", con);
                    dup.Parameters.AddWithValue("?", email);
                    if (Convert.ToInt32(dup.ExecuteScalar()) > 0) { UiHelper.Msg(this, "An admin with this email already exists.", true); return; }

                    OleDbCommand cmd = new OleDbCommand("INSERT INTO [admin] (fullname, email, passwordd, lastlogin) VALUES (?,?,?,?)", con);
                    cmd.Parameters.AddWithValue("?", name);
                    cmd.Parameters.AddWithValue("?", email);
                    cmd.Parameters.AddWithValue("?", Security.HashPassword(txtpassword.Text));
                    cmd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                    cmd.ExecuteNonQuery();

                    UiHelper.Ok(this, "Admin saved.");
                }
                else
                {
                    int id;
                    if (!int.TryParse(HiddenField1.Value, out id)) { ResetForm(); return; }

                    OleDbCommand dup = new OleDbCommand("SELECT COUNT(*) FROM [admin] WHERE email = ? AND id <> ?", con);
                    dup.Parameters.AddWithValue("?", email);
                    dup.Parameters.Add("?", OleDbType.Integer).Value = id;
                    if (Convert.ToInt32(dup.ExecuteScalar()) > 0) { UiHelper.Msg(this, "Another admin already uses this email.", true); return; }

                    bool newPass = txtpassword.Text != "";
                    if (newPass && txtpassword.Text.Length < 6) { UiHelper.Msg(this, "Password must be at least 6 characters.", true); return; }

                    OleDbCommand cmd = new OleDbCommand(newPass
                        ? "UPDATE [admin] SET fullname = ?, email = ?, passwordd = ? WHERE id = ?"
                        : "UPDATE [admin] SET fullname = ?, email = ? WHERE id = ?", con);
                    cmd.Parameters.AddWithValue("?", name);
                    cmd.Parameters.AddWithValue("?", email);
                    if (newPass) cmd.Parameters.AddWithValue("?", Security.HashPassword(txtpassword.Text));
                    cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                    cmd.ExecuteNonQuery();

                    // editing yourself: keep the logged-in session in sync
                    DataTable me = Session["AdminData"] as DataTable;
                    if (me != null && me.Rows.Count > 0 && Convert.ToInt32(me.Rows[0]["id"]) == id)
                    {
                        me.Rows[0]["fullname"] = name;
                        me.Rows[0]["email"] = email;
                    }
                    UiHelper.Ok(this, "Admin updated.");
                }
            }
            ResetForm();
            FillGridview();
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }

    public void FillGridview()
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                DataTable dt = new DataTable();
                new OleDbDataAdapter("SELECT id, fullname, email, lastlogin FROM [admin] ORDER BY id", con).Fill(dt);
                if (GridView1.PageIndex > 0 && GridView1.PageIndex * GridView1.PageSize >= dt.Rows.Count) GridView1.PageIndex = 0;
                GridView1.DataSource = dt;
                GridView1.DataBind();
                Label10.Text = dt.Rows.Count.ToString();
            }
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        FillGridview();
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        UiHelper.ConfirmDelete(e);
    }

    protected void GridView1_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        GridViewRow row = GridView1.Rows[e.NewSelectedIndex];
        HiddenField1.Value = ((Label)row.FindControl("lblid")).Text;
        txtfullname.Text = ((Label)row.FindControl("lblfullname")).Text;
        txtemail.Text = ((Label)row.FindControl("lblemail")).Text;
        txtpassword.Text = "";
        txtchangepass.Text = "";
        btnaddadmin.Text = "Update";
        // leaving the password empty on update = keep the old password
        RequiredFieldValidator3.Enabled = false;
        RequiredFieldValidator4.Enabled = false;
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int id = Convert.ToInt32(((Label)GridView1.Rows[e.RowIndex].FindControl("lblid")).Text);

            if (id == CurrentAdminId())
            {
                UiHelper.Msg(this, "You cannot delete the account you are logged in with.", true);
                return;
            }

            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cnt = new OleDbCommand("SELECT COUNT(*) FROM [admin]", con);
                if (Convert.ToInt32(cnt.ExecuteScalar()) <= 1)
                {
                    UiHelper.Msg(this, "At least one admin must remain.", true);
                    return;
                }

                OleDbCommand cmd = new OleDbCommand("DELETE FROM [admin] WHERE id = ?", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                cmd.ExecuteNonQuery();
            }
            UiHelper.Ok(this, "Admin deleted.");
            FillGridview();
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }
}
