<%@ Page Title="About Us" Language="C#" MasterPageFile="~/Site.master" AutoEventWireup="true"
    CodeFile="About.aspx.cs" Inherits="About" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <style type="text/css">
        .about-wrap {
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
            padding: 30px 28px;
            margin-bottom: 24px;
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

        .card-panel p {
            color: #4b4d55;
            font-size: 14.5px;
            line-height: 1.7;
            margin: 0 0 14px;
        }

        .card-panel p:last-child { margin-bottom: 0; }

        .feature-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 16px;
            margin-top: 6px;
        }

        @media (max-width: 640px) {
            .feature-grid { grid-template-columns: 1fr; }
        }

        .feature-item {
            display: flex;
            gap: 14px;
            align-items: flex-start;
        }

        .feature-item .f-icon {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            background: rgba(242,169,0,.12);
            color: var(--accent-ink);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 17px;
            flex-shrink: 0;
        }

        .feature-item strong {
            display: block;
            color: var(--text);
            font-size: 14px;
            margin-bottom: 3px;
        }

        .feature-item span {
            color: var(--muted);
            font-size: 12.5px;
            line-height: 1.5;
        }
    </style>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div class="about-wrap">

        <div class="top-strip"></div>

        <div class="page-header">
            <div class="icon-badge"><i class="bi bi-info-circle-fill"></i></div>
            <div>
                <h1>About Haathi Fitness</h1>
                <p>What this admin centre helps you run, day to day</p>
            </div>
        </div>

        <div class="card-panel">
            <p>Haathi Fitness Admin Centre is the back-office panel behind the gym floor — the place staff manage admins, members, trainers and membership plans without touching a spreadsheet.</p>
            <p>Everything a front-desk team needs is one click away from the dashboard: adding a new member, onboarding a trainer, publishing a pricing plan, or handing out admin access.</p>
        </div>

        <div class="card-panel">
            <div class="feature-grid">
                <div class="feature-item">
                    <span class="f-icon"><i class="bi bi-person-vcard-fill"></i></span>
                    <div><strong>Member Management</strong><span>Register members, track fitness details, keep records up to date.</span></div>
                </div>
                <div class="feature-item">
                    <span class="f-icon"><i class="bi bi-person-badge-fill"></i></span>
                    <div><strong>Trainer Roster</strong><span>Keep trainer specializations, contact info and photos on file.</span></div>
                </div>
                <div class="feature-item">
                    <span class="f-icon"><i class="bi bi-clipboard2-check-fill"></i></span>
                    <div><strong>Membership Plans</strong><span>Set up and price the plans members can subscribe to.</span></div>
                </div>
                <div class="feature-item">
                    <span class="f-icon"><i class="bi bi-shield-fill-check"></i></span>
                    <div><strong>Admin Access</strong><span>Control who on staff can manage the panel.</span></div>
                </div>
            </div>
        </div>

    </div>
</asp:Content>
