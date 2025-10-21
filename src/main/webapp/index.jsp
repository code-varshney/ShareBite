<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Sharebite - Food Rescue Web App</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(-45deg, #2c5aa0, #1e3c72, #667eea, #764ba2);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            overflow-x: hidden;
        }
        
        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        .floating-shapes {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            pointer-events: none;
            z-index: -1;
        }
        
        .shape {
            position: absolute;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 50%;
            animation: float 6s ease-in-out infinite;
        }
        
        .shape:nth-child(1) { width: 80px; height: 80px; top: 10%; left: 10%; animation-delay: 0s; }
        .shape:nth-child(2) { width: 120px; height: 120px; top: 20%; right: 10%; animation-delay: 2s; }
        .shape:nth-child(3) { width: 60px; height: 60px; bottom: 20%; left: 20%; animation-delay: 4s; }
        .shape:nth-child(4) { width: 100px; height: 100px; bottom: 10%; right: 20%; animation-delay: 1s; }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-20px) rotate(180deg); }
        }
        
        .hero-section {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 30px;
            padding: 4rem 2rem;
            margin: 3rem auto;
            text-align: center;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            animation: slideUp 1s ease-out;
            max-width: 1200px;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(50px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .main-title {
            font-size: 4rem;
            font-weight: 800;
            background: linear-gradient(45deg, #fff, #f8f9fa, #fff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1rem;
            animation: titleGlow 2s ease-in-out infinite alternate;
            text-shadow: 0 0 30px rgba(255, 255, 255, 0.5);
        }
        
        @keyframes titleGlow {
            from { filter: drop-shadow(0 0 10px rgba(255, 255, 255, 0.3)); }
            to { filter: drop-shadow(0 0 20px rgba(255, 255, 255, 0.6)); }
        }
        
        .subtitle {
            font-size: 1.6rem;
            color: #ffffff;
            margin-bottom: 1rem;
            font-weight: 400;
            animation: fadeIn 1.5s ease-out 0.5s both;
        }
        
        .tagline {
            font-size: 1.2rem;
            color: rgba(255, 255, 255, 0.9);
            margin-bottom: 3rem;
            animation: fadeIn 1.5s ease-out 1s both;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .option-btn {
            font-size: 1.1rem;
            padding: 1rem 2rem;
            border-radius: 50px;
            margin: 0.5rem;
            font-weight: 600;
            border: none;
            text-decoration: none;
            color: #fff;
            position: relative;
            overflow: hidden;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            animation: buttonSlide 1.5s ease-out 1.5s both;
        }
        
        @keyframes buttonSlide {
            from { opacity: 0; transform: translateX(-50px); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        .option-btn::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }
        
        .option-btn:hover::before {
            left: 100%;
        }
        
        .btn-donor {
            background: linear-gradient(135deg, #28a745, #20c997, #17a2b8);
            box-shadow: 0 10px 30px rgba(40, 167, 69, 0.3);
        }
        
        .btn-donor:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 15px 40px rgba(40, 167, 69, 0.4);
            color: #fff;
        }
        
        .btn-ngo {
            background: linear-gradient(135deg, #007bff, #0056b3, #004085);
            box-shadow: 0 10px 30px rgba(0, 123, 255, 0.3);
        }
        
        .btn-ngo:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 15px 40px rgba(0, 123, 255, 0.4);
            color: #fff;
        }
        
        .btn-admin {
            background: linear-gradient(135deg, #6c757d, #495057, #343a40);
            box-shadow: 0 10px 30px rgba(108, 117, 125, 0.3);
        }
        
        .btn-admin:hover {
            transform: translateY(-5px) scale(1.05);
            box-shadow: 0 15px 40px rgba(108, 117, 125, 0.4);
            color: #fff;
        }
        
        .stats-section {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            border-radius: 25px;
            padding: 2.5rem;
            margin: 2rem auto;
            text-align: center;
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideUp 1s ease-out 0.8s both;
            max-width: 1200px;
        }
        
        .stat-item {
            animation: countUp 2s ease-out 2s both;
        }
        
        @keyframes countUp {
            from { opacity: 0; transform: scale(0.5); }
            to { opacity: 1; transform: scale(1); }
        }
        
        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(45deg, #ffd700, #ffed4e, #ffd700);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            animation: pulse 2s ease-in-out infinite;
        }
        
        @keyframes pulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.05); }
        }
        
        .stat-label {
            font-size: 1.1rem;
            color: rgba(255, 255, 255, 0.9);
            font-weight: 500;
        }
        
        .features-section {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 30px;
            padding: 4rem 2rem;
            margin: 3rem auto;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.15);
            animation: slideUp 1s ease-out 1.2s both;
            max-width: 1200px;
        }
        
        .feature-card {
            text-align: center;
            padding: 2.5rem 1.5rem;
            border-radius: 20px;
            background: #fff;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            height: 100%;
            border: 1px solid rgba(0, 0, 0, 0.05);
        }
        
        .feature-card:hover {
            transform: translateY(-10px) rotateY(5deg);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.2);
        }
        
        .feature-icon {
            font-size: 4rem;
            background: linear-gradient(45deg, #2c5aa0, #1e3c72);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1.5rem;
            animation: iconBounce 2s ease-in-out infinite;
        }
        
        @keyframes iconBounce {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-10px); }
        }
        
        .footer {
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(15px);
            padding: 3rem 0;
            color: #ffffff;
            margin-top: 3rem;
        }
        
        @media (max-width: 768px) {
            .main-title { font-size: 2.5rem; }
            .hero-section { padding: 2rem 1rem; }
            .option-btn { font-size: 1rem; padding: 0.8rem 1.5rem; }
            .stat-number { font-size: 2rem; }
        }
    </style>
</head>
<body>
    <div class="floating-shapes">
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
        <div class="shape"></div>
    </div>
    
    <div class="container-fluid px-3">
        <div class="hero-section">
            <div class="main-title">
                <i class="fas fa-heart text-danger me-3"></i>ShareBite
            </div>
            <div class="subtitle">Connecting Food Donors with NGOs</div>
            <div class="tagline">Reduce food waste. Support hunger relief. Make a difference.</div>
            
            <div class="row justify-content-center">
                <div class="col-md-4 text-center">
                    <a href="donorLogin.jsp" class="option-btn btn-donor">
                        <i class="fas fa-hand-holding-heart me-2"></i>Donor Portal
                    </a>
                </div>
                <div class="col-md-4 text-center">
                    <a href="ngoLogin.jsp" class="option-btn btn-ngo">
                        <i class="fas fa-users me-2"></i>NGO Portal
                    </a>
                </div>
                <div class="col-md-4 text-center">
                    <a href="adminLogin.jsp" class="option-btn btn-admin">
                        <i class="fas fa-shield-alt me-2"></i>Admin Portal
                    </a>
                </div>
            </div>
        </div>
        
        <div class="stats-section">
            <div class="row">
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">500+</div>
                        <div class="stat-label">Food Donations</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">50+</div>
                        <div class="stat-label">Verified NGOs</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">1000+</div>
                        <div class="stat-label">Lives Impacted</div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="stat-item">
                        <div class="stat-number">2.5T</div>
                        <div class="stat-label">Food Saved</div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="features-section">
            <h2 class="text-center mb-5">How Sharebite Works</h2>
            <div class="row">
                <div class="col-md-4 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-utensils"></i>
                        </div>
                        <h4>Donate Food</h4>
                        <p>Restaurants, caterers, and individuals can easily post surplus food with pickup details and expiry information.</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-search"></i>
                        </div>
                        <h4>Browse and Request</h4>
                        <p>Verified NGOs can search for available food donations in their area and request pickup with specific details.</p>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <i class="fas fa-truck"></i>
                        </div>
                        <h4>Connect and Deliver</h4>
                        <p>Donor approve requests and coordinate pickup, ensuring food reaches those who need it most.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <h5>About Sharebite</h5>
                    <p>Sharebite is a food rescue platform that connects food donors with verified NGOs to reduce food waste and support hunger relief efforts.</p>
                </div>
                <div class="col-md-6">
                    <h5>Contact Us</h5>
                    <p><i class="fas fa-envelope me-2"></i>info@sharebite.org</p>
                    <p><i class="fas fa-phone me-2"></i>+1 (555) 123-4567</p>
                </div>
            </div>
            <hr class="my-3">
            <p>&copy; <%= java.time.Year.now() %> Sharebite. All rights reserved. | Making food rescue simple and effective.</p>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>