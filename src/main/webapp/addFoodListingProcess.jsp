<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="java.util.*" %>

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
String status = request.getParameter("status");
String storageCondition = request.getParameter("storageCondition");
String allergenInfo = request.getParameter("allergenInfo");
String specialNotes = request.getParameter("specialNotes");
String latitude = request.getParameter("latitude");
String longitude = request.getParameter("longitude");

// Validate required fields
if (foodName == null || foodName.trim().isEmpty() ||
    quantity == null || quantity.trim().isEmpty() ||
    quantityUnit == null || quantityUnit.trim().isEmpty() ||
    foodType == null || foodType.trim().isEmpty() ||
    expiryDate == null || expiryDate.trim().isEmpty() ||
    pickupAddress == null || pickupAddress.trim().isEmpty() ||
    pickupCity == null || pickupCity.trim().isEmpty() ||
    pickupState == null || pickupState.trim().isEmpty() ||
    pickupZipCode == null || pickupZipCode.trim().isEmpty()) {
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
foodListing.setStatus(status != null && !status.isEmpty() ? status.trim().toLowerCase() : "available");
foodListing.setImageUrl(""); // No image upload in JSP
foodListing.setActive(true);
foodListing.setStorageCondition(storageCondition != null ? storageCondition.trim() : "");
foodListing.setAllergenInfo(allergenInfo != null ? allergenInfo.trim() : "");
foodListing.setSpecialNotes(specialNotes != null ? specialNotes.trim() : "");

// Set location coordinates if provided
if (latitude != null && !latitude.trim().isEmpty() && longitude != null && !longitude.trim().isEmpty()) {
    try {
        foodListing.setLatitude(Double.parseDouble(latitude.trim()));
        foodListing.setLongitude(Double.parseDouble(longitude.trim()));
    } catch (NumberFormatException e) {
        // If coordinates are invalid, set to 0
        foodListing.setLatitude(0.0);
        foodListing.setLongitude(0.0);
    }
} else {
    foodListing.setLatitude(0.0);
    foodListing.setLongitude(0.0);
}

// Attempt to create food listing
int listingStatus = FoodListingDAO.createFoodListing(foodListing);

if (listingStatus > 0) {
    response.sendRedirect("donorDashboard.jsp?success=listing_created");
} else {
    response.sendRedirect("addFoodListing.jsp?error=creation_failed");
}
%>