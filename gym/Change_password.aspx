<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Change_password.aspx.cs" Inherits="Change_password" %>

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
            max-width: 480px;
            margin: 60px auto 80px;
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
            text-align: center;
            margin-bottom: 26px;
        }

        .page-header .icon-badge {
            width: 56px;
            height: 56px;
            border-radius: 14px;
            background: var(--accent);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #0d0d0f;
            font-size: 26px;
            box-shadow: 0 6px 18px rgba(242,169,0,.25);
            margin: 0 auto 14px;
            transform: rotate(-3deg);
        }

        .page-title {
            font-family: 'Oswald', sans-serif;
            font-size: 24px;
            font-weight: 700;
            letter-spacing: .03em;
            text-transform: uppercase;
            color: var(--text);
            display: block;
        }

        .page-header p {
            margin: 6px 0 0;
            color: var(--muted);
            font-size: 13.5px;
        }

        .card-panel {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            box-shadow: 0 10px 30px rgba(17,24,39,.10);
            padding: 32px 28px 26px;
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

        .field-group {
            margin-bottom: 18px;
        }

        .hint-text {
            font-size: 12px;
            color: var(--muted);
            margin-top: 5px;
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
            padding: 12px 0;
            border-radius: 10px;
            font-size: 14.5px;
            width: 100%;
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
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="page-wrap">

        <div class="top-strip"></div>

        <div class="page-header">
            <div class="icon-badge"><i class="bi bi-shield-lock-fill"></i></div>
            <asp:Label ID="Label1" runat="server" CssClass="page-title" Text="Change Password"></asp:Label>
            <p>Update the login credentials for this account</p>
        </div>

        <div class="card-panel">

            <div class="field-group">
                <div class="field-label">
                    <span class="req">*</span>
                    <asp:Label ID="Label2" runat="server" Text="Email"></asp:Label>
                </div>
                <asp:TextBox ID="txtcemail" CssClass="form-control admin-input" placeholder="Enter email" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                    ControlToValidate="txtcemail" ErrorMessage="Enter Email"
                    CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                    ControlToValidate="txtcemail" ErrorMessage="Invalid Email Format"
                    CssClass="validator-text" Display="Dynamic"
                    ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
            </div>

            <div class="field-group">
                <div class="field-label">
                    <span class="req">*</span>
                    <asp:Label ID="Label3" runat="server" Text="New Password"></asp:Label>
                </div>
                <asp:TextBox ID="txtnpassword" CssClass="form-control admin-input" placeholder="Enter new password" runat="server" TextMode="Password"></asp:TextBox>
                <div class="hint-text">Minimum 8 characters</div>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                    ControlToValidate="txtnpassword" ErrorMessage="Enter Password"
                    CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
            </div>

            <div class="field-group">
                <div class="field-label">
                    <span class="req">*</span>
                    <asp:Label ID="Label4" runat="server" Text="Confirm Password"></asp:Label>
                </div>
                <asp:TextBox ID="txtccpassword" CssClass="form-control admin-input" placeholder="Re-enter new password" runat="server" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                    ControlToValidate="txtccpassword" ErrorMessage="Enter Confirm Password"
                    CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                <asp:CompareValidator ID="CompareValidator2" runat="server"
                    ControlToCompare="txtnpassword" ControlToValidate="txtccpassword"
                    ErrorMessage="Passwords do not match" CssClass="validator-text" Display="Dynamic"></asp:CompareValidator>
            </div>

            <asp:Label ID="lblMsg" runat="server" CssClass="d-block mb-3" Text=""></asp:Label>

            <div class="mt-2">
                <asp:Button ID="btnchangepassword" runat="server" CssClass="btn btn-admin-primary" Text="Change Password" OnClick="btnchangepassword_Click" />
            </div>

        </div>
    </div>
</asp:Content>
