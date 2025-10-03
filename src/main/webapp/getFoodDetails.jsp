<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.bean.UserBean" %>

<%
response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");

try {
    String foodIdParam = request.getParameter("id");
    if (foodIdParam == null || foodIdParam.trim().isEmpty()) {
        out.print("{\"status\":\"ERROR\",\"message\":\"Food ID is required\"}");
        return;
    }
    
    int foodId = Integer.parseInt(foodIdParam);
    FoodListingBean food = FoodListingDAO.getFoodListingById(foodId);
    
    if (food != null) {
        // Get donor details
        UserBean donor = UserDAO.getUserById(food.getDonorId());
        
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"status\":\"SUCCESS\",");
        json.append("\"id\":").append(food.getId()).append(",");
        json.append("\"foodName\":\"").append(food.getFoodName() != null ? food.getFoodName().replace("\"", "\\\"") : "").append("\",");
        json.append("\"foodType\":\"").append(food.getFoodType() != null ? food.getFoodType().replace("\"", "\\\"") : "").append("\",");
        json.append("\"quantity\":").append(food.getQuantity()).append(",");
        json.append("\"quantityUnit\":\"").append(food.getQuantityUnit() != null ? food.getQuantityUnit().replace("\"", "\\\"") : "").append("\",");
        json.append("\"expiryDate\":\"").append(food.getExpiryDate() != null ? food.getExpiryDate().replace("\"", "\\\"") : "").append("\",");
        json.append("\"description\":\"").append(food.getDescription() != null ? food.getDescription().replace("\"", "\\\"") : "").append("\",");
        json.append("\"pickupAddress\":\"").append(food.getPickupAddress() != null ? food.getPickupAddress().replace("\"", "\\\"") : "").append("\",");
        json.append("\"pickupCity\":\"").append(food.getPickupCity() != null ? food.getPickupCity().replace("\"", "\\\"") : "").append("\",");
        json.append("\"pickupState\":\"").append(food.getPickupState() != null ? food.getPickupState().replace("\"", "\\\"") : "").append("\",");
        json.append("\"pickupZipCode\":\"").append(food.getPickupZipCode() != null ? food.getPickupZipCode().replace("\"", "\\\"") : "").append("\",");
        json.append("\"pickupInstructions\":\"").append(food.getPickupInstructions() != null ? food.getPickupInstructions().replace("\"", "\\\"") : "").append("\",");
        json.append("\"donorName\":\"").append(donor != null && donor.getName() != null ? donor.getName().replace("\"", "\\\"") : "Unknown Donor").append("\",");
        json.append("\"status_value\":\"").append(food.getStatus() != null ? food.getStatus().replace("\"", "\\\"") : "").append("\"");
        json.append("}");
        
        out.print(json.toString());
    } else {
        out.print("{\"status\":\"ERROR\",\"message\":\"Food listing not found\"}");
    }
    
} catch (Exception e) {
    out.print("{\"status\":\"ERROR\",\"message\":\"Error fetching food details: " + e.getMessage().replace("\"", "\\\"") + "\"}");
}
%>