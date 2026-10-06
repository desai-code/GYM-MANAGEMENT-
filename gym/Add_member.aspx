<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Add_member.aspx.cs" Inherits="Add_member" %>

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
            max-width: 1040px;
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

        .page-header h1 {
            font-family: 'Oswald', sans-serif;
            font-size: 26px;
            font-weight: 700;
            letter-spacing: .03em;
            text-transform: uppercase;
            color: var(--text);
            margin: 0;
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

        .subsection-label {
            font-family: 'Oswald', sans-serif;
            font-size: 12.5px;
            font-weight: 600;
            letter-spacing: .08em;
            text-transform: uppercase;
            color: var(--accent-ink);
            margin: 4px 0 14px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--border);
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

        .form-control.admin-input,
        .form-select.admin-input {
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

        .form-control.admin-input:focus,
        .form-select.admin-input:focus {
            background: var(--panel-alt);
            border-color: var(--accent-ink);
            box-shadow: 0 0 0 3px rgba(242,169,0,.15);
            color: var(--text);
            outline: none;
        }

        textarea.admin-input {
            min-height: 84px;
            resize: vertical;
        }

        .form-select.admin-input option {
            background: var(--panel-alt);
            color: var(--text);
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

        .section-title h2 {
            font-family: 'Oswald', sans-serif;
            font-size: 19px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .03em;
            color: var(--text);
            margin: 0;
            display: flex;
            align-items: center;
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
            overflow-x: auto;
            box-shadow: 0 10px 30px rgba(17,24,39,.07);
        }

        .admin-grid {
            width: 100%;
            min-width: 1100px;
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
            white-space: nowrap;
        }

        .admin-grid td {
            padding: 13px 16px;
            border-bottom: 1px solid #eef0f3;
            color: #33343b;
            vertical-align: middle;
            white-space: nowrap;
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

        .gender-pill {
            font-size: 11.5px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 20px;
        }

        .gender-male { background: rgba(79,140,255,.12); color: #2563eb; border: 1px solid rgba(79,140,255,.25); }
        .gender-female { background: rgba(255,110,199,.12); color: #db2777; border: 1px solid rgba(255,110,199,.25); }

        .page-title {
            font-family: 'Oswald', sans-serif;
            font-size: 26px;
            font-weight: 700;
            letter-spacing: .03em;
            text-transform: uppercase;
            color: var(--text);
            display: block;
        }

        .list-title {
            font-family: 'Oswald', sans-serif;
            font-size: 19px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .03em;
            color: var(--text);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="page-wrap">

        <div class="top-strip"></div>

        <div class="page-header">
            <div class="icon-badge"><i class="bi bi-person-vcard-fill"></i></div>
            <div>
                <asp:Label ID="Label1" runat="server" CssClass="page-title" Text="Add New Member"></asp:Label>
                <p>Register a new member to the gym</p>
            </div>
        </div>

        <div class="card-panel">
            <asp:HiddenField ID="HiddenField1" runat="server" />

            <div class="subsection-label">Personal Details</div>
            <div class="row">
                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label2" runat="server" Text="Member Name"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtmemname" CssClass="form-control admin-input" placeholder="Enter full name" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                        ControlToValidate="txtmemname" ErrorMessage="Enter Member Name"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label3" runat="server" Text="Email"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtmememail" CssClass="form-control admin-input" placeholder="member@gym.com" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                        ControlToValidate="txtmememail" ErrorMessage="Enter Email"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server"
                        ControlToValidate="txtmememail" ErrorMessage="Invalid Email Format"
                        CssClass="validator-text" Display="Dynamic"
                        ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <asp:Label ID="Label4" runat="server" Text="Date Of Birth"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtmemdob" CssClass="form-control admin-input" runat="server" type="date"></asp:TextBox>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label5" runat="server" Text="Mobile No"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtmemmobile" CssClass="form-control admin-input" placeholder="Enter mobile number" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                        ControlToValidate="txtmemmobile" ErrorMessage="Enter Mobile No"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegexMobile" runat="server"
                        ControlToValidate="txtmemmobile" ErrorMessage="Enter a valid mobile number (7-15 digits)"
                        CssClass="validator-text" Display="Dynamic" ValidationExpression="^[0-9+\-\s]{7,15}$"></asp:RegularExpressionValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label6" runat="server" Text="Gender"></asp:Label>
                    </div>
                    <asp:DropDownList ID="ddlmemgender" CssClass="form-select admin-input" runat="server">
                        <asp:ListItem>Select Gender</asp:ListItem>
                        <asp:ListItem>Male</asp:ListItem>
                        <asp:ListItem>Female</asp:ListItem>
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                        ControlToValidate="ddlmemgender" InitialValue="Select Gender" ErrorMessage="Select Gender"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label8" runat="server" Text="Join date"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtmemjoindate" CssClass="form-control admin-input" runat="server" type="date"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                        ControlToValidate="txtmemjoindate" ErrorMessage="Enter Joining Date"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="LabelPwd" runat="server" Text="Login Password"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtmempassword" CssClass="form-control admin-input" placeholder="Password the member will use to log in" runat="server" TextMode="Password"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidatorPwd" runat="server"
                        ControlToValidate="txtmempassword" ErrorMessage="Enter a password for the member (min 6 characters)"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </div>

                <div class="col-12 field-group">
                    <div class="field-label">
                        <asp:Label ID="Label7" runat="server" Text="Address"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtmemaddress" CssClass="form-control admin-input" placeholder="Enter address" runat="server" TextMode="MultiLine"></asp:TextBox>
                </div>
            </div>

            <div class="subsection-label">Fitness Details</div>
            <div class="row">
                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label9" runat="server" Text="Height (cm)"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtmemheight" CssClass="form-control admin-input" placeholder="e.g. 175" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server"
                        ControlToValidate="txtmemheight" ErrorMessage="Enter Height"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegexHeight" runat="server"
                        ControlToValidate="txtmemheight" ErrorMessage="Enter height in cm (numbers only)"
                        CssClass="validator-text" Display="Dynamic" ValidationExpression="^\d{2,3}(\.\d{1,2})?$"></asp:RegularExpressionValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label10" runat="server" Text="Weight (kg)"></asp:Label>
                    </div>
                    <asp:TextBox ID="txtmemweight" CssClass="form-control admin-input" placeholder="e.g. 70" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server"
                        ControlToValidate="txtmemweight" ErrorMessage="Enter Weight"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegexWeight" runat="server"
                        ControlToValidate="txtmemweight" ErrorMessage="Enter weight in kg (numbers only)"
                        CssClass="validator-text" Display="Dynamic" ValidationExpression="^\d{2,3}(\.\d{1,2})?$"></asp:RegularExpressionValidator>
                </div>
            </div>

            <div class="text-end mt-2">
                <asp:Button ID="btnaddmember" runat="server" CssClass="btn btn-admin-primary" Text="Add Member"
                    OnClick="Button1_Click" />
            </div>
        </div>

        <div class="section-title">
            <h2><span class="bar"></span><asp:Label ID="Label18" runat="server" CssClass="list-title" Text="Members List"></asp:Label></h2>
            <asp:Label ID="lblSearchInfo" runat="server" CssClass="ms-3 small text-muted"></asp:Label>
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

                    <asp:TemplateField HeaderText="NAME">
                        <ItemTemplate>
                            <asp:Label ID="lblfullname" runat="server" Text='<%#Eval("fullname") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="E-MAIL">
                        <ItemTemplate>
                            <asp:Label ID="lblemail" runat="server" Text='<%#Eval("email") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="DATE OF BIRTH">
                        <ItemTemplate>
                            <asp:Label ID="lbldateofbirth" runat="server" Text='<%#Eval("dateofbirth") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="MOBILE NO">
                        <ItemTemplate>
                            <asp:Label ID="lblmobileno" runat="server" Text='<%#Eval("mobileno") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="GENDER">
                        <ItemTemplate>
                            <asp:Label ID="lblgender" runat="server" Text='<%#Eval("gender") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="JOIN DATE">
                        <ItemTemplate>
                            <asp:Label ID="lbljoindate" runat="server" Text='<%#Eval("joindate") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="HEIGHT">
                        <ItemTemplate>
                            <asp:Label ID="lblheight" runat="server" Text='<%#Eval("height") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="WEIGHT">
                        <ItemTemplate>
                            <asp:Label ID="lblweight" runat="server" Text='<%#Eval("weight") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="ADDRESS">
                        <ItemTemplate>
                            <asp:Label ID="lbladdress" runat="server" Text='<%#Eval("address") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="PLAN">
                        <ItemTemplate>
                            <asp:Label ID="lblplan" runat="server" Text='<%#Eval("planname") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="LAST LOGIN">
                        <ItemTemplate>
                            <asp:Label ID="lbllast" runat="server" Text='<%#Eval("lastlogin") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerStyle CssClass="p-2" />
            </asp:GridView>
        </div>

    </div>
</asp:Content>
