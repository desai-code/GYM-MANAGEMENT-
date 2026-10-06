<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style type="text/css">
        .dash-wrap {
            max-width: 1100px;
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

        .hero-banner {
            background: linear-gradient(120deg, var(--panel) 0%, var(--panel-alt) 100%);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 30px 32px;
            margin-bottom: 32px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(17,24,39,.10);
        }

        .hero-banner::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, var(--accent), transparent 70%);
        }

        .hero-banner::after {
            content: "\f0e7";
            font-family: "bootstrap-icons";
            position: absolute;
            right: 24px;
            bottom: -18px;
            font-size: 130px;
            color: rgba(242,169,0,.05);
        }

        .hero-eyebrow {
            font-family: 'Oswald', sans-serif;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: .12em;
            text-transform: uppercase;
            color: var(--accent-ink);
            margin-bottom: 8px;
        }

        .hero-banner h2 {
            font-family: 'Oswald', sans-serif;
            font-size: 30px;
            font-weight: 700;
            letter-spacing: .02em;
            text-transform: uppercase;
            color: var(--text);
            margin: 0 0 8px;
        }

        .hero-banner p {
            color: var(--muted);
            font-size: 14.5px;
            margin: 0;
            max-width: 560px;
        }

        .section-title {
            display: flex;
            align-items: center;
            gap: 10px;
            margin: 0 0 16px;
        }

        .section-title h3 {
            font-family: 'Oswald', sans-serif;
            font-size: 17px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: .03em;
            color: var(--text);
            margin: 0;
        }

        .section-title .bar {
            display: inline-block;
            width: 5px;
            height: 18px;
            background: var(--accent);
            border-radius: 2px;
        }

        .stat-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 36px;
        }

        @media (max-width: 900px) {
            .stat-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 520px) {
            .stat-grid { grid-template-columns: 1fr; }
        }

        .stat-card {
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 22px 20px;
            position: relative;
            overflow: hidden;
            box-shadow: 0 8px 22px rgba(17,24,39,.07);
            transition: transform .15s, border-color .15s;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            border-color: rgba(242,169,0,.35);
        }

        .stat-card .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: 11px;
            background: rgba(242,169,0,.12);
            color: var(--accent-ink);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 16px;
        }

        .stat-card .stat-value {
            font-family: 'Oswald', sans-serif;
            font-size: 32px;
            font-weight: 700;
            color: var(--text);
            line-height: 1;
            margin-bottom: 6px;
        }

        .stat-card .stat-label {
            font-size: 12.5px;
            font-weight: 600;
            letter-spacing: .04em;
            text-transform: uppercase;
            color: var(--muted);
        }

        .stat-card.accent-blue .stat-icon { background: rgba(110,168,255,.12); color: #2563eb; }
        .stat-card.accent-pink .stat-icon { background: rgba(255,110,199,.12); color: #db2777; }
        .stat-card.accent-green .stat-icon { background: rgba(22,163,74,.12); color: var(--success); }

        .quick-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
        }

        @media (max-width: 900px) {
            .quick-grid { grid-template-columns: repeat(2, 1fr); }
        }

        @media (max-width: 520px) {
            .quick-grid { grid-template-columns: 1fr; }
        }

        .quick-link {
            min-width: 0;
            background: var(--panel);
            border: 1px solid var(--border);
            border-radius: var(--radius);
            padding: 20px;
            display: flex;
            align-items: center;
            gap: 14px;
            text-decoration: none;
            transition: border-color .15s, background .15s, transform .15s;
        }

        .quick-link:hover {
            border-color: var(--accent-ink);
            background: var(--panel-alt);
            transform: translateY(-2px);
        }

        .quick-link .quick-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: var(--accent);
            color: #0d0d0f;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            flex-shrink: 0;
        }

        .quick-link .quick-text strong {
            display: block;
            color: var(--text);
            font-size: 13.5px;
            font-weight: 700;
        }

        .quick-link .quick-text span {
            color: var(--muted);
            font-size: 12px;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="dash-wrap">

        <div class="top-strip"></div>

        <div class="hero-banner">
            <div class="hero-eyebrow">Admin Centre</div>
            <h2>Welcome back, Coach</h2>
            <p>Here's a snapshot of Haathi Fitness right now — members, staff and plans, all in one place.</p>
        </div>

        <div class="section-title">
            <span class="bar"></span>
            <h3>Overview</h3>
        </div>

        <div class="stat-grid">
            <div class="stat-card">
                <div class="stat-icon"><i class="bi bi-shield-fill-check"></i></div>
                <asp:Label ID="Label3" runat="server" CssClass="stat-value" Text="10"></asp:Label>
                <div class="stat-label"><asp:Label ID="Label1" runat="server" Text="Admins"></asp:Label></div>
            </div>

            <div class="stat-card accent-blue">
                <div class="stat-icon"><i class="bi bi-person-vcard-fill"></i></div>
                <asp:Label ID="Label4" runat="server" CssClass="stat-value" Text="100"></asp:Label>
                <div class="stat-label"><asp:Label ID="Label2" runat="server" Text="Members"></asp:Label></div>
            </div>

            <div class="stat-card accent-green">
                <div class="stat-icon"><i class="bi bi-clipboard2-check-fill"></i></div>
                <asp:Label ID="Label7" runat="server" CssClass="stat-value" Text="50"></asp:Label>
                <div class="stat-label"><asp:Label ID="Label5" runat="server" Text="Membership"></asp:Label></div>
            </div>

            <div class="stat-card accent-pink">
                <div class="stat-icon"><i class="bi bi-person-badge-fill"></i></div>
                <asp:Label ID="Label8" runat="server" CssClass="stat-value" Text="10"></asp:Label>
                <div class="stat-label"><asp:Label ID="Label6" runat="server" Text="Trainers"></asp:Label></div>
            </div>
        </div>

        <div class="section-title">
            <span class="bar"></span>
            <h3>Quick Actions</h3>
        </div>

        <div class="quick-grid">
            <a class="quick-link" href="Add_member.aspx">
                <span class="quick-icon"><i class="bi bi-person-plus-fill"></i></span>
                <span class="quick-text"><strong>Add Member</strong><span>Register a new member</span></span>
            </a>
            <a class="quick-link" href="Add_trainer_Info.aspx">
                <span class="quick-icon"><i class="bi bi-person-badge-fill"></i></span>
                <span class="quick-text"><strong>Add Trainer</strong><span>Onboard staff</span></span>
            </a>
            <a class="quick-link" href="Add_membership_plan.aspx">
                <span class="quick-icon"><i class="bi bi-clipboard2-plus-fill"></i></span>
                <span class="quick-text"><strong>New Plan</strong><span>Create a pricing plan</span></span>
            </a>
            <a class="quick-link" href="Add_admin.aspx">
                <span class="quick-icon"><i class="bi bi-shield-plus"></i></span>
                <span class="quick-text"><strong>Add Admin</strong><span>Grant panel access</span></span>
            </a>
        </div>

    </div>
</asp:Content>
