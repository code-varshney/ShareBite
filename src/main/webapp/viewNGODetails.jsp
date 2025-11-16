<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="com.net.bean.NGODetailsBean" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="com.net.DAO.NGODetailsDAO" %>
<%
String ngoIdStr = request.getParameter("ngoId");
if (ngoIdStr == null) {
    response.sendRedirect("donorDashboard.jsp");
    return;
}

int ngoId = Integer.parseInt(ngoIdStr);
UserBean ngo = UserDAO.getUserById(ngoId);
NGODetailsBean ngoDetails = NGODetailsDAO.getNGODetailsByUserId(ngoId);

if (ngo == null) {
    response.sendRedirect("donorDashboard.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>NGO Details - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { 
            background: linear-gradient(-45deg, #28a745, #20c997, #17a2b8, #007bff);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            min-height: 100vh;
            font-family: 'Poppins', sans-serif;
        }
        @keyframes gradientShift {
            0% { background-position: 0% 50%; }
            50% { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }
        .details-container {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 25px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            margin: 2rem auto;
            padding: 2rem;
            max-width: 800px;
        }
        .profile-header {
            text-align: center;
            margin-bottom: 2rem;
            color: white;
        }
        .profile-icon {
            font-size: 4rem;
            margin-bottom: 1rem;
            color: rgba(255, 255, 255, 0.9);
        }
        .detail-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            color: white;
        }
        .btn-back {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 15px;
            padding: 0.8rem 2rem;
            transition: all 0.3s ease;
        }
        .btn-back:hover {
            background: rgba(255, 255, 255, 0.3);
            color: white;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="details-container">
            <div class="profile-header">
                <div class="profile-icon">
                    <i class="fas fa-hands-helping"></i>
                </div>
                <h2><%= ngo.getOrganizationName() != null ? ngo.getOrganizationName() : ngo.getName() %></h2>
                <p class="mb-0">NGO Details</p>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="detail-card">
                        <h5><i class="fas fa-user me-2"></i>Contact Person</h5>
                        <p class="mb-0"><%= ngo.getName() %></p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="detail-card">
                        <h5><i class="fas fa-envelope me-2"></i>Email</h5>
                        <p class="mb-0"><%= ngo.getEmail() %></p>
                    </div>
                </div>
            </div>

            <div class="row">
                <div class="col-md-6">
                    <div class="detail-card">
                        <h5><i class="fas fa-phone me-2"></i>Phone</h5>
                        <p class="mb-0"><%= ngo.getPhone() != null ? ngo.getPhone() : "Not provided" %></p>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="detail-card">
                        <h5><i class="fas fa-check-circle me-2"></i>Verification Status</h5>
                        <span class="badge <%= "verified".equals(ngo.getVerificationStatus()) ? "bg-success" : "bg-warning" %>">
                            <%= ngo.getVerificationStatus() != null ? ngo.getVerificationStatus().toUpperCase() : "PENDING" %>
                        </span>
                    </div>
                </div>
            </div>

            <div class="detail-card">
                <h5><i class="fas fa-map-marker-alt me-2"></i>Address</h5>
                <p class="mb-0"><%= ngo.getFullAddress() != null ? ngo.getFullAddress() : "Not provided" %></p>
            </div>

            <% if (ngoDetails != null) { %>
                <% if (ngoDetails.getRegistrationNumber() != null && !ngoDetails.getRegistrationNumber().isEmpty()) { %>
                    <div class="detail-card">
                        <h5><i class="fas fa-id-card me-2"></i>Registration Number</h5>
                        <p class="mb-0"><%= ngoDetails.getRegistrationNumber() %></p>
                    </div>
                <% } %>
                
                <% if (ngoDetails.getMission() != null && !ngoDetails.getMission().isEmpty()) { %>
                    <div class="detail-card">
                        <h5><i class="fas fa-bullseye me-2"></i>Mission</h5>
                        <p class="mb-0"><%= ngoDetails.getMission() %></p>
                    </div>
                <% } %>
                
                <% if (ngoDetails.getWebsite() != null && !ngoDetails.getWebsite().isEmpty()) { %>
                    <div class="detail-card">
                        <h5><i class="fas fa-globe me-2"></i>Website</h5>
                        <p class="mb-0"><a href="<%= ngoDetails.getWebsite() %>" target="_blank" style="color: rgba(255,255,255,0.9);"><%= ngoDetails.getWebsite() %></a></p>
                    </div>
                <% } %>
                
                <% if (ngoDetails.getServiceArea() != null && !ngoDetails.getServiceArea().isEmpty()) { %>
                    <div class="detail-card">
                        <h5><i class="fas fa-map me-2"></i>Service Area</h5>
                        <p class="mb-0"><%= ngoDetails.getServiceArea() %></p>
                    </div>
                <% } %>
            <% } %>

            <div class="text-center mt-4">
                <button onclick="history.back()" class="btn btn-back">
                    <i class="fas fa-arrow-left me-2"></i>Back
                </button>
            </div>
        </div>
    </div>
</body>
</html>