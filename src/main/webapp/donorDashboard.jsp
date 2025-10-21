<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="com.net.DAO.NotificationDAO" %>
<%@ page import="com.net.bean.NotificationBean" %>
<%@ page import="java.util.*" %>
<%
// Check if user is logged in and is a donor
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");
String userName = (String) session.getAttribute("userName");
String userEmail = (String) session.getAttribute("email");

if (userType == null || !"donor".equals(userType) || userId == null) {
    response.sendRedirect("donorLogin.jsp?error=not_authorized");
    return;
}

int donorId = Integer.parseInt(userId);

// Fetch donor data
List<FoodListingBean> myListings = FoodListingDAO.getFoodListingsByDonor(donorId);
List<FoodRequestBean> myRequests = FoodRequestDAO.getFoodRequestsForDonor(donorId);
UserBean donorProfile = UserDAO.getUserById(donorId);

// Get notifications for this donor (stored with donor ID as ngo_id)
List<NotificationBean> notifications = NotificationDAO.getNotificationsByNGO(donorId);
int unreadCount = NotificationDAO.getUnreadCount(donorId);

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
    <link rel="stylesheet" href="css/welcomePopup.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(-45deg, #e8f5e8, #f0f8f0, #e6f7e6, #f5fbf5);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
        }
        
        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        
        .navbar {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            box-shadow: 0 4px 20px rgba(40, 167, 69, 0.3);
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.2);
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        
        .sidebar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            box-shadow: 4px 0 30px rgba(0, 0, 0, 0.1);
            min-height: calc(100vh - 76px);
            border-radius: 0 20px 20px 0;
            border-right: 1px solid rgba(40, 167, 69, 0.1);
        }
        
        .sidebar .nav-link {
            color: #6c757d;
            padding: 1.2rem 1.5rem;
            border-radius: 15px;
            margin: 0.3rem 1rem;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
        }
        
        .sidebar .nav-link::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(40, 167, 69, 0.1), transparent);
            transition: left 0.5s;
        }
        
        .sidebar .nav-link:hover::before {
            left: 100%;
        }
        
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            transform: translateX(5px) scale(1.02);
            box-shadow: 0 8px 25px rgba(40, 167, 69, 0.3);
        }
        
        .main-content {
            padding: 2.5rem;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 25px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            margin: 1.5rem;
            border: 1px solid rgba(255, 255, 255, 0.2);
            animation: slideUp 0.6s ease-out;
        }
        
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .stats-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 10px 30px rgba(40, 167, 69, 0.3);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
        }
        
        .stats-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%);
            transform: translateX(-100%);
            animation: shimmer 3s infinite;
        }
        
        .stats-card:hover {
            transform: translateY(-10px) scale(1.05);
            box-shadow: 0 20px 50px rgba(40, 167, 69, 0.4);
        }
        
        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        
        .stats-number {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .food-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(40, 167, 69, 0.1);
            border-left: 4px solid #28a745;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
        }
        
        .food-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent, rgba(40, 167, 69, 0.05), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .food-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 50px rgba(40, 167, 69, 0.2);
            border-left-color: #20c997;
        }
        
        .food-card:hover::before {
            opacity: 1;
        }
        
        .welcome-section {
            background: linear-gradient(135deg, #28a745 0%, #20c997 50%, #17a2b8 100%);
            color: white;
            border-radius: 25px;
            padding: 3rem;
            margin-bottom: 2rem;
            text-align: center;
            position: relative;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(40, 167, 69, 0.3);
        }
        
        .welcome-section h2 {
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 1rem;
            text-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        
        .welcome-section p {
            font-size: 1.2rem;
            opacity: 0.9;
            margin-bottom: 2rem;
        }
        
        .welcome-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%);
            transform: translateX(-100%);
            animation: shimmer 3s infinite;
        }
        
        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }
        
        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #28a745;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .pulse-animation {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .notification-toast {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 300px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
            border-radius: 10px;
            overflow: hidden;
        }
        
        .interactive-card {
            cursor: pointer;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        
        .interactive-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }
        
        .section-transition {
            transition: all 0.4s ease-in-out;
        }
        
        /* Dark Theme Support */
        [data-theme="dark"] {
            background-color: #1a1a1a;
            color: #e0e0e0;
        }
        
        [data-theme="dark"] .sidebar {
            background: #2d2d2d;
            color: #e0e0e0;
        }
        
        [data-theme="dark"] .main-content {
            background: #2d2d2d;
            color: #e0e0e0;
        }
        
        [data-theme="dark"] .food-card {
            background: #2d2d2d;
            border-color: #404040;
            color: #e0e0e0;
        }
        

        [data-theme="dark"] .form-control {
            background: #3d3d3d;
            border-color: #404040;
            color: #e0e0e0;
        }
        
        [data-theme="dark"] .form-control:focus {
            background: #3d3d3d;
            border-color: #28a745;
            color: #e0e0e0;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
        
        [data-theme="dark"] .btn-outline-light {
            color: #e0e0e0;
            border-color: #e0e0e0;
        }
        
        [data-theme="dark"] .btn-outline-light:hover {
            background: #e0e0e0;
            color: #1a1a1a;
        }
        
        /* Enhanced Search Styling */
        .search-container {
            position: relative;
        }
        
        .search-container input {
            border-radius: 20px;
            padding-left: 35px;
        }
        
        .search-container::before {
            content: '\f002';
            font-family: 'Font Awesome 5 Free';
            font-weight: 900;
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            z-index: 10;
        }
        
        /* Loading States */
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
        }
        
        /* Responsive Enhancements */
        /* Enhanced Modal and Form Styling */
        .modal-content {
            border-radius: 25px;
            border: none;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(20px);
            background: rgba(255, 255, 255, 0.95);
            overflow: hidden;
        }
        
        .modal-header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border-radius: 25px 25px 0 0;
            padding: 1.5rem 2rem;
            border: none;
            position: relative;
        }
        
        .modal-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(45deg, transparent 30%, rgba(255,255,255,0.1) 50%, transparent 70%);
            transform: translateX(-100%);
            animation: shimmer 3s infinite;
        }
        
        .modal-body {
            padding: 2rem;
            background: rgba(255, 255, 255, 0.9);
        }
        
        .modal-footer {
            padding: 1.5rem 2rem;
            border: none;
            background: rgba(248, 249, 250, 0.9);
        }
        
        @media (max-width: 768px) {
            .search-container input {
                width: 150px !important;
            }
            
            .navbar-nav .navbar-text {
                display: none;
            }
            
            .stats-card {
                margin-bottom: 1rem;
            }
            
            .welcome-section h2 {
                font-size: 2rem;
            }
            
            .main-content {
                padding: 1.5rem;
                margin: 1rem;
            }
        }
        
        /* Animation for section transitions */
        .section-enter {
            opacity: 0;
            transform: translateX(50px);
        }
        
        .section-enter-active {
            opacity: 1;
            transform: translateX(0);
            transition: all 0.3s ease-out;
        }
        
        .section-exit {
            opacity: 1;
            transform: translateX(0);
        }
        
        .section-exit-active {
            opacity: 0;
            transform: translateX(-50px);
            transition: all 0.3s ease-in;
        }

        /* Enhanced Food Card Styling */
        .food-card {
            border-left: 4px solid #28a745;
            transition: all 0.3s ease;
        }

        .food-card:hover {
            border-left-color: #20c997;
            box-shadow: 0 6px 25px rgba(0,0,0,0.1);
        }

        .text-sm {
            font-size: 0.875rem;
        }

        .btn-group-vertical .btn {
            margin-bottom: 0.25rem;
        }

        .btn-group-vertical .btn:last-child {
            margin-bottom: 0;
        }

        /* Status Badge Styling */
        .badge.bg-success {
            background: linear-gradient(135deg, #28a745, #20c997) !important;
        }

        .badge.bg-warning {
            background: linear-gradient(135deg, #ffc107, #fd7e14) !important;
            color: #000;
        }

        .badge.bg-secondary {
            background: linear-gradient(135deg, #6c757d, #495057) !important;
        }

        /* Form Enhancements */
        .form-label .text-danger {
            font-weight: bold;
        }

        .form-control:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }

        .form-select:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }

        /* Filter Section Styling */
        .filter-section {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }

        /* Modal Enhancements */
        .modal-content {
            border-radius: 15px;
            border: none;
            box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        }

        .modal-header {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border-radius: 15px 15px 0 0;
        }

        .modal-header .btn-close {
            filter: invert(1);
        }

        /* Food Listings Dashboard Specific Styles */
        .listing-row {
            transition: all 0.3s ease;
        }

        .listing-row:hover {
            background-color: #f8f9fa !important;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }

        .food-icon {
            background: linear-gradient(135deg, #28a745, #20c997);
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .ngo-requests {
            max-height: 120px;
            overflow-y: auto;
        }

        .table th {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
            font-weight: 600;
            border-bottom: 2px solid #28a745;
        }

        .badge.fs-6 {
            font-size: 0.875rem !important;
            padding: 0.5em 0.75em;
        }

        /* Enhanced filter section */
        .filter-section {
            border: 1px solid #e9ecef;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .filter-section h6 {
            color: #28a745;
            font-weight: 600;
        }
    </style>
</head>
<body data-total-requests="<%= totalRequests %>" data-donor-id="<%= donorId %>">
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">
                <i class="fas fa-heart me-2"></i>Sharebite
            </a>
            <div class="navbar-nav ms-auto d-flex align-items-center">
                <div class="search-container me-3">
                    <input type="text" id="search-input" class="form-control form-control-sm" placeholder="Search listings..." style="width: 200px;">
                </div>
                <a class="nav-link position-relative me-3" href="#" data-bs-toggle="modal" data-bs-target="#notificationsModal">
                    <i class="fas fa-bell"></i>
                    <% if (unreadCount > 0) { %>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                            <%= unreadCount %>
                        </span>
                    <% } %>
                </a>
                <button class="btn btn-outline-light btn-sm me-3" onclick="dashboard.toggleTheme()" title="Toggle Theme">
                    <i class="fas fa-moon"></i>
                </button>
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
                            <a href="#dashboard" class="nav-link">
                                <i class="fas fa-tachometer-alt me-2"></i>Overview
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="#my-listings" class="nav-link active">
                                <i class="fas fa-utensils me-2"></i>Food Listings Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="#requests" class="nav-link">
                                <i class="fas fa-handshake me-2"></i>NGO Requests
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="addFoodListing.jsp" class="nav-link">
                                <i class="fas fa-plus-circle me-2"></i>Add Food Listing
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="#" class="nav-link" data-bs-toggle="modal" data-bs-target="#profileModal">
                                <i class="fas fa-user-cog me-2"></i>Profile
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <!-- Dashboard Section -->
                <div id="section-dashboard">
                    <div class="welcome-section">
                        <h2>Food Listings Management</h2>
                        <p>Efficiently manage all your food donations and track their impact on reducing food waste</p>
                        <div class="mt-3">
                            <a href="addFoodListing.jsp" class="btn btn-light me-2">
                                <i class="fas fa-plus me-2"></i>Add New Listing
                            </a>
                            <a href="#my-listings" class="btn btn-outline-light">
                                <i class="fas fa-list me-2"></i>Manage All Listings
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
                                <div class="food-card interactive-card" data-food-id="<%= food.getId() %>">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="d-flex justify-content-between align-items-start mb-2">
                                                <h5 class="mb-0"><%= food.getFoodName() %></h5>
                                                <span class="badge <%= food.getStatus().equals("Available") ? "bg-success" : food.getStatus().equals("Reserved") ? "bg-warning" : "bg-secondary" %>">
                                                    <%= food.getStatus() %>
                                                </span>
                                            </div>
                                            
                                            <% if (food.getDescription() != null && !food.getDescription().isEmpty()) { %>
                                                <p class="text-muted mb-2"><%= food.getDescription().length() > 80 ? food.getDescription().substring(0, 80) + "..." : food.getDescription() %></p>
                                            <% } %>
                                            
                                            <div class="row text-sm mb-2">
                                                <div class="col-md-6">
                                                    <small class="text-muted">
                                                        <i class="fas fa-tag me-1"></i><%= food.getFoodType() != null ? food.getFoodType() : "General" %>
                                                    </small>
                                                </div>
                                                <div class="col-md-6">
                                                    <small class="text-muted">
                                                        <i class="fas fa-weight me-1"></i><%= food.getQuantity() %> <%= food.getQuantityUnit() %>
                                                    </small>
                                                </div>
                                            </div>
                                            
                                            <div class="row text-sm">
                                                <div class="col-md-6">
                                                    <small class="text-muted">
                                                        <i class="fas fa-map-marker-alt me-1"></i><%= food.getPickupCity() %>, <%= food.getPickupState() %>
                                                    </small>
                                                </div>
                                                <div class="col-md-6">
                                                    <small class="text-muted">
                                                        <i class="fas fa-calendar me-1"></i>Expires: <%= food.getExpiryDate() %>
                                                    </small>
                                                </div>
                                            </div>
                                            
                                            <div class="mt-2">
                                                <small class="text-muted">
                                                    <i class="fas fa-clock me-1"></i>Created: <%= food.getCreatedAt() %>
                                                </small>
                                            </div>
                                        </div>
                                        
                                        <div class="col-md-4 text-end">
                                            <div class="d-flex flex-column gap-2">
                                                <div class="btn-group-vertical w-100">
                                                    <a class="btn btn-outline-primary btn-sm" href="viewFoodListing.jsp?id=<%= food.getId() %>" onclick="event.stopPropagation()">
                                                        <i class="fas fa-eye me-1"></i>View Details
                                                    </a>
                                                    <button class="btn btn-outline-success btn-sm edit-food-btn" data-food-id="<%= food.getId() %>">
                                                        <i class="fas fa-edit me-1"></i>Edit
                                                    </button>
                                                    <button class="btn btn-outline-info btn-sm status-btn" data-food-id="<%= food.getId() %>" data-current-status="<%= food.getStatus() %>">
                                                        <i class="fas fa-exchange-alt me-1"></i>Update Status
                                                    </button>
                                                </div>
                                            </div>
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

                <!-- Food Listings Dashboard Section -->
                <div id="section-my-listings" style="display: none;">
                    <div class="main-content mt-4">
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h4><i class="fas fa-utensils me-2"></i>Food Listings Dashboard</h4>
                            <a href="addFoodListing.jsp" class="btn btn-success">
                                <i class="fas fa-plus me-2"></i>Add New Listing
                            </a>
                        </div>

                        <!-- Statistics Cards -->
                        <div class="row mb-4">
                            <div class="col-md-3">
                                <div class="stats-card text-center">
                                    <div class="stats-number"><%= myListings.stream().mapToInt(f -> "Available".equals(f.getStatus()) ? 1 : 0).sum() %></div>
                                    <div>Active Listings</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stats-card text-center">
                                    <div class="stats-number"><%= myListings.stream().mapToInt(f -> "Inactive".equals(f.getStatus()) ? 1 : 0).sum() %></div>
                                    <div>Inactive Listings</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stats-card text-center">
                                    <div class="stats-number"><%= myListings.stream().mapToInt(f -> "Expired".equals(f.getStatus()) ? 1 : 0).sum() %></div>
                                    <div>Expired Listings</div>
                                </div>
                            </div>
                            <div class="col-md-3">
                                <div class="stats-card text-center">
                                    <div class="stats-number"><%= totalRequests %></div>
                                    <div>Total Requests</div>
                                </div>
                            </div>
                        </div>

                        <!-- Filters Section -->
                        <div class="filter-section">
                            <h6 class="mb-3"><i class="fas fa-filter me-2"></i>Filter and Search</h6>
                            <form method="get" class="row g-3">
                                <div class="col-md-2">
                                    <label class="form-label">Status</label>
                                    <select class="form-select" name="status" id="statusFilter">
                                        <option value="">All Status</option>
                                        <option value="Available" <%= "Available".equals(request.getParameter("status")) ? "selected" : "" %>>Available</option>
                                        <option value="Reserved" <%= "Reserved".equals(request.getParameter("status")) ? "selected" : "" %>>Reserved</option>
                                        <option value="Collected" <%= "Collected".equals(request.getParameter("status")) ? "selected" : "" %>>Collected</option>
                                        <option value="Expired" <%= "Expired".equals(request.getParameter("status")) ? "selected" : "" %>>Expired</option>
                                        <option value="Inactive" <%= "Inactive".equals(request.getParameter("status")) ? "selected" : "" %>>Inactive</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Expiry Date</label>
                                    <input type="date" class="form-control" name="expiryDate" id="expiryFilter" value="<%= request.getParameter("expiryDate") != null ? request.getParameter("expiryDate") : "" %>">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">City</label>
                                    <input type="text" class="form-control" name="city" id="cityFilter" value="<%= request.getParameter("city") != null ? request.getParameter("city") : "" %>" placeholder="Enter city">
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Food Type</label>
                                    <select class="form-select" name="foodType" id="foodTypeFilter">
                                        <option value="">All Types</option>
                                        <option value="Fruits">Fruits</option>
                                        <option value="Vegetables">Vegetables</option>
                                        <option value="Dairy">Dairy</option>
                                        <option value="Meat">Meat</option>
                                        <option value="Bakery">Bakery</option>
                                        <option value="Prepared">Prepared Food</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Sort By</label>
                                    <select class="form-select" name="sortBy" id="sortFilter">
                                        <option value="createdAt">Created Date</option>
                                        <option value="expiryDate">Expiry Date</option>
                                        <option value="foodName">Food Name</option>
                                        <option value="status">Status</option>
                                    </select>
                                </div>
                                <div class="col-md-2 d-flex align-items-end">
                                    <button type="submit" class="btn btn-outline-success w-100">
                                        <i class="fas fa-search me-1"></i>Apply
                                    </button>
                                </div>
                            </form>
                        </div>

                        <!-- Listings Table -->
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead class="table-light">
                                    <tr>
                                        <th>Food Details</th>
                                        <th>Quantity</th>
                                        <th>Pickup Info</th>
                                        <th>Expiry and Storage</th>
                                        <th>Status</th>
                                        <th>Timestamps</th>
                                        <th>NGO Requests</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <% 
                                if (myListings != null && !myListings.isEmpty()) {
                                    for (FoodListingBean food : myListings) {
                                        // Filter logic
                                        String filterStatus = request.getParameter("status");
                                        String filterExpiry = request.getParameter("expiryDate");
                                        String filterCity = request.getParameter("city");
                                        String filterFoodType = request.getParameter("foodType");
                                        boolean show = true;
                                        
                                        if (filterStatus != null && !filterStatus.isEmpty() && !filterStatus.equals(food.getStatus())) show = false;
                                        if (filterExpiry != null && !filterExpiry.isEmpty() && (food.getExpiryDate() == null || !food.getExpiryDate().toString().equals(filterExpiry))) show = false;
                                        if (filterCity != null && !filterCity.isEmpty() && (food.getPickupCity() == null || !food.getPickupCity().toLowerCase().contains(filterCity.toLowerCase()))) show = false;
                                        if (filterFoodType != null && !filterFoodType.isEmpty() && (food.getFoodType() == null || !food.getFoodType().equals(filterFoodType))) show = false;
                                        
                                        if (!show) continue;
                                        
                                        List<FoodRequestBean> requests = FoodRequestDAO.getRequestsByFoodId(food.getId());
                                %>
                                    <tr class="listing-row" data-food-id="<%= food.getId() %>">
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <div class="food-icon me-3">
                                                    <i class="fas fa-utensils fa-2x text-success"></i>
                                                </div>
                                                <div>
                                                    <h6 class="mb-1"><%= food.getFoodName() %></h6>
                                                    <small class="text-muted">
                                                        <i class="fas fa-tag me-1"></i><%= food.getFoodType() != null ? food.getFoodType() : "General" %>
                                                    </small>
                                                    <% if (food.getDescription() != null && !food.getDescription().isEmpty()) { %>
                                                        <br><small class="text-muted"><%= food.getDescription().length() > 50 ? food.getDescription().substring(0, 50) + "..." : food.getDescription() %></small>
                                                    <% } %>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <strong><%= food.getQuantity() %></strong><br>
                                            <small class="text-muted"><%= food.getQuantityUnit() %></small>
                                        </td>
                                        <td>
                                            <div class="text-sm">
                                                <i class="fas fa-map-marker-alt text-danger me-1"></i>
                                                <%= food.getPickupCity() %>, <%= food.getPickupState() %><br>
                                                <% if (food.getPickupInstructions() != null && !food.getPickupInstructions().isEmpty()) { %>
                                                    <small class="text-muted">
                                                        <i class="fas fa-info-circle me-1"></i>
                                                        <%= food.getPickupInstructions().length() > 30 ? food.getPickupInstructions().substring(0, 30) + "..." : food.getPickupInstructions() %>
                                                    </small>
                                                <% } %>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="text-sm">
                                                <i class="fas fa-calendar-alt text-warning me-1"></i>
                                                <strong><%= food.getExpiryDate() != null ? food.getExpiryDate() : "Not specified" %></strong><br>
                                                <% if (food.getStorageCondition() != null && !food.getStorageCondition().isEmpty()) { %>
                                                    <small class="text-muted">
                                                        <i class="fas fa-thermometer-half me-1"></i><%= food.getStorageCondition() %>
                                                    </small>
                                                <% } %>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge fs-6 <%= 
                                                food.getStatus().equals("Available") ? "bg-success" : 
                                                food.getStatus().equals("Reserved") ? "bg-warning text-dark" : 
                                                food.getStatus().equals("Collected") ? "bg-info" :
                                                food.getStatus().equals("Expired") ? "bg-danger" :
                                                food.getStatus().equals("Inactive") ? "bg-secondary" : "bg-dark" 
                                            %>">
                                                <%= food.getStatus() %>
                                            </span>
                                        </td>
                                        <td>
                                            <div class="text-sm">
                                                <strong>Created:</strong><br>
                                                <small class="text-muted"><%= food.getCreatedAt() != null ? food.getCreatedAt() : "-" %></small><br>
                                                <strong>Updated:</strong><br>
                                                <small class="text-muted"><%= food.getUpdatedAt() != null ? food.getUpdatedAt() : "-" %></small>
                                            </div>
                                        </td>
                                        <td>
                                            <% if (requests != null && !requests.isEmpty()) { %>
                                                <div class="ngo-requests">
                                                    <span class="badge bg-info mb-1"><%= requests.size() %> Request(s)</span>
                                                    <% for (int i = 0; i < Math.min(2, requests.size()); i++) { 
                                                        FoodRequestBean req = requests.get(i);
                                                    %>
                                                        <div class="text-sm mb-1">
                                                            <i class="fas fa-handshake text-info me-1"></i>
                                                            <strong><%= req.getNgoName() %></strong><br>
                                                            <small class="text-muted">Status: <%= req.getStatus() %></small>
                                                        </div>
                                                    <% } %>
                                                    <% if (requests.size() > 2) { %>
                                                        <small class="text-muted">+<%= requests.size() - 2 %> more...</small>
                                                    <% } %>
                                                </div>
                                            <% } else { %>
                                                <span class="text-muted">No requests</span>
                                            <% } %>
                                        </td>
                                        <td>
                                            <div class="btn-group-vertical" role="group">
                                                <a href="viewFoodListing.jsp?id=<%= food.getId() %>" 
                                                   class="btn btn-sm btn-outline-primary view-food-btn" 
                                                   data-food-id="<%= food.getId() %>" 
                                                   title="View Details">
                                                    <i class="fas fa-eye me-1"></i>View
                                                </a>
                                                <a href="editFoodListing.jsp?id=<%= food.getId() %>" 
                                                   class="btn btn-sm btn-outline-success edit-food-btn" 
                                                   data-food-id="<%= food.getId() %>" 
                                                   title="Edit Details">
                                                    <i class="fas fa-edit me-1"></i>Edit
                                                </a>
                                                <button class="btn btn-sm btn-outline-info status-update-btn" 
                                                        data-food-id="<%= food.getId() %>" 
                                                        data-current-status="<%= food.getStatus() %>" 
                                                        title="Update Status">
                                                    <i class="fas fa-exchange-alt me-1"></i>Status
                                                </button>
                                                <a href="deactivateFoodListing.jsp?id=<%= food.getId() %>" 
                                                   class="btn btn-sm btn-outline-warning" 
                                                   title="Deactivate Listing">
                                                    <i class="fas fa-ban me-1"></i>Deactivate
                                                </a>
                                                <a href="deleteFoodListing.jsp?id=<%= food.getId() %>" 
                                                   class="btn btn-sm btn-outline-danger" 
                                                   onclick="return confirm('Are you sure you want to delete this listing? This action cannot be undone.');"
                                                   title="Delete Listing">
                                                    <i class="fas fa-trash me-1"></i>Delete
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                <% 
                                    }
                                } else { 
                                %>
                                    <tr>
                                        <td colspan="8" class="text-center py-5">
                                            <i class="fas fa-utensils fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">No food listings found</h5>
                                            <p class="text-muted">Start by creating your first food listing to help reduce food waste.</p>
                                            <a href="addFoodListing.jsp" class="btn btn-success">
                                                <i class="fas fa-plus me-2"></i>Add Your First Listing
                                            </a>
                                        </td>
                                    </tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination (if needed) -->
                        <% if (myListings != null && myListings.size() > 10) { %>
                        <nav aria-label="Listings pagination">
                            <ul class="pagination justify-content-center">
                                <li class="page-item disabled">
                                    <a class="page-link" href="#" tabindex="-1">Previous</a>
                                </li>
                                <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                <li class="page-item"><a class="page-link" href="#">2</a></li>
                                <li class="page-item"><a class="page-link" href="#">3</a></li>
                                <li class="page-item">
                                    <a class="page-link" href="#">Next</a>
                                </li>
                            </ul>
                        </nav>
                        <% } %>
                    </div>
                </div>

                <!-- Server-side Rendered Food Listings Section (removed old location) -->
                <!-- Dynamic sections will be loaded here -->
                <div id="section-requests" style="display: none;"></div>
                <div id="section-add-food" style="display: none;"></div>
                <div id="section-profile" style="display: none;"></div>
            </div>
        </div>
    </div>

    <!-- Profile Modal -->
    <div class="modal fade" id="profileModal" tabindex="-1" aria-labelledby="profileModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="profileModalLabel">
                        <i class="fas fa-user-circle me-2"></i>My Profile
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <% if (donorProfile != null) { %>
                    <!-- View Mode -->
                    <div id="profileView">
                        <div class="row">
                            <div class="col-md-4 text-center mb-4">
                                <i class="fas fa-user-circle fa-5x text-success mb-3"></i>
                                <h5><%= donorProfile.getName() != null ? donorProfile.getName() : (userName != null ? userName : "Donor") %></h5>
                                <p class="text-muted">Food Donor</p>
                                <span class="badge bg-success">DONOR</span>
                            </div>
                            <div class="col-md-8">
                                <h6 class="text-success mb-3">Personal Information</h6>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Name:</strong></div>
                                    <div class="col-sm-8"><%= donorProfile.getName() != null ? donorProfile.getName() : (userName != null ? userName : "N/A") %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Email:</strong></div>
                                    <div class="col-sm-8"><%= donorProfile.getEmail() != null ? donorProfile.getEmail() : (userEmail != null ? userEmail : "N/A") %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Phone:</strong></div>
                                    <div class="col-sm-8"><%= donorProfile.getPhone() != null ? donorProfile.getPhone() : "Not provided" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Address:</strong></div>
                                    <div class="col-sm-8"><%= donorProfile.getFullAddress() != null ? donorProfile.getFullAddress() : "Not provided" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Organization:</strong></div>
                                    <div class="col-sm-8"><%= donorProfile.getOrganizationName() != null ? donorProfile.getOrganizationName() : "Individual" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Donation Frequency:</strong></div>
                                    <div class="col-sm-8"><%= donorProfile.getDonationFrequency() != null ? donorProfile.getDonationFrequency() : "Not specified" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Member Since:</strong></div>
                                    <div class="col-sm-8"><%= donorProfile.getCreatedAt() != null ? donorProfile.getCreatedAt().substring(0, 10) : "N/A" %></div>
                                </div>
                                <hr>
                                <h6 class="text-success mb-3">Statistics</h6>
                                <div class="row">
                                    <div class="col-6 text-center">
                                        <h4 class="text-success"><%= activeListings %></h4>
                                        <small class="text-muted">Active Listings</small>
                                    </div>
                                    <div class="col-6 text-center">
                                        <h4 class="text-success"><%= totalRequests %></h4>
                                        <small class="text-muted">Total Requests</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Edit Mode -->
                    <div id="profileEdit" style="display: none;">
                        <form id="profileForm" action="updateProfile.jsp" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="userId" value="<%= donorId %>">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="name" value="<%= donorProfile.getName() != null ? donorProfile.getName() : (userName != null ? userName : "") %>" required>
                                    <div class="invalid-feedback">Please provide your name.</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" name="email" value="<%= donorProfile.getEmail() != null ? donorProfile.getEmail() : (userEmail != null ? userEmail : "") %>" required>
                                    <div class="invalid-feedback">Please provide a valid email address.</div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Phone</label>
                                    <input type="tel" class="form-control" name="phone" value="<%= donorProfile.getPhone() != null ? donorProfile.getPhone() : "" %>">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Organization Name</label>
                                    <input type="text" class="form-control" name="organizationName" value="<%= donorProfile.getOrganizationName() != null ? donorProfile.getOrganizationName() : "" %>">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Address</label>
                                <textarea class="form-control" name="fulladdress" rows="2"><%= donorProfile.getFullAddress() != null ? donorProfile.getFullAddress() : "" %></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Donation Frequency</label>
                                <select class="form-select" name="donationFrequency">
                                    <option value="">Select frequency</option>
                                    <option value="Weekly" <%= "Weekly".equals(donorProfile.getDonationFrequency()) ? "selected" : "" %>>Weekly</option>
                                    <option value="Monthly" <%= "Monthly".equals(donorProfile.getDonationFrequency()) ? "selected" : "" %>>Monthly</option>
                                    <option value="Occasionally" <%= "Occasionally".equals(donorProfile.getDonationFrequency()) ? "selected" : "" %>>Occasionally</option>
                                    <option value="As needed" <%= "As needed".equals(donorProfile.getDonationFrequency()) ? "selected" : "" %>>As needed</option>
                                </select>
                            </div>
                        </form>
                    </div>
                    <% } else { %>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Unable to load profile information. Please try again later.
                        </div>
                    <% } %>
                </div>
                <div class="modal-footer">
                    <div id="viewButtons">
                        <button type="button" class="btn btn-primary" onclick="toggleEditMode()">Edit Profile</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    </div>
                    <div id="editButtons" style="display: none;">
                        <button type="button" class="btn btn-success" onclick="saveProfile()">Save Changes</button>
                        <button type="button" class="btn btn-secondary" onclick="toggleEditMode()">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Notifications Modal -->
    <div class="modal fade" id="notificationsModal" tabindex="-1" aria-labelledby="notificationsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="notificationsModalLabel">
                        <i class="fas fa-bell me-2"></i>Food Request Notifications
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="max-height: 500px; overflow-y: auto;">
                    <% if (notifications != null && !notifications.isEmpty()) { %>
                        <% for (NotificationBean notification : notifications) { %>
                            <div class="card mb-3 <%= !notification.isRead() ? "border-success" : "" %>">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <h6 class="card-title mb-2">
                                                <i class="fas fa-handshake text-success me-2"></i>
                                                Food Request
                                                <% if (!notification.isRead()) { %>
                                                    <span class="badge bg-success ms-2">New</span>
                                                <% } %>
                                            </h6>
                                            <p class="card-text mb-2">
                                                <strong>Message:</strong> <%= notification.getMessage() %>
                                            </p>
                                            <small class="text-muted">
                                                <i class="fas fa-clock me-1"></i>
                                                <%= notification.getCreatedAt() %>
                                            </small>
                                        </div>
                                        <div class="ms-3">
                                            <% if (notification.getFoodListingId() > 0) { %>
                                                <button class="btn btn-sm btn-outline-success" onclick="viewFoodRequest(<%= notification.getFoodListingId() %>)">
                                                    <i class="fas fa-eye me-1"></i>View Request
                                                </button>
                                            <% } %>
                                            <% if (!notification.isRead()) { %>
                                                <button class="btn btn-sm btn-outline-secondary mt-1" onclick="markAsRead(<%= notification.getId() %>)">
                                                    <i class="fas fa-check me-1"></i>Mark Read
                                                </button>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="text-center py-4">
                            <i class="fas fa-bell-slash fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No notifications yet</h5>
                            <p class="text-muted">You'll receive notifications when NGOs request your food items.</p>
                        </div>
                    <% } %>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <% if (unreadCount > 0) { %>
                        <button type="button" class="btn btn-success" onclick="markAllAsRead()">Mark All as Read</button>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/welcomePopup.js"></script>
    <script>
        function toggleEditMode() {
            const viewMode = document.getElementById('profileView');
            const editMode = document.getElementById('profileEdit');
            const viewButtons = document.getElementById('viewButtons');
            const editButtons = document.getElementById('editButtons');
            
            if (viewMode.style.display === 'none') {
                viewMode.style.display = 'block';
                editMode.style.display = 'none';
                viewButtons.style.display = 'block';
                editButtons.style.display = 'none';
            } else {
                viewMode.style.display = 'none';
                editMode.style.display = 'block';
                viewButtons.style.display = 'none';
                editButtons.style.display = 'block';
            }
        }
        
        function saveProfile() {
            const form = document.getElementById('profileForm');
            const formData = new FormData(form);
            
            fetch('updateProfile.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('SUCCESS')) {
                    alert('Profile updated successfully!');
                    location.reload();
                } else {
                    alert('Error updating profile.');
                }
            })
            .catch(() => alert('Error updating profile.'));
        }
        function toggleEditMode() {
            const viewMode = document.getElementById('profileView');
            const editMode = document.getElementById('profileEdit');
            const viewButtons = document.getElementById('viewButtons');
            const editButtons = document.getElementById('editButtons');
            
            if (viewMode && editMode && viewButtons && editButtons) {
                if (editMode.style.display === 'block') {
                    viewMode.style.display = 'block';
                    editMode.style.display = 'none';
                    viewButtons.style.display = 'block';
                    editButtons.style.display = 'none';
                } else {
                    viewMode.style.display = 'none';
                    editMode.style.display = 'block';
                    viewButtons.style.display = 'none';
                    editButtons.style.display = 'block';
                }
            }
        }
        
        function saveProfile() {
            const form = document.getElementById('profileForm');
            if (!form.checkValidity()) {
                form.classList.add('was-validated');
                return;
            }
            
            const formData = new FormData(form);
            const saveBtn = document.querySelector('#editButtons .btn-success');
            const originalText = saveBtn.innerHTML;
            saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving...';
            saveBtn.disabled = true;
            
            fetch('updateProfile.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('SUCCESS')) {
                    alert('Profile updated successfully!');
                    location.reload();
                } else {
                    alert('Error updating profile: ' + data);
                }
            })
            .catch(error => {
                alert('Error updating profile. Please try again.');
            })
            .finally(() => {
                saveBtn.innerHTML = originalText;
                saveBtn.disabled = false;
            });
        }
        
        // Global function for profile edit toggle
        window.toggleEditMode = function() {
            console.log('toggleEditMode called');
            const viewMode = document.getElementById('profileView');
            const editMode = document.getElementById('profileEdit');
            const viewButtons = document.getElementById('viewButtons');
            const editButtons = document.getElementById('editButtons');
            
            console.log('Elements:', {viewMode, editMode, viewButtons, editButtons});
            
            if (viewMode && editMode && viewButtons && editButtons) {
                if (editMode.style.display === 'block') {
                    // Switch to view mode
                    viewMode.style.display = 'block';
                    editMode.style.display = 'none';
                    viewButtons.style.display = 'block';
                    editButtons.style.display = 'none';
                } else {
                    // Switch to edit mode
                    viewMode.style.display = 'none';
                    editMode.style.display = 'block';
                    viewButtons.style.display = 'none';
                    editButtons.style.display = 'block';
                }
            } else {
                console.error('Profile elements not found');
            }
        };
        
        // Global function for saving profile
        window.saveProfile = function() {
            const form = document.getElementById('profileForm');
            if (!form.checkValidity()) {
                form.classList.add('was-validated');
                return;
            }
            
            const formData = new FormData(form);
            
            // Show loading state
            const saveBtn = document.querySelector('#editButtons .btn-success');
            const originalText = saveBtn.innerHTML;
            saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving...';
            saveBtn.disabled = true;
            
            fetch('updateProfile.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('SUCCESS')) {
                    alert('Profile updated successfully!');
                    location.reload();
                } else {
                    alert('Error updating profile: ' + data);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating profile. Please try again.');
            })
            .finally(() => {
                saveBtn.innerHTML = originalText;
                saveBtn.disabled = false;
            });
        };
        
        function toggleEditMode() {
            return window.toggleEditMode();
        }
        
        function saveProfile() {
            return window.saveProfile();
        }
        
        function oldSaveProfile() {
            const form = document.getElementById('profileForm');
            if (!form.checkValidity()) {
                form.classList.add('was-validated');
                return;
            }
            
            const formData = new FormData(form);
            
            // Show loading state
            const saveBtn = document.querySelector('#editButtons .btn-success');
            const originalText = saveBtn.innerHTML;
            saveBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving...';
            saveBtn.disabled = true;
            
            fetch('updateProfile.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.text())
            .then(data => {
                console.log('Response:', data);
                if (data.includes('SUCCESS')) {
                    alert('Profile updated successfully!');
                    location.reload();
                } else {
                    alert('Error updating profile: ' + data);
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error updating profile. Please try again.');
            })
            .finally(() => {
                saveBtn.innerHTML = originalText;
                saveBtn.disabled = false;
            });
        }
        
        // Dynamic Dashboard Functionality
        class DonorDashboard {
            constructor() {
                this.currentSection = 'dashboard';
                this.init();
            }

            init() {
                this.loadTheme();
                this.setupNavigation();
                this.setupInteractiveElements();
                this.startAutoRefresh();
                this.setupModals();
                this.setupAnimations();
                this.setupKeyboardShortcuts();
                this.setupDragAndDrop();
                this.setupSearch();
            }

            setupNavigation() {
                // Handle sidebar navigation
                document.querySelectorAll('.sidebar .nav-link').forEach(link => {
                    link.addEventListener('click', (e) => {
                        e.preventDefault();
                        const target = e.currentTarget.getAttribute('href').substring(1);
                        this.showSection(target);
                        this.updateActiveNav(e.currentTarget);
                    });
                });

                // Handle anchor links in welcome section
                document.querySelectorAll('a[href^="#"]').forEach(link => {
                    link.addEventListener('click', (e) => {
                        e.preventDefault();
                        const target = e.currentTarget.getAttribute('href').substring(1);
                        this.showSection(target);
                        this.updateActiveNavBySection(target);
                    });
                });
            }

            showSection(sectionName) {
                // Hide all sections first
                document.querySelectorAll('[id^="section-"]').forEach(section => {
                    section.style.display = 'none';
                });

                // Show target section with animation
                const targetSection = document.getElementById(`section-${sectionName}`);
                if (targetSection) {
                    targetSection.style.display = 'block';
                    targetSection.style.opacity = '0';
                    targetSection.style.transform = 'translateY(20px)';
                    
                    setTimeout(() => {
                        targetSection.style.transition = 'all 0.3s ease';
                        targetSection.style.opacity = '1';
                        targetSection.style.transform = 'translateY(0)';
                    }, 10);
                }

                this.currentSection = sectionName;
                this.loadSectionData(sectionName);
            }

            updateActiveNav(activeLink) {
                document.querySelectorAll('.sidebar .nav-link').forEach(link => {
                    link.classList.remove('active');
                });
                activeLink.classList.add('active');
            }

            updateActiveNavBySection(sectionName) {
                document.querySelectorAll('.sidebar .nav-link').forEach(link => {
                    link.classList.remove('active');
                    if (link.getAttribute('href') === `#${sectionName}`) {
                        link.classList.add('active');
                    }
                });
            }

            loadSectionData(sectionName) {
                switch(sectionName) {
                    case 'dashboard':
                        this.loadDashboardData();
                        break;
                    case 'my-listings':
                        this.loadMyListings();
                        break;
                    case 'requests':
                        this.loadNGORequests();
                        break;
                    case 'add-food':
                        this.showAddFoodForm();
                        break;
                    case 'profile':
                        this.loadProfileData();
                        break;
                }
            }

            loadDashboardData() {
                // Simulate real-time data updates
                this.updateStatistics();
                this.loadRecentActivity();
            }

            updateStatistics() {
                // Animate statistics counters
                const statNumbers = document.querySelectorAll('.stats-number');
                statNumbers.forEach(stat => {
                    const finalValue = stat.textContent;
                    if (!isNaN(finalValue)) {
                        this.animateCounter(stat, parseInt(finalValue));
                    }
                });
            }

            animateCounter(element, target) {
                let current = 0;
                const increment = target / 50;
                const timer = setInterval(() => {
                    current += increment;
                    if (current >= target) {
                        element.textContent = target;
                        clearInterval(timer);
                    } else {
                        element.textContent = Math.floor(current);
                    }
                }, 30);
            }

            loadRecentActivity() {
                // Add loading animation to food cards
                const foodCards = document.querySelectorAll('.food-card');
                foodCards.forEach((card, index) => {
                    card.style.animationDelay = (index * 0.1) + 's';
                    card.classList.add('fade-in-up');
                });
            }

            loadMyListings() {
                // Create dynamic listings section
                const content = '<div class="main-content">' +
                    '<div class="d-flex justify-content-between align-items-center mb-4">' +
                        '<h4><i class="fas fa-utensils me-2"></i>My Food Listings</h4>' +
                        '<button class="btn btn-success" onclick="dashboard.showAddFoodForm()">' +
                            '<i class="fas fa-plus me-2"></i>Add New Listing' +
                        '</button>' +
                    '</div>' +
                    '<div class="row mb-4">' +
                        '<div class="col-md-3">' +
                            '<select class="form-select" id="status-filter">' +
                                '<option value="">All Status</option>' +
                                '<option value="Available">Available</option>' +
                                '<option value="Reserved">Reserved</option>' +
                                '<option value="Collected">Collected</option>' +
                                '<option value="Expired">Expired</option>' +
                            '</select>' +
                        '</div>' +
                        '<div class="col-md-3">' +
                            '<select class="form-select" id="food-type-filter">' +
                                '<option value="">All Types</option>' +
                                '<option value="Fruits">Fruits</option>' +
                                '<option value="Vegetables">Vegetables</option>' +
                                '<option value="Dairy">Dairy</option>' +
                                '<option value="Meat">Meat</option>' +
                                '<option value="Bakery">Bakery</option>' +
                                '<option value="Prepared">Prepared Food</option>' +
                                '<option value="Other">Other</option>' +
                            '</select>' +
                        '</div>' +
                        '<div class="col-md-3">' +
                            '<select class="form-select" id="sort-by">' +
                                '<option value="createdAt">Sort by Date</option>' +
                                '<option value="expiryDate">Sort by Expiry</option>' +
                                '<option value="foodName">Sort by Name</option>' +
                                '<option value="status">Sort by Status</option>' +
                            '</select>' +
                        '</div>' +
                        '<div class="col-md-3">' +
                            '<button class="btn btn-outline-secondary" onclick="dashboard.clearFilters()">' +
                                '<i class="fas fa-times me-2"></i>Clear Filters' +
                            '</button>' +
                        '</div>' +
                    '</div>' +
                    '<div class="row" id="listings-container">' +
                        '<!-- Dynamic listings will be loaded here -->' +
                    '</div>' +
                '</div>';
                this.updateMainContent(content);
                this.fetchMyListings();
                this.setupListingsFilters();
            }

            fetchMyListings() {
                // Simulate API call to fetch listings
                setTimeout(() => {
                    const container = document.getElementById('listings-container');
                    if (container) {
                        container.innerHTML = '<div class="col-12">' +
                            '<div class="alert alert-info">' +
                                '<i class="fas fa-info-circle me-2"></i>' +
                                'Loading your food listings...' +
                            '</div>' +
                        '</div>';
                    }
                }, 500);
            }

            loadNGORequests() {
                const content = '<div class="main-content">' +
                    '<h4 class="mb-4"><i class="fas fa-handshake me-2"></i>NGO Requests</h4>' +
                    '<div class="row">' +
                        '<div class="col-md-4">' +
                            '<div class="stats-card">' +
                                '<div class="stats-number" id="pending-requests">0</div>' +
                                '<div>Pending Requests</div>' +
                            '</div>' +
                        </div>' +
                        '<div class="col-md-4">' +
                            '<div class="stats-card">' +
                                '<div class="stats-number" id="accepted-requests">0</div>' +
                                '<div>Accepted Requests</div>' +
                            '</div>' +
                        </div>' +
                        '<div class="col-md-4">' +
                            '<div class="stats-card">' +
                                '<div class="stats-number" id="completed-requests">0</div>' +
                                '<div>Completed Requests</div>' +
                            </div>
                        </div>' +
                    '</div>' +
                    '<div class="mt-4" id="requests-container">' +
                        '<!-- Dynamic requests will be loaded here -->' +
                    '</div>' +
                '</div>';
                this.updateMainContent(content);
                this.loadRequestsData();
            }

            loadRequestsData() {
                // Simulate loading requests data
                setTimeout(() => {
                    var totalRequests = parseInt(document.body.getAttribute('data-total-requests')) || 0;
                    this.animateCounter(document.getElementById('pending-requests'), totalRequests);
                    this.animateCounter(document.getElementById('accepted-requests'), 5);
                    this.animateCounter(document.getElementById('completed-requests'), 12);
                }, 300);
            }

            showAddFoodForm() {
                const content = '<div class="main-content">' +
                    '<h4 class="mb-4"><i class="fas fa-plus-circle me-2"></i>Add New Food Listing</h4>' +
                    '<form id="add-food-form" class="needs-validation" novalidate>' +
                        '<div class="row">' +
                            '<div class="col-md-6 mb-3">' +
                                '<label for="foodName" class="form-label">Food Name <span class="text-danger">*</span></label>' +
                                '<input type="text" class="form-control" id="foodName" required placeholder="e.g., Fresh Apples">' +
                                '<div class="invalid-feedback">Please provide a food name.</div>' +
                            '</div>' +
                            '<div class="col-md-3 mb-3">' +
                                '<label for="quantity" class="form-label">Quantity <span class="text-danger">*</span></label>' +
                                '<input type="number" class="form-control" id="quantity" required min="1" step="0.1" placeholder="10">' +
                                '<div class="invalid-feedback">Please provide quantity.</div>' +
                            '</div>' +
                            '<div class="col-md-3 mb-3">' +
                                '<label for="quantityUnit" class="form-label">Unit <span class="text-danger">*</span></label>' +
                                '<select class="form-select" id="quantityUnit" required>' +
                                    '<option value="">Select Unit</option>' +
                                    '<option value="kg">Kilograms (kg)</option>' +
                                    '<option value="grams">Grams (g)</option>' +
                                    '<option value="pieces">Pieces</option>' +
                                    '<option value="liters">Liters (L)</option>' +
                                    '<option value="plates">Plates</option>' +
                                    '<option value="boxes">Boxes</option>' +
                                    '<option value="bottles">Bottles</option>' +
                                '</select>' +
                            '</div>' +
                        '</div>' +
                        '<div class="row">' +
                            '<div class="col-md-6 mb-3">' +
                                '<label for="foodType" class="form-label">Food Type <span class="text-danger">*</span></label>' +
                                '<select class="form-select" id="foodType" required>' +
                                    '<option value="">Select Food Type</option>' +
                                    '<option value="Fruits">Fruits</option>' +
                                    '<option value="Vegetables">Vegetables</option>' +
                                    '<option value="Dairy">Dairy Products</option>' +
                                    '<option value="Meat">Meat & Poultry</option>' +
                                    '<option value="Bakery">Bakery Items</option>' +
                                    '<option value="Prepared">Prepared Food</option>' +
                                    '<option value="Grains">Grains & Cereals</option>' +
                                    '<option value="Other">Other</option>' +
                                '</select>' +
                            </div>' +
                            '<div class="col-md-6 mb-3">' +
                                '<label for="expiryDate" class="form-label">Expiry Date <span class="text-danger">*</span></label>' +
                                '<input type="date" class="form-control" id="expiryDate" required>' +
                                '<div class="invalid-feedback">Please select expiry date.</div>' +
                            '</div>' +
                        </div>' +
                        '<div class="mb-3">' +
                            '<label for="description" class="form-label">Description</label>' +
                            '<textarea class="form-control" id="description" rows="3" placeholder="Describe the food item, its condition, and any special notes..."></textarea>' +
                        '</div>' +
                        '<div class="row">' +
                            '<div class="col-md-8 mb-3">' +
                                '<label for="pickupAddress" class="form-label">Pickup Address <span class="text-danger">*</span></label>' +
                                '<input type="text" class="form-control" id="pickupAddress" required placeholder="Street address">' +
                                '<div class="invalid-feedback">Please provide pickup address.</div>' +
                            </div>' +
                            '<div class="col-md-2 mb-3">' +
                                '<label for="pickupCity" class="form-label">City <span class="text-danger">*</span></label>' +
                                '<input type="text" class="form-control" id="pickupCity" required placeholder=\'City\'>' +
                            '</div>' +
                            '<div class="col-md-2 mb-3">' +
                                '<label for="pickupState" class="form-label">State <span class="text-danger">*</span></label>' +
                                '<input type="text" class="form-control" id="pickupState" required placeholder=\'State\'>' +
                            '</div>' +
                        '</div>' +
                        '<div class="row">' +
                            '<div class="col-md-6 mb-3">' +
                                '<label for="pickupZipCode" class="form-label">ZIP Code</label>' +
                                '<input type="text" class="form-control" id="pickupZipCode" placeholder="12345">' +
                            '</div>' +
                            '<div class="col-md-6 mb-3">' +
                                '<label for="status" class="form-label">Initial Status</label>' +
                                '<select class="form-select" id="status">' +
                                    '<option value="Available" selected>Available</option>' +
                                    '<option value="Reserved">Reserved</option>' +
                                '</select>' +
                            '</div>' +
                        '</div>' +
                        '<div class="mb-3">' +
                            '<label for="pickupInstructions" class="form-label">Pickup Instructions</label>' +
                            '<textarea class="form-control" id="pickupInstructions" rows="2" placeholder="Special instructions for pickup (e.g., Ring doorbell, Call before coming, etc.)"></textarea>' +
                        '</div>' +
                        '<div class="d-flex gap-2">' +
                            '<button type="submit" class="btn btn-success">' +
                                '<i class="fas fa-save me-2"></i>Save Listing' +
                            '</button>' +
                            '<button type="button" class="btn btn-secondary" onclick="dashboard.showSection(\'dashboard\')">' +
                                '<i class="fas fa-times me-2"></i>Cancel' +
                            '</button>' +
                        '</div>' +
                    '</form>' +
                '</div>';
                this.updateMainContent(content);
                this.setupAddFoodForm();
            }

            setupAddFoodForm() {
                const form = document.getElementById('add-food-form');
                if (form) {
                    form.addEventListener('submit', (e) => {
                        e.preventDefault();
                        this.submitFoodListing(form);
                    });
                }
            }

            submitFoodListing(form) {
                if (form.checkValidity()) {
                    // Show loading state
                    const submitBtn = form.querySelector('button[type="submit"]');
                    const originalText = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Saving...';
                    submitBtn.disabled = true;

                    // Collect form data
                    const formData = new FormData(form);
                    
                    // Add donor ID from session
                    const donorId = document.body.getAttribute('data-donor-id') || '<%= donorId %>';
                    formData.append('donorId', donorId);
                    
                    // Add additional fields that might not be in the form
                    formData.append('isActive', 'true');
                    
                    // Submit to backend
                    fetch('addFoodListingProcess.jsp', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => {
                        if (response.ok) {
                            // Check if response is a redirect (success) or error page
                            const url = new URL(response.url);
                            if (url.searchParams.get('success')) {
                                this.showNotification('Food listing added successfully!', 'success');
                                submitBtn.innerHTML = originalText;
                                submitBtn.disabled = false;
                                
                                // Reset form
                                form.reset();
                                form.classList.remove('was-validated');
                                
                                // Navigate back to dashboard or listings
                                this.showSection('my-listings');
                                
                                // Refresh the listings
                                this.loadMyListings();
                            } else if (url.searchParams.get('error')) {
                                throw new Error('Server error: ' + url.searchParams.get('error'));
                            } else {
                                // If we get here, it's likely a successful redirect
                                this.showNotification('Food listing added successfully!', 'success');
                                submitBtn.innerHTML = originalText;
                                submitBtn.disabled = false;
                                this.showSection('my-listings');
                            }
                        } else {
                            throw new Error('Network response was not ok');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        this.showNotification('Error saving food listing. Please try again.', 'danger');
                        submitBtn.innerHTML = originalText;
                        submitBtn.disabled = false;
                    });
                } else {
                    form.classList.add('was-validated');
                }
            }

            loadProfileData() {
                const donorId = document.body.getAttribute('data-donor-id');
                const formData = new FormData();
                formData.append('userId', donorId);
                
                fetch('getProfileData.jsp', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.text())
                .then(data => {
                    let userData = { name: '', email: '', phone: '', address: '', organizationName: '', donationFrequency: '', verificationStatus: 'pending' };
                    
                    if (data && data.includes('SUCCESS:')) {
                        try {
                            const jsonData = data.split('SUCCESS:')[1];
                            const parsed = JSON.parse(jsonData);
                            userData = { ...userData, ...parsed };
                        } catch (e) {
                            console.log('Using default profile data');
                        }
                    }
                    
                    const content = '<div class="main-content">' +
                        '<h4 class="mb-4"><i class="fas fa-user-cog me-2"></i>Profile Settings</h4>' +
                        '<div class="row">' +
                            '<div class="col-md-4">' +
                                '<div class="card text-center">' +
                                    '<div class="card-body">' +
                                        '<div class="profile-avatar mb-3">' +
                                            '<i class="fas fa-user-circle fa-5x text-primary"></i>' +
                                        '</div>' +
                                        '<h5>' + (userData.name || 'Donor') + '</h5>' +
                                        '<p class="text-muted">Food Donor</p>' +
                                        '<span class="badge ' + (userData.verificationStatus === 'verified' ? 'bg-success' : 'bg-warning') + '">' +
                                            (userData.verificationStatus || 'Pending') + ' Status' +
                                        '</span>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                            '<div class="col-md-8">' +
                                '<div class="card">' +
                                    '<div class="card-header">' +
                                        '<h6 class="mb-0"><i class="fas fa-edit me-2"></i>Edit Profile Information</h6>' +
                                    '</div>' +
                                    '<div class="card-body">' +
                                        '<form id="profile-form" class="needs-validation" novalidate>' +
                                            '<div class="row">' +
                                                '<div class="col-md-6 mb-3">' +
                                                    '<label class="form-label">Full Name <span class="text-danger">*</span></label>' +
                                                    '<input type="text" class="form-control" name="name" value="' + (userData.name || '') + '" required>' +
                                                    '<div class="invalid-feedback">Please provide your full name.</div>' +
                                                '</div>' +
                                                '<div class="col-md-6 mb-3">' +
                                                    '<label class="form-label">Email <span class="text-danger">*</span></label>' +
                                                    '<input type="email" class="form-control" name="email" value="' + (userData.email || '') + '" required>' +
                                                    '<div class="invalid-feedback">Please provide a valid email.</div>' +
                                                '</div>' +
                                            '</div>' +
                                            '<div class="row">' +
                                                '<div class="col-md-6 mb-3">' +
                                                    '<label class="form-label">Phone Number</label>' +
                                                    '<input type="tel" class="form-control" name="phone" value="' + (userData.phone || '') + '" placeholder="+1234567890">' +
                                                '</div>' +
                                                '<div class="col-md-6 mb-3">' +
                                                    '<label class="form-label">Donation Frequency</label>' +
                                                    '<select class="form-select" name="donationFrequency">' +
                                                        '<option value="">Select frequency</option>' +
                                                        '<option value="Weekly"' + (userData.donationFrequency === 'Weekly' ? ' selected' : '') + '>Weekly</option>' +
                                                        '<option value="Monthly"' + (userData.donationFrequency === 'Monthly' ? ' selected' : '') + '>Monthly</option>' +
                                                        '<option value="Occasionally"' + (userData.donationFrequency === 'Occasionally' ? ' selected' : '') + '>Occasionally</option>' +
                                                        '<option value="As needed"' + (userData.donationFrequency === 'As needed' ? ' selected' : '') + '>As needed</option>' +
                                                    '</select>' +
                                                '</div>' +
                                            '</div>' +
                                            '<div class="mb-3">' +
                                                '<label class="form-label">Address</label>' +
                                                '<textarea class="form-control" name="fulladdress" rows="2" placeholder="Enter your full address">' + (userData.address || '') + '</textarea>' +
                                            '</div>' +
                                            '<div class="mb-3">' +
                                                '<label class="form-label">Organization Name (if applicable)</label>' +
                                                '<input type="text" class="form-control" name="organizationName" value="' + (userData.organizationName || '') + '" placeholder="Restaurant, Hotel, etc.">' +
                                            '</div>' +
                                            '<div class="d-flex gap-2">' +
                                                '<button type="submit" class="btn btn-primary">' +
                                                    '<i class="fas fa-save me-2"></i>Update Profile' +
                                                '</button>' +
                                                '<button type="button" class="btn btn-secondary" onclick="dashboard.showSection(\'dashboard\')">' +
                                                    '<i class="fas fa-times me-2"></i>Cancel' +
                                                '</button>' +
                                            '</div>' +
                                        '</form>' +
                                    '</div>' +
                                '</div>' +
                            '</div>' +
                        '</div>' +
                    '</div>';
                    
                    this.updateMainContent(content);
                    this.setupProfileForm();
                })
                .catch(error => {
                    console.error('Error fetching profile:', error);
                    const content = '<div class="main-content">' +
                        '<h4 class="mb-4"><i class="fas fa-user-cog me-2"></i>Profile Settings</h4>' +
                        '<div class="alert alert-danger">Error loading profile data. Please try again.</div>' +
                    '</div>';
                    this.updateMainContent(content);
                });
            }

            setupProfileForm() {
                const form = document.getElementById('profile-form');
                if (form) {
                    form.addEventListener('submit', (e) => {
                        e.preventDefault();
                        this.updateProfile(form);
                    });
                }
            }

            updateProfile(form) {
                if (form.checkValidity()) {
                    const submitBtn = form.querySelector('button[type="submit"]');
                    const originalText = submitBtn.innerHTML;
                    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Updating...';
                    submitBtn.disabled = true;

                    const formData = new FormData(form);
                    const donorId = document.body.getAttribute('data-donor-id');
                    formData.append('userId', donorId);

                    fetch('updateProfile.jsp', {
                        method: 'POST',
                        body: formData
                    })
                    .then(response => response.text())
                    .then(data => {
                        if (data.includes('SUCCESS')) {
                            this.showNotification('Profile updated successfully!', 'success');
                            setTimeout(() => {
                                this.loadProfileData();
                            }, 1000);
                        } else {
                            throw new Error('Update failed');
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        this.showNotification('Error updating profile. Please try again.', 'danger');
                    })
                    .finally(() => {
                        submitBtn.innerHTML = originalText;
                        submitBtn.disabled = false;
                    });
                } else {
                    form.classList.add('was-validated');
                }
            }

            oldLoadProfileData() {
                const content = '<div class="main-content">' +
                    '<h4 class="mb-4"><i class="fas fa-user-cog me-2"></i>Profile Settings</h4>' +
                    '<div class="row">' +
                        '<div class="col-md-4">' +
                            '<div class="text-center">' +
                                '<div class="profile-avatar mb-3">' +
                                    '<i class="fas fa-user-circle fa-5x text-primary"></i>' +
                                </div>' +
                                '<h5><%= userName != null ? userName : "Donor" %></h5>' +
                                '<p class="text-muted">Food Donor</p>' +
                                '<button class="btn btn-outline-primary btn-sm">' +
                                    '<i class="fas fa-camera me-2"></i>Change Photo' +
                                '</button>' +
                            '</div>' +
                        </div>' +
                        '<div class="col-md-8">' +
                            '<form>' +
                                '<div class="row">' +
                                    '<div class="col-md-6 mb-3">' +
                                        '<label class="form-label">Full Name</label>' +
                                        '<input type="text" class="form-control" value="<%= userName != null ? userName : "Donor" %>">' +
                                    </div>' +
                                    '<div class="col-md-6 mb-3">' +
                                        '<label class="form-label">Email</label>' +
                                        '<input type="email" class="form-control" value="donor@example.com">' +
                                    </div>' +
                                '</div>' +
                                '<div class="row">' +
                                    '<div class="col-md-6 mb-3">' +
                                        '<label class="form-label">Phone</label>' +
                                        '<input type="tel" class="form-control" value="+1234567890">' +
                                    </div>' +
                                    '<div class="col-md-6 mb-3">' +
                                        '<label class="form-label">Location</label>' +
                                        '<input type="text" class="form-control" value="New York, NY">' +
                                    </div>' +
                                '</div>' +
                                '<button type="submit" class="btn btn-primary">' +
                                    '<i class="fas fa-save me-2"></i>Update Profile' +
                                '</button>' +
                            '</form>' +
                        </div>' +
                    </div>' +
                '</div>';
                this.updateMainContent(content);
            }

            updateMainContent(content) {
                const mainContent = document.querySelector('.col-md-9.col-lg-10');
                if (mainContent) {
                    mainContent.innerHTML = content;
                }
            }

            setupInteractiveElements() {
                // Add hover effects to cards
                document.addEventListener('mouseover', (e) => {
                    if (e.target.closest('.food-card')) {
                        e.target.closest('.food-card').style.transform = 'translateY(-5px) scale(1.02)';
                    }
                });

                document.addEventListener('mouseout', (e) => {
                    if (e.target.closest('.food-card')) {
                        e.target.closest('.food-card').style.transform = 'translateY(0) scale(1)';
                    }
                });

                // Add click handlers for food cards
                document.addEventListener('click', (e) => {
                    if (e.target.closest('.food-card.interactive-card') && !e.target.closest('.btn-group')) {
                        const foodId = e.target.closest('.food-card').getAttribute('data-food-id');
                        if (foodId) {
                            this.viewFoodDetails(foodId);
                        }
                    }
                });

                // Edit buttons handled by native anchor tags

                // Add click handlers for status update buttons
                document.addEventListener('click', (e) => {
                    if (e.target.closest('.status-btn')) {
                        e.stopPropagation();
                        const foodId = e.target.closest('.status-btn').getAttribute('data-food-id');
                        const currentStatus = e.target.closest('.status-btn').getAttribute('data-current-status');
                        if (foodId && currentStatus) {
                            this.showStatusModal(foodId, currentStatus);
                        }
                    }
                });
            }

            setupModals() {
                // Create notification system
                this.createNotificationContainer();
            }

            createNotificationContainer() {
                if (!document.getElementById('notification-container')) {
                    const container = document.createElement('div');
                    container.id = 'notification-container';
                    container.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 9999;';
                    document.body.appendChild(container);
                }
            }

            showNotification(message, type = 'info') {
                const container = document.getElementById('notification-container');
                const notification = document.createElement('div');
                notification.className = 'alert alert-' + type + ' alert-dismissible fade show';
                notification.style.cssText = 'margin-bottom: 10px; min-width: 300px; box-shadow: 0 4px 20px rgba(0,0,0,0.1);';
                notification.innerHTML = message + '<button type="button" class="btn-close" data-bs-dismiss="alert"></button>';
                
                container.appendChild(notification);
                
                // Auto remove after 5 seconds
                setTimeout(() => {
                    if (notification.parentNode) {
                        notification.remove();
                    }
                }, 5000);
            }

            setupAnimations() {
                // Add CSS for animations
                const style = document.createElement('style');
                style.textContent = '.fade-in-up { animation: fadeInUp 0.6s ease forwards; } ' +
                    '@keyframes fadeInUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: translateY(0); } } ' +
                    '.food-card { transition: all 0.3s ease; } ' +
                    '.stats-card { transition: all 0.3s ease; } ' +
                    '.stats-card:hover { transform: translateY(-5px); }';
                document.head.appendChild(style);
            }

            startAutoRefresh() {
                // Refresh statistics every 30 seconds
                setInterval(() => {
                    if (this.currentSection === 'dashboard') {
                        this.updateStatistics();
                    }
                }, 30000);
                
                // Check for expired listings every 5 minutes
                setInterval(() => {
                    this.checkExpiredListings();
                }, 300000);
            }
            
            checkExpiredListings() {
                fetch('updateExpiredListings.jsp', {
                    method: 'GET'
                })
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.updatedCount > 0) {
                        this.showNotification(`${data.updatedCount} expired listing(s) updated to "Not Available"`, 'warning');
                        // Refresh current section if viewing listings
                        if (this.currentSection === 'my-listings') {
                            setTimeout(() => {
                                location.reload();
                            }, 2000);
                        }
                    }
                })
                .catch(error => {
                    console.error('Error checking expired listings:', error);
                });
            }

            viewFoodDetails(foodId) {
                // Show food details in a modal or redirect
                this.showNotification('Loading food details...', 'info');
                setTimeout(() => {
                    window.location.href = 'viewFoodListing.jsp?id=' + foodId;
                }, 500);
            }

            editFoodListing(foodId) {
                // Show edit form for the food listing
                this.showNotification('Opening edit form...', 'info');
                // You can implement an edit modal here or redirect to edit page
                setTimeout(() => {
                    window.location.href = 'editFoodListing.jsp?id=' + foodId;
                }, 500);
            }

            // Add real-time search functionality
            setupSearch() {
                const searchInput = document.getElementById('search-input');
                if (searchInput) {
                    searchInput.addEventListener('input', (e) => {
                        this.filterContent(e.target.value);
                    });
                }
            }

            filterContent(searchTerm) {
                const cards = document.querySelectorAll('.food-card');
                cards.forEach(card => {
                    const text = card.textContent.toLowerCase();
                    const matches = text.includes(searchTerm.toLowerCase());
                    card.style.display = matches ? 'block' : 'none';
                    
                    if (matches) {
                        card.classList.add('fade-in-up');
                    }
                });
            }

            // Add keyboard shortcuts
            setupKeyboardShortcuts() {
                document.addEventListener('keydown', (e) => {
                    if (e.ctrlKey || e.metaKey) {
                        switch(e.key) {
                            case '1':
                                e.preventDefault();
                                this.showSection('dashboard');
                                break;
                            case '2':
                                e.preventDefault();
                                this.showSection('my-listings');
                                break;
                            case '3':
                                e.preventDefault();
                                this.showSection('requests');
                                break;
                            case '4':
                                e.preventDefault();
                                this.showSection('add-food');
                                break;
                            case '5':
                                e.preventDefault();
                                this.showSection('profile');
                                break;
                        }
                    }
                });
            }

            // Add drag and drop functionality for food cards
            setupDragAndDrop() {
                const cards = document.querySelectorAll('.food-card');
                cards.forEach(card => {
                    card.draggable = true;
                    card.addEventListener('dragstart', (e) => {
                        e.dataTransfer.setData('text/plain', card.dataset.foodId);
                        card.style.opacity = '0.5';
                    });
                    
                    card.addEventListener('dragend', (e) => {
                        card.style.opacity = '1';
                    });
                });
            }

            // Add progress tracking
            updateProgress() {
                const progressBar = document.querySelector('.progress-bar');
                if (progressBar) {
                    const currentValue = parseInt(progressBar.style.width) || 0;
                    const targetValue = Math.min(currentValue + 10, 100);
                    
                    let current = currentValue;
                    const timer = setInterval(() => {
                        current += 2;
                        progressBar.style.width = current + '%';
                        
                        if (current >= targetValue) {
                            clearInterval(timer);
                        }
                    }, 50);
                }
            }

            // Add theme switching capability
            toggleTheme() {
                const body = document.body;
                const currentTheme = body.getAttribute('data-theme');
                const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
                
                body.setAttribute('data-theme', newTheme);
                localStorage.setItem('theme', newTheme);
                
                this.showNotification('Switched to ' + newTheme + ' theme', 'success');
            }

            // Load saved theme
            loadTheme() {
                const savedTheme = localStorage.getItem('theme') || 'light';
                document.body.setAttribute('data-theme', savedTheme);
            }

            // Setup listings filters
            setupListingsFilters() {
                const statusFilter = document.getElementById('status-filter');
                const typeFilter = document.getElementById('food-type-filter');
                const sortBy = document.getElementById('sort-by');

                if (statusFilter) {
                    statusFilter.addEventListener('change', () => this.applyFilters());
                }
                if (typeFilter) {
                    typeFilter.addEventListener('change', () => this.applyFilters());
                }
                if (sortBy) {
                    sortBy.addEventListener('change', () => this.applyFilters());
                }
            }

            // Apply filters to listings
            applyFilters() {
                const statusFilter = document.getElementById('status-filter')?.value || '';
                const typeFilter = document.getElementById('food-type-filter')?.value || '';
                const sortBy = document.getElementById('sort-by')?.value || 'createdAt';

                // This would filter the displayed listings based on the selected criteria
                this.showNotification('Filters applied: ' + (statusFilter || 'All Status') + ', ' + (typeFilter || 'All Types'), 'info');
                
                // In a real implementation, you would:
                // 1. Filter the listings array based on status and type
                // 2. Sort the filtered results
                // 3. Re-render the listings container
            }

            // Clear all filters
            clearFilters() {
                const statusFilter = document.getElementById('status-filter');
                const typeFilter = document.getElementById('food-type-filter');
                const sortBy = document.getElementById('sort-by');

                if (statusFilter) statusFilter.value = '';
                if (typeFilter) typeFilter.value = '';
                if (sortBy) sortBy.value = 'createdAt';

                this.applyFilters();
                this.showNotification('All filters cleared', 'success');
            }

            // Update food listing status
            updateFoodStatus(foodId, newStatus) {
                this.showNotification('Updating status to ' + newStatus + '...', 'info');
                
                // Create form data for status update
                const formData = new FormData();
                formData.append('foodId', foodId);
                formData.append('status', newStatus);
                formData.append('action', 'updateStatus');
                
                // Submit to backend
                fetch('updateFoodStatus.jsp', {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.ok) {
                        return response.json();
                    }
                    throw new Error('Network response was not ok');
                })
                .then(data => {
                    if (data.success) {
                        this.showNotification(data.message, 'success');
                        // Refresh the listings
                        this.showSection('my-listings');
                    } else {
                        throw new Error(data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    this.showNotification('Error updating status. Please try again.', 'danger');
                });
            }

            // Show status update modal
            showStatusModal(foodId, currentStatus) {
                const statusOptions = [
                    { value: 'Available', label: 'Available', color: 'success', icon: 'check-circle' },
                    { value: 'Reserved', label: 'Reserved', color: 'warning', icon: 'clock' },
                    { value: 'Collected', label: 'Collected', color: 'info', icon: 'handshake' },
                    { value: 'Expired', label: 'Expired', color: 'danger', icon: 'times-circle' },
                    { value: 'Inactive', label: 'Inactive', color: 'secondary', icon: 'ban' }
                ];
                const availableOptions = statusOptions.filter(status => status.value !== currentStatus);
                
                const modalContent = '<div class="modal fade" id="statusModal" tabindex="-1">' +
                    '<div class="modal-dialog modal-dialog-centered">' +
                        '<div class="modal-content">' +
                            '<div class="modal-header">' +
                                '<h5 class="modal-title"><i class="fas fa-exchange-alt me-2"></i>Update Food Status</h5>' +
                                '<button type="button" class="btn-close" data-bs-dismiss="modal"></button>' +
                            '</div>' +
                            '<div class="modal-body">' +
                                '<div class="alert alert-info">' +
                                    '<i class="fas fa-info-circle me-2"></i>' +
                                    'Current status: <span class="badge bg-info ms-2">' + currentStatus + '</span>' +
                                '</div>' +
                                '<p class="mb-3">Select new status:</p>' +
                                '<div class="d-grid gap-2">' +
                                    availableOptions.map(status => 
                                        '<button class="btn btn-outline-' + status.color + ' d-flex align-items-center justify-content-start" ' +
                                        'onclick="dashboard.updateFoodStatus(' + foodId + ', \'' + status.value + '\'); bootstrap.Modal.getInstance(document.getElementById(\'statusModal\')).hide();">' +
                                            '<i class="fas fa-' + status.icon + ' me-2"></i>' + status.label +
                                        '</button>'
                                    ).join('') +
                                '</div>' +
                            '</div>' +
                            '<div class="modal-footer">' +
                                '<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">' +
                                    '<i class="fas fa-times me-2"></i>Cancel' +
                                '</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';

                // Remove existing modal if any
                const existingModal = document.getElementById('statusModal');
                if (existingModal) {
                    existingModal.remove();
                }

                // Add new modal to body
                document.body.insertAdjacentHTML('beforeend', modalContent);

                // Show modal
                const modal = new bootstrap.Modal(document.getElementById('statusModal'));
                modal.show();
            }
            // Enhanced filter functionality
            setupListingsFilters() {
                const filters = ['statusFilter', 'expiryFilter', 'cityFilter', 'foodTypeFilter', 'sortFilter'];
                
                filters.forEach(filterId => {
                    const element = document.getElementById(filterId);
                    if (element) {
                        element.addEventListener('change', () => this.applyRealTimeFilters());
                    }
                });

                // Setup search input for real-time filtering
                const searchInput = document.getElementById('search-input');
                if (searchInput) {
                    searchInput.addEventListener('input', (e) => {
                        this.filterListingsBySearch(e.target.value);
                    });
                }
            }

            // Real-time filtering without page reload
            applyRealTimeFilters() {
                const statusFilter = document.getElementById('statusFilter')?.value || '';
                const cityFilter = document.getElementById('cityFilter')?.value || '';
                const foodTypeFilter = document.getElementById('foodTypeFilter')?.value || '';
                const sortFilter = document.getElementById('sortFilter')?.value || 'createdAt';

                const rows = document.querySelectorAll('.listing-row');
                let visibleCount = 0;

                rows.forEach(row => {
                    let show = true;
                    
                    // Status filter
                    if (statusFilter) {
                        const statusBadge = row.querySelector('.badge');
                        if (!statusBadge || !statusBadge.textContent.trim().includes(statusFilter)) {
                            show = false;
                        }
                    }

                    // City filter
                    if (cityFilter) {
                        const cityText = row.textContent.toLowerCase();
                        if (!cityText.includes(cityFilter.toLowerCase())) {
                            show = false;
                        }
                    }

                    // Food type filter
                    if (foodTypeFilter) {
                        const foodTypeText = row.textContent.toLowerCase();
                        if (!foodTypeText.includes(foodTypeFilter.toLowerCase())) {
                            show = false;
                        }
                    }

                    row.style.display = show ? '' : 'none';
                    if (show) visibleCount++;
                });

                // Update visible count
                this.updateFilterResults(visibleCount);
            }

            // Filter listings by search term
            filterListingsBySearch(searchTerm) {
                const rows = document.querySelectorAll('.listing-row');
                let visibleCount = 0;

                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    const matches = text.includes(searchTerm.toLowerCase());
                    row.style.display = matches ? '' : 'none';
                    if (matches) visibleCount++;
                });

                this.updateFilterResults(visibleCount);
            }

            // Update filter results count
            updateFilterResults(count) {
                let resultInfo = document.getElementById('filter-results');
                if (!resultInfo) {
                    resultInfo = document.createElement('div');
                    resultInfo.id = 'filter-results';
                    resultInfo.className = 'alert alert-info mt-2';
                    document.querySelector('.filter-section').appendChild(resultInfo);
                }
                resultInfo.innerHTML = '<i class="fas fa-info-circle me-2"></i>Showing ' + count + ' listing(s)';
            }

            // Enhanced status update with actual form submission
            updateFoodStatus(foodId, newStatus) {
                this.showNotification('Updating status to ' + newStatus + '...', 'info');
                
                // Create form for status update
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = 'updateFoodStatus.jsp';
                
                const foodIdInput = document.createElement('input');
                foodIdInput.type = 'hidden';
                foodIdInput.name = 'foodId';
                foodIdInput.value = foodId;
                
                const statusInput = document.createElement('input');
                statusInput.type = 'hidden';
                statusInput.name = 'status';
                statusInput.value = newStatus;
                
                form.appendChild(foodIdInput);
                form.appendChild(statusInput);
                document.body.appendChild(form);
                
                // Submit form
                form.submit();
            }

            // Get appropriate CSS class for status badge
            getStatusBadgeClass(status) {
                switch(status) {
                    case 'Available': return 'bg-success';
                    case 'Reserved': return 'bg-warning text-dark';
                    case 'Collected': return 'bg-info';
                    case 'Expired': return 'bg-danger';
                    case 'Inactive': return 'bg-secondary';
                    default: return 'bg-dark';
                }
            }

            // Enhanced setup for interactive elements
            setupInteractiveElements() {
                // Status update button handlers
                document.addEventListener('click', (e) => {
                    if (e.target.closest('.status-update-btn')) {
                        e.preventDefault();
                        const btn = e.target.closest('.status-update-btn');
                        const foodId = btn.getAttribute('data-food-id');
                        const currentStatus = btn.getAttribute('data-current-status');
                        this.showStatusModal(foodId, currentStatus);
                    }
                });

                // Edit buttons use native anchor navigation - no handler needed

                // View buttons use native anchor navigation - no handler needed

                // Row hover effects
                document.addEventListener('mouseover', (e) => {
                    if (e.target.closest('.listing-row')) {
                        e.target.closest('.listing-row').style.backgroundColor = '#f8f9fa';
                    }
                });

                document.addEventListener('mouseout', (e) => {
                    if (e.target.closest('.listing-row')) {
                        e.target.closest('.listing-row').style.backgroundColor = '';
                    }
                });

                // Setup tooltips for action buttons
                this.setupTooltips();
            }

            // Setup Bootstrap tooltips
            setupTooltips() {
                const tooltipTriggerList = [].slice.call(document.querySelectorAll('[title]'));
                tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }
        }

        // Notification functions for donors
        function viewFoodRequest(foodListingId) {
            window.location.href = 'viewFoodListing.jsp?id=' + foodListingId;
        }
        
        function markAsRead(notificationId) {
            fetch('markNotificationRead.jsp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'notificationId=' + notificationId
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('SUCCESS')) {
                    location.reload();
                } else {
                    alert('Error marking notification as read');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error marking notification as read');
            });
        }
        
        function markAllAsRead() {
            fetch('markAllNotificationsRead.jsp', {
                method: 'POST'
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('SUCCESS')) {
                    location.reload();
                } else {
                    alert('Error marking all notifications as read');
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Error marking all notifications as read');
            });
        }

        // Initialize dashboard when page loads
        let dashboard;
        document.addEventListener('DOMContentLoaded', () => {
            dashboard = new DonorDashboard();
            
            // Check for expired listings on page load
            dashboard.checkExpiredListings();
            
            // Show welcome popup for new login
            showWelcomePopup('donor', '<%= userName != null ? userName : "Donor" %>');
            
            // Show Food Listings Dashboard by default
            dashboard.showSection('my-listings');
            dashboard.updateActiveNavBySection('my-listings');
            
            // Setup interactive elements immediately
            dashboard.setupInteractiveElements();
            
            // Setup listings filters
            setTimeout(() => {
                if (document.getElementById('statusFilter')) {
                    dashboard.setupListingsFilters();
                }
            }, 100);
        });

        // Add smooth scrolling for anchor links
        document.addEventListener('click', (e) => {
            if (e.target.matches('a[href^="#"]')) {
                e.preventDefault();
                const target = e.target.getAttribute('href').substring(1);
                dashboard.showSection(target);
            }
        });
    </script>
</body>
</html>