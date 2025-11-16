package com.net.DAO;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.net.bean.ChatMessageBean;

public class ChatDAO {
    static String dclass = "com.mysql.cj.jdbc.Driver";
    static String url = "jdbc:mysql://localhost:3306/sharebite_db";
    static String username = "root";
    static String password = "";

    public static boolean sendMessage(int requestId, int senderId, int receiverId, String message) {
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                     "INSERT INTO chat_messages (request_id, sender_id, receiver_id, message) VALUES (?, ?, ?, ?)")) {
                ps.setInt(1, requestId);
                ps.setInt(2, senderId);
                ps.setInt(3, receiverId);
                ps.setString(4, message);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static List<ChatMessageBean> getChatMessages(int requestId) {
        List<ChatMessageBean> messages = new ArrayList<>();
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                     "SELECT cm.*, s.name as sender_name, r.name as receiver_name " +
                     "FROM chat_messages cm " +
                     "JOIN users s ON cm.sender_id = s.id " +
                     "JOIN users r ON cm.receiver_id = r.id " +
                     "WHERE cm.request_id = ? ORDER BY cm.sent_at ASC")) {
                ps.setInt(1, requestId);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        ChatMessageBean msg = new ChatMessageBean();
                        msg.setId(rs.getInt("id"));
                        msg.setRequestId(rs.getInt("request_id"));
                        msg.setSenderId(rs.getInt("sender_id"));
                        msg.setReceiverId(rs.getInt("receiver_id"));
                        msg.setMessage(rs.getString("message"));
                        msg.setSentAt(rs.getTimestamp("sent_at"));
                        msg.setRead(rs.getBoolean("is_read"));
                        msg.setSenderName(rs.getString("sender_name"));
                        msg.setReceiverName(rs.getString("receiver_name"));
                        messages.add(msg);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return messages;
    }

    public static boolean markMessagesAsRead(int requestId, int userId) {
        try {
            Class.forName(dclass);
            try (Connection con = DriverManager.getConnection(url, username, password);
                 PreparedStatement ps = con.prepareStatement(
                     "UPDATE chat_messages SET is_read = 1 WHERE request_id = ? AND receiver_id = ?")) {
                ps.setInt(1, requestId);
                ps.setInt(2, userId);
                return ps.executeUpdate() > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}