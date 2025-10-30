<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Debug Request Submission</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Debug Request Submission Flow</h2>
        
        <%
        // Check session
        String userType = (String) session.getAttribute("userType");
        String userId = (String) session.getAttribute("userId");
        String userName = (String) session.getAttribute("userName");
        String organizationName = (String) session.getAttribute("organizationName");
        
        out.println("<div class='alert alert-info'>");
        out.println("<h5>Session Information:</h5>");
        out.println("User Type: " + userType + "<br>");
        out.println("User ID: " + userId + "<br>");
        out.println("User Name: " + userName + "<br>");
        out.println("Organization Name: " + organizationName + "<br>");
        out.println("</div>");
        
        // Get available food listings
        List<FoodListingBean> availableFood = FoodListingDAO.getAllFoodListings();
        out.println("<div class='alert alert-success'>");
        out.println("<h5>Available Food Listings: " + (availableFood != null ? availableFood.size() : 0) + "</h5>");
        if (availableFood != null && !availableFood.isEmpty()) {
            for (FoodListingBean food : availableFood) {
                out.println("ID: " + food.getId() + " - " + food.getFoodName() + " (Donor ID: " + food.getDonorId() + ")<br>");
            }
        }
        out.println("</div>");
        
        // Test request submission if form is submitted
        String testSubmit = request.getParameter("testSubmit");
        if ("true".equals(testSubmit) && userId != null && availableFood != null && !availableFood.isEmpty()) {
            try {
                FoodListingBean firstFood = availableFood.get(0);
                
                FoodRequestBean testRequest = new FoodRequestBean();
                testRequest.setNgoId(Integer.parseInt(userId));
                testRequest.setFoodListingId(firstFood.getId());
                testRequest.setRequestMessage("Test request from debug page");
                testRequest.setPickupDate("2024-12-20");
                testRequest.setPickupTime("14:00");
                testRequest.setStatus("pending");
                testRequest.setActive(true);
                
                out.println("<div class='alert alert-warning'>");
                out.println("<h5>Testing Request Creation:</h5>");
                out.println("NGO ID: " + testRequest.getNgoId() + "<br>");
                out.println("Food Listing ID: " + testRequest.getFoodListingId() + "<br>");
                out.println("Food Name: " + firstFood.getFoodName() + "<br>");
                out.println("</div>");
                
                int result = FoodRequestDAO.createFoodRequest(testRequest);
                
                if (result > 0) {
                    out.println("<div class='alert alert-success'>");
                    out.println("<h5>✅ SUCCESS: Request created successfully!</h5>");
                    out.println("Result: " + result + "<br>");
                    out.println("</div>");
                } else {
                    out.println("<div class='alert alert-danger'>");
                    out.println("<h5>❌ FAILED: Request creation failed!</h5>");
                    out.println("Result: " + result + "<br>");
                    out.println("</div>");
                }
                
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>");
                out.println("<h5>❌ ERROR: Exception occurred!</h5>");
                out.println("Error: " + e.getMessage() + "<br>");
                e.printStackTrace();
                out.println("</div>");
            }
        }
        
        // Check existing requests
        if (userId != null) {
            try {
                List<FoodRequestBean> ngoRequests = FoodRequestDAO.getFoodRequestsByNgo(Integer.parseInt(userId));
                out.println("<div class='alert alert-info'>");
                out.println("<h5>Existing NGO Requests: " + (ngoRequests != null ? ngoRequests.size() : 0) + "</h5>");
                if (ngoRequests != null && !ngoRequests.isEmpty()) {
                    for (FoodRequestBean req : ngoRequests) {
                        out.println("Request ID: " + req.getId() + " - Status: " + req.getStatus() + " - Date: " + req.getPickupDate() + "<br>");
                    }
                }
                out.println("</div>");
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error getting NGO requests: " + e.getMessage() + "</div>");
            }
        }
        %>
        
        <% if (userType != null && "ngo".equals(userType) && userId != null && availableFood != null && !availableFood.isEmpty()) { %>
            <form method="post">
                <input type="hidden" name="testSubmit" value="true">
                <button type="submit" class="btn btn-primary">Test Request Submission</button>
            </form>
        <% } else { %>
            <div class="alert alert-warning">
                <h5>Cannot Test Request Submission:</h5>
                <% if (userType == null || !"ngo".equals(userType)) { %>
                    - Not logged in as NGO<br>
                <% } %>
                <% if (userId == null) { %>
                    - No user ID in session<br>
                <% } %>
                <% if (availableFood == null || availableFood.isEmpty()) { %>
                    - No available food listings<br>
                <% } %>
            </div>
        <% } %>
        
        <div class="mt-4">
            <a href="ngoDashboard.jsp" class="btn btn-secondary">Back to NGO Dashboard</a>
            <a href="donorDashboard.jsp" class="btn btn-info">Check Donor Dashboard</a>
        </div>
    </div>
</body>
</html>