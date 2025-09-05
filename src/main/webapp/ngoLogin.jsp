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
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 450px;
        }
        
        .logo-section {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .logo-icon {
            font-size: 3rem;
            color: #007bff;
            margin-bottom: 1rem;
        }
        
        .logo-title {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .logo-subtitle {
            color: #6c757d;
            font-size: 1rem;
        }
        
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 0.75rem 1rem;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        
        .btn-login {
            background: linear-gradient(45deg, #007bff, #6610f2);
            border: none;
            border-radius: 10px;
            padding: 0.75rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .btn-login:hover {
            background: linear-gradient(45deg, #0056b3, #520dc2);
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0, 123, 255, 0.3);
        }
        
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .input-group-text {
            background: #f8f9fa;
            border: 2px solid #e9ecef;
            border-right: none;
            border-radius: 10px 0 0 10px;
        }
        
        .input-group .form-control {
            border-left: none;
            border-radius: 0 10px 10px 0;
        }
        
        .back-link {
            text-align: center;
            margin-top: 2rem;
        }
        
        .back-link a {
            color: #007bff;
            text-decoration: none;
            font-weight: 500;
        }
        
        .back-link a:hover {
            color: #0056b3;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
        }
        
        .verification-notice {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            color: #856404;
            padding: 1rem;
            border-radius: 10px;
            margin-bottom: 1.5rem;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
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



