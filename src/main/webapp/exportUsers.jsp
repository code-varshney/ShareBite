<%@ page language="java" contentType="text/csv; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.DAO.UserDAO" %>
<%@ page import="com.net.bean.UserBean" %>
<%@ page import="java.util.*" %>
<%
response.setHeader("Content-Disposition", "attachment; filename=users.csv");
List<UserBean> users = UserDAO.getAllUsers();
out.println("ID,Name,Email,Phone,Role,Organization Name,Full Address,Verification Status");
if (users != null) {
    for (UserBean user : users) {
        out.println(
            user.getId() + "," +
            (user.getName() != null ? user.getName().replace(",", " ") : "") + "," +
            (user.getEmail() != null ? user.getEmail() : "") + "," +
            (user.getPhone() != null ? user.getPhone() : "") + "," +
            (user.getUserType() != null ? user.getUserType() : "") + "," +
            (user.getOrganizationName() != null ? user.getOrganizationName().replace(",", " ") : "") + "," +
            (user.getFullAddress() != null ? user.getFullAddress().replace(",", " ") : "") + "," +
            (user.getVerificationStatus() != null ? user.getVerificationStatus() : "")
        );
    }
}
%>
