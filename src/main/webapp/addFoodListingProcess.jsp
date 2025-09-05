<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>

<%
// Check if user is logged in and is a donor
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || !"donor".equals(userType) || userId == null) {
    response.sendRedirect("donorLogin.jsp?error=not_authorized");
    return;
}

// Get form parameters
String foodName = request.getParameter("foodName");
String description = request.getParameter("description");
String quantity = request.getParameter("quantity");
String quantityUnit = request.getParameter("quantityUnit");
String foodType = request.getParameter("foodType");
String expiryDate = request.getParameter("expiryDate");
String pickupAddress = request.getParameter("pickupAddress");
String pickupCity = request.getParameter("pickupCity");
String pickupState = request.getParameter("pickupState");
String pickupZipCode = request.getParameter("pickupZipCode");
String pickupInstructions = request.getParameter("pickupInstructions");
String storageCondition = request.getParameter("storageCondition");
String allergenInfo = request.getParameter("allergenInfo");
String specialNotes = request.getParameter("specialNotes");

// Validate required fields
if (foodName == null || quantity == null || quantityUnit == null || foodType == null || 
    expiryDate == null || pickupAddress == null || pickupCity == null || 
    pickupState == null || pickupZipCode == null) {
    response.sendRedirect("addFoodListing.jsp?error=missing_fields");
    return;
}

// Validate expiry date
try {
    java.time.LocalDate expiry = java.time.LocalDate.parse(expiryDate);
    java.time.LocalDate today = java.time.LocalDate.now();
    if (expiry.isBefore(today) || expiry.isEqual(today)) {
        response.sendRedirect("addFoodListing.jsp?error=invalid_expiry");
        return;
    }
} catch (Exception e) {
    response.sendRedirect("addFoodListing.jsp?error=invalid_expiry");
    return;
}

// Handle image upload
String imageUrl = "";
Part filePart = request.getPart("foodImage");
if (filePart != null && filePart.getSize() > 0) {
    try {
        // Create uploads directory if it doesn't exist
        String uploadPath = getServletContext().getRealPath("/uploads");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        
        // Generate unique filename
        String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
        String filePath = uploadPath + File.separator + fileName;
        
        // Save file
        try (InputStream input = filePart.getInputStream();
             OutputStream output = new FileOutputStream(filePath)) {
            byte[] buffer = new byte[1024];
            int length;
            while ((length = input.read(buffer)) > 0) {
                output.write(buffer, 0, length);
            }
        }
        
        imageUrl = "uploads/" + fileName;
    } catch (Exception e) {
        // Log error but continue without image
        System.err.println("Error uploading image: " + e.getMessage());
    }
}

// Create FoodListingBean
FoodListingBean foodListing = new FoodListingBean();
foodListing.setDonorId(Integer.parseInt(userId));
foodListing.setFoodName(foodName.trim());
foodListing.setDescription(description != null ? description.trim() : "");
foodListing.setQuantity(Integer.parseInt(quantity));
foodListing.setQuantityUnit(quantityUnit.trim());
foodListing.setFoodType(foodType.trim());
foodListing.setExpiryDate(expiryDate.trim());
foodListing.setPickupAddress(pickupAddress.trim());
foodListing.setPickupCity(pickupCity.trim());
foodListing.setPickupState(pickupState.trim());
foodListing.setPickupZipCode(pickupZipCode.trim());
foodListing.setPickupInstructions(pickupInstructions != null ? pickupInstructions.trim() : "");
foodListing.setStatus("available");
foodListing.setImageUrl(imageUrl);
foodListing.setActive(true);

// Attempt to create food listing
int listingStatus = FoodListingDAO.createFoodListing(foodListing);

if (listingStatus > 0) {
    // Food listing created successfully
    response.sendRedirect("donorDashboard.jsp?success=listing_created");
} else {
    // Food listing creation failed
    response.sendRedirect("addFoodListing.jsp?error=creation_failed");
}
%>
