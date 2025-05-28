/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAL;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Nguyễn Tùng
 */
public class DatabaseConnection {
    public  Connection connection;
    public DatabaseConnection()  {
        try {
            String url = "jdbc:mysql://localhost:3306/material_management";
            String user = "root";
            String password = "1234";
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, user, password);
            System.out.println("ket noi thanh cong ");

        } catch (SQLException | ClassNotFoundException e) {
            throw new RuntimeException("Lỗi khi khởi tạo kết nối cơ sở dữ liệu" + e);
        }
    }
    public static void main(String[] args) {
        DatabaseConnection c =  new DatabaseConnection();
        
    }
}
