<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="java.util.*" %>
<%
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");
if (userType == null || !"donor".equals(userType) || userId == null) {
    response.sendRedirect("donorLogin.jsp?error=not_authorized");
    return;
}
String foodIdParam = request.getParameter("id");
if (foodIdParam == null) {
    response.sendRedirect("donorDashboard.jsp?error=missing_id");
    
    return;
}
int foodId = Integer.parseInt(foodIdParam);
FoodListingBean food = FoodListingDAO.getFoodListingById(foodId);
if (food == null || food.getDonorId() != Integer.parseInt(userId)) {
    response.sendRedirect("donorDashboard.jsp?error=not_found");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Food Listing - Sharebite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .card {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border: none;
        }
        .form-control:focus, .form-select:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        .btn-success {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
        }
        .btn-success:hover {
            background: linear-gradient(135deg, #20c997, #17a2b8);
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="fas fa-edit me-2"></i>Edit Food Listing</h4>
                    </div>
                    <div class="card-body">
                        <form action="editFoodListingProcess.jsp" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="id" value="<%= food.getId() %>" />
                            
                            <div class="row">
                                <div class="col-md-8 mb-3">
                                    <label class="form-label">Food Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="foodName" value="<%= food.getFoodName() %>" required />
                                    <div class="invalid-feedback">Please provide a food name.</div>
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label">Food Type</label>
                                    <select class="form-select" name="foodType">
                                        <option value="Fruits" <%= "Fruits".equals(food.getFoodType()) ? "selected" : "" %>>Fruits</option>
                                        <option value="Vegetables" <%= "Vegetables".equals(food.getFoodType()) ? "selected" : "" %>>Vegetables</option>
                                        <option value="Dairy" <%= "Dairy".equals(food.getFoodType()) ? "selected" : "" %>>Dairy</option>
                                        <option value="Meat" <%= "Meat".equals(food.getFoodType()) ? "selected" : "" %>>Meat</option>
                                        <option value="Bakery" <%= "Bakery".equals(food.getFoodType()) ? "selected" : "" %>>Bakery</option>
                                        <option value="Prepared" <%= "Prepared".equals(food.getFoodType()) ? "selected" : "" %>>Prepared Food</option>
                                        <option value="Other" <%= "Other".equals(food.getFoodType()) ? "selected" : "" %>>Other</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Description</label>
                                <textarea class="form-control" name="description" rows="2" placeholder="Describe the food item"><%= food.getDescription() != null ? food.getDescription() : "" %></textarea>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Quantity <span class="text-danger">*</span></label>
                                    <input type="number" class="form-control" name="quantity" value="<%= food.getQuantity() %>" min="1" step="0.1" required />
                                    <div class="invalid-feedback">Please provide quantity.</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Unit <span class="text-danger">*</span></label>
                                    <select class="form-select" name="quantityUnit" required>
                                        <option value="kg" <%= "kg".equals(food.getQuantityUnit()) ? "selected" : "" %>>Kilograms (kg)</option>
                                        <option value="grams" <%= "grams".equals(food.getQuantityUnit()) ? "selected" : "" %>>Grams (g)</option>
                                        <option value="pieces" <%= "pieces".equals(food.getQuantityUnit()) ? "selected" : "" %>>Pieces</option>
                                        <option value="liters" <%= "liters".equals(food.getQuantityUnit()) ? "selected" : "" %>>Liters (L)</option>
                                        <option value="plates" <%= "plates".equals(food.getQuantityUnit()) ? "selected" : "" %>>Plates</option>
                                        <option value="boxes" <%= "boxes".equals(food.getQuantityUnit()) ? "selected" : "" %>>Boxes</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Expiry Date</label>
                                    <input type="date" class="form-control" name="expiryDate" value="<%= food.getExpiryDate() != null ? food.getExpiryDate().toString() : "" %>" />
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Storage Conditions</label>
                                    <input type="text" class="form-control" name="storageCondition" value="<%= food.getStorageCondition() != null ? food.getStorageCondition() : "" %>" placeholder="e.g., Refrigerated, Room Temperature" />
                                </div>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Pickup Instructions</label>
                                <textarea class="form-control" name="pickupInstructions" rows="2" placeholder="Special instructions for pickup"><%= food.getPickupInstructions() != null ? food.getPickupInstructions() : "" %></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Status <span class="text-danger">*</span></label>
                                <select class="form-select" name="status" required>
                                    <option value="Available" <%= "Available".equals(food.getStatus()) ? "selected" : "" %>>Available</option>
                                    <option value="Reserved" <%= "Reserved".equals(food.getStatus()) ? "selected" : "" %>>Reserved</option>
                                    <option value="Collected" <%= "Collected".equals(food.getStatus()) ? "selected" : "" %>>Collected</option>
                                    <option value="Expired" <%= "Expired".equals(food.getStatus()) ? "selected" : "" %>>Expired</option>
                                    <option value="Inactive" <%= "Inactive".equals(food.getStatus()) ? "selected" : "" %>>Inactive</option>
                                </select>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save me-2"></i>Save Changes
                                </button>
                                <a href="donorDashboard.jsp" class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        (function() {
            'use strict';
            window.addEventListener('load', function() {
                var forms = document.getElementsByClassName('needs-validation');
                var validation = Array.prototype.filter.call(forms, function(form) {
                    form.addEventListener('submit', function(event) {
                        if (form.checkValidity() === false) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            }, false);
        })();
        
        // Set minimum date to today for expiry date
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            const expiryInput = document.querySelector('input[name="expiryDate"]');
            if (expiryInput) {
                expiryInput.min = today;
            }
        });
    </script>
</body>
</html>
