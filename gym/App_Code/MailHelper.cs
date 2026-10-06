using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.Net;
using System.Net.Mail;
using System.Text;
using System.Web;

/// <summary>One purchased supplement line (used for the order e-mail).</summary>
public class OrderLine
{
    public string Name;
    public decimal Price;
    public int Quantity;
    public decimal Total { get { return Price * Quantity; } }
}

/// <summary>Sends the "New supplement order" e-mail to the gym owner. Never throws; returns true only if the mail was sent.</summary>
public static class MailHelper
{
    private static string Money(decimal v)
    {
        return "\u20B9" + v.ToString("N2", new CultureInfo("en-IN"));
    }

    public static bool SendOrderNotification(string customerName, List<OrderLine> lines)
    {
        try
        {
            string to = ConfigurationManager.AppSettings["OrderNotifyTo"];
            if (string.IsNullOrEmpty(to) || lines == null || lines.Count == 0) return false;

            decimal grand = 0;
            StringBuilder rows = new StringBuilder();
            foreach (OrderLine l in lines)
            {
                grand += l.Total;
                rows.Append("<tr>")
                    .Append("<td style='padding:8px;border:1px solid #ddd'>").Append(HttpUtility.HtmlEncode(l.Name)).Append("</td>")
                    .Append("<td style='padding:8px;border:1px solid #ddd;text-align:center'>").Append(l.Quantity).Append("</td>")
                    .Append("<td style='padding:8px;border:1px solid #ddd;text-align:right'>").Append(Money(l.Price)).Append("</td>")
                    .Append("<td style='padding:8px;border:1px solid #ddd;text-align:right'>").Append(Money(l.Total)).Append("</td>")
                    .Append("</tr>");
            }

            string body =
                "<div style='font-family:Arial,sans-serif;max-width:600px'>" +
                "<h2 style='background:#f2a900;margin:0;padding:14px'>New Supplement Order</h2>" +
                "<p><b>Customer:</b> " + HttpUtility.HtmlEncode(customerName) + "<br/>" +
                "<b>Date:</b> " + DateTime.Now.ToString("dd MMM yyyy, hh:mm tt") + "</p>" +
                "<table style='border-collapse:collapse;width:100%'>" +
                "<tr style='background:#f3f4f7'><th style='padding:8px;border:1px solid #ddd;text-align:left'>Supplement</th>" +
                "<th style='padding:8px;border:1px solid #ddd'>Qty</th>" +
                "<th style='padding:8px;border:1px solid #ddd;text-align:right'>Price</th>" +
                "<th style='padding:8px;border:1px solid #ddd;text-align:right'>Amount</th></tr>" +
                rows +
                "<tr><td colspan='3' style='padding:8px;text-align:right'><b>Total Amount</b></td>" +
                "<td style='padding:8px;text-align:right'><b>" + Money(grand) + "</b></td></tr>" +
                "</table></div>";

            // Gmail needs TLS 1.2 (3072 = Tls12). Safe to set; ignored if already higher.
            ServicePointManager.SecurityProtocol = ServicePointManager.SecurityProtocol | (SecurityProtocolType)3072;

            using (MailMessage msg = new MailMessage())
            {
                msg.To.Add(to);                       // From comes from <system.net><mailSettings> in Web.config
                msg.Subject = "New Supplement Order - " + customerName + " (" + Money(grand) + ")";
                msg.Body = body;
                msg.IsBodyHtml = true;
                SmtpClient smtp = new SmtpClient();   // host / port / user / password also from Web.config
                smtp.Timeout = 15000;
                smtp.Send(msg);
            }
            return true;      // mail really left the server
        }
        catch (Exception ex)
        {
            DbHelper.Log(ex);
            return false;
        }
    }
}
