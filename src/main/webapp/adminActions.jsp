<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%
String action = request.getParameter("action");
String idStr = request.getParameter("id");
String status = request.getParameter("status");
int result = 0;
if ("updateRequestStatus".equals(action) && idStr != null && status != null) {
    int requestId = Integer.parseInt(idStr);
    result = FoodRequestDAO.updateRequestStatus(requestId, status);
    out.print("{\"success\":" + (result > 0) + "}");
    return;
}
if ("updateVerificationStatus".equals(action) && idStr != null && status != null) {
    int userId = Integer.parseInt(idStr);
    result = UserDAO.updateVerificationStatus(userId, status);
    out.print("{\"success\":" + (result > 0) + "}");
    return;
}

if ("autoVerifyNGOs".equals(action)) {
    // Auto-verify all pending NGOs
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        java.sql.Connection con = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
        java.sql.PreparedStatement ps = con.prepareStatement("UPDATE users SET verificationStatus='verified' WHERE role='ngo' AND verificationStatus='pending'");
        result = ps.executeUpdate();
        ps.close();
        con.close();
    } catch (Exception e) { e.printStackTrace(); }
    out.print("{\"success\":" + (result > 0) + "}");
    return;
}
out.print("{\"success\":false}");
%>