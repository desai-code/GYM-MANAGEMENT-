using System;
using System.Data;
using System.Data.OleDb;
using System.IO;
using System.Web.UI.WebControls;

public partial class Add_trainer_Info : System.Web.UI.Page
{
    private static readonly string[] AllowedExt = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };
    private const int MaxPhotoBytes = 2 * 1024 * 1024;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack) FillGRidView();
    }

    // used by the grid markup: ImageUrl='<%# PhotoUrl(Eval("photo")) %>'
    protected string PhotoUrl(object photo)
    {
        string p = Convert.ToString(photo);
        if (string.IsNullOrEmpty(p))
            return "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='40' height='40'><rect width='40' height='40' fill='%23ddd'/></svg>";
        return "~/Image1/" + p;
    }

    private void ResetForm()
    {
        txttrainername.Text = "";
        txttrainerspecialization.Text = "";
        txttrainerphone.Text = "";
        txtsalary.Text = "";
        txtexperirence.Text = "";
        HiddenField1.Value = "";
        Image1.Visible = false;
        Image1.ImageUrl = "";
        btnaddtrainer.Text = "Add Trainer";
    }

    /// <summary>Validates + saves the uploaded photo with a safe random name. Returns the file name, or null if none uploaded.</summary>
    private string SavePhoto()
    {
        if (!fuphoto.HasFile) return null;

        string ext = Path.GetExtension(fuphoto.FileName).ToLowerInvariant();
        if (Array.IndexOf(AllowedExt, ext) < 0)
            throw new ApplicationException("Only JPG, PNG, GIF or WEBP photos are allowed.");
        if (fuphoto.PostedFile.ContentLength > MaxPhotoBytes)
            throw new ApplicationException("Photo is too large (maximum 2 MB).");

        string name = Guid.NewGuid().ToString("N") + ext;
        string folder = Server.MapPath("~/Image1");
        if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
        fuphoto.SaveAs(Path.Combine(folder, name));
        return name;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        try
        {
            string photo = SavePhoto();

            using (OleDbConnection con = DbHelper.GetConnection())
            {
                if (btnaddtrainer.Text == "Add Trainer")
                {
                    OleDbCommand cmd = new OleDbCommand(
                        "INSERT INTO [trainer] (trainername, specialization, phoneno, salary, exprerience, photo) VALUES (?,?,?,?,?,?)", con);
                    cmd.Parameters.AddWithValue("?", txttrainername.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txttrainerspecialization.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txttrainerphone.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtsalary.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtexperirence.Text.Trim());
                    cmd.Parameters.AddWithValue("?", photo ?? "");
                    cmd.ExecuteNonQuery();
                    UiHelper.Ok(this, "Trainer saved.");
                }
                else
                {
                    int id;
                    if (!int.TryParse(HiddenField1.Value, out id)) { ResetForm(); return; }

                    OleDbCommand cmd = new OleDbCommand(
                        "UPDATE [trainer] SET trainername = ?, specialization = ?, phoneno = ?, salary = ?, exprerience = ?" +
                        (photo != null ? ", photo = ?" : "") + " WHERE id = ?", con);
                    cmd.Parameters.AddWithValue("?", txttrainername.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txttrainerspecialization.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txttrainerphone.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtsalary.Text.Trim());
                    cmd.Parameters.AddWithValue("?", txtexperirence.Text.Trim());
                    if (photo != null) cmd.Parameters.AddWithValue("?", photo);
                    cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                    cmd.ExecuteNonQuery();
                    UiHelper.Ok(this, "Trainer updated.");
                }
            }
            ResetForm();
            FillGRidView();
        }
        catch (ApplicationException ex) { UiHelper.Msg(this, ex.Message, true); }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }

    public void FillGRidView()
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                DataTable dt = new DataTable();
                new OleDbDataAdapter("SELECT id, trainername, specialization, phoneno, salary, exprerience, photo FROM [trainer] ORDER BY id", con).Fill(dt);
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
        FillGRidView();
    }

    protected void GridView1_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        UiHelper.ConfirmDelete(e);
    }

    protected void GridView1_SelectedIndexChanging(object sender, GridViewSelectEventArgs e)
    {
        GridViewRow row = GridView1.Rows[e.NewSelectedIndex];
        HiddenField1.Value = ((Label)row.FindControl("lblid")).Text;
        txttrainername.Text = ((Label)row.FindControl("lbltrainername")).Text;
        txttrainerspecialization.Text = ((Label)row.FindControl("lblspecialization")).Text;
        txttrainerphone.Text = ((Label)row.FindControl("lblphoneno")).Text;
        txtsalary.Text = ((Label)row.FindControl("lblsalary")).Text;
        txtexperirence.Text = ((Label)row.FindControl("lblexprerience")).Text;

        // current photo preview (read the real file name from the database)
        Image1.Visible = false;
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd = new OleDbCommand("SELECT photo FROM [trainer] WHERE id = ?", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(HiddenField1.Value);
                string photo = Convert.ToString(cmd.ExecuteScalar());
                if (!string.IsNullOrEmpty(photo))
                {
                    Image1.ImageUrl = "~/Image1/" + photo;
                    Image1.Visible = true;
                }
            }
        }
        catch (Exception ex) { DbHelper.Log(ex); }

        btnaddtrainer.Text = "Update";
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int id = Convert.ToInt32(((Label)GridView1.Rows[e.RowIndex].FindControl("lblid")).Text);
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd = new OleDbCommand("DELETE FROM [trainer] WHERE id = ?", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                cmd.ExecuteNonQuery();
            }
            UiHelper.Ok(this, "Trainer deleted. Programs that used this trainer now show \"TBA\" until you assign another trainer.");
            FillGRidView();
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }
}
