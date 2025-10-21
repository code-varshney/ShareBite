<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.UserDAO" %>

<%
String userId = request.getParameter("userId");
String status = request.getParameter("status");

if (userId != null && status != null) {
    try {
        int result = UserDAO.updateVerificationStatus(Integer.parseInt(userId), status);
        if (result > 0) {
            out.print("SUCCESS: Verification status updated");
        } else {
            out.print("ERROR: Failed to update verification status");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.print("ERROR: " + e.getMessage());
    }
} else {
    out.print("ERROR: Missing parameters");
}
%>