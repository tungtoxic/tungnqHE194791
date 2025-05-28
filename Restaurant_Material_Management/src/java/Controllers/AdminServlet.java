package Controllers;

import DAL.UserDAO;
import Models.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


public class AdminServlet extends HttpServlet {
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("roleId") == null || (int) session.getAttribute("roleId") != 1) {
            response.sendRedirect("login.jsp?error=Access denied! Only Admin can access this page.");
            return;
        }

        try {
            List<User> users = userDAO.getAllUsers();
            request.setAttribute("users", users);
            request.getRequestDispatcher("admin.jsp").forward(request, response);
        } catch (Exception e) {
            throw new ServletException("Error retrieving users: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("roleId") == null || (int) session.getAttribute("roleId") != 1) {
            response.sendRedirect("login.jsp?error=Access denied! Only Admin can access this page.");
            return;
        }

        String action = request.getParameter("action");
        int userId = Integer.parseInt(request.getParameter("userId"));

        try {
            if ("delete".equals(action)) {
                boolean deleted = userDAO.deleteUser(userId);
                if (deleted) {
                    response.sendRedirect("AdminServlet?message=User deleted successfully!");
                } else {
                    response.sendRedirect("AdminServlet?error=Failed to delete user!");
                }
            }
        } catch (Exception e) {
            throw new ServletException("Error processing request: " + e.getMessage(), e);
        }
    }

    @Override
    public String getServletInfo() {
        return "Admin Servlet for Restaurant Material Management";
    }
}