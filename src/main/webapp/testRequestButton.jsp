<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Test Request Button</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Test Request Button Functionality</h2>
        
        <%
        // Check session
        String userType = (String) session.getAttribute("userType");
        String userId = (String) session.getAttribute("userId");
        
        if (userType == null || !"ngo".equals(userType) || userId == null) {
        %>
            <div class="alert alert-warning">
                <h5>Please log in as NGO first</h5>
                <a href="ngoLogin.jsp" class="btn btn-primary">NGO Login</a>
            </div>
        <%
        } else {
            // Get available food listings
            List<FoodListingBean> availableFood = FoodListingDAO.getAllFoodListings();
            
            if (availableFood != null && !availableFood.isEmpty()) {
                FoodListingBean testFood = availableFood.get(0);
        %>
                <div class="alert alert-info">
                    <h5>Session Info:</h5>
                    User Type: <%= userType %><br>
                    User ID: <%= userId %><br>
                    Test Food: <%= testFood.getFoodName() %> (ID: <%= testFood.getId() %>)
                </div>
                
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title"><%= testFood.getFoodName() %></h5>
                        <p class="card-text"><%= testFood.getDescription() %></p>
                        <p class="text-muted">
                            <strong>Quantity:</strong> <%= testFood.getQuantity() %> <%= testFood.getQuantityUnit() %><br>
                            <strong>Expires:</strong> <%= testFood.getExpiryDate() %><br>
                            <strong>Location:</strong> <%= testFood.getPickupCity() %>, <%= testFood.getPickupState() %>
                        </p>
                        <button class="btn btn-primary" onclick="testRequestFood('<%= testFood.getId() %>')">
                            Test Request Button
                        </button>
                    </div>
                </div>
                
                <!-- Test Modal -->
                <div class="modal fade" id="testRequestModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title">Test Food Request</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <form id="testRequestForm">
                                    <input type="hidden" id="foodListingId" name="foodListingId">
                                    <div class="mb-3">
                                        <label for="pickupDate" class="form-label">Pickup Date *</label>
                                        <input type="date" class="form-control" id="pickupDate" name="pickupDate" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="pickupTime" class="form-label">Pickup Time</label>
                                        <input type="time" class="form-control" id="pickupTime" name="pickupTime">
                                    </div>
                                    <div class="mb-3">
                                        <label for="requestMessage" class="form-label">Request Message</label>
                                        <textarea class="form-control" id="requestMessage" name="requestMessage" rows="3">Test request from test page</textarea>
                                    </div>
                                </form>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" class="btn btn-primary" onclick="submitTestRequest()">Submit Test Request</button>
                            </div>
                        </div>
                    </div>
                </div>
                
                <div id="result" class="mt-4"></div>
        <%
            } else {
        %>
                <div class="alert alert-warning">
                    <h5>No food listings available for testing</h5>
                </div>
        <%
            }
        }
        %>
        
        <div class="mt-4">
            <a href="ngoDashboard.jsp" class="btn btn-secondary">Back to NGO Dashboard</a>
            <a href="debugRequestSubmission.jsp" class="btn btn-info">Debug Page</a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function testRequestFood(foodListingId) {
            document.getElementById('foodListingId').value = foodListingId;
            
            // Set minimum date to today
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('pickupDate').min = today;
            document.getElementById('pickupDate').value = today;
            document.getElementById('pickupTime').value = '14:00';
            
            // Show modal
            const modal = new bootstrap.Modal(document.getElementById('testRequestModal'));
            modal.show();
        }
        
        function submitTestRequest() {
            const form = document.getElementById('testRequestForm');
            const formData = new FormData(form);
            
            // Show loading
            document.getElementById('result').innerHTML = '<div class="alert alert-info">Submitting request...</div>';
            
            fetch('submitFoodRequest.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                console.log('Response status:', response.status);
                console.log('Response redirected:', response.redirected);
                console.log('Response URL:', response.url);
                
                if (response.redirected) {
                    // Check if redirected to success or error
                    if (response.url.includes('success=request_submitted')) {
                        document.getElementById('result').innerHTML = '<div class="alert alert-success">✅ SUCCESS: Request submitted successfully!</div>';
                    } else if (response.url.includes('error=')) {
                        const errorParam = new URL(response.url).searchParams.get('error');
                        document.getElementById('result').innerHTML = '<div class="alert alert-danger">❌ ERROR: ' + errorParam + '</div>';
                    } else {
                        document.getElementById('result').innerHTML = '<div class="alert alert-warning">⚠️ Redirected to: ' + response.url + '</div>';
                    }
                } else {
                    return response.text();
                }
            })
            .then(data => {
                if (data) {
                    console.log('Response data:', data);
                    document.getElementById('result').innerHTML = '<div class="alert alert-info">Response received:<br><pre>' + data.substring(0, 500) + '</pre></div>';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                document.getElementById('result').innerHTML = '<div class="alert alert-danger">❌ Network Error: ' + error.message + '</div>';
            });
            
            // Hide modal
            const modal = bootstrap.Modal.getInstance(document.getElementById('testRequestModal'));
            modal.hide();
        }
    </script>
</body>
</html>