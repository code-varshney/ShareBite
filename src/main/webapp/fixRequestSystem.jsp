<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="com.net.DAO.FoodListingDAO" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="java.util.*" %>

<!DOCTYPE html>
<html>
<head>
    <title>Fix Request System - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Fix Request System</h2>
        
        <%
        String action = request.getParameter("action");
        String dclass = "com.mysql.cj.jdbc.Driver";
        String url = "jdbc:mysql://localhost:3306/sharebite_db";
        String username = "root";
        String password = "";
        
        if ("createTable".equals(action)) {
            try {
                Class.forName(dclass);
                Connection con = DriverManager.getConnection(url, username, password);
                
                // Drop and recreate table
                Statement stmt = con.createStatement();
                stmt.execute("DROP TABLE IF EXISTS food_requests");
                
                String createTableSQL = "CREATE TABLE food_requests (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY," +
                    "ngoId INT NOT NULL," +
                    "foodListingId INT NOT NULL," +
                    "requestMessage TEXT," +
                    "pickupDate DATE NOT NULL," +
                    "pickupTime TIME," +
                    "status ENUM('pending', 'approved', 'rejected', 'completed') DEFAULT 'pending'," +
                    "donorResponse TEXT," +
                    "createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP," +
                    "updatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP," +
                    "isActive BOOLEAN DEFAULT TRUE," +
                    "INDEX idx_ngo_id (ngoId)," +
                    "INDEX idx_food_listing_id (foodListingId)," +
                    "INDEX idx_status (status)" +
                    ")";
                
                stmt.execute(createTableSQL);
                out.println("<div class='alert alert-success'>✓ Table created successfully</div>");
                
                con.close();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            }
        }
        
        if ("insertSample".equals(action)) {
            try {
                Class.forName(dclass);
                Connection con = DriverManager.getConnection(url, username, password);
                
                // Get first NGO and first food listing - try different possible column names
                PreparedStatement ps;
                ResultSet rs;
                int ngoId = 0;
                
                // Try different possible column names for user type
                String[] possibleColumns = {"userType", "user_type", "type", "role", "account_type"};
                for (String column : possibleColumns) {
                    try {
                        ps = con.prepareStatement("SELECT id FROM users WHERE " + column + "='ngo' LIMIT 1");
                        rs = ps.executeQuery();
                        if (rs.next()) {
                            ngoId = rs.getInt("id");
                            out.println("<p>Found NGO using column: " + column + "</p>");
                            break;
                        }
                    } catch (SQLException e) {
                        // Column doesn't exist, try next one
                        continue;
                    }
                }
                
                // If no specific NGO found, just get any user
                if (ngoId == 0) {
                    ps = con.prepareStatement("SELECT id FROM users LIMIT 1");
                    rs = ps.executeQuery();
                    if (rs.next()) {
                        ngoId = rs.getInt("id");
                        out.println("<p>Using first available user ID: " + ngoId + "</p>");
                    }
                }
                
                ps = con.prepareStatement("SELECT id, donorId FROM food_listings WHERE isActive=1 LIMIT 1");
                rs = ps.executeQuery();
                int foodListingId = 0, donorId = 0;
                if (rs.next()) {
                    foodListingId = rs.getInt("id");
                    donorId = rs.getInt("donorId");
                }
                
                if (ngoId > 0 && foodListingId > 0) {
                    ps = con.prepareStatement("INSERT INTO food_requests (ngoId, foodListingId, requestMessage, pickupDate, pickupTime, status, isActive) VALUES (?, ?, ?, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', 'pending', 1)");
                    ps.setInt(1, ngoId);
                    ps.setInt(2, foodListingId);
                    ps.setString(3, "Sample request for testing - NGO " + ngoId + " requesting food from donor " + donorId);
                    
                    int result = ps.executeUpdate();
                    if (result > 0) {
                        out.println("<div class='alert alert-success'>✓ Sample request inserted</div>");
                        out.println("<p>NGO ID: " + ngoId + ", Food Listing ID: " + foodListingId + ", Donor ID: " + donorId + "</p>");
                    }
                } else {
                    out.println("<div class='alert alert-warning'>No NGO or food listing found</div>");
                }
                
                con.close();
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            }
        }
        
        if ("testDAO".equals(action)) {
            try {
                String testDonorId = request.getParameter("donorId");
                if (testDonorId != null && !testDonorId.isEmpty()) {
                    int donorId = Integer.parseInt(testDonorId);
                    List<FoodRequestBean> requests = FoodRequestDAO.getFoodRequestsForDonor(donorId);
                    
                    out.println("<div class='alert alert-info'>Testing DAO for donor ID: " + donorId + "</div>");
                    out.println("<p><strong>Requests found: " + (requests != null ? requests.size() : 0) + "</strong></p>");
                    
                    if (requests != null && !requests.isEmpty()) {
                        out.println("<table class='table table-sm'>");
                        out.println("<tr><th>ID</th><th>NGO Name</th><th>Food Name</th><th>Status</th><th>Date</th></tr>");
                        for (FoodRequestBean req : requests) {
                            out.println("<tr>");
                            out.println("<td>" + req.getId() + "</td>");
                            out.println("<td>" + req.getNgoName() + "</td>");
                            out.println("<td>" + req.getFoodName() + "</td>");
                            out.println("<td>" + req.getStatus() + "</td>");
                            out.println("<td>" + req.getCreatedAt() + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</table>");
                    }
                }
            } catch (Exception e) {
                out.println("<div class='alert alert-danger'>Error: " + e.getMessage() + "</div>");
            }
        }
        %>
        
        <!-- Current Status -->
        <div class="row mb-4">
            <div class="col-md-12">
                <h4>Current System Status</h4>
                <%
                try {
                    Class.forName(dclass);
                    Connection con = DriverManager.getConnection(url, username, password);
                    
                    // Check table existence
                    DatabaseMetaData dbm = con.getMetaData();
                    ResultSet tables = dbm.getTables(null, null, "food_requests", null);
                    if (tables.next()) {
                        out.println("<div class='alert alert-success'>✓ food_requests table exists</div>");
                        
                        // Count requests
                        PreparedStatement ps = con.prepareStatement("SELECT COUNT(*) FROM food_requests");
                        ResultSet rs = ps.executeQuery();
                        if (rs.next()) {
                            int count = rs.getInt(1);
                            out.println("<p><strong>Total requests in database: " + count + "</strong></p>");
                        }
                        
                        // Show sample data
                        ps = con.prepareStatement("SELECT fr.id, fr.ngoId, fr.foodListingId, fr.status, fl.donorId FROM food_requests fr LEFT JOIN food_listings fl ON fr.foodListingId = fl.id LIMIT 5");
                        rs = ps.executeQuery();
                        out.println("<table class='table table-sm'>");
                        out.println("<tr><th>Request ID</th><th>NGO ID</th><th>Food Listing ID</th><th>Donor ID</th><th>Status</th></tr>");
                        while (rs.next()) {
                            out.println("<tr>");
                            out.println("<td>" + rs.getInt("id") + "</td>");
                            out.println("<td>" + rs.getInt("ngoId") + "</td>");
                            out.println("<td>" + rs.getInt("foodListingId") + "</td>");
                            out.println("<td>" + rs.getInt("donorId") + "</td>");
                            out.println("<td>" + rs.getString("status") + "</td>");
                            out.println("</tr>");
                        }
                        out.println("</table>");
                        
                    } else {
                        out.println("<div class='alert alert-danger'>✗ food_requests table does not exist</div>");
                    }
                    
                    con.close();
                } catch (Exception e) {
                    out.println("<div class='alert alert-danger'>Database error: " + e.getMessage() + "</div>");
                }
                %>
            </div>
        </div>
        
        <!-- Actions -->
        <div class="row">
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5>1. Create Table</h5>
                    </div>
                    <div class="card-body">
                        <p>Create/recreate the food_requests table with correct structure.</p>
                        <form method="post">
                            <input type="hidden" name="action" value="createTable">
                            <button type="submit" class="btn btn-warning">Create Table</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5>2. Insert Sample Data</h5>
                    </div>
                    <div class="card-body">
                        <p>Insert a sample request for testing.</p>
                        <form method="post">
                            <input type="hidden" name="action" value="insertSample">
                            <button type="submit" class="btn btn-success">Insert Sample</button>
                        </form>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4">
                <div class="card">
                    <div class="card-header">
                        <h5>3. Test DAO</h5>
                    </div>
                    <div class="card-body">
                        <p>Test the DAO method with a donor ID.</p>
                        <form method="post">
                            <input type="hidden" name="action" value="testDAO">
                            <div class="mb-2">
                                <input type="number" name="donorId" class="form-control" placeholder="Donor ID" value="1">
                            </div>
                            <button type="submit" class="btn btn-info">Test DAO</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        <hr class="mt-4">
        <div class="mt-4">
            <h4>Quick Links</h4>
            <a href="debugRequests.jsp" class="btn btn-info me-2">Debug Requests</a>
            <a href="donorDashboard.jsp" class="btn btn-primary me-2">Donor Dashboard</a>
            <a href="ngoDashboard.jsp" class="btn btn-success me-2">NGO Dashboard</a>
            <a href="insertTestRequest.jsp" class="btn btn-secondary">Insert Test Request</a>
        </div>
    </div>
</body>
</html>