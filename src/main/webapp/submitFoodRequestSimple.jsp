<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>

<%
// Check if user is logged in and is an NGO
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || !"ngo".equals(userType) || userId == null) {
    response.sendRedirect("ngoLogin.jsp?error=not_authorized");
    return;
}

// Get form parameters
String foodListingId = request.getParameter("foodListingId");
String pickupDate = request.getParameter("pickupDate");
String pickupTime = request.getParameter("pickupTime");
String requestMessage = request.getParameter("requestMessage");

// Validate required fields
if (foodListingId == null || foodListingId.trim().isEmpty() ||
    pickupDate == null || pickupDate.trim().isEmpty()) {
    response.sendRedirect("ngoDashboard.jsp?error=missing_fields");
    return;
}

try {
    // Create FoodRequestBean directly without checking food listing
    FoodRequestBean foodRequest = new FoodRequestBean();
    foodRequest.setNgoId(Integer.parseInt(userId));
    foodRequest.setFoodListingId(Integer.parseInt(foodListingId));
    foodRequest.setPickupDate(pickupDate.trim());
    foodRequest.setPickupTime(pickupTime != null ? pickupTime.trim() : "");
    foodRequest.setRequestMessage(requestMessage != null ? requestMessage.trim() : "");
    foodRequest.setStatus("pending");
    foodRequest.setActive(true);
    
    // Submit the request
    int result = FoodRequestDAO.createFoodRequest(foodRequest);
    
    if (result > 0) {
        response.sendRedirect("ngoDashboard.jsp?success=request_submitted");
    } else {
        response.sendRedirect("ngoDashboard.jsp?error=request_failed");
    }
    
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("ngoDashboard.jsp?error=request_failed");
}
%>