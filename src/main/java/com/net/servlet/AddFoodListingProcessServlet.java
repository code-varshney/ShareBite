package com.net.servlet;

import com.net.bean.FoodListingBean;
import com.net.DAO.FoodListingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.*;
import java.time.LocalDate;

@WebServlet("/AddFoodListingProcessServlet")
@MultipartConfig
public class AddFoodListingProcessServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        String userType = (String) request.getSession().getAttribute("userType");
        String userId = (String) request.getSession().getAttribute("userId");
        if (userType == null || !"donor".equals(userType) || userId == null) {
            response.sendRedirect("donorLogin.jsp?error=not_authorized");
            return;
        }
        try {
            String foodName = getValue(request.getPart("foodName"));
            String description = getValue(request.getPart("description"));
            String quantity = getValue(request.getPart("quantity"));
            String quantityUnit = getValue(request.getPart("quantityUnit"));
            String foodType = getValue(request.getPart("foodType"));
            String expiryDate = getValue(request.getPart("expiryDate"));
            String pickupAddress = getValue(request.getPart("pickupAddress"));
            String pickupCity = getValue(request.getPart("pickupCity"));
            String pickupState = getValue(request.getPart("pickupState"));
            String pickupZipCode = getValue(request.getPart("pickupZipCode"));
            String pickupInstructions = getValue(request.getPart("pickupInstructions"));
            String status = getValue(request.getPart("status"));
            String storageCondition = getValue(request.getPart("storageCondition"));
            String allergenInfo = getValue(request.getPart("allergenInfo"));
            String specialNotes = getValue(request.getPart("specialNotes"));

            // Validate required fields
            String missingField = null;
            if (foodName == null || foodName.trim().isEmpty()) missingField = "foodName";
            else if (quantity == null || quantity.trim().isEmpty()) missingField = "quantity";
            else if (quantityUnit == null || quantityUnit.trim().isEmpty()) missingField = "quantityUnit";
            else if (foodType == null || foodType.trim().isEmpty()) missingField = "foodType";
            else if (expiryDate == null || expiryDate.trim().isEmpty()) missingField = "expiryDate";
            else if (pickupAddress == null || pickupAddress.trim().isEmpty()) missingField = "pickupAddress";
            else if (pickupCity == null || pickupCity.trim().isEmpty()) missingField = "pickupCity";
            else if (pickupState == null || pickupState.trim().isEmpty()) missingField = "pickupState";
            else if (pickupZipCode == null || pickupZipCode.trim().isEmpty()) missingField = "pickupZipCode";
            if (missingField != null) {
                response.sendRedirect("addFoodListing.jsp?error=missing_" + missingField);
                return;
            }

            // Validate expiry date
            try {
                LocalDate expiry = LocalDate.parse(expiryDate);
                LocalDate today = LocalDate.now();
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
                    String uploadPath = getServletContext().getRealPath("/uploads");
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    String fileName = System.currentTimeMillis() + "_" + filePart.getSubmittedFileName();
                    String filePath = uploadPath + File.separator + fileName;
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
            foodListing.setStatus(status != null && !status.isEmpty() ? status.trim() : "Available");
            foodListing.setImageUrl(imageUrl);
            foodListing.setActive(true);
            foodListing.setStorageCondition(storageCondition != null ? storageCondition.trim() : "");
            foodListing.setAllergenInfo(allergenInfo != null ? allergenInfo.trim() : "");
            foodListing.setSpecialNotes(specialNotes != null ? specialNotes.trim() : "");

            int listingStatus = FoodListingDAO.createFoodListing(foodListing);
            if (listingStatus > 0) {
                response.sendRedirect("donorDashboard.jsp?success=listing_created");
            } else {
                response.sendRedirect("addFoodListing.jsp?error=creation_failed");
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            response.sendRedirect("addFoodListing.jsp?error=server_error");
        }
    }

    private String getValue(Part part) throws IOException {
        if (part == null) return null;
        try (InputStream is = part.getInputStream()) {
            java.util.Scanner s = new java.util.Scanner(is).useDelimiter("\\A");
            String val = s.hasNext() ? s.next() : "";
            s.close();
            return val;
        }
    }
}
