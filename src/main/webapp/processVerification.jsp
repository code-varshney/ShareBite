<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");

String userIdStr = request.getParameter("userId");
String status = request.getParameter("status");

if (userIdStr != null && status != null) {
    try {
        int userId = Integer.parseInt(userIdStr);
        int result = UserDAO.updateVerificationStatus(userId, status);
        
        if (result > 0) {
            out.print("{\"success\": true, \"message\": \"User " + status + " successfully!\"}");
        } else {
            out.print("{\"success\": false, \"message\": \"Failed to update verification status\"}");
        }
    } catch (NumberFormatException e) {
        out.print("{\"success\": false, \"message\": \"Invalid user ID\"}");
    } catch (Exception e) {
        e.printStackTrace();
        out.print("{\"success\": false, \"message\": \"Database error occurred\"}");
    }
} else {
    out.print("{\"success\": false, \"message\": \"Missing required parameters\"}");
}
%>