<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="java.util.*" %>

<%
// Get form parameters
String email = request.getParameter("email");
String password = request.getParameter("password");

// Validate input
if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
    response.sendRedirect("donorLogin.jsp?error=empty_fields");
    return;
}

// Create UserBean for login
UserBean userBean = new UserBean();
userBean.setEmail(email.trim());
userBean.setPassword(password.trim());

// DEBUG: Print email and password being used for login
out.println("DEBUG: Email=" + email + ", Password=" + password + "<br>");

// Attempt login
int loginStatus = UserDAO.login(userBean);
// DEBUG: Print loginStatus
out.println("DEBUG: loginStatus=" + loginStatus + "<br>");

if (loginStatus == 1) {
    // Login successful
    String userType = userBean.getUserType();
    String verificationStatus = userBean.getVerificationStatus();
    
    // Check if user is a donor
    if (!"donor".equals(userType)) {
        response.sendRedirect("donorLogin.jsp?error=not_donor");
        return;
    }
    
    // Verification status check removed
    
    // Create session
    session.setAttribute("userId", String.valueOf(userBean.getId()));
    session.setAttribute("email", userBean.getEmail());
    session.setAttribute("userType", userBean.getUserType());
    session.setAttribute("userName", userBean.getName());
    session.setAttribute("verificationStatus", userBean.getVerificationStatus());
    
    // Redirect to donor dashboard
    response.sendRedirect("donorDashboard.jsp");
    
} else {
    // Login failed - print debug info and do not redirect
    out.println("<b>Login failed. Please check the debug info above and your database record.</b>");
}
%>
