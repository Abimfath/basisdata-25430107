-- File: p05_ddl_107.sql
-- Skrip DDL Proyek Perpustakaan Ilmu Komputer UM Metro (perpus_107)

CREATE DATABASE IF NOT EXISTS perpus_107 
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE perpus_107;

-- Menghapus tabel dengan urutan terbalik (Anak -> Induk)
DROP TABLE IF EXISTS detail_peminjaman;
DROP TABLE IF EXISTS peminjaman;
DROP TABLE IF EXISTS buku;
DROP TABLE IF EXISTS pustakawan;
DROP TABLE IF EXISTS mahasiswa;

-- 1. Tabel MAHASISWA (Merujuk AB-01: Identitas mahasiswa aktif)
CREATE TABLE mahasiswa (
    id_mahasiswa INT NOT NULL AUTO_INCREMENT,
    nim_mahasiswa CHAR(10) NOT NULL,
    nama_mahasiswa VARCHAR(100) NOT NULL,
    prodi_mahasiswa VARCHAR(60) NOT NULL,
    status_mahasiswa ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
    PRIMARY KEY (id_mahasiswa),
    CONSTRAINT uq_mahasiswa_nim UNIQUE (nim_mahasiswa) -- AB-01: NIM unik
) ENGINE=InnoDB;

-- 2. Tabel PUSTAKAWAN (Merujuk AB-03: Identitas pengelola)
CREATE TABLE pustakawan (
    id_pustakawan INT NOT NULL AUTO_INCREMENT,
    kode_pustakawan CHAR(5) NOT NULL,
    nama_pustakawan VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_pustakawan),
    CONSTRAINT uq_pustakawan_kode UNIQUE (kode_pustakawan)
) ENGINE=InnoDB;

-- 3. Tabel BUKU (Merujuk AB-02: Katalog master)
CREATE TABLE buku (
    id_buku INT NOT NULL AUTO_INCREMENT,
    kode_buku VARCHAR(10) NOT NULL,
    isbn_buku VARCHAR(20) NOT NULL,
    judul_buku VARCHAR(150) NOT NULL,
    pengarang_buku VARCHAR(100) NOT NULL,
    penerbit_buku VARCHAR(100) NOT NULL,
    tahun_terbit_buku SMALLINT NOT NULL,
    stok_buku INT NOT NULL DEFAULT 1,
    PRIMARY KEY (id_buku),
    CONSTRAINT uq_buku_kode UNIQUE (kode_buku), -- AB-02: Kode unik
    CONSTRAINT ck_buku_stok CHECK (stok_buku >= 0) -- AB-03: Stok tidak boleh negatif
) ENGINE=InnoDB;

-- 4. Tabel PEMINJAMAN (Merujuk AB-04: Transaksi Sirkulasi)
CREATE TABLE peminjaman (
    id_peminjaman INT NOT NULL AUTO_INCREMENT,
    no_peminjaman CHAR(12) NOT NULL,
    tgl_peminjaman DATE NOT NULL,
    batas_pengembalian DATE NOT NULL,
    id_mahasiswa INT NOT NULL,
    id_pustakawan INT NOT NULL,
    PRIMARY KEY (id_peminjaman),
    CONSTRAINT uq_peminjaman_no UNIQUE (no_peminjaman), -- AB-04: Resi transaksi unik
    CONSTRAINT fk_peminjaman_mahasiswa FOREIGN KEY (id_mahasiswa) REFERENCES mahasiswa (id_mahasiswa),
    CONSTRAINT fk_peminjaman_pustakawan FOREIGN KEY (id_pustakawan) REFERENCES pustakawan (id_pustakawan),
    CONSTRAINT ck_peminjaman_tgl CHECK (batas_pengembalian >= tgl_peminjaman)
) ENGINE=InnoDB;

-- 5. Tabel DETAIL_PEMINJAMAN (Merujuk AB-05: Rincian buku dipinjam)
CREATE TABLE detail_peminjaman (
    id_peminjaman INT NOT NULL,
    id_buku INT NOT NULL,
    status_pengembalian ENUM('dipinjam','kembali') NOT NULL DEFAULT 'dipinjam',
    PRIMARY KEY (id_peminjaman, id_buku),
    CONSTRAINT fk_detail_peminjaman FOREIGN KEY (id_peminjaman) REFERENCES peminjaman (id_peminjaman) ON DELETE CASCADE,
    CONSTRAINT fk_detail_buku FOREIGN KEY (id_buku) REFERENCES buku (id_buku)
) ENGINE=InnoDB;