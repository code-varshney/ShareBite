<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
// This JSP can be called by a scheduler (like cron job) to perform maintenance tasks
// It should be called periodically (e.g., every hour or daily)

try {
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String currentTime = sdf.format(new Date());
    
    // Update expired food listings
    int updatedCount = FoodListingDAO.updateExpiredFoodListings();
    
    // Log the activity
    System.out.println("[" + currentTime + "] Scheduled task executed: Updated " + updatedCount + " expired food listings");
    
    // Return JSON response for API calls
    response.setContentType("application/json");
    out.print("{");
    out.print("\"success\": true,");
    out.print("\"timestamp\": \"" + currentTime + "\",");
    out.print("\"updatedCount\": " + updatedCount + ",");
    out.print("\"message\": \"Scheduled maintenance completed successfully\"");
    out.print("}");
    
} catch (Exception e) {
    e.printStackTrace();
    
    // Log the error
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    String currentTime = sdf.format(new Date());
    System.err.println("[" + currentTime + "] Scheduled task failed: " + e.getMessage());
    
    response.setContentType("application/json");
    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
    out.print("{");
    out.print("\"success\": false,");
    out.print("\"timestamp\": \"" + currentTime + "\",");
    out.print("\"error\": \"" + e.getMessage().replace("\"", "\\\"") + "\",");
    out.print("\"message\": \"Scheduled maintenance failed\"");
    out.print("}");
}
%>