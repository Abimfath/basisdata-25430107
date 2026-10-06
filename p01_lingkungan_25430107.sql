
-- Skrip Inisialisasi Lingkungan Kerja Modul 1
-- Praktikan : Abim Faturohman
-- NIM       : 25430107
-- Topik     : Pengaturan Database & Akun Kerja


-- 1. Membuat Database Praktikum (Kopma)
CREATE DATABASE IF NOT EXISTS kopma_107
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

-- 2. Membuat Database Proyek Mandiri (Perpustakaan)
CREATE DATABASE IF NOT EXISTS perpus_107
  CHARACTER SET utf8mb4 
  COLLATE utf8mb4_unicode_ci;

-- 3. Membuat Akun Developer untuk Proyek Mandiri
CREATE USER IF NOT EXISTS 'dev_107'@'localhost' 
  IDENTIFIED BY '<Perpus_107>';

  -- 4. Membuat Akun Tamu
CREATE USER IF NOT EXISTS 'tamu_107'@'localhost' 
  IDENTIFIED BY '<Abim130206>';

-- 5. Pengaturan Hak Akses (Privileges)
-- Akun Kerja Utama untuk Praktikum Kopma
GRANT ALL PRIVILEGES ON kopma_107.* TO 'AbimFaturohman_107'@'localhost';

-- Akun Developer khusus Database Proyek
GRANT ALL PRIVILEGES ON perpus_107.* TO 'dev_107'@'localhost';

-- 6. Menerapkan Perubahan Akses
FLUSH PRIVILEGES;