<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.NotificationDAO" %>

<%
// Check if user is logged in and is an NGO
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || !"ngo".equals(userType) || userId == null) {
    out.print("ERROR: Not authorized");
    return;
}

try {
    String notificationIdParam = request.getParameter("notificationId");
    if (notificationIdParam != null && !notificationIdParam.trim().isEmpty()) {
        int notificationId = Integer.parseInt(notificationIdParam);
        boolean success = NotificationDAO.markAsRead(notificationId);
        
        if (success) {
            out.print("SUCCESS: Notification marked as read");
        } else {
            out.print("ERROR: Failed to mark notification as read");
        }
    } else {
        out.print("ERROR: Notification ID is required");
    }
} catch (Exception e) {
    out.print("ERROR: " + e.getMessage());
}
%>