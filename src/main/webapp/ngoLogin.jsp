<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>NGO Login - Sharebite</title>
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
            background: linear-gradient(-45deg, #667eea, #764ba2, #2c5aa0, #1e3c72);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            padding: 2rem 0;
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
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            animation: float 8s ease-in-out infinite;
        }
        
        .shape:nth-child(1) { width: 70px; height: 70px; top: 15%; left: 15%; animation-delay: 0s; }
        .shape:nth-child(2) { width: 90px; height: 90px; top: 70%; right: 10%; animation-delay: 3s; }
        .shape:nth-child(3) { width: 50px; height: 50px; bottom: 25%; left: 25%; animation-delay: 6s; }
        .shape:nth-child(4) { width: 110px; height: 110px; top: 40%; right: 30%; animation-delay: 1.5s; }
        
        @keyframes float {
            0%, 100% { transform: translateY(0px) rotate(0deg); }
            50% { transform: translateY(-25px) rotate(180deg); }
        }
        
        .login-container {
            background: rgba(255, 255, 255, 0.12);
            backdrop-filter: blur(25px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            border-radius: 30px;
            padding: 3.5rem 3rem;
            box-shadow: 0 25px 70px rgba(0, 0, 0, 0.25);
            width: 100%;
            max-width: 480px;
            margin: 0 auto;
            animation: slideUp 1.2s ease-out;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(60px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .logo-section {
            text-align: center;
            margin-bottom: 2.5rem;
            animation: fadeIn 1.5s ease-out 0.4s both;
        }
        
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(25px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .logo-icon {
            font-size: 4.5rem;
            background: linear-gradient(45deg, #fff, #e3f2fd, #fff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 1.2rem;
            animation: iconFloat 3s ease-in-out infinite;
            filter: drop-shadow(0 0 15px rgba(255, 255, 255, 0.4));
        }
        
        @keyframes iconFloat {
            0%, 100% { transform: translateY(0px) scale(1); }
            50% { transform: translateY(-8px) scale(1.05); }
        }
        
        .logo-title {
            font-size: 2.8rem;
            font-weight: 800;
            background: linear-gradient(45deg, #fff, #e3f2fd, #fff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.6rem;
            text-shadow: 0 0 25px rgba(255, 255, 255, 0.6);
        }
        
        .logo-subtitle {
            color: rgba(255, 255, 255, 0.95);
            font-size: 1.2rem;
            font-weight: 500;
            letter-spacing: 0.5px;
        }
        
        .verification-notice {
            background: rgba(255, 193, 7, 0.15);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 193, 7, 0.3);
            color: rgba(255, 255, 255, 0.95);
            padding: 1.2rem;
            border-radius: 18px;
            margin-bottom: 2rem;
            font-size: 0.95rem;
            animation: slideDown 0.8s ease-out 0.6s both;
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-25px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .form-control {
            border-radius: 18px;
            border: 2px solid rgba(255, 255, 255, 0.15);
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(15px);
            padding: 1.1rem 1.3rem;
            font-size: 1rem;
            color: #fff;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.65);
        }
        
        .form-control:focus {
            border-color: rgba(255, 255, 255, 0.4);
            background: rgba(255, 255, 255, 0.15);
            box-shadow: 0 0 0 0.25rem rgba(255, 255, 255, 0.2);
            transform: translateY(-3px);
        }
        
        .btn-login {
            background: linear-gradient(135deg, #fff, #e3f2fd, #bbdefb);
            border: none;
            border-radius: 18px;
            padding: 1.1rem 2.5rem;
            font-size: 1.15rem;
            font-weight: 700;
            color: #1e3c72;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            width: 100%;
            position: relative;
            overflow: hidden;
        }
        
        .btn-login::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(30, 60, 114, 0.15), transparent);
            transition: left 0.6s;
        }
        
        .btn-login:hover::before {
            left: 100%;
        }
        
        .btn-login:hover {
            transform: translateY(-4px) scale(1.02);
            box-shadow: 0 12px 35px rgba(255, 255, 255, 0.25);
            color: #0d47a1;
        }
        
        .form-label {
            font-weight: 600;
            color: rgba(255, 255, 255, 0.95);
            margin-bottom: 0.8rem;
            font-size: 1.05rem;
        }
        
        .input-group-text {
            background: rgba(255, 255, 255, 0.08);
            backdrop-filter: blur(15px);
            border: 2px solid rgba(255, 255, 255, 0.15);
            border-right: none;
            border-radius: 18px 0 0 18px;
            color: rgba(255, 255, 255, 0.8);
        }
        
        .input-group .form-control {
            border-left: none;
            border-radius: 0 18px 18px 0;
        }
        
        .back-link {
            text-align: center;
            margin-top: 2.5rem;
        }
        
        .back-link a {
            color: rgba(255, 255, 255, 0.9);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            font-size: 1rem;
        }
        
        .back-link a:hover {
            color: #fff;
            transform: translateX(-8px);
        }
        
        .alert {
            border-radius: 18px;
            border: none;
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(15px);
            animation: alertSlide 0.6s ease-out;
        }
        
        @keyframes alertSlide {
            from { opacity: 0; transform: translateY(-25px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .btn-outline-primary {
            border: 2px solid rgba(255, 255, 255, 0.4);
            color: rgba(255, 255, 255, 0.95);
            background: transparent;
            border-radius: 18px;
            padding: 0.7rem 1.8rem;
            font-weight: 600;
            transition: all 0.4s ease;
        }
        
        .btn-outline-primary:hover {
            background: rgba(255, 255, 255, 0.15);
            border-color: rgba(255, 255, 255, 0.6);
            color: #fff;
            transform: translateY(-3px);
        }
        
        @media (max-width: 768px) {
            body { padding: 1rem; }
            .login-container { padding: 2.5rem 2rem; margin: 1rem auto; }
            .logo-title { font-size: 2.2rem; }
            .logo-icon { font-size: 3.5rem; }
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
    
    <div class="login-container">
        <div class="logo-section">
            <div class="logo-icon">
                <i class="fas fa-users"></i>
            </div>
            <div class="logo-title">Sharebite</div>
            <div class="logo-subtitle">NGO Portal</div>
        </div>
        
        <div class="verification-notice">
            <i class="fas fa-info-circle me-2"></i>
            <strong>Note:</strong> NGO accounts require verification before access. Please allow 24-48 hours for verification.
        </div>
        
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                <% String error = request.getParameter("error");
                   if ("empty_fields".equals(error)) { %>
                       Please enter both email and password.
                   <% } else if ("invalid_credentials".equals(error)) { %>
                       Invalid email or password.
                   <% } else if ("not_ngo".equals(error)) { %>
                       This account is not registered as an NGO.
                   <% } else if ("pending".equals(error)) { %>
                       Your NGO account is pending verification. Please wait for admin approval.
                   <% } else if ("rejected".equals(error)) { %>
                       Your NGO registration was rejected. Please register again.
                   <% } %>
            </div>
        <% } %>
        
        <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success" role="alert">
                <i class="fas fa-check-circle me-2"></i>
                Registration successful! Please wait for verification.
            </div>
        <% } %>
        
        <form action="ngoLoginProcess.jsp" method="post" id="loginForm">
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-envelope"></i>
                    </span>
                    <input type="email" class="form-control" id="email" name="email" 
                           placeholder="Enter your email" required>
                </div>
            </div>
            
            <div class="mb-4">
                <label for="password" class="form-label">Password</label>
                <div class="input-group">
                    <span class="input-group-text">
                        <i class="fas fa-lock"></i>
                    </span>
                    <input type="password" class="form-control" id="password" name="password" 
                           placeholder="Enter your password" required>
                </div>
            </div>
            
            <button type="submit" class="btn btn-login">
                <i class="fas fa-sign-in-alt me-2"></i>Login
            </button>
        </form>
        
        <div class="text-center mt-3">
            <p class="mb-2">Don't have an account?</p>
            <a href="ngoRegister.jsp" class="btn btn-outline-primary">
                <i class="fas fa-user-plus me-2"></i>Register as NGO
            </a>
        </div>
        
        <div class="back-link">
            <a href="index.jsp">
                <i class="fas fa-arrow-left me-2"></i>Back to Home
            </a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('loginForm').addEventListener('submit', function(e) {
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value.trim();
            
            if (!email || !password) {
                e.preventDefault();
                alert('Please fill in all fields');
                return false;
            }
        });
    </script>
</body>
</html>



