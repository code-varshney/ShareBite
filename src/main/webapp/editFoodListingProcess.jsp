<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");
if (userType == null || !"donor".equals(userType) || userId == null) {
    response.sendRedirect("donorLogin.jsp?error=not_authorized");
    return;
}
String idParam = request.getParameter("id");
String quantityParam = request.getParameter("quantity");
String pickupInstructions = request.getParameter("pickupInstructions");
String status = request.getParameter("status");

if (idParam == null || quantityParam == null || status == null) {
    response.sendRedirect("donorDashboard.jsp?error=missing_fields");
    return;
}
int foodId = Integer.parseInt(idParam);
FoodListingBean food = FoodListingDAO.getFoodListingById(foodId);
if (food == null || food.getDonorId() != Integer.parseInt(userId)) {
    response.sendRedirect("donorDashboard.jsp?error=not_found");
    return;
}
try {
    int quantity = (int) Double.parseDouble(quantityParam);
    food.setQuantity(quantity);
    food.setPickupInstructions(pickupInstructions);
    food.setStatus(status);
    int updated = FoodListingDAO.updateFoodListing(food);
    if (updated > 0) {
        response.sendRedirect("donorDashboard.jsp?success=listing_updated");
    } else {
        response.sendRedirect("editFoodListing.jsp?id=" + foodId + "&error=update_failed");
    }
} catch (Exception e) {
    response.sendRedirect("editFoodListing.jsp?id=" + foodId + "&error=exception");
}
%>