<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.NotificationDAO" %>
<%@ page import="com.net.bean.NotificationBean" %>
<%@ page import="java.util.List" %>

<%
// Check if user is logged in and is an NGO
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || !"ngo".equals(userType) || userId == null) {
    out.print("ERROR: Not authorized");
    return;
}

try {
    int ngoId = Integer.parseInt(userId);
    
    // Get all unread notifications for this NGO
    List<NotificationBean> notifications = NotificationDAO.getNotificationsByNGO(ngoId);
    boolean allSuccess = true;
    
    for (NotificationBean notification : notifications) {
        if (!notification.isRead()) {
            boolean success = NotificationDAO.markAsRead(notification.getId());
            if (!success) {
                allSuccess = false;
            }
        }
    }
    
    if (allSuccess) {
        out.print("SUCCESS: All notifications marked as read");
    } else {
        out.print("ERROR: Some notifications could not be marked as read");
    }
    
} catch (Exception e) {
    out.print("ERROR: " + e.getMessage());
}
%>