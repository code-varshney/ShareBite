<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Simple Test Request - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Simple Test Request</h2>
        
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
                
                // Get any user as NGO (first user)
                PreparedStatement ps = con.prepareStatement("SELECT id FROM users ORDER BY id LIMIT 1");
                ResultSet rs = ps.executeQuery();
                int ngoId = 0;
                if (rs.next()) ngoId = rs.getInt("id");
                
                // Get any food listing
                ps = con.prepareStatement("SELECT id, donorId FROM food_listings WHERE isActive=1 ORDER BY id LIMIT 1");
                rs = ps.executeQuery();
                int foodListingId = 0, donorId = 0;
                if (rs.next()) {
                    foodListingId = rs.getInt("id");
                    donorId = rs.getInt("donorId");
                }
                
                if (ngoId > 0 && foodListingId > 0) {
                    // Insert test request
                    ps = con.prepareStatement("INSERT INTO food_requests (ngoId, foodListingId, requestMessage, pickupDate, pickupTime, status, isActive) VALUES (?, ?, ?, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', 'pending', 1)");
                    ps.setInt(1, ngoId);
                    ps.setInt(2, foodListingId);
                    ps.setString(3, "Simple test request - User " + ngoId + " requesting food from donor " + donorId);
                    
                    int result = ps.executeUpdate();
                    
                    if (result > 0) {
                        out.println("<div class='alert alert-success'>✓ Test request inserted successfully!</div>");
                        out.println("<p><strong>NGO/User ID:</strong> " + ngoId + "</p>");
                        out.println("<p><strong>Food Listing ID:</strong> " + foodListingId + "</p>");
                        out.println("<p><strong>Food Donor ID:</strong> " + donorId + "</p>");
                        
                        // Show the inserted request
                        ps = con.prepareStatement("SELECT * FROM food_requests WHERE ngoId=? AND foodListingId=? ORDER BY id DESC LIMIT 1");
                        ps.setInt(1, ngoId);
                        ps.setInt(2, foodListingId);
                        rs = ps.executeQuery();
                        
                        if (rs.next()) {
                            out.println("<h4>Inserted Request Details:</h4>");
                            out.println("<table class='table table-sm'>");
                            out.println("<tr><th>ID</th><th>NGO ID</th><th>Food Listing ID</th><th>Message</th><th>Status</th><th>Date</th></tr>");
                            out.println("<tr>");
                            out.println("<td>" + rs.getInt("id") + "</td>");
                            out.println("<td>" + rs.getInt("ngoId") + "</td>");
                            out.println("<td>" + rs.getInt("foodListingId") + "</td>");
                            out.println("<td>" + rs.getString("requestMessage") + "</td>");
                            out.println("<td>" + rs.getString("status") + "</td>");
                            out.println("<td>" + rs.getTimestamp("createdAt") + "</td>");
                            out.println("</tr>");
                            out.println("</table>");
                        }
                    } else {
                        out.println("<div class='alert alert-danger'>✗ Failed to insert test request</div>");
                    }
                } else {
                    out.println("<div class='alert alert-warning'>⚠ No users or food listings found</div>");
                    out.println("<p>User ID: " + ngoId + ", Food Listing ID: " + foodListingId + "</p>");
                }
                
                con.close();
                
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
                e.printStackTrace();
            }
        }
        %>
        
        <div class="card">
            <div class="card-header">
                <h5>Insert Simple Test Request</h5>
            </div>
            <div class="card-body">
                <p>This will insert a test request using the first available user and food listing.</p>
                <form method="post">
                    <input type="hidden" name="action" value="insert">
                    <button type="submit" class="btn btn-success">Insert Test Request</button>
                </form>
            </div>
        </div>
        
        <hr>
        <div class="mt-4">
            <a href="checkUserTable.jsp" class="btn btn-info me-2">Check User Table</a>
            <a href="fixRequestSystem.jsp" class="btn btn-primary me-2">Fix System</a>
            <a href="donorDashboard.jsp" class="btn btn-success">Donor Dashboard</a>
        </div>
    </div>
</body>
</html>