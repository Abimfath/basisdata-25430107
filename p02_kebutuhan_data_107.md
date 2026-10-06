# Dokumen Kebutuhan Data Perpustakaan EDU MU

## 1. Latar Belakang dan Aktivitas Organisasi
Perpustakaan EDU MU
 melayani pendaftaran anggota (mahasiswa), peminjaman buku, pengembalian buku, dan pengenaan denda keterlambatan.

## 2. Aktor dan Proses Bisnis
| Kode | Proses Bisnis | Aktor | Pemicu |
| :--- | :--- | :--- | :--- |
| PB-01 | Mendaftarkan Anggota | Petugas | Mahasiswa ingin meminjam buku |
| PB-02 | Mencatat Peminjaman | Petugas | Anggota meminjam buku |
| PB-03 | Mencatat Pengembalian & Denda | Petugas | Anggota mengembalikan buku |
| PB-04 | Mengelola Katalog Buku | Petugas | Penambahan koleksi buku baru |

## 3. Dokumen Sumber
Nota/Slip Peminjaman Buku dan Kuitansi Pembayaran Denda.

## 4. Entitas Kandidat dan Elemen Data
1. **Anggota:** id_anggota, nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota.
2. **Buku:** id_buku, kode_buku, judul_buku, pengarang_buku, stok_buku.
3. **Petugas:** id_petugas, kode_petugas, nama_petugas.
4. **Peminjaman:** id_peminjaman, no_pinjam, tgl_pinjam, tgl_tenggat.
5. **Detail Peminjaman:** id_peminjaman, id_buku, qty_pinjam, denda_per_hari.
6. **Pengembalian:** id_pengembalian, tgl_kembali, denda_dibayar.

## 5. Aturan Bisnis
* **AB-01:** Setiap transaksi peminjaman memiliki nomor slip unik dan maksimal meminjam 10 buku (P+2).
* **AB-02:** Denda keterlambatan pengembalian buku dihitung Rp8.000 (P) per hari terlambat.
* **AB-03:** Stok buku tidak boleh negatif.
* **AB-04:** NIM anggota bersifat unik (10 digit).

## 6. Kebutuhan Informasi (KI)
* **KI-01:** Laporan jumlah peminjaman per hari dan per bulan.
* **KI-02:** Lima buku paling sering dipinjam per bulan.
* **KI-03:** Daftar anggota dengan denda tertunggak terbesar.
* **KI-04:** Buku dengan stok tersedia di bawah batas minimum.
* **KI-05:** Rekapitulasi peminjaman berdasarkan program studi mahasiswa.

## 7. Matriks CRUD
| Proses | Anggota | Buku | Peminjaman | Detail | Pengembalian |
| :--- | :---: | :---: | :---: | :---: | :---: |
| PB-01 Daftar Anggota | C | R | - | - | - |
| PB-02 Catat Peminjaman | R | U | C | C | - |
| PB-03 Pengembalian & Denda | R | U | R | R | C |
| PB-04 Kelola Buku | - | C/U/D | - | - | - |

## 8. Kamus Data Awal
| Elemen | Arti | Contoh | Aturan | Penanggung Jawab |
| :--- | :--- | :--- | :--- | :--- |
| nim_anggota | NIM Mahasiswa | 2301010107 | Unik, 10 digit | Petugas |
| no_hp_anggota | No. HP | 08123456789 | Data Pribadi (PDP) | Petugas |
| denda_harian | Tarif Denda | 8000 | Rp8.000/hari | Kepala Perpustakaan |

## 9. Kebutuhan Non-Fungsional & Parameter Personal (P)
* **Perhitungan Parameter P:** NIM akhiran 07 -> P = ((7 mod 9) + 1) = 8.
* **Batas Maksimal Buku per Pinjam:** 10 buku ($P + 2$).
* **Tarif Denda Harian:** Rp8.000 ($P$ ribu).
* **Estimasi Volume Transaksi Harian:** 80 transaksi ($40 + 5 \times 8$).
* **Aturan Privasi:** `no_hp_anggota` bersifat rahasia (UU PDP) dan hanya dapat diakses oleh Kepala Perpustakaan.