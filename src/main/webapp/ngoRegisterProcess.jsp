<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.*" %>

<%
try {
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

    // Debug: Log received parameters
    System.out.println("NGO Registration - Organization: " + organizationName + ", Email: " + email);

    // Validate required fields
    if (organizationName == null || organizationType == null || contactPerson == null || 
        email == null || phone == null || password == null || 
        address == null || city == null || state == null || zipCode == null) {
        System.out.println("Missing required fields");
        response.sendRedirect("ngoRegister.jsp?error=missing_fields");
        return;
    }

    // Check if email already exists
    if (UserDAO.isEmailExists(email.trim())) {
        System.out.println("Email already exists: " + email);
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
    userBean.setVerificationStatus("pending");
    userBean.setActive(true);
    String fullAddress = address.trim() + ", " + city.trim() + ", " + state.trim() + " - " + zipCode.trim();
    userBean.setFullAddress(fullAddress);

    System.out.println("Attempting to register user: " + email);
    
    // Attempt registration
    int registrationStatus = UserDAO.register(userBean);
    System.out.println("Registration status: " + registrationStatus);

    if (registrationStatus > 0) {
        // Registration successful - get the new user ID
        int userId = 0;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
            PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE email=? ORDER BY id DESC LIMIT 1");
            ps.setString(1, email.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                userId = rs.getInt("id");
                System.out.println("Retrieved user ID: " + userId);
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) { 
            System.out.println("Error getting user ID: " + e.getMessage());
            e.printStackTrace(); 
        }

        // Insert extra NGO details if userId was found
        if (userId > 0) {
            try {
                int ngoDetailsStatus = com.net.DAO.NGODetailsDAO.insertNGODetails(userId, registrationNumber, mission, contactPerson, contactTitle, website, serviceArea);
                System.out.println("NGO details insert status: " + ngoDetailsStatus);
            } catch (Exception e) {
                System.out.println("Error inserting NGO details: " + e.getMessage());
                e.printStackTrace();
            }
            
            // Update user coordinates if provided
            if (latitude != null && longitude != null && !latitude.trim().isEmpty() && !longitude.trim().isEmpty()) {
                try {
                    Connection con2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
                    PreparedStatement ps2 = con2.prepareStatement("UPDATE users SET latitude=?, longitude=? WHERE id=?");
                    ps2.setDouble(1, Double.parseDouble(latitude.trim()));
                    ps2.setDouble(2, Double.parseDouble(longitude.trim()));
                    ps2.setInt(3, userId);
                    int coordStatus = ps2.executeUpdate();
                    System.out.println("Coordinates update status: " + coordStatus);
                    ps2.close();
                    con2.close();
                } catch (Exception e) { 
                    System.out.println("Error updating coordinates: " + e.getMessage());
                    e.printStackTrace(); 
                }
            }
        }

        System.out.println("Registration completed successfully");
        response.sendRedirect("ngoLogin.jsp?success=registration_pending");
    } else {
        // Registration failed
        System.out.println("Registration failed - status: " + registrationStatus);
        response.sendRedirect("ngoRegister.jsp?error=registration_failed");
    }
} catch (Exception e) {
    System.out.println("Exception in NGO registration: " + e.getMessage());
    e.printStackTrace();
    response.sendRedirect("ngoRegister.jsp?error=system_error");
}
%>
