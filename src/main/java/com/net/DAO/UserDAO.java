package com.net.DAO;

import java.sql.*;
import com.net.bean.UserBean;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    static String dclass = "com.mysql.cj.jdbc.Driver";
    static String url = "jdbc:mysql://localhost:3306/sharebite_db";
    static String username = "root";
    static String password = "";

    public static int login(UserBean ub) {
        int status = 0;
        try {
            Class.forName(dclass);
            String loginQuery = "SELECT * FROM users WHERE email=? AND password=? AND isActive=1";
            // If NGO, require verified status
            if (ub.getUserType() != null && ub.getUserType().equals("ngo")) {
                loginQuery += " AND verificationStatus='verified'";
            }
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(loginQuery)) {
                ps.setString(1, ub.getEmail());
                ps.setString(2, ub.getPassword());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        status = 1;
                        ub.setId(rs.getInt("id"));
                        ub.setName(rs.getString("name"));
                        ub.setEmail(rs.getString("email"));
                        ub.setPassword(rs.getString("password"));
                        ub.setUserType(rs.getString("role"));
                        ub.setOrganizationName(rs.getString("organizationName"));
                        ub.setPhone(rs.getString("phone"));
                        ub.setFullAddress(rs.getString("fulladdress"));
                        ub.setActive(rs.getBoolean("isActive"));
                        ub.setOrganizationType(rs.getString("organizationType"));
                        ub.setDonationFrequency(rs.getString("donationFrequency"));
                        ub.setVerificationStatus(rs.getString("verificationStatus"));
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public static int register(UserBean ub) {
        int status = 0;
        try {
            Class.forName(dclass);
            // Combine firstName and lastName if name is missing
            String name = ub.getName();
            if (name == null || name.trim().isEmpty()) {
                String firstName = ub.getFirstName() != null ? ub.getFirstName() : "";
                String lastName = ub.getLastName() != null ? ub.getLastName() : "";
                name = (firstName + " " + lastName).trim();
            }
            String fulladdress = ub.getFullAddress();
            if (fulladdress == null || fulladdress.trim().isEmpty()) {
                String address = ub.getAddress() != null ? ub.getAddress() : "";
                String city = ub.getCity() != null ? ub.getCity() : "";
                String state = ub.getState() != null ? ub.getState() : "";
                String zipCode = ub.getZipCode() != null ? ub.getZipCode() : "";
                fulladdress = (address + " " + city + " " + state + " " + zipCode).trim();
            }
            // Set role to 'donor' if missing
            String role = ub.getUserType();
            if (role == null || role.trim().isEmpty()) {
                role = "donor";
            }
            // Set isActive to true if not set
            boolean isActive = ub.isActive();
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO users (name, email, password, role, organizationName, phone, createdAt, isActive, organizationType, donationFrequency, fulladdress, verificationStatus) VALUES (?, ?, ?, ?, ?, ?, NOW(), ?, ?, ?, ?, ?)") ) {
                ps.setString(1, name);
                ps.setString(2, ub.getEmail());
                ps.setString(3, ub.getPassword());
                ps.setString(4, role); // userType in bean, role in DB
                ps.setString(5, ub.getOrganizationName());
                ps.setString(6, ub.getPhone());
                ps.setBoolean(7, isActive);
                ps.setString(8, ub.getOrganizationType());
                ps.setString(9, ub.getDonationFrequency());
                ps.setString(10, fulladdress);
                ps.setString(11, ub.getVerificationStatus());
                status = ps.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public static List<UserBean> getAllUsers() {
        List<UserBean> users = new ArrayList<>();
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE isActive=1 ORDER BY createdAt DESC");
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserBean user = new UserBean();
                    user.setId(rs.getInt("id"));
                    user.setName(rs.getString("name"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));
                    user.setPhone(rs.getString("phone"));
                    user.setActive(rs.getBoolean("isActive"));
                    user.setOrganizationType(rs.getString("organizationType"));
                    user.setDonationFrequency(rs.getString("donationFrequency"));
                    user.setUserType(rs.getString("role"));
                    user.setOrganizationName(rs.getString("organizationName"));
                    user.setFullAddress(rs.getString("fulladdress"));
                    user.setVerificationStatus(rs.getString("verificationStatus"));
                    users.add(user);
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public static List<UserBean> getUsersByType(String userType) {
        List<UserBean> users = new ArrayList<>();
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE role=? AND isActive=1 ORDER BY createdAt DESC")) {
                ps.setString(1, userType);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        UserBean user = new UserBean();
                        user.setId(rs.getInt("id"));
                        user.setName(rs.getString("name"));
                        user.setEmail(rs.getString("email"));
                        user.setPhone(rs.getString("phone"));
                        user.setUserType(rs.getString("role"));
                        user.setOrganizationName(rs.getString("organizationName"));
                        user.setFullAddress(rs.getString("fulladdress"));
                        user.setVerificationStatus(rs.getString("verificationStatus"));
                        user.setActive(rs.getBoolean("isActive"));
                        user.setOrganizationType(rs.getString("organizationType"));
                        user.setDonationFrequency(rs.getString("donationFrequency"));
                        users.add(user);
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public static List<UserBean> getVerifiedUsersByType(String userType) {
        List<UserBean> users = new ArrayList<>();
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE role=? AND verificationStatus='verified' AND isActive=1 ORDER BY createdAt DESC"    )) {
                ps.setString(1, userType);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        UserBean user = new UserBean();
                        user.setId(rs.getInt("id"));
                        user.setName(rs.getString("name"));
                        user.setEmail(rs.getString("email"));
                        user.setPhone(rs.getString("phone"));
                        user.setUserType(rs.getString("role"));
                        user.setOrganizationName(rs.getString("organizationName"));
                        user.setFullAddress(rs.getString("fulladdress"));
                        user.setVerificationStatus(rs.getString("verificationStatus"));
                        user.setActive(rs.getBoolean("isActive"));
                        user.setOrganizationType(rs.getString("organizationType"));
                        user.setDonationFrequency(rs.getString("donationFrequency"));
                        users.add(user);
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
    
    public static int updateUser(UserBean ub) {
        int status = 0;
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                    "UPDATE users SET name=?, email=?, phone=?, fulladdress=?, organizationName=?, organizationType=?, donationFrequency=? WHERE id=?")) {
                ps.setString(1, ub.getName());
                ps.setString(2, ub.getEmail());
                ps.setString(3, ub.getPhone());
                ps.setString(4, ub.getFullAddress());
                ps.setString(5, ub.getOrganizationName());
                ps.setString(6, ub.getOrganizationType());
                ps.setString(7, ub.getDonationFrequency());
                ps.setInt(8, ub.getId());
                status = ps.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public static int updateVerificationStatus(int userId, String newStatus) {
        int status = 0;
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("UPDATE users SET verificationStatus=? WHERE id=?")) {
                ps.setString(1, newStatus);
                ps.setInt(2, userId);
                status = ps.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public static int deleteUser(int userId) {
        int status = 0;
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("UPDATE users SET isActive=0 WHERE id=?")) {
                ps.setInt(1, userId);
                status = ps.executeUpdate();
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return status;
    }

    public static boolean isEmailExists(String email) {
        boolean exists = false;
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("SELECT id FROM users WHERE email=? AND isActive=1")) {
                ps.setString(1, email);
                try (ResultSet rs = ps.executeQuery()) {
                    exists = rs.next();
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return exists;
    }

    public static UserBean getUserById(int userId) {
        UserBean user = null;
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=? AND isActive=1")) {
                ps.setInt(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        user = new UserBean();
                        user.setId(rs.getInt("id"));
                        user.setName(rs.getString("name"));
                        user.setEmail(rs.getString("email"));
                        user.setPhone(rs.getString("phone"));
                        user.setUserType(rs.getString("role"));
                        user.setOrganizationName(rs.getString("organizationName"));
                        user.setFullAddress(rs.getString("fulladdress"));
                        user.setAddress(rs.getString("fulladdress"));
                        user.setVerificationStatus(rs.getString("verificationStatus"));
                        user.setActive(rs.getBoolean("isActive"));
                        user.setOrganizationType(rs.getString("organizationType"));
                        user.setDonationFrequency(rs.getString("donationFrequency"));
                        user.setCreatedAt(rs.getString("createdAt"));
                    }
                }
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
}

