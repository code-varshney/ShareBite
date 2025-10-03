<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.NotificationDAO" %>
<%@ page import="com.net.bean.NotificationBean" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <title>Test Notifications</title>
</head>
<body>
    <h1>Notifications Test</h1>
    
    <%
    try {
        // Test creating a notification
        boolean created = NotificationDAO.createNotification(1, 1, 1, "Test notification", "test");
        out.println("<p>Test notification created: " + created + "</p>");
        
        // Test getting notifications for NGO ID 1
        List<NotificationBean> notifications = NotificationDAO.getNotificationsByNGO(1);
        out.println("<p>Total notifications for NGO 1: " + (notifications != null ? notifications.size() : 0) + "</p>");
        
        if (notifications != null && !notifications.isEmpty()) {
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>NGO ID</th><th>Donor ID</th><th>Food ID</th><th>Message</th><th>Read</th><th>Created</th></tr>");
            
            for (NotificationBean notif : notifications) {
                out.println("<tr>");
                out.println("<td>" + notif.getId() + "</td>");
                out.println("<td>" + notif.getNgoId() + "</td>");
                out.println("<td>" + notif.getDonorId() + "</td>");
                out.println("<td>" + notif.getFoodListingId() + "</td>");
                out.println("<td>" + notif.getMessage() + "</td>");
                out.println("<td>" + notif.isRead() + "</td>");
                out.println("<td>" + notif.getCreatedAt() + "</td>");
                out.println("</tr>");
            }
            
            out.println("</table>");
        }
        
        // Test unread count
        int unreadCount = NotificationDAO.getUnreadCount(1);
        out.println("<p>Unread count for NGO 1: " + unreadCount + "</p>");
        
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
    %>
    
</body>
</html>