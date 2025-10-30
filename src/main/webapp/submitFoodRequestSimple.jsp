<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.DAO.NotificationDAO" %>
<%@ page import="java.sql.*" %>

<%
// Check if user is logged in and is an NGO
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || !"ngo".equals(userType) || userId == null) {
    response.sendRedirect("ngoLogin.jsp?error=not_authorized");
    return;
}

// Get form parameters
String foodListingId = request.getParameter("foodListingId");
String pickupDate = request.getParameter("pickupDate");
String pickupTime = request.getParameter("pickupTime");
String requestMessage = request.getParameter("requestMessage");
String requestedQuantity = request.getParameter("requestedQuantity");

// Validate required fields
if (foodListingId == null || foodListingId.trim().isEmpty() ||
    pickupDate == null || pickupDate.trim().isEmpty() ||
    requestedQuantity == null || requestedQuantity.trim().isEmpty()) {
    response.sendRedirect("ngoDashboard.jsp?error=missing_fields");
    return;
}

try {
    // Create FoodRequestBean directly without checking food listing
    FoodRequestBean foodRequest = new FoodRequestBean();
    foodRequest.setNgoId(Integer.parseInt(userId));
    foodRequest.setFoodListingId(Integer.parseInt(foodListingId));
    foodRequest.setPickupDate(pickupDate.trim());
    foodRequest.setPickupTime(pickupTime != null ? pickupTime.trim() : "");
    foodRequest.setRequestMessage(requestMessage != null ? requestMessage.trim() : "");
    foodRequest.setRequestedQuantity(Double.parseDouble(requestedQuantity.trim()));
    foodRequest.setStatus("pending");
    foodRequest.setActive(true);
    
    // Submit the request
    int result = FoodRequestDAO.createFoodRequest(foodRequest);
    
    if (result > 0) {
        // Get food listing and NGO details for notification
        FoodListingBean foodListing = FoodListingDAO.getFoodListingById(Integer.parseInt(foodListingId));
        
        if (foodListing != null) {
            // Get NGO name from database
            String ngoName = "NGO";
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
                PreparedStatement ps = con.prepareStatement("SELECT name, organizationName FROM users WHERE id = ?");
                ps.setInt(1, Integer.parseInt(userId));
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    String orgName = rs.getString("organizationName");
                    String userName = rs.getString("name");
                    ngoName = (orgName != null && !orgName.isEmpty()) ? orgName : userName;
                }
                rs.close();
                ps.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
            
            // Create notification for donor
            System.out.println("DEBUG: Creating notification for donor ID: " + foodListing.getDonorId());
            System.out.println("DEBUG: NGO Name: " + ngoName + ", Food: " + foodListing.getFoodName());
            
            boolean notificationCreated = NotificationDAO.notifyDonorAboutFoodRequest(
                foodListing.getDonorId(), 
                Integer.parseInt(userId), 
                Integer.parseInt(foodListingId), 
                ngoName, 
                foodListing.getFoodName()
            );
            
            System.out.println("DEBUG: Notification created: " + notificationCreated);
        }
        
        response.sendRedirect("ngoDashboard.jsp?success=request_submitted");
    } else {
        response.sendRedirect("ngoDashboard.jsp?error=request_failed");
    }
    
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("ngoDashboard.jsp?error=request_failed");
}
%>