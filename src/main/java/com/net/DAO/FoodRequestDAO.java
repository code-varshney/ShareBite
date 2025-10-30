package com.net.DAO;

import java.sql.*;
import com.net.bean.FoodRequestBean;
import java.util.ArrayList;
import java.util.List;

public class FoodRequestDAO {
    
    static String dclass = "com.mysql.cj.jdbc.Driver";
    static String url = "jdbc:mysql://localhost:3306/sharebite_db";
    static String username = "root";
    static String password = "";
    
    public static int createFoodRequest(FoodRequestBean frb) {
        Connection con = null;
        PreparedStatement ps = null;
        int status = 0;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "INSERT INTO food_requests(ngoId, foodListingId, requestMessage, pickupDate, pickupTime, status, createdAt, updatedAt, isActive) VALUES(?,?,?,?,?,?,NOW(),NOW(),?)";
            ps = con.prepareStatement(sql);
            ps.setInt(1, frb.getNgoId());
            ps.setInt(2, frb.getFoodListingId());
            ps.setString(3, frb.getRequestMessage());
            ps.setString(4, frb.getPickupDate());
            ps.setString(5, frb.getPickupTime());
            ps.setString(6, frb.getStatus());
            ps.setBoolean(7, frb.isActive());
            
            System.out.println("DEBUG: Creating food request - NGO ID: " + frb.getNgoId() + ", Food Listing ID: " + frb.getFoodListingId());
            status = ps.executeUpdate();
            System.out.println("DEBUG: Food request creation result: " + status);
            
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("DEBUG: Error creating food request: " + e.getMessage());
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
    
    public static List<FoodRequestBean> getFoodRequestsByNgo(int ngoId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<FoodRequestBean> requests = new ArrayList<>();
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "SELECT fr.*, fl.foodName, fl.quantity, fl.quantityUnit, fl.expiryDate, u.name as donorName FROM food_requests fr JOIN food_listings fl ON fr.foodListingId = fl.id JOIN users u ON fl.donorId = u.id WHERE fr.ngoId=? AND fr.isActive=1 ORDER BY fr.createdAt DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, ngoId);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                FoodRequestBean request = new FoodRequestBean();
                request.setId(rs.getInt("id"));
                request.setNgoId(rs.getInt("ngoId"));
                request.setFoodListingId(rs.getInt("foodListingId"));
                request.setRequestMessage(rs.getString("requestMessage"));
                request.setPickupDate(rs.getString("pickupDate"));
                request.setPickupTime(rs.getString("pickupTime"));
                request.setStatus(rs.getString("status"));
                request.setDonorResponse(rs.getString("donorResponse"));
                request.setCreatedAt(rs.getTimestamp("createdAt"));
                request.setUpdatedAt(rs.getTimestamp("updatedAt"));
                request.setActive(rs.getBoolean("isActive"));
                requests.add(request);
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
        return requests;
    }
    
    public static List<FoodRequestBean> getFoodRequestsForDonor(int donorId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<FoodRequestBean> requests = new ArrayList<>();
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "SELECT fr.*, fl.foodName, fl.quantity, fl.quantityUnit, u.name as ngoName, u.organizationName FROM food_requests fr JOIN food_listings fl ON fr.foodListingId = fl.id JOIN users u ON fr.ngoId = u.id WHERE fl.donorId=? AND fr.isActive=1 ORDER BY fr.createdAt DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, donorId);
            rs = ps.executeQuery();
            
            System.out.println("DEBUG: Executing query for donor ID: " + donorId);
            int count = 0;
            while (rs.next()) {
                count++;
                FoodRequestBean request = new FoodRequestBean();
                request.setId(rs.getInt("id"));
                request.setNgoId(rs.getInt("ngoId"));
                request.setFoodListingId(rs.getInt("foodListingId"));
                request.setRequestMessage(rs.getString("requestMessage"));
                request.setPickupDate(rs.getString("pickupDate"));
                request.setPickupTime(rs.getString("pickupTime"));
                request.setStatus(rs.getString("status"));
                request.setDonorResponse(rs.getString("donorResponse"));
                request.setCreatedAt(rs.getTimestamp("createdAt"));
                request.setUpdatedAt(rs.getTimestamp("updatedAt"));
                request.setActive(rs.getBoolean("isActive"));
                request.setNgoName(rs.getString("organizationName") != null ? rs.getString("organizationName") : rs.getString("ngoName"));
                request.setFoodName(rs.getString("foodName"));
                requests.add(request);
                System.out.println("DEBUG: Found request ID " + request.getId() + " from NGO: " + request.getNgoName());
            }
            System.out.println("DEBUG: Total requests found for donor " + donorId + ": " + count);
            
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("DEBUG: Error in getFoodRequestsForDonor: " + e.getMessage());
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
        return requests;
    }
    
    public static FoodRequestBean getFoodRequestById(int requestId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        FoodRequestBean request = null;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "SELECT fr.*, fl.foodName, fl.quantity, fl.quantityUnit, fl.expiryDate, fl.pickupAddress, fl.pickupCity, u.name as ngoName, u.organizationName, u.phone as ngoPhone FROM food_requests fr JOIN food_listings fl ON fr.foodListingId = fl.id JOIN users u ON fr.ngoId = u.id WHERE fr.id=? AND fr.isActive=1";
            ps = con.prepareStatement(sql);
            ps.setInt(1, requestId);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                request = new FoodRequestBean();
                request.setId(rs.getInt("id"));
                request.setNgoId(rs.getInt("ngoId"));
                request.setFoodListingId(rs.getInt("foodListingId"));
                request.setRequestMessage(rs.getString("requestMessage"));
                request.setPickupDate(rs.getString("pickupDate"));
                request.setPickupTime(rs.getString("pickupTime"));
                request.setStatus(rs.getString("status"));
                request.setDonorResponse(rs.getString("donorResponse"));
                request.setCreatedAt(rs.getTimestamp("createdAt"));
                request.setUpdatedAt(rs.getTimestamp("updatedAt"));
                request.setActive(rs.getBoolean("isActive"));
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
        return request;
    }
    
    public static boolean updateRequestStatus(int requestId, String newStatus) {
        Connection con = null;
        PreparedStatement ps = null;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "UPDATE food_requests SET status=?, updatedAt=NOW() WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, requestId);
            
            int rowsUpdated = ps.executeUpdate();
            return rowsUpdated > 0;
            
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            try {
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
    
    public static int addDonorResponse(int requestId, String response) {
        Connection con = null;
        PreparedStatement ps = null;
        int status = 0;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "UPDATE food_requests SET donorResponse=?, updatedAt=NOW() WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, response);
            ps.setInt(2, requestId);
            
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
    
    public static List<FoodRequestBean> getPendingRequests() {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<FoodRequestBean> requests = new ArrayList<>();
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "SELECT fr.*, fl.foodName, fl.quantity, fl.quantityUnit, fl.expiryDate, u.name as ngoName, u.organizationName FROM food_requests fr JOIN food_listings fl ON fr.foodListingId = fl.id JOIN users u ON fr.ngoId = u.id WHERE fr.status='pending' AND fr.isActive=1 ORDER BY fr.createdAt ASC";
            ps = con.prepareStatement(sql);
            rs = ps.executeQuery();
            
            while (rs.next()) {
                FoodRequestBean request = new FoodRequestBean();
                request.setId(rs.getInt("id"));
                request.setNgoId(rs.getInt("ngoId"));
                request.setFoodListingId(rs.getInt("foodListingId"));
                request.setRequestMessage(rs.getString("requestMessage"));
                request.setPickupDate(rs.getString("pickupDate"));
                request.setPickupTime(rs.getString("pickupTime"));
                request.setStatus(rs.getString("status"));
                request.setDonorResponse(rs.getString("donorResponse"));
                request.setCreatedAt(rs.getTimestamp("createdAt"));
                request.setUpdatedAt(rs.getTimestamp("updatedAt"));
                request.setActive(rs.getBoolean("isActive"));
                requests.add(request);
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
        return requests;
    }
    
    public static int deleteFoodRequest(int requestId) {
        Connection con = null;
        PreparedStatement ps = null;
        int status = 0;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "UPDATE food_requests SET isActive=0, updatedAt=NOW() WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, requestId);
            
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
    
    public static boolean hasActiveRequest(int ngoId, int foodListingId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        boolean hasRequest = false;
        
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            
            String sql = "SELECT id FROM food_requests WHERE ngoId=? AND foodListingId=? AND status IN ('pending', 'approved') AND isActive=1";
            ps = con.prepareStatement(sql);
            ps.setInt(1, ngoId);
            ps.setInt(2, foodListingId);
            rs = ps.executeQuery();
            
            hasRequest = rs.next();
            
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
        return hasRequest;
    }
    
    public static List<FoodRequestBean> getRequestsByFoodId(int foodId) {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<FoodRequestBean> requests = new ArrayList<>();
        try {
            Class.forName(dclass);
            con = DriverManager.getConnection(url, username, password);
            String sql = "SELECT fr.*, u.name as ngoName, u.organizationName FROM food_requests fr JOIN users u ON fr.ngoId = u.id WHERE fr.foodListingId=? AND fr.isActive=1 ORDER BY fr.createdAt DESC";
            ps = con.prepareStatement(sql);
            ps.setInt(1, foodId);
            rs = ps.executeQuery();
            while (rs.next()) {
                FoodRequestBean request = new FoodRequestBean();
                request.setId(rs.getInt("id"));
                request.setNgoId(rs.getInt("ngoId"));
                request.setFoodListingId(rs.getInt("foodListingId"));
                request.setRequestMessage(rs.getString("requestMessage"));
                request.setPickupDate(rs.getString("pickupDate"));
                request.setPickupTime(rs.getString("pickupTime"));
                request.setStatus(rs.getString("status"));
                request.setDonorResponse(rs.getString("donorResponse"));
                request.setCreatedAt(rs.getTimestamp("createdAt"));
                request.setUpdatedAt(rs.getTimestamp("updatedAt"));
                request.setActive(rs.getBoolean("isActive"));
                request.setNgoName(rs.getString("ngoName"));
                requests.add(request);
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
        return requests;
    }
}