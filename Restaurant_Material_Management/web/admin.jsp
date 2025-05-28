<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List" %>
<%@page import="Models.User" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        body {
            background-color: #1a1a1a;
            font-family: 'Poppins', sans-serif;
            color: #f5f5f5;
            margin: 0;
            padding: 20px;
        }
        .container {
            background-color: #2a2a2a;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
            max-width: 1200px;
            margin: 0 auto;
        }
        h1 {
            color: #00c4ff;
            text-align: center;
            margin-bottom: 20px;
        }
        .menu {
            margin-bottom: 20px;
        }
        .menu a {
            color: #00c4ff;
            text-decoration: none;
            margin-right: 15px;
            font-weight: 500;
        }
        .menu a:hover {
            color: #66b0ff;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #444;
        }
        th {
            background-color: #333;
            color: #00c4ff;
        }
        tr:nth-child(even) {
            background-color: #2d2d2d;
        }
        .error, .success {
            text-align: center;
            margin: 10px 0;
        }
        .error { color: #ff4444; }
        .success { color: #00ff00; }
        .action-btn {
            background: #007bff;
            color: #fff;
            border: none;
            padding: 5px 10px;
            border-radius: 5px;
            cursor: pointer;
        }
        .action-btn:hover {
            background: #0056b3;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Admin Dashboard</h1>
        <div class="menu">
            <a href="AdminServlet">Quản Lý Người Dùng</a>
            <a href="#">Quản Lý Thông Tin Liên Hệ</a>
            <a href="#">Kiểm Kê Tồn Kho</a>
            <a href="#">Báo Cáo Thống Kê</a>
            <a href="LogoutServlet">Đăng Xuất</a>
        </div>
        <% if (request.getParameter("error") != null) { %>
            <p class="error"><%= request.getParameter("error") %></p>
        <% } %>
        <% if (request.getParameter("message") != null) { %>
            <p class="success"><%= request.getParameter("message") %></p>
        <% } %>
        <table>
            <tr>
                <th>ID</th>
                <th>Họ và Tên</th>
                <th>Email</th>
                <th>Giới Tính</th>
                <th>Ngày Sinh</th>
                <th>Địa Chỉ</th>
                <th>Quyền</th>
                <th>Hành Động</th>
            </tr>
            <% List<User> users = (List<User>) request.getAttribute("users");
               if (users != null) {
                   for (User user : users) { %>
            <tr>
                <td><%= user.getUserId() %></td>
                <td><%= user.getFullName() %></td>
                <td><%= user.getEmail() %></td>
                <td><%= user.getGender() != null ? user.getGender() : "N/A" %></td>
                <td><%= user.getDateOfBirth() != null ? user.getDateOfBirth() : "N/A" %></td>
                <td><%= user.getAddress() != null ? user.getAddress() : "N/A" %></td>
                <td><%= user.getRoleId() == 1 ? "Admin" : "Other" %></td>
                <td>
                    <form action="AdminServlet" method="post" style="display:inline;">
                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                        <input type="hidden" name="action" value="delete">
                        <button type="submit" class="action-btn">Xóa</button>
                    </form>
                </td>
            </tr>
            <% }
               } %>
        </table>
    </div>
</body>
</html>