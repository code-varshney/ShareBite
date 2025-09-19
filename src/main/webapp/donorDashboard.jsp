<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="java.util.*" %>
<%
// Check if user is logged in and is a donor
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");

if (userType == null || !"donor".equals(userType) || userId == null) {
    response.sendRedirect("donorLogin.jsp?error=not_authorized");
    return;
}

int donorId = Integer.parseInt(userId);

// Fetch donor data
List<FoodListingBean> myListings = FoodListingDAO.getFoodListingsByDonor(donorId);
List<FoodRequestBean> myRequests = FoodRequestDAO.getFoodRequestsForDonor(donorId);

int activeListings = myListings != null ? myListings.size() : 0;
int totalRequests = myRequests != null ? myRequests.size() : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Donor Dashboard - Sharebite</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f8f9fa;
        }
        
        .navbar {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .sidebar {
            background: #ffffff;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            min-height: calc(100vh - 76px);
        }
        
        .sidebar .nav-link {
            color: #6c757d;
            padding: 1rem 1.5rem;
            border-left: 3px solid transparent;
            transition: all 0.3s ease;
        }
        
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: #f8f9fa;
            color: #28a745;
            border-left-color: #28a745;
        }
        
        .main-content {
            padding: 2rem;
            background: #ffffff;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            margin: 1rem;
        }
        
        .stats-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 20px rgba(40, 167, 69, 0.3);
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .food-card {
            background: #ffffff;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            border: 1px solid #e9ecef;
            transition: transform 0.3s ease;
        }
        
        .food-card:hover {
            transform: translateY(-5px);
        }
        
        .welcome-section {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            text-align: center;
        }
    </style>
</head>
<body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-heart me-2"></i>Sharebite
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    <i class="fas fa-user me-2"></i>Welcome, <%= userName != null ? userName : "Donor" %>
                </span>
                <a class="nav-link" href="logout.jsp">
                    <i class="fas fa-sign-out-alt me-2"></i>Logout
                </a>
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 sidebar">
                <div class="d-flex flex-column flex-shrink-0 p-3">
                    <ul class="nav nav-pills flex-column mb-auto">
                        <li class="nav-item">
                            <a href="#dashboard" class="nav-link active">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="#my-listings" class="nav-link">
                                <i class="fas fa-utensils me-2"></i>My Food Listings
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="#requests" class="nav-link">
                                <i class="fas fa-handshake me-2"></i>NGO Requests
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="#add-food" class="nav-link">
                                <i class="fas fa-plus-circle me-2"></i>Add Food Listing
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="#profile" class="nav-link">
                                <i class="fas fa-user-cog me-2"></i>Profile
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <!-- Dashboard Section -->
                <div id="dashboard">
                    <div class="welcome-section">
                        <h2>Welcome to Your Donor Dashboard</h2>
                        <p>Manage your food donations and help reduce food waste</p>
                        <div class="mt-3">
                            <a href="#add-food" class="btn btn-light me-2">
                                <i class="fas fa-plus me-2"></i>Add New Food
                            </a>
                            <a href="#my-listings" class="btn btn-outline-light">
                                <i class="fas fa-eye me-2"></i>View Listings
                            </a>
                        </div>
                    </div>

                    <!-- Statistics -->
                    <div class="row">
                        <div class="col-md-3">
                            <div class="stats-card">
                                <div class="stats-number"><%= activeListings %></div>
                                <div>Active Listings</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card">
                                <div class="stats-number"><%= totalRequests %></div>
                                <div>Pending Requests</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card">
                                <div class="stats-number">45</div>
                                <div>Total Donations</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card">
                                <div class="stats-number">150+</div>
                                <div>Lives Impacted</div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Activity -->
                    <div class="main-content">
                        <h4 class="mb-4">
                            <i class="fas fa-clock me-2"></i>Recent Activity
                        </h4>
                        <% if (myListings != null && !myListings.isEmpty()) { %>
                            <% for (int i = 0; i < Math.min(3, myListings.size()); i++) { 
                                FoodListingBean food = myListings.get(i);
                            %>
                                <div class="food-card">
                                    <div class="row align-items-center">
                                        <div class="col-md-8">
                                            <h5><%= food.getFoodName() %></h5>
                                            <p class="text-muted">
                                                <i class="fas fa-map-marker-alt me-2"></i><%= food.getPickupCity() %>, <%= food.getPickupState() %>
                                            </p>
                                            <span class="badge bg-success me-2"><%= food.getStatus() %></span>
                                            <small class="text-muted">
                                                <i class="fas fa-calendar me-1"></i>Expires: <%= food.getExpiryDate() %>
                                            </small>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <div class="mb-2"><strong>Quantity:</strong> <%= food.getQuantity() %> <%= food.getQuantityUnit() %></div>
                                            <a class="btn btn-outline-primary btn-sm" href="viewFoodListing.jsp?id=<%= food.getId() %>">
                                                <i class="fas fa-eye me-1"></i>View Details
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        <% } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-utensils fa-3x text-muted mb-3"></i>
                                <p class="text-muted">No food listings yet. Create your first one.</p>
                                <a href="addFoodListing.jsp" class="btn btn-success">
                                    <i class="fas fa-plus me-2"></i>Add Food Listing
                                </a>
                            </div>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
