<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Bookings.aspx.cs" Inherits="Bookings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Oswald:wght@500;600;700&display=swap" rel="stylesheet" />

    <style type="text/css">
        :root {
            --accent: #f2a900; --accent-dark: #d99400; --ink: #f5f6f8; --accent-ink: #8a5f00;
            --text: #16171c; --panel: #ffffff; --panel-alt: #f3f4f7; --muted: #6b6d76;
            --border: #e6e8ec; --danger: #dc2626; --success: #16a34a; --radius: 14px;
        }
        body { font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif; background: var(--ink); }
        .page-wrap { max-width: 980px; margin: 32px auto 60px; padding: 0 16px; }
        .top-strip { height: 4px; background: repeating-linear-gradient(90deg, var(--accent) 0 24px, transparent 24px 34px); opacity: .6; margin-bottom: 24px; border-radius: 4px; }
        .page-header { display: flex; align-items: center; gap: 16px; margin-bottom: 26px; }
        .page-header .icon-badge { width: 52px; height: 52px; border-radius: 12px; background: var(--accent); display: flex; align-items: center; justify-content: center; color: #0d0d0f; font-size: 24px; box-shadow: 0 6px 18px rgba(242,169,0,.25); transform: rotate(-3deg); }
        .page-title { font-family: 'Oswald', sans-serif; font-size: 26px; font-weight: 700; letter-spacing: .03em; text-transform: uppercase; color: var(--text); display: block; }
        .page-header p { margin: 3px 0 0; color: var(--muted); font-size: 13.5px; }
        .card-panel { background: var(--panel); border: 1px solid var(--border); border-radius: var(--radius); box-shadow: 0 10px 30px rgba(17,24,39,.10); padding: 30px 28px 24px; margin-bottom: 30px; position: relative; overflow: hidden; }
        .card-panel::before { content: ""; position: absolute; top: 0; left: 0; right: 0; height: 3px; background: linear-gradient(90deg, var(--accent), transparent 70%); }
        .field-label { font-weight: 600; font-size: 12px; text-transform: uppercase; letter-spacing: .06em; color: #4b4d55; margin-bottom: 8px; display: flex; align-items: center; gap: 4px; }
        .field-label .req { color: var(--accent-ink); font-weight: 700; }
        .form-control.admin-input { background: var(--panel-alt); border: 1px solid var(--border); border-radius: 10px; padding: 11px 14px; font-size: 14px; color: var(--text); width: 100%; }
        .form-control.admin-input:focus { border-color: var(--accent-ink); box-shadow: 0 0 0 3px rgba(242,169,0,.15); outline: none; }
        .field-group { margin-bottom: 18px; }
        .input-prefix-group { position: relative; }
        .input-prefix-group .prefix { position: absolute; left: 14px; top: 50%; transform: translateY(-50%); color: var(--accent-ink); font-weight: 700; font-size: 14px; pointer-events: none; }
        .input-prefix-group .form-control.admin-input { padding-left: 30px; }
        .validator-text { font-size: 12px; color: var(--danger) !important; display: block; margin-top: 5px; }
        .btn-admin-primary { background: var(--accent); border: none; color: #0d0d0f; font-weight: 700; font-family: 'Oswald', sans-serif; letter-spacing: .04em; text-transform: uppercase; padding: 12px 34px; border-radius: 10px; font-size: 14.5px; box-shadow: 0 6px 16px rgba(242,169,0,.3); }
        .btn-admin-primary:hover { background: var(--accent-dark); color: #0d0d0f; }
        .btn-admin-primary i { margin-right: 8px; }
        .section-title { display: flex; align-items: center; gap: 10px; margin: 0 0 16px; }
        .list-title { font-family: 'Oswald', sans-serif; font-size: 19px; font-weight: 600; text-transform: uppercase; letter-spacing: .03em; color: var(--text); }
        .section-title .bar { display: inline-block; width: 5px; height: 20px; background: var(--accent); margin-right: 10px; border-radius: 2px; }
        .grid-wrap { background: var(--panel); border: 1px solid var(--border); border-radius: var(--radius); overflow-x: auto; box-shadow: 0 10px 30px rgba(17,24,39,.07); }
        .admin-grid { width: 100%; min-width: 900px; border-collapse: collapse; font-size: 13.5px; }
        .admin-grid th { background: var(--panel-alt); color: var(--muted); font-weight: 700; text-transform: uppercase; font-size: 11px; letter-spacing: .06em; padding: 13px 16px; border-bottom: 1px solid var(--border); text-align: left; white-space: nowrap; }
        .admin-grid td { padding: 10px 16px; border-bottom: 1px solid #eef0f3; color: #33343b; vertical-align: middle; }
        .admin-grid tr:hover td { background: #fdf7e8; }
        .admin-grid a { font-size: 12.5px; font-weight: 700; text-decoration: none; padding: 5px 12px; border-radius: 7px; margin-right: 4px; }
        .prod-thumb { width: 36px; height: 36px; border-radius: 8px; object-fit: cover; border: 2px solid var(--accent); background: #fff; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="page-wrap">
        <div class="top-strip"></div>

        <div class="page-header">
            <div class="icon-badge"><i class="bi bi-calendar2-check-fill"></i></div>
            <div>
                <asp:Label ID="Label1" runat="server" CssClass="page-title" Text="Bookings &amp; Orders"></asp:Label>
                <p>Sessions booked and supplements ordered by members on the client site</p>
            </div>
        </div>

        <div class="section-title">
            <h2 class="list-title"><span class="bar"></span>Program Bookings (<asp:Label ID="lblBookingCount" runat="server" Text="0"></asp:Label>)</h2>
        </div>
        <div class="grid-wrap" style="margin-bottom:30px;">
            <asp:GridView ID="gvBookings" runat="server" CssClass="admin-grid" GridLines="None"
                AllowPaging="True" PageSize="10" AutoGenerateColumns="False"
                EmptyDataText="No sessions have been booked yet."
                OnPageIndexChanging="gvBookings_PageIndexChanging">
                <Columns>
                    <asp:BoundField DataField="id" HeaderText="ID" />
                    <asp:BoundField DataField="membername" HeaderText="MEMBER" />
                    <asp:BoundField DataField="programname" HeaderText="PROGRAM" />
                    <asp:BoundField DataField="trainername" HeaderText="TRAINER" />
                    <asp:BoundField DataField="bookingday" HeaderText="DAY" />
                    <asp:BoundField DataField="bookingslot" HeaderText="TIME" />
                    <asp:BoundField DataField="bookingdate" HeaderText="BOOKED ON" DataFormatString="{0:dd MMM yyyy, hh:mm tt}" HtmlEncode="false" />
                </Columns>
                <PagerStyle CssClass="p-2" />
            </asp:GridView>
        </div>

        <div class="section-title">
            <h2 class="list-title"><span class="bar"></span>Supplement Orders (<asp:Label ID="lblOrderCount" runat="server" Text="0"></asp:Label>)</h2>
        </div>
        <div class="grid-wrap">
            <asp:GridView ID="gvOrders" runat="server" CssClass="admin-grid" GridLines="None"
                AllowPaging="True" PageSize="10" AutoGenerateColumns="False"
                EmptyDataText="No supplement orders yet."
                OnPageIndexChanging="gvOrders_PageIndexChanging">
                <Columns>
                    <asp:BoundField DataField="id" HeaderText="ID" />
                    <asp:BoundField DataField="membername" HeaderText="MEMBER" />
                    <asp:BoundField DataField="supplementname" HeaderText="PRODUCT" />
                    <asp:BoundField DataField="price" HeaderText="PRICE (&#8377;)" DataFormatString="{0:N2}" HtmlEncode="false" />
                    <asp:BoundField DataField="quantity" HeaderText="QTY" />
                    <asp:BoundField DataField="orderdate" HeaderText="ORDERED ON" DataFormatString="{0:dd MMM yyyy, hh:mm tt}" HtmlEncode="false" />
                </Columns>
                <PagerStyle CssClass="p-2" />
            </asp:GridView>
        </div>
    </div>
</asp:Content>
