<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="java.util.*" %>

<%
// Get all user data
List<UserBean> allUsers = UserDAO.getAllUsers();
List<UserBean> donors = UserDAO.getUsersByType("donor");
List<UserBean> ngos = UserDAO.getUsersByType("ngo");
List<UserBean> verifiedNgos = UserDAO.getVerifiedUsersByType("ngo");
List<UserBean> pendingUsers = UserDAO.getPendingVerificationUsers();

int totalUsers = allUsers.size();
int totalDonors = donors.size();
int totalNgos = ngos.size();
int totalVerifiedNgos = verifiedNgos.size();
int totalPendingUsers = pendingUsers.size();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); min-height: 100vh; }
        .admin-container { background: rgba(255,255,255,0.95); backdrop-filter: blur(20px); border-radius: 20px; box-shadow: 0 20px 60px rgba(0,0,0,0.2); margin: 2rem auto; padding: 2rem; }
        .stats-card { background: linear-gradient(135deg, #28a745, #20c997); color: white; border-radius: 15px; padding: 1.5rem; margin-bottom: 1rem; box-shadow: 0 8px 25px rgba(40,167,69,0.3); }
        .stats-number { font-size: 2.5rem; font-weight: 700; }
        .table { border-radius: 15px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
        .table th { background: linear-gradient(135deg, #007bff, #6610f2); color: white; border: none; }
        .badge-verified { background: linear-gradient(135deg, #28a745, #20c997); }
        .badge-pending { background: linear-gradient(135deg, #ffc107, #fd7e14); color: #000; }
        .btn-verify { background: linear-gradient(135deg, #28a745, #20c997); border: none; }
        .btn-reject { background: linear-gradient(135deg, #dc3545, #c82333); border: none; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="admin-container">
            <div class="text-center mb-4">
                <h2><i class="fas fa-shield-alt me-2"></i>Admin Dashboard</h2>
                <p class="text-muted">Manage users, NGOs, and verifications</p>
            </div>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-md-2">
                    <div class="stats-card text-center">
                        <div class="stats-number"><%= totalUsers %></div>
                        <div>Total Users</div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="stats-card text-center">
                        <div class="stats-number"><%= totalDonors %></div>
                        <div>Donors</div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="stats-card text-center">
                        <div class="stats-number"><%= totalNgos %></div>
                        <div>NGOs</div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="stats-card text-center">
                        <div class="stats-number"><%= totalVerifiedNgos %></div>
                        <div>Verified NGOs</div>
                    </div>
                </div>
                <div class="col-md-2">
                    <div class="stats-card text-center">
                        <div class="stats-number"><%= totalPendingUsers %></div>
                        <div>Pending</div>
                    </div>
                </div>
            </div>

            <!-- Navigation Tabs -->
            <ul class="nav nav-tabs mb-4" id="adminTabs">
                <li class="nav-item">
                    <a class="nav-link active" data-bs-toggle="tab" href="#users">All Users</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" href="#pending">Pending Verification</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" href="#donors">All Donors</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" href="#ngos">All NGOs</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" data-bs-toggle="tab" href="#verified">Verified NGOs</a>
                </li>
            </ul>

            <div class="tab-content">
                <!-- All Users Tab -->
                <div class="tab-pane fade show active" id="users">
                    <h4><i class="fas fa-users me-2"></i>All Users (<%= totalUsers %>)</h4>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Type</th>
                                    <th>Organization</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Verification</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (UserBean user : allUsers) { %>
                                <tr>
                                    <td><%= user.getName() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td><span class="badge bg-<%= "donor".equals(user.getUserType()) ? "success" : "info" %>"><%= user.getUserType().toUpperCase() %></span></td>
                                    <td><%= user.getOrganizationName() != null ? user.getOrganizationName() : ("donor".equals(user.getUserType()) ? "Individual" : "-") %></td>
                                    <td><%= user.getPhone() != null ? user.getPhone() : "-" %></td>
                                    <td><%= user.getFullAddress() != null ? user.getFullAddress() : "-" %></td>
                                    <td>
                                        <% if ("verified".equals(user.getVerificationStatus())) { %>
                                            <span class="badge badge-verified">Verified</span>
                                        <% } else if ("pending".equals(user.getVerificationStatus())) { %>
                                            <span class="badge badge-pending">Pending</span>
                                        <% } else if ("rejected".equals(user.getVerificationStatus())) { %>
                                            <span class="badge bg-danger">Rejected</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary">N/A</span>
                                        <% } %>
                                    </td>
                                    <td><span class="badge badge-verified">Active</span></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Pending Verification Tab -->
                <div class="tab-pane fade" id="pending">
                    <h4><i class="fas fa-clock me-2"></i>Pending Verification (<%= totalPendingUsers %>)</h4>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Type</th>
                                    <th>Organization</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (UserBean user : pendingUsers) { %>
                                <tr>
                                    <td><%= user.getName() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td><span class="badge bg-info"><%= user.getUserType().toUpperCase() %></span></td>
                                    <td><%= user.getOrganizationName() != null ? user.getOrganizationName() : "-" %></td>
                                    <td><%= user.getPhone() != null ? user.getPhone() : "-" %></td>
                                    <td><%= user.getFullAddress() != null ? user.getFullAddress() : "-" %></td>
                                    <td>
                                        <button class="btn btn-verify btn-sm me-1" onclick="updateVerification(<%= user.getId() %>, 'verified')">
                                            <i class="fas fa-check"></i> Verify
                                        </button>
                                        <button class="btn btn-reject btn-sm" onclick="updateVerification(<%= user.getId() %>, 'rejected')">
                                            <i class="fas fa-times"></i> Reject
                                        </button>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- All Donors Tab -->
                <div class="tab-pane fade" id="donors">
                    <h4><i class="fas fa-heart me-2"></i>All Donors (<%= totalDonors %>)</h4>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Organization</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Donation Frequency</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (UserBean user : donors) { %>
                                <tr>
                                    <td><%= user.getName() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td><%= user.getOrganizationName() != null ? user.getOrganizationName() : "Individual" %></td>
                                    <td><%= user.getPhone() != null ? user.getPhone() : "-" %></td>
                                    <td><%= user.getFullAddress() != null ? user.getFullAddress() : "-" %></td>
                                    <td><%= user.getDonationFrequency() != null ? user.getDonationFrequency() : "-" %></td>
                                    <td><span class="badge badge-verified">Active</span></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- All NGOs Tab -->
                <div class="tab-pane fade" id="ngos">
                    <h4><i class="fas fa-users me-2"></i>All NGOs (<%= totalNgos %>)</h4>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Organization</th>
                                    <th>Contact Person</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Type</th>
                                    <th>Verification</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (UserBean user : ngos) { %>
                                <tr>
                                    <td><%= user.getOrganizationName() != null ? user.getOrganizationName() : user.getName() %></td>
                                    <td><%= user.getName() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td><%= user.getPhone() != null ? user.getPhone() : "-" %></td>
                                    <td><%= user.getFullAddress() != null ? user.getFullAddress() : "-" %></td>
                                    <td><%= user.getOrganizationType() != null ? user.getOrganizationType() : "-" %></td>
                                    <td>
                                        <% if ("verified".equals(user.getVerificationStatus())) { %>
                                            <span class="badge badge-verified">Verified</span>
                                        <% } else if ("pending".equals(user.getVerificationStatus())) { %>
                                            <span class="badge badge-pending">Pending</span>
                                        <% } else { %>
                                            <span class="badge bg-danger">Rejected</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Verified NGOs Tab -->
                <div class="tab-pane fade" id="verified">
                    <h4><i class="fas fa-check-circle me-2"></i>Verified NGOs (<%= totalVerifiedNgos %>)</h4>
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Organization</th>
                                    <th>Contact Person</th>
                                    <th>Email</th>
                                    <th>Phone</th>
                                    <th>Address</th>
                                    <th>Type</th>
                                    <th>Verified Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (UserBean user : verifiedNgos) { %>
                                <tr>
                                    <td><%= user.getOrganizationName() != null ? user.getOrganizationName() : user.getName() %></td>
                                    <td><%= user.getName() %></td>
                                    <td><%= user.getEmail() %></td>
                                    <td><%= user.getPhone() != null ? user.getPhone() : "-" %></td>
                                    <td><%= user.getFullAddress() != null ? user.getFullAddress() : "-" %></td>
                                    <td><%= user.getOrganizationType() != null ? user.getOrganizationType() : "-" %></td>
                                    <td><%= user.getCreatedAt() != null ? user.getCreatedAt().substring(0, 10) : "-" %></td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateVerification(userId, status) {
            if (confirm(`Are you sure you want to ${status} this user?`)) {
                fetch('admin/updateVerification.jsp', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: `userId=${userId}&status=${status}`
                })
                .then(response => response.text())
                .then(data => {
                    if (data.includes('SUCCESS')) {
                        alert(`User ${status} successfully!`);
                        location.reload();
                    } else {
                        alert('Error updating verification status');
                    }
                })
                .catch(error => {
                    alert('Error updating verification status');
                });
            }
        }
    </script>
</body>
</html>