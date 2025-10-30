<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.DAO.NotificationDAO" %>

<%
System.out.println("=== SUBMIT FOOD REQUEST DEBUG START ===");

// Check if user is logged in and is an NGO
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");
String ngoName = (String) session.getAttribute("organizationName");
if (ngoName == null) ngoName = (String) session.getAttribute("userName");

System.out.println("DEBUG: Session - userType: " + userType + ", userId: " + userId + ", ngoName: " + ngoName);

if (userType == null || !"ngo".equals(userType) || userId == null) {
    System.out.println("DEBUG: Authorization failed - redirecting to login");
    response.sendRedirect("ngoLogin.jsp?error=not_authorized");
    return;
}

// Get form parameters
String foodListingId = request.getParameter("foodListingId");
String pickupDate = request.getParameter("pickupDate");
String pickupTime = request.getParameter("pickupTime");
String requestMessage = request.getParameter("requestMessage");

System.out.println("DEBUG: Form parameters - foodListingId: " + foodListingId + ", pickupDate: " + pickupDate + ", pickupTime: " + pickupTime);

// Validate required fields
if (foodListingId == null || foodListingId.trim().isEmpty() ||
    pickupDate == null || pickupDate.trim().isEmpty()) {
    System.out.println("DEBUG: Missing required fields - redirecting with error");
    response.sendRedirect("ngoDashboard.jsp?error=missing_fields");
    return;
}

try {
    System.out.println("DEBUG: Getting food listing details for ID: " + foodListingId);
    
    // Get food listing details to get donor ID and food name
    FoodListingBean foodListing = FoodListingDAO.getFoodListingById(Integer.parseInt(foodListingId));
    
    if (foodListing == null) {
        System.out.println("DEBUG: Food listing not found for ID: " + foodListingId);
        
        // Check if food listing exists but is inactive
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            java.sql.Connection debugCon = java.sql.DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
            java.sql.PreparedStatement debugPs = debugCon.prepareStatement("SELECT id, foodName, status, isActive FROM food_listings WHERE id=?");
            debugPs.setInt(1, Integer.parseInt(foodListingId));
            java.sql.ResultSet debugRs = debugPs.executeQuery();
            
            if (debugRs.next()) {
                System.out.println("DEBUG: Food listing exists but - ID: " + debugRs.getInt("id") + ", Name: " + debugRs.getString("foodName") + ", Status: " + debugRs.getString("status") + ", Active: " + debugRs.getBoolean("isActive"));
            } else {
                System.out.println("DEBUG: Food listing with ID " + foodListingId + " does not exist in database");
            }
            
            debugRs.close();
            debugPs.close();
            debugCon.close();
        } catch (Exception debugEx) {
            System.out.println("DEBUG: Error checking food listing: " + debugEx.getMessage());
        }
        
        response.sendRedirect("ngoDashboard.jsp?error=food_not_found");
        return;
    }
    
    System.out.println("DEBUG: Food listing found - Name: " + foodListing.getFoodName() + ", Donor ID: " + foodListing.getDonorId());
    
    // Check if NGO already has an active request for this food listing
    int ngoId = Integer.parseInt(userId);
    int listingId = Integer.parseInt(foodListingId);
    
    if (FoodRequestDAO.hasActiveRequest(ngoId, listingId)) {
        System.out.println("DEBUG: NGO already has active request for this food listing");
        response.sendRedirect("ngoDashboard.jsp?error=already_requested");
        return;
    }
    
    // Create FoodRequestBean
    FoodRequestBean foodRequest = new FoodRequestBean();
    foodRequest.setNgoId(ngoId);
    foodRequest.setFoodListingId(listingId);
    foodRequest.setPickupDate(pickupDate.trim());
    foodRequest.setPickupTime(pickupTime != null ? pickupTime.trim() : "");
    foodRequest.setRequestMessage(requestMessage != null ? requestMessage.trim() : "");
    foodRequest.setStatus("pending");
    foodRequest.setActive(true);
    
    System.out.println("DEBUG: Created FoodRequestBean - NGO ID: " + foodRequest.getNgoId() + ", Food Listing ID: " + foodRequest.getFoodListingId());
    
    // Submit the request
    int result = FoodRequestDAO.createFoodRequest(foodRequest);
    
    System.out.println("DEBUG: FoodRequestDAO.createFoodRequest result: " + result);
    
    if (result > 0) {
        System.out.println("DEBUG: Request created successfully, notifying donor");
        
        try {
            // Notify the donor about the food request
            NotificationDAO.notifyDonorAboutFoodRequest(
                foodListing.getDonorId(), 
                ngoId, 
                listingId, 
                ngoName, 
                foodListing.getFoodName()
            );
            System.out.println("DEBUG: Donor notification sent successfully");
        } catch (Exception notifEx) {
            System.out.println("DEBUG: Error sending donor notification: " + notifEx.getMessage());
            notifEx.printStackTrace();
            // Continue anyway - request was created successfully
        }
        
        System.out.println("DEBUG: Redirecting to success page");
        response.sendRedirect("ngoDashboard.jsp?success=request_submitted");
    } else {
        System.out.println("DEBUG: Request creation failed, redirecting to error page");
        response.sendRedirect("ngoDashboard.jsp?error=request_failed");
    }
    
} catch (Exception e) {
    System.out.println("DEBUG: Exception occurred: " + e.getMessage());
    e.printStackTrace();
    response.sendRedirect("ngoDashboard.jsp?error=request_failed&details=" + e.getMessage());
}

System.out.println("=== SUBMIT FOOD REQUEST DEBUG END ===");
%>