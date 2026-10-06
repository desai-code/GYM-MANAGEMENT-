using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI.WebControls;

public partial class Add_membership_plan : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack) FillGridView();
    }

    private void ResetForm()
    {
        txtplanname.Text = "";
        txtplanduration.Text = "";
        txtplanprice.Text = "";
        HiddenField1.Value = "";
        btnaddplan.Text = "Add Plan";
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                if (btnaddplan.Text == "Add Plan")
                {
                    OleDbCommand cmd = new OleDbCommand("INSERT INTO [membership] (planname, membershipduration, price) VALUES (?,?,?)", con);
                    cmd.Parameters.AddWithValue("?", txtplanname.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtplanduration.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtplanprice.Text.Trim());
                    cmd.ExecuteNonQuery();
                    UiHelper.Ok(this, "Plan saved.");
                }
                else
                {
                    int id;
                    if (!int.TryParse(HiddenField1.Value, out id)) { ResetForm(); return; }

                    OleDbCommand cmd = new OleDbCommand("UPDATE [membership] SET planname = ?, membershipduration = ?, price = ? WHERE id = ?", con);
                    cmd.Parameters.AddWithValue("?", txtplanname.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtplanduration.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtplanprice.Text.Trim());
                    cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                    cmd.ExecuteNonQuery();
                    UiHelper.Ok(this, "Plan updated.");
                }
            }
            ResetForm();
            FillGridView();
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }

    public void FillGridView()
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                DataTable dt = new DataTable();
                new OleDbDataAdapter("SELECT id, planname, membershipduration, price FROM [membership] ORDER BY id", con).Fill(dt);
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
        FillGridView();
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        UiHelper.ConfirmDelete(e);
    }

    protected void GridView1_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        GridViewRow row = GridView1.Rows[e.NewSelectedIndex];
        HiddenField1.Value = ((Label)row.FindControl("lblid")).Text;
        txtplanname.Text = ((Label)row.FindControl("lblplanname")).Text;
        txtplanduration.Text = ((Label)row.FindControl("lblmembershipduration")).Text;
        txtplanprice.Text = ((Label)row.FindControl("lblprice")).Text;
        btnaddplan.Text = "Update";
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int id = Convert.ToInt32(((Label)GridView1.Rows[e.RowIndex].FindControl("lblid")).Text);
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd = new OleDbCommand("DELETE FROM [membership] WHERE id = ?", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                cmd.ExecuteNonQuery();
            }
            UiHelper.Ok(this, "Plan deleted.");
            FillGridView();
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }
}
