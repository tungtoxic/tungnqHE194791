package Controllers;

import DAL.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

public class LoginServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
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
                response.sendRedirect("dashboard.jsp");
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