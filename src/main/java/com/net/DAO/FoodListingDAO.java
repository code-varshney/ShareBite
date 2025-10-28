package com.net.DAO;

import java.sql.*;
import com.net.bean.FoodListingBean;
import java.util.ArrayList;
import java.util.List;

public class FoodListingDAO {
    
    static String dclass = "com.mysql.cj.jdbc.Driver";
    static String url = "jdbc:mysql://localhost:3306/sharebite_db";
    static String username = "root";
    static String password = "";
    
    public static int createFoodListing(FoodListingBean flb) {
        Connection con = null;
        PreparedStatement ps = null;
        int status = 0;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "INSERT INTO food_listings(donorId, foodName, description, quantity, quantityUnit, foodType, expiryDate, pickupAddress, pickupCity, pickupState, pickupZipCode, pickupInstructions, status, imageUrl, storageCondition, allergenInfo, specialNotes, latitude, longitude, createdAt, updatedAt, isActive) VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,NOW(),NOW(),?)";
            ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, flb.getDonorId());
            ps.setString(2, flb.getFoodName());
            ps.setString(3, flb.getDescription());
            ps.setInt(4, flb.getQuantity());
            ps.setString(5, flb.getQuantityUnit());
            ps.setString(6, flb.getFoodType());
            ps.setString(7, flb.getExpiryDate());
            ps.setString(8, flb.getPickupAddress());
            ps.setString(9, flb.getPickupCity());
            ps.setString(10, flb.getPickupState());
            ps.setString(11, flb.getPickupZipCode());
            ps.setString(12, flb.getPickupInstructions());
            ps.setString(13, flb.getStatus());
            ps.setString(14, flb.getImageUrl());
            ps.setString(15, flb.getStorageCondition());
            ps.setString(16, flb.getAllergenInfo());
            ps.setString(17, flb.getSpecialNotes());
            ps.setDouble(18, flb.getLatitude());
            ps.setDouble(19, flb.getLongitude());
            ps.setBoolean(20, flb.isActive());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    status = generatedKeys.getInt(1);
                }
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return status;
    }
    
    public static List<FoodListingBean> getAllFoodListings() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<FoodListingBean> listings = new ArrayList<>();
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            System.out.println("DEBUG: Connected to DB in FoodListingDAO.getAllFoodListings()");
            String sql = "SELECT fl.*, u.name as donorName, u.fulladdress as donorCity FROM food_listings fl JOIN users u ON fl.donorId = u.id WHERE fl.isActive=1 AND fl.status='Available' AND fl.expiryDate >= CURDATE() ORDER BY fl.createdAt DESC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            int debugCount = 0;
            while (rs.next()) {
                FoodListingBean listing = new FoodListingBean();
                listing.setId(rs.getInt("id"));
                listing.setDonorId(rs.getInt("donorId"));
                listing.setFoodName(rs.getString("foodName"));
                listing.setDescription(rs.getString("description"));
                listing.setQuantity(rs.getInt("quantity"));
                listing.setQuantityUnit(rs.getString("quantityUnit"));
                listing.setFoodType(rs.getString("foodType"));
                listing.setExpiryDate(rs.getString("expiryDate"));
                listing.setPickupAddress(rs.getString("pickupAddress"));
                listing.setPickupCity(rs.getString("pickupCity"));
                listing.setPickupState(rs.getString("pickupState"));
                listing.setPickupZipCode(rs.getString("pickupZipCode"));
                listing.setPickupInstructions(rs.getString("pickupInstructions"));
                listing.setStatus(rs.getString("status"));
                listing.setImageUrl(rs.getString("imageUrl"));
                listing.setStorageCondition(rs.getString("storageCondition"));
                listing.setAllergenInfo(rs.getString("allergenInfo"));
                listing.setSpecialNotes(rs.getString("specialNotes"));
                listing.setLatitude(rs.getDouble("latitude"));
                listing.setLongitude(rs.getDouble("longitude"));
                listing.setCreatedAt(rs.getTimestamp("createdAt"));
                listing.setUpdatedAt(rs.getTimestamp("updatedAt"));
                listing.setActive(rs.getBoolean("isActive"));
                listings.add(listing);
                debugCount++;
            }
            System.out.println("DEBUG: getAllFoodListings returned " + debugCount + " records");
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("DEBUG: Exception in getAllFoodListings: " + e.getMessage());
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return listings;
    }
    
    public static List<FoodListingBean> getFoodListingsByDonor(int donorId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<FoodListingBean> listings = new ArrayList<>();
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "SELECT * FROM food_listings WHERE donorId=? AND isActive=1 ORDER BY createdAt DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, donorId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                FoodListingBean listing = new FoodListingBean();
                listing.setId(rs.getInt("id"));
                listing.setDonorId(rs.getInt("donorId"));
                listing.setFoodName(rs.getString("foodName"));
                listing.setDescription(rs.getString("description"));
                listing.setQuantity(rs.getInt("quantity"));
                listing.setQuantityUnit(rs.getString("quantityUnit"));
                listing.setFoodType(rs.getString("foodType"));
                listing.setExpiryDate(rs.getString("expiryDate"));
                listing.setPickupAddress(rs.getString("pickupAddress"));
                listing.setPickupCity(rs.getString("pickupCity"));
                listing.setPickupState(rs.getString("pickupState"));
                listing.setPickupZipCode(rs.getString("pickupZipCode"));
                listing.setPickupInstructions(rs.getString("pickupInstructions"));
                listing.setStatus(rs.getString("status"));
                listing.setImageUrl(rs.getString("imageUrl"));
                listing.setCreatedAt(rs.getTimestamp("createdAt"));
                listing.setUpdatedAt(rs.getTimestamp("updatedAt"));
                listing.setActive(rs.getBoolean("isActive"));
                listings.add(listing);
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return listings;
    }
    
    public static FoodListingBean getFoodListingById(int listingId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        FoodListingBean listing = null;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "SELECT fl.*, u.name as donorName, u.phone as donorPhone, u.city as donorCity FROM food_listings fl JOIN users u ON fl.donorId = u.id WHERE fl.id=? AND fl.isActive=1";
            ps = con.prepareStatement(sql);
            ps.setInt(1, listingId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                listing = new FoodListingBean();
                listing.setId(rs.getInt("id"));
                listing.setDonorId(rs.getInt("donorId"));
                listing.setFoodName(rs.getString("foodName"));
                listing.setDescription(rs.getString("description"));
                listing.setQuantity(rs.getInt("quantity"));
                listing.setQuantityUnit(rs.getString("quantityUnit"));
                listing.setFoodType(rs.getString("foodType"));
                listing.setExpiryDate(rs.getString("expiryDate"));
                listing.setPickupAddress(rs.getString("pickupAddress"));
                listing.setPickupCity(rs.getString("pickupCity"));
                listing.setPickupState(rs.getString("pickupState"));
                listing.setPickupZipCode(rs.getString("pickupZipCode"));
                listing.setPickupInstructions(rs.getString("pickupInstructions"));
                listing.setStatus(rs.getString("status"));
                listing.setImageUrl(rs.getString("imageUrl"));
                listing.setCreatedAt(rs.getTimestamp("createdAt"));
                listing.setUpdatedAt(rs.getTimestamp("updatedAt"));
                listing.setActive(rs.getBoolean("isActive"));
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return listing;
    }
    
    public static List<FoodListingBean> searchFoodListings(String city, String foodType, String keyword) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<FoodListingBean> listings = new ArrayList<>();
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            StringBuilder sql = new StringBuilder("SELECT fl.*, u.name as donorName, u.city as donorCity FROM food_listings fl JOIN users u ON fl.donorId = u.id WHERE fl.isActive=1 AND fl.status='Available' AND fl.expiryDate >= CURDATE()");
            
            if (city != null && !city.trim().isEmpty()) {
                sql.append(" AND fl.pickupCity LIKE ?");
            }
            if (foodType != null && !foodType.trim().isEmpty()) {
                sql.append(" AND fl.foodType = ?");
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND (fl.foodName LIKE ? OR fl.description LIKE ?)");
            }
            
            sql.append(" ORDER BY fl.createdAt DESC");
            
            ps = con.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (city != null && !city.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + city + "%");
            }
            if (foodType != null && !foodType.trim().isEmpty()) {
                ps.setString(paramIndex++, foodType);
            }
            if (keyword != null && !keyword.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + keyword + "%");
                ps.setString(paramIndex++, "%" + keyword + "%");
            }
            
            rs = ps.executeQuery();
            
            while (rs.next()) {
                FoodListingBean listing = new FoodListingBean();
                listing.setId(rs.getInt("id"));
                listing.setDonorId(rs.getInt("donorId"));
                listing.setFoodName(rs.getString("foodName"));
                listing.setDescription(rs.getString("description"));
                listing.setQuantity(rs.getInt("quantity"));
                listing.setQuantityUnit(rs.getString("quantityUnit"));
                listing.setFoodType(rs.getString("foodType"));
                listing.setExpiryDate(rs.getString("expiryDate"));
                listing.setPickupAddress(rs.getString("pickupAddress"));
                listing.setPickupCity(rs.getString("pickupCity"));
                listing.setPickupState(rs.getString("pickupState"));
                listing.setPickupZipCode(rs.getString("pickupZipCode"));
                listing.setPickupInstructions(rs.getString("pickupInstructions"));
                listing.setStatus(rs.getString("status"));
                listing.setImageUrl(rs.getString("imageUrl"));
                listing.setCreatedAt(rs.getTimestamp("createdAt"));
                listing.setUpdatedAt(rs.getTimestamp("updatedAt"));
                listing.setActive(rs.getBoolean("isActive"));
                listings.add(listing);
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return listings;
    }
    
    public static int updateFoodListingStatus(int listingId, String newStatus) {
        Connection con = null;
        PreparedStatement ps = null;
        int status = 0;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "UPDATE food_listings SET status=?, updatedAt=NOW() WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, listingId);
            
            status = ps.executeUpdate();
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return status;
    }
    
    public static int updateFoodListing(FoodListingBean flb) {
        Connection con = null;
        PreparedStatement ps = null;
        int status = 0;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "UPDATE food_listings SET foodName=?, description=?, quantity=?, quantityUnit=?, foodType=?, expiryDate=?, pickupAddress=?, pickupCity=?, pickupState=?, pickupZipCode=?, pickupInstructions=?, status=?, updatedAt=NOW() WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, flb.getFoodName());
            ps.setString(2, flb.getDescription());
            ps.setInt(3, flb.getQuantity());
            ps.setString(4, flb.getQuantityUnit());
            ps.setString(5, flb.getFoodType());
            ps.setString(6, flb.getExpiryDate());
            ps.setString(7, flb.getPickupAddress());
            ps.setString(8, flb.getPickupCity());
            ps.setString(9, flb.getPickupState());
            ps.setString(10, flb.getPickupZipCode());
            ps.setString(11, flb.getPickupInstructions());
            ps.setString(12, flb.getStatus());
            ps.setInt(13, flb.getId());
            
            status = ps.executeUpdate();
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return status;
    }
    
    public static int deleteFoodListing(int listingId) {
        Connection con = null;
        PreparedStatement ps = null;
        int status = 0;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "UPDATE food_listings SET isActive=0, updatedAt=NOW() WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, listingId);
            
            status = ps.executeUpdate();
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return status;
    }
    
    public static List<FoodListingBean> getExpiringFoodListings() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<FoodListingBean> listings = new ArrayList<>();
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "SELECT * FROM food_listings WHERE isActive=1 AND status='available' AND expiryDate <= DATE_ADD(CURDATE(), INTERVAL 2 DAY) ORDER BY expiryDate ASC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                FoodListingBean listing = new FoodListingBean();
                listing.setId(rs.getInt("id"));
                listing.setDonorId(rs.getInt("donorId"));
                listing.setFoodName(rs.getString("foodName"));
                listing.setDescription(rs.getString("description"));
                listing.setQuantity(rs.getInt("quantity"));
                listing.setQuantityUnit(rs.getString("quantityUnit"));
                listing.setFoodType(rs.getString("foodType"));
                listing.setExpiryDate(rs.getString("expiryDate"));
                listing.setPickupAddress(rs.getString("pickupAddress"));
                listing.setPickupCity(rs.getString("pickupCity"));
                listing.setPickupState(rs.getString("pickupState"));
                listing.setPickupZipCode(rs.getString("pickupZipCode"));
                listing.setPickupInstructions(rs.getString("pickupInstructions"));
                listing.setStatus(rs.getString("status"));
                listing.setImageUrl(rs.getString("imageUrl"));
                listing.setCreatedAt(rs.getTimestamp("createdAt"));
                listing.setUpdatedAt(rs.getTimestamp("updatedAt"));
                listing.setActive(rs.getBoolean("isActive"));
                listings.add(listing);
            }
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return listings;
    }
    
    public static int updateExpiredFoodListings() {
        Connection con = null;
        PreparedStatement ps = null;
        int updatedCount = 0;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "UPDATE food_listings SET status='Expired', updatedAt=NOW() WHERE isActive=1 AND status IN ('Available', 'Reserved') AND expiryDate < CURDATE()";
            ps = con.prepareStatement(sql);
            updatedCount = ps.executeUpdate();
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return updatedCount;
    }
    
    public static List<FoodListingBean> getFoodListingsWithinRange(double ngoLatitude, double ngoLongitude, double rangeKm) {
        List<FoodListingBean> listings = new ArrayList<>();
        try {
            Class.forName(dclass);
            Connection con = DriverManager.getConnection(url, username, password);
            
            String sql = "SELECT fl.*, u.name as donorName, u.fulladdress as donorCity, " +
                        "(6371 * acos(cos(radians(?)) * cos(radians(fl.latitude)) * " +
                        "cos(radians(fl.longitude) - radians(?)) + sin(radians(?)) * " +
                        "sin(radians(fl.latitude)))) AS distance " +
                        "FROM food_listings fl JOIN users u ON fl.donorId = u.id " +
                        "WHERE fl.isActive=1 AND fl.status='Available' AND fl.expiryDate >= CURDATE() " +
                        "AND fl.latitude != 0 AND fl.longitude != 0 " +
                        "HAVING distance <= ? ORDER BY distance ASC";
            
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setDouble(1, ngoLatitude);
            ps.setDouble(2, ngoLongitude);
            ps.setDouble(3, ngoLatitude);
            ps.setDouble(4, rangeKm);
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                FoodListingBean listing = new FoodListingBean();
                listing.setId(rs.getInt("id"));
                listing.setDonorId(rs.getInt("donorId"));
                listing.setFoodName(rs.getString("foodName"));
                listing.setDescription(rs.getString("description"));
                listing.setQuantity(rs.getInt("quantity"));
                listing.setQuantityUnit(rs.getString("quantityUnit"));
                listing.setFoodType(rs.getString("foodType"));
                listing.setExpiryDate(rs.getString("expiryDate"));
                listing.setPickupAddress(rs.getString("pickupAddress"));
                listing.setPickupCity(rs.getString("pickupCity"));
                listing.setPickupState(rs.getString("pickupState"));
                listing.setPickupZipCode(rs.getString("pickupZipCode"));
                listing.setPickupInstructions(rs.getString("pickupInstructions"));
                listing.setStatus(rs.getString("status"));
                listing.setImageUrl(rs.getString("imageUrl"));
                listing.setLatitude(rs.getDouble("latitude"));
                listing.setLongitude(rs.getDouble("longitude"));
                listing.setCreatedAt(rs.getTimestamp("createdAt"));
                listing.setUpdatedAt(rs.getTimestamp("updatedAt"));
                listing.setActive(rs.getBoolean("isActive"));
                listings.add(listing);
            }
            
            rs.close();
            ps.close();
            con.close();
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return listings;
    }
}