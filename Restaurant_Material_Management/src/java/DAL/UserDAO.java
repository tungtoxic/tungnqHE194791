package DAL;

import Models.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    private DBContextMySQL dbContext;

    public UserDAO() {
        dbContext = new DBContextMySQL();
    }

    public boolean login(String email, String password) throws SQLException {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rs = stmt.executeQuery();
            boolean loginSuccess = rs.next();
            dbContext.closeConnection(conn);
            return loginSuccess;
        }
    }

    public String getUserFullName(String email) throws SQLException {
        String sql = "SELECT full_name FROM users WHERE email = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, email);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String fullName = rs.getString("full_name");
                dbContext.closeConnection(conn);
                return fullName;
            }
            dbContext.closeConnection(conn);
            return null;
        }
    }

    public boolean register(String fullName, String email, String password, String gender, String dateOfBirth, String address, int roleId) throws SQLException {
        String checkEmailSql = "SELECT COUNT(*) FROM users WHERE email = ?";
        String insertSql = "INSERT INTO users (full_name, email, password, gender, date_of_birth, address, role_id) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkEmailSql);
             PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
            checkStmt.setString(1, email);
            ResultSet rs = checkStmt.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                dbContext.closeConnection(conn);
                return false;
            }

            insertStmt.setString(1, fullName);
            insertStmt.setString(2, email);
            insertStmt.setString(3, password);
            insertStmt.setString(4, gender);
            insertStmt.setString(5, dateOfBirth);
            insertStmt.setString(6, address);
            insertStmt.setInt(7, roleId);
            int rowsAffected = insertStmt.executeUpdate();
            dbContext.closeConnection(conn);
            return rowsAffected > 0;
        }
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT user_id, full_name, email, gender, date_of_birth, address, role_id FROM users";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                User user = new User(
                    rs.getInt("user_id"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("gender"),
                    rs.getDate("date_of_birth"),
                    rs.getString("address"),
                    rs.getInt("role_id")
                );
                users.add(user);
            }
            dbContext.closeConnection(conn);
            return users;
        }
    }

    public boolean deleteUser(int userId) throws SQLException {
        String sql = "DELETE FROM users WHERE user_id = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();
            dbContext.closeConnection(conn);
            return rowsAffected > 0;
        }
    }
}