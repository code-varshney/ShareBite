<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="java.sql.Date" %>

<%
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || !"donor".equals(userType) || userId == null) {
    response.sendRedirect("donorLogin.jsp?error=not_authorized");
    return;
}

String foodIdParam = request.getParameter("id");
String foodName = request.getParameter("foodName");
String description = request.getParameter("description");
String quantity = request.getParameter("quantity");
String quantityUnit = request.getParameter("quantityUnit");
String foodType = request.getParameter("foodType");
String expiryDate = request.getParameter("expiryDate");
String storageCondition = request.getParameter("storageCondition");
String pickupInstructions = request.getParameter("pickupInstructions");
String status = request.getParameter("status");

if (foodIdParam == null || foodName == null || quantity == null || status == null) {
    response.sendRedirect("donorDashboard.jsp?error=missing_fields");
    return;
}

try {
    int foodId = Integer.parseInt(foodIdParam);
    int quantityValue = (int) Double.parseDouble(quantity);
    
    FoodListingBean food = FoodListingDAO.getFoodListingById(foodId);
    if (food == null || food.getDonorId() != Integer.parseInt(userId)) {
        response.sendRedirect("donorDashboard.jsp?error=not_authorized");
        return;
    }
    
    food.setFoodName(foodName);
    food.setDescription(description);
    food.setQuantity(quantityValue);
    food.setQuantityUnit(quantityUnit);
    food.setFoodType(foodType);
    food.setExpiryDate(expiryDate != null && !expiryDate.isEmpty() ? expiryDate : null);
    food.setStorageCondition(storageCondition);
    food.setPickupInstructions(pickupInstructions);
    food.setStatus(status);
    
    int result = FoodListingDAO.updateFoodListing(food);
    boolean success = result > 0;
    
    if (success) {
        response.sendRedirect("donorDashboard.jsp?success=updated");
    } else {
        response.sendRedirect("editFoodListing.jsp?id=" + foodId + "&error=update_failed");
    }
    
} catch (Exception e) {
    e.printStackTrace();
    response.sendRedirect("donorDashboard.jsp?error=system_error");
}
%>