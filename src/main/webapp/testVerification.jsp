<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <title>Test Verification System</title>
</head>
<body>
    <h2>Testing Verification System</h2>
    
    <%
    // Test database connection and methods
    try {
        // Get pending users
        List<UserBean> pendingUsers = UserDAO.getPendingVerificationUsers();
        out.println("<h3>Pending Users: " + (pendingUsers != null ? pendingUsers.size() : 0) + "</h3>");
        
        if (pendingUsers != null && !pendingUsers.isEmpty()) {
            out.println("<table border='1'>");
            out.println("<tr><th>ID</th><th>Name</th><th>Email</th><th>Type</th><th>Status</th></tr>");
            for (UserBean user : pendingUsers) {
                out.println("<tr>");
                out.println("<td>" + user.getId() + "</td>");
                out.println("<td>" + user.getName() + "</td>");
                out.println("<td>" + user.getEmail() + "</td>");
                out.println("<td>" + user.getUserType() + "</td>");
                out.println("<td>" + user.getVerificationStatus() + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
        }
        
        // Test update method if requested
        String testUserId = request.getParameter("testUserId");
        String testStatus = request.getParameter("testStatus");
        
        if (testUserId != null && testStatus != null) {
            int userId = Integer.parseInt(testUserId);
            int result = UserDAO.updateVerificationStatus(userId, testStatus);
            out.println("<h3>Update Result: " + result + "</h3>");
            if (result > 0) {
                out.println("<p style='color: green;'>Successfully updated user " + userId + " to " + testStatus + "</p>");
            } else {
                out.println("<p style='color: red;'>Failed to update user " + userId + "</p>");
            }
        }
        
    } catch (Exception e) {
        out.println("<h3 style='color: red;'>Error: " + e.getMessage() + "</h3>");
        e.printStackTrace();
    }
    %>
    
    <h3>Test Update (Use with caution)</h3>
    <form method="get">
        User ID: <input type="number" name="testUserId" required>
        Status: <select name="testStatus" required>
            <option value="verified">Verified</option>
            <option value="rejected">Rejected</option>
            <option value="pending">Pending</option>
        </select>
        <input type="submit" value="Test Update">
    </form>
    
    <p><a href="adminDashboard.jsp">Back to Admin Dashboard</a></p>
</body>
</html>