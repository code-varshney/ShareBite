<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.bean.NGODetailsBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.NGODetailsDAO" %>
<%@ page import="com.net.DAO.NotificationDAO" %>
<%@ page import="com.net.bean.NotificationBean" %>
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

// Get NGO coordinates for range-based filtering
double ngoLatitude = 0.0;
double ngoLongitude = 0.0;
try {
    java.sql.Connection con = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
    java.sql.PreparedStatement ps = con.prepareStatement("SELECT latitude, longitude FROM users WHERE id=?");
    ps.setInt(1, ngoId);
    java.sql.ResultSet rs = ps.executeQuery();
    if (rs.next()) {
        ngoLatitude = rs.getDouble("latitude");
        ngoLongitude = rs.getDouble("longitude");
    }
    rs.close();
    ps.close();
    con.close();
} catch (Exception e) { e.printStackTrace(); }

// Get available food listings within 5km range
List<FoodListingBean> availableFood;
if (ngoLatitude != 0.0 && ngoLongitude != 0.0) {
    availableFood = FoodListingDAO.getFoodListingsWithinRange(ngoLatitude, ngoLongitude, 5.0);
} else {
    availableFood = FoodListingDAO.getAllFoodListings();
}

// Get NGO's food requests
List<FoodRequestBean> ngoRequests = FoodRequestDAO.getFoodRequestsByNgo(ngoId);

// Fetch NGO details bean
NGODetailsBean ngoDetails = NGODetailsDAO.getNGODetailsByUserId(ngoId);

// Get notifications for this NGO
List<NotificationBean> notifications = NotificationDAO.getNotificationsByNGO(ngoId);
int unreadCount = NotificationDAO.getUnreadCount(ngoId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>NGO Dashboard - Sharebite</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/sharebite-theme.css">
    <link rel="stylesheet" href="css/welcomePopup.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: var(--gradient-ngo);
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
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        
        .navbar-nav .nav-link {
            color: white !important;
        }
        
        .navbar-text {
            color: white !important;
        }
        
        .navbar-brand {
            font-weight: 700;
            font-size: 1.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }
        
        .sidebar {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            min-height: calc(100vh - 76px);
            box-shadow: 4px 0 30px rgba(0, 0, 0, 0.1);
            padding: 0;
            border-radius: 0 20px 20px 0;
            border-right: 1px solid rgba(0, 123, 255, 0.1);
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
            background: linear-gradient(90deg, transparent, rgba(0, 123, 255, 0.1), transparent);
            transition: left 0.5s;
        }
        
        .sidebar .nav-link:hover::before {
            left: 100%;
        }
        
        .sidebar .nav-link:hover,
        .sidebar .nav-link.active {
            background: linear-gradient(135deg, #007bff, #6610f2);
            color: white;
            transform: translateX(5px) scale(1.02);
            box-shadow: 0 8px 25px rgba(0, 123, 255, 0.3);
        }
        
        .sidebar .nav-link i {
            width: 20px;
            margin-right: 10px;
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
        
        .welcome-section {
            background: linear-gradient(135deg, #007bff 0%, #6610f2 50%, #17a2b8 100%);
            color: white;
            padding: 3rem;
            border-radius: 25px;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 15px 40px rgba(0, 123, 255, 0.3);
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
            animation: shimmer 4s infinite;
        }
        
        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
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
        }
        
        .stats-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 2rem;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0, 123, 255, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            border: 1px solid rgba(0, 123, 255, 0.1);
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
            background: linear-gradient(45deg, transparent, rgba(0, 123, 255, 0.05), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .stats-card:hover {
            transform: translateY(-10px) scale(1.05);
            box-shadow: 0 20px 50px rgba(0, 123, 255, 0.3);
        }
        
        .stats-card:hover::before {
            opacity: 1;
        }
        
        .stats-number {
            font-size: 3rem;
            font-weight: 800;
            background: linear-gradient(135deg, #007bff, #6610f2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
            margin-bottom: 0.5rem;
            text-shadow: 0 4px 8px rgba(0, 123, 255, 0.2);
        }
        
        .food-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(0, 123, 255, 0.1);
            border-left: 4px solid #007bff;
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
            background: linear-gradient(45deg, transparent, rgba(0, 123, 255, 0.05), transparent);
            opacity: 0;
            transition: opacity 0.3s ease;
        }
        
        .food-card:hover {
            transform: translateY(-10px) scale(1.02);
            box-shadow: 0 20px 50px rgba(0, 123, 255, 0.2);
            border-left-color: #6610f2;
        }
        
        .food-card:hover::before {
            opacity: 1;
        }
        
        .request-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.1);
            border: 1px solid rgba(40, 167, 69, 0.1);
            border-left: 4px solid #28a745;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .request-card:hover {
            transform: translateY(-5px) scale(1.01);
            box-shadow: 0 15px 40px rgba(40, 167, 69, 0.2);
        }
        
        .btn-request, .btn-primary {
            background: linear-gradient(135deg, #007bff, #6610f2);
            border: none;
            border-radius: 15px;
            padding: 0.8rem 2rem;
            color: white;
            font-weight: 600;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
        }
        
        .btn-request::before, .btn-primary::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
            transition: left 0.5s;
        }
        
        .btn-request:hover::before, .btn-primary:hover::before {
            left: 100%;
        }
        
        .btn-request:hover, .btn-primary:hover {
            background: linear-gradient(135deg, #6610f2, #17a2b8);
            transform: translateY(-3px) scale(1.05);
            box-shadow: 0 10px 30px rgba(0, 123, 255, 0.4);
            color: white;
        }
        
        .status-badge, .badge {
            padding: 0.5rem 1rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .status-pending { 
            background: linear-gradient(135deg, #ffc107, #fd7e14);
            color: #000;
            box-shadow: 0 4px 15px rgba(255, 193, 7, 0.3);
        }
        .status-approved { 
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        .status-rejected { 
            background: linear-gradient(135deg, #dc3545, #c82333);
            color: white;
            box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
        }
        .status-completed { 
            background: linear-gradient(135deg, #007bff, #6610f2);
            color: white;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }
        
        .bg-success {
            background: linear-gradient(135deg, #28a745, #20c997) !important;
            box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
        }
        
        .bg-info {
            background: linear-gradient(135deg, #17a2b8, #138496) !important;
            box-shadow: 0 4px 15px rgba(23, 162, 184, 0.3);
        }
        
        .bg-primary {
            background: linear-gradient(135deg, #007bff, #6610f2) !important;
            box-shadow: 0 4px 15px rgba(0, 123, 255, 0.3);
        }
        
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
            background: linear-gradient(135deg, #007bff, #6610f2);
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
        
        .form-control, .form-select {
            border-radius: 12px;
            border: 2px solid rgba(0, 123, 255, 0.2);
            padding: 0.8rem 1rem;
            transition: all 0.3s ease;
            background: rgba(255, 255, 255, 0.9);
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #007bff;
            box-shadow: 0 0 0 0.3rem rgba(0, 123, 255, 0.15);
            background: white;
            transform: translateY(-2px);
        }
        
        .form-label {
            font-weight: 600;
            color: #495057;
            margin-bottom: 0.8rem;
        }
        
        .table {
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
        }
        
        .table th {
            background: linear-gradient(135deg, #007bff, #6610f2);
            color: white;
            font-weight: 700;
            border: none;
            padding: 1.5rem;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            font-size: 0.95rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        .table td {
            padding: 1.2rem;
            border-color: rgba(0, 123, 255, 0.1);
            vertical-align: middle;
            background: rgba(255, 255, 255, 0.8);
        }
        
        .table tbody tr {
            transition: all 0.4s ease;
        }
        
        .table tbody tr:hover {
            background: rgba(0, 123, 255, 0.08);
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
        }
        
        .table tbody tr:hover td {
            background: rgba(0, 123, 255, 0.05);
        }
        
        .alert {
            border-radius: 15px;
            border: none;
            backdrop-filter: blur(15px);
            animation: slideDown 0.6s ease-out;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        }
        
        .alert-success {
            background: linear-gradient(135deg, rgba(40, 167, 69, 0.9), rgba(32, 201, 151, 0.9));
            color: white;
        }
        
        .alert-info {
            background: linear-gradient(135deg, rgba(23, 162, 184, 0.9), rgba(19, 132, 150, 0.9));
            color: white;
        }
        
        .alert-warning {
            background: linear-gradient(135deg, rgba(255, 193, 7, 0.9), rgba(253, 126, 20, 0.9));
            color: #000;
        }
        
        .alert-danger {
            background: linear-gradient(135deg, rgba(220, 53, 69, 0.9), rgba(200, 35, 51, 0.9));
            color: white;
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-30px) scale(0.9); }
            to { opacity: 1; transform: translateY(0) scale(1); }
        }
        
        /* Enhanced Interactive Elements */
        .interactive-card {
            cursor: pointer;
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        
        .interactive-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 15px 40px rgba(0, 123, 255, 0.2);
        }
        
        .pulse-animation {
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        
        .loading-spinner {
            display: inline-block;
            width: 20px;
            height: 20px;
            border: 3px solid rgba(0, 123, 255, 0.3);
            border-top: 3px solid #007bff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        .notification-toast {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 9999;
            min-width: 350px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
            border-radius: 15px;
            overflow: hidden;
            backdrop-filter: blur(20px);
            animation: slideInRight 0.5s ease-out;
        }
        
        @keyframes slideInRight {
            from { opacity: 0; transform: translateX(100%); }
            to { opacity: 1; transform: translateX(0); }
        }
        
        /* Responsive Enhancements */
        @media (max-width: 768px) {
            .welcome-section h2 {
                font-size: 2rem;
            }
            
            .stats-number {
                font-size: 2.5rem;
            }
            
            .main-content {
                padding: 1.5rem;
                margin: 1rem;
            }
            
            .sidebar {
                border-radius: 0;
            }
            
            .food-card, .request-card {
                padding: 1.5rem;
            }
        }
        
        @media (max-width: 576px) {
            .welcome-section {
                padding: 2rem 1.5rem;
            }
            
            .stats-card {
                padding: 1.5rem;
            }
            
            .modal-content {
                margin: 1rem;
            }
        }
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
                <a class="nav-link position-relative me-3" href="#" data-bs-toggle="modal" data-bs-target="#notificationsModal">
                    <i class="fas fa-bell"></i>
                    <% if (unreadCount > 0) { %>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                            <%= unreadCount %>
                        </span>
                    <% } %>
                </a>
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
                        <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#profileModal">
                            <i class="fas fa-user-cog"></i>Profile
                        </a>
                    </nav>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <!-- Dashboard Section -->
                <div id="dashboard" class="main-content">
                    <!-- Success/Error Messages -->
                    <% 
                    String successMsg = request.getParameter("success");
                    String errorMsg = request.getParameter("error");
                    if (successMsg != null) {
                    %>
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            <% if ("request_submitted".equals(successMsg)) { %>
                                Food request submitted successfully! The donor will be notified.
                            <% } %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } %>
                    <% if (errorMsg != null) { %>
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            <% if ("missing_fields".equals(errorMsg)) { %>
                                Please fill in all required fields.
                            <% } else if ("food_not_found".equals(errorMsg)) { %>
                                Food listing not found.
                            <% } else if ("request_failed".equals(errorMsg)) { %>
                                Failed to submit request. Please try again.
                            <% } else { %>
                                An error occurred. Please try again.
                            <% } %>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    <% } %>
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
                                                    <i class="fas fa-weight me-1"></i><%= String.format("%.1f", food.getQuantity()) %> <%= food.getQuantityUnit() %>
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

                    <!-- Available Food Listings Table -->
                    <h2 class="mt-4 mb-3">Available Food Listings</h2>
                    <table class="table table-bordered table-striped">
                        <thead class="table-dark">
                            <tr>
                                <th>Food Name</th>
                                <th>Type</th>
                                <th>Quantity</th>
                                <th>Expiry Date</th>
                                <th>Pickup Address</th>
                                <th>Description</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% if (availableFood != null && !availableFood.isEmpty()) {
                                for (FoodListingBean food : availableFood) { %>
                                    <tr>
                                        <td><%= food.getFoodName() %></td>
                                        <td><%= food.getFoodType() %></td>
                                        <td><%= String.format("%.1f", food.getQuantity()) %> <%= food.getQuantityUnit() %></td>
                                        <td><%= food.getExpiryDate() %></td>
                                        <td><%= food.getPickupAddress() %>, <%= food.getPickupCity() %>, <%= food.getPickupState() %>, <%= food.getPickupZipCode() %></td>
                                        <td><%= food.getDescription() %></td>
                                    </tr>
                            <%   }
                               } else { %>
                                <tr><td colspan="6" class="text-center">No food listings available at the moment.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
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
                                                        <i class="fas fa-weight me-1"></i><%= String.format("%.1f", food.getQuantity()) %> <%= food.getQuantityUnit() %>
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
                                        <h5><%= request1.getFoodName() != null ? request1.getFoodName() : "Food Request" %> #<%= request1.getId() %></h5>
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
                                        <% if ("approved".equals(request1.getStatus()) || "completed".equals(request1.getStatus())) { %>
                                            <a href="viewDonorDetails.jsp?donorId=<%= request1.getDonorId() %>" class="btn btn-outline-info btn-sm mb-2">
                                                <i class="fas fa-info-circle me-1"></i>Donor Details
                                            </a>
                                        <% } %>
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
                            <label for="requestedQuantity" class="form-label">Requested Quantity *</label>
                            <input type="number" class="form-control" id="requestedQuantity" name="requestedQuantity" min="1" step="0.1" required>
                            <div class="invalid-feedback">Please specify the quantity you need.</div>
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



    <!-- Notifications Modal -->
    <div class="modal fade" id="notificationsModal" tabindex="-1" aria-labelledby="notificationsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title" id="notificationsModalLabel">
                        <i class="fas fa-bell me-2"></i>Notifications
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" style="max-height: 500px; overflow-y: auto;">
                    <% if (notifications != null && !notifications.isEmpty()) { %>
                        <% for (NotificationBean notification : notifications) { %>
                            <div class="card mb-3 <%= !notification.isRead() ? "border-primary" : "" %>">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div class="flex-grow-1">
                                            <h6 class="card-title mb-2">
                                                <i class="fas fa-utensils text-success me-2"></i>
                                                <%= notification.getFoodName() != null ? notification.getFoodName() : "New Food Available" %>
                                                <% if (!notification.isRead()) { %>
                                                    <span class="badge bg-primary ms-2">New</span>
                                                <% } %>
                                            </h6>
                                            <p class="card-text mb-2">
                                                <strong>Donor:</strong> <%= notification.getDonorName() != null ? notification.getDonorName() : "Unknown" %><br>
                                                <strong>Message:</strong> <%= notification.getMessage() %>
                                            </p>
                                            <small class="text-muted">
                                                <i class="fas fa-clock me-1"></i>
                                                <%= notification.getCreatedAt() %>
                                            </small>
                                        </div>
                                        <div class="ms-3">
                                            <% if (notification.getFoodListingId() > 0) { %>
                                                <button class="btn btn-sm btn-outline-primary" onclick="viewFoodDetails(<%= notification.getFoodListingId() %>)">
                                                    <i class="fas fa-eye me-1"></i>View Details
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
                            <p class="text-muted">You'll receive notifications when donors add new food listings.</p>
                        </div>
                    <% } %>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <% if (unreadCount > 0) { %>
                        <button type="button" class="btn btn-primary" onclick="markAllAsRead()">Mark All as Read</button>
                    <% } %>
                </div>
            </div>
        </div>
    </div>

    <!-- Profile Modal -->
    <div class="modal fade" id="profileModal" tabindex="-1" aria-labelledby="profileModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="profileModalLabel">
                        <i class="fas fa-user-circle me-2"></i>Organization Profile
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- View Mode -->
                    <div id="profileView">
                        <div class="row">
                            <div class="col-md-4 text-center mb-4">
                                <i class="fas fa-users fa-5x text-primary mb-3"></i>
                                <h5 id="displayOrgName"><%= organizationName != null ? organizationName : userName %></h5>
                                <p class="text-muted">NGO Organization</p>
                                <span class="badge bg-primary">NGO</span>
                            </div>
                            <div class="col-md-8">
                                <h6 class="text-primary mb-3">Organization Information</h6>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Organization:</strong></div>
                                    <div class="col-sm-8" id="viewOrgName"><%= organizationName != null ? organizationName : "N/A" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Registration #:</strong></div>
                                    <div class="col-sm-8" id="viewRegNumber"><%= ngoDetails != null && ngoDetails.getRegistrationNumber() != null ? ngoDetails.getRegistrationNumber() : "Not provided" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Mission:</strong></div>
                                    <div class="col-sm-8" id="viewMission"><%= ngoDetails != null && ngoDetails.getMission() != null ? ngoDetails.getMission() : "Not provided" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Contact Person:</strong></div>
                                    <div class="col-sm-8" id="viewContactPerson"><%= ngoDetails != null && ngoDetails.getContactPerson() != null ? ngoDetails.getContactPerson() : "Not provided" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Contact Title:</strong></div>
                                    <div class="col-sm-8" id="viewContactTitle"><%= ngoDetails != null && ngoDetails.getContactTitle() != null ? ngoDetails.getContactTitle() : "Not provided" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Email:</strong></div>
                                    <div class="col-sm-8" id="viewEmail">Not provided</div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Phone:</strong></div>
                                    <div class="col-sm-8" id="viewPhone">Not provided</div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Address:</strong></div>
                                    <div class="col-sm-8" id="viewAddress">Not provided</div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Website:</strong></div>
                                    <div class="col-sm-8" id="viewWebsite"><%= ngoDetails != null && ngoDetails.getWebsite() != null ? ngoDetails.getWebsite() : "Not provided" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Service Area:</strong></div>
                                    <div class="col-sm-8" id="viewServiceArea"><%= ngoDetails != null && ngoDetails.getServiceArea() != null ? ngoDetails.getServiceArea() : "Not provided" %></div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Organization Type:</strong></div>
                                    <div class="col-sm-8" id="viewOrgType">Not provided</div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-sm-4"><strong>Verification Status:</strong></div>
                                    <div class="col-sm-8" id="viewVerificationStatus">Not provided</div>
                                </div>
                                <hr>
                                <h6 class="text-primary mb-3">Statistics</h6>
                                <div class="row">
                                    <div class="col-6 text-center">
                                        <h4 class="text-primary"><%= ngoRequests != null ? ngoRequests.size() : 0 %></h4>
                                        <small class="text-muted">Total Requests</small>
                                    </div>
                                    <div class="col-6 text-center">
                                        <h4 class="text-primary"><%= ngoRequests != null ? ngoRequests.stream().filter(r -> "approved".equals(r.getStatus())).count() : 0 %></h4>
                                        <small class="text-muted">Approved Requests</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Edit Mode -->
                    <div id="profileEdit" style="display: none;">
                        <form id="profileForm" class="needs-validation" novalidate>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Organization Name <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" name="organizationName" id="editOrgName" required>
                                    <div class="invalid-feedback">Please provide organization name.</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Registration Number</label>
                                    <input type="text" class="form-control" name="registrationNumber" id="editRegNumber">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Mission Statement</label>
                                <textarea class="form-control" name="mission" id="editMission" rows="3"></textarea>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Contact Person</label>
                                    <input type="text" class="form-control" name="contactPerson" id="editContactPerson">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Contact Title</label>
                                    <input type="text" class="form-control" name="contactTitle" id="editContactTitle">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Email <span class="text-danger">*</span></label>
                                    <input type="email" class="form-control" name="email" id="editEmail" required>
                                    <div class="invalid-feedback">Please provide a valid email address.</div>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Phone</label>
                                    <input type="tel" class="form-control" name="phone" id="editPhone">
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Website</label>
                                    <input type="url" class="form-control" name="website" id="editWebsite">
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Service Area</label>
                                    <input type="text" class="form-control" name="serviceArea" id="editServiceArea">
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Address</label>
                                <textarea class="form-control" name="address" id="editAddress" rows="2"></textarea>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Organization Type</label>
                                    <select class="form-select" name="organizationType" id="editOrgType">
                                        <option value="">Select Type</option>
                                        <option value="Charity">Charity</option>
                                        <option value="Non-Profit">Non-Profit</option>
                                        <option value="Religious">Religious Organization</option>
                                        <option value="Community">Community Group</option>
                                        <option value="Government">Government Agency</option>
                                        <option value="Other">Other</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Verification Status</label>
                                    <input type="text" class="form-control" name="verificationStatus" id="editVerificationStatus" readonly>
                                    <small class="text-muted">Contact admin to change verification status</small>
                                </div>
                            </div>
                        </form>
                    </div>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/welcomePopup.js"></script>
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
            if (!form.checkValidity()) {
                form.classList.add('was-validated');
                return;
            }
            
            // Hide modal first
            const modal = bootstrap.Modal.getInstance(document.getElementById('requestModal'));
            modal.hide();
            
            // Create a hidden form and submit it traditionally
            const hiddenForm = document.createElement('form');
            hiddenForm.method = 'POST';
            hiddenForm.action = 'submitFoodRequestSimple.jsp';
            hiddenForm.style.display = 'none';
            
            // Copy form data to hidden form
            const formData = new FormData(form);
            for (let [key, value] of formData.entries()) {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = key;
                input.value = value;
                hiddenForm.appendChild(input);
            }
            
            // Add to document and submit
            document.body.appendChild(hiddenForm);
            hiddenForm.submit();
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
            // Check for expired listings on page load
            checkExpiredListings();
            
            // Show welcome popup for new login
            showWelcomePopup('ngo', '<%= organizationName != null ? organizationName : (userName != null ? userName : "NGO") %>');
            
            const today = new Date().toISOString().split('T')[0];
            document.getElementById('pickupDate').min = today;
            
            // Load profile data when modal is opened
            const profileModal = document.getElementById('profileModal');
            if (profileModal) {
                profileModal.addEventListener('show.bs.modal', function() {
                    loadProfileData();
                });
            }
            
            // Auto-refresh food listings every 30 seconds
            setInterval(function() {
                location.reload();
            }, 30000);
        });
        
        function checkExpiredListings() {
            fetch('updateExpiredListings.jsp', {
                method: 'GET'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success && data.updatedCount > 0) {
                    console.log(`${data.updatedCount} expired listing(s) updated`);
                    // Optionally refresh the page to show updated listings
                    setTimeout(() => {
                        location.reload();
                    }, 1000);
                }
            })
            .catch(error => {
                console.error('Error checking expired listings:', error);
            });
        }
        
        // Profile management functions
        function loadProfileData() {
            fetch('getNGOProfileData.jsp')
                .then(response => response.json())
                .then(data => {
                    console.log('Profile data received:', data);
                    if (data.status === 'SUCCESS') {
                        // Update view mode
                        document.getElementById('viewOrgName').textContent = data.organizationName || 'Not provided';
                        document.getElementById('displayOrgName').textContent = data.organizationName || 'NGO';
                        document.getElementById('viewRegNumber').textContent = data.registrationNumber || 'Not provided';
                        document.getElementById('viewMission').textContent = data.mission || 'Not provided';
                        document.getElementById('viewContactPerson').textContent = data.contactPerson || 'Not provided';
                        document.getElementById('viewContactTitle').textContent = data.contactTitle || 'Not provided';
                        document.getElementById('viewEmail').textContent = data.email || 'Not provided';
                        document.getElementById('viewPhone').textContent = data.phone || 'Not provided';
                        document.getElementById('viewAddress').textContent = data.address || 'Not provided';
                        document.getElementById('viewWebsite').textContent = data.website || 'Not provided';
                        document.getElementById('viewServiceArea').textContent = data.serviceArea || 'Not provided';
                        document.getElementById('viewOrgType').textContent = data.organizationType || 'Not provided';
                        document.getElementById('viewVerificationStatus').textContent = data.verificationStatus || 'Not provided';
                        
                        // Update edit mode
                        document.getElementById('editOrgName').value = data.organizationName || '';
                        document.getElementById('editRegNumber').value = data.registrationNumber || '';
                        document.getElementById('editMission').value = data.mission || '';
                        document.getElementById('editContactPerson').value = data.contactPerson || '';
                        document.getElementById('editContactTitle').value = data.contactTitle || '';
                        document.getElementById('editEmail').value = data.email || '';
                        document.getElementById('editPhone').value = data.phone || '';
                        document.getElementById('editWebsite').value = data.website || '';
                        document.getElementById('editServiceArea').value = data.serviceArea || '';
                        document.getElementById('editAddress').value = data.address || '';
                        document.getElementById('editOrgType').value = data.organizationType || '';
                        document.getElementById('editVerificationStatus').value = data.verificationStatus || '';
                    }
                })
                .catch(error => console.error('Error loading profile:', error));
        }
        
        function toggleEditMode() {
            const viewMode = document.getElementById('profileView');
            const editMode = document.getElementById('profileEdit');
            const viewButtons = document.getElementById('viewButtons');
            const editButtons = document.getElementById('editButtons');
            
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
            
            fetch('updateNGOProfile.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 'SUCCESS') {
                    alert('Profile updated successfully!');
                    toggleEditMode();
                    loadProfileData();
                    
                    // Update session organization name if changed
                    if (data.organizationName) {
                        location.reload();
                    }
                } else {
                    alert('Error updating profile: ' + data.message);
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
        
        // Notification functions
        function viewFoodDetails(foodListingId) {
            const notificationsModal = bootstrap.Modal.getInstance(document.getElementById('notificationsModal'));
            if (notificationsModal) {
                notificationsModal.hide();
            }
            
            fetch('getFoodDetails.jsp?id=' + foodListingId)
                .then(response => response.json())
                .then(data => {
                    if (data.status === 'SUCCESS') {
                        showFoodDetailsModal(data);
                    } else {
                        alert('Error loading food details');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error loading food details');
                });
        }
        
        function showFoodDetailsModal(foodData) {
            const modalContent = `
                <div class="modal fade" id="foodDetailsModal" tabindex="-1">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <div class="modal-header bg-success text-white">
                                <h5 class="modal-title">
                                    <i class="fas fa-utensils me-2"></i>${foodData.foodName}
                                </h5>
                                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="row">
                                    <div class="col-md-6">
                                        <h6 class="text-success mb-3">Food Information</h6>
                                        <p><strong>Food Name:</strong> ${foodData.foodName}</p>
                                        <p><strong>Type:</strong> ${foodData.foodType}</p>
                                        <p><strong>Quantity:</strong> ${foodData.quantity} ${foodData.quantityUnit}</p>
                                        <p><strong>Expiry Date:</strong> ${foodData.expiryDate}</p>
                                        <p><strong>Description:</strong> ${foodData.description || 'Not provided'}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <h6 class="text-success mb-3">Donor & Pickup Details</h6>
                                        <p><strong>Donor:</strong> ${foodData.donorName}</p>
                                        <p><strong>Pickup Address:</strong> ${foodData.pickupAddress}</p>
                                        <p><strong>City:</strong> ${foodData.pickupCity}, ${foodData.pickupState}</p>
                                        <p><strong>ZIP Code:</strong> ${foodData.pickupZipCode}</p>
                                        <p><strong>Instructions:</strong> ${foodData.pickupInstructions || 'None'}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-success" onclick="requestFood(${foodData.id})">
                                    <i class="fas fa-hand-holding-heart me-2"></i>Request This Food
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            `;
            
            const existingModal = document.getElementById('foodDetailsModal');
            if (existingModal) {
                existingModal.remove();
            }
            
            document.body.insertAdjacentHTML('beforeend', modalContent);
            const modal = new bootstrap.Modal(document.getElementById('foodDetailsModal'));
            modal.show();
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
    </script>
</body>
</html>