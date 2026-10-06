<%@ Page Title="" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true" CodeFile="Add_trainer_Info.aspx.cs" Inherits="Add_trainer_Info" %>

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
            max-width: 980px;
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

        .photo-upload-box {
            background: var(--panel-alt);
            border: 1.5px dashed var(--border);
            border-radius: 10px;
            padding: 16px;
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .photo-preview {
            width: 56px;
            height: 56px;
            border-radius: 10px;
            object-fit: cover;
            background: #eef0f3;
            border: 1px solid var(--border);
        }

        .photo-upload-box input[type=file] {
            color: var(--muted);
            font-size: 13px;
        }

        .photo-upload-box input[type=file]::file-selector-button {
            background: var(--accent);
            color: #0d0d0f;
            border: none;
            padding: 7px 14px;
            border-radius: 8px;
            font-weight: 700;
            font-size: 12.5px;
            margin-right: 12px;
            cursor: pointer;
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
            overflow-x: auto;
            box-shadow: 0 10px 30px rgba(17,24,39,.07);
        }

        .admin-grid {
            width: 100%;
            min-width: 900px;
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
            padding: 10px 16px;
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

        .trainer-name-cell {
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }

        .trainer-avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--accent);
        }

        .trainer-avatar-fallback {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: rgba(242,169,0,.15);
            color: var(--accent-ink);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 12.5px;
        }

        .spec-pill {
            font-size: 11.5px;
            font-weight: 700;
            padding: 3px 10px;
            border-radius: 20px;
            background: rgba(110,168,255,.12);
            color: #2563eb;
            border: 1px solid rgba(110,168,255,.25);
        }

        .salary-tag {
            font-weight: 700;
            color: var(--accent-ink);
        }

        .exp-pill {
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
            <div class="icon-badge"><i class="bi bi-person-badge-fill"></i></div>
            <div>
                <asp:Label ID="Label1" runat="server" CssClass="page-title" Text="Add Trainer's Information"></asp:Label>
                <p>Add a new trainer to the gym staff roster</p>
            </div>
        </div>

        <div class="card-panel">
            <asp:HiddenField ID="HiddenField1" runat="server" />

            <div class="row">
                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label2" runat="server" Text="Trainer Name"></asp:Label>
                    </div>
                    <asp:TextBox ID="txttrainername" CssClass="form-control admin-input" placeholder="Enter trainer name" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server"
                        ControlToValidate="txttrainername" ErrorMessage="Enter Trainer Name"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label3" runat="server" Text="Specialization"></asp:Label>
                    </div>
                    <asp:TextBox ID="txttrainerspecialization" CssClass="form-control admin-input" placeholder="e.g. Strength & Conditioning" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server"
                        ControlToValidate="txttrainerspecialization" ErrorMessage="Enter Specialization"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label4" runat="server" Text="Phone"></asp:Label>
                    </div>
                    <asp:TextBox ID="txttrainerphone" CssClass="form-control admin-input" placeholder="Enter mobile number" runat="server"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server"
                        ControlToValidate="txttrainerphone" ErrorMessage="Enter Phone No."
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegexPhone" runat="server"
                        ControlToValidate="txttrainerphone" ErrorMessage="Enter a valid phone number (7-15 digits)"
                        CssClass="validator-text" Display="Dynamic" ValidationExpression="^[0-9+\-\s]{7,15}$"></asp:RegularExpressionValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label5" runat="server" Text="Salary"></asp:Label>
                    </div>
                    <div class="input-prefix-group">
                        <span class="prefix">&#8377;</span>
                        <asp:TextBox ID="txtsalary" CssClass="form-control admin-input" placeholder="Enter monthly salary" runat="server"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server"
                        ControlToValidate="txtsalary" ErrorMessage="Enter Salary"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegexSalary" runat="server"
                        ControlToValidate="txtsalary" ErrorMessage="Enter salary as a number"
                        CssClass="validator-text" Display="Dynamic" ValidationExpression="^\d{1,8}(\.\d{1,2})?$"></asp:RegularExpressionValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <span class="req">*</span>
                        <asp:Label ID="Label6" runat="server" Text="Experience"></asp:Label>
                    </div>
                    <div class="input-suffix-group">
                        <asp:TextBox ID="txtexperirence" CssClass="form-control admin-input" placeholder="e.g. 3" runat="server"></asp:TextBox>
                        <span class="suffix">years</span>
                    </div>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server"
                        ControlToValidate="txtexperirence" ErrorMessage="Enter Exprerience"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                    <asp:RegularExpressionValidator ID="RegexExp" runat="server"
                        ControlToValidate="txtexperirence" ErrorMessage="Enter experience in years (number)"
                        CssClass="validator-text" Display="Dynamic" ValidationExpression="^\d{1,2}(\.\d)?$"></asp:RegularExpressionValidator>
                </div>

                <div class="col-md-6 field-group">
                    <div class="field-label">
                        <asp:Label ID="Label15" runat="server" Text="Photo"></asp:Label>
                    </div>
                    <div class="photo-upload-box">
                        <asp:Image ID="Image1" runat="server" CssClass="photo-preview" Visible="false" />
                        <asp:FileUpload ID="fuphoto" runat="server" />
                    </div>
                </div>
            </div>

            <div class="text-end mt-2">
                <asp:Button ID="btnaddtrainer" runat="server" CssClass="btn btn-admin-primary" Text="Add Trainer"
                    OnClick="Button1_Click" />
            </div>
        </div>

        <div class="section-title">
            <h2 class="list-title"><span class="bar"></span><asp:Label ID="Label14" runat="server" Text="Trainer Info"></asp:Label></h2>
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

                    <asp:TemplateField HeaderText="PHOTO">
                        <ItemTemplate>
                            <asp:Image ID="lblfphoto" runat="server" CssClass="trainer-avatar" ImageUrl='<%# PhotoUrl(Eval("photo")) %>' />
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="NAME">
                        <ItemTemplate>
                            <asp:Label ID="lbltrainername" runat="server" Text='<%#Eval("trainername") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="SPECIALIZATION">
                        <ItemTemplate>
                            <asp:Label ID="lblspecialization" runat="server" Text='<%#Eval("specialization") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="PHONE No">
                        <ItemTemplate>
                            <asp:Label ID="lblphoneno" runat="server" Text='<%#Eval("phoneno") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="SALARY">
                        <ItemTemplate>
                            <asp:Label ID="lblsalary" runat="server" CssClass="salary-tag" Text='<%#Eval("salary") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>

                    <asp:TemplateField HeaderText="EXPERIENCE">
                        <ItemTemplate>
                            <asp:Label ID="lblexprerience" runat="server" Text='<%#Eval("exprerience") %>'></asp:Label>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <PagerStyle CssClass="p-2" />
            </asp:GridView>
        </div>

    </div>
</asp:Content>
