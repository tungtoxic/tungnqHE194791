<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">
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
            animation: fadeIn 0.5s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .logo {
            font-size: 24px;
            font-weight: 600;
            color: #00c4ff;
            margin-bottom: 20px;
        }
        h2 {
            margin-bottom: 20px;
            color: #00c4ff;
        }
        input[type="text"], input[type="password"] {
            width: 100%;
            padding: 12px;
            margin: 10px 0;
            border: none;
            border-radius: 5px;
            background-color: #fff;
            color: #000;
            font-size: 14px;
            font-family: 'Poppins', sans-serif;
        }
        input[type="submit"] {
            background: linear-gradient(45deg, #007bff, #00c4ff);
            color: #fff;
            padding: 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 100%;
            margin-top: 10px;
            font-size: 16px;
            transition: background 0.3s;
        }
        input[type="submit"]:hover {
            background: linear-gradient(45deg, #0056b3, #0099cc);
        }
        .error {
            color: #ff4444;
            margin-bottom: 15px;
            font-size: 14px;
            text-align: center;
        }
        @media (max-width: 400px) {
            .container {
                padding: 20px;
                margin: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="logo">Hệ Thống Quản Lý Vật Tư Nhà Hàng</div>
        <h2>Đăng nhập</h2>
        <% if (request.getParameter("error") != null) { %>
            <p class="error">Email hoặc mật khẩu không đúng!</p>
        <% } %>
        <form action="LoginServlet" method="post">
            <input type="text" name="email" placeholder="Email" required>
            <input type="password" name="password" placeholder="Mật khẩu" required>
            <input type="submit" value="Đăng nhập">
        </form>
    </div>
</body>
</html>