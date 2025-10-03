<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="com.net.DAO.NGODetailsDAO" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="com.net.bean.NGODetailsBean" %>
<%@ page import="org.json.JSONObject" %>

<%
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");

JSONObject jsonResponse = new JSONObject();

try {
    // Check if user is logged in and is an NGO
    String userType = (String) session.getAttribute("userType");
    String userId = (String) session.getAttribute("userId");
    
    if (userType == null || !"ngo".equals(userType) || userId == null) {
        jsonResponse.put("status", "ERROR");
        jsonResponse.put("message", "Not authorized");
        out.print(jsonResponse.toString());
        return;
    }
    
    int ngoUserId = Integer.parseInt(userId);
    
    // Get form parameters
    String organizationName = request.getParameter("organizationName");
    String email = request.getParameter("email");
    String phone = request.getParameter("phone");
    String address = request.getParameter("address");
    String organizationType = request.getParameter("organizationType");
    String registrationNumber = request.getParameter("registrationNumber");
    String mission = request.getParameter("mission");
    String contactPerson = request.getParameter("contactPerson");
    String contactTitle = request.getParameter("contactTitle");
    String website = request.getParameter("website");
    String serviceArea = request.getParameter("serviceArea");
    
    // Update user basic info
    UserBean user = new UserBean();
    user.setId(ngoUserId);
    user.setName(organizationName);
    user.setEmail(email);
    user.setPhone(phone);
    user.setFullAddress(address);
    user.setOrganizationType(organizationType);
    user.setOrganizationName(organizationName);
    
    boolean userUpdated = UserDAO.updateUser(user);
    
    // Update NGO specific details
    NGODetailsBean ngoDetails = new NGODetailsBean();
    ngoDetails.setUserId(ngoUserId);
    ngoDetails.setRegistrationNumber(registrationNumber != null ? registrationNumber : "");
    ngoDetails.setMission(mission != null ? mission : "");
    ngoDetails.setContactPerson(contactPerson != null ? contactPerson : "");
    ngoDetails.setContactTitle(contactTitle != null ? contactTitle : "");
    ngoDetails.setWebsite(website != null ? website : "");
    ngoDetails.setServiceArea(serviceArea != null ? serviceArea : "");
    
    boolean ngoDetailsUpdated = NGODetailsDAO.updateNGODetailsByUserId(ngoDetails);
    
    if (userUpdated && ngoDetailsUpdated) {
        // Update session if organization name changed
        if (organizationName != null && !organizationName.trim().isEmpty()) {
            session.setAttribute("userName", organizationName);
            session.setAttribute("organizationName", organizationName);
        }
        
        jsonResponse.put("status", "SUCCESS");
        jsonResponse.put("message", "Profile updated successfully");
        jsonResponse.put("organizationName", organizationName);
    } else {
        jsonResponse.put("status", "ERROR");
        jsonResponse.put("message", "Failed to update profile");
    }
    
} catch (Exception e) {
    jsonResponse.put("status", "ERROR");
    jsonResponse.put("message", "Error updating profile: " + e.getMessage());
}

out.print(jsonResponse.toString());
%>