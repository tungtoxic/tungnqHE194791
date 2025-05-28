package Controllers;

import DAL.DBContextMySQL;
import DAL.UserDAO;
import DAL.RoleDAO;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;
    private DBContextMySQL dbContext;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        dbContext = new DBContextMySQL(); // Khởi tạo DBContext
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            boolean loginSuccess = userDAO.login(email, password);
            if (loginSuccess) {
                HttpSession session = request.getSession();
                session.setAttribute("email", email);
                String fullName = userDAO.getUserFullName(email);
                session.setAttribute("fullName", fullName);

                // Lấy role_id từ database
                String sql = "SELECT role_id FROM users WHERE email = ? AND password = ?";
                try (Connection conn = dbContext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setString(1, email);
                    stmt.setString(2, password);
                    ResultSet rs = stmt.executeQuery();
                    if (rs.next()) {
                        int roleId = rs.getInt("role_id");
                        session.setAttribute("roleId", roleId);

                        // Điều hướng dựa trên role_id
                        switch (roleId) {
                            case 1: // Admin
                                response.sendRedirect("AdminServlet");
                                break;
                            case 2: // Director
                            case 3: // Employee
                            case 4: // Supplier
                            case 5: // Warehouse Employee
                            case 6: // Warehouse Manager
                                response.sendRedirect("dashboard.jsp");
                                break;
                            default:
                                response.sendRedirect("login.jsp?error=Invalid role!");
                        }
                    } else {
                        response.sendRedirect("login.jsp?error=1");
                    }
                }
            } else {
                response.sendRedirect("login.jsp?error=1");
            }
        } catch (SQLException e) {
            throw new ServletException("Login failed: " + e.getMessage(), e);
        }
    }

    @Override
    public String getServletInfo() {
        return "Login Servlet for Restaurant Material Management";
    }
}