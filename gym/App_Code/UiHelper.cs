using System;
using System.Globalization;
using System.Web;
using System.Web.Script.Serialization;
using System.Web.UI;
using System.Web.UI.WebControls;

/// <summary>Small helpers shared by the admin pages.</summary>
public static class UiHelper
{
    /// <summary>Show a dismissible message bar at the top of the page (defined in Site.master).</summary>
    public static void Msg(Page page, string text, bool error)
    {
        string js = "showAdminMsg(" + new JavaScriptSerializer().Serialize(text) + ",'" + (error ? "danger" : "success") + "');";
        page.ClientScript.RegisterStartupScript(page.GetType(), "adminmsg" + Guid.NewGuid().ToString("N"), js, true);
    }

    public static void Ok(Page page, string text) { Msg(page, text, false); }

    /// <summary>Log the real error, show a friendly one (full text only when browsing from the server itself).</summary>
    public static void Fail(Page page, Exception ex)
    {
        DbHelper.Log(ex);
        string text = "Something went wrong. Please try again.";
        if (HttpContext.Current != null && HttpContext.Current.Request.IsLocal) text += " (" + ex.Message + ")";
        Msg(page, text, true);
    }

    /// <summary>Adds an "are you sure?" popup to the auto-generated Delete link of a GridView row.</summary>
    public static void ConfirmDelete(GridViewRowEventArgs e)
    {
        if (e.Row.RowType != DataControlRowType.DataRow) return;
        foreach (Control c in e.Row.Cells[0].Controls)
        {
            LinkButton lb = c as LinkButton;
            if (lb != null && lb.CommandName == "Delete")
                lb.OnClientClick = "return confirm('Delete this record permanently?');";
        }
    }

    public static string Html(object o)
    {
        return HttpUtility.HtmlEncode(Convert.ToString(o) ?? "");
    }

    private static readonly string[] DateFormats = { "yyyy-MM-dd", "dd/MM/yyyy", "d/M/yyyy", "dd-MM-yyyy", "MM/dd/yyyy" };

    public static string PrettyDate(string raw)
    {
        DateTime d;
        if (DateTime.TryParseExact(raw ?? "", DateFormats, CultureInfo.InvariantCulture, DateTimeStyles.None, out d))
            return d.ToString("dd MMM yyyy", CultureInfo.InvariantCulture);
        return raw ?? "";
    }

    /// <summary>"3" -> "3 months", "1" -> "1 month", anything else is shown as typed.</summary>
    public static string Duration(object raw)
    {
        string s = Convert.ToString(raw) ?? "";
        int n;
        if (int.TryParse(s.Trim(), out n)) return n + (n == 1 ? " month" : " months");
        return s;
    }

    public static bool IsEmail(string s)
    {
        return !string.IsNullOrEmpty(s) &&
               System.Text.RegularExpressions.Regex.IsMatch(s, @"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    }
}
