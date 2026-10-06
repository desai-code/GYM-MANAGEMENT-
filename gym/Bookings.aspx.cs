using System;
using System.Data;
using System.Data.OleDb;
using System.Web.UI.WebControls;

public partial class Bookings : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack) BindAll();
    }

    private void BindAll()
    {
        try
        {
            using (OleDbConnection con = DbHelper.GetConnection())
            {
                DataTable b = new DataTable();
                new OleDbDataAdapter(
                    "SELECT booking.id, member.fullname AS membername, booking.programname, booking.trainername, " +
                    "booking.bookingday, booking.bookingslot, booking.bookingdate " +
                    "FROM [booking] LEFT JOIN [member] ON booking.memberid = member.id ORDER BY booking.bookingdate DESC", con).Fill(b);
                gvBookings.DataSource = b;
                gvBookings.DataBind();
                lblBookingCount.Text = b.Rows.Count.ToString();

                DataTable o = new DataTable();
                new OleDbDataAdapter(
                    "SELECT orderitem.id, member.fullname AS membername, orderitem.supplementname, orderitem.price, " +
                    "orderitem.quantity, orderitem.orderdate " +
                    "FROM [orderitem] LEFT JOIN [member] ON orderitem.memberid = member.id ORDER BY orderitem.orderdate DESC", con).Fill(o);
                gvOrders.DataSource = o;
                gvOrders.DataBind();
                lblOrderCount.Text = o.Rows.Count.ToString();
            }
        }
        catch (Exception ex) { UiHelper.Fail(this, ex); }
    }

    protected void gvBookings_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvBookings.PageIndex = e.NewPageIndex;
        BindAll();
    }

    protected void gvOrders_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        gvOrders.PageIndex = e.NewPageIndex;
        BindAll();
    }
}
