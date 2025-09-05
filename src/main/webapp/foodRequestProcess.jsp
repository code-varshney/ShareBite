<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="java.util.*" %>

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
if (foodListingId == null || pickupDate == null || pickupDate.trim().isEmpty()) {
    response.sendRedirect("ngoDashboard.jsp?error=missing_fields");
    return;
}

// Check if NGO already has an active request for this food listing
int ngoId = Integer.parseInt(userId);
int listingId = Integer.parseInt(foodListingId);

if (FoodRequestDAO.hasActiveRequest(ngoId, listingId)) {
    response.sendRedirect("ngoDashboard.jsp?error=already_requested");
    return;
}

// Create FoodRequestBean
FoodRequestBean requestBean = new FoodRequestBean();
requestBean.setNgoId(ngoId);
requestBean.setFoodListingId(listingId);
requestBean.setRequestMessage(requestMessage != null ? requestMessage.trim() : "");
requestBean.setPickupDate(pickupDate.trim());
requestBean.setPickupTime(pickupTime != null ? pickupTime.trim() : "");
requestBean.setStatus("pending");
requestBean.setActive(true);

// Attempt to create request
int requestStatus = FoodRequestDAO.createFoodRequest(requestBean);

if (requestStatus > 0) {
    // Request created successfully
    response.sendRedirect("ngoDashboard.jsp?success=request_created");
} else {
    // Request creation failed
    response.sendRedirect("ngoDashboard.jsp?error=request_failed");
}
%>
