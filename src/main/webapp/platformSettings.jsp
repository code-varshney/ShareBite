<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%
String action = request.getParameter("action");
String autoVerifyDonors = request.getParameter("autoVerifyDonors");
String requireNgoVerification = request.getParameter("requireNgoVerification");
if ("savePlatformSettings".equals(action)) {
    session.setAttribute("autoVerifyDonors", autoVerifyDonors);
    session.setAttribute("requireNgoVerification", requireNgoVerification);
    out.print("{\"success\":true}");
    return;
}
out.print("{\"success\":false}");
%>
