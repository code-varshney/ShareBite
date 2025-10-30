<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.NotificationDAO" %>
<%@ page import="com.net.bean.FoodRequestBean" %>

<%
// Check if user is logged in and is a donor
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || !"donor".equals(userType) || userId == null) {
    response.sendRedirect("donorLogin.jsp?error=not_authorized");
    return;
}

// Get form parameters
String requestIdStr = request.getParameter("requestId");
String newStatus = request.getParameter("status");

if (requestIdStr == null || requestIdStr.trim().isEmpty() || 
    newStatus == null || newStatus.trim().isEmpty()) {
    out.print("ERROR: Missing required parameters");
    return;
}

try {
    int requestId = Integer.parseInt(requestIdStr);
    int donorId = Integer.parseInt(userId);
    
    // Get the request details first to verify it belongs to this donor
    FoodRequestBean request = FoodRequestDAO.getFoodRequestById(requestId);
    if (request == null) {
        out.print("ERROR: Request not found");
        return;
    }
    
    // Update the request status
    int result = FoodRequestDAO.updateRequestStatus(requestId, newStatus);
    
    if (result > 0) {
        // Notify the NGO about the status update
        String message = "Your food request has been " + newStatus + " by the donor.";
        NotificationDAO.notifyNGOAboutRequestUpdate(
            request.getNgoId(), 
            donorId, 
            request.getFoodListingId(), 
            message
        );
        
        out.print("SUCCESS: Request status updated to " + newStatus);
    } else {
        out.print("ERROR: Failed to update request status");
    }
    
} catch (NumberFormatException e) {
    out.print("ERROR: Invalid request ID");
} catch (Exception e) {
    e.printStackTrace();
    out.print("ERROR: " + e.getMessage());
}
%>