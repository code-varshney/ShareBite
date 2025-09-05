<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>NGO Registration - Sharebite</title>
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
        .btn-register {
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
        .btn-register:hover {
            background: linear-gradient(45deg, #0056b3, #520dc2);
            color: #fff;
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0, 123, 255, 0.3);
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
    <div class="register-container">
        <div class="logo-section">
            <div class="logo-icon">
                <i class="fas fa-users"></i>
            </div>
            <div class="logo-title">Sharebite</div>
            <div class="logo-subtitle">NGO Registration</div>
        </div>
        <div class="verification-notice">
            <i class="fas fa-info-circle me-2"></i>
            <strong>Important:</strong> NGO accounts require verification before access. Please allow 24-48 hours for admin verification after registration.
        </div>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-danger" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                Registration failed. Please try again.
            </div>
        <% } %>
        <form action="ngoRegisterProcess.jsp" method="post" id="registrationForm">
            <h5 class="mb-4 text-center">NGO Registration</h5>
            <div class="mb-3">
                <label for="organizationName" class="form-label">Organization Name *</label>
                <input type="text" class="form-control" id="organizationName" name="organizationName" required>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="organizationType" class="form-label">Organization Type *</label>
                    <select class="form-select" id="organizationType" name="organizationType" required>
                        <option value="">Select Organization Type</option>
                        <option value="food_bank">Food Bank</option>
                        <option value="shelter">Homeless Shelter</option>
                        <option value="community_kitchen">Community Kitchen</option>
                        <option value="charity">Charity Organization</option>
                        <option value="religious">Religious Organization</option>
                        <option value="other">Other</option>
                    </select>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="registrationNumber" class="form-label">Registration Number</label>
                    <input type="text" class="form-control" id="registrationNumber" name="registrationNumber" placeholder="Legal registration number (if applicable)">
                </div>
            </div>
            <div class="mb-3">
                <label for="mission" class="form-label">Mission Statement</label>
                <textarea class="form-control" id="mission" name="mission" rows="3" placeholder="Brief description of your organization's mission and goals"></textarea>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="contactPerson" class="form-label">Primary Contact Person *</label>
                    <input type="text" class="form-control" id="contactPerson" name="contactPerson" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="contactTitle" class="form-label">Contact Person Title</label>
                    <input type="text" class="form-control" id="contactTitle" name="contactTitle" placeholder="e.g., Director, Manager, Coordinator">
                </div>
            </div>
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label for="email" class="form-label">Email Address *</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label for="phone" class="form-label">Phone Number *</label>
                    <input type="tel" class="form-control" id="phone" name="phone" required>
                </div>
            </div>
            <div class="mb-3">
                <label for="website" class="form-label">Website</label>
                <input type="url" class="form-control" id="website" name="website" placeholder="https://www.yourorganization.org">
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
                <label for="address" class="form-label">Organization Address *</label>
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
                <label for="serviceArea" class="form-label">Service Area</label>
                <textarea class="form-control" id="serviceArea" name="serviceArea" rows="2" placeholder="Describe the geographic area you serve"></textarea>
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
            <a href="ngoLogin.jsp">
                <i class="fas fa-arrow-left me-2"></i>Back to Login
            </a>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Single-step form validation
        document.getElementById('registrationForm').addEventListener('submit', function(e) {
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
            if (!isValid) {
                e.preventDefault();
                alert('Please complete all required fields correctly.');
                return false;
            }
        });
    </script>
</body>
</html>