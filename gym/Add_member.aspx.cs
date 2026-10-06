using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI.WebControls;

public partial class Add_member : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack) FillGridveiw();
    }

    private string SearchTerm
    {
        get { return (Request.QueryString["q"] ?? "").Trim(); }
    }

    private void ResetForm()
    {
        txtmemname.Text = "";
        txtmememail.Text = "";
        txtmemdob.Text = "";
        txtmemmobile.Text = "";
        ddlmemgender.SelectedIndex = 0;
        txtmemaddress.Text = "";
        txtmemjoindate.Text = "";
        txtmemheight.Text = "";
        txtmemweight.Text = "";
        txtmempassword.Text = "";
        HiddenField1.Value = "";
        btnaddmember.Text = "Add Member";
        RequiredFieldValidatorPwd.Enabled = true;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;
        string email = txtmememail.Text.Trim();

        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                if (btnaddmember.Text == "Add Member")
                {
                    if (txtmempassword.Text.Length < 6) { UiHelper.Msg(this, "Password must be at least 6 characters.", true); return; }

                    OleDbCommand dup = new OleDbCommand("SELECT COUNT(*) FROM [member] WHERE email = ?", con);
                    dup.Parameters.AddWithValue("?", email);
                    if (Convert.ToInt32(dup.ExecuteScalar()) > 0) { UiHelper.Msg(this, "A member with this email already exists.", true); return; }

                    OleDbCommand cmd = new OleDbCommand(
                        "INSERT INTO [member] (fullname, email, passwordd, dateofbirth, mobileno, gender, address, joindate, height, weight, lastlogin) " +
                        "VALUES (?,?,?,?,?,?,?,?,?,?,?)", con);
                    cmd.Parameters.AddWithValue("?", txtmemname.Text.Trim());
                    cmd.Parameters.AddWithValue("?", email);
                    cmd.Parameters.AddWithValue("?", Security.HashPassword(txtmempassword.Text));
                    cmd.Parameters.AddWithValue("?", txtmemdob.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtmemmobile.Text.Trim());
                    cmd.Parameters.AddWithValue("?", ddlmemgender.SelectedValue);
                    cmd.Parameters.AddWithValue("?", txtmemaddress.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtmemjoindate.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtmemheight.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtmemweight.Text.Trim());
                    cmd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                    cmd.ExecuteNonQuery();
                    UiHelper.Ok(this, "Member saved.");
                }
                else
                {
                    int id;
                    if (!int.TryParse(HiddenField1.Value, out id)) { ResetForm(); return; }

                    OleDbCommand dup = new OleDbCommand("SELECT COUNT(*) FROM [member] WHERE email = ? AND id <> ?", con);
                    dup.Parameters.AddWithValue("?", email);
                    dup.Parameters.Add("?", OleDbType.Integer).Value = id;
                    if (Convert.ToInt32(dup.ExecuteScalar()) > 0) { UiHelper.Msg(this, "Another member already uses this email.", true); return; }

                    bool newPass = txtmempassword.Text != "";
                    if (newPass && txtmempassword.Text.Length < 6) { UiHelper.Msg(this, "Password must be at least 6 characters.", true); return; }

                    OleDbCommand cmd = new OleDbCommand(
                        "UPDATE [member] SET fullname = ?, email = ?, dateofbirth = ?, mobileno = ?, gender = ?, address = ?, joindate = ?, height = ?, weight = ?" +
                        (newPass ? ", passwordd = ?" : "") + " WHERE id = ?", con);
                    cmd.Parameters.AddWithValue("?", txtmemname.Text.Trim());
                    cmd.Parameters.AddWithValue("?", email);
                    cmd.Parameters.AddWithValue("?", txtmemdob.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtmemmobile.Text.Trim());
                    cmd.Parameters.AddWithValue("?", ddlmemgender.SelectedValue);
                    cmd.Parameters.AddWithValue("?", txtmemaddress.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtmemjoindate.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtmemheight.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtmemweight.Text.Trim());
                    if (newPass) cmd.Parameters.AddWithValue("?", Security.HashPassword(txtmempassword.Text));
                    cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                    cmd.ExecuteNonQuery();
                    UiHelper.Ok(this, "Member updated.");
                }
            }
            ResetForm();
            FillGridveiw();
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }

    public void FillGridveiw()
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd;
                string q = SearchTerm;
                string cols = "SELECT id, fullname, email, dateofbirth, mobileno, gender, joindate, height, weight, address, lastlogin, planname FROM [member]";
                if (q.Length > 0)
                {
                    cmd = new OleDbCommand(cols + " WHERE fullname LIKE ? OR email LIKE ? OR mobileno LIKE ? ORDER BY id DESC", con);
                    string like = "%" + q + "%";
                    cmd.Parameters.AddWithValue("?", like);
                    cmd.Parameters.AddWithValue("?", like);
                    cmd.Parameters.AddWithValue("?", like);
                    lblSearchInfo.Text = "Search: \"" + System.Web.HttpUtility.HtmlEncode(q) + "\"";
                }
                else
                {
                    cmd = new OleDbCommand(cols + " ORDER BY id DESC", con);
                    lblSearchInfo.Text = "";
                }

                DataTable dt = new DataTable();
                new OleDbDataAdapter(cmd).Fill(dt);
                if (GridView1.PageIndex > 0 && GridView1.PageIndex * GridView1.PageSize >= dt.Rows.Count) GridView1.PageIndex = 0;
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }

    protected void GridView1_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        GridView1.PageIndex = e.NewPageIndex;
        FillGridveiw();
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        UiHelper.ConfirmDelete(e);
    }

    protected void GridView1_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        GridViewRow row = GridView1.Rows[e.NewSelectedIndex];
        HiddenField1.Value = ((Label)row.FindControl("lblid")).Text;
        txtmemname.Text = ((Label)row.FindControl("lblfullname")).Text;
        txtmememail.Text = ((Label)row.FindControl("lblemail")).Text;
        txtmemmobile.Text = ((Label)row.FindControl("lblmobileno")).Text;
        string g = ((Label)row.FindControl("lblgender")).Text;
        ddlmemgender.SelectedIndex = ddlmemgender.Items.IndexOf(ddlmemgender.Items.FindByText(g)) >= 0
            ? ddlmemgender.Items.IndexOf(ddlmemgender.Items.FindByText(g)) : 0;
        txtmemdob.Text = ((Label)row.FindControl("lbldateofbirth")).Text;
        txtmemjoindate.Text = ((Label)row.FindControl("lbljoindate")).Text;
        txtmemheight.Text = ((Label)row.FindControl("lblheight")).Text;
        txtmemweight.Text = ((Label)row.FindControl("lblweight")).Text;
        txtmemaddress.Text = ((Label)row.FindControl("lbladdress")).Text;
        txtmempassword.Text = "";

        btnaddmember.Text = "Update";
        // empty password on update = keep the member's current password
        RequiredFieldValidatorPwd.Enabled = false;
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int id = Convert.ToInt32(((Label)GridView1.Rows[e.RowIndex].FindControl("lblid")).Text);
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd = new OleDbCommand("DELETE FROM [member] WHERE id = ?", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                cmd.ExecuteNonQuery();
            }
            UiHelper.Ok(this, "Member deleted.");
            FillGridveiw();
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }
}
