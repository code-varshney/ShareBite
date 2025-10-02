<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="com.net.DAO.UserDAO" %>

<%
// Get form parameters
String userId = request.getParameter("userId");
String name = request.getParameter("name");
String email = request.getParameter("email");
String phone = request.getParameter("phone");
String fulladdress = request.getParameter("fulladdress");
if (fulladdress == null) {
    fulladdress = request.getParameter("address");
}
String organizationName = request.getParameter("organizationName");
String donationFrequency = request.getParameter("donationFrequency");

// Validate input
if (userId == null || name == null || email == null || 
    userId.trim().isEmpty() || name.trim().isEmpty() || email.trim().isEmpty()) {
    out.println("ERROR: Required fields are missing");
    return;
}

try {
    // Create UserBean with updated information
    UserBean userBean = new UserBean();
    userBean.setId(Integer.parseInt(userId.trim()));
    userBean.setName(name.trim());
    userBean.setEmail(email.trim());
    userBean.setPhone(phone != null ? phone.trim() : "");
    userBean.setFullAddress(fulladdress != null ? fulladdress.trim() : "");
    userBean.setOrganizationName(organizationName != null ? organizationName.trim() : "");
    userBean.setDonationFrequency(donationFrequency != null ? donationFrequency.trim() : "");
    
    // Update user in database
    int updateStatus = UserDAO.updateUser(userBean);
    
    if (updateStatus > 0) {
        // Update session with new name if changed
        session.setAttribute("userName", name.trim());
        out.println("SUCCESS: Profile updated successfully");
    } else {
        out.println("ERROR: Failed to update profile");
    }
    
} catch (NumberFormatException e) {
    out.println("ERROR: Invalid user ID");
} catch (Exception e) {
    out.println("ERROR: " + e.getMessage());
}
%>