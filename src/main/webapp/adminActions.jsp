<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="java.sql.*" %>
<%
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");

String action = request.getParameter("action");
String idStr = request.getParameter("id");
String status = request.getParameter("status");

try {
    if ("updateVerificationStatus".equals(action) && idStr != null && status != null) {
        int userId = Integer.parseInt(idStr);
        
        // Direct database update
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
        PreparedStatement ps = con.prepareStatement("UPDATE users SET verificationStatus=? WHERE id=?");
        ps.setString(1, status);
        ps.setInt(2, userId);
        int result = ps.executeUpdate();
        ps.close();
        con.close();
        
        out.print("{\"success\":" + (result > 0) + ", \"message\":\"User " + status + " successfully\"}");
        return;
    }
    
    out.print("{\"success\":false, \"message\":\"Invalid parameters\"}");
} catch (Exception e) {
    out.print("{\"success\":false, \"message\":\"Error: " + e.getMessage() + "\"}");
}
%>