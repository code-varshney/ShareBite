<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%
String foodIdParam = request.getParameter("id");
if (foodIdParam == null) {
    response.sendRedirect("donorDashboard.jsp");
    return;
}

int foodId = Integer.parseInt(foodIdParam);
FoodListingBean food = FoodListingDAO.getFoodListingById(foodId);

if (food == null) {
    response.sendRedirect("donorDashboard.jsp?error=food_not_found");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Food Listing - <%= food.getFoodName() %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body class="bg-light">
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-success text-white">
                        <h4><i class="fas fa-utensils me-2"></i><%= food.getFoodName() %></h4>
                    </div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Food Details</h6>
                                <p><strong>Type:</strong> <%= food.getFoodType() != null ? food.getFoodType() : "Not specified" %></p>
                                <p><strong>Quantity:</strong> <%= food.getQuantity() %> <%= food.getQuantityUnit() %></p>
                                <p><strong>Status:</strong> 
                                    <span class="badge <%= food.getStatus().equals("Available") ? "bg-success" : 
                                        food.getStatus().equals("Reserved") ? "bg-warning" : 
                                        food.getStatus().equals("Collected") ? "bg-info" : "bg-secondary" %>">
                                        <%= food.getStatus() %>
                                    </span>
                                </p>
                                <% if (food.getDescription() != null && !food.getDescription().isEmpty()) { %>
                                <p><strong>Description:</strong><br><%= food.getDescription() %></p>
                                <% } %>
                            </div>
                            <div class="col-md-6">
                                <h6>Pickup Information</h6>
                                <p><strong>Address:</strong> <%= food.getPickupAddress() != null ? food.getPickupAddress() : "Not specified" %></p>
                                <p><strong>City:</strong> <%= food.getPickupCity() %>, <%= food.getPickupState() %></p>
                                <% if (food.getPickupZipCode() != null) { %>
                                <p><strong>ZIP Code:</strong> <%= food.getPickupZipCode() %></p>
                                <% } %>
                                <% if (food.getPickupInstructions() != null && !food.getPickupInstructions().isEmpty()) { %>
                                <p><strong>Instructions:</strong><br><%= food.getPickupInstructions() %></p>
                                <% } %>
                            </div>
                        </div>
                        
                        <hr>
                        
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Storage & Expiry</h6>
                                <p><strong>Expiry Date:</strong> <%= food.getExpiryDate() != null ? food.getExpiryDate() : "Not specified" %></p>
                                <% if (food.getStorageCondition() != null && !food.getStorageCondition().isEmpty()) { %>
                                <p><strong>Storage Conditions:</strong> <%= food.getStorageCondition() %></p>
                                <% } %>
                            </div>
                            <div class="col-md-6">
                                <h6>Timestamps</h6>
                                <p><strong>Created:</strong> <%= food.getCreatedAt() != null ? food.getCreatedAt() : "Not available" %></p>
                                <p><strong>Last Updated:</strong> <%= food.getUpdatedAt() != null ? food.getUpdatedAt() : "Not available" %></p>
                            </div>
                        </div>
                    </div>
                    <div class="card-footer">
                        <a href="donorDashboard.jsp" class="btn btn-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
                        </a>
                        <a href="editFoodListing.jsp?id=<%= food.getId() %>" class="btn btn-success">
                            <i class="fas fa-edit me-2"></i>Edit Listing
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>