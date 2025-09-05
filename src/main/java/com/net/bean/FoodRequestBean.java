package com.net.bean;

import java.sql.Timestamp;

public class FoodRequestBean {
    private int id;
    private int ngoId;
    private int foodListingId;
    private String requestMessage;
    private String pickupDate;
    private String pickupTime;
    private String status; // "pending", "approved", "rejected", "completed"
    private String donorResponse;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private boolean isActive;

    // Default constructor
    public FoodRequestBean() {}

    // Constructor with parameters
    public FoodRequestBean(int ngoId, int foodListingId, String requestMessage, 
                          String pickupDate, String pickupTime) {
        this.ngoId = ngoId;
        this.foodListingId = foodListingId;
        this.requestMessage = requestMessage;
        this.pickupDate = pickupDate;
        this.pickupTime = pickupTime;
        this.status = "pending";
        this.isActive = true;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getNgoId() {
        return ngoId;
    }

    public void setNgoId(int ngoId) {
        this.ngoId = ngoId;
    }

    public int getFoodListingId() {
        return foodListingId;
    }

    public void setFoodListingId(int foodListingId) {
        this.foodListingId = foodListingId;
    }

    public String getRequestMessage() {
        return requestMessage;
    }

    public void setRequestMessage(String requestMessage) {
        this.requestMessage = requestMessage;
    }

    public String getPickupDate() {
        return pickupDate;
    }

    public void setPickupDate(String pickupDate) {
        this.pickupDate = pickupDate;
    }

    public String getPickupTime() {
        return pickupTime;
    }

    public void setPickupTime(String pickupTime) {
        this.pickupTime = pickupTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDonorResponse() {
        return donorResponse;
    }

    public void setDonorResponse(String donorResponse) {
        this.donorResponse = donorResponse;
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
