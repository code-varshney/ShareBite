<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="java.sql.*" %>

<%
// Check if user is logged in and is a donor
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || !"donor".equals(userType) || userId == null) {
    response.sendRedirect("donorLogin.jsp?error=not_authorized");
    return;
}

// Get request ID
String requestIdStr = request.getParameter("requestId");
if (requestIdStr == null) {
    response.sendRedirect("donorDashboard.jsp?error=invalid_request");
    return;
}

int requestId = Integer.parseInt(requestIdStr);
FoodRequestBean foodRequest = FoodRequestDAO.getFoodRequestById(requestId);

if (foodRequest == null) {
    response.sendRedirect("donorDashboard.jsp?error=request_not_found");
    return;
}

// Get NGO details
String ngoName = "";
String ngoPhone = "";
String ngoEmail = "";
String ngoAddress = "";
String organizationName = "";
String mission = "";

try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
    
    PreparedStatement ps = con.prepareStatement(
        "SELECT u.name, u.phone, u.email, u.fulladdress, u.organizationName, " +
        "nd.mission, nd.contactPerson, nd.registrationNumber " +
        "FROM users u LEFT JOIN ngo_details nd ON u.id = nd.userId " +
        "WHERE u.id = ?"
    );
    ps.setInt(1, foodRequest.getNgoId());
    ResultSet rs = ps.executeQuery();
    
    if (rs.next()) {
        ngoName = rs.getString("name") != null ? rs.getString("name") : "";
        ngoPhone = rs.getString("phone") != null ? rs.getString("phone") : "";
        ngoEmail = rs.getString("email") != null ? rs.getString("email") : "";
        ngoAddress = rs.getString("fulladdress") != null ? rs.getString("fulladdress") : "";
        organizationName = rs.getString("organizationName") != null ? rs.getString("organizationName") : "";
        mission = rs.getString("mission") != null ? rs.getString("mission") : "";
    }
    
    rs.close();
    ps.close();
    con.close();
} catch (Exception e) {
    e.printStackTrace();
}

// Get food listing details
FoodListingBean foodListing = FoodListingDAO.getFoodListingById(foodRequest.getFoodListingId());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>NGO Request Details - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(-45deg, #e3f2fd, #f0f8ff, #e1f5fe, #f3e5f5);
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        .main-container {
            max-width: 1000px;
            margin: 2rem auto;
            padding: 0 1rem;
        }
        
        .request-card {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 2rem;
        }
        
        .card-header {
            background: linear-gradient(135deg, #007bff, #6610f2);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        
        .status-badge {
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.8rem;
        }
        
        .status-pending { background: #ffc107; color: #000; }
        .status-approved { background: #28a745; color: white; }
        .status-rejected { background: #dc3545; color: white; }
        
        .info-section {
            padding: 2rem;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 1rem;
            padding: 0.5rem 0;
            border-bottom: 1px solid #eee;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
            min-width: 150px;
        }
        
        .info-value {
            color: #6c757d;
            flex: 1;
        }
        
        .action-buttons {
            padding: 2rem;
            background: #f8f9fa;
            text-align: center;
        }
        
        .btn-accept {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            color: white;
            padding: 0.8rem 2rem;
            border-radius: 10px;
            margin: 0 0.5rem;
            transition: all 0.3s ease;
        }
        
        .btn-reject {
            background: linear-gradient(135deg, #dc3545, #c82333);
            border: none;
            color: white;
            padding: 0.8rem 2rem;
            border-radius: 10px;
            margin: 0 0.5rem;
            transition: all 0.3s ease;
        }
        
        .btn-accept:hover, .btn-reject:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
    </style>
</head>
<body>
    <div class="main-container">
        <div class="request-card">
            <div class="card-header">
                <h2><i class="fas fa-hands-helping me-2"></i>NGO Food Request</h2>
                <p class="mb-0">Request ID: #<%= foodRequest.getId() %></p>
                <span class="status-badge status-<%= foodRequest.getStatus() %>">
                    <%= foodRequest.getStatus().toUpperCase() %>
                </span>
            </div>
            
            <div class="info-section">
                <h4><i class="fas fa-utensils me-2 text-primary"></i>Food Details</h4>
                <% if (foodListing != null) { %>
                    <div class="info-row">
                        <div class="info-label">Food Name:</div>
                        <div class="info-value"><%= foodListing.getFoodName() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Quantity:</div>
                        <div class="info-value"><%= foodListing.getQuantity() %> <%= foodListing.getQuantityUnit() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Food Type:</div>
                        <div class="info-value"><%= foodListing.getFoodType() %></div>
                    </div>
                    <div class="info-row">
                        <div class="info-label">Expiry Date:</div>
                        <div class="info-value"><%= foodListing.getExpiryDate() %></div>
                    </div>
                <% } %>
            </div>
            
            <div class="info-section">
                <h4><i class="fas fa-users me-2 text-success"></i>NGO Details</h4>
                <div class="info-row">
                    <div class="info-label">Organization:</div>
                    <div class="info-value"><%= organizationName.isEmpty() ? ngoName : organizationName %></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Contact Person:</div>
                    <div class="info-value"><%= ngoName %></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Phone:</div>
                    <div class="info-value"><%= ngoPhone.isEmpty() ? "Not provided" : ngoPhone %></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Email:</div>
                    <div class="info-value"><%= ngoEmail.isEmpty() ? "Not provided" : ngoEmail %></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Address:</div>
                    <div class="info-value"><%= ngoAddress.isEmpty() ? "Not provided" : ngoAddress %></div>
                </div>
                <% if (!mission.isEmpty()) { %>
                <div class="info-row">
                    <div class="info-label">Mission:</div>
                    <div class="info-value"><%= mission %></div>
                </div>
                <% } %>
            </div>
            
            <div class="info-section">
                <h4><i class="fas fa-calendar me-2 text-info"></i>Request Details</h4>
                <div class="info-row">
                    <div class="info-label">Pickup Date:</div>
                    <div class="info-value"><%= foodRequest.getPickupDate() %></div>
                </div>
                <% if (foodRequest.getPickupTime() != null && !foodRequest.getPickupTime().isEmpty()) { %>
                <div class="info-row">
                    <div class="info-label">Pickup Time:</div>
                    <div class="info-value"><%= foodRequest.getPickupTime() %></div>
                </div>
                <% } %>
                <% if (foodRequest.getRequestMessage() != null && !foodRequest.getRequestMessage().isEmpty()) { %>
                <div class="info-row">
                    <div class="info-label">Message:</div>
                    <div class="info-value"><%= foodRequest.getRequestMessage() %></div>
                </div>
                <% } %>
                <div class="info-row">
                    <div class="info-label">Request Date:</div>
                    <div class="info-value"><%= foodRequest.getCreatedAt() %></div>
                </div>
            </div>
            
            <% if ("pending".equals(foodRequest.getStatus())) { %>
            <div class="action-buttons">
                <button class="btn btn-accept" onclick="updateRequestStatus(<%= foodRequest.getId() %>, 'approved')">
                    <i class="fas fa-check me-2"></i>Accept Request
                </button>
                <button class="btn btn-reject" onclick="updateRequestStatus(<%= foodRequest.getId() %>, 'rejected')">
                    <i class="fas fa-times me-2"></i>Reject Request
                </button>
            </div>
            <% } else if ("approved".equals(foodRequest.getStatus())) { %>
            <div class="action-buttons">
                <button class="btn btn-accept" onclick="updateRequestStatus(<%= foodRequest.getId() %>, 'completed')">
                    <i class="fas fa-check-double me-2"></i>Mark as Completed
                </button>
            </div>
            <% } %>
            
            <div class="action-buttons">
                <a href="ngoRequests.jsp" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Back to Requests
                </a>
            </div>
        </div>
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
                        window.location.href = 'ngoRequests.jsp';
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
                    <div class="info-label">Pickup Time:</div>
                    <div class="info-value"><%= foodRequest.getPickupTime().isEmpty() ? "Not specified" : foodRequest.getPickupTime() %></div>
                </div>
                <div class="info-row">
                    <div class="info-label">Request Date:</div>
                    <div class="info-value"><%= foodRequest.getCreatedAt() %></div>
                </div>
                <% if (foodRequest.getRequestMessage() != null && !foodRequest.getRequestMessage().isEmpty()) { %>
                <div class="info-row">
                    <div class="info-label">Message:</div>
                    <div class="info-value"><%= foodRequest.getRequestMessage() %></div>
                </div>
                <% } %>
            </div>
            
            <% if ("pending".equals(foodRequest.getStatus())) { %>
            <div class="action-buttons">
                <h5 class="mb-3">Take Action</h5>
                <button class="btn btn-accept" onclick="updateRequestStatus(<%= foodRequest.getId() %>, 'approved')">
                    <i class="fas fa-check me-2"></i>Accept Request
                </button>
                <button class="btn btn-reject" onclick="updateRequestStatus(<%= foodRequest.getId() %>, 'rejected')">
                    <i class="fas fa-times me-2"></i>Reject Request
                </button>
            </div>
            <% } else { %>
            <div class="action-buttons">
                <div class="alert alert-info">
                    <i class="fas fa-info-circle me-2"></i>
                    This request has already been <%= foodRequest.getStatus() %>.
                </div>
            </div>
            <% } %>
        </div>
        
        <div class="text-center">
            <a href="donorDashboard.jsp" class="btn btn-secondary">
                <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
            </a>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateRequestStatus(requestId, status) {
            if (confirm('Are you sure you want to ' + status + ' this request?')) {
                fetch('updateRequestStatus.jsp', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'requestId=' + requestId + '&status=' + status
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('success')) {
                        alert('Request ' + status + ' successfully!');
                        window.location.reload();
                    } else {
                        alert('Error updating request status.');
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Error updating request status.');
                });
            }
        }
    </script>
</body>
</html>