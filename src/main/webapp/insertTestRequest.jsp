<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Insert Test Request - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Insert Test Request</h2>
        
        <%
        String action = request.getParameter("action");
        
        if ("insert".equals(action)) {
            String dclass = "com.mysql.cj.jdbc.Driver";
            String url = "jdbc:mysql://localhost:3306/sharebite_db";
            String username = "root";
            String password = "";
            
            try {
                Class.forName(dclass);
                Connection con = DriverManager.getConnection(url, username, password);
                
                // First, get available users and food listings
                PreparedStatement ps = con.prepareStatement("SELECT id, name, userType FROM users WHERE userType IN ('donor', 'ngo') ORDER BY userType, id");
                ResultSet rs = ps.executeQuery();
                
                int donorId = 0, ngoId = 0;
                while (rs.next()) {
                    if ("donor".equals(rs.getString("userType")) && donorId == 0) {
                        donorId = rs.getInt("id");
                    }
                    if ("ngo".equals(rs.getString("userType")) && ngoId == 0) {
                        ngoId = rs.getInt("id");
                    }
                }
                
                // Get a food listing
                ps = con.prepareStatement("SELECT id, donorId FROM food_listings WHERE isActive=1 LIMIT 1");
                rs = ps.executeQuery();
                int foodListingId = 0;
                int foodDonorId = 0;
                if (rs.next()) {
                    foodListingId = rs.getInt("id");
                    foodDonorId = rs.getInt("donorId");
                }
                
                if (ngoId > 0 && foodListingId > 0) {
                    // Insert test request
                    ps = con.prepareStatement("INSERT INTO food_requests (ngoId, foodListingId, requestMessage, pickupDate, pickupTime, status, isActive, createdAt, updatedAt) VALUES (?, ?, ?, CURDATE() + INTERVAL 1 DAY, '14:00:00', 'pending', 1, NOW(), NOW())");
                    ps.setInt(1, ngoId);
                    ps.setInt(2, foodListingId);
                    ps.setString(3, "Test request for debugging purposes");
                    
                    int result = ps.executeUpdate();
                    
                    if (result > 0) {
                        out.println("<div class='alert alert-success'>✓ Test request inserted successfully!</div>");
                        out.println("<p><strong>NGO ID:</strong> " + ngoId + "</p>");
                        out.println("<p><strong>Food Listing ID:</strong> " + foodListingId + "</p>");
                        out.println("<p><strong>Food Donor ID:</strong> " + foodDonorId + "</p>");
                    } else {
                        out.println("<div class='alert alert-danger'>✗ Failed to insert test request</div>");
                    }
                } else {
                    out.println("<div class='alert alert-warning'>⚠ No suitable NGO or food listing found</div>");
                    out.println("<p>NGO ID: " + ngoId + ", Food Listing ID: " + foodListingId + "</p>");
                }
                
                con.close();
                
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                e.printStackTrace();
            }
        }
        %>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>Insert Test Request</h5>
                    </div>
                    <div class="card-body">
                        <p>This will insert a test food request to verify the system is working.</p>
                        <form method="post">
                            <input type="hidden" name="action" value="insert">
                            <button type="submit" class="btn btn-primary">Insert Test Request</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header">
                        <h5>Quick Links</h5>
                    </div>
                    <div class="card-body">
                        <a href="debugRequests.jsp" class="btn btn-info btn-sm me-2">Debug Requests</a>
                        <a href="donorDashboard.jsp" class="btn btn-primary btn-sm me-2">Donor Dashboard</a>
                        <a href="ngoDashboard.jsp" class="btn btn-success btn-sm">NGO Dashboard</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>