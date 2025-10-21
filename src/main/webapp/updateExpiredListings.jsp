<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>

<%
// This JSP can be called periodically to update expired food listings
// It can be triggered by a cron job, scheduler, or called manually

try {
    // Update all expired food listings
    int updatedCount = FoodListingDAO.updateExpiredFoodListings();
    
    // Return success response
    response.setContentType("application/json");
    out.print("{\"success\": true, \"message\": \"Updated " + updatedCount + " expired listings\", \"updatedCount\": " + updatedCount + "}");
    
} catch (Exception e) {
    e.printStackTrace();
    response.setContentType("application/json");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    out.print("{\"success\": false, \"message\": \"Error updating expired listings: " + e.getMessage() + "\"}");
}
%>