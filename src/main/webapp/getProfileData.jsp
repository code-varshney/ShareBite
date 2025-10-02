<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%!
    // Simple helper to escape strings for JSON output
    private String jsonEscape(String s) {
        if (s == null) return "null";
        StringBuilder sb = new StringBuilder();
        sb.append('"');
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '\\': sb.append("\\\\"); break;
                case '"': sb.append("\\\""); break;
                case '\n': sb.append("\\n"); break;
                case '\r': sb.append("\\r"); break;
                case '\t': sb.append("\\t"); break;
                default:
                    if (c < 0x20) {
                        sb.append(String.format("\\u%04x", (int)c));
                    } else {
                        sb.append(c);
                    }
            }
        }
        sb.append('"');
        return sb.toString();
    }
%>
<%
// Check if user is logged in
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");

if (userType == null || userId == null) {
    out.print("ERROR: Not authorized");
    return;
}

// Get userId from request
String requestUserId = request.getParameter("userId");
if (requestUserId == null || requestUserId.isEmpty()) {
    out.print("ERROR: User ID not provided");
    return;
}

try {
    int userIdInt = Integer.parseInt(requestUserId);

    // Fetch user data
    UserBean user = UserDAO.getUserById(userIdInt);

    if (user != null) {
        String address = user.getFullAddress() != null ? user.getFullAddress() : user.getAddress();
        StringBuilder jo = new StringBuilder();
        jo.append('{');
        jo.append("\"name\":").append(jsonEscape(user.getName())).append(',');
        jo.append("\"email\":").append(jsonEscape(user.getEmail())).append(',');
        jo.append("\"phone\":").append(jsonEscape(user.getPhone())).append(',');
        jo.append("\"address\":").append(address != null ? jsonEscape(address) : "null").append(',');
        jo.append("\"organizationName\":").append(jsonEscape(user.getOrganizationName())).append(',');
        jo.append("\"donationFrequency\":").append(jsonEscape(user.getDonationFrequency())).append(',');
        jo.append("\"verificationStatus\":").append(jsonEscape(user.getVerificationStatus()));
        jo.append('}');

        out.print("SUCCESS:" + jo.toString());
    } else {
        out.print("ERROR: User not found");
    }
} catch (Exception e) {
    e.printStackTrace();
    out.print("ERROR: " + e.getMessage());
}
%>