package com.net.bean;

public class NotificationBean {
    private int id;
    private int ngoId;
    private int donorId;
    private int foodListingId;
    private String message;
    private String type;
    private boolean isRead;
    private String createdAt;
    private String donorName;
    private String foodName;

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public int getNgoId() { return ngoId; }
    public void setNgoId(int ngoId) { this.ngoId = ngoId; }
    
    public int getDonorId() { return donorId; }
    public void setDonorId(int donorId) { this.donorId = donorId; }
    
    public int getFoodListingId() { return foodListingId; }
    public void setFoodListingId(int foodListingId) { this.foodListingId = foodListingId; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
    
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    public String getDonorName() { return donorName; }
    public void setDonorName(String donorName) { this.donorName = donorName; }
    
    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }
}