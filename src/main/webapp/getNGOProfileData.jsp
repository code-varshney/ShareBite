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
    
    // Get user basic info
    UserBean user = UserDAO.getUserById(ngoUserId);
    
    // Get NGO specific details
    NGODetailsBean ngoDetails = NGODetailsDAO.getNGODetailsByUserId(ngoUserId);
    
    if (user != null) {
        jsonResponse.put("status", "SUCCESS");
        jsonResponse.put("organizationName", user.getName() != null ? user.getName() : "");
        jsonResponse.put("email", user.getEmail() != null ? user.getEmail() : "");
        jsonResponse.put("phone", user.getPhone() != null ? user.getPhone() : "");
        jsonResponse.put("address", user.getFullAddress() != null ? user.getFullAddress() : "");
        jsonResponse.put("organizationType", user.getOrganizationType() != null ? user.getOrganizationType() : "");
        jsonResponse.put("verificationStatus", user.getVerificationStatus() != null ? user.getVerificationStatus() : "");
        
        if (ngoDetails != null) {
            jsonResponse.put("registrationNumber", ngoDetails.getRegistrationNumber() != null ? ngoDetails.getRegistrationNumber() : "");
            jsonResponse.put("mission", ngoDetails.getMission() != null ? ngoDetails.getMission() : "");
            jsonResponse.put("contactPerson", ngoDetails.getContactPerson() != null ? ngoDetails.getContactPerson() : "");
            jsonResponse.put("contactTitle", ngoDetails.getContactTitle() != null ? ngoDetails.getContactTitle() : "");
            jsonResponse.put("website", ngoDetails.getWebsite() != null ? ngoDetails.getWebsite() : "");
            jsonResponse.put("serviceArea", ngoDetails.getServiceArea() != null ? ngoDetails.getServiceArea() : "");
        } else {
            jsonResponse.put("registrationNumber", "");
            jsonResponse.put("mission", "");
            jsonResponse.put("contactPerson", "");
            jsonResponse.put("contactTitle", "");
            jsonResponse.put("website", "");
            jsonResponse.put("serviceArea", "");
        }
    } else {
        jsonResponse.put("status", "ERROR");
        jsonResponse.put("message", "User not found");
    }
    
} catch (Exception e) {
    jsonResponse.put("status", "ERROR");
    jsonResponse.put("message", "Error fetching profile data: " + e.getMessage());
}

out.print(jsonResponse.toString());
%>