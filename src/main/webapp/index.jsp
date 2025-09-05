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
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            position: relative;
            overflow-x: hidden;
            color: #2c3e50;
        }
        
        .hero-section {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 3rem;
            margin: 2rem 0;
            text-align: center;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        
        .main-title {
            font-size: 3.5rem;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            letter-spacing: 1px;
        }
        
        .subtitle {
            font-size: 1.4rem;
            color: #ffffff;
            margin-bottom: 2rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.2);
            font-weight: 300;
        }
        
        .tagline {
            font-size: 1.1rem;
            color: #e8f4fd;
            margin-bottom: 2rem;
            font-weight: 400;
        }
        
        .option-btn {
            font-size: 1.2rem;
            padding: 1.2rem 2.5rem;
            border-radius: 50px;
            margin: 0.8rem;
            font-weight: 600;
            letter-spacing: 0.5px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 24px rgba(13,110,253,0.15);
            border: none;
            outline: none;
            text-decoration: none;
            color: #fff;
            position: relative;
            overflow: hidden;
            display: inline-block;
        }
        
        .btn-donor {
            background: linear-gradient(45deg, #28a745, #20c997);
        }
        
        .btn-donor:hover {
            background: linear-gradient(45deg, #218838, #1ea085);
            color: #fff;
            transform: translateY(-3px);
            box-shadow: 0 8px 32px rgba(40, 167, 69, 0.3);
        }
        
        .btn-ngo {
            background: linear-gradient(45deg, #007bff, #6610f2);
        }
        
        .btn-ngo:hover {
            background: linear-gradient(45deg, #0056b3, #520dc2);
            color: #fff;
            transform: translateY(-3px);
            box-shadow: 0 8px 32px rgba(0, 123, 255, 0.3);
        }
        
        .btn-admin {
            background: linear-gradient(45deg, #6c757d, #495057);
        }
        
        .btn-admin:hover {
            background: linear-gradient(45deg, #545b62, #343a40);
            color: #fff;
            transform: translateY(-3px);
            box-shadow: 0 8px 32px rgba(108, 117, 125, 0.3);
        }
        
        .features-section {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 3rem;
            margin: 2rem 0;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
        }
        
        .feature-card {
            text-align: center;
            padding: 2rem;
            border-radius: 15px;
            background: #fff;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease;
            height: 100%;
        }
        
        .feature-card:hover {
            transform: translateY(-5px);
        }
        
        .feature-icon {
            font-size: 3rem;
            color: #667eea;
            margin-bottom: 1rem;
        }
        
        .footer {
            margin-top: auto;
            padding: 2rem 0;
            background: rgba(0, 0, 0, 0.2);
            backdrop-filter: blur(10px);
            text-align: center;
            color: #ffffff;
            font-weight: 300;
        }
        
        .stats-section {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 2rem;
            margin: 2rem 0;
            text-align: center;
        }
        
        .stat-item {
            color: #ffffff;
            margin: 1rem 0;
        }
        
        .stat-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #ffd700;
        }
        
        .stat-label {
            font-size: 1rem;
            color: #e8f4fd;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="hero-section">
            <div class="main-title">
                <i class="fas fa-heart text-danger me-3"></i>Sharebite
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