using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// Client-side page for Haathi Fitness.
/// Binds live data from the same MS Access database used by the admin side
/// (projectdatabase.mdb) and adds member Login / Register / My Account /
/// Choose Membership Plan / Book Program Sessions / Buy Supplements.
/// </summary>
public partial class clieent_index : System.Web.UI.Page
{
    // NOTE: keep this identical to the connection string used on the admin pages
    // so both sides read/write the same .mdb file.
    // Jet.OLEDB.4.0 ships built into Windows (32-bit only) — no separate
    // "Access Database Engine" download/install needed. It just requires
    // the app pool / IIS Express to run in 32-bit mode. See README.
    private string ConnStr
    {
        get { return "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + Server.MapPath("~/App_Data/projectdatabase.mdb"); }
    }

    protected bool IsLoggedIn
    {
        get { return Session["MemberId"] != null; }
    }

    protected string MemberName
    {
        get { return Session["MemberName"] as string ?? ""; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                using (OleDbConnection con = new OleDbConnection(ConnStr))
                {
                    con.Open();
                    BindTrainers(con);
                    BindPlans(con);
                    BindPrograms(con);
                    BindSupplements(con);
                    if (IsLoggedIn)
                    {
                        BindAccount(con);
                    }
                }
            }
            catch (Exception ex)
            {
                lblGlobalMsg.Text = "Could not load page data: " + ex.Message;
            }
        }
    }

    // =========================================================
    //  TRAINERS  (admin side: Add_trainer_Info.aspx -> table "trainer")
    // =========================================================
    private void BindTrainers(OleDbConnection con)
    {
        try
        {
            OleDbDataAdapter da = new OleDbDataAdapter(
                "SELECT trainername, specialization, exprerience, photo FROM trainer", con);
            DataTable dt = new DataTable();
            da.Fill(dt);

            dt.Columns.Add("TrainerName", typeof(string));
            dt.Columns.Add("Specialization", typeof(string));
            dt.Columns.Add("ExperienceYears", typeof(string));
            dt.Columns.Add("PhotoUrl", typeof(string));

            foreach (DataRow row in dt.Rows)
            {
                row["TrainerName"] = row["trainername"] == DBNull.Value ? "" : row["trainername"].ToString();
                row["Specialization"] = row["specialization"] == DBNull.Value ? "" : row["specialization"].ToString();
                row["ExperienceYears"] = row["exprerience"] == DBNull.Value ? "" : row["exprerience"].ToString();

                string photo = row["photo"] == DBNull.Value ? "" : row["photo"].ToString();
                row["PhotoUrl"] = string.IsNullOrEmpty(photo)
                    ? "https://via.placeholder.com/300x300.png?text=Trainer"
                    : ResolveUrl("~/Image1/" + photo);
            }

            rptTrainers.DataSource = dt;
            rptTrainers.DataBind();
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Could not load trainers: " + ex.Message;
        }
    }

    // =========================================================
    //  MEMBERSHIP / MEMBERSHIP PLANS  (admin side: Add_membership_plan.aspx -> table "membership")
    // =========================================================
    private void BindPlans(OleDbConnection con)
    {
        try
        {
            OleDbDataAdapter da = new OleDbDataAdapter(
                "SELECT id, planname, membershipduration, price FROM membership", con);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptPlans.DataSource = dt;
            rptPlans.DataBind();
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Could not load membership plans: " + ex.Message;
        }
    }

    /// <summary>
    /// Fires when a member clicks "Join Now" on a plan card.
    /// If nobody is logged in, we bounce them to the Login page and remember
    /// which plan they wanted so we can finish the job right after they sign in.
    /// </summary>
    protected void rptPlans_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "Join") return;

        int planId;
        if (!int.TryParse(e.CommandArgument.ToString(), out planId)) return;

        if (!IsLoggedIn)
        {
            ViewState["PendingPlanId"] = planId;
            hidActivePage.Value = "login";
            lblLoginMsg.CssClass = "text-warning small d-block mb-2";
            lblLoginMsg.Text = "Please log in to choose this plan.";
            return;
        }

        JoinPlan(planId);
    }

    /// <summary>Assigns the given membership plan to the currently logged-in member.</summary>
    private void JoinPlan(int planId)
    {
        try
        {
            using (OleDbConnection con = new OleDbConnection(ConnStr))
            {
                con.Open();

                OleDbCommand lookup = new OleDbCommand("SELECT planname FROM membership WHERE id = ?", con);
                lookup.Parameters.AddWithValue("?", planId);
                object result = lookup.ExecuteScalar();
                if (result == null) return;
                string planName = result.ToString();

                OleDbCommand cmd = new OleDbCommand(
                    "UPDATE member SET planid = ?, planname = ?, plandate = ? WHERE id = ?", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = planId;
                cmd.Parameters.Add("?", OleDbType.VarWChar, 100).Value = planName;
                cmd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                cmd.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(Session["MemberId"]);
                cmd.ExecuteNonQuery();

                Session["MemberPlan"] = planName;
                hidActivePage.Value = "account";
                hidToastTitle.Value = "Plan Activated";
                hidToastMsg.Value = "You are now subscribed to the " + SanitizeForToast(planName) + " plan.";

                BindAccount(con);
            }
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Could not save your plan: " + ex.Message;
        }
    }

    // =========================================================
    //  WORKOUT PROGRAMS + BOOKING
    //  (admin side: Add_program.aspx -> tables "program" / "programslot" / "booking")
    // =========================================================
    private void BindPrograms(OleDbConnection con)
    {
        try
        {
            OleDbDataAdapter da = new OleDbDataAdapter(
                "SELECT id, programname, description, icon FROM program", con);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptPrograms.DataSource = dt;
            rptPrograms.DataBind();
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Could not load programs: " + ex.Message;
        }
    }

    /// <summary>Card click -> load the chosen program's details + trainer + slots into the modal.</summary>
    protected void rptPrograms_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "ViewProgram") return;

        int programId;
        if (!int.TryParse(e.CommandArgument.ToString(), out programId)) return;

        LoadProgramIntoModal(programId);
    }

    private void LoadProgramIntoModal(int programId)
    {
        try
        {
            using (OleDbConnection con = new OleDbConnection(ConnStr))
            {
                con.Open();

                OleDbCommand cmd = new OleDbCommand(
                    "SELECT program.id, programname, description, trainerid, trainername, specialization, exprerience, photo " +
                    "FROM program LEFT JOIN trainer ON program.trainerid = trainer.id WHERE program.id = ?", con);
                cmd.Parameters.AddWithValue("?", programId);
                OleDbDataAdapter da = new OleDbDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);
                if (dt.Rows.Count == 0) return;

                DataRow row = dt.Rows[0];
                ViewState["CurrentProgramId"] = programId;

                lblModalTitle.Text = row["programname"].ToString();
                lblModalDesc.Text = row["description"] == DBNull.Value ? "" : row["description"].ToString();
                lblModalTrainerName.Text = row["trainername"] == DBNull.Value ? "TBA" : row["trainername"].ToString();
                lblModalTrainerSpec.Text = row["specialization"] == DBNull.Value ? "" : row["specialization"].ToString();
                lblModalTrainerExp.Text = row["exprerience"] == DBNull.Value ? "-" : row["exprerience"].ToString();
                lblBookingTrainerName.Text = lblModalTrainerName.Text;

                string photo = row["photo"] == DBNull.Value ? "" : row["photo"].ToString();
                imgModalTrainer.ImageUrl = string.IsNullOrEmpty(photo)
                    ? "https://via.placeholder.com/120x120.png?text=Trainer"
                    : ResolveUrl("~/Image1/" + photo);

                OleDbCommand slotCmd = new OleDbCommand(
                    "SELECT id, dayname, slottime FROM programslot WHERE programid = ?", con);
                slotCmd.Parameters.AddWithValue("?", programId);
                OleDbDataAdapter slotDa = new OleDbDataAdapter(slotCmd);
                DataTable slotDt = new DataTable();
                slotDa.Fill(slotDt);
                rptSlots.DataSource = slotDt;
                rptSlots.DataBind();

                lblSlotMsg.Text = slotDt.Rows.Count == 0 ? "No time slots have been published for this program yet." : "";

                hidShowProgramModal.Value = "1";
                hidModalView.Value = "details";
            }
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Could not load program: " + ex.Message;
        }
    }

    /// <summary>Member clicks a specific time slot -> books it (requires login).</summary>
    protected void rptSlots_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "BookSlot") return;

        int slotId;
        if (!int.TryParse(e.CommandArgument.ToString(), out slotId)) return;

        int programId = ViewState["CurrentProgramId"] != null ? Convert.ToInt32(ViewState["CurrentProgramId"]) : 0;

        if (!IsLoggedIn)
        {
            ViewState["PendingBookingSlotId"] = slotId;
            ViewState["PendingBookingProgramId"] = programId;
            hidShowProgramModal.Value = "0";
            hidActivePage.Value = "login";
            lblLoginMsg.CssClass = "text-warning small d-block mb-2";
            lblLoginMsg.Text = "Please log in to book a session.";
            return;
        }

        if (programId > 0) LoadProgramIntoModal(programId); // keep modal populated on re-render
        hidModalView.Value = "booking";
        BookSlot(slotId, programId);
    }

    private void BookSlot(int slotId, int programId)
    {
        try
        {
            using (OleDbConnection con = new OleDbConnection(ConnStr))
            {
                con.Open();

                OleDbCommand slotCmd = new OleDbCommand("SELECT dayname, slottime, programid FROM programslot WHERE id = ?", con);
                slotCmd.Parameters.AddWithValue("?", slotId);
                OleDbDataAdapter slotDa = new OleDbDataAdapter(slotCmd);
                DataTable slotDt = new DataTable();
                slotDa.Fill(slotDt);
                if (slotDt.Rows.Count == 0) return;

                string day = slotDt.Rows[0]["dayname"].ToString();
                string time = slotDt.Rows[0]["slottime"].ToString();
                int resolvedProgramId = Convert.ToInt32(slotDt.Rows[0]["programid"]);

                OleDbCommand progCmd = new OleDbCommand(
                    "SELECT programname, trainername FROM program LEFT JOIN trainer ON program.trainerid = trainer.id WHERE program.id = ?", con);
                progCmd.Parameters.AddWithValue("?", resolvedProgramId);
                OleDbDataAdapter progDa = new OleDbDataAdapter(progCmd);
                DataTable progDt = new DataTable();
                progDa.Fill(progDt);
                if (progDt.Rows.Count == 0) return;

                string programName = progDt.Rows[0]["programname"].ToString();
                string trainerName = progDt.Rows[0]["trainername"] == DBNull.Value ? "TBA" : progDt.Rows[0]["trainername"].ToString();

                OleDbCommand ins = new OleDbCommand(
                    "INSERT INTO booking (memberid, programid, programname, trainername, bookingday, bookingslot, bookingdate) " +
                    "VALUES (?,?,?,?,?,?,?)", con);
                ins.Parameters.AddWithValue("?", Convert.ToInt32(Session["MemberId"]));
                ins.Parameters.AddWithValue("?", resolvedProgramId);
                ins.Parameters.AddWithValue("?", programName);
                ins.Parameters.AddWithValue("?", trainerName);
                ins.Parameters.AddWithValue("?", day);
                ins.Parameters.AddWithValue("?", time);
                ins.Parameters.AddWithValue("?", DateTime.Now);
                ins.ExecuteNonQuery();

                hidShowProgramModal.Value = "0";
                hidActivePage.Value = "account";
                hidToastTitle.Value = "Booking Confirmed";
                hidToastMsg.Value = "You booked " + SanitizeForToast(programName) + " with " + SanitizeForToast(trainerName) + " on " + SanitizeForToast(day) + " at " + SanitizeForToast(time) + ".";

                BindAccount(con);
            }
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Could not save your booking: " + ex.Message;
        }
    }

    // =========================================================
    //  SUPPLEMENTS + CART/CHECKOUT
    //  (admin side: Add_supplement.aspx -> table "supplement"; orders -> "orderitem")
    // =========================================================
    private void BindSupplements(OleDbConnection con)
    {
        try
        {
            OleDbDataAdapter da = new OleDbDataAdapter(
                "SELECT id, [name], description, price, [size], imageurl FROM supplement", con);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptSupplements.DataSource = dt;
            rptSupplements.DataBind();
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Could not load supplements: " + ex.Message;
        }
    }

    private class CartLine
    {
        public string name { get; set; }
        public decimal price { get; set; }
        public int quantity { get; set; }
    }

    protected void btnCheckout_Click(object sender, EventArgs e)
    {
        hidActivePage.Value = "cart";

        if (!IsLoggedIn) return;
        if (string.IsNullOrWhiteSpace(hidCartData.Value)) return;

        try
        {
            JavaScriptSerializer serializer = new JavaScriptSerializer();
            List<CartLine> lines = serializer.Deserialize<List<CartLine>>(hidCartData.Value);
            if (lines == null || lines.Count == 0) return;

            using (OleDbConnection con = new OleDbConnection(ConnStr))
            {
                con.Open();
                foreach (CartLine line in lines)
                {
                    OleDbCommand cmd = new OleDbCommand(
                        "INSERT INTO orderitem (memberid, supplementname, price, quantity, orderdate) VALUES (?,?,?,?,?)", con);

                    cmd.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(Session["MemberId"]);
                    cmd.Parameters.Add("?", OleDbType.VarWChar, 100).Value = line.name ?? "";
                    cmd.Parameters.Add("?", OleDbType.Currency).Value = line.price;
                    cmd.Parameters.Add("?", OleDbType.Integer).Value = line.quantity;
                    cmd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;

                    cmd.ExecuteNonQuery();
                }
            }

            hidCartData.Value = "";
            hidClearCart.Value = "1";
            hidActivePage.Value = "account";
            hidToastTitle.Value = "Order Placed";
            hidToastMsg.Value = "Your order has been placed successfully. Thank you for shopping with us!";

            BindAccount();
        }
        catch (Exception ex)
        {
            string detail = ex.Message;
            if (ex.InnerException != null) detail += " | Inner: " + ex.InnerException.Message;
            lblCartMsg.CssClass = "text-danger d-block text-center mt-2";
            lblCartMsg.Text = "Checkout failed (" + ex.GetType().Name + "): " + detail;
            hidActivePage.Value = "cart";
        }
    }

    // =========================================================
    //  REGISTER  (writes into the SAME "member" table the admin GridView shows)
    // =========================================================
    protected void btnRegister_Click(object sender, EventArgs e)
    {
        hidActivePage.Value = "register";

        if (!Page.IsValid) return;

        if (txtRegPassword.Text != txtRegConfirmPassword.Text)
        {
            lblRegMsg.CssClass = "text-danger small d-block mt-2";
            lblRegMsg.Text = "Passwords do not match.";
            return;
        }

        try
        {
            using (OleDbConnection con = new OleDbConnection(ConnStr))
            {
                con.Open();

                OleDbCommand chk = new OleDbCommand("SELECT COUNT(*) FROM member WHERE email = ?", con);
                chk.Parameters.AddWithValue("?", txtRegEmail.Text.Trim());
                int existing = (int)chk.ExecuteScalar();
                if (existing > 0)
                {
                    lblRegMsg.CssClass = "text-danger small d-block mt-2";
                    lblRegMsg.Text = "An account with this email already exists. Please log in instead.";
                    return;
                }

                OleDbCommand cmd = new OleDbCommand(
                    "INSERT INTO member (fullname,email,passwordd,dateofbirth,mobileno,gender,address,joindate,height,weight,lastlogin) " +
                    "VALUES (?,?,?,?,?,?,?,?,?,?,?)", con);
                cmd.Parameters.AddWithValue("?", txtRegFullName.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtRegEmail.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtRegPassword.Text);
                cmd.Parameters.AddWithValue("?", txtRegDob.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtRegMobile.Text.Trim());
                cmd.Parameters.AddWithValue("?", ddlRegGender.SelectedValue);
                cmd.Parameters.AddWithValue("?", txtRegAddress.Text.Trim());
                cmd.Parameters.AddWithValue("?", DateTime.Now.ToString("dd/MM/yyyy"));
                cmd.Parameters.AddWithValue("?", txtRegHeight.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtRegWeight.Text.Trim());
                cmd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                cmd.ExecuteNonQuery();
            }

            txtLoginEmail.Text = txtRegEmail.Text.Trim();
            ClearRegisterForm();

            hidActivePage.Value = "login";
            hidToastTitle.Value = "Account Created";
            hidToastMsg.Value = "Welcome to Haathi Fitness! Please log in to continue.";
        }
        catch (Exception ex)
        {
            lblRegMsg.CssClass = "text-danger small d-block mt-2";
            lblRegMsg.Text = "Registration failed: " + ex.Message;
        }
    }

    private void ClearRegisterForm()
    {
        txtRegFullName.Text = "";
        txtRegEmail.Text = "";
        txtRegPassword.Text = "";
        txtRegConfirmPassword.Text = "";
        txtRegDob.Text = "";
        txtRegMobile.Text = "";
        txtRegAddress.Text = "";
        txtRegHeight.Text = "";
        txtRegWeight.Text = "";
    }

    // =========================================================
    //  LOGIN  (checks against "member" table -> separate from admin login.aspx)
    // =========================================================
    protected void btnClientLogin_Click(object sender, EventArgs e)
    {
        hidActivePage.Value = "login";

        if (!Page.IsValid) return;

        try
        {
            using (OleDbConnection con = new OleDbConnection(ConnStr))
            {
                con.Open();
                OleDbCommand cmd = new OleDbCommand(
                    "SELECT * FROM member WHERE email = ? AND passwordd = ?", con);
                cmd.Parameters.AddWithValue("?", txtLoginEmail.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtLoginPassword.Text);

                OleDbDataAdapter da = new OleDbDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    Session["MemberId"] = row["id"];
                    Session["MemberName"] = row["fullname"].ToString();
                    Session["MemberPlan"] = (dt.Columns.Contains("planname") && row["planname"] != DBNull.Value)
                        ? row["planname"].ToString() : "";

                    OleDbCommand upd = new OleDbCommand("UPDATE member SET lastlogin = ? WHERE id = ?", con);
                    upd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                    upd.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(row["id"]);
                    upd.ExecuteNonQuery();

                    txtLoginEmail.Text = "";
                    txtLoginPassword.Text = "";

                    BindAccount(con);

                    if (ViewState["PendingPlanId"] != null)
                    {
                        int pendingPlanId = Convert.ToInt32(ViewState["PendingPlanId"]);
                        ViewState["PendingPlanId"] = null;
                        JoinPlan(pendingPlanId); // sets hidActivePage/toast to "account"
                    }
                    else if (ViewState["PendingBookingSlotId"] != null)
                    {
                        int pendingSlotId = Convert.ToInt32(ViewState["PendingBookingSlotId"]);
                        int pendingProgramId = ViewState["PendingBookingProgramId"] != null ? Convert.ToInt32(ViewState["PendingBookingProgramId"]) : 0;
                        ViewState["PendingBookingSlotId"] = null;
                        ViewState["PendingBookingProgramId"] = null;
                        BookSlot(pendingSlotId, pendingProgramId); // sets hidActivePage/toast to "account"
                    }
                    else
                    {
                        hidActivePage.Value = "account";
                        hidToastTitle.Value = "Welcome back";
                        hidToastMsg.Value = "You have signed in as " + SanitizeForToast(Session["MemberName"] as string) + ".";
                    }
                }
                else
                {
                    lblLoginMsg.CssClass = "text-danger small d-block mb-2";
                    lblLoginMsg.Text = "Invalid email or password.";
                }
            }
        }
        catch (Exception ex)
        {
            lblLoginMsg.CssClass = "text-danger small d-block mb-2";
            lblLoginMsg.Text = "Login failed: " + ex.Message;
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Session.Abandon();
        Response.Redirect("index.aspx");
    }

    // =========================================================
    //  MY ACCOUNT
    // =========================================================

    /// <summary>Convenience overload — opens its own connection. Use BindAccount(con) instead when a connection is already open.</summary>
    private void BindAccount()
    {
        try
        {
            using (OleDbConnection con = new OleDbConnection(ConnStr))
            {
                con.Open();
                BindAccount(con);
            }
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Could not load your account: " + ex.Message;
        }
    }

    private void BindAccount(OleDbConnection con)
    {
        if (!IsLoggedIn) return;

        try
        {
            OleDbCommand cmd = new OleDbCommand("SELECT * FROM member WHERE id = ?", con);
            cmd.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(Session["MemberId"]);
            OleDbDataAdapter da = new OleDbDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            if (dt.Rows.Count == 0) return;

            DataRow row = dt.Rows[0];

            lblAccName.Text = SafeStr(row, "fullname");
            lblAccEmail.Text = SafeStr(row, "email");
            lblAccMobile.Text = SafeStr(row, "mobileno");
            lblAccGender.Text = SafeStr(row, "gender");
            lblAccAddress.Text = SafeStr(row, "address");
            lblAccHeight.Text = SafeStr(row, "height");
            lblAccWeight.Text = SafeStr(row, "weight");

            DateTime joinDateParsed;
            string joinDateRaw = SafeStr(row, "joindate");
            lblAccJoinDate.Text = DateTime.TryParse(joinDateRaw, out joinDateParsed)
                ? joinDateParsed.ToString("dd MMM yyyy")
                : joinDateRaw;

            lblAccPlan.Text = (dt.Columns.Contains("planname") && row["planname"] != DBNull.Value && row["planname"].ToString() != "")
                ? row["planname"].ToString()
                : "No active plan";

            txtEditMobile.Text = lblAccMobile.Text == "-" ? "" : lblAccMobile.Text;
            txtEditAddress.Text = lblAccAddress.Text == "-" ? "" : lblAccAddress.Text;
            txtEditHeight.Text = lblAccHeight.Text == "-" ? "" : lblAccHeight.Text;
            txtEditWeight.Text = lblAccWeight.Text == "-" ? "" : lblAccWeight.Text;

            BindMyBookings(con);
            BindMyOrders(con);
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Could not load your account: " + ex.Message;
        }
    }

    private void BindMyBookings(OleDbConnection con)
    {
        OleDbCommand cmd = new OleDbCommand(
            "SELECT programname, trainername, bookingday, bookingslot FROM booking WHERE memberid = ? ORDER BY bookingdate DESC", con);
        cmd.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(Session["MemberId"]);
        OleDbDataAdapter da = new OleDbDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        rptMyBookings.DataSource = dt;
        rptMyBookings.DataBind();
        lblNoBookings.Visible = dt.Rows.Count == 0;
    }

    private void BindMyOrders(OleDbConnection con)
    {
        OleDbCommand cmd = new OleDbCommand(
            "SELECT supplementname, price, quantity, orderdate FROM orderitem WHERE memberid = ? ORDER BY orderdate DESC", con);
        cmd.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(Session["MemberId"]);
        OleDbDataAdapter da = new OleDbDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        rptMyOrders.DataSource = dt;
        rptMyOrders.DataBind();
        lblNoOrders.Visible = dt.Rows.Count == 0;
    }

    private static string SafeStr(DataRow row, string col)
    {
        if (!row.Table.Columns.Contains(col) || row[col] == DBNull.Value) return "-";
        return row[col].ToString();
    }

    /// <summary>
    /// Strips angle brackets from free text before it's written into a hidden field
    /// (hidToastMsg etc). Without this, a member name or plan/program name containing
    /// "&lt;" or "&gt;" would trip ASP.NET's request validation on the NEXT postback
    /// with the same "potentially dangerous Request.Form value" error.
    /// </summary>
    private static string SanitizeForToast(string text)
    {
        if (string.IsNullOrEmpty(text)) return text;
        return text.Replace("<", "").Replace(">", "");
    }

    protected void btnUpdateProfile_Click(object sender, EventArgs e)
    {
        hidActivePage.Value = "account";
        if (!IsLoggedIn) return;

        try
        {
            using (OleDbConnection con = new OleDbConnection(ConnStr))
            {
                con.Open();
                OleDbCommand cmd = new OleDbCommand(
                    "UPDATE member SET mobileno = ?, address = ?, height = ?, weight = ? WHERE id = ?", con);
                cmd.Parameters.AddWithValue("?", txtEditMobile.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtEditAddress.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtEditHeight.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtEditWeight.Text.Trim());
                cmd.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(Session["MemberId"]);
                cmd.ExecuteNonQuery();
            }

            BindAccount();
            hidToastTitle.Value = "Profile Updated";
            hidToastMsg.Value = "Your details have been saved.";
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Update failed: " + ex.Message;
        }
    }

    protected void btnChangePassword_Click(object sender, EventArgs e)
    {
        hidActivePage.Value = "account";
        if (!IsLoggedIn) return;

        if (string.IsNullOrEmpty(txtNewPassword.Text) || txtNewPassword.Text != txtConfirmNewPassword.Text)
        {
            lblPasswordMsg.CssClass = "text-danger small d-block mt-2";
            lblPasswordMsg.Text = "New passwords do not match.";
            return;
        }

        try
        {
            using (OleDbConnection con = new OleDbConnection(ConnStr))
            {
                con.Open();

                OleDbCommand chk = new OleDbCommand("SELECT COUNT(*) FROM member WHERE id = ? AND passwordd = ?", con);
                chk.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(Session["MemberId"]);
                chk.Parameters.AddWithValue("?", txtCurrentPassword.Text);
                int match = (int)chk.ExecuteScalar();

                if (match == 0)
                {
                    lblPasswordMsg.CssClass = "text-danger small d-block mt-2";
                    lblPasswordMsg.Text = "Current password is incorrect.";
                    return;
                }

                OleDbCommand cmd = new OleDbCommand("UPDATE member SET passwordd = ? WHERE id = ?", con);
                cmd.Parameters.AddWithValue("?", txtNewPassword.Text);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = Convert.ToInt32(Session["MemberId"]);
                cmd.ExecuteNonQuery();
            }

            txtCurrentPassword.Text = "";
            txtNewPassword.Text = "";
            txtConfirmNewPassword.Text = "";

            lblPasswordMsg.CssClass = "text-success small d-block mt-2";
            lblPasswordMsg.Text = "Password updated successfully.";
        }
        catch (Exception ex)
        {
            lblGlobalMsg.Text = "Password change failed: " + ex.Message;
        }
    }
}
