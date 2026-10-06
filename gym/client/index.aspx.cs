using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>
/// Customer-facing page of Haathi Fitness (programs, trainers, supplements, plans, login/register,
/// My Account, bookings and cart/checkout). Uses the SAME Access database as the admin panel via DbHelper.
/// </summary>
public partial class client_index : System.Web.UI.Page
{
    private const string TrainerPlaceholder = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHdpZHRoPSczMDAnIGhlaWdodD0nMzAwJz48cmVjdCB3aWR0aD0nMzAwJyBoZWlnaHQ9JzMwMCcgZmlsbD0nIzFiMWIxZicvPjxjaXJjbGUgY3g9JzE1MCcgY3k9JzExNScgcj0nNTInIGZpbGw9JyMyZTJlMzUnLz48cmVjdCB4PSc3MCcgeT0nMTg1JyB3aWR0aD0nMTYwJyBoZWlnaHQ9JzkwJyByeD0nNDUnIGZpbGw9JyMyZTJlMzUnLz48dGV4dCB4PScxNTAnIHk9JzI5MicgZm9udC1mYW1pbHk9J0FyaWFsJyBmb250LXNpemU9JzE4JyBmaWxsPScjZjJhOTAwJyB0ZXh0LWFuY2hvcj0nbWlkZGxlJz5IQUFUSEkgRklUTkVTUzwvdGV4dD48L3N2Zz4=";
    private const string ProductPlaceholder = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0naHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmcnIHdpZHRoPSc0MDAnIGhlaWdodD0nMzAwJz48cmVjdCB3aWR0aD0nNDAwJyBoZWlnaHQ9JzMwMCcgZmlsbD0nI2ZmZmZmZicvPjxyZWN0IHg9JzE1MCcgeT0nNzAnIHdpZHRoPScxMDAnIGhlaWdodD0nMTUwJyByeD0nMTQnIGZpbGw9JyNlNmU4ZWMnLz48cmVjdCB4PScxNzAnIHk9JzUwJyB3aWR0aD0nNjAnIGhlaWdodD0nMjgnIHJ4PSc2JyBmaWxsPScjZjJhOTAwJy8+PHRleHQgeD0nMjAwJyB5PScyNjInIGZvbnQtZmFtaWx5PSdBcmlhbCcgZm9udC1zaXplPScxNicgZmlsbD0nIzZiNmQ3NicgdGV4dC1hbmNob3I9J21pZGRsZSc+Tm8gaW1hZ2U8L3RleHQ+PC9zdmc+";
    private const string Area = "member";

    protected bool IsLoggedIn
    {
        get { return Session["MemberId"] != null; }
    }

    // True only when the ADMIN logged in through login.aspx. Customers never get this session value,
    // so the "Admin Panel" button is not even written into the page for them.
    protected bool IsAdmin
    {
        get { return Session["AdminData"] != null; }
    }

    protected string MemberName
    {
        get { return Session["MemberName"] as string ?? ""; }
    }

    private int MemberId
    {
        get { return Convert.ToInt32(Session["MemberId"]); }
    }

    // ---- helpers used from the markup: <%# H(Eval("name")) %> -----------------
    protected static string H(object o) { return UiHelper.Html(o); }
    protected static string Duration(object o) { return HttpUtility.HtmlEncode(UiHelper.Duration(o)); }
    protected static string ProductImg(object o)
    {
        string s = Convert.ToString(o);
        return string.IsNullOrEmpty(s) ? ProductPlaceholder : HttpUtility.HtmlAttributeEncode(s);
    }
    protected static string Money(object o)
    {
        decimal d;
        if (o is decimal) d = (decimal)o;                       // Currency column
        else if (!decimal.TryParse(Convert.ToString(o), NumberStyles.Number, CultureInfo.InvariantCulture, out d))
            return HttpUtility.HtmlEncode(Convert.ToString(o));
        return d == Math.Truncate(d) ? d.ToString("N0", CultureInfo.InvariantCulture) : d.ToString("N2", CultureInfo.InvariantCulture);
    }
    /// <summary>Plain invariant number ("499.5") for use in data-* attributes.</summary>
    protected static string Num(object o)
    {
        decimal d;
        if (o is decimal) d = (decimal)o;
        else if (!decimal.TryParse(Convert.ToString(o), NumberStyles.Number, CultureInfo.InvariantCulture, out d)) d = 0;
        return d.ToString("0.##", CultureInfo.InvariantCulture);
    }
    protected static string IconClass(object o)
    {
        string s = Convert.ToString(o);
        // only allow a plain bootstrap-icon class name
        return System.Text.RegularExpressions.Regex.IsMatch(s ?? "", @"^bi-[a-z0-9\-]+$") ? s : "bi-activity";
    }

    private void GlobalError(Exception ex)
    {
        DbHelper.Log(ex);
        lblGlobalMsg.Text = Request.IsLocal
            ? "Something went wrong: " + HttpUtility.HtmlEncode(ex.Message)
            : "Something went wrong. Please try again in a moment.";
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (IsPostBack) return;
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                BindTrainers(con);
                BindPlans(con);
                BindPrograms(con);
                BindSupplements(con);
                if (IsLoggedIn) BindAccount(con);
            }
        }
        catch (Exception ex) { GlobalError(ex); }
    }

    // =========================================================
    //  TRAINERS
    // =========================================================
    private void BindTrainers(OleDbConnection con)
    {
        DataTable dt = new DataTable();
        new OleDbDataAdapter("SELECT trainername, specialization, exprerience, photo FROM [trainer] ORDER BY id", con).Fill(dt);

        dt.Columns.Add("TrainerName", typeof(string));
        dt.Columns.Add("Specialization", typeof(string));
        dt.Columns.Add("ExperienceYears", typeof(string));
        dt.Columns.Add("PhotoUrl", typeof(string));

        foreach (DataRow row in dt.Rows)
        {
            row["TrainerName"] = Convert.ToString(row["trainername"]);
            row["Specialization"] = Convert.ToString(row["specialization"]);
            row["ExperienceYears"] = Convert.ToString(row["exprerience"]);
            string photo = Convert.ToString(row["photo"]);
            row["PhotoUrl"] = string.IsNullOrEmpty(photo) ? TrainerPlaceholder : ResolveUrl("~/Image1/" + photo);
        }
        rptTrainers.DataSource = dt;
        rptTrainers.DataBind();
    }

    // =========================================================
    //  MEMBERSHIP PLANS
    // =========================================================
    private void BindPlans(OleDbConnection con)
    {
        DataTable dt = new DataTable();
        new OleDbDataAdapter("SELECT id, planname, membershipduration, price FROM [membership] ORDER BY id", con).Fill(dt);
        rptPlans.DataSource = dt;
        rptPlans.DataBind();
    }

    protected void rptPlans_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "Join") return;

        int planId;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out planId)) return;

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

    private void JoinPlan(int planId)
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand lookup = new OleDbCommand("SELECT planname FROM [membership] WHERE id = ?", con);
                lookup.Parameters.Add("?", OleDbType.Integer).Value = planId;
                object result = lookup.ExecuteScalar();
                if (result == null) return;
                string planName = result.ToString();

                OleDbCommand cmd = new OleDbCommand("UPDATE [member] SET planid = ?, planname = ?, plandate = ? WHERE id = ?", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = planId;
                cmd.Parameters.Add("?", OleDbType.VarWChar, 100).Value = planName;
                cmd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                cmd.Parameters.Add("?", OleDbType.Integer).Value = MemberId;
                cmd.ExecuteNonQuery();

                Session["MemberPlan"] = planName;
                hidActivePage.Value = "account";
                hidToastTitle.Value = "Plan Activated";
                hidToastMsg.Value = "You are now subscribed to the " + SanitizeForToast(planName) + " plan.";
                BindAccount(con);
            }
        }
        catch (Exception ex) { GlobalError(ex); }
    }

    // =========================================================
    //  WORKOUT PROGRAMS + BOOKING
    // =========================================================
    private void BindPrograms(OleDbConnection con)
    {
        DataTable dt = new DataTable();
        new OleDbDataAdapter("SELECT id, programname, description, icon FROM [program] ORDER BY id", con).Fill(dt);
        rptPrograms.DataSource = dt;
        rptPrograms.DataBind();
    }

    protected void rptPrograms_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "ViewProgram") return;
        int programId;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out programId)) return;
        hidActivePage.Value = "programs";
        LoadProgramIntoModal(programId);
    }

    private void LoadProgramIntoModal(int programId)
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd = new OleDbCommand(
                    "SELECT program.id, programname, description, trainerid, trainername, specialization, exprerience, photo " +
                    "FROM [program] LEFT JOIN [trainer] ON program.trainerid = trainer.id WHERE program.id = ?", con);
                cmd.Parameters.Add("?", OleDbType.Integer).Value = programId;
                DataTable dt = new DataTable();
                new OleDbDataAdapter(cmd).Fill(dt);
                if (dt.Rows.Count == 0) return;

                DataRow row = dt.Rows[0];
                ViewState["CurrentProgramId"] = programId;

                lblModalTitle.Text = H(row["programname"]);
                lblModalDesc.Text = H(row["description"]);
                lblModalTrainerName.Text = row["trainername"] == DBNull.Value ? "TBA" : H(row["trainername"]);
                lblModalTrainerSpec.Text = H(row["specialization"]);
                lblModalTrainerExp.Text = row["exprerience"] == DBNull.Value ? "-" : H(row["exprerience"]);
                lblBookingTrainerName.Text = lblModalTrainerName.Text;

                string photo = Convert.ToString(row["photo"]);
                imgModalTrainer.ImageUrl = string.IsNullOrEmpty(photo) ? TrainerPlaceholder : "~/Image1/" + photo;

                OleDbCommand slotCmd = new OleDbCommand("SELECT id, dayname, slottime FROM [programslot] WHERE programid = ? ORDER BY id", con);
                slotCmd.Parameters.Add("?", OleDbType.Integer).Value = programId;
                DataTable slotDt = new DataTable();
                new OleDbDataAdapter(slotCmd).Fill(slotDt);
                rptSlots.DataSource = slotDt;
                rptSlots.DataBind();

                lblSlotMsg.Text = slotDt.Rows.Count == 0 ? "No time slots have been published for this program yet." : "";

                hidShowProgramModal.Value = "1";
                hidModalView.Value = "details";
            }
        }
        catch (Exception ex) { GlobalError(ex); }
    }

    protected void rptSlots_ItemCommand(object source, RepeaterCommandEventArgs e)
    {
        if (e.CommandName != "BookSlot") return;

        int slotId;
        if (!int.TryParse(Convert.ToString(e.CommandArgument), out slotId)) return;

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

        if (programId > 0) LoadProgramIntoModal(programId); // keep modal populated if we have to show a message
        hidModalView.Value = "booking";
        BookSlot(slotId, programId, false);
    }

    private void BookSlot(int slotId, int programId, bool afterLogin)
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand slotCmd = new OleDbCommand("SELECT dayname, slottime, programid FROM [programslot] WHERE id = ?", con);
                slotCmd.Parameters.Add("?", OleDbType.Integer).Value = slotId;
                DataTable slotDt = new DataTable();
                new OleDbDataAdapter(slotCmd).Fill(slotDt);
                if (slotDt.Rows.Count == 0) { lblSlotMsg.Text = "This time slot is no longer available."; return; }

                string day = Convert.ToString(slotDt.Rows[0]["dayname"]);
                string time = Convert.ToString(slotDt.Rows[0]["slottime"]);
                int resolvedProgramId = Convert.ToInt32(slotDt.Rows[0]["programid"]);

                OleDbCommand progCmd = new OleDbCommand(
                    "SELECT programname, trainername FROM [program] LEFT JOIN [trainer] ON program.trainerid = trainer.id WHERE program.id = ?", con);
                progCmd.Parameters.Add("?", OleDbType.Integer).Value = resolvedProgramId;
                DataTable progDt = new DataTable();
                new OleDbDataAdapter(progCmd).Fill(progDt);
                if (progDt.Rows.Count == 0) return;

                string programName = Convert.ToString(progDt.Rows[0]["programname"]);
                string trainerName = progDt.Rows[0]["trainername"] == DBNull.Value ? "TBA" : Convert.ToString(progDt.Rows[0]["trainername"]);

                // same member + same slot twice? -> don't double book
                OleDbCommand dup = new OleDbCommand(
                    "SELECT COUNT(*) FROM [booking] WHERE memberid = ? AND programid = ? AND bookingday = ? AND bookingslot = ?", con);
                dup.Parameters.Add("?", OleDbType.Integer).Value = MemberId;
                dup.Parameters.Add("?", OleDbType.Integer).Value = resolvedProgramId;
                dup.Parameters.AddWithValue("?", day);
                dup.Parameters.AddWithValue("?", time);
                if (Convert.ToInt32(dup.ExecuteScalar()) > 0)
                {
                    if (afterLogin)
                    {
                        hidActivePage.Value = "account";
                        hidToastTitle.Value = "Already Booked";
                        hidToastMsg.Value = "You have already booked " + SanitizeForToast(programName) + " on " + SanitizeForToast(day) + " at " + SanitizeForToast(time) + ".";
                    }
                    else
                    {
                        lblSlotMsg.Text = "You have already booked this slot.";
                    }
                    return;
                }

                OleDbCommand ins = new OleDbCommand(
                    "INSERT INTO [booking] (memberid, programid, programname, trainername, bookingday, bookingslot, bookingdate) VALUES (?,?,?,?,?,?,?)", con);
                ins.Parameters.Add("?", OleDbType.Integer).Value = MemberId;
                ins.Parameters.Add("?", OleDbType.Integer).Value = resolvedProgramId;
                ins.Parameters.AddWithValue("?", programName);
                ins.Parameters.AddWithValue("?", trainerName);
                ins.Parameters.AddWithValue("?", day);
                ins.Parameters.AddWithValue("?", time);
                ins.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                ins.ExecuteNonQuery();

                hidShowProgramModal.Value = "0";
                hidActivePage.Value = "account";
                hidToastTitle.Value = "Booking Confirmed";
                hidToastMsg.Value = "You booked " + SanitizeForToast(programName) + " with " + SanitizeForToast(trainerName) + " on " + SanitizeForToast(day) + " at " + SanitizeForToast(time) + ".";
                BindAccount(con);
            }
        }
        catch (Exception ex) { GlobalError(ex); }
    }

    // =========================================================
    //  SUPPLEMENTS + CART / CHECKOUT
    // =========================================================
    private void BindSupplements(OleDbConnection con)
    {
        DataTable dt = new DataTable();
        new OleDbDataAdapter("SELECT id, [name], description, price, [size], imageurl FROM [supplement] ORDER BY id", con).Fill(dt);
        rptSupplements.DataSource = dt;
        rptSupplements.DataBind();
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
            List<CartLine> lines = new JavaScriptSerializer().Deserialize<List<CartLine>>(hidCartData.Value);
            if (lines == null || lines.Count == 0) return;

            List<OrderLine> mailLines = new List<OrderLine>();   // for the owner's e-mail

            using (OleDbConnection con = DbHelper.GetConnection())
            using (OleDbTransaction tx = con.BeginTransaction())
            {
                try
                {
                    foreach (CartLine line in lines)
                    {
                        if (line == null || string.IsNullOrEmpty(line.name) || line.quantity < 1 || line.quantity > 50)
                            throw new ApplicationException("Your cart contains an invalid item. Please refresh the page and try again.");

                        // NEVER trust the price sent by the browser: read the real price from the database
                        OleDbCommand pc = new OleDbCommand("SELECT price FROM [supplement] WHERE [name] = ?", con, tx);
                        pc.Parameters.AddWithValue("?", line.name);
                        object real = pc.ExecuteScalar();
                        if (real == null || real == DBNull.Value)
                            throw new ApplicationException("\"" + line.name + "\" is no longer available. Please remove it from your cart.");

                        OleDbCommand cmd = new OleDbCommand(
                            "INSERT INTO [orderitem] (memberid, supplementname, price, quantity, orderdate) VALUES (?,?,?,?,?)", con, tx);
                        cmd.Parameters.Add("?", OleDbType.Integer).Value = MemberId;
                        cmd.Parameters.Add("?", OleDbType.VarWChar, 150).Value = line.name;
                        cmd.Parameters.Add("?", OleDbType.Currency).Value = Convert.ToDecimal(real);
                        cmd.Parameters.Add("?", OleDbType.Integer).Value = line.quantity;
                        cmd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                        cmd.ExecuteNonQuery();

                        mailLines.Add(new OrderLine { Name = line.name, Price = Convert.ToDecimal(real), Quantity = line.quantity });
                    }
                    tx.Commit();
                }
                catch
                {
                    tx.Rollback();
                    throw;
                }
            }

            // order is saved; now tell the owner by e-mail (errors are logged, never shown to the customer)
            bool mailSent = MailHelper.SendOrderNotification(MemberName, mailLines);

            hidCartData.Value = "";
            hidClearCart.Value = "1";
            hidActivePage.Value = "account";
            if (mailSent)
            {
                hidToastTitle.Value = "Email Sent";
                hidToastMsg.Value = "Email has been sent successfully. Your order has been placed. Thank you for shopping with us!";
            }
            else
            {
                hidToastTitle.Value = "Order Placed";
                hidToastMsg.Value = "Your order has been placed successfully. Thank you for shopping with us!";
            }
            BindAccount();
        }
        catch (ApplicationException ex)
        {
            lblCartMsg.CssClass = "text-danger d-block text-center mt-2";
            lblCartMsg.Text = HttpUtility.HtmlEncode(ex.Message);
            hidActivePage.Value = "cart";
        }
        catch (Exception ex)
        {
            DbHelper.Log(ex);
            lblCartMsg.CssClass = "text-danger d-block text-center mt-2";
            lblCartMsg.Text = "Checkout failed. Please try again.";
            hidActivePage.Value = "cart";
        }
    }

    // =========================================================
    //  REGISTER
    // =========================================================
    protected void btnRegister_Click(object sender, EventArgs e)
    {
        hidActivePage.Value = "register";
        if (!Page.IsValid) return;

        lblRegMsg.CssClass = "text-danger small d-block mt-2";

        string email = txtRegEmail.Text.Trim();
        if (!UiHelper.IsEmail(email)) { lblRegMsg.Text = "Please enter a valid email address."; return; }
        if (txtRegPassword.Text.Length < 6) { lblRegMsg.Text = "Password must be at least 6 characters."; return; }
        if (txtRegPassword.Text != txtRegConfirmPassword.Text) { lblRegMsg.Text = "Passwords do not match."; return; }

        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand chk = new OleDbCommand("SELECT COUNT(*) FROM [member] WHERE email = ?", con);
                chk.Parameters.AddWithValue("?", email);
                if (Convert.ToInt32(chk.ExecuteScalar()) > 0)
                {
                    lblRegMsg.Text = "An account with this email already exists. Please log in instead.";
                    return;
                }

                OleDbCommand cmd = new OleDbCommand(
                    "INSERT INTO [member] (fullname, email, passwordd, dateofbirth, mobileno, gender, address, joindate, height, weight, lastlogin) " +
                    "VALUES (?,?,?,?,?,?,?,?,?,?,?)", con);
                cmd.Parameters.AddWithValue("?", txtRegFullName.Text.Trim());
                cmd.Parameters.AddWithValue("?", email);
                cmd.Parameters.AddWithValue("?", Security.HashPassword(txtRegPassword.Text));
                cmd.Parameters.AddWithValue("?", txtRegDob.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtRegMobile.Text.Trim());
                cmd.Parameters.AddWithValue("?", ddlRegGender.SelectedValue);
                cmd.Parameters.AddWithValue("?", txtRegAddress.Text.Trim());
                cmd.Parameters.AddWithValue("?", DateTime.Now.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture));
                cmd.Parameters.AddWithValue("?", txtRegHeight.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtRegWeight.Text.Trim());
                cmd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                cmd.ExecuteNonQuery();
            }

            txtLoginEmail.Text = email;
            ClearRegisterForm();
            lblRegMsg.Text = "";

            hidActivePage.Value = "login";
            hidToastTitle.Value = "Account Created";
            hidToastMsg.Value = "Welcome to Haathi Fitness! Please log in to continue.";
        }
        catch (Exception ex)
        {
            DbHelper.Log(ex);
            lblRegMsg.Text = "Registration failed. Please try again.";
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
    //  LOGIN / LOGOUT
    // =========================================================
    protected void btnClientLogin_Click(object sender, EventArgs e)
    {
        hidActivePage.Value = "login";
        if (!Page.IsValid) return;

        lblLoginMsg.CssClass = "text-danger small d-block mb-2";

        if (LoginThrottle.IsBlocked(Area))
        {
            lblLoginMsg.Text = "Too many failed attempts. Please wait 10 minutes and try again.";
            return;
        }

        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd = new OleDbCommand("SELECT id, fullname, passwordd, planname FROM [member] WHERE email = ?", con);
                cmd.Parameters.AddWithValue("?", txtLoginEmail.Text.Trim());
                DataTable dt = new DataTable();
                new OleDbDataAdapter(cmd).Fill(dt);

                bool ok = false, upgrade = false;
                if (dt.Rows.Count > 0)
                    ok = Security.Verify(txtLoginPassword.Text, Convert.ToString(dt.Rows[0]["passwordd"]), out upgrade);

                if (!ok)
                {
                    LoginThrottle.Fail(Area);
                    lblLoginMsg.Text = "Invalid email or password.";
                    return;
                }
                LoginThrottle.Reset(Area);

                DataRow row = dt.Rows[0];
                int id = Convert.ToInt32(row["id"]);

                Session["MemberId"] = id;
                Session["MemberName"] = Convert.ToString(row["fullname"]);
                Session["MemberPlan"] = Convert.ToString(row["planname"]);

                OleDbCommand upd = upgrade
                    ? new OleDbCommand("UPDATE [member] SET lastlogin = ?, passwordd = ? WHERE id = ?", con)
                    : new OleDbCommand("UPDATE [member] SET lastlogin = ? WHERE id = ?", con);
                upd.Parameters.Add("?", OleDbType.Date).Value = DateTime.Now;
                if (upgrade) upd.Parameters.AddWithValue("?", Security.HashPassword(txtLoginPassword.Text));
                upd.Parameters.Add("?", OleDbType.Integer).Value = id;
                upd.ExecuteNonQuery();

                txtLoginEmail.Text = "";
                lblLoginMsg.Text = "";
                BindAccount(con);

                if (ViewState["PendingPlanId"] != null)
                {
                    int pendingPlanId = Convert.ToInt32(ViewState["PendingPlanId"]);
                    ViewState["PendingPlanId"] = null;
                    JoinPlan(pendingPlanId);
                }
                else if (ViewState["PendingBookingSlotId"] != null)
                {
                    int pendingSlotId = Convert.ToInt32(ViewState["PendingBookingSlotId"]);
                    int pendingProgramId = ViewState["PendingBookingProgramId"] != null ? Convert.ToInt32(ViewState["PendingBookingProgramId"]) : 0;
                    ViewState["PendingBookingSlotId"] = null;
                    ViewState["PendingBookingProgramId"] = null;
                    BookSlot(pendingSlotId, pendingProgramId, true);
                }
                else
                {
                    hidActivePage.Value = "account";
                    hidToastTitle.Value = "Welcome back";
                    hidToastMsg.Value = "You have signed in as " + SanitizeForToast(Session["MemberName"] as string) + ".";
                }
            }
        }
        catch (Exception ex)
        {
            DbHelper.Log(ex);
            lblLoginMsg.Text = "Login is temporarily unavailable. Please try again.";
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
    private void BindAccount()
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection()) BindAccount(con);
        }
        catch (Exception ex) { GlobalError(ex); }
    }

    private void BindAccount(OleDbConnection con)
    {
        if (!IsLoggedIn) return;

        try
        {
            OleDbCommand cmd = new OleDbCommand("SELECT * FROM [member] WHERE id = ?", con);
            cmd.Parameters.Add("?", OleDbType.Integer).Value = MemberId;
            DataTable dt = new DataTable();
            new OleDbDataAdapter(cmd).Fill(dt);

            if (dt.Rows.Count == 0)
            {
                // account was removed by an admin -> sign out
                Session.Clear();
                return;
            }

            DataRow row = dt.Rows[0];
            string mobile = SafeStr(row, "mobileno"), address = SafeStr(row, "address"),
                   height = SafeStr(row, "height"), weight = SafeStr(row, "weight");

            lblAccName.Text = H(SafeStr(row, "fullname"));
            lblAccEmail.Text = H(SafeStr(row, "email"));
            lblAccMobile.Text = H(mobile);
            lblAccGender.Text = H(SafeStr(row, "gender"));
            lblAccAddress.Text = H(address);
            lblAccHeight.Text = H(height);
            lblAccWeight.Text = H(weight);
            lblAccJoinDate.Text = H(UiHelper.PrettyDate(SafeStr(row, "joindate")));

            string plan = Convert.ToString(row["planname"]);
            lblAccPlan.Text = string.IsNullOrEmpty(plan) ? "No active plan" : H(plan);

            // edit boxes get the RAW values (not the HTML-encoded label text)
            txtEditMobile.Text = mobile == "-" ? "" : mobile;
            txtEditAddress.Text = address == "-" ? "" : address;
            txtEditHeight.Text = height == "-" ? "" : height;
            txtEditWeight.Text = weight == "-" ? "" : weight;

            BindMyBookings(con);
            BindMyOrders(con);
        }
        catch (Exception ex) { GlobalError(ex); }
    }

    private void BindMyBookings(OleDbConnection con)
    {
        OleDbCommand cmd = new OleDbCommand(
            "SELECT programname, trainername, bookingday, bookingslot FROM [booking] WHERE memberid = ? ORDER BY bookingdate DESC", con);
        cmd.Parameters.Add("?", OleDbType.Integer).Value = MemberId;
        DataTable dt = new DataTable();
        new OleDbDataAdapter(cmd).Fill(dt);
        rptMyBookings.DataSource = dt;
        rptMyBookings.DataBind();
        lblNoBookings.Visible = dt.Rows.Count == 0;
    }

    private void BindMyOrders(OleDbConnection con)
    {
        OleDbCommand cmd = new OleDbCommand(
            "SELECT supplementname, price, quantity, orderdate FROM [orderitem] WHERE memberid = ? ORDER BY orderdate DESC", con);
        cmd.Parameters.Add("?", OleDbType.Integer).Value = MemberId;
        DataTable dt = new DataTable();
        new OleDbDataAdapter(cmd).Fill(dt);
        rptMyOrders.DataSource = dt;
        rptMyOrders.DataBind();
        lblNoOrders.Visible = dt.Rows.Count == 0;
    }

    private static string SafeStr(DataRow row, string col)
    {
        if (!row.Table.Columns.Contains(col) || row[col] == DBNull.Value) return "-";
        string s = row[col].ToString();
        return s == "" ? "-" : s;
    }

    /// <summary>Strips angle brackets before text goes into a hidden field (ASP.NET request validation would reject it on the next postback).</summary>
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
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand cmd = new OleDbCommand("UPDATE [member] SET mobileno = ?, address = ?, height = ?, weight = ? WHERE id = ?", con);
                cmd.Parameters.AddWithValue("?", txtEditMobile.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtEditAddress.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtEditHeight.Text.Trim());
                cmd.Parameters.AddWithValue("?", txtEditWeight.Text.Trim());
                cmd.Parameters.Add("?", OleDbType.Integer).Value = MemberId;
                cmd.ExecuteNonQuery();
                BindAccount(con);
            }
            hidToastTitle.Value = "Profile Updated";
            hidToastMsg.Value = "Your details have been saved.";
        }
        catch (Exception ex) { GlobalError(ex); }
    }

    protected void btnChangePassword_Click(object sender, EventArgs e)
    {
        hidActivePage.Value = "account";
        if (!IsLoggedIn) return;

        lblPasswordMsg.CssClass = "text-danger small d-block mt-2";

        if (txtNewPassword.Text.Length < 6) { lblPasswordMsg.Text = "New password must be at least 6 characters."; return; }
        if (txtNewPassword.Text != txtConfirmNewPassword.Text) { lblPasswordMsg.Text = "New passwords do not match."; return; }

        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                OleDbCommand chk = new OleDbCommand("SELECT passwordd FROM [member] WHERE id = ?", con);
                chk.Parameters.Add("?", OleDbType.Integer).Value = MemberId;
                bool upgrade;
                if (!Security.Verify(txtCurrentPassword.Text, Convert.ToString(chk.ExecuteScalar()), out upgrade))
                {
                    lblPasswordMsg.Text = "Current password is incorrect.";
                    return;
                }

                OleDbCommand cmd = new OleDbCommand("UPDATE [member] SET passwordd = ? WHERE id = ?", con);
                cmd.Parameters.AddWithValue("?", Security.HashPassword(txtNewPassword.Text));
                cmd.Parameters.Add("?", OleDbType.Integer).Value = MemberId;
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
            DbHelper.Log(ex);
            lblPasswordMsg.Text = "Password change failed. Please try again.";
        }
    }
}
