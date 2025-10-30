<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Database Verification</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Database Verification</h2>
        
        <%
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
            
            out.println("<div class='alert alert-success'>✅ Database connection successful</div>");
            
            // Check if food_requests table exists
            DatabaseMetaData dbmd = con.getMetaData();
            ResultSet tables = dbmd.getTables(null, null, "food_requests", null);
            
            if (tables.next()) {
                out.println("<div class='alert alert-success'>✅ food_requests table exists</div>");
                
                // Get table structure
                out.println("<h4>Table Structure:</h4>");
                out.println("<table class='table table-bordered'>");
                out.println("<thead><tr><th>Column</th><th>Type</th><th>Null</th><th>Key</th><th>Default</th></tr></thead>");
                out.println("<tbody>");
                
                ResultSet columns = dbmd.getColumns(null, null, "food_requests", null);
                while (columns.next()) {
                    String columnName = columns.getString("COLUMN_NAME");
                    String dataType = columns.getString("TYPE_NAME");
                    String nullable = columns.getString("IS_NULLABLE");
                    String columnDefault = columns.getString("COLUMN_DEF");
                    
                    out.println("<tr>");
                    out.println("<td>" + columnName + "</td>");
                    out.println("<td>" + dataType + "</td>");
                    out.println("<td>" + nullable + "</td>");
                    out.println("<td></td>");
                    out.println("<td>" + (columnDefault != null ? columnDefault : "NULL") + "</td>");
                    out.println("</tr>");
                }
                out.println("</tbody></table>");
                columns.close();
                
                // Check record count
                ps = con.prepareStatement("SELECT COUNT(*) as count FROM food_requests");
                rs = ps.executeQuery();
                if (rs.next()) {
                    int count = rs.getInt("count");
                    out.println("<div class='alert alert-info'>📊 Total records in food_requests: " + count + "</div>");
                }
                rs.close();
                ps.close();
                
                // Show recent records
                ps = con.prepareStatement("SELECT * FROM food_requests ORDER BY createdAt DESC LIMIT 5");
                rs = ps.executeQuery();
                
                out.println("<h4>Recent Records:</h4>");
                out.println("<table class='table table-striped'>");
                out.println("<thead><tr><th>ID</th><th>NGO ID</th><th>Food Listing ID</th><th>Status</th><th>Pickup Date</th><th>Created At</th></tr></thead>");
                out.println("<tbody>");
                
                while (rs.next()) {
                    out.println("<tr>");
                    out.println("<td>" + rs.getInt("id") + "</td>");
                    out.println("<td>" + rs.getInt("ngoId") + "</td>");
                    out.println("<td>" + rs.getInt("foodListingId") + "</td>");
                    out.println("<td>" + rs.getString("status") + "</td>");
                    out.println("<td>" + rs.getString("pickupDate") + "</td>");
                    out.println("<td>" + rs.getTimestamp("createdAt") + "</td>");
                    out.println("</tr>");
                }
                out.println("</tbody></table>");
                
            } else {
                out.println("<div class='alert alert-danger'>❌ food_requests table does NOT exist</div>");
                out.println("<div class='alert alert-warning'>You need to run the food_requests_table.sql script to create the table.</div>");
            }
            tables.close();
            
            // Check food_listings table
            ResultSet foodTables = dbmd.getTables(null, null, "food_listings", null);
            if (foodTables.next()) {
                out.println("<div class='alert alert-success'>✅ food_listings table exists</div>");
                
                ps = con.prepareStatement("SELECT COUNT(*) as count FROM food_listings WHERE isActive=1");
                rs = ps.executeQuery();
                if (rs.next()) {
                    int count = rs.getInt("count");
                    out.println("<div class='alert alert-info'>📊 Active food listings: " + count + "</div>");
                }
                rs.close();
                ps.close();
            } else {
                out.println("<div class='alert alert-danger'>❌ food_listings table does NOT exist</div>");
            }
            foodTables.close();
            
            // Check users table
            ResultSet userTables = dbmd.getTables(null, null, "users", null);
            if (userTables.next()) {
                out.println("<div class='alert alert-success'>✅ users table exists</div>");
                
                ps = con.prepareStatement("SELECT COUNT(*) as count FROM users");
                rs = ps.executeQuery();
                if (rs.next()) {
                    int count = rs.getInt("count");
                    out.println("<div class='alert alert-info'>📊 Total users: " + count + "</div>");
                }
                rs.close();
                ps.close();
            } else {
                out.println("<div class='alert alert-danger'>❌ users table does NOT exist</div>");
            }
            userTables.close();
            
        } catch (Exception e) {
            out.println("<div class='alert alert-danger'>❌ Database error: " + e.getMessage() + "</div>");
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
        %>
        
        <div class="mt-4">
            <a href="ngoDashboard.jsp" class="btn btn-secondary">Back to NGO Dashboard</a>
            <a href="debugRequestSubmission.jsp" class="btn btn-info">Debug Requests</a>
            <a href="testRequestButton.jsp" class="btn btn-warning">Test Request Button</a>
        </div>
    </div>
</body>
</html>