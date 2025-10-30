<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Check Food Listings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Food Listings Debug</h2>
        
        <%
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
            
            // Check all food listings
            PreparedStatement ps = con.prepareStatement("SELECT id, foodName, status, isActive, donorId FROM food_listings ORDER BY id DESC LIMIT 10");
            ResultSet rs = ps.executeQuery();
            
            out.println("<h4>Recent Food Listings in Database:</h4>");
            out.println("<table class='table table-striped'>");
            out.println("<thead><tr><th>ID</th><th>Food Name</th><th>Status</th><th>Active</th><th>Donor ID</th><th>Test Request</th></tr></thead>");
            out.println("<tbody>");
            
            while (rs.next()) {
                int id = rs.getInt("id");
                String foodName = rs.getString("foodName");
                String status = rs.getString("status");
                boolean isActive = rs.getBoolean("isActive");
                int donorId = rs.getInt("donorId");
                
                out.println("<tr>");
                out.println("<td>" + id + "</td>");
                out.println("<td>" + foodName + "</td>");
                out.println("<td>" + status + "</td>");
                out.println("<td>" + isActive + "</td>");
                out.println("<td>" + donorId + "</td>");
                out.println("<td><button class='btn btn-sm btn-primary' onclick='testRequest(" + id + ")'>Test</button></td>");
                out.println("</tr>");
            }
            
            out.println("</tbody></table>");
            rs.close();
            ps.close();
            
            // Test getFoodListingById for each ID
            ps = con.prepareStatement("SELECT id FROM food_listings ORDER BY id DESC LIMIT 5");
            rs = ps.executeQuery();
            
            out.println("<h4>DAO Test Results:</h4>");
            out.println("<div class='alert alert-info'>");
            
            while (rs.next()) {
                int testId = rs.getInt("id");
                FoodListingBean testListing = FoodListingDAO.getFoodListingById(testId);
                
                if (testListing != null) {
                    out.println("✅ ID " + testId + ": Found - " + testListing.getFoodName() + "<br>");
                } else {
                    out.println("❌ ID " + testId + ": NOT FOUND<br>");
                }
            }
            
            out.println("</div>");
            rs.close();
            ps.close();
            con.close();
            
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            e.printStackTrace();
        }
        %>
        
        <div id="testResult" class="mt-4"></div>
        
        <div class="mt-4">
            <a href="ngoDashboard.jsp" class="btn btn-secondary">Back to NGO Dashboard</a>
        </div>
    </div>
    
    <script>
        function testRequest(foodId) {
            document.getElementById('testResult').innerHTML = '<div class="alert alert-info">Testing request for Food ID: ' + foodId + '</div>';
            
            // Create form data
            const formData = new FormData();
            formData.append('foodListingId', foodId);
            formData.append('pickupDate', '2024-12-20');
            formData.append('pickupTime', '14:00');
            formData.append('requestMessage', 'Test request from debug page');
            
            fetch('submitFoodRequest.jsp', {
                method: 'POST',
                body: formData
            })
            .then(response => {
                if (response.redirected) {
                    if (response.url.includes('success=request_submitted')) {
                        document.getElementById('testResult').innerHTML = '<div class="alert alert-success">✅ SUCCESS: Request submitted for Food ID ' + foodId + '</div>';
                    } else if (response.url.includes('error=food_not_found')) {
                        document.getElementById('testResult').innerHTML = '<div class="alert alert-danger">❌ ERROR: Food listing not found for ID ' + foodId + '</div>';
                    } else {
                        document.getElementById('testResult').innerHTML = '<div class="alert alert-warning">⚠️ Redirected to: ' + response.url + '</div>';
                    }
                } else {
                    return response.text();
                }
            })
            .then(data => {
                if (data) {
                    document.getElementById('testResult').innerHTML = '<div class="alert alert-info">Response: <pre>' + data.substring(0, 500) + '</pre></div>';
                }
            })
            .catch(error => {
                document.getElementById('testResult').innerHTML = '<div class="alert alert-danger">❌ Error: ' + error.message + '</div>';
            });
        }
    </script>
</body>
</html>