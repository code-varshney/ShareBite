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
String statusParam = request.getParameter("status");
if (idParam == null || statusParam == null) {
    response.sendRedirect("donorDashboard.jsp?error=missing_fields");
    return;
}
int foodId = Integer.parseInt(idParam);
FoodListingBean food = FoodListingDAO.getFoodListingById(foodId);
if (food == null || food.getDonorId() != Integer.parseInt(userId)) {
    response.sendRedirect("donorDashboard.jsp?error=not_found");
    return;
}
food.setStatus(statusParam);
int updated = FoodListingDAO.updateFoodListing(food);
if (updated > 0) {
    response.sendRedirect("donorDashboard.jsp?success=status_updated");
} else {
    response.sendRedirect("donorDashboard.jsp?error=status_update_failed");
}
%>