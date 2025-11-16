<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.DAO.ChatDAO" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");
String requestIdStr = request.getParameter("requestId");
String message = request.getParameter("message");

if (userType == null || userId == null || requestIdStr == null || message == null) {
    out.print("ERROR: Missing parameters");
    return;
}

int currentUserId = Integer.parseInt(userId);
int requestId = Integer.parseInt(requestIdStr);

FoodRequestBean foodRequest = FoodRequestDAO.getFoodRequestById(requestId);
if (foodRequest == null || (!foodRequest.getStatus().equals("approved") && !foodRequest.getStatus().equals("completed"))) {
    out.print("ERROR: Invalid request");
    return;
}

// Determine receiver based on sender
int receiverId;
if ("donor".equals(userType)) {
    receiverId = foodRequest.getNgoId();
} else {
    // Get donor ID from food listing
    receiverId = foodRequest.getDonorId();
}

boolean success = ChatDAO.sendMessage(requestId, currentUserId, receiverId, message);
out.print(success ? "SUCCESS" : "ERROR: Failed to send message");
%>