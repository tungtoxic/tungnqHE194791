-- 🔹 Tạo database
CREATE DATABASE IF NOT EXISTS restaurant_material_management;
USE restaurant_material_management;

-- 🔹 Bảng roles - Quản lý Phân quyền Người dùng
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE -- Vai trò: Admin, Giám đốc, Quản lý kho, Nhân viên kho, Nhân viên nhà hàng
);

-- 🔹 Bảng users - Quản lý Tài khoản Người dùng
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL, -- Họ và tên người dùng
    email VARCHAR(100) UNIQUE NOT NULL, -- Email đăng nhập
    password VARCHAR(20) NOT NULL, -- Mật khẩu cho phép chữ + số, không hash
    role_id INT NOT NULL, -- Quyền của người dùng
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- 🔹 Bảng suppliers - Nhà Cung Cấp
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- Tên nhà cung cấp
    contact_info TEXT, -- Thông tin liên hệ
    address VARCHAR(255) -- Địa chỉ nhà cung cấp
);

-- 🔹 Bảng categories - Danh Mục Vật Tư
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- Tên danh mục vật tư
    parent_id INT DEFAULT NULL, -- Danh mục cha (phân cấp danh mục)
    FOREIGN KEY (parent_id) REFERENCES categories(category_id)
);

-- 🔹 Bảng materials - Quản lý Vật Tư
CREATE TABLE materials (
    material_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL, -- Tên vật tư
    category_id INT NOT NULL, -- Thuộc danh mục nào
    supplier_id INT, -- Nhà cung cấp của vật tư này
    image_url VARCHAR(255), -- Ảnh minh họa vật tư
    material_condition ENUM('new', 'used', 'damaged'), -- Tình trạng vật tư
    price DECIMAL(12,2) NOT NULL, -- Giá vật tư
    description TEXT, -- Mô tả chi tiết vật tư
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- 🔹 Bảng inventory - Quản lý Kho Vật Tư
CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    material_id INT NOT NULL, -- Vật tư được quản lý trong kho
    quantity INT NOT NULL, -- Số lượng tồn kho
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- Cập nhật thời gian khi có thay đổi
    FOREIGN KEY (material_id) REFERENCES materials(material_id)
);

-- 🔹 Bảng import_forms - Phiếu Nhập Kho
CREATE TABLE import_forms (
    import_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- Người thực hiện nhập kho
    supplier_id INT, -- Nhà cung cấp liên quan đến nhập hàng (nếu có)
    import_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời gian nhập kho
    note TEXT, -- Ghi chú về nhập kho
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- 🔹 Bảng export_forms - Phiếu Xuất Kho
CREATE TABLE export_forms (
    export_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- Người thực hiện xuất kho
    export_date DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời gian xuất kho
    recipient VARCHAR(100), -- Người nhận vật tư
    note TEXT, -- Ghi chú xuất kho
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 🔹 Bảng material_history - Lịch sử Nhập/Xuất Vật Tư
CREATE TABLE material_history (
    history_id INT AUTO_INCREMENT PRIMARY KEY,
    material_id INT NOT NULL, -- Vật tư liên quan đến lịch sử
    quantity INT NOT NULL, -- Số lượng thay đổi
    action_type ENUM('import', 'export') NOT NULL, -- Hành động: Nhập hoặc Xuất
    reference_id INT NOT NULL, -- Liên kết đến phiếu nhập/xuất
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời điểm xảy ra hành động
    FOREIGN KEY (material_id) REFERENCES materials(material_id)
);

-- 🔹 Bảng request_types - Loại Yêu Cầu
CREATE TABLE request_types (
    request_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(100) NOT NULL -- Loại yêu cầu (Xuất kho, Mua vật tư, Sửa chữa...)
);

-- 🔹 Bảng requests - Yêu Cầu Xuất/Mua/Sửa Vật Tư
CREATE TABLE requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    requester_id INT NOT NULL, -- Người yêu cầu
    request_type_id INT NOT NULL, -- Loại yêu cầu
    material_id INT NOT NULL, -- Vật tư liên quan
    quantity INT NOT NULL, -- Số lượng yêu cầu
    reason TEXT, -- Lý do yêu cầu
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending', -- Trạng thái xử lý
    response_note TEXT, -- Lý do chấp nhận/từ chối yêu cầu
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời gian yêu cầu
    responded_by INT DEFAULT NULL, -- Người xử lý yêu cầu
    responded_at DATETIME DEFAULT NULL, -- Thời gian phản hồi yêu cầu
    FOREIGN KEY (requester_id) REFERENCES users(user_id),
    FOREIGN KEY (responded_by) REFERENCES users(user_id),
    FOREIGN KEY (material_id) REFERENCES materials(material_id),
    FOREIGN KEY (request_type_id) REFERENCES request_types(request_type_id)
);

-- 🔹 Bảng approval_history - Lịch sử Phê Duyệt Yêu Cầu
CREATE TABLE approval_history (
    approval_id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL, -- Liên kết với yêu cầu
    approved_by INT NOT NULL, -- Người phê duyệt
    status ENUM('approved', 'rejected') NOT NULL, -- Trạng thái phê duyệt
    reason TEXT, -- Lý do phê duyệt/từ chối
    approved_at DATETIME DEFAULT CURRENT_TIMESTAMP, -- Thời gian phê duyệt
    FOREIGN KEY (request_id) REFERENCES requests(request_id),
    FOREIGN KEY (approved_by) REFERENCES users(user_id)
);
