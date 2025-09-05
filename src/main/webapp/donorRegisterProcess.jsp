<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="java.util.*" %>

<%
// Get form parameters
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String email = request.getParameter("email");
String password = request.getParameter("password");
String confirmPassword = request.getParameter("confirmPassword");
String phone = request.getParameter("phone");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String zipCode = request.getParameter("zipCode");
String organizationName = request.getParameter("organizationName");
String organizationType = request.getParameter("organizationType");
String donationFrequency = request.getParameter("donationFrequency");
String termsAccepted = request.getParameter("termsAccepted");

// Validate required fields
if (firstName == null || lastName == null || email == null || 
    password == null || confirmPassword == null || phone == null || address == null || city == null || 
    state == null || zipCode == null || termsAccepted == null) {
    response.sendRedirect("donorRegister.jsp?error=missing_fields");
    return;
}

// Password match and length validation
if (!password.equals(confirmPassword)) {
    response.sendRedirect("donorRegister.jsp?error=password_mismatch");
    return;
}
if (password.length() < 6) {
    response.sendRedirect("donorRegister.jsp?error=password_short");
    return;
}

// Check if email already exists
if (UserDAO.isEmailExists(email.trim())) {
    response.sendRedirect("donorRegister.jsp?error=email_exists");
    return;
}

// Create UserBean
UserBean userBean = new UserBean();
userBean.setPassword(password.trim());
userBean.setName(firstName.trim() + " " + lastName.trim());
userBean.setEmail(email.trim());
userBean.setPhone(phone.trim());
String fullAddress = address.trim() + ", " + city.trim() + ", " + state.trim() + " - " + zipCode.trim();
userBean.setAddress(fullAddress);
userBean.setUserType("donor");
userBean.setOrganizationName(organizationName != null ? organizationName.trim() : "");
userBean.setOrganizationType(organizationType != null ? organizationType.trim() : "");
userBean.setDonationFrequency(donationFrequency != null ? donationFrequency.trim() : "");
userBean.setVerificationStatus("verified"); // Donors are auto-verified
userBean.setActive(true);

// Attempt registration
int registrationStatus = UserDAO.register(userBean);

if (registrationStatus > 0) {
    // Registration successful
    response.sendRedirect("donorLogin.jsp?success=registration_complete");
} else {
    // Registration failed
    response.sendRedirect("donorRegister.jsp?error=registration_failed");
}
%>
