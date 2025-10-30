<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Debug Requests - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Debug Request System</h2>
        
        <%
        // Database connection details
        String dclass = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/sharebite_db";
        String username = "root";
        String password = "";
        
        try {
            Class.forName(dclass);
            Connection con = DriverManager.getConnection(url, username, password);
            
            // Check if food_requests table exists
            out.println("<h4>1. Database Table Check</h4>");
            DatabaseMetaData dbm = con.getMetaData();
            ResultSet tables = dbm.getTables(null, null, "food_requests", null);
            if (tables.next()) {
                out.println("<div class='alert alert-success'>✓ food_requests table exists</div>");
            } else {
                out.println("<div class='alert alert-danger'>✗ food_requests table does not exist</div>");
            }
            
            // Check table structure
            out.println("<h4>2. Table Structure</h4>");
            PreparedStatement ps = con.prepareStatement("DESCRIBE food_requests");
            ResultSet rs = ps.executeQuery();
            out.println("<table class='table table-sm'>");
            out.println("<tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString("Field") + "</td>");
                out.println("<td>" + rs.getString("Type") + "</td>");
                out.println("<td>" + rs.getString("Null") + "</td>");
                out.println("<td>" + rs.getString("Key") + "</td>");
                out.println("<td>" + rs.getString("Default") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Check all requests in database
            out.println("<h4>3. All Requests in Database</h4>");
            ps = con.prepareStatement("SELECT * FROM food_requests ORDER BY createdAt DESC");
            rs = ps.executeQuery();
            out.println("<table class='table table-sm'>");
            out.println("<tr><th>ID</th><th>NGO ID</th><th>Food Listing ID</th><th>Status</th><th>Pickup Date</th><th>Active</th><th>Created</th></tr>");
            int totalRequests = 0;
            while (rs.next()) {
                totalRequests++;
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getInt("ngoId") + "</td>");
                out.println("<td>" + rs.getInt("foodListingId") + "</td>");
                out.println("<td>" + rs.getString("status") + "</td>");
                out.println("<td>" + rs.getString("pickupDate") + "</td>");
                out.println("<td>" + rs.getBoolean("isActive") + "</td>");
                out.println("<td>" + rs.getTimestamp("createdAt") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            out.println("<p><strong>Total requests in database: " + totalRequests + "</strong></p>");
            
            // Check food listings
            out.println("<h4>4. Food Listings</h4>");
            ps = con.prepareStatement("SELECT id, donorId, foodName, status FROM food_listings ORDER BY id");
            rs = ps.executeQuery();
            out.println("<table class='table table-sm'>");
            out.println("<tr><th>ID</th><th>Donor ID</th><th>Food Name</th><th>Status</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getInt("donorId") + "</td>");
                out.println("<td>" + rs.getString("foodName") + "</td>");
                out.println("<td>" + rs.getString("status") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Check users
            out.println("<h4>5. Users</h4>");
            ps = con.prepareStatement("SELECT id, name, userType FROM users ORDER BY id");
            rs = ps.executeQuery();
            out.println("<table class='table table-sm'>");
            out.println("<tr><th>ID</th><th>Name</th><th>Type</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("name") + "</td>");
                out.println("<td>" + rs.getString("userType") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Test the DAO method
            out.println("<h4>6. Test DAO Method</h4>");
            String currentUserId = (String) session.getAttribute("userId");
            String currentUserType = (String) session.getAttribute("userType");
            
            out.println("<p><strong>Current Session:</strong></p>");
            out.println("<p>User ID: " + currentUserId + "</p>");
            out.println("<p>User Type: " + currentUserType + "</p>");
            
            if (currentUserId != null) {
                int donorId = Integer.parseInt(currentUserId);
                List<FoodRequestBean> requests = FoodRequestDAO.getFoodRequestsForDonor(donorId);
                out.println("<p><strong>Requests for donor " + donorId + ": " + (requests != null ? requests.size() : 0) + "</strong></p>");
                
                if (requests != null && !requests.isEmpty()) {
                    out.println("<table class='table table-sm'>");
                    out.println("<tr><th>ID</th><th>NGO Name</th><th>Food Name</th><th>Status</th><th>Date</th></tr>");
                    for (FoodRequestBean req : requests) {
                        out.println("<tr>");
                        out.println("<td>" + req.getId() + "</td>");
                        out.println("<td>" + req.getNgoName() + "</td>");
                        out.println("<td>" + req.getFoodName() + "</td>");
                        out.println("<td>" + req.getStatus() + "</td>");
                        out.println("<td>" + req.getCreatedAt() + "</td>");
                        out.println("</tr>");
                    }
                    out.println("</table>");
                }
            }
            
            con.close();
            
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            e.printStackTrace();
        }
        %>
        
        <hr>
        <div class="mt-4">
            <a href="donorDashboard.jsp" class="btn btn-primary">Back to Donor Dashboard</a>
            <a href="ngoDashboard.jsp" class="btn btn-success">NGO Dashboard</a>
        </div>
    </div>
</body>
</html>