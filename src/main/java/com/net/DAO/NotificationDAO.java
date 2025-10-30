package com.net.DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.net.bean.NotificationBean;

public class NotificationDAO {
    static String dclass = "com.mysql.cj.jdbc.Driver";
    static String url = "jdbc:mysql://localhost:3306/sharebite_db";
    static String username = "root";
    static String password = "";

    public static boolean createNotification(int ngoId, int donorId, int foodListingId, String message, String type) {
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO notifications (ngo_id, donor_id, food_listing_id, message, type, is_read, created_at) VALUES (?, ?, ?, ?, ?, 0, NOW())")) {
                ps.setInt(1, ngoId);
                ps.setInt(2, donorId);
                ps.setInt(3, foodListingId);
                ps.setString(4, message);
                ps.setString(5, type);
                return ps.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void notifyAllNGOsAboutNewFood(int donorId, int foodListingId, String donorName, String foodName) {
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO notifications (ngo_id, donor_id, food_listing_id, message, type, is_read, created_at) " +
                    "SELECT id, ?, ?, ?, 'new_food', 0, NOW() FROM users WHERE userType='ngo' AND isActive=1")) {
                String message = "New food available: " + foodName + " by " + donorName;
                ps.setInt(1, donorId);
                ps.setInt(2, foodListingId);
                ps.setString(3, message);
                int rowsInserted = ps.executeUpdate();
                System.out.println("DEBUG: Notifications created for " + rowsInserted + " NGOs");
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            System.out.println("DEBUG: Error creating notifications: " + e.getMessage());
        }
    }

    public static List<NotificationBean> getNotificationsByNGO(int ngoId) {
        List<NotificationBean> notifications = new ArrayList<>();
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                    "SELECT n.*, u.name as donor_name, f.foodName as food_name " +
                    "FROM notifications n " +
                    "LEFT JOIN users u ON n.donor_id = u.id " +
                    "LEFT JOIN food_listings f ON n.food_listing_id = f.id " +
                    "WHERE n.ngo_id = ? ORDER BY n.created_at DESC LIMIT 20")) {
                ps.setInt(1, ngoId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        NotificationBean notification = new NotificationBean();
                        notification.setId(rs.getInt("id"));
                        notification.setNgoId(rs.getInt("ngo_id"));
                        notification.setDonorId(rs.getInt("donor_id"));
                        notification.setFoodListingId(rs.getInt("food_listing_id"));
                        notification.setMessage(rs.getString("message"));
                        notification.setType(rs.getString("type"));
                        notification.setRead(rs.getBoolean("is_read"));
                        notification.setCreatedAt(rs.getString("created_at"));
                        notification.setDonorName(rs.getString("donor_name"));
                        notification.setFoodName(rs.getString("food_name"));
                        notifications.add(notification);
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    public static boolean markAsRead(int notificationId) {
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("UPDATE notifications SET is_read = 1 WHERE id = ?")) {
                ps.setInt(1, notificationId);
                return ps.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static int getUnreadCount(int ngoId) {
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM notifications WHERE ngo_id = ? AND is_read = 0")) {
                ps.setInt(1, ngoId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public static boolean notifyDonorAboutFoodRequest(int donorId, int ngoId, int foodListingId, String ngoName, String foodName) {
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO notifications (ngo_id, donor_id, food_listing_id, message, type, is_read, created_at) VALUES (?, ?, ?, ?, 'food_request', 0, NOW())")) {
                String message = ngoName + " has requested your food: " + foodName;
                ps.setInt(1, donorId); // Store donor as ngo_id for donor notifications
                ps.setInt(2, ngoId);
                ps.setInt(3, foodListingId);
                ps.setString(4, message);
                return ps.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean notifyNGOAboutRequestUpdate(int ngoId, int donorId, int foodListingId, String message) {
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO notifications (ngo_id, donor_id, food_listing_id, message, type, is_read, created_at) VALUES (?, ?, ?, ?, 'request_update', 0, NOW())")) {
                ps.setInt(1, ngoId);
                ps.setInt(2, donorId);
                ps.setInt(3, foodListingId);
                ps.setString(4, message);
                return ps.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean markAllAsRead(int ngoId) {
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("UPDATE notifications SET is_read = 1 WHERE ngo_id = ?")) {
                ps.setInt(1, ngoId);
                return ps.executeUpdate() > 0;
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}