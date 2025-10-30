<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Enable Request Functionality - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
    <div class="container mt-4">
        <h2>Request Functionality Status</h2>
        
        <%
        // Check if user is logged in as NGO
        String userType = (String) session.getAttribute("userType");
        String userId = (String) session.getAttribute("userId");
        
        if (userType != null && "ngo".equals(userType) && userId != null) {
            out.println("<div class='alert alert-success'>✓ NGO Session Active - User ID: " + userId + "</div>");
            
            // Get available food listings
            List<FoodListingBean> availableFood = FoodListingDAO.getAllFoodListings();
            
            if (availableFood != null && !availableFood.isEmpty()) {
                out.println("<div class='alert alert-success'>✓ Food Listings Available: " + availableFood.size() + "</div>");
                
                out.println("<h4>Available Food Items (Request Enabled)</h4>");
                out.println("<div class='row'>");
                
                for (FoodListingBean food : availableFood) {
                    if ("Available".equals(food.getStatus())) {
                        out.println("<div class='col-md-6 mb-3'>");
                        out.println("<div class='card'>");
                        out.println("<div class='card-body'>");
                        out.println("<h5 class='card-title'>" + food.getFoodName() + "</h5>");
                        out.println("<p class='card-text'>");
                        out.println("<strong>Type:</strong> " + food.getFoodType() + "<br>");
                        out.println("<strong>Quantity:</strong> " + food.getQuantity() + " " + food.getQuantityUnit() + "<br>");
                        out.println("<strong>Expires:</strong> " + food.getExpiryDate() + "<br>");
                        out.println("<strong>Location:</strong> " + food.getPickupCity() + ", " + food.getPickupState());
                        out.println("</p>");
                        
                        // Check if NGO already has an active request for this food
                        boolean hasActiveRequest = FoodRequestDAO.hasActiveRequest(Integer.parseInt(userId), food.getId());
                        
                        if (hasActiveRequest) {
                            out.println("<button class='btn btn-secondary' disabled>");
                            out.println("<i class='fas fa-clock me-2'></i>Already Requested");
                            out.println("</button>");
                        } else {
                            out.println("<button class='btn btn-success' onclick='requestFood(" + food.getId() + ")'>");
                            out.println("<i class='fas fa-hand-holding-heart me-2'></i>Request Food");
                            out.println("</button>");
                        }
                        
                        out.println("</div>");
                        out.println("</div>");
                        out.println("</div>");
                    }
                }
                out.println("</div>");
            } else {
                out.println("<div class='alert alert-warning'>⚠ No Food Listings Available</div>");
            }
            
        } else if (userType != null && "donor".equals(userType) && userId != null) {
            out.println("<div class='alert alert-info'>ℹ Donor Session Active - User ID: " + userId + "</div>");
            out.println("<p>As a donor, you can view NGO requests in your dashboard.</p>");
            out.println("<a href='donorDashboard.jsp' class='btn btn-primary'>Go to Donor Dashboard</a>");
            
        } else {
            out.println("<div class='alert alert-danger'>✗ No Active Session</div>");
            out.println("<p>Please log in as an NGO to test request functionality.</p>");
            out.println("<a href='ngoLogin.jsp' class='btn btn-success me-2'>NGO Login</a>");
            out.println("<a href='donorLogin.jsp' class='btn btn-primary'>Donor Login</a>");
        }
        %>
        
        <hr>
        <div class="mt-4">
            <h4>Quick Links</h4>
            <a href="ngoDashboard.jsp" class="btn btn-success me-2">NGO Dashboard</a>
            <a href="donorDashboard.jsp" class="btn btn-primary me-2">Donor Dashboard</a>
            <a href="testRequestFlow.jsp" class="btn btn-info">Test Request Flow</a>
        </div>
    </div>

    <!-- Food Request Modal -->
    <div class="modal fade" id="requestModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Request Food Item</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="requestForm" class="needs-validation" novalidate>
                        <input type="hidden" id="foodListingId" name="foodListingId">
                        <div class="mb-3">
                            <label for="pickupDate" class="form-label">Pickup Date *</label>
                            <input type="date" class="form-control" id="pickupDate" name="pickupDate" required>
                            <div class="invalid-feedback">Please select a pickup date.</div>
                        </div>
                        <div class="mb-3">
                            <label for="pickupTime" class="form-label">Pickup Time</label>
                            <input type="time" class="form-control" id="pickupTime" name="pickupTime">
                        </div>
                        <div class="mb-3">
                            <label for="requestMessage" class="form-label">Request Message</label>
                            <textarea class="form-control" id="requestMessage" name="requestMessage" rows="3" 
                                      placeholder="Any special instructions or requirements..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary" onclick="submitRequest()">Submit Request</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        function requestFood(foodListingId) {
            document.getElementById('foodListingId').value = foodListingId;
            
            // Set minimum date to today
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('pickupDate').min = today;
            
            // Show modal
            const modal = new bootstrap.Modal(document.getElementById('requestModal'));
            modal.show();
        }
        
        function submitRequest() {
            const form = document.getElementById('requestForm');
            if (!form.checkValidity()) {
                form.classList.add('was-validated');
                return;
            }
            
            const formData = new FormData(form);
            
            fetch('submitFoodRequest.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.redirected) {
                    window.location.href = response.url;
                } else {
                    return response.text();
                }
            })
            .then(data => {
                if (data && data.includes('error')) {
                    alert('Error submitting request. Please try again.');
                } else {
                    const modal = bootstrap.Modal.getInstance(document.getElementById('requestModal'));
                    modal.hide();
                    alert('Food request submitted successfully!');
                    location.reload();
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error submitting request. Please try again.');
            });
        }
        
        // Set today's date as minimum for pickup date when page loads
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            const pickupDateInput = document.getElementById('pickupDate');
            if (pickupDateInput) {
                pickupDateInput.min = today;
            }
        });
    </script>
</body>
</html>