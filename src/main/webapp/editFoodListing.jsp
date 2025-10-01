<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.FoodListingBean" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="java.util.*" %>
<%
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");
if (userType == null || !"donor".equals(userType) || userId == null) {
    response.sendRedirect("donorLogin.jsp?error=not_authorized");
    return;
}
String foodIdParam = request.getParameter("id");
if (foodIdParam == null) {
    response.sendRedirect("donorDashboard.jsp?error=missing_id");
    
    return;
}
int foodId = Integer.parseInt(foodIdParam);
FoodListingBean food = FoodListingDAO.getFoodListingById(foodId);
if (food == null || food.getDonorId() != Integer.parseInt(userId)) {
    response.sendRedirect("donorDashboard.jsp?error=not_found");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Food Listing - Sharebite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h4 class="mb-0"><i class="fas fa-edit me-2"></i>Edit Food Listing</h4>
                    </div>
                    <div class="card-body">
                        <form action="editFoodListingProcess.jsp" method="post">
                            <input type="hidden" name="id" value="<%= food.getId() %>" />
                            <div class="mb-3">
                                <label class="form-label">Food Name</label>
                                <input type="text" class="form-control" value="<%= food.getFoodName() %>" disabled />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Quantity <span class="text-danger">*</span></label>
                                <input type="number" class="form-control" name="quantity" value="<%= food.getQuantity() %>" min="1" step="0.1" required />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Unit</label>
                                <input type="text" class="form-control" value="<%= food.getQuantityUnit() %>" disabled />
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Pickup Instructions</label>
                                <textarea class="form-control" name="pickupInstructions" rows="2"><%= food.getPickupInstructions() != null ? food.getPickupInstructions() : "" %></textarea>
                            </div>
                            <div class="mb-3">
                                <label class="form-label">Status <span class="text-danger">*</span></label>
                                <select class="form-select" name="status" required>
                                    <option value="Available" <%= "Available".equals(food.getStatus()) ? "selected" : "" %>>Available</option>
                                    <option value="Reserved" <%= "Reserved".equals(food.getStatus()) ? "selected" : "" %>>Reserved</option>
                                    <option value="Collected" <%= "Collected".equals(food.getStatus()) ? "selected" : "" %>>Collected</option>
                                    <option value="Expired" <%= "Expired".equals(food.getStatus()) ? "selected" : "" %>>Expired</option>
                                </select>
                            </div>
                            <div class="d-flex gap-2">
                                <button type="submit" class="btn btn-success">
                                    <i class="fas fa-save me-2"></i>Save Changes
                                </button>
                                <a href="donorDashboard.jsp" class="btn btn-secondary">
                                    <i class="fas fa-times me-2"></i>Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
