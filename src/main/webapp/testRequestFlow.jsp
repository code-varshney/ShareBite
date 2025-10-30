<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Test Request Flow - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Test Request Flow</h2>
        
        <%
        // Test data - you can modify these values
        int testDonorId = 1; // Change this to an actual donor ID
        int testNgoId = 2;   // Change this to an actual NGO ID
        
        out.println("<h4>Testing Request Flow for Donor ID: " + testDonorId + "</h4>");
        
        // Get food listings for this donor
        List<FoodListingBean> donorListings = FoodListingDAO.getFoodListingsByDonor(testDonorId);
        out.println("<p><strong>Food Listings by Donor:</strong> " + (donorListings != null ? donorListings.size() : 0) + "</p>");
        
        if (donorListings != null && !donorListings.isEmpty()) {
            out.println("<ul>");
            for (FoodListingBean listing : donorListings) {
                out.println("<li>ID: " + listing.getId() + " - " + listing.getFoodName() + " (" + listing.getStatus() + ")</li>");
            }
            out.println("</ul>");
        }
        
        // Get requests for this donor
        List<FoodRequestBean> donorRequests = FoodRequestDAO.getFoodRequestsForDonor(testDonorId);
        out.println("<p><strong>Requests for Donor:</strong> " + (donorRequests != null ? donorRequests.size() : 0) + "</p>");
        
        if (donorRequests != null && !donorRequests.isEmpty()) {
            out.println("<div class='row'>");
            for (FoodRequestBean donorRequest : donorRequests) {
                out.println("<div class='col-md-6 mb-3'>");
                out.println("<div class='card'>");
                out.println("<div class='card-body'>");
                out.println("<h6 class='card-title'>Request #" + donorRequest.getId() + "</h6>");
                out.println("<p class='card-text'>");
                out.println("<strong>NGO:</strong> " + (donorRequest.getNgoName() != null ? donorRequest.getNgoName() : "Unknown") + "<br>");
                out.println("<strong>Food:</strong> " + (donorRequest.getFoodName() != null ? donorRequest.getFoodName() : "Food ID: " + donorRequest.getFoodListingId()) + "<br>");
                out.println("<strong>Status:</strong> " + donorRequest.getStatus() + "<br>");
                out.println("<strong>Pickup Date:</strong> " + donorRequest.getPickupDate() + "<br>");
                if (donorRequest.getRequestMessage() != null && !donorRequest.getRequestMessage().isEmpty()) {
                    out.println("<strong>Message:</strong> " + donorRequest.getRequestMessage() + "<br>");
                }
                out.println("<strong>Created:</strong> " + donorRequest.getCreatedAt());
                out.println("</p>");
                out.println("</div>");
                out.println("</div>");
                out.println("</div>");
            }
            out.println("</div>");
        } else {
            out.println("<div class='alert alert-info'>No requests found for this donor. This could mean:</div>");
            out.println("<ul>");
            out.println("<li>No NGOs have made requests yet</li>");
            out.println("<li>The donor ID doesn't exist</li>");
            out.println("<li>There's an issue with the database query</li>");
            out.println("</ul>");
        }
        
        // Test NGO requests
        out.println("<hr>");
        out.println("<h4>Testing NGO Requests for NGO ID: " + testNgoId + "</h4>");
        
        List<FoodRequestBean> ngoRequests = FoodRequestDAO.getFoodRequestsByNgo(testNgoId);
        out.println("<p><strong>Requests by NGO:</strong> " + (ngoRequests != null ? ngoRequests.size() : 0) + "</p>");
        
        if (ngoRequests != null && !ngoRequests.isEmpty()) {
            out.println("<div class='row'>");
            for (FoodRequestBean ngoRequest : ngoRequests) {
                out.println("<div class='col-md-6 mb-3'>");
                out.println("<div class='card'>");
                out.println("<div class='card-body'>");
                out.println("<h6 class='card-title'>Request #" + ngoRequest.getId() + "</h6>");
                out.println("<p class='card-text'>");
                out.println("<strong>Food Listing ID:</strong> " + ngoRequest.getFoodListingId() + "<br>");
                out.println("<strong>Status:</strong> " + ngoRequest.getStatus() + "<br>");
                out.println("<strong>Pickup Date:</strong> " + ngoRequest.getPickupDate() + "<br>");
                out.println("<strong>Created:</strong> " + ngoRequest.getCreatedAt());
                out.println("</p>");
                out.println("</div>");
                out.println("</div>");
                out.println("</div>");
            }
            out.println("</div>");
        }
        %>
        
        <hr>
        <div class="alert alert-warning">
            <h5>Instructions:</h5>
            <ol>
                <li>Make sure you have donors and NGOs registered in your system</li>
                <li>Update the testDonorId and testNgoId variables above with actual IDs from your database</li>
                <li>Create some food listings as a donor</li>
                <li>Make requests as an NGO</li>
                <li>Check if the requests appear in the donor's dashboard</li>
            </ol>
        </div>
        
        <div class="mt-4">
            <a href="donorDashboard.jsp" class="btn btn-primary">Go to Donor Dashboard</a>
            <a href="ngoDashboard.jsp" class="btn btn-success">Go to NGO Dashboard</a>
        </div>
    </div>
</body>
</html>