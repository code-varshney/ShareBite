<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.net.bean.ChatMessageBean" %>
<%@ page import="com.net.bean.FoodRequestBean" %>
<%@ page import="com.net.DAO.ChatDAO" %>
<%@ page import="com.net.DAO.FoodRequestDAO" %>
<%@ page import="java.util.*" %>
<%
String userType = (String) session.getAttribute("userType");
String userId = (String) session.getAttribute("userId");
String requestIdStr = request.getParameter("requestId");

if (userType == null || userId == null || requestIdStr == null) {
    response.sendRedirect("donorLogin.jsp");
    return;
}

int currentUserId = Integer.parseInt(userId);
int requestId = Integer.parseInt(requestIdStr);

FoodRequestBean foodRequest = FoodRequestDAO.getFoodRequestById(requestId);
if (foodRequest == null || (!foodRequest.getStatus().equals("approved") && !foodRequest.getStatus().equals("completed"))) {
    response.sendRedirect("donorDashboard.jsp");
    return;
}

List<ChatMessageBean> messages = ChatDAO.getChatMessages(requestId);
ChatDAO.markMessagesAsRead(requestId, currentUserId);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chat - ShareBite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: linear-gradient(-45deg, #28a745, #20c997, #17a2b8, #007bff); min-height: 100vh; }
        .chat-container { background: rgba(255,255,255,0.95); backdrop-filter: blur(20px); border-radius: 25px; box-shadow: 0 20px 60px rgba(0,0,0,0.2); margin: 2rem auto; max-width: 800px; }
        .chat-header { background: linear-gradient(135deg, #28a745, #20c997); color: white; border-radius: 25px 25px 0 0; padding: 1.5rem; }
        .chat-messages { height: 400px; overflow-y: auto; padding: 1rem; }
        .message { margin-bottom: 1rem; }
        .message.sent { text-align: right; }
        .message.received { text-align: left; }
        .message-bubble { display: inline-block; max-width: 70%; padding: 0.75rem 1rem; border-radius: 20px; }
        .message.sent .message-bubble { background: #28a745; color: white; }
        .message.received .message-bubble { background: #f8f9fa; color: #333; }
        .message-time { font-size: 0.75rem; opacity: 0.7; margin-top: 0.25rem; }
        .chat-input { padding: 1rem; border-top: 1px solid #dee2e6; }
    </style>
</head>
<body>
    <div class="container">
        <div class="chat-container">
            <div class="chat-header">
                <div class="d-flex justify-content-between align-items-center">
                    <h5><i class="fas fa-comments me-2"></i>Chat - Request #<%= requestId %></h5>
                    <button onclick="history.back()" class="btn btn-light btn-sm">
                        <i class="fas fa-arrow-left me-1"></i>Back
                    </button>
                </div>
            </div>
            
            <div class="chat-messages" id="chatMessages">
                <% if (messages.isEmpty()) { %>
                    <div class="text-center text-muted py-4">
                        <i class="fas fa-comment-dots fa-3x mb-3"></i>
                        <p>No messages yet. Start the conversation!</p>
                    </div>
                <% } else { %>
                    <% for (ChatMessageBean msg : messages) { %>
                        <div class="message <%= msg.getSenderId() == currentUserId ? "sent" : "received" %>">
                            <div class="message-bubble">
                                <%= msg.getMessage() %>
                            </div>
                            <div class="message-time">
                                <%= msg.getSenderName() %> • <%= msg.getSentAt() %>
                            </div>
                        </div>
                    <% } %>
                <% } %>
            </div>
            
            <div class="chat-input">
                <form id="messageForm" onsubmit="sendMessage(event)">
                    <div class="input-group">
                        <input type="text" class="form-control" id="messageInput" placeholder="Type your message..." required>
                        <button type="submit" class="btn btn-success">
                            <i class="fas fa-paper-plane"></i>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        function sendMessage(event) {
            event.preventDefault();
            const messageInput = document.getElementById('messageInput');
            const message = messageInput.value.trim();
            
            if (!message) return;
            
            fetch('sendMessage.jsp', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                body: 'requestId=<%= requestId %>&message=' + encodeURIComponent(message)
            })
            .then(response => response.text())
            .then(data => {
                if (data.includes('SUCCESS')) {
                    messageInput.value = '';
                    location.reload();
                } else {
                    alert('Error sending message');
                }
            });
        }
        
        // Auto-refresh messages every 5 seconds
        setInterval(() => location.reload(), 5000);
    </script>
</body>
</html>