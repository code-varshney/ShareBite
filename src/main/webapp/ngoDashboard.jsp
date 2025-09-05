<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.bean.NGODetailsBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.NGODetailsDAO" %>
<%@ page import="java.util.*" %>

<%
// Check if user is logged in and is an NGO
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");
String organizationName = (String) session.getAttribute("organizationName");

if (userType == null || !"ngo".equals(userType) || userId == null) {
    response.sendRedirect("ngoLogin.jsp?error=not_authorized");
    return;
}

// Get NGO ID
int ngoId = Integer.parseInt(userId);

// Get available food listings
List<FoodListingBean> availableFood = FoodListingDAO.getAllFoodListings();

// Get NGO's food requests
List<FoodRequestBean> ngoRequests = FoodRequestDAO.getFoodRequestsByNgo(ngoId);

// Fetch NGO details bean
NGODetailsBean ngoDetails = NGODetailsDAO.getNGODetailsByUserId(ngoId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>NGO Dashboard - Sharebite</title>
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
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .sidebar {
            background: white;
            min-height: calc(100vh - 76px);
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
            padding: 0;
        }
        
        .sidebar .nav-link {
            color: #6c757d;
            padding: 1rem 1.5rem;
            border-radius: 0;
            transition: all 0.3s ease;
        }
        
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            color: white;
        }
        
        .sidebar .nav-link i {
            width: 20px;
            margin-right: 10px;
        }
        
        .main-content {
            padding: 2rem;
            background: white;
            border-radius: 15px;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            margin: 1rem;
        }
        
        .welcome-section {
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            color: white;
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
        }
        
        .stats-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 2px 20px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .stats-card:hover {
            transform: translateY(-5px);
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            color: #007bff;
            margin-bottom: 0.5rem;
        }
        
        .food-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            border-left: 4px solid #007bff;
            transition: transform 0.3s ease;
        }
        
        .food-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 25px rgba(0,0,0,0.15);
        }
        
        .request-card {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            border-left: 4px solid #28a745;
        }
        
        .btn-request {
            background: linear-gradient(45deg, #007bff, #6610f2);
            border: none;
            border-radius: 25px;
            padding: 0.5rem 1.5rem;
            color: white;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-request:hover {
            background: linear-gradient(45deg, #0056b3, #520dc2);
            transform: translateY(-2px);
            color: white;
        }
        
        .status-badge {
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.8rem;
            font-weight: 500;
        }
        
        .status-pending { background: #fff3cd; color: #856404; }
        .status-approved { background: #d4edda; color: #155724; }
        .status-rejected { background: #f8d7da; color: #721c24; }
        .status-completed { background: #cce5ff; color: #004085; }
    </style>
</head>
<body>
    <!-- Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-users me-2"></i>Sharebite NGO Portal
            </a>
            <div class="navbar-nav ms-auto">
                <span class="navbar-text me-3">
                    <i class="fas fa-user me-2"></i><%= organizationName != null ? organizationName : userName %>
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
            <div class="col-md-3 col-lg-2">
                <div class="sidebar">
                    <nav class="nav flex-column">
                        <a class="nav-link active" href="#dashboard" onclick="showSection('dashboard')">
                            <i class="fas fa-tachometer-alt"></i>Dashboard
                        </a>
                        <a class="nav-link" href="#browse-food" onclick="showSection('browse-food')">
                            <i class="fas fa-search"></i>Browse Food
                        </a>
                        <a class="nav-link" href="#my-requests" onclick="showSection('my-requests')">
                            <i class="fas fa-list"></i>My Requests
                        </a>
                        <a class="nav-link" href="#profile" onclick="showSection('profile')">
                            <i class="fas fa-user-cog"></i>Profile
                        </a>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <!-- Dashboard Section -->
                <div id="dashboard" class="main-content">
                    <div class="welcome-section">
                        <h2><i class="fas fa-users me-3"></i>Welcome, <%= organizationName != null ? organizationName : userName %></h2>
                        <p class="mb-0">Manage your food requests and help reduce food waste in your community</p>
                    </div>

                    <!-- Statistics -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="stats-card">
                                <div class="stats-number"><%= availableFood != null ? availableFood.size() : 0 %></div>
                                <div>Available Food Items</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card">
                                <div class="stats-number"><%= ngoRequests != null ? ngoRequests.size() : 0 %></div>
                                <div>Total Requests</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card">
                                <div class="stats-number">
                                    <%= ngoRequests != null ? ngoRequests.stream().filter(r -> "approved".equals(r.getStatus())).count() : 0 %>
                                </div>
                                <div>Approved Requests</div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card">
                                <div class="stats-number">
                                    <%= ngoRequests != null ? ngoRequests.stream().filter(r -> "completed".equals(r.getStatus())).count() : 0 %>
                                </div>
                                <div>Completed Pickups</div>
                            </div>
                        </div>
                    </div>

                    <!-- Recent Available Food -->
                    <h4 class="mb-4">
                        <i class="fas fa-utensils me-2"></i>Recent Available Food
                    </h4>
                    <% if (availableFood != null && !availableFood.isEmpty()) { %>
                        <% for (int i = 0; i < Math.min(3, availableFood.size()); i++) { 
                            FoodListingBean food = availableFood.get(i);
                        %>
                            <div class="food-card">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h5><%= food.getFoodName() %></h5>
                                        <p class="text-muted mb-2"><%= food.getDescription() %></p>
                                        <div class="row">
                                            <div class="col-md-4">
                                                <small class="text-muted">
                                                    <i class="fas fa-map-marker-alt me-1"></i><%= food.getPickupCity() %>, <%= food.getPickupState() %>
                                                </small>
                                            </div>
                                            <div class="col-md-4">
                                                <small class="text-muted">
                                                    <i class="fas fa-calendar me-1"></i>Expires: <%= food.getExpiryDate() %>
                                                </small>
                                            </div>
                                            <div class="col-md-4">
                                                <small class="text-muted">
                                                    <i class="fas fa-weight me-1"></i><%= food.getQuantity() %> <%= food.getQuantityUnit() %>
                                                </small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <span class="badge bg-success me-2">Available</span>
                                        <button class="btn btn-request" onclick="requestFood('<%= food.getId() %>')">
                                            <i class="fas fa-hand-holding-heart me-2"></i>Request
                                        </button>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                        <div class="text-center mt-3">
                            <a href="#browse-food" class="btn btn-outline-primary" onclick="showSection('browse-food')">
                                <i class="fas fa-eye me-2"></i>View All Available Food
                            </a>
                        </div>
                    <% } else { %>
                        <div class="text-center py-4">
                            <i class="fas fa-utensils fa-3x text-muted mb-3"></i>
                            <p class="text-muted">No food items available at the moment.</p>
                        </div>
                    <% } %>
                </div>

                <!-- Browse Food Section -->
                <div id="browse-food" class="main-content" style="display: none;">
                    <h3 class="mb-4">
                        <i class="fas fa-search me-2"></i>Browse Available Food
                    </h3>
                    
                    <!-- Search Filters -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <input type="text" class="form-control" id="searchKeyword" placeholder="Search food...">
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="foodTypeFilter">
                                <option value="">All Food Types</option>
                                <option value="fresh">Fresh</option>
                                <option value="canned">Canned</option>
                                <option value="baked">Baked</option>
                                <option value="dairy">Dairy</option>
                                <option value="frozen">Frozen</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" id="cityFilter">
                                <option value="">All Cities</option>
                                <option value="New York">New York</option>
                                <option value="Los Angeles">Los Angeles</option>
                                <option value="Chicago">Chicago</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <button class="btn btn-primary w-100" onclick="applyFilters()">
                                <i class="fas fa-filter me-2"></i>Apply Filters
                            </button>
                        </div>
                    </div>

                    <!-- Food Listings -->
                    <div id="foodListings">
                        <% if (availableFood != null && !availableFood.isEmpty()) { %>
                            <% for (FoodListingBean food : availableFood) { %>
                                <div class="food-card">
                                    <div class="row align-items-center">
                                        <div class="col-md-8">
                                            <h5><%= food.getFoodName() %></h5>
                                            <p class="text-muted mb-2"><%= food.getDescription() %></p>
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <small class="text-muted">
                                                        <i class="fas fa-map-marker-alt me-1"></i><%= food.getPickupCity() %>, <%= food.getPickupState() %>
                                                    </small>
                                                </div>
                                                <div class="col-md-4">
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar me-1"></i>Expires: <%= food.getExpiryDate() %>
                                                    </small>
                                                </div>
                                                <div class="col-md-4">
                                                    <small class="text-muted">
                                                        <i class="fas fa-weight me-1"></i><%= food.getQuantity() %> <%= food.getQuantityUnit() %>
                                                    </small>
                                                </div>
                                            </div>
                                            <div class="mt-2">
                                                <span class="badge bg-info me-2"><%= food.getFoodType() %></span>
                                                <span class="badge bg-success">Available</span>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <button class="btn btn-request" onclick="requestFood('<%= food.getId() %>')">
                                                <i class="fas fa-hand-holding-heart me-2"></i>Request Food
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            <% } %>
                        <% } else { %>
                            <div class="text-center py-4">
                                <i class="fas fa-utensils fa-3x text-muted mb-3"></i>
                                <p class="text-muted">No food items available at the moment.</p>
                            </div>
                        <% } %>
                    </div>
                </div>

                <!-- My Requests Section -->
                <div id="my-requests" class="main-content" style="display: none;">
                    <h3 class="mb-4">
                        <i class="fas fa-list me-2"></i>My Food Requests
                    </h3>
                    
                    <% if (ngoRequests != null && !ngoRequests.isEmpty()) { %>
                        <% for (FoodRequestBean request1 : ngoRequests) { %>
                            <div class="request-card">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h5>Request #<%= request1.getId() %></h5>
                                        <p class="text-muted mb-2">
                                            <strong>Pickup Date:</strong> <%= request1.getPickupDate() %> at <%= request1.getPickupTime() %>
                                        </p>
                                        <% if (request1.getRequestMessage() != null && !request1.getRequestMessage().isEmpty()) { %>
                                            <p class="mb-2"><%= request1.getRequestMessage() %></p>
                                        <% } %>
                                        <div class="mt-2">
                                            <span class="status-badge status-<%= request1.getStatus() %>">
                                                <%= request1.getStatus().substring(0, 1).toUpperCase() + request1.getStatus().substring(1) %>
                                            </span>
                                        </div>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <% if ("pending".equals(request1.getStatus())) { %>
                                            <button class="btn btn-warning btn-sm me-2">
                                                <i class="fas fa-clock me-1"></i>Pending
                                            </button>
                                        <% } else if ("approved".equals(request1.getStatus())) { %>
                                            <button class="btn btn-success btn-sm me-2">
                                                <i class="fas fa-check me-1"></i>Approved
                                            </button>
                                        <% } else if ("rejected".equals(request1.getStatus())) { %>
                                            <button class="btn btn-danger btn-sm me-2">
                                                <i class="fas fa-times me-1"></i>Rejected
                                            </button>
                                        <% } %>
                                        
                                        <% if (request1.getDonorResponse() != null && !request1.getDonorResponse().isEmpty()) { %>
                                            <button class="btn btn-info btn-sm" onclick="showResponse('<%= request1.getDonorResponse() %>')">
                                                <i class="fas fa-comment me-1"></i>View Response
                                            </button>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="text-center py-4">
                            <i class="fas fa-list fa-3x text-muted mb-3"></i>
                            <p class="text-muted">You haven't made any food requests yet.</p>
                            <a href="#browse-food" class="btn btn-primary" onclick="showSection('browse-food')">
                                <i class="fas fa-search me-2"></i>Browse Available Food
                            </a>
                        </div>
                    <% } %>
                </div>

                <!-- Profile Section -->
                <div id="profile" class="main-content" style="display: none;">
                    <h3 class="mb-4">
                        <i class="fas fa-user-cog me-2"></i>Organization Profile
                    </h3>
                    
                    <div class="row">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Organization Information</h5>
                                    <p><strong>Name:</strong> <%= organizationName != null ? organizationName : "N/A" %></p>
                                    <% if (ngoDetails != null) { %>
    <p><strong>Registration Number:</strong> <%= ngoDetails.getRegistrationNumber() != null ? ngoDetails.getRegistrationNumber() : "N/A" %></p>
    <p><strong>Mission:</strong> <%= ngoDetails.getMission() != null ? ngoDetails.getMission() : "N/A" %></p>
    <p><strong>Contact Person:</strong> <%= ngoDetails.getContactPerson() != null ? ngoDetails.getContactPerson() : "N/A" %></p>
    <p><strong>Contact Title:</strong> <%= ngoDetails.getContactTitle() != null ? ngoDetails.getContactTitle() : "N/A" %></p>
    <p><strong>Website:</strong> <%= ngoDetails.getWebsite() != null ? ngoDetails.getWebsite() : "N/A" %></p>
    <p><strong>Service Area:</strong> <%= ngoDetails.getServiceArea() != null ? ngoDetails.getServiceArea() : "N/A" %></p>
<% } else { %>
    <p>No NGO details found.</p>
<% } %>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h5 class="card-title">Account Status</h5>
                                    <p><strong>Username:</strong> <%= session.getAttribute("username") %></p>
                                    <p><strong>User Type:</strong> <%= session.getAttribute("userType") %></p>
                                    <p><strong>Verification Status:</strong> 
                                        <span class="badge bg-success">Verified</span>
                                    </p>
                                    <p><strong>Member Since:</strong> <%= session.getAttribute("createdAt") != null ? session.getAttribute("createdAt") : "N/A" %></p>
                                    
                                    <button class="btn btn-primary mt-3">
                                        <i class="fas fa-edit me-2"></i>Edit Profile
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
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
                    <form id="requestForm">
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function showSection(sectionName) {
            // Hide all sections
            document.querySelectorAll('.main-content').forEach(section => {
                section.style.display = 'none';
            });
            
            // Show selected section
            document.getElementById(sectionName).style.display = 'block';
            
            // Update active nav link
            document.querySelectorAll('.nav-link').forEach(link => {
                link.classList.remove('active');
            });
            event.target.classList.add('active');
        }
        
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
            const formData = new FormData(form);
            
            // Here you would typically submit the form via AJAX
            // For now, we'll just close the modal
            const modal = bootstrap.Modal.getInstance(document.getElementById('requestModal'));
            modal.hide();
            
            // Show success message
            alert('Food request submitted successfully!');
            
            // Refresh the page to show updated requests
            location.reload();
        }
        
        function showResponse(response) {
            alert('Donor Response: ' + response);
        }
        
        function applyFilters() {
            const keyword = document.getElementById('searchKeyword').value;
            const foodType = document.getElementById('foodTypeFilter').value;
            const city = document.getElementById('cityFilter').value;
            
            // Here you would typically filter the food listings
            // For now, we'll just show a message
            alert('Filters applied: ' + keyword + ', ' + foodType + ', ' + city);
        }
        
        // Set today's date as minimum for pickup date
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('pickupDate').min = today;
        });
    </script>
</body>
</html>
