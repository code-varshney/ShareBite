<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.NotificationDAO" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="java.sql.*" %>

<%
// Check if user is logged in and is a donor
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || !"donor".equals(userType) || userId == null) {
    out.print("ERROR: Not authorized");
    return;
}

// Get parameters
String requestIdStr = request.getParameter("requestId");
String newStatus = request.getParameter("status");

if (requestIdStr == null || newStatus == null) {
    out.print("ERROR: Missing parameters");
    return;
}

try {
    int requestId = Integer.parseInt(requestIdStr);
    
    // Get the request details first
    FoodRequestBean foodRequest = FoodRequestDAO.getFoodRequestById(requestId);
    if (foodRequest == null) {
        out.print("ERROR: Request not found");
        return;
    }
    
    // Debug logging
    System.out.println("DEBUG: Updating request " + requestId + " to status: " + newStatus);
    
    // Update request status using direct SQL
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
    
    PreparedStatement ps = con.prepareStatement("UPDATE food_requests SET status=?, updatedAt=NOW() WHERE id=?");
    ps.setString(1, newStatus);
    ps.setInt(2, requestId);
    
    int rowsUpdated = ps.executeUpdate();
    System.out.println("DEBUG: Rows updated: " + rowsUpdated);
    
    ps.close();
    con.close();
    
    if (rowsUpdated > 0) {
        // Create notification for NGO
        String message = "";
        if ("approved".equals(newStatus)) {
            message = "Your food request has been APPROVED! You can proceed with pickup.";
        } else if ("rejected".equals(newStatus)) {
            message = "Your food request has been REJECTED. Please try other available listings.";
        } else if ("completed".equals(newStatus)) {
            message = "Your food request has been marked as COMPLETED. Thank you!";
        }
        
        if (!message.isEmpty()) {
            NotificationDAO.notifyNGOAboutRequestUpdate(foodRequest.getNgoId(), Integer.parseInt(userId), foodRequest.getFoodListingId(), message);
        }
        
        out.print("SUCCESS: Request status updated to " + newStatus);
    } else {
        out.print("ERROR: No rows updated - request may not exist");
    }
    
} catch (Exception e) {
    System.out.println("DEBUG: Exception in updateRequestStatus: " + e.getMessage());
    e.printStackTrace();
    out.print("ERROR: " + e.getMessage());
}
%>