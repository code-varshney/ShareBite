<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
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
List<FoodRequestBean> myRequests = FoodRequestDAO.getFoodRequestsForDonor(donorId);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>NGO Requests - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(-45deg, #e8f5e8, #f0f8f0, #e6f7e6, #f5fbf5);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .main-container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .header-card {
            background: linear-gradient(135deg, #28a745, #20c997);
            color: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            text-align: center;
        }
        
        .request-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        
        .request-card:hover {
            transform: translateY(-5px);
        }
        
        .request-header {
            background: #f8f9fa;
            padding: 1.5rem;
            border-bottom: 1px solid #dee2e6;
        }
        
        .request-body {
            padding: 1.5rem;
        }
        
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.8rem;
        }
        
        .status-pending { background: #ffc107; color: #000; }
        .status-approved { background: #28a745; color: white; }
        .status-rejected { background: #dc3545; color: white; }
        .status-completed { background: #17a2b8; color: white; }
        
        .btn-action {
            padding: 0.5rem 1rem;
            border-radius: 8px;
            margin: 0.2rem;
            transition: all 0.3s ease;
        }
        
        .btn-accept {
            background: #28a745;
            border: none;
            color: white;
        }
        
        .btn-reject {
            background: #dc3545;
            border: none;
            color: white;
        }
        
        .btn-complete {
            background: #17a2b8;
            border: none;
            color: white;
        }
        
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 3px 10px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="header-card">
            <h2><i class="fas fa-handshake me-2"></i>NGO Food Requests</h2>
            <p class="mb-0">Manage requests from NGOs for your food donations</p>
        </div>
        
        <div class="mb-3">
            <a href="donorDashboard.jsp" class="btn btn-outline-success">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
        
        <% if (myRequests != null && !myRequests.isEmpty()) { %>
            <% for (FoodRequestBean ngoRequest : myRequests) { %>
                <div class="request-card">
                    <div class="request-header">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h5 class="mb-1">
                                    <i class="fas fa-building me-2 text-primary"></i>
                                    <%= ngoRequest.getNgoName() != null ? ngoRequest.getNgoName() : "NGO Request" %>
                                </h5>
                                <small class="text-muted">Request ID: #<%= ngoRequest.getId() %></small>
                            </div>
                            <div class="col-md-4 text-end">
                                <span class="status-badge status-<%= ngoRequest.getStatus() %>">
                                    <%= ngoRequest.getStatus().toUpperCase() %>
                                </span>
                            </div>
                        </div>
                    </div>
                    
                    <div class="request-body">
                        <div class="row">
                            <div class="col-md-8">
                                <p class="mb-2">
                                    <strong><i class="fas fa-utensils me-1 text-success"></i>Food Item:</strong> 
                                    <%= ngoRequest.getFoodName() != null ? ngoRequest.getFoodName() : "Food Listing #" + ngoRequest.getFoodListingId() %>
                                </p>
                                <p class="mb-2">
                                    <strong><i class="fas fa-calendar me-1 text-info"></i>Requested Pickup:</strong> 
                                    <%= ngoRequest.getPickupDate() %>
                                    <% if (ngoRequest.getPickupTime() != null && !ngoRequest.getPickupTime().isEmpty()) { %>
                                        at <%= ngoRequest.getPickupTime() %>
                                    <% } %>
                                </p>
                                <% if (ngoRequest.getRequestMessage() != null && !ngoRequest.getRequestMessage().isEmpty()) { %>
                                    <p class="mb-2">
                                        <strong><i class="fas fa-comment me-1 text-warning"></i>Message:</strong> 
                                        <%= ngoRequest.getRequestMessage() %>
                                    </p>
                                <% } %>
                                <small class="text-muted">
                                    <i class="fas fa-clock me-1"></i>Requested: <%= ngoRequest.getCreatedAt() %>
                                </small>
                            </div>
                            
                            <div class="col-md-4">
                                <div class="d-grid gap-2">
                                    <a href="viewNGORequest.jsp?requestId=<%= ngoRequest.getId() %>" class="btn btn-outline-primary btn-action">
                                        <i class="fas fa-eye me-1"></i>View Details
                                    </a>
                                    
                                    <% if ("pending".equals(ngoRequest.getStatus())) { %>
                                        <button class="btn btn-accept btn-action" onclick="updateRequestStatus(<%= ngoRequest.getId() %>, 'approved')">
                                            <i class="fas fa-check me-1"></i>Accept
                                        </button>
                                        <button class="btn btn-reject btn-action" onclick="updateRequestStatus(<%= ngoRequest.getId() %>, 'rejected')">
                                            <i class="fas fa-times me-1"></i>Reject
                                        </button>
                                    <% } else if ("approved".equals(ngoRequest.getStatus())) { %>
                                        <button class="btn btn-complete btn-action" onclick="updateRequestStatus(<%= ngoRequest.getId() %>, 'completed')">
                                            <i class="fas fa-check-double me-1"></i>Mark Complete
                                        </button>
                                    <% } else { %>
                                        <span class="text-muted small">Request <%= ngoRequest.getStatus() %></span>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } else { %>
            <div class="request-card text-center">
                <div class="request-body py-5">
                    <i class="fas fa-handshake fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">No NGO Requests Yet</h4>
                    <p class="text-muted">When NGOs request your food listings, they will appear here for you to review.</p>
                    <a href="addFoodListing.jsp" class="btn btn-success">
                        <i class="fas fa-plus me-2"></i>Add Food Listing
                    </a>
                </div>
            </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateRequestStatus(requestId, newStatus) {
            let confirmMessage = '';
            switch(newStatus) {
                case 'approved':
                    confirmMessage = 'Are you sure you want to accept this request? The NGO will be notified.';
                    break;
                case 'rejected':
                    confirmMessage = 'Are you sure you want to reject this request? The NGO will be notified.';
                    break;
                case 'completed':
                    confirmMessage = 'Are you sure you want to mark this request as completed?';
                    break;
            }
            
            if (confirm(confirmMessage)) {
                const formData = new FormData();
                formData.append('requestId', requestId);
                formData.append('status', newStatus);
                
                fetch('updateRequestStatus.jsp', {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('SUCCESS')) {
                        alert('Request status updated successfully!');
                        location.reload();
                    } else {
                        alert('Error updating request status: ' + data);
                    }
                })
                .catch(error => {
                    alert('Error updating request status. Please try again.');
                });
            }
        }
    </script>
</body>
</html>