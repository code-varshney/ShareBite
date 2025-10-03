<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <title>Test Food Listings</title>
</head>
<body>
    <h1>Food Listings Test</h1>
    
    <%
    try {
        List<FoodListingBean> listings = FoodListingDAO.getAllFoodListings();
        out.println("<p>Total food listings found: " + (listings != null ? listings.size() : 0) + "</p>");
        
        if (listings != null && !listings.isEmpty()) {
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Food Name</th><th>Type</th><th>Quantity</th><th>Status</th><th>Active</th></tr>");
            
            for (FoodListingBean food : listings) {
                out.println("<tr>");
                out.println("<td>" + food.getId() + "</td>");
                out.println("<td>" + food.getFoodName() + "</td>");
                out.println("<td>" + food.getFoodType() + "</td>");
                out.println("<td>" + food.getQuantity() + " " + food.getQuantityUnit() + "</td>");
                out.println("<td>" + food.getStatus() + "</td>");
                out.println("<td>" + food.isActive() + "</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
        } else {
            out.println("<p>No food listings found.</p>");
        }
        
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
    %>
    
</body>
</html>