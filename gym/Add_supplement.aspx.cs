using System;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.Web.UI.WebControls;

public partial class Add_supplement : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack) FillGridView();
    }

    public void FillGridView()
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                // "name" and "size" are reserved words in Access -> bracketed
                DataTable dt = new DataTable();
                new OleDbDataAdapter("SELECT id, [name], description, price, [size], imageurl FROM [supplement] ORDER BY id", con).Fill(dt);
                if (GridView1.PageIndex > 0 && GridView1.PageIndex * GridView1.PageSize >= dt.Rows.Count) GridView1.PageIndex = 0;
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }

    private void ClearForm()
    {
        txtname.Text = "";
        txtdescription.Text = "";
        txtprice.Text = "";
        txtsize.Text = "";
        txtimageurl.Text = "";
        HiddenField1.Value = "";
        btnaddsupplement.Text = "Add Supplement";
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        decimal price;
        if (!decimal.TryParse(txtprice.Text.Trim(), NumberStyles.Number, CultureInfo.InvariantCulture, out price) || price < 0)
        {
            UiHelper.Msg(this, "Please enter a valid numeric price (for example 1499 or 1499.50).", true);
            return;
        }

        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                if (btnaddsupplement.Text == "Add Supplement")
                {
                    OleDbCommand cmd = new OleDbCommand(
                        "INSERT INTO [supplement] ([name], description, price, [size], imageurl) VALUES (?,?,?,?,?)", con);
                    cmd.Parameters.AddWithValue("?", txtname.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtdescription.Text.Trim());
                    cmd.Parameters.Add("?", OleDbType.Currency).Value = price;
                    cmd.Parameters.AddWithValue("?", txtsize.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtimageurl.Text.Trim());
                    cmd.ExecuteNonQuery();
                    UiHelper.Ok(this, "Supplement saved.");
                }
                else
                {
                    int id;
                    if (!int.TryParse(HiddenField1.Value, out id)) { ClearForm(); return; }

                    OleDbCommand cmd = new OleDbCommand(
                        "UPDATE [supplement] SET [name] = ?, description = ?, price = ?, [size] = ?, imageurl = ? WHERE id = ?", con);
                    cmd.Parameters.AddWithValue("?", txtname.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtdescription.Text.Trim());
                    cmd.Parameters.Add("?", OleDbType.Currency).Value = price;
                    cmd.Parameters.AddWithValue("?", txtsize.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtimageurl.Text.Trim());
                    cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                    cmd.ExecuteNonQuery();
                    UiHelper.Ok(this, "Supplement updated.");
                }
            }
            ClearForm();
            FillGridView();
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
        txtname.Text = ((Label)row.FindControl("lblname")).Text;
        txtdescription.Text = ((Label)row.FindControl("lbldescription")).Text;
        // price label shows the DB currency value; strip any currency symbol / grouping so it can be re-saved
        string rawPrice = ((Label)row.FindControl("lblprice")).Text;
        decimal p;
        txtprice.Text = decimal.TryParse(rawPrice, NumberStyles.Currency, CultureInfo.CurrentCulture, out p)
            ? p.ToString("0.##", CultureInfo.InvariantCulture) : rawPrice;
        txtsize.Text = ((Label)row.FindControl("lblsize")).Text;
        txtimageurl.Text = ((Label)row.FindControl("lblimageurl")).Text;
        btnaddsupplement.Text = "Update";
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int id = Convert.ToInt32(((Label)GridView1.Rows[e.RowIndex].FindControl("lblid")).Text);
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd = new OleDbCommand("DELETE FROM [supplement] WHERE id = ?", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                cmd.ExecuteNonQuery();
            }
            UiHelper.Ok(this, "Supplement deleted.");
            FillGridView();
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }
}
