<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Add_membership_plan.aspx.cs" Inherits="Add_membership_plan" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" Runat="Server">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&family=Oswald:wght@500;600;700&display=swap" rel="stylesheet" />

    <style type="text/css">
        :root {
            --accent: #f2a900;
            --accent-dark: #d99400;
            --ink: #f5f6f8;
            --accent-ink: #8a5f00;
            --text: #16171c;
            --panel: #ffffff;
            --panel-alt: #f3f4f7;
            --muted: #6b6d76;
            --border: #e6e8ec;
            --danger: #dc2626;
            --success: #16a34a;
            --radius: 14px;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            background: var(--ink);
        }

        .page-wrap {
            max-width: 900px;
            margin: 32px auto 60px;
            padding: 0 16px;
        }

        .top-strip {
            height: 4px;
            background: repeating-linear-gradient(90deg, var(--accent) 0 24px, transparent 24px 34px);
            opacity: .6;
            margin-bottom: 24px;
            border-radius: 4px;
        }

        .page-header {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 26px;
        }

        .page-header .icon-badge {
            width: 52px;
            height: 52px;
            border-radius: 12px;
            background: var(--accent);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #0d0d0f;
            font-size: 24px;
            box-shadow: 0 6px 18px rgba(242,169,0,.25);
            transform: rotate(-3deg);
        }

        .page-title {
            font-family: 'Oswald', sans-serif;
            font-size: 26px;
            font-weight: 700;
            letter-spacing: .03em;
            text-transform: uppercase;
            color: var(--text);
            display: block;
        }

        .page-header p {
            margin: 3px 0 0;
            color: var(--muted);
            font-size: 13.5px;
        }

        .card-panel {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: 0 10px 30px rgba(17,24,39,.10);
            padding: 30px 28px 24px;
            margin-bottom: 30px;
            position: relative;
            overflow: hidden;
        }

        .card-panel::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--accent), transparent 70%);
        }

        .field-label {
            font-weight: 600;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: .06em;
            color: #4b4d55;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .field-label .req {
            color: var(--accent-ink);
            font-weight: 700;
        }

        .form-control.admin-input {
            background: var(--panel-alt);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 11px 14px;
            font-size: 14px;
            color: var(--text);
            width: 100%;
            transition: border-color .15s, box-shadow .15s;
        }

        .form-control.admin-input::placeholder {
            color: #9a9ca6;
        }

        .form-control.admin-input:focus {
            background: var(--panel-alt);
            border-color: var(--accent-ink);
            box-shadow: 0 0 0 3px rgba(242,169,0,.15);
            color: var(--text);
            outline: none;
        }

        .input-prefix-group {
            position: relative;
        }

        .input-prefix-group .prefix {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--accent-ink);
            font-weight: 700;
            font-size: 14px;
            pointer-events: none;
        }

        .input-prefix-group .form-control.admin-input {
            padding-left: 30px;
        }

        .input-suffix-group {
            position: relative;
        }

        .input-suffix-group .suffix {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--muted);
            font-weight: 600;
            font-size: 12.5px;
            pointer-events: none;
        }

        .field-group {
            margin-bottom: 18px;
        }

        .validator-text {
            font-size: 12px;
            color: var(--danger) !important;
            display: block;
            margin-top: 5px;
        }

        .btn-admin-primary {
            background: var(--accent);
            border: none;
            color: #0d0d0f;
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            letter-spacing: .04em;
            text-transform: uppercase;
            padding: 12px 34px;
            border-radius: 10px;
            font-size: 14.5px;
            box-shadow: 0 6px 16px rgba(242,169,0,.3);
            transition: background .15s, transform .1s;
        }

        .btn-admin-primary:hover {
            background: var(--accent-dark);
            color: #0d0d0f;
        }

        .btn-admin-primary:active {
            transform: translateY(1px);
        }

        .btn-admin-primary i {
            margin-right: 8px;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 16px;
        }

        .list-title {
            font-family: 'Oswald', sans-serif;
            font-size: 19px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .03em;
            color: var(--text);
        }

        .section-title .bar {
            display: inline-block;
            width: 5px;
            height: 20px;
            background: var(--accent);
            margin-right: 10px;
            border-radius: 2px;
        }

        .badge-count {
            background: rgba(242,169,0,.12);
            color: var(--accent-ink);
            font-size: 12px;
            font-weight: 700;
            padding: 3px 12px;
            border-radius: 20px;
            border: 1px solid rgba(242,169,0,.25);
        }

        .grid-wrap {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(17,24,39,.07);
        }

        .admin-grid {
            width: 100%;
            border-collapse: collapse;
            font-size: 13.5px;
        }

        .admin-grid th {
            background: var(--panel-alt);
            color: var(--muted);
            font-weight: 700;
            text-transform: uppercase;
            font-size: 11px;
            letter-spacing: .06em;
            padding: 13px 16px;
            border-bottom: 1px solid var(--border);
            text-align: left;
        }

        .admin-grid td {
            padding: 13px 16px;
            border-bottom: 1px solid #eef0f3;
            color: #33343b;
            vertical-align: middle;
        }

        .admin-grid tr:last-child td {
            border-bottom: none;
        }

        .admin-grid tr:hover td {
            background: #fdf7e8;
        }

        .admin-grid a {
            font-size: 12.5px;
            font-weight: 700;
            text-decoration: none;
            padding: 5px 12px;
            border-radius: 7px;
            margin-right: 4px;
        }

        .plan-name-cell {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }

        .plan-icon {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            background: rgba(242,169,0,.12);
            color: var(--accent-ink);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
        }

        .price-tag {
            font-weight: 700;
            color: var(--accent-ink);
        }

        .duration-pill {
            font-size: 11.5px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 20px;
            background: rgba(22,163,74,.12);
            color: var(--success);
            border: 1px solid rgba(22,163,74,.25);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="page-wrap">

        <div class="top-strip"></div>

        <div class="page-header">
            <div class="icon-badge"><i class="bi bi-clipboard2-check-fill"></i></div>
            <div>
                <asp:Label ID="Label1" runat="server" CssClass="page-title" Text="Add Membership Plan Details"></asp:Label>
                <p>Create pricing plans members can subscribe to</p>
            </div>
        </div>

        <div class="card-panel">
            <asp:HiddenField ID="HiddenField1" runat="server" />

            <div class="row">
                <div class="col-md-4 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label2" runat="server" Text="Plan Name"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtplanname" CssClass="form-control admin-input" placeholder="e.g. Gold Membership" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                        ControlToValidate="txtplanname" ErrorMessage="Enter Plan Name"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-4 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label3" runat="server" Text="Plan Duration"></asp:Label>
                    </div>
                    <div class="input-suffix-group">
                        <asp:TextBox ID="txtplanduration" CssClass="form-control admin-input" placeholder="e.g. 3" runat="server"></asp:TextBox>
                        <span class="suffix">months</span>
                    </div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                        ControlToValidate="txtplanduration" ErrorMessage="Enter Plan Duration"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegexDuration" runat="server"
                        ControlToValidate="txtplanduration" ErrorMessage="Enter duration in months (whole number)"
                        CssClass="validator-text" Display="Dynamic" ValidationExpression="^\d{1,3}$"></asp:RegularExpressionValidator>
                </div>

                <div class="col-md-4 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label4" runat="server" Text="Price"></asp:Label>
                    </div>
                    <div class="input-prefix-group">
                        <span class="prefix">&#8377;</span>
                        <asp:TextBox ID="txtplanprice" CssClass="form-control admin-input" placeholder="Enter price" runat="server"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                        ControlToValidate="txtplanprice" ErrorMessage="Enter Plan Price"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegexPrice" runat="server"
                        ControlToValidate="txtplanprice" ErrorMessage="Enter a valid price (numbers only)"
                        CssClass="validator-text" Display="Dynamic" ValidationExpression="^\d{1,7}(\.\d{1,2})?$"></asp:RegularExpressionValidator>
                </div>
            </div>

            <div class="text-end mt-2">
                <asp:Button ID="btnaddplan" runat="server" CssClass="btn btn-admin-primary" Text="Add Plan"
                    OnClick="Button1_Click" />
            </div>
        </div>

        <div class="section-title">
            <h2 class="list-title"><span class="bar"></span><asp:Label ID="Label8" runat="server" Text="Membership Plans"></asp:Label></h2>
        </div>

        <div class="grid-wrap">
            <asp:GridView ID="GridView1" runat="server"
                CssClass="admin-grid"
                GridLines="None"
                AllowPaging="True" PageSize="10"
                AutoGenerateColumns="False" AutoGenerateDeleteButton="True"
                AutoGenerateSelectButton="True"
                OnSelectedIndexChanging="GridView1_SelectedIndexChanging"
                OnPageIndexChanging="GridView1_PageIndexChanging"
                OnRowDataBound="GridView1_RowDataBound"
                OnRowDeleting="GridView1_RowDeleting">
                <Columns>
                    <asp:TemplateField HeaderText="ID">
                        <ItemTemplate>
                            <asp:Label ID="lblid" runat="server" Text='<%#Eval("id") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="PLAN NAME">
                        <ItemTemplate>
                            <div class="plan-name-cell">
                                <span class="plan-icon"><i class="bi bi-star-fill"></i></span>
                                <asp:Label ID="lblplanname" runat="server" Text='<%#Eval("planname") %>'></asp:Label>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="MEMBERSHIP DURATION">
                        <ItemTemplate>
                            <asp:Label ID="lblmembershipduration" runat="server" Text='<%#Eval("membershipduration") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="PRICE">
                        <ItemTemplate>
                            <asp:Label ID="lblprice" runat="server" CssClass="price-tag" Text='<%#Eval("price") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerStyle CssClass="p-2" />
            </asp:GridView>
        </div>

    </div>
</asp:Content>
