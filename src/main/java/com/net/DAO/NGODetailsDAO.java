package com.net.DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.net.bean.NGODetailsBean;

public class NGODetailsDAO {
    static String dclass = "com.mysql.cj.jdbc.Driver";
    static String url = "jdbc:mysql://localhost:3306/sharebite_db";
    static String username = "root";
    static String password = "";

    public static int insertNGODetails(int userId, String registrationNumber, String mission, String contactPerson, String contactTitle, String website, String serviceArea) {
        int status = 0;
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO ngo_details (user_id, registration_number, mission, contact_person, contact_title, website, service_area) VALUES (?, ?, ?, ?, ?, ?, ?)")
            ) {
                ps.setInt(1, userId);
                ps.setString(2, registrationNumber);
                ps.setString(3, mission);
                ps.setString(4, contactPerson);
                ps.setString(5, contactTitle);
                ps.setString(6, website);
                ps.setString(7, serviceArea);
                status = ps.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public static List<NGODetailsBean> getAllNGODetails() {
        List<NGODetailsBean> ngos = new ArrayList<>();
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM ngo_details");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    NGODetailsBean ngo = new NGODetailsBean();
                    ngo.setId(rs.getInt("id"));
                    ngo.setUserId(rs.getInt("user_id"));
                    ngo.setRegistrationNumber(rs.getString("registration_number"));
                    ngo.setMission(rs.getString("mission"));
                    ngo.setContactPerson(rs.getString("contact_person"));
                    ngo.setContactTitle(rs.getString("contact_title"));
                    ngo.setWebsite(rs.getString("website"));
                    ngo.setServiceArea(rs.getString("service_area"));
                    ngos.add(ngo);
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return ngos;
    }

    public static NGODetailsBean getNGODetailsById(int id) {
        NGODetailsBean ngo = null;
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM ngo_details WHERE id=? LIMIT 1")) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        ngo = new NGODetailsBean();
                        ngo.setId(rs.getInt("id"));
                        ngo.setUserId(rs.getInt("user_id"));
                        ngo.setRegistrationNumber(rs.getString("registration_number"));
                        ngo.setMission(rs.getString("mission"));
                        ngo.setContactPerson(rs.getString("contact_person"));
                        ngo.setContactTitle(rs.getString("contact_title"));
                        ngo.setWebsite(rs.getString("website"));
                        ngo.setServiceArea(rs.getString("service_area"));
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return ngo;
    }

    public static int updateNGODetails(NGODetailsBean ngo) {
        int status = 0;
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                    "UPDATE ngo_details SET registration_number=?, mission=?, contact_person=?, contact_title=?, website=?, service_area=? WHERE id=?")) {
                ps.setString(1, ngo.getRegistrationNumber());
                ps.setString(2, ngo.getMission());
                ps.setString(3, ngo.getContactPerson());
                ps.setString(4, ngo.getContactTitle());
                ps.setString(5, ngo.getWebsite());
                ps.setString(6, ngo.getServiceArea());
                ps.setInt(7, ngo.getId());
                status = ps.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public static int deleteNGODetails(int id) {
        int status = 0;
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("DELETE FROM ngo_details WHERE id=?")) {
                ps.setInt(1, id);
                status = ps.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public static NGODetailsBean getNGODetailsByUserId(int userId) {
        NGODetailsBean details = null;
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                    "SELECT * FROM ngo_details WHERE user_id=? LIMIT 1")
            ) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        details = new NGODetailsBean();
                        details.setId(rs.getInt("id"));
                        details.setUserId(rs.getInt("user_id"));
                        details.setRegistrationNumber(rs.getString("registration_number"));
                        details.setMission(rs.getString("mission"));
                        details.setContactPerson(rs.getString("contact_person"));
                        details.setContactTitle(rs.getString("contact_title"));
                        details.setWebsite(rs.getString("website"));
                        details.setServiceArea(rs.getString("service_area"));
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return details;
    }
    
    public static boolean updateNGODetailsByUserId(NGODetailsBean ngo) {
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password)) {
                // First check if NGO details exist for this user
                PreparedStatement checkPs = con.prepareStatement("SELECT id FROM ngo_details WHERE user_id=?");
                checkPs.setInt(1, ngo.getUserId());
                ResultSet rs = checkPs.executeQuery();
                
                if (rs.next()) {
                    // Update existing record
                    PreparedStatement updatePs = con.prepareStatement(
                        "UPDATE ngo_details SET registration_number=?, mission=?, contact_person=?, contact_title=?, website=?, service_area=? WHERE user_id=?");
                    updatePs.setString(1, ngo.getRegistrationNumber());
                    updatePs.setString(2, ngo.getMission());
                    updatePs.setString(3, ngo.getContactPerson());
                    updatePs.setString(4, ngo.getContactTitle());
                    updatePs.setString(5, ngo.getWebsite());
                    updatePs.setString(6, ngo.getServiceArea());
                    updatePs.setInt(7, ngo.getUserId());
                    return updatePs.executeUpdate() > 0;
                } else {
                    // Insert new record
                    PreparedStatement insertPs = con.prepareStatement(
                        "INSERT INTO ngo_details (user_id, registration_number, mission, contact_person, contact_title, website, service_area) VALUES (?, ?, ?, ?, ?, ?, ?)");
                    insertPs.setInt(1, ngo.getUserId());
                    insertPs.setString(2, ngo.getRegistrationNumber());
                    insertPs.setString(3, ngo.getMission());
                    insertPs.setString(4, ngo.getContactPerson());
                    insertPs.setString(5, ngo.getContactTitle());
                    insertPs.setString(6, ngo.getWebsite());
                    insertPs.setString(7, ngo.getServiceArea());
                    return insertPs.executeUpdate() > 0;
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
