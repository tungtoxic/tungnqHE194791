package DAL;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContextMySQL {
    private final String url = "jdbc:mysql://localhost:3306/restaurant_material_management";
    private final String username = "root";
    private final String password = "1234";
    private final String driver = "com.mysql.cj.jdbc.Driver";

    public DBContextMySQL() {
        // Không khởi tạo connection tĩnh trong constructor
    }

    public Connection getConnection() {
        try {
            Class.forName(driver);
            System.out.println("Trying to connect to: " + url);
            Connection conn = DriverManager.getConnection(url, username, password);
            if (conn == null || conn.isClosed()) {
                throw new SQLException("Không thể tạo kết nối: Kết nối trả về null hoặc đã bị đóng.");
            }
            System.out.println("Kết nối thành công: " + conn);
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("Không tìm thấy driver JDBC: " + e.getMessage());
            throw new RuntimeException("Không tìm thấy driver JDBC", e);
        } catch (SQLException e) {
            System.err.println("Lỗi kết nối tới MySQL: " + e.getMessage());
            throw new RuntimeException("Lỗi kết nối tới MySQL", e);
        }
    }

    public void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                if (!conn.isClosed()) {
                    conn.close();
                    System.out.println("Đã đóng kết nối tới MySQL.");
                }
            } catch (SQLException e) {
                System.err.println("Lỗi khi đóng kết nối: " + e.getMessage());
            }
        }
    }

    public static void main(String[] args) {
        try {
            DBContextMySQL dbContext = new DBContextMySQL();
            Connection conn = dbContext.getConnection();
            System.out.println("Kiểm tra kết nối thành công! Connection: " + conn);
            dbContext.closeConnection(conn);
        } catch (Exception e) {
            System.err.println("Lỗi khi kiểm tra kết nối: " + e.getMessage());
            e.printStackTrace();
        }
    }
}