<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Troubleshoot Request System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>🔧 Troubleshoot Request System</h2>
        
        <div class="alert alert-info">
            <h5>Issue: NGO requests not appearing in donor dashboard</h5>
            <p>Follow these steps to diagnose and fix the problem:</p>
        </div>
        
        <div class="row">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-primary text-white">
                        <h5>Step 1: Verify Database</h5>
                    </div>
                    <div class="card-body">
                        <p>Check if all required tables exist and have correct structure.</p>
                        <a href="verifyDatabase.jsp" class="btn btn-primary">Verify Database</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-warning text-dark">
                        <h5>Step 2: Create/Fix Tables</h5>
                    </div>
                    <div class="card-body">
                        <p>If food_requests table is missing or corrupted, recreate it.</p>
                        <a href="createFoodRequestsTable.jsp" class="btn btn-warning">Fix Tables</a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="row mt-3">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5>Step 3: Test Request Flow</h5>
                    </div>
                    <div class="card-body">
                        <p>Test the complete request submission process.</p>
                        <a href="testRequestButton.jsp" class="btn btn-info">Test Requests</a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-6">
                <div class="card">
                    <div class="card-header bg-success text-white">
                        <h5>Step 4: Debug Submission</h5>
                    </div>
                    <div class="card-body">
                        <p>Debug the request submission with detailed logging.</p>
                        <a href="debugRequestSubmission.jsp" class="btn btn-success">Debug Submission</a>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="mt-4">
            <div class="card">
                <div class="card-header bg-dark text-white">
                    <h5>Common Issues & Solutions</h5>
                </div>
                <div class="card-body">
                    <div class="accordion" id="troubleshootAccordion">
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingOne">
                                <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseOne">
                                    Issue 1: food_requests table doesn't exist
                                </button>
                            </h2>
                            <div id="collapseOne" class="accordion-collapse collapse show" data-bs-parent="#troubleshootAccordion">
                                <div class="accordion-body">
                                    <strong>Solution:</strong> Use the "Fix Tables" button above to create the food_requests table with the correct structure.
                                    <br><br>
                                    <strong>Alternative:</strong> Run the food_requests_table.sql script in your MySQL database.
                                </div>
                            </div>
                        </div>
                        
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingTwo">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseTwo">
                                    Issue 2: NGO not logged in properly
                                </button>
                            </h2>
                            <div id="collapseTwo" class="accordion-collapse collapse" data-bs-parent="#troubleshootAccordion">
                                <div class="accordion-body">
                                    <strong>Solution:</strong> Make sure you're logged in as an NGO user. Check session attributes:
                                    <ul>
                                        <li>userType should be "ngo"</li>
                                        <li>userId should be a valid integer</li>
                                        <li>userName or organizationName should be set</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingThree">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseThree">
                                    Issue 3: No food listings available
                                </button>
                            </h2>
                            <div id="collapseThree" class="accordion-collapse collapse" data-bs-parent="#troubleshootAccordion">
                                <div class="accordion-body">
                                    <strong>Solution:</strong> Make sure there are active food listings in the database:
                                    <ul>
                                        <li>Check food_listings table has records with isActive=1</li>
                                        <li>Ensure donors have posted food listings</li>
                                        <li>Verify food listings haven't expired</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingFour">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFour">
                                    Issue 4: JavaScript/Modal not working
                                </button>
                            </h2>
                            <div id="collapseFour" class="accordion-collapse collapse" data-bs-parent="#troubleshootAccordion">
                                <div class="accordion-body">
                                    <strong>Solution:</strong> Check browser console for JavaScript errors:
                                    <ul>
                                        <li>Ensure Bootstrap JS is loaded</li>
                                        <li>Check if requestFood() function is defined</li>
                                        <li>Verify modal HTML is present in the page</li>
                                        <li>Test with browser developer tools</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        
                        <div class="accordion-item">
                            <h2 class="accordion-header" id="headingFive">
                                <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseFive">
                                    Issue 5: Database connection problems
                                </button>
                            </h2>
                            <div id="collapseFive" class="accordion-collapse collapse" data-bs-parent="#troubleshootAccordion">
                                <div class="accordion-body">
                                    <strong>Solution:</strong> Verify database connection settings:
                                    <ul>
                                        <li>Check MySQL server is running</li>
                                        <li>Verify database name: sharebite_db</li>
                                        <li>Check username: root, password: (empty)</li>
                                        <li>Ensure MySQL JDBC driver is in classpath</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="mt-4">
            <div class="alert alert-success">
                <h5>✅ Quick Fix Steps:</h5>
                <ol>
                    <li>Click "Verify Database" to check table structure</li>
                    <li>If food_requests table is missing, click "Fix Tables"</li>
                    <li>Login as NGO and click "Test Requests" to verify functionality</li>
                    <li>Check donor dashboard to see if requests appear</li>
                </ol>
            </div>
        </div>
        
        <div class="mt-4">
            <a href="ngoDashboard.jsp" class="btn btn-secondary">Back to NGO Dashboard</a>
            <a href="donorDashboard.jsp" class="btn btn-primary">Check Donor Dashboard</a>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>