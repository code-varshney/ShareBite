<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Donor Registration - Sharebite</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }
        
        .register-container {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 3rem;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 800px;
        }
        
        .logo-section {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .logo-icon {
            font-size: 3rem;
            color: #28a745;
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
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        
        .btn-register {
            background: linear-gradient(45deg, #28a745, #20c997);
            border: none;
            border-radius: 10px;
            padding: 0.75rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
            width: 100%;
        }
        
        .btn-register:hover {
            background: linear-gradient(45deg, #218838, #1ea085);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(40, 167, 69, 0.3);
        }
        
        .form-label {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .back-link {
            text-align: center;
            margin-top: 2rem;
        }
        
        .back-link a {
            color: #28a745;
            text-decoration: none;
            font-weight: 500;
        }
        
        .back-link a:hover {
            color: #218838;
        }
        
        .alert {
            border-radius: 10px;
            border: none;
        }
        
        .progress-bar {
            background: linear-gradient(45deg, #28a745, #20c997);
        }
        
        .step-indicator {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
            position: relative;
        }
        
        .step-indicator::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: #e9ecef;
            z-index: 1;
        }
        
        .step {
            background: #fff;
            border: 2px solid #e9ecef;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: #6c757d;
            position: relative;
            z-index: 2;
            transition: all 0.3s ease;
        }
        
        .step.active {
            border-color: #28a745;
            background: #28a745;
            color: white;
        }
        
        .step.completed {
            border-color: #28a745;
            background: #28a745;
            color: white;
        }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="logo-section">
            <div class="logo-icon">
                <i class="fas fa-hand-holding-heart"></i>
            </div>
            <div class="logo-title">Sharebite</div>
            <div class="logo-subtitle">Donor Registration</div>
        </div>
        
        <%-- Show error messages based on error query parameter --%>
        <% String error = request.getParameter("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger" role="alert">
                <% if ("missing_fields".equals(error)) { %>
                    Please fill in all required fields.
                <% } else if ("password_mismatch".equals(error)) { %>
                    Password and Confirm Password do not match.
                <% } else if ("password_short".equals(error)) { %>
                    Password must be at least 6 characters long.
                <% } else if ("username_exists".equals(error)) { %>
                    Username already exists. Please choose another.
                <% } else if ("email_exists".equals(error)) { %>
                    Email already exists. Please use another.
                <% } else if ("registration_failed".equals(error)) { %>
                    Registration failed. Please try again.
                <% } else { %>
                    Registration failed. Please check your details and try again.
                <% } %>
            </div>
        <% } %>
        
        <form action="donorRegisterProcess.jsp" method="post" id="registrationForm">
            <!-- All fields in one step -->
            <h5 class="mb-4 text-center">Donor Registration</h5>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="firstName" class="form-label">First Name *</label>
                    <input type="text" class="form-control" id="firstName" name="firstName" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="lastName" class="form-label">Last Name *</label>
                    <input type="text" class="form-control" id="lastName" name="lastName" required>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="email" class="form-label">Email *</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="password" class="form-label">Password *</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="confirmPassword" class="form-label">Confirm Password *</label>
                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                </div>
            </div>
            <div class="mb-3">
                <label for="phone" class="form-label">Phone Number *</label>
                <input type="tel" class="form-control" id="phone" name="phone" required>
            </div>
            <div class="mb-3">
                <label for="address" class="form-label">Address *</label>
                <textarea class="form-control" id="address" name="address" rows="2" required></textarea>
            </div>
            <div class="row">
                <div class="col-md-4 mb-3">
                    <label for="city" class="form-label">City *</label>
                    <input type="text" class="form-control" id="city" name="city" required>
                </div>
                <div class="col-md-4 mb-3">
                    <label for="state" class="form-label">State *</label>
                    <input type="text" class="form-control" id="state" name="state" required>
                </div>
                <div class="col-md-4 mb-3">
                    <label for="zipCode" class="form-label">ZIP Code *</label>
                    <input type="text" class="form-control" id="zipCode" name="zipCode" required>
                </div>
            </div>
            <div class="mb-3">
                <label for="organizationName" class="form-label">Organization/Business Name</label>
                <input type="text" class="form-control" id="organizationName" name="organizationName" placeholder="Restaurant, Catering Service, etc. (Optional)">
            </div>
            <div class="mb-3">
                <label for="organizationType" class="form-label">Type of Organization</label>
                <select class="form-select" id="organizationType" name="organizationType">
                    <option value="">Select Organization Type</option>
                    <option value="restaurant">Restaurant</option>
                    <option value="catering">Catering Service</option>
                    <option value="bakery">Bakery</option>
                    <option value="grocery">Grocery Store</option>
                    <option value="individual">Individual</option>
                    <option value="other">Other</option>
                </select>
            </div>
            <div class="mb-4">
                <label for="donationFrequency" class="form-label">Expected Donation Frequency</label>
                <select class="form-select" id="donationFrequency" name="donationFrequency">
                    <option value="">Select Frequency</option>
                    <option value="daily">Daily</option>
                    <option value="weekly">Weekly</option>
                    <option value="monthly">Monthly</option>
                    <option value="occasionally">Occasionally</option>
                </select>
            </div>
            <div class="form-check mb-4">
                <input class="form-check-input" type="checkbox" id="termsAccepted" name="termsAccepted" required>
                <label class="form-check-label" for="termsAccepted">
                    I agree to the <a href="#" class="text-decoration-none">Terms of Service</a> and 
                    <a href="#" class="text-decoration-none">Privacy Policy</a> *
                </label>
            </div>
            <div class="text-center">
                <button type="submit" class="btn btn-register">
                    <i class="fas fa-user-plus me-2"></i>Complete Registration
                </button>
            </div>
        </form>
        
        <div class="back-link">
            <a href="donorLogin.jsp">
                <i class="fas fa-arrow-left me-2"></i>Back to Login
            </a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Remove step logic, keep only validation for all fields
        function validateForm() {
            let isValid = true;
            const requiredFields = document.querySelectorAll('#registrationForm [required]');
            requiredFields.forEach(field => {
                if ((field.type === 'checkbox' && !field.checked) || (!field.type || field.value.trim() === '')) {
                    field.classList.add('is-invalid');
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });
            // Password match and length
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            if (password !== confirmPassword) {
                document.getElementById('confirmPassword').classList.add('is-invalid');
                isValid = false;
            }
            if (password.length < 6) {
                document.getElementById('password').classList.add('is-invalid');
                isValid = false;
            }
            return isValid;
        }
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
            if (!validateForm()) {
                e.preventDefault();
                alert('Please complete all required fields correctly.');
                return false;
            }
        });
    </script>
</body>
</html>
