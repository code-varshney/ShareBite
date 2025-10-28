<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Database Test</title>
</head>
<body>
    <h2>Database Connection Test</h2>
    <%
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
        out.println("<p style='color: green;'>✓ Database connection successful!</p>");
        
        // Check if users table exists
        DatabaseMetaData meta = con.getMetaData();
        ResultSet tables = meta.getTables(null, null, "users", null);
        if (tables.next()) {
            out.println("<p style='color: green;'>✓ Users table exists</p>");
            
            // Check users table structure
            PreparedStatement ps = con.prepareStatement("DESCRIBE users");
            ResultSet rs = ps.executeQuery();
            out.println("<h3>Users Table Structure:</h3><ul>");
            while (rs.next()) {
                out.println("<li>" + rs.getString("Field") + " - " + rs.getString("Type") + "</li>");
            }
            out.println("</ul>");
            rs.close();
            ps.close();
        } else {
            out.println("<p style='color: red;'>✗ Users table does not exist</p>");
        }
        
        // Check if ngo_details table exists
        ResultSet ngoTables = meta.getTables(null, null, "ngo_details", null);
        if (ngoTables.next()) {
            out.println("<p style='color: green;'>✓ NGO Details table exists</p>");
            
            // Check ngo_details table structure
            PreparedStatement ps2 = con.prepareStatement("DESCRIBE ngo_details");
            ResultSet rs2 = ps2.executeQuery();
            out.println("<h3>NGO Details Table Structure:</h3><ul>");
            while (rs2.next()) {
                out.println("<li>" + rs2.getString("Field") + " - " + rs2.getString("Type") + "</li>");
            }
            out.println("</ul>");
            rs2.close();
            ps2.close();
        } else {
            out.println("<p style='color: red;'>✗ NGO Details table does not exist</p>");
        }
        
        con.close();
    } catch (Exception e) {
        out.println("<p style='color: red;'>✗ Database error: " + e.getMessage() + "</p>");
        e.printStackTrace();
    }
    %>
</body>
</html>