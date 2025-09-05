package com.net.bean;

import java.sql.Timestamp;

public class FoodListingBean {
    private int id;
    private int donorId;
    private String foodName;
    private String description;
    private int quantity;
    private String quantityUnit; // "kg", "pieces", "boxes", etc.
    private String foodType; // "fresh", "canned", "baked", "dairy", "frozen"
    private String expiryDate;
    private String pickupAddress;
    private String pickupCity;
    private String pickupState;
    private String pickupZipCode;
    private String pickupInstructions;
    private String status; // "available", "reserved", "picked_up", "expired"
    private String imageUrl;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isActive;

    // Default constructor
    public FoodListingBean() {}

    // Constructor with parameters
    public FoodListingBean(int donorId, String foodName, String description, int quantity, 
                          String quantityUnit, String foodType, String expiryDate, 
                          String pickupAddress, String pickupCity, String pickupState, 
                          String pickupZipCode, String pickupInstructions) {
        this.donorId = donorId;
        this.foodName = foodName;
        this.description = description;
        this.quantity = quantity;
        this.quantityUnit = quantityUnit;
        this.foodType = foodType;
        this.expiryDate = expiryDate;
        this.pickupAddress = pickupAddress;
        this.pickupCity = pickupCity;
        this.pickupState = pickupState;
        this.pickupZipCode = pickupZipCode;
        this.pickupInstructions = pickupInstructions;
        this.status = "available";
        this.isActive = true;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getDonorId() {
        return donorId;
    }

    public void setDonorId(int donorId) {
        this.donorId = donorId;
    }

    public String getFoodName() {
        return foodName;
    }

    public void setFoodName(String foodName) {
        this.foodName = foodName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getQuantityUnit() {
        return quantityUnit;
    }

    public void setQuantityUnit(String quantityUnit) {
        this.quantityUnit = quantityUnit;
    }

    public String getFoodType() {
        return foodType;
    }

    public void setFoodType(String foodType) {
        this.foodType = foodType;
    }

    public String getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(String expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getPickupAddress() {
        return pickupAddress;
    }

    public void setPickupAddress(String pickupAddress) {
        this.pickupAddress = pickupAddress;
    }

    public String getPickupCity() {
        return pickupCity;
    }

    public void setPickupCity(String pickupCity) {
        this.pickupCity = pickupCity;
    }

    public String getPickupState() {
        return pickupState;
    }

    public void setPickupState(String pickupState) {
        this.pickupState = pickupState;
    }

    public String getPickupZipCode() {
        return pickupZipCode;
    }

    public void setPickupZipCode(String pickupZipCode) {
        this.pickupZipCode = pickupZipCode;
    }

    public String getPickupInstructions() {
        return pickupInstructions;
    }

    public void setPickupInstructions(String pickupInstructions) {
        this.pickupInstructions = pickupInstructions;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }
}
