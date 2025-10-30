<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Create Food Requests Table</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Create Food Requests Table</h2>
        
        <%
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            Connection con = null;
            Statement stmt = null;
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/sharebite_db", "root", "");
                stmt = con.createStatement();
                
                // Drop existing table if it exists
                try {
                    stmt.executeUpdate("DROP TABLE IF EXISTS food_requests");
                    out.println("<div class='alert alert-warning'>⚠️ Dropped existing food_requests table</div>");
                } catch (Exception e) {
                    // Table might not exist, that's okay
                }
                
                // Create the table
                String createTableSQL = 
                    "CREATE TABLE food_requests (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "ngoId INT NOT NULL, " +
                    "foodListingId INT NOT NULL, " +
                    "requestMessage TEXT, " +
                    "pickupDate DATE NOT NULL, " +
                    "pickupTime TIME, " +
                    "status ENUM('pending', 'approved', 'rejected', 'completed') DEFAULT 'pending', " +
                    "donorResponse TEXT, " +
                    "createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, " +
                    "isActive BOOLEAN DEFAULT TRUE, " +
                    "INDEX idx_ngo_id (ngoId), " +
                    "INDEX idx_food_listing_id (foodListingId), " +
                    "INDEX idx_status (status), " +
                    "INDEX idx_created_at (createdAt)" +
                    ")";
                
                stmt.executeUpdate(createTableSQL);
                out.println("<div class='alert alert-success'>✅ food_requests table created successfully!</div>");
                
                // Insert sample data
                String insertSQL = 
                    "INSERT INTO food_requests (ngoId, foodListingId, requestMessage, pickupDate, pickupTime, status) " +
                    "SELECT " +
                    "(SELECT id FROM users ORDER BY id LIMIT 1) as ngoId, " +
                    "(SELECT id FROM food_listings WHERE isActive=1 ORDER BY id LIMIT 1) as foodListingId, " +
                    "'Sample request for testing purposes' as requestMessage, " +
                    "DATE_ADD(CURDATE(), INTERVAL 1 DAY) as pickupDate, " +
                    "'14:00:00' as pickupTime, " +
                    "'pending' as status " +
                    "WHERE EXISTS (SELECT 1 FROM users) " +
                    "AND EXISTS (SELECT 1 FROM food_listings WHERE isActive=1)";
                
                int sampleRows = stmt.executeUpdate(insertSQL);
                if (sampleRows > 0) {
                    out.println("<div class='alert alert-info'>📊 Inserted " + sampleRows + " sample record(s)</div>");
                } else {
                    out.println("<div class='alert alert-warning'>⚠️ No sample data inserted (no users or food listings found)</div>");
                }
                
                // Verify the table
                ResultSet rs = stmt.executeQuery("SELECT COUNT(*) as count FROM food_requests");
                if (rs.next()) {
                    int count = rs.getInt("count");
                    out.println("<div class='alert alert-success'>✅ Table verification: " + count + " records in food_requests table</div>");
                }
                rs.close();
                
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>❌ Error creating table: " + e.getMessage() + "</div>");
                e.printStackTrace();
            } finally {
                try {
                    if (stmt != null) stmt.close();
                    if (con != null) con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
        %>
            <div class="alert alert-warning">
                <h5>⚠️ Warning</h5>
                <p>This will drop the existing food_requests table (if it exists) and create a new one with the correct structure.</p>
                <p>Any existing request data will be lost!</p>
            </div>
            
            <form method="post">
                <input type="hidden" name="action" value="create">
                <button type="submit" class="btn btn-danger" onclick="return confirm('Are you sure you want to recreate the food_requests table? This will delete all existing request data!')">
                    Create Food Requests Table
                </button>
            </form>
        <%
        }
        %>
        
        <div class="mt-4">
            <a href="verifyDatabase.jsp" class="btn btn-info">Verify Database</a>
            <a href="ngoDashboard.jsp" class="btn btn-secondary">Back to NGO Dashboard</a>
        </div>
    </div>
</body>
</html>