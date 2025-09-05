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
    response.sendRedirect("ngoLogin.jsp?error=empty_fields");
    return;
}

// Create UserBean for login
UserBean userBean = new UserBean();
userBean.setEmail(email.trim());
userBean.setPassword(password.trim());

// Attempt login
int loginStatus = UserDAO.login(userBean);

if (loginStatus == 1) {
    // Login successful
    String userType = userBean.getUserType();
    String verificationStatus = userBean.getVerificationStatus();
    // Check if user is an NGO
    if (!"ngo".equals(userType)) {
        response.sendRedirect("ngoLogin.jsp?error=not_ngo");
        return;
    }
    // Check platform setting for NGO verification requirement
    String requireNgoVerification = (String)session.getAttribute("requireNgoVerification");
    if ("false".equals(requireNgoVerification)) {
        // Allow login regardless of verification status
        session.setAttribute("userId", userBean.getId());
        session.setAttribute("email", userBean.getEmail());
        session.setAttribute("userId", String.valueOf(userBean.getId()));
        session.setAttribute("userType", userBean.getUserType());
        session.setAttribute("userName", userBean.getName());
        session.setAttribute("organizationName", userBean.getOrganizationName());
        session.setAttribute("verificationStatus", userBean.getVerificationStatus());
        response.sendRedirect("ngoDashboard.jsp");
    } else {
        // Handle verification status scenarios
        if ("verified".equals(verificationStatus)) {
            // Create session and login
            session.setAttribute("userId", userBean.getId());
            session.setAttribute("email", userBean.getEmail());
            session.setAttribute("userId", String.valueOf(userBean.getId()));
            session.setAttribute("userType", userBean.getUserType());
            session.setAttribute("userName", userBean.getName());
            session.setAttribute("organizationName", userBean.getOrganizationName());
            session.setAttribute("verificationStatus", userBean.getVerificationStatus());
            response.sendRedirect("ngoDashboard.jsp");
        } else if ("pending".equals(verificationStatus)) {
            response.sendRedirect("ngoLogin.jsp?error=pending");
        } else if ("rejected".equals(verificationStatus)) {
            response.sendRedirect("ngoLogin.jsp?error=rejected");
        } else {
            response.sendRedirect("ngoLogin.jsp?error=invalid_credentials");
        }
    }
} else {
    // Login failed
    response.sendRedirect("ngoLogin.jsp?error=invalid_credentials");
}
%>
