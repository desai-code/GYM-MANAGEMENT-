using System;
using System.Data;
using System.Data.OleDb;
using System.Text;
using System.Web.UI.WebControls;

public partial class Add_program : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            FillTrainerDropdown();
            FillGridView();
        }
    }

    private void FillTrainerDropdown()
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                DataTable dt = new DataTable();
                new OleDbDataAdapter("SELECT id, trainername FROM [trainer] ORDER BY trainername", con).Fill(dt);
                ddlTrainer.DataSource = dt;
                ddlTrainer.DataTextField = "trainername";
                ddlTrainer.DataValueField = "id";
                ddlTrainer.DataBind();
            }
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
                new OleDbDataAdapter(
                    "SELECT program.id, programname, description, icon, trainername " +
                    "FROM [program] LEFT JOIN [trainer] ON program.trainerid = trainer.id ORDER BY program.id", con).Fill(dt);
                if (GridView1.PageIndex > 0 && GridView1.PageIndex * GridView1.PageSize >= dt.Rows.Count) GridView1.PageIndex = 0;
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }

    private void ResetForm()
    {
        txtprogramname.Text = "";
        txticon.Text = "";
        txtschedule.Text = "";
        txtdescription.Text = "";
        HiddenField1.Value = "";
        btnaddprogram.Text = "Add Program";
    }

    /// <summary>
    /// "Monday:06:00 AM,08:00 AM | Wednesday:06:00 PM"  ->  one row per slot in [programslot].
    /// The day is everything before the FIRST colon (times themselves contain colons).
    /// </summary>
    private int SaveSlots(OleDbConnection con, OleDbTransaction tx, int programId, string scheduleText)
    {
        OleDbCommand del = new OleDbCommand("DELETE FROM [programslot] WHERE programid = ?", con, tx);
        del.Parameters.Add("?", OleDbType.Integer).Value = programId;
        del.ExecuteNonQuery();

        if (string.IsNullOrWhiteSpace(scheduleText)) return 0;

        int saved = 0;
        foreach (string dayBlock in scheduleText.Split('|'))
        {
            int colon = dayBlock.IndexOf(':');
            if (colon <= 0) continue;

            string day = dayBlock.Substring(0, colon).Trim();
            if (day == "") continue;

            foreach (string slot in dayBlock.Substring(colon + 1).Split(','))
            {
                string s = slot.Trim();
                if (s == "") continue;

                OleDbCommand ins = new OleDbCommand("INSERT INTO [programslot] (programid, dayname, slottime) VALUES (?,?,?)", con, tx);
                ins.Parameters.Add("?", OleDbType.Integer).Value = programId;
                ins.Parameters.AddWithValue("?", day);
                ins.Parameters.AddWithValue("?", s);
                ins.ExecuteNonQuery();
                saved++;
            }
        }
        if (saved == 0)
            throw new ApplicationException("Schedule format not understood. Example: Monday:06:00 AM,08:00 AM | Wednesday:06:00 PM");
        return saved;
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (!Page.IsValid) return;

        int trainerId;
        if (!int.TryParse(ddlTrainer.SelectedValue, out trainerId))
        {
            UiHelper.Msg(this, "Please add a trainer first (Trainer Info page), then assign it to the program.", true);
            return;
        }

        string icon = string.IsNullOrWhiteSpace(txticon.Text) ? "bi-activity" : txticon.Text.Trim();

        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            using (OleDbTransaction tx = con.BeginTransaction())
            {
                try
                {
                    int programId;
                    if (btnaddprogram.Text == "Add Program")
                    {
                        OleDbCommand cmd = new OleDbCommand("INSERT INTO [program] (programname, description, icon, trainerid) VALUES (?,?,?,?)", con, tx);
                        cmd.Parameters.AddWithValue("?", txtprogramname.Text.Trim());
                        cmd.Parameters.AddWithValue("?", txtdescription.Text.Trim());
                        cmd.Parameters.AddWithValue("?", icon);
                        cmd.Parameters.Add("?", OleDbType.Integer).Value = trainerId;
                        cmd.ExecuteNonQuery();

                        programId = Convert.ToInt32(new OleDbCommand("SELECT @@IDENTITY", con, tx).ExecuteScalar());
                    }
                    else
                    {
                        if (!int.TryParse(HiddenField1.Value, out programId)) { ResetForm(); return; }

                        OleDbCommand cmd = new OleDbCommand("UPDATE [program] SET programname = ?, description = ?, icon = ?, trainerid = ? WHERE id = ?", con, tx);
                        cmd.Parameters.AddWithValue("?", txtprogramname.Text.Trim());
                        cmd.Parameters.AddWithValue("?", txtdescription.Text.Trim());
                        cmd.Parameters.AddWithValue("?", icon);
                        cmd.Parameters.Add("?", OleDbType.Integer).Value = trainerId;
                        cmd.Parameters.Add("?", OleDbType.Integer).Value = programId;
                        cmd.ExecuteNonQuery();
                    }

                    SaveSlots(con, tx, programId, txtschedule.Text.Trim());
                    tx.Commit();
                }
                catch
                {
                    tx.Rollback();
                    throw;
                }
            }

            UiHelper.Ok(this, btnaddprogram.Text == "Add Program" ? "Program saved." : "Program updated.");
            ResetForm();
            FillGridView();
        }
        catch (ApplicationException ex) { UiHelper.Msg(this, ex.Message, true); }
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
        int id = Convert.ToInt32(((Label)row.FindControl("lblid")).Text);

        HiddenField1.Value = id.ToString();
        txtprogramname.Text = ((Label)row.FindControl("lblprogramname")).Text;
        txtdescription.Text = ((Label)row.FindControl("lbldescription")).Text;
        txticon.Text = ((Label)row.FindControl("lblicon")).Text;

        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                // keep the assigned trainer (otherwise saving silently switched it to the first trainer in the list)
                OleDbCommand tcmd = new OleDbCommand("SELECT trainerid FROM [program] WHERE id = ?", con);
                tcmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                object tid = tcmd.ExecuteScalar();
                if (tid != null && tid != DBNull.Value)
                {
                    ListItem li = ddlTrainer.Items.FindByValue(Convert.ToString(tid));
                    if (li != null) ddlTrainer.SelectedValue = li.Value;
                }

                OleDbCommand cmd = new OleDbCommand("SELECT dayname, slottime FROM [programslot] WHERE programid = ? ORDER BY id", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                DataTable dt = new DataTable();
                new OleDbDataAdapter(cmd).Fill(dt);

                // group the times per day: "Monday:06:00 AM,08:00 AM | Wednesday:06:00 PM"
                StringBuilder sb = new StringBuilder();
                string lastDay = null;
                foreach (DataRow r in dt.Rows)
                {
                    string day = Convert.ToString(r["dayname"]);
                    if (day != lastDay)
                    {
                        if (sb.Length > 0) sb.Append(" | ");
                        sb.Append(day).Append(":").Append(r["slottime"]);
                        lastDay = day;
                    }
                    else sb.Append(",").Append(r["slottime"]);
                }
                txtschedule.Text = sb.ToString();
            }
        }
        catch (Exception ex) { DbHelper.Log(ex); }

        btnaddprogram.Text = "Update";
    }

    protected void GridView1_RowDeleting(object sender, GridViewDeleteEventArgs e)
    {
        try
        {
            int id = Convert.ToInt32(((Label)GridView1.Rows[e.RowIndex].FindControl("lblid")).Text);
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand delSlots = new OleDbCommand("DELETE FROM [programslot] WHERE programid = ?", con);
                delSlots.Parameters.Add("?", OleDbType.Integer).Value = id;
                delSlots.ExecuteNonQuery();

                OleDbCommand cmd = new OleDbCommand("DELETE FROM [program] WHERE id = ?", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = id;
                cmd.ExecuteNonQuery();
            }
            UiHelper.Ok(this, "Program deleted.");
            FillGridView();
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }
}
