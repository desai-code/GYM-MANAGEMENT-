<%@ Page Language="C#" AutoEventWireup="true" CodeFile="index.aspx.cs" Inherits="client_index" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hathi Fitness — Unleash Your Strength</title>
    
    <!-- Bootstrap & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Oswald:wght@500;600;700;800&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --accent: #f2a900;
            --accent-dark: #d99400;
            --bg-dark: #0d0d0f;
            --panel-dark: rgba(255, 255, 255, 0.05);
            --border-dark: rgba(255, 255, 255, 0.12);
            --text-light: #f5f6f8;
            --muted-light: #9a9ca6;
        }
        
        
        /* ================= PRELOADER STYLES ================= */
    #loader-wrapper {
        position: fixed;
        inset: 0;
        background-color: var(--bg-dark);
        z-index: 9999;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        transition: opacity 0.6s cubic-bezier(0.8, 0, 0.2, 1), visibility 0.6s cubic-bezier(0.8, 0, 0.2, 1);
    }

    .loader-brand {
        font-family: 'Oswald', sans-serif;
        font-size: 2.5rem;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 2px;
        color: var(--text-light);
        margin-bottom: 20px;
        animation: pulseText 1.5s infinite alternate ease-in-out;
    }

    .loader-brand span, .loader-brand i { 
        color: var(--accent); 
    }

    .spinner-container {
        position: relative;
        width: 70px;
        height: 70px;
    }

    .spinner {
        width: 100%;
        height: 100%;
        border: 4px solid var(--border-dark);
        border-top: 4px solid var(--accent);
        border-bottom: 4px solid var(--accent);
        border-radius: 50%;
        animation: spinLoader 1.2s linear infinite;
    }

    .spinner-container::after {
        content: '';
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        width: 15px;
        height: 15px;
        background-color: var(--accent);
        border-radius: 50%;
        animation: pulseDot 1.2s infinite alternate ease-in-out;
        box-shadow: 0 0 15px rgba(242, 169, 0, 0.6);
    }

    @keyframes spinLoader {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
    }

    @keyframes pulseText {
        0% { opacity: 0.6; }
        100% { opacity: 1; }
    }

    @keyframes pulseDot {
        0% { transform: translate(-50%, -50%) scale(0.8); opacity: 0.6; }
        100% { transform: translate(-50%, -50%) scale(1.2); opacity: 1; }
    }

    /* Hide class triggered by JS */
    body.loaded #loader-wrapper {
        opacity: 0;
        visibility: hidden;
        pointer-events: none;
    }
    
    /* Prevent scrolling while loading */
    body.no-scroll {
        overflow: hidden;
    }

        body { 
            font-family: 'Inter', sans-serif; 
            background-color: var(--bg-dark); 
            color: var(--text-light); 
            overflow-x: hidden;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        
        /* ================= PRELOADER STYLES ================= */
        #loader-wrapper {
            position: fixed;
            inset: 0;
            background-color: var(--bg-dark);
            z-index: 9999;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            transition: opacity 0.6s cubic-bezier(0.8, 0, 0.2, 1), visibility 0.6s cubic-bezier(0.8, 0, 0.2, 1);
        }

        .loader-brand {
            font-family: 'Oswald', sans-serif;
            font-size: 2.5rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 2px;
            color: var(--text-light);
            margin-bottom: 30px;
            animation: pulseText 1.5s infinite alternate ease-in-out;
        }

        .loader-brand span, .loader-brand i { 
            color: var(--accent); 
        }

        .spinner-container {
            position: relative;
            width: 70px;
            height: 70px;
        }

        .spinner {
            width: 100%;
            height: 100%;
            border: 4px solid var(--border-dark);
            border-top: 4px solid var(--accent);
            border-bottom: 4px solid var(--accent);
            border-radius: 50%;
            animation: spinLoader 1.2s linear infinite;
        }

        .spinner-container::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 15px;
            height: 15px;
            background-color: var(--accent);
            border-radius: 50%;
            animation: pulseDot 1.2s infinite alternate ease-in-out;
            box-shadow: 0 0 15px rgba(242, 169, 0, 0.6);
        }

   

        /* Hide class triggered by JS */
        body.loaded #loader-wrapper {
            opacity: 0;
            visibility: hidden;
            pointer-events: none;
        }
        
        /* Prevent scrolling while loading */
        body.no-scroll {
            overflow: hidden;
        }

        /* Navigation */
        .navbar-dark {
            background: rgba(13, 13, 15, 0.85);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid var(--border-dark);
            z-index: 1000;
        }
        
        .navbar-brand {
            font-family: 'Oswald', sans-serif;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 1.5rem;
        }

        .navbar-brand i { color: var(--accent); }
        
        .nav-link {
            font-weight: 600;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 1px;
            cursor: pointer;
            transition: color 0.2s;
        }

        .nav-link:hover, .nav-link.active {
            color: var(--accent) !important;
        }

        /* Shared Page Headers */
        .page-header { 
            padding: 80px 0 60px; 
            background: radial-gradient(circle at 50% 0%, #1c1d22 0%, transparent 80%); 
            text-align: center;
        }

        .page-title { 
            font-family: 'Oswald', sans-serif; 
            font-size: 3.5rem; 
            text-transform: uppercase; 
            font-weight: 800;
            letter-spacing: 1px;
        }

        .page-title span { color: var(--accent); }
        .section-title {
            font-family: 'Oswald', sans-serif;
            font-size: 2.5rem;
            text-transform: uppercase;
            font-weight: 700;
            border-bottom: 2px solid var(--accent);
            display: inline-block;
            padding-bottom: 10px;
            margin-bottom: 40px;
        }

        /* Home Hero Section */
        .hero-video-wrapper {
            position: relative;
            height: 85vh;
            width: 100%;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .hero-video-wrapper video {
            position: absolute;
            top: 50%; left: 50%;
            min-width: 100%; min-height: 100%;
            transform: translateX(-50%) translateY(-50%);
            z-index: 0;
            object-fit: cover;
            opacity: 0.4;
        }

        .hero-video-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to bottom, rgba(13,13,15,0.3) 0%, rgba(13,13,15,1) 100%);
            z-index: 1;
        }

        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
        }

        /* Glassmorphism Cards */
        .glass-card { 
            background: var(--panel-dark); 
            border: 1px solid var(--border-dark); 
            backdrop-filter: blur(16px); 
            border-radius: 16px; 
            padding: 30px; 
            transition: all 0.3s cubic-bezier(0.25, 0.8, 0.25, 1); 
            height: 100%;
        }

        .glass-card:hover { 
            transform: translateY(-8px); 
            border-color: var(--accent); 
            box-shadow: 0 12px 30px rgba(242, 169, 0, 0.15); 
        }
        
        .blog-card { padding: 0; overflow: hidden; }
        .blog-content { padding: 25px; }

        .clickable-card, .clickable-card:hover { cursor: pointer; color: var(--text-light); }

        /* Homepage Additions (Gallery, Reviews, Blog) */
        .gallery-img-wrapper { overflow: hidden; border-radius: 12px; height: 250px; }
        .gallery-img {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform 0.5s ease;
        }
        .gallery-img-wrapper:hover .gallery-img { transform: scale(1.1); }

        .testimonial-avatar {
            width: 70px; height: 70px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--accent);
            margin-bottom: 15px;
        }
        .stars { color: var(--accent); font-size: 1.2rem; }

        /* Typography & Buttons */
        .font-oswald { font-family: 'Oswald', sans-serif; }
        
        .btn-client-primary { 
            background: linear-gradient(135deg, var(--accent), var(--accent-dark)); 
            color: #0d0d0f; 
            font-family: 'Oswald', sans-serif; 
            font-weight: 700; 
            text-transform: uppercase; 
            border: none; 
            padding: 12px 30px; 
            border-radius: 10px; 
            font-size: 1.1rem;
            box-shadow: 0 6px 16px rgba(242, 169, 0, 0.3);
            transition: transform 0.15s, filter 0.15s;
        }

        .btn-client-primary:hover { 
            color: #0d0d0f; 
            filter: brightness(1.1); 
            transform: translateY(-2px);
        }

        .btn-client-outline {
            background: transparent;
            color: var(--text-light);
            border: 2px solid var(--text-light);
            font-family: 'Oswald', sans-serif; 
            font-weight: 700; 
            text-transform: uppercase; 
            padding: 10px 30px; 
            border-radius: 10px;
            font-size: 1.1rem;
            transition: all 0.2s ease;
        }
        
        .btn-client-outline:hover {
            background: var(--text-light);
            color: var(--bg-dark);
        }

        /* Specific Elements */
        .trainer-img {
            width: 140px; height: 140px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid var(--border-dark);
            margin-bottom: 20px;
            transition: border-color 0.3s;
        }

        .glass-card:hover .trainer-img { border-color: var(--accent); }

        .price-badge { 
            font-family: 'Oswald', sans-serif; 
            font-size: 2.8rem; 
            color: var(--accent); 
            font-weight: 700;
        }

        .program-icon {
            font-size: 2.5rem;
            color: var(--accent);
            margin-bottom: 15px;
        }

        /* Form Inputs (Glass style) */
        .glass-input {
            background: rgba(255, 255, 255, 0.05) !important;
            border: 1px solid var(--border-dark) !important;
            color: var(--text-light) !important;
            transition: all 0.2s;
        }
        .glass-input:focus {
            background: rgba(255, 255, 255, 0.08) !important;
            border-color: var(--accent) !important;
            box-shadow: 0 0 0 0.25rem rgba(242, 169, 0, 0.25) !important;
        }

        /* Cart Specifics */
        .cart-item {
            background: rgba(255, 255, 255, 0.02);
            border: 1px solid var(--border-dark);
            border-radius: 12px;
            padding: 15px;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .qty-btn {
            background: transparent;
            color: var(--text-light);
            border: 1px solid var(--border-dark);
            border-radius: 6px;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s;
        }
        .qty-btn:hover { background: var(--accent); color: var(--bg-dark); border-color: var(--accent); }
        .cart-badge { font-size: 0.75rem; vertical-align: super; }

        /* Modal Customization */
        .modal-content.glass-modal {
            background: rgba(22, 23, 28, 0.95);
            backdrop-filter: blur(20px);
            border: 1px solid var(--accent);
            border-radius: 16px;
            color: var(--text-light);
        }

        .modal-trainer-img {
            width: 80px; height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 2px solid var(--accent);
        }

        .trainer-assignment-box {
            background: rgba(0,0,0,0.3);
            border: 1px solid var(--border-dark);
            border-radius: 12px;
            padding: 15px;
            margin-top: 20px;
        }

        /* Time Slots styling */
        .time-slot-btn {
            background: transparent;
            border: 1px solid var(--border-dark);
            color: var(--text-light);
            border-radius: 8px;
            padding: 8px 12px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .time-slot-btn:hover { border-color: var(--accent); color: var(--accent); }
        .time-slot-btn.selected { background: var(--accent); color: #0d0d0f; border-color: var(--accent); }

        .day-group {
            background: rgba(255,255,255,0.03);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
            border: 1px solid transparent;
        }

        /* Toast Styling */
        .toast {
            background: rgba(22, 23, 28, 0.95);
            backdrop-filter: blur(10px);
            border: 1px solid var(--accent);
            color: var(--text-light);
            border-radius: 12px;
        }
        .toast-header {
            background: transparent;
            color: var(--accent);
            border-bottom: 1px solid rgba(242, 169, 0, 0.2);
        }

        /* Page Container */
        .page-section { display: none; animation: fadeIn 0.4s ease-in-out; }
        .page-section.active { display: block; }
        
        .global-msg:empty { display: none !important; }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }
    

        /* ---- My Account layout: cards must size to their content (they were height:100% and overlapped) ---- */
        #account .glass-card:hover { transform: none; }
        #account .col-lg-5 > .glass-card,
        #account .col-lg-7 > .glass-card { height: auto; }
        @media (min-width: 992px) {
            #account .col-lg-5 > .glass-card { position: sticky; top: 100px; }
        }

        /* =====================================================
           RESPONSIVE / MOBILE
           ===================================================== */
        html { -webkit-text-size-adjust: 100%; }
        img, video { max-width: 100%; }
        /* hover "lift" makes no sense on touch screens (it stays stuck after a tap) */
        @media (hover: none) {
            .glass-card:hover { transform: none; }
        }

        @media (max-width: 991.98px) {
            .navbar-collapse { padding: 10px 0 18px; }
            .navbar-nav { gap: .35rem !important; align-items: stretch !important; text-align: center; }
            .navbar-nav .nav-link { padding: 10px 0; }
            .navbar-nav .btn { display: block; width: 100%; }
            .navbar-nav .cart-badge { vertical-align: middle; }
        }

        @media (max-width: 767.98px) {
            .page-header { padding: 56px 0 36px; }
            .page-title { font-size: 2.3rem; }
            .hero-content .page-title { font-size: clamp(2.6rem, 14vw, 4rem) !important; }
            .section-title { font-size: 1.8rem; margin-bottom: 28px; }
            .glass-card { padding: 22px 18px; }
            .price-badge { font-size: 2.2rem; }
            .gallery-img-wrapper { height: 190px; }
            .hero-video-wrapper { height: auto; min-height: 80vh; padding: 90px 0 70px; }
            .hero-content p.fs-5 { font-size: 1.05rem !important; }
            .hero-content .btn { width: 100%; max-width: 320px; }
            .container.my-5.py-5 { margin-top: 2rem !important; margin-bottom: 2rem !important; padding-top: 1rem !important; padding-bottom: 1rem !important; }
            /* 16px inputs: stops iPhones from zooming the page when a field is tapped */
            input, select, textarea, .glass-input { font-size: 16px !important; }
        }

        @media (max-width: 575.98px) {
            .navbar-brand { font-size: 1.2rem; }
            .page-title { font-size: 2rem; }
            .section-title { font-size: 1.5rem; }
            .cart-item { flex-wrap: wrap; gap: 12px; }
            .cart-item > div { width: 100%; }
            .cart-item > div:last-child { justify-content: space-between; }
            .toast-container { left: 0; right: 0; padding: 12px !important; }
            .toast-container .toast { width: 100%; max-width: none; }
            .time-slot-btn { flex: 1 1 100%; text-align: center; }
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
<asp:HiddenField ID="hidActivePage" runat="server" Value="" />
<asp:HiddenField ID="hidToastTitle" runat="server" Value="" />
<asp:HiddenField ID="hidToastMsg" runat="server" Value="" />
<asp:HiddenField ID="hidClearCart" runat="server" Value="" />
<asp:HiddenField ID="hidShowProgramModal" runat="server" Value="" />
<asp:HiddenField ID="hidModalView" runat="server" Value="details" />

        <!-- ================= LOGIN / WELCOME PRELOADER ================= -->
    <div id="loader-wrapper">
        <div class="loader-brand">
            <i class="bi bi-lightning-charge-fill me-2"></i>Haathi <span>Fitness</span>
        </div>
        <div class="spinner-container">
            <div class="spinner"></div>
        </div>
        <p class="text-secondary text-uppercase tracking-widest mt-4 fw-semibold" style="letter-spacing: 3px; font-size: 13px;">Unleashing Your Strength...</p>
    </div>
   

    <div class="container"><asp:Label ID="lblGlobalMsg" runat="server" CssClass="global-msg text-danger d-block text-center py-2" Text=""></asp:Label></div>

    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark sticky-top">
        <div class="container">
            <a class="navbar-brand" href="#" onclick="showPage('home', this)"><i class="bi bi-lightning-charge-fill me-2"></i>Haathi Fitness</a>
            <button type="button" class="navbar-toggler" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav gap-3 align-items-center">
                    <li class="nav-item"><a class="nav-link active" onclick="showPage('home', this)">Home</a></li>
                    <li class="nav-item"><a class="nav-link" onclick="showPage('programs', this)">Programs</a></li>
                    <li class="nav-item"><a class="nav-link" onclick="showPage('trainers', this)">Our Trainers</a></li>
                    <li class="nav-item"><a class="nav-link" onclick="showPage('supplements', this)">Supplements</a></li>
                    <li class="nav-item"><a class="nav-link" onclick="showPage('plans', this)">Memberships</a></li>
                    <!-- Cart Link -->
                    <li class="nav-item">
                        <a class="nav-link" onclick="showPage('cart', this)">
                            <i class="bi bi-cart3 fs-5"></i> 
                            <span id="cartCountBadge" class="badge bg-warning text-dark cart-badge rounded-pill">0</span>
                        </a>
                    </li>
                    <% if (IsAdmin) { %>
                    <li class="nav-item"><a class="btn btn-client-primary btn-sm" href="<%= ResolveUrl("~/Default.aspx") %>"><i class="bi bi-speedometer2 me-1"></i>Admin Panel</a></li>
                    <% } %>
                    <% if (IsLoggedIn) { %>
                    <li class="nav-item"><a class="nav-link" onclick="showPage('account', this)"><i class="bi bi-person-circle me-1"></i><%= System.Web.HttpUtility.HtmlEncode(MemberName) %></a></li>
                    <li class="nav-item">
                        <asp:LinkButton ID="btnLogout" runat="server" CssClass="btn btn-client-outline btn-sm" OnClick="btnLogout_Click">Logout</asp:LinkButton>
                    </li>
                    <% } else { %>
                    <li class="nav-item"><a class="nav-link" onclick="showPage('login', this)">Login</a></li>
                    <li class="nav-item"><a class="btn btn-client-primary btn-sm" onclick="showPage('register', this)">Register</a></li>
                    <% } %>
                </ul>
            </div>
        </div>
    </nav>

    <!-- ================= PAGE 1: HOME ================= -->
    <div id="home" class="page-section active">
        <!-- Hero -->
        <section class="hero-video-wrapper">
            <video autoplay loop muted playsinline poster="https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=1200&q=80">
                <source src="https://cdn.coverr.co/videos/coverr-man-lifting-weights-in-a-gym-5244/1080p.mp4" type="video/mp4">
            </video>
            <div class="hero-video-overlay"></div>
            
            <div class="container hero-content">
                <span class="text-uppercase tracking-widest fw-bold" style="color: var(--accent); letter-spacing: 4px;">Welcome to the jungle</span>
                <h1 class="page-title mt-2 mb-4" style="font-size: 5rem;">Haathi <span>Fitness</span></h1>
                <p class="text-light fs-5 mb-5 max-w-75 mx-auto">Forging elite fitness through state-of-the-art equipment, world-class trainers, and an unbreakable community.</p>
                <div class="d-flex justify-content-center gap-3 flex-wrap">
                    <button type="button" class="btn btn-client-primary" onclick="showPage('plans', document.querySelectorAll('.nav-link')[4])">Join Now</button>
                    <button type="button" class="btn btn-client-outline" onclick="showPage('programs', document.querySelectorAll('.nav-link')[1])">Explore Programs</button>
                </div>
            </div>
        </section>

        <!-- Inside the Jungle (Gallery) -->
        <section class="container my-5 py-5 text-center">
            <h2 class="section-title">Inside the <span>Jungle</span></h2>
            <div class="row g-3">
                <div class="col-md-4">
                    <div class="gallery-img-wrapper">
                        <img src="https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=600&q=80" alt="Gym Floor" class="gallery-img">
                    </div>
                </div>
                <div class="col-md-8">
                    <div class="gallery-img-wrapper">
                        <img src="https://images.unsplash.com/photo-1540497077202-7c8a3999166f?auto=format&fit=crop&w=1200&q=80" alt="Training" class="gallery-img">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="gallery-img-wrapper">
                        <img src="https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&w=800&q=80" alt="Equipment" class="gallery-img">
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="gallery-img-wrapper">
                        <img src="https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?auto=format&fit=crop&w=800&q=80" alt="Cardio" class="gallery-img">
                    </div>
                </div>
            </div>
        </section>

        <!-- Testimonials -->
        <section class="bg-dark text-center py-5" style="border-top: 1px solid var(--border-dark); border-bottom: 1px solid var(--border-dark);">
            <div class="container my-4">
                <h2 class="section-title">Client <span>Victories</span></h2>
                <div class="row g-4 mt-2">
                    <div class="col-md-4">
                        <div class="glass-card">
                            <img src="https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=150&q=80" alt="Client" class="testimonial-avatar">
                            <div class="stars mb-2">
                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                            </div>
                            <p class="text-secondary font-italic">"The strength program completely changed my outlook on fitness. The trainers here don't just instruct; they educate and motivate."</p>
                            <h6 class="font-oswald text-uppercase mt-3 mb-0">— Karan Mehta</h6>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="glass-card">
                            <img src="https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=150&q=80" alt="Client" class="testimonial-avatar">
                            <div class="stars mb-2">
                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i>
                            </div>
                            <p class="text-secondary font-italic">"Haathi Fitness has the best equipment and the most supportive community. The CrossFit sessions pushed me beyond my limits!"</p>
                            <h6 class="font-oswald text-uppercase mt-3 mb-0">— Riya Desai</h6>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="glass-card">
                            <img src="https://images.unsplash.com/photo-1500648767791-00dcc994a43e?auto=format&fit=crop&w=150&q=80" alt="Client" class="testimonial-avatar">
                            <div class="stars mb-2">
                                <i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-fill"></i><i class="bi bi-star-half"></i>
                            </div>
                            <p class="text-secondary font-italic">"Incredible powerlifting coaching. I hit my PRs within two months safely and effectively. Best gym decision I've ever made."</p>
                            <h6 class="font-oswald text-uppercase mt-3 mb-0">— Amit Patel</h6>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>

    <!-- ================= PAGE 2: TRAINING PROGRAMS ================= -->
    <div id="programs" class="page-section">
        <header class="page-header">
            <div class="container">
                <h1 class="page-title">Discover Your <span>Discipline</span></h1>
                <p class="text-secondary fs-5 mt-3 max-w-75 mx-auto">Click on any program to see full details and book a session with the assigned expert.</p>
            </div>
        </header>
        <div class="container my-5 pb-5">
            <div class="row g-4">
                <asp:Repeater ID="rptPrograms" runat="server" OnItemCommand="rptPrograms_ItemCommand">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4">
                            <asp:LinkButton runat="server" CssClass="glass-card clickable-card text-center d-block text-decoration-none" CommandName="ViewProgram" CommandArgument='<%# Eval("id") %>'>
                                <i class="bi <%# IconClass(Eval("icon")) %> program-icon"></i>
                                <h4 class="fw-bold text-uppercase font-oswald"><%# H(Eval("programname")) %></h4>
                                <p class="text-secondary mt-3"><%# H(Eval("description")) %></p>
                                <span class="text-warning small fw-bold tracking-wide mt-3 d-block">VIEW &amp; BOOK <i class="bi bi-arrow-right"></i></span>
                            </asp:LinkButton>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

   <!-- ================= PAGE 3: OUR TRAINERS ================= -->
<div id="trainers" class="page-section">
    <header class="page-header">
        <div class="container">
            <h1 class="page-title">Meet Our <span>Experts</span></h1>
            <p class="text-secondary fs-5 mt-3 max-w-75 mx-auto">Our certified trainers have years of experience to help you achieve your peak physical condition.</p>
        </div>
    </header>

    <div class="container my-5 pb-5">
        <div class="row g-4 justify-content-center">
            
            <!-- ASP.NET Repeater to dynamically render trainers from MS Access -->
            <asp:Repeater ID="rptTrainers" runat="server">
                <ItemTemplate>
                    <div class="col-md-4 col-sm-6">
                        <div class="glass-card text-center">
                            <img src="<%# H(Eval("PhotoUrl")) %>" alt="Trainer" class="trainer-img">
                            <h4 class="fw-bold text-uppercase font-oswald mb-1"><%# H(Eval("TrainerName")) %></h4>
                            <span class="badge text-bg-dark border border-warning text-warning mb-3 px-3 py-2"><%# H(Eval("Specialization")) %></span>
                            <ul class="list-unstyled text-secondary small text-start mx-auto" style="max-width: 200px;">
                                <li class="mb-2"><i class="bi bi-check2-circle text-warning me-2"></i><%# H(Eval("ExperienceYears")) %> Years Experience</li>
                            </ul>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

        </div>
    </div>
</div>

    <!-- ================= PAGE 4: SUPPLEMENTS ================= -->
    <div id="supplements" class="page-section">
        <header class="page-header">
            <div class="container">
                <h1 class="page-title">Essential <span>Supplements</span></h1>
                <p class="text-secondary fs-5 mt-3 max-w-75 mx-auto">Fuel your progress with our premium, lab-tested supplements selected by experts.</p>
            </div>
        </header>

        <div class="container my-5 pb-5">
            <div class="row g-4">
                <asp:Repeater ID="rptSupplements" runat="server">
                    <ItemTemplate>
                        <div class="col-md-6 col-lg-4">
                            <div class="glass-card text-center d-flex flex-column h-100">
                                <div class="gallery-img-wrapper mb-3" style="height: 200px; background: #fff;">
                                    <img src="<%# ProductImg(Eval("imageurl")) %>" alt="<%# H(Eval("name")) %>" class="gallery-img" style="object-fit: contain;">
                                </div>
                                <h4 class="fw-bold text-uppercase font-oswald"><%# H(Eval("name")) %></h4>
                                <p class="text-secondary mt-2 flex-grow-1"><%# H(Eval("description")) %></p>
                                <div class="d-flex justify-content-between align-items-center mt-3 border-top border-dark pt-3">
                                    <span class="badge text-bg-dark border border-secondary text-light"><%# H(Eval("size")) %></span>
                                    <span class="fs-4 font-oswald text-warning fw-bold">&#8377;<%# Money(Eval("price")) %></span>
                                </div>
                                <button type="button" class="btn btn-client-outline w-100 mt-3 add-to-cart-btn"
                                    data-name="<%# H(Eval("name")) %>" data-price="<%# Num(Eval("price")) %>"
                                    onclick="purchaseSupplement(this.dataset.name, this.dataset.price)">
                                    Add to Cart <i class="bi bi-cart-plus ms-1"></i>
                                </button>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

    <!-- ================= PAGE 5: MEMBERSHIP PLANS ================= -->
    <div id="plans" class="page-section">
        <header class="page-header">
            <div class="container">
                <h1 class="page-title">Choose Your <span>Plan</span></h1>
                <p class="text-secondary fs-5 mt-3 max-w-75 mx-auto">Select a membership duration and pricing tier that matches your commitment.</p>
            </div>
        </header>

        <div class="container my-5 pb-5">
                        <div class="row g-4 align-items-center justify-content-center">
                <asp:Repeater ID="rptPlans" runat="server" OnItemCommand="rptPlans_ItemCommand">
                    <ItemTemplate>
                        <div class="col-lg-4 col-md-6">
                            <div class="glass-card text-center d-flex flex-column justify-content-between h-100">
                                <div>
                                    <h4 class="fw-bold text-uppercase font-oswald"><%# H(Eval("planname")) %> Membership</h4>
                                    <div class="price-badge my-3 text-white">&#8377;<%# H(Eval("price")) %> <span class="fs-6 text-secondary fw-normal">/ <%# Duration(Eval("membershipduration")) %></span></div>
                                    <ul class="list-unstyled text-start my-4 text-secondary">
                                        <li class="mb-3"><i class="bi bi-check-circle-fill text-secondary me-2"></i>Full Gym Floor Access</li>
                                        <li class="mb-3"><i class="bi bi-check-circle-fill text-secondary me-2"></i>Locker & Shower Facilities</li>
                                        <li class="mb-3"><i class="bi bi-check-circle-fill text-secondary me-2"></i>Access to Certified Trainers</li>
                                    </ul>
                                </div>
                                <asp:LinkButton runat="server" CssClass="btn btn-client-primary w-100 mt-4" CommandName="Join" CommandArgument='<%# Eval("id") %>'>Join Now</asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>

    <!-- ================= PAGE: CLIENT LOGIN ================= -->
    <div id="login" class="page-section">
        <header class="page-header pb-4">
            <div class="container">
                <h1 class="page-title">Member <span>Login</span></h1>
                <p class="text-secondary fs-5 mt-3 max-w-75 mx-auto">Sign in to book sessions, choose a plan, and manage your account.</p>
            </div>
        </header>
        <div class="container my-5 pb-5">
            <div class="row justify-content-center">
                <div class="col-md-6 col-lg-5">
                    <div class="glass-card">
                        <div class="mb-3">
                            <label class="form-label text-light">Email</label>
                            <asp:TextBox ID="txtLoginEmail" runat="server" CssClass="form-control glass-input" placeholder="you@example.com"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvLoginEmail" runat="server" ControlToValidate="txtLoginEmail" ValidationGroup="LoginGroup" CssClass="text-danger small" Text="Email is required" Display="Dynamic" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label text-light">Password</label>
                            <asp:TextBox ID="txtLoginPassword" runat="server" TextMode="Password" CssClass="form-control glass-input" placeholder="Your password"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rfvLoginPassword" runat="server" ControlToValidate="txtLoginPassword" ValidationGroup="LoginGroup" CssClass="text-danger small" Text="Password is required" Display="Dynamic" />
                        </div>
                        <asp:Label ID="lblLoginMsg" runat="server" CssClass="d-block mb-2" Text=""></asp:Label>

                         
                    

                        <asp:Button ID="btnClientLogin" runat="server" CssClass="btn btn-client-primary w-100" Text="Login" ValidationGroup="LoginGroup" OnClick="btnClientLogin_Click" />
                        <p class="text-secondary text-center mt-3 mb-0">New here? <a href="#" class="text-warning" onclick="showPage('register', document.querySelectorAll('.nav-link')[document.querySelectorAll('.nav-link').length-1]); return false;">Create an account</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ================= PAGE: CLIENT REGISTER ================= -->
    <div id="register" class="page-section">
        <header class="page-header pb-4">
            <div class="container">
                <h1 class="page-title">Create Your <span>Account</span></h1>
                <p class="text-secondary fs-5 mt-3 max-w-75 mx-auto">Register as a member to book programs and choose a plan.</p>
            </div>
        </header>
        <div class="container my-5 pb-5">
            <div class="row justify-content-center">
                <div class="col-md-8 col-lg-7">
                    <div class="glass-card">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-light">Full Name</label>
                                <asp:TextBox ID="txtRegFullName" runat="server" CssClass="form-control glass-input"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvRegName" runat="server" ControlToValidate="txtRegFullName" ValidationGroup="RegGroup" CssClass="text-danger small" Text="Required" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light">Email</label>
                                <asp:TextBox ID="txtRegEmail" runat="server" CssClass="form-control glass-input"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvRegEmail" runat="server" ControlToValidate="txtRegEmail" ValidationGroup="RegGroup" CssClass="text-danger small" Text="Required" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light">Password</label>
                                <asp:TextBox ID="txtRegPassword" runat="server" TextMode="Password" CssClass="form-control glass-input"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvRegPassword" runat="server" ControlToValidate="txtRegPassword" ValidationGroup="RegGroup" CssClass="text-danger small" Text="Required" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light">Confirm Password</label>
                                <asp:TextBox ID="txtRegConfirmPassword" runat="server" TextMode="Password" CssClass="form-control glass-input"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvRegConfirmPassword" runat="server" ControlToValidate="txtRegConfirmPassword" ValidationGroup="RegGroup" CssClass="text-danger small" Text="Required" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light">Date of Birth</label>
                                <asp:TextBox ID="txtRegDob" runat="server" TextMode="SingleLine" CssClass="form-control glass-input" placeholder="YYYY-MM-DD" MaxLength="30"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light">Mobile Number</label>
                                <asp:TextBox ID="txtRegMobile" runat="server" CssClass="form-control glass-input"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="rfvRegMobile" runat="server" ControlToValidate="txtRegMobile" ValidationGroup="RegGroup" CssClass="text-danger small" Text="Required" Display="Dynamic" />
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light">Gender</label>
                                <asp:DropDownList ID="ddlRegGender" runat="server" CssClass="form-control glass-input">
                                    <asp:ListItem Text="Male" Value="Male"></asp:ListItem>
                                    <asp:ListItem Text="Female" Value="Female"></asp:ListItem>
                                    <asp:ListItem Text="Other" Value="Other"></asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light">Height (cm)</label>
                                <asp:TextBox ID="txtRegHeight" runat="server" CssClass="form-control glass-input"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light">Weight (kg)</label>
                                <asp:TextBox ID="txtRegWeight" runat="server" CssClass="form-control glass-input"></asp:TextBox>
                            </div>
                            <div class="col-12">
                                <label class="form-label text-light">Address</label>
                                <asp:TextBox ID="txtRegAddress" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control glass-input"></asp:TextBox>
                            </div>
                        </div>
                        <asp:Label ID="lblRegMsg" runat="server" CssClass="d-block mt-3" Text=""></asp:Label>
                        <asp:Button ID="btnRegister" runat="server" CssClass="btn btn-client-primary w-100 mt-3" Text="Create Account" ValidationGroup="RegGroup" OnClick="btnRegister_Click" />
                        <p class="text-secondary text-center mt-3 mb-0">Already a member? <a href="#" class="text-warning" onclick="showPage('login', document.querySelectorAll('.nav-link')[document.querySelectorAll('.nav-link').length-2]); return false;">Login here</a></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ================= PAGE: MY ACCOUNT ================= -->
    <div id="account" class="page-section">
        <header class="page-header pb-4">
            <div class="container">
                <h1 class="page-title">My <span>Account</span></h1>
                <p class="text-secondary fs-5 mt-3 max-w-75 mx-auto">Your profile, membership plan, and account settings.</p>
            </div>
        </header>
        <div class="container my-5 pb-5">
            <div class="row g-4">
                <div class="col-lg-5">
                    <div class="glass-card">
                        <h4 class="font-oswald text-uppercase fw-bold mb-4"><i class="bi bi-person-badge-fill text-warning me-2"></i>Profile</h4>
                        <p class="mb-2"><span class="text-secondary">Name:</span> <asp:Label ID="lblAccName" runat="server" CssClass="fw-bold" /></p>
                        <p class="mb-2"><span class="text-secondary">Email:</span> <asp:Label ID="lblAccEmail" runat="server" /></p>
                        <p class="mb-2"><span class="text-secondary">Mobile:</span> <asp:Label ID="lblAccMobile" runat="server" /></p>
                        <p class="mb-2"><span class="text-secondary">Gender:</span> <asp:Label ID="lblAccGender" runat="server" /></p>
                        <p class="mb-2"><span class="text-secondary">Address:</span> <asp:Label ID="lblAccAddress" runat="server" /></p>
                        <p class="mb-2"><span class="text-secondary">Height:</span> <asp:Label ID="lblAccHeight" runat="server" /> cm</p>
                        <p class="mb-2"><span class="text-secondary">Weight:</span> <asp:Label ID="lblAccWeight" runat="server" /> kg</p>
                        <p class="mb-2"><span class="text-secondary">Member since:</span> <asp:Label ID="lblAccJoinDate" runat="server" /></p>
                        <p class="mb-0"><span class="text-secondary">Current Plan:</span> <span class="badge bg-warning text-dark px-3 py-2"><asp:Label ID="lblAccPlan" runat="server" /></span></p>
                        <button type="button" class="btn btn-client-outline w-100 mt-4" onclick="showPage('plans', document.querySelectorAll('.nav-link')[4])">Change Plan</button>
                    </div>
                </div>
                <div class="col-lg-7">
                    <div class="glass-card h-auto mb-4">
                        <h4 class="font-oswald text-uppercase fw-bold mb-4"><i class="bi bi-pencil-square text-warning me-2"></i>Edit Details</h4>
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label text-light">Mobile Number</label>
                                <asp:TextBox ID="txtEditMobile" runat="server" CssClass="form-control glass-input"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light">Height (cm)</label>
                                <asp:TextBox ID="txtEditHeight" runat="server" CssClass="form-control glass-input"></asp:TextBox>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label text-light">Weight (kg)</label>
                                <asp:TextBox ID="txtEditWeight" runat="server" CssClass="form-control glass-input"></asp:TextBox>
                            </div>
                            <div class="col-12">
                                <label class="form-label text-light">Address</label>
                                <asp:TextBox ID="txtEditAddress" runat="server" TextMode="MultiLine" Rows="2" CssClass="form-control glass-input"></asp:TextBox>
                            </div>
                        </div>
                        <asp:Button ID="btnUpdateProfile" runat="server" CssClass="btn btn-client-primary w-100 mt-3" Text="Save Changes" OnClick="btnUpdateProfile_Click" CausesValidation="false" />
                    </div>
                    <div class="glass-card h-auto">
                        <h4 class="font-oswald text-uppercase fw-bold mb-4"><i class="bi bi-shield-lock-fill text-warning me-2"></i>Change Password</h4>
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label text-light">Current Password</label>
                                <asp:TextBox ID="txtCurrentPassword" runat="server" TextMode="Password" CssClass="form-control glass-input"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-light">New Password</label>
                                <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" CssClass="form-control glass-input"></asp:TextBox>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label text-light">Confirm New Password</label>
                                <asp:TextBox ID="txtConfirmNewPassword" runat="server" TextMode="Password" CssClass="form-control glass-input"></asp:TextBox>
                            </div>
                        </div>
                        <asp:Label ID="lblPasswordMsg" runat="server" CssClass="d-block mt-2" Text=""></asp:Label>
                        <asp:Button ID="btnChangePassword" runat="server" CssClass="btn btn-client-outline w-100 mt-3" Text="Update Password" OnClick="btnChangePassword_Click" CausesValidation="false" />
                    </div>
                </div>
            </div>

            <div class="row g-4 mt-1">
                <div class="col-lg-6">
                    <div class="glass-card">
                        <h4 class="font-oswald text-uppercase fw-bold mb-4"><i class="bi bi-calendar2-check-fill text-warning me-2"></i>My Bookings</h4>
                        <asp:Repeater ID="rptMyBookings" runat="server">
                            <ItemTemplate>
                                <div class="d-flex justify-content-between align-items-center border-bottom border-dark pb-2 mb-2">
                                    <div>
                                        <div class="fw-bold"><%# H(Eval("programname")) %></div>
                                        <div class="text-secondary small"><%# H(Eval("trainername")) %> &middot; <%# H(Eval("bookingday")) %> at <%# H(Eval("bookingslot")) %></div>
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoBookings" runat="server" CssClass="text-secondary" Text="No sessions booked yet." Visible="false" />
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="glass-card">
                        <h4 class="font-oswald text-uppercase fw-bold mb-4"><i class="bi bi-bag-check-fill text-warning me-2"></i>My Orders</h4>
                        <asp:Repeater ID="rptMyOrders" runat="server">
                            <ItemTemplate>
                                <div class="d-flex justify-content-between align-items-center border-bottom border-dark pb-2 mb-2">
                                    <div>
                                        <div class="fw-bold"><%# H(Eval("supplementname")) %> <span class="text-secondary">x<%# Eval("quantity") %></span></div>
                                        <div class="text-secondary small"><%# Eval("orderdate", "{0:dd MMM yyyy}") %></div>
                                    </div>
                                    <div class="text-warning fw-bold">&#8377;<%# Money(Eval("price")) %></div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                        <asp:Label ID="lblNoOrders" runat="server" CssClass="text-secondary" Text="No orders yet." Visible="false" />
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ================= PAGE 6: MY CART ================= -->
    <div id="cart" class="page-section">
        <header class="page-header pb-4">
            <div class="container">
                <h1 class="page-title">My <span>Cart</span></h1>
                <p class="text-secondary fs-5 mt-3 max-w-75 mx-auto">Review your selected supplements and proceed to checkout.</p>
            </div>
        </header>

        <div class="container my-5 pb-5">
            <div class="row g-4">
                <div class="col-lg-8" id="cartItemsContainer">
                    <div class="text-center text-secondary py-5">
                        <i class="bi bi-cart-x fs-1 d-block mb-3"></i>
                        <h4>Your cart is empty</h4>
                        <button type="button" class="btn btn-client-outline mt-3" onclick="showPage('supplements', document.querySelectorAll('.nav-link')[3])">Browse Supplements</button>
                    </div>
                </div>

                <div class="col-lg-4">
                    <div class="glass-card position-sticky" style="top: 100px;">
                        <h4 class="font-oswald text-uppercase fw-bold mb-4">Order Summary</h4>
                        <div class="d-flex justify-content-between text-secondary mb-3">
                            <span>Subtotal</span>
                            <span id="cartSubtotal">&#8377;0</span>
                        </div>
                        <div class="d-flex justify-content-between text-secondary mb-4">
                            <span>Shipping</span>
                            <span class="text-success">Free</span>
                        </div>
                        <div class="border-top border-dark pt-3 mb-4 d-flex justify-content-between align-items-center">
                            <span class="fs-5 fw-bold">Total</span>
                            <span id="cartTotal" class="fs-3 font-oswald text-warning fw-bold">&#8377;0</span>
                        </div>
                        <asp:HiddenField ID="hidCartData" runat="server" Value="" />
                        <asp:Button ID="btnCheckout" runat="server" CssClass="btn btn-client-primary w-100" Text="Proceed to Checkout"
                            OnClientClick="return prepareCheckout();" OnClick="btnCheckout_Click" CausesValidation="false" />
                        <asp:Label ID="lblCartMsg" runat="server" CssClass="d-block text-center mt-2" Text=""></asp:Label>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ================= DYNAMIC PROGRAM & BOOKING MODAL ================= -->
    <div class="modal fade" id="programModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content glass-modal p-2">
                <div class="modal-header border-bottom-0 pb-0">
                    <h2 class="modal-title font-oswald text-uppercase fw-bold"><asp:Label ID="lblModalTitle" runat="server" Text="Program Title" /></h2>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="detailsView">
                        <p class="text-secondary fs-5 mb-4"><asp:Label ID="lblModalDesc" runat="server" Text="Program description goes here." /></p>
                        <h5 class="font-oswald text-uppercase text-warning"><i class="bi bi-person-badge-fill me-2"></i>Lead Instructor</h5>
                        <div class="trainer-assignment-box d-flex flex-wrap align-items-center gap-3">
                            <asp:Image ID="imgModalTrainer" runat="server" CssClass="modal-trainer-img" AlternateText="Trainer Photo" />
                            <div>
                                <h4 class="fw-bold text-uppercase font-oswald mb-1 m-0"><asp:Label ID="lblModalTrainerName" runat="server" Text="Trainer Name" /></h4>
                                <span class="badge text-bg-dark border border-secondary text-light mb-1"><asp:Label ID="lblModalTrainerSpec" runat="server" Text="Specialization" /></span>
                                <div class="text-secondary small"><i class="bi bi-award-fill text-warning me-1"></i><asp:Label ID="lblModalTrainerExp" runat="server" Text="X" /> years Experience</div>
                            </div>
                            <div class="ms-auto pe-md-3 mt-3 mt-md-0 w-100 w-md-auto text-end">
                                <button type="button" class="btn btn-warning fw-bold" onclick="showBookingView()">Book Session <i class="bi bi-calendar2-check ms-1"></i></button>
                            </div>
                        </div>
                    </div>
                    <div id="bookingView" style="display: none;">
                        <button type="button" class="btn btn-link text-warning p-0 text-decoration-none mb-3" onclick="hideBookingView()"><i class="bi bi-arrow-left me-1"></i>Back to Details</button>
                        <h5 class="font-oswald text-uppercase text-light mb-3">Select a timing for <span class="text-warning"><asp:Label ID="lblBookingTrainerName" runat="server" /></span></h5>
                        <asp:Label ID="lblSlotMsg" runat="server" CssClass="d-block text-warning small mb-2" Text=""></asp:Label>
                        <div class="mb-4 d-flex flex-wrap gap-2">
                            <asp:Repeater ID="rptSlots" runat="server" OnItemCommand="rptSlots_ItemCommand">
                                <ItemTemplate>
                                    <asp:LinkButton runat="server" CssClass="time-slot-btn" CommandName="BookSlot" CommandArgument='<%# Eval("id") %>'>
                                        <%# H(Eval("dayname")) %> &middot; <%# H(Eval("slottime")) %>
                                    </asp:LinkButton>
                                </ItemTemplate>
                                <SeparatorTemplate> </SeparatorTemplate>
                            </asp:Repeater>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>


    <!-- ================= CUSTOM TOAST NOTIFICATION ================= -->
    <div class="toast-container position-fixed bottom-0 end-0 p-4" style="z-index: 1100">
        <div id="actionToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true" data-bs-delay="5000">
            <div class="toast-header">
                <i class="bi bi-check-circle-fill me-2"></i>
                <strong class="me-auto font-oswald text-uppercase fs-6" id="toastTitle">Notification</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body fs-6" id="toastMessage"></div>
        </div>
    </div>

    <!-- Bootstrap JS for Modals -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Scripts -->
    <script>

    // --- 5-SECOND PRELOADER LOGIC ---
    document.body.classList.add('no-scroll');

    window.addEventListener('load', function() {
        // Ensure the preloader displays for at least 5 seconds before fading out
        setTimeout(function() {
            document.body.classList.add('loaded');
            document.body.classList.remove('no-scroll');
        }, 3000); // 5000 milliseconds = 5 seconds
    });

        // Page Navigation Logic
        function showPage(pageId, navElement) {
            document.querySelectorAll('.page-section').forEach(page => {
                page.classList.remove('active');
            });
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
            });
            document.getElementById(pageId).classList.add('active');
            if (navElement) {
                navElement.classList.add('active');
            }
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function inr(n) {
            return Number(n).toLocaleString('en-IN', { minimumFractionDigits: (n % 1 === 0) ? 0 : 2, maximumFractionDigits: 2 });
        }

        function esc(s) {
            return String(s).replace(/[&<>"']/g, function (c) {
                return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[c];
            });
        }

        // --- CART LOGIC ---
        let cart = [];
        var clientIsLoggedIn = <%= IsLoggedIn.ToString().ToLower() %>;

        function syncCartHidden() {
            document.getElementById('<%= hidCartData.ClientID %>').value = JSON.stringify(cart);
        }

        function prepareCheckout() {
            if (!clientIsLoggedIn) {
                showPage('login', document.querySelectorAll('.nav-link')[document.querySelectorAll('.nav-link').length - 1]);
                document.getElementById('<%= lblLoginMsg.ClientID %>').innerText = 'Please log in to complete your order.';
                document.getElementById('<%= lblLoginMsg.ClientID %>').className = 'text-warning small d-block mb-2';
                return false;
            }
            if (cart.length === 0) return false;
            syncCartHidden();
            return true;
        }

        function purchaseSupplement(itemName, itemPriceStr) {
            const priceNum = parseFloat(itemPriceStr) || 0;
            const displayPrice = '\u20B9' + inr(priceNum);
            const existingItem = cart.find(item => item.name === itemName);
            
            if (existingItem) {
                existingItem.quantity += 1;
            } else {
                cart.push({
                    name: itemName,
                    price: priceNum,
                    quantity: 1,
                    displayPrice: displayPrice
                });
            }

            updateCartUI();
            syncCartHidden();

            document.getElementById('toastTitle').innerText = 'Added to Cart';
            const messageHTML = `
                You have successfully added a product to your cart.<br>
                <div class="mt-2 text-secondary">
                    <i class="bi bi-box-seam me-1"></i> Product: <strong class="text-warning">${esc(itemName)}</strong><br>
                    <i class="bi bi-tag-fill me-1"></i> Price: <strong>${displayPrice}</strong>
                </div>
            `;
            document.getElementById('toastMessage').innerHTML = messageHTML;
            const toast = new bootstrap.Toast(document.getElementById('actionToast'));
            toast.show();
        }

        function changeQuantity(index, delta) {
            cart[index].quantity += delta;
            
            if (cart[index].quantity <= 0) {
                cart.splice(index, 1);
            }
            updateCartUI();
            syncCartHidden();
        }

        function updateCartUI() {
            const container = document.getElementById('cartItemsContainer');
            const countBadge = document.getElementById('cartCountBadge');
            const subtotalEl = document.getElementById('cartSubtotal');
            const totalEl = document.getElementById('cartTotal');
            const checkoutBtn = document.getElementById('<%= btnCheckout.ClientID %>');
            
            const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
            countBadge.innerText = totalItems;

            if (cart.length === 0) {
                container.innerHTML = `
                    <div class="text-center text-secondary py-5">
                        <i class="bi bi-cart-x fs-1 d-block mb-3"></i>
                        <h4>Your cart is empty</h4>
                        <button type="button" class="btn btn-client-outline mt-3" onclick="showPage('supplements', document.querySelectorAll('.nav-link')[3])">Browse Supplements</button>
                    </div>`;
                subtotalEl.innerText = '\u20B90';
                totalEl.innerText = '\u20B90';
                checkoutBtn.disabled = true;
                return;
            }

            let cartHTML = '';
            let totalPrice = 0;

            cart.forEach((item, index) => {
                const itemTotal = item.price * item.quantity;
                totalPrice += itemTotal;
                const formattedItemTotal = '\u20B9' + inr(itemTotal);

                cartHTML += `
                    <div class="cart-item">
                        <div class="d-flex align-items-center flex-grow-1">
                            <div class="bg-light rounded p-2 me-3 d-flex align-items-center justify-content-center" style="width: 60px; height: 60px;">
                                <i class="bi bi-box-seam text-dark fs-3"></i>
                            </div>
                            <div>
                                <h5 class="font-oswald text-uppercase mb-1">${esc(item.name)}</h5>
                                <div class="text-secondary small">Unit Price: ${item.displayPrice}</div>
                            </div>
                        </div>
                        
                        <div class="d-flex align-items-center gap-3">
                            <div class="d-flex align-items-center gap-2">
                                <button type="button" class="qty-btn" onclick="changeQuantity(${index}, -1)"><i class="bi bi-dash"></i></button>
                                <span class="fw-bold fs-5 px-2">${item.quantity}</span>
                                <button type="button" class="qty-btn" onclick="changeQuantity(${index}, 1)"><i class="bi bi-plus"></i></button>
                            </div>
                            <div class="text-end" style="width: 100px;">
                                <span class="text-warning fw-bold fs-5">${formattedItemTotal}</span>
                            </div>
                        </div>
                    </div>
                `;
            });

            container.innerHTML = cartHTML;
            
            const formattedTotal = '\u20B9' + inr(totalPrice);
            subtotalEl.innerText = formattedTotal;
            totalEl.innerText = formattedTotal;
            checkoutBtn.disabled = false;
        }

        // --- PROGRAM BOOKING LOGIC (data is rendered server-side; JS only toggles views) ---
        function showBookingView() {
            document.getElementById('detailsView').style.display = 'none';
            document.getElementById('bookingView').style.display = 'block';
        }

        function hideBookingView() {
            document.getElementById('detailsView').style.display = 'block';
            document.getElementById('bookingView').style.display = 'none';
        }

        // --- SERVER-DRIVEN NAVIGATION (login/register/join-plan postbacks) ---
        (function () {
            var storedCart = document.getElementById('<%= hidCartData.ClientID %>').value;
            if (storedCart) {
                try { cart = JSON.parse(storedCart); } catch (e) { cart = []; }
            }
            if (document.getElementById('<%= hidClearCart.ClientID %>').value === '1') {
                cart = [];
            }
            updateCartUI();

            var activePage = document.getElementById('<%= hidActivePage.ClientID %>').value;
            if (activePage) {
                var navMap = { home: 0, programs: 1, trainers: 2, supplements: 3, plans: 4 };
                var navLinks = document.querySelectorAll('.nav-link');
                var idx = navMap[activePage];
                showPage(activePage, idx !== undefined ? navLinks[idx] : null);
            }

            var toastTitle = document.getElementById('<%= hidToastTitle.ClientID %>').value;
            var toastMsg = document.getElementById('<%= hidToastMsg.ClientID %>').value;
            if (toastTitle) {
                document.getElementById('toastTitle').innerText = toastTitle;
                document.getElementById('toastMessage').textContent = toastMsg;
                window.addEventListener('load', function () {
                    var t = new bootstrap.Toast(document.getElementById('actionToast'));
                    t.show();
                });
            }

            if (document.getElementById('<%= hidShowProgramModal.ClientID %>').value === '1') {
                if (document.getElementById('<%= hidModalView.ClientID %>').value === 'booking') {
                    showBookingView();
                } else {
                    hideBookingView();
                }
                window.addEventListener('load', function () {
                    var pm = new bootstrap.Modal(document.getElementById('programModal'));
                    pm.show();
                });
            }
        })();
    </script>
</form>
</body>
</html>