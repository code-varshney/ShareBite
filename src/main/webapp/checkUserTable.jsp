<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Check User Table - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>User Table Structure</h2>
        
        <%
        String dclass = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/sharebite_db";
        String username = "root";
        String password = "";
        
        try {
            Class.forName(dclass);
            Connection con = DriverManager.getConnection(url, username, password);
            
            // Check table structure
            out.println("<h4>Users Table Structure</h4>");
            PreparedStatement ps = con.prepareStatement("DESCRIBE users");
            ResultSet rs = ps.executeQuery();
            out.println("<table class='table table-sm'>");
            out.println("<tr><th>Field</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th></tr>");
            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getString("Field") + "</td>");
                out.println("<td>" + rs.getString("Type") + "</td>");
                out.println("<td>" + rs.getString("Null") + "</td>");
                out.println("<td>" + rs.getString("Key") + "</td>");
                out.println("<td>" + rs.getString("Default") + "</td>");
                out.println("</tr>");
            }
            out.println("</table>");
            
            // Show sample users
            out.println("<h4>Sample Users</h4>");
            ps = con.prepareStatement("SELECT * FROM users LIMIT 5");
            rs = ps.executeQuery();
            ResultSetMetaData rsmd = rs.getMetaData();
            int columnCount = rsmd.getColumnCount();
            
            out.println("<table class='table table-sm'>");
            out.println("<tr>");
            for (int i = 1; i <= columnCount; i++) {
                out.println("<th>" + rsmd.getColumnName(i) + "</th>");
            }
            out.println("</tr>");
            
            while (rs.next()) {
                out.println("<tr>");
                for (int i = 1; i <= columnCount; i++) {
                    out.println("<td>" + rs.getString(i) + "</td>");
                }
                out.println("</tr>");
            }
            out.println("</table>");
            
            con.close();
            
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            e.printStackTrace();
        }
        %>
        
        <a href="fixRequestSystem.jsp" class="btn btn-primary">Back to Fix System</a>
    </div>
</body>
</html>