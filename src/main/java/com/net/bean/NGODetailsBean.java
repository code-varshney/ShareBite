package com.net.bean;

public class NGODetailsBean {
    private int id;
    private int userId;
    private String registrationNumber;
    private String mission;
    private String contactPerson;
    private String contactTitle;
    private String website;
    private String serviceArea;

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getRegistrationNumber() { return registrationNumber; }
    public void setRegistrationNumber(String registrationNumber) { this.registrationNumber = registrationNumber; }
    public String getMission() { return mission; }
    public void setMission(String mission) { this.mission = mission; }
    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }
    public String getContactTitle() { return contactTitle; }
    public void setContactTitle(String contactTitle) { this.contactTitle = contactTitle; }
    public String getWebsite() { return website; }
    public void setWebsite(String website) { this.website = website; }
    public String getServiceArea() { return serviceArea; }
    public void setServiceArea(String serviceArea) { this.serviceArea = serviceArea; }
}
