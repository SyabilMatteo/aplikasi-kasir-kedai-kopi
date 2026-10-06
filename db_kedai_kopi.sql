-- =====================================================
-- DATABASE APLIKASI KASIR BERBASIS WEB
-- Kedai Kopi Mbah Buyut
-- Versi ringkas untuk tugas
-- =====================================================

CREATE DATABASE IF NOT EXISTS db_kedai_kopi
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE db_kedai_kopi;

-- 1. Data pengguna: Admin, Kasir, Pelanggan
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100),
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN','KASIR','PELANGGAN') NOT NULL,
    coin INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Kategori menu
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nama_kategori VARCHAR(100) NOT NULL
);

-- 3. Menu
CREATE TABLE menus (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    nama_menu VARCHAR(100) NOT NULL,
    harga DECIMAL(10,2) NOT NULL,
    deskripsi TEXT,
    status ENUM('TERSEDIA','HABIS') DEFAULT 'TERSEDIA',
    FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 4. Varian menu
CREATE TABLE variants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    menu_id INT NOT NULL,
    nama_varian VARCHAR(100) NOT NULL,
    tambahan_harga DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (menu_id) REFERENCES menus(id)
        ON DELETE CASCADE
);

-- 5. Meja dan QR Code
CREATE TABLE tables (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nomor_meja VARCHAR(20) NOT NULL UNIQUE,
    qr_token VARCHAR(100) NOT NULL UNIQUE
);

-- 6. Jam operasional
CREATE TABLE operational_hours (
    id INT AUTO_INCREMENT PRIMARY KEY,
    hari VARCHAR(20) NOT NULL,
    jam_buka TIME,
    jam_tutup TIME,
    status ENUM('BUKA','TUTUP') DEFAULT 'BUKA'
);

-- 7. Pesanan / transaksi
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    kode_pesanan VARCHAR(30) NOT NULL UNIQUE,
    customer_id INT,
    cashier_id INT,
    table_id INT,

    jenis_pesanan ENUM('DINE_IN','TAKEAWAY') DEFAULT 'DINE_IN',
    sumber_pesanan ENUM('QR','KASIR') DEFAULT 'QR',

    status_pesanan ENUM(
        'PENDING',
        'DIKONFIRMASI',
        'DIPROSES',
        'SELESAI',
        'DITOLAK'
    ) DEFAULT 'PENDING',

    metode_pembayaran ENUM(
        'CASH',
        'QRIS',
        'TRANSFER',
        'E_WALLET'
    ),

    status_pembayaran ENUM(
        'BELUM_BAYAR',
        'LUNAS'
    ) DEFAULT 'BELUM_BAYAR',

    subtotal DECIMAL(10,2) DEFAULT 0,
    potongan_coin DECIMAL(10,2) DEFAULT 0,
    total DECIMAL(10,2) DEFAULT 0,

    catatan VARCHAR(255),
    alasan_penolakan VARCHAR(255),
    tanggal DATETIME DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (customer_id) REFERENCES users(id),
    FOREIGN KEY (cashier_id) REFERENCES users(id),
    FOREIGN KEY (table_id) REFERENCES tables(id)
);

-- 8. Detail pesanan
CREATE TABLE order_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    menu_id INT NOT NULL,
    variant_id INT,
    jumlah INT NOT NULL,
    harga DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    catatan VARCHAR(255),

    FOREIGN KEY (order_id) REFERENCES orders(id)
        ON DELETE CASCADE,
    FOREIGN KEY (menu_id) REFERENCES menus(id),
    FOREIGN KEY (variant_id) REFERENCES variants(id)
);

-- =====================================================
-- DATA AWAL
-- =====================================================

INSERT INTO categories (nama_kategori) VALUES
('Kopi'),
('Non Kopi'),
('Makanan');

INSERT INTO tables (nomor_meja, qr_token) VALUES
('MEJA-01', 'QR-MEJA-01'),
('MEJA-02', 'QR-MEJA-02'),
('MEJA-03', 'QR-MEJA-03');

INSERT INTO operational_hours
(hari, jam_buka, jam_tutup, status)
VALUES
('Senin', '08:00:00', '22:00:00', 'BUKA'),
('Selasa', '08:00:00', '22:00:00', 'BUKA'),
('Rabu', '08:00:00', '22:00:00', 'BUKA'),
('Kamis', '08:00:00', '22:00:00', 'BUKA'),
('Jumat', '08:00:00', '22:00:00', 'BUKA'),
('Sabtu', '08:00:00', '23:00:00', 'BUKA'),
('Minggu', '08:00:00', '23:00:00', 'BUKA');

-- =====================================================
-- CONTOH LAPORAN TRANSAKSI
-- =====================================================

-- Semua transaksi selesai
SELECT *
FROM orders
WHERE status_pesanan = 'SELESAI';

-- Laporan berdasarkan tanggal
SELECT
    DATE(tanggal) AS tanggal,
    COUNT(*) AS jumlah_transaksi,
    SUM(total) AS total_penjualan
FROM orders
WHERE status_pesanan = 'SELESAI'
GROUP BY DATE(tanggal)
ORDER BY tanggal DESC;

-- Riwayat transaksi pelanggan
SELECT *
FROM orders
WHERE customer_id = 1
ORDER BY tanggal DESC;
