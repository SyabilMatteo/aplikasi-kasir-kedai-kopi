# Database Aplikasi Kasir Berbasis Web
## Kedai Kopi Mbah Buyut

Repository ini berisi database MySQL untuk **Aplikasi Kasir dan Pemesanan Digital Berbasis Web** pada Kedai Kopi Mbah Buyut.

Sistem dirancang untuk mendukung tiga jenis pengguna:

- **Admin**
- **Kasir**
- **Pelanggan**

Database dibuat dalam versi sederhana agar mudah dipahami, digunakan, dan dipresentasikan, tetapi tetap mencakup kebutuhan utama dari Use Case Diagram dan Data Flow Diagram.

---

## Fitur Utama

Database mendukung fitur:

- Login pengguna
- Hak akses Admin, Kasir, dan Pelanggan
- Pengelolaan kategori menu
- Pengelolaan menu
- Pengelolaan varian menu
- Pengelolaan harga
- Pemesanan melalui QR Code
- Pemesanan manual oleh kasir
- Dine In dan Takeaway
- Checkout pesanan
- Catatan pesanan
- Status pesanan
- Konfirmasi dan penolakan pesanan
- Pembayaran tunai dan non-tunai
- Sistem coin pelanggan
- Jam operasional
- Riwayat transaksi
- Laporan penjualan

---

## Struktur File

```text
kedai-kopi-kasir-db/
├── database.sql
└── README.md
```

---

## Database

Nama database:

```sql
db_kedai_kopi
```

DBMS yang digunakan:

```text
MySQL 8.x
```

---

## Struktur Tabel

Database terdiri dari 8 tabel utama.

### 1. `users`

Menyimpan data seluruh pengguna sistem.

Digunakan untuk:

- Admin
- Kasir
- Pelanggan
- Login
- Profil pengguna
- Role pengguna
- Saldo coin

Kolom utama:

```text
id
nama
username
email
password
role
coin
created_at
```

Role yang tersedia:

```text
ADMIN
KASIR
PELANGGAN
```

---

### 2. `categories`

Menyimpan kategori menu.

Contoh:

```text
Kopi
Non Kopi
Makanan
```

---

### 3. `menus`

Menyimpan data menu yang dijual.

Data yang disimpan antara lain:

```text
nama menu
kategori
harga
deskripsi
status menu
```

Status menu:

```text
TERSEDIA
HABIS
```

---

### 4. `variants`

Menyimpan varian dari setiap menu.

Contoh:

```text
Regular
Large
Hot
Ice
```

Varian dapat memiliki tambahan harga.

Contoh:

```text
Kopi Susu       Rp15.000
Large            +Rp5.000
-------------------------
Total             Rp20.000
```

---

### 5. `tables`

Menyimpan data meja dan token QR Code.

Contoh:

```text
MEJA-01
MEJA-02
MEJA-03
```

Token QR digunakan agar pelanggan dapat membuka menu sesuai meja yang digunakan.

---

### 6. `operational_hours`

Menyimpan jam operasional kedai.

Contoh:

```text
Senin   08:00 - 22:00
Sabtu   08:00 - 23:00
```

Status operasional:

```text
BUKA
TUTUP
```

---

### 7. `orders`

Merupakan tabel utama untuk menyimpan pesanan dan transaksi.

Tabel ini digunakan untuk menyimpan:

- Pelanggan
- Kasir
- Meja
- Jenis pesanan
- Sumber pesanan
- Status pesanan
- Metode pembayaran
- Status pembayaran
- Subtotal
- Potongan coin
- Total pembayaran
- Catatan pesanan
- Alasan penolakan
- Tanggal transaksi

Jenis pesanan:

```text
DINE_IN
TAKEAWAY
```

Sumber pesanan:

```text
QR
KASIR
```

Status pesanan:

```text
PENDING
DIKONFIRMASI
DIPROSES
SELESAI
DITOLAK
```

Metode pembayaran:

```text
CASH
QRIS
TRANSFER
E_WALLET
```

Status pembayaran:

```text
BELUM_BAYAR
LUNAS
```

---

### 8. `order_details`

Menyimpan detail menu yang terdapat dalam sebuah pesanan.

Data yang disimpan:

```text
order_id
menu_id
variant_id
jumlah
harga
subtotal
catatan
```

Contoh:

```text
Pesanan ORD-001

2 x Kopi Susu Large
1 x Kentang Goreng
```

---

## Relasi Database

Relasi utama database:

```text
users
 ├── orders sebagai pelanggan
 └── orders sebagai kasir

categories
 └── menus
      └── variants

tables
 └── orders

orders
 └── order_details

menus
 └── order_details

variants
 └── order_details
```

---

## Kesesuaian dengan Use Case

### Admin

Admin dapat melakukan:

- Login
- Melihat statistik transaksi
- Mengelola kategori menu
- Mengelola menu
- Mengelola varian
- Mengelola harga
- Mengelola pengguna
- Mengelola coin pelanggan
- Mengelola jam operasional
- Melihat laporan transaksi
- Mengubah profil
- Logout

---

### Kasir

Kasir dapat melakukan:

- Login
- Memproses transaksi
- Memilih menu
- Memilih varian
- Menentukan jumlah
- Menghitung total
- Input pesanan manual
- Melihat detail pesanan
- Mengonfirmasi pesanan
- Menolak pesanan
- Melihat riwayat transaksi
- Mengubah profil
- Logout

---

### Pelanggan

Pelanggan dapat melakukan:

- Scan QR Code
- Login
- Melihat daftar menu
- Melihat saldo coin
- Memilih menu
- Memilih varian
- Menentukan jumlah
- Menambahkan menu ke pesanan
- Memilih Dine In atau Takeaway
- Menambahkan catatan pesanan
- Menggunakan coin sebagai potongan
- Memilih metode pembayaran
- Melakukan checkout
- Melihat status pesanan
- Melihat transaksi
- Mengubah profil
- Logout

---

## Cara Import Database

### Menggunakan MySQL CMD

Masuk ke MySQL:

```bash
mysql -u root -p
```

Setelah berhasil login, jalankan:

```sql
SOURCE C:/lokasi-folder/database.sql;
```

Contoh:

```sql
SOURCE C:/xampp/htdocs/kedai-kopi-kasir-db/database.sql;
```

---

### Menggunakan phpMyAdmin

1. Buka phpMyAdmin.
2. Pilih menu **Import**.
3. Pilih file `database.sql`.
4. Klik **Import** atau **Go**.
5. Database akan dibuat otomatis.

---

## Mengecek Database

Gunakan:

```sql
USE db_kedai_kopi;
```

Kemudian:

```sql
SHOW TABLES;
```

Untuk melihat struktur tabel:

```sql
DESCRIBE users;
DESCRIBE menus;
DESCRIBE orders;
DESCRIBE order_details;
```

---

## Contoh Query Laporan

### Melihat transaksi selesai

```sql
SELECT *
FROM orders
WHERE status_pesanan = 'SELESAI';
```

### Laporan penjualan per hari

```sql
SELECT
    DATE(tanggal) AS tanggal,
    COUNT(*) AS jumlah_transaksi,
    SUM(total) AS total_penjualan
FROM orders
WHERE status_pesanan = 'SELESAI'
GROUP BY DATE(tanggal)
ORDER BY tanggal DESC;
```

### Riwayat transaksi pelanggan

```sql
SELECT *
FROM orders
WHERE customer_id = 1
ORDER BY tanggal DESC;
```

---

## Sistem Coin

Saldo coin pelanggan disimpan pada:

```text
users.coin
```

Saat pelanggan mendapatkan coin, nilai coin dapat ditambahkan.

Contoh:

```sql
UPDATE users
SET coin = coin + 5
WHERE id = 3;
```

Saat coin digunakan:

```sql
UPDATE users
SET coin = coin - 2
WHERE id = 3;
```

Potongan dari penggunaan coin disimpan pada:

```text
orders.potongan_coin
```

---

## Catatan Password

Password tidak disarankan disimpan dalam bentuk teks asli.

Password sebaiknya di-hash oleh aplikasi menggunakan:

```text
bcrypt
Argon2
```

Contoh PHP:

```php
$passwordHash = password_hash($password, PASSWORD_BCRYPT);
```

Kemudian hasil hash disimpan ke kolom:

```text
users.password
```

---

## Kenapa Database Dibuat Ringkas?

Database dibuat lebih sederhana agar:

- Mudah dipahami
- Mudah dijelaskan saat presentasi
- Tidak memiliki terlalu banyak tabel
- Tetap sesuai kebutuhan sistem
- Mudah dikembangkan menjadi aplikasi web

Beberapa fitur yang sebenarnya dapat dibuat dalam tabel terpisah sengaja digabungkan.

Contohnya:

```text
Role pengguna
```

langsung disimpan pada:

```text
users.role
```

Pembayaran langsung disimpan pada:

```text
orders
```

Saldo coin langsung disimpan pada:

```text
users.coin
```

Hal ini membuat struktur database lebih sederhana tanpa menghilangkan fungsi utama sistem.

---

## Upload ke GitHub

Setelah file selesai, repository dapat berisi:

```text
database.sql
README.md
```

Contoh commit:

```bash
git add .
git commit -m "Add database kasir Kedai Kopi Mbah Buyut"
```

Kemudian push ke GitHub:

```bash
git push
```

---

## Kesimpulan

Database ini dirancang untuk mendukung Sistem Aplikasi Kasir dan Pemesanan Digital Berbasis Web pada Kedai Kopi Mbah Buyut.

Database mendukung tiga aktor utama yaitu **Admin, Kasir, dan Pelanggan**, serta fitur utama seperti **QR Code, menu, varian, transaksi, pembayaran, coin pelanggan, laporan penjualan, dan jam operasional**.
