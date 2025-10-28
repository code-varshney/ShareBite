<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="java.util.*" %>

<%
// Get form parameters
String organizationName = request.getParameter("organizationName");
String organizationType = request.getParameter("organizationType");
String registrationNumber = request.getParameter("registrationNumber");
String mission = request.getParameter("mission");
String contactPerson = request.getParameter("contactPerson");
String contactTitle = request.getParameter("contactTitle");
String email = request.getParameter("email");
String phone = request.getParameter("phone");
String website = request.getParameter("website");
String password = request.getParameter("password");
String address = request.getParameter("address");
String city = request.getParameter("city");
String state = request.getParameter("state");
String zipCode = request.getParameter("zipCode");
String serviceArea = request.getParameter("serviceArea");
String latitude = request.getParameter("latitude");
String longitude = request.getParameter("longitude");

// Validate required fields
if (organizationName == null || organizationType == null || contactPerson == null || 
    email == null || phone == null || password == null || 
    address == null || city == null || state == null || zipCode == null) {
    response.sendRedirect("ngoRegister.jsp?error=missing_fields");
    return;
}

// Check if email already exists
if (UserDAO.isEmailExists(email.trim())) {
    response.sendRedirect("ngoRegister.jsp?error=email_exists");
    return;
}

// Create UserBean
UserBean userBean = new UserBean();
userBean.setPassword(password.trim());
userBean.setName(contactPerson.trim());
userBean.setEmail(email.trim());
userBean.setPhone(phone.trim());
userBean.setCity(city.trim());
userBean.setState(state.trim());
userBean.setZipCode(zipCode.trim());
userBean.setUserType("ngo");
userBean.setOrganizationName(organizationName.trim());
// Auto-verify NGOs if platform setting is enabled
String autoVerifyDonors = (String)session.getAttribute("autoVerifyDonors");
if ("true".equals(autoVerifyDonors)) {
    userBean.setVerificationStatus("verified");
} else {
    userBean.setVerificationStatus("pending");
}
userBean.setActive(true);
String fullAddress = address.trim() + ", " + city.trim() + ", " + state.trim() + " - " + zipCode.trim();
userBean.setFullAddress(fullAddress);

// Attempt registration
int registrationStatus = UserDAO.register(userBean);

if (registrationStatus > 0) {
    // Registration successful
    // Get the new user ID (fetch by email)
    int userId = 0;
    try {
        java.sql.Connection con = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
        java.sql.PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE email=? ORDER BY id DESC LIMIT 1");
        ps.setString(1, email.trim());
        java.sql.ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            userId = rs.getInt("id");
        }
        rs.close();
        ps.close();
        con.close();
    } catch (Exception e) { e.printStackTrace(); }

    // Insert extra NGO details
    com.net.DAO.NGODetailsDAO.insertNGODetails(userId, registrationNumber, mission, contactPerson, contactTitle, website, serviceArea);
    
    // Update user coordinates if provided
    if (latitude != null && longitude != null && !latitude.trim().isEmpty() && !longitude.trim().isEmpty()) {
        try {
            java.sql.Connection con2 = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
            java.sql.PreparedStatement ps2 = con2.prepareStatement("UPDATE users SET latitude=?, longitude=? WHERE id=?");
            ps2.setDouble(1, Double.parseDouble(latitude.trim()));
            ps2.setDouble(2, Double.parseDouble(longitude.trim()));
            ps2.setInt(3, userId);
            ps2.executeUpdate();
            ps2.close();
            con2.close();
        } catch (Exception e) { e.printStackTrace(); }
    }

    response.sendRedirect("ngoLogin.jsp?success=registration_pending");
} else {
    // Registration failed
    response.sendRedirect("ngoRegister.jsp?error=registration_failed");
}
%>
