<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
    <style>
        body {
            background-color: #1a1a1a;
            font-family: 'Poppins', sans-serif;
            color: #f5f5f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .container {
            background-color: #2a2a2a;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.5);
            width: 100%;
            max-width: 350px;
            text-align: center;
        }
        h1 {
            color: #00c4ff;
        }
        a {
            color: #00c4ff;
            text-decoration: none;
            margin-top: 15px;
            display: inline-block;
        }
        a:hover {
            color: #66b0ff;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Xin chào, <%= session.getAttribute("fullName") %>!</h1>
        <p>Email: <%= session.getAttribute("email") %></p>
        <a href="logout">Đăng xuất</a>
    </div>
</body>
</html>