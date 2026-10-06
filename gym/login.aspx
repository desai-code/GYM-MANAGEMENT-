<%@ Page Language="C#" AutoEventWireup="true" CodeFile="login.aspx.cs" Inherits="login" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head id="Head1" runat="server">
    <title>Log In — Haathi Fitness Admin Centre</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css" rel="stylesheet" />
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

        * { box-sizing: border-box; }

        html, body {
            margin: 0;
            min-height: 100%;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, sans-serif;
            overflow-x: hidden;
        }

        /* ---------- Animated backdrop ---------- */
        body {
            background: radial-gradient(circle at 20% 20%, #1c1d22 0%, #101114 55%, #0a0a0c 100%);
            position: relative;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .bg-glow {
            position: fixed;
            border-radius: 50%;
            filter: blur(70px);
            opacity: .35;
            z-index: 0;
            animation: float 14s ease-in-out infinite;
        }

        .bg-glow.g1 {
            width: 420px; height: 420px;
            top: -120px; left: -120px;
            background: radial-gradient(circle, var(--accent), transparent 70%);
            animation-delay: 0s;
        }

        .bg-glow.g2 {
            width: 380px; height: 380px;
            bottom: -140px; right: -100px;
            background: radial-gradient(circle, #ffce54, transparent 70%);
            animation-delay: 3s;
        }

        .bg-glow.g3 {
            width: 260px; height: 260px;
            bottom: 10%; left: 8%;
            background: radial-gradient(circle, var(--accent-dark), transparent 70%);
            opacity: .2;
            animation-delay: 6s;
        }

        @keyframes float {
            0%, 100% { transform: translate(0, 0) scale(1); }
            50% { transform: translate(24px, -30px) scale(1.08); }
        }

        .grain {
            position: fixed;
            inset: 0;
            z-index: 1;
            pointer-events: none;
            background-image: radial-gradient(rgba(255,255,255,.025) 1px, transparent 1px);
            background-size: 3px 3px;
        }

        /* ---------- Card ---------- */
        .login-wrap {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 400px;
            animation: rise .6s cubic-bezier(.22,1,.36,1);
        }

        @keyframes rise {
            from { opacity: 0; transform: translateY(22px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .brand-block {
            text-align: center;
            margin-bottom: 26px;
        }

        .brand-icon {
            width: 62px;
            height: 62px;
            border-radius: 16px;
            margin: 0 auto 14px;
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            display: flex;
            align-items: center;
            justify-content: center;
            color: #0d0d0f;
            font-size: 28px;
            transform: rotate(-4deg);
            box-shadow: 0 10px 28px rgba(242,169,0,.35), 0 0 0 6px rgba(242,169,0,.08);
            animation: pulse 3s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { box-shadow: 0 10px 28px rgba(242,169,0,.35), 0 0 0 6px rgba(242,169,0,.08); }
            50%      { box-shadow: 0 10px 32px rgba(242,169,0,.5), 0 0 0 10px rgba(242,169,0,.05); }
        }

        .brand-block h1 {
            font-family: 'Oswald', sans-serif;
            font-size: 22px;
            font-weight: 700;
            letter-spacing: .05em;
            text-transform: uppercase;
            color: #fff;
            margin: 0;
        }

        .brand-block span {
            display: block;
            margin-top: 4px;
            font-size: 11.5px;
            letter-spacing: .16em;
            text-transform: uppercase;
            color: var(--accent);
            font-weight: 600;
        }

        .login-card {
            background: rgba(255,255,255,.06);
            border: 1px solid rgba(255,255,255,.12);
            border-radius: var(--radius);
            padding: 32px 30px 26px;
            backdrop-filter: blur(18px);
            -webkit-backdrop-filter: blur(18px);
            box-shadow: 0 20px 60px rgba(0,0,0,.45);
            position: relative;
            overflow: hidden;
        }

        .login-card::before {
            content: "";
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
            background: linear-gradient(90deg, transparent, var(--accent), transparent);
            background-size: 200% 100%;
            animation: shimmer 3.5s linear infinite;
        }

        @keyframes shimmer {
            0%   { background-position: 200% 0; }
            100% { background-position: -200% 0; }
        }

        .login-card h2 {
            font-family: 'Oswald', sans-serif;
            font-size: 15px;
            font-weight: 600;
            letter-spacing: .04em;
            text-transform: uppercase;
            color: #fff;
            margin: 0 0 22px;
            text-align: center;
        }

        .field-group { margin-bottom: 16px; position: relative; }

        .field-label {
            font-weight: 600;
            font-size: 11.5px;
            text-transform: uppercase;
            letter-spacing: .06em;
            color: #c7c9d1;
            margin-bottom: 7px;
            display: block;
        }

        .input-shell { position: relative; }

        .input-shell i.field-ic {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #8a8c96;
            font-size: 14px;
            transition: color .15s;
            pointer-events: none;
        }

        .form-control.admin-input {
            background: rgba(255,255,255,.05);
            border: 1px solid rgba(255,255,255,.14);
            border-radius: 10px;
            padding: 11px 14px 11px 38px;
            font-size: 14px;
            color: #fff;
            width: 100%;
            transition: border-color .15s, box-shadow .15s, background .15s;
        }

        .form-control.admin-input::placeholder { color: #7d7f89; }

        .form-control.admin-input:focus {
            outline: none;
            background: rgba(255,255,255,.08);
            border-color: var(--accent);
            box-shadow: 0 0 0 3px rgba(242,169,0,.15);
        }

        .form-control.admin-input:focus ~ i.field-ic,
        .input-shell:focus-within i.field-ic { color: var(--accent); }

        .toggle-pw {
            position: absolute;
            right: 12px;
            top: 50%;
            transform: translateY(-50%);
            background: none;
            border: none;
            color: #8a8c96;
            font-size: 14px;
            cursor: pointer;
            padding: 4px;
            transition: color .15s;
        }

        .toggle-pw:hover { color: var(--accent); }

        .row-between {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin: 4px 0 22px;
            font-size: 12.5px;
        }

        .remember-me { display: flex; align-items: center; gap: 7px; color: #c7c9d1; }
        .remember-me input { accent-color: var(--accent); }

        .row-between a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 600;
        }

        .row-between a:hover { color: var(--accent-dark); text-decoration: underline; }

        .btn-login {
            width: 100%;
            background: linear-gradient(135deg, var(--accent), var(--accent-dark));
            border: none;
            color: #0d0d0f;
            font-weight: 700;
            font-family: 'Oswald', sans-serif;
            letter-spacing: .05em;
            text-transform: uppercase;
            padding: 13px;
            border-radius: 10px;
            font-size: 14px;
            cursor: pointer;
            box-shadow: 0 8px 22px rgba(242,169,0,.3);
            transition: transform .12s, box-shadow .15s, filter .15s;
            position: relative;
            overflow: hidden;
        }

        .btn-login:hover { filter: brightness(1.06); box-shadow: 0 10px 26px rgba(242,169,0,.4); }
        .btn-login:active { transform: translateY(1px) scale(.99); }

        .btn-login i { margin-right: 8px; }

        .validator-text {
            font-size: 11.5px;
            color: #ff8080 !important;
            display: block;
            margin-top: 5px;
        }

        .msg-banner {
            font-size: 12.5px;
            padding: 10px 14px;
            border-radius: 9px;
            margin-bottom: 16px;
            text-align: center;
        }

        .msg-banner.error {
            background: rgba(220,38,38,.12);
            border: 1px solid rgba(220,38,38,.3);
            color: #ff9b9b;
        }

        .divider-note {
            text-align: center;
            margin-top: 20px;
            font-size: 11.5px;
            color: #6b6d76;
        }

        .divider-note .dot {
            display: inline-block;
            width: 5px; height: 5px;
            border-radius: 50%;
            background: var(--accent);
            margin-right: 6px;
            vertical-align: middle;
        }

        @media (max-width: 420px) {
            .login-card { padding: 26px 20px 22px; }
        }
    </style>
</head>
<body>
    <div class="bg-glow g1"></div>
    <div class="bg-glow g2"></div>
    <div class="bg-glow g3"></div>
    <div class="grain"></div>

    <form id="form1" runat="server">
        <div class="login-wrap">

            <div class="brand-block">
                <div class="brand-icon"><i class="bi bi-lightning-charge-fill"></i></div>
                <h1>Haathi Fitness</h1>
                <span>Admin Centre</span>
            &nbsp;</div>

            <div class="login-card">
                <h2>Sign in to your account</h2>

                <asp:Label ID="lblError" runat="server" CssClass="msg-banner error" Visible="false"></asp:Label>

                <div class="field-group">
                    <label class="field-label" for="txtUsername">Email</label>
                    <div class="input-shell">
                        <i class="bi bi-envelope-fill field-ic"></i>
                        <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control admin-input" placeholder="admin@haathifitness.com"></asp:TextBox>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvUsername" runat="server"
                        ControlToValidate="txtUsername" ErrorMessage="Enter your email"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </div>

                <div class="field-group">
                    <label class="field-label" for="txtPassword">Password</label>
                    <div class="input-shell">
                        <i class="bi bi-lock-fill field-ic"></i>
                        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control admin-input" placeholder="Enter password" TextMode="Password"></asp:TextBox>
                        <button type="button" class="toggle-pw" onclick="togglePw()"><i id="pwIcon" class="bi bi-eye-fill"></i></button>
                    </div>
                    <asp:RequiredFieldValidator ID="rfvPassword" runat="server"
                        ControlToValidate="txtPassword" ErrorMessage="Enter your password"
                        CssClass="validator-text" Display="Dynamic" SetFocusOnError="True"></asp:RequiredFieldValidator>
                </div>

                

                <asp:Button ID="btnLogin" runat="server" CssClass="btn-login" Text="Log In"
                    OnClick="btnLogin_Click" />

                <div class="divider-note"><span class="dot"></span>Authorized personnel only</div>
            </div>
        </div>
    </form>

    <script>
        function togglePw() {
            var pwInput = document.getElementById('<%= txtPassword.ClientID %>');
            var icon = document.getElementById('pwIcon');
            if (pwInput.type === 'password') {
                pwInput.type = 'text';
                icon.className = 'bi bi-eye-slash-fill';
            } else {
                pwInput.type = 'password';
                icon.className = 'bi bi-eye-fill';
            }
        }
    </script>
</body>
</html>
