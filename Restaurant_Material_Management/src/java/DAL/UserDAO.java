package DAL;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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

    // Lấy thông tin user sau khi đăng nhập (nếu cần)
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
}