# Normalisasi Basis Data — Sistem Informasi Perpustakaan Ilmu Komputer UM Metro
**Nama:** Abim Faturohman  

**NIM:** 25430107  

**Kelas:** D   

**Tanggal** : 6 oktober 2026

**Dosen Pengampu** : Dedi Irawan, S.Kom., M.Kom. 

## F. Tugas Mandiri — Milestone Proyek 4

### F.1 Bentuk Tidak Ternormalisasi (UNF)
Dokumen sumber yang digunakan sebagai titik awal adalah **Formulir Peminjaman Buku** pada Perpustakaan Fakultas Ilmu Komputer UM Metro.

Berdasarkan elemen data pada dokumen, relasi awal dapat dituliskan sebagai berikut:
`PEMINJAMAN_UNF (no_peminjaman, tgl_peminjaman, batas_pengembalian, nim_mahasiswa, nama_mahasiswa, program_studi, id_pustakawan, nama_pustakawan, {kode_buku, isbn, judul_buku, pengarang, penerbit, tahun_terbit})`

Keterangan:
- Data peminjaman memuat identitas mahasiswa, pustakawan, dan tenggat waktu.
- Satu transaksi dapat memuat beberapa buku. Kelompok `{kode_buku, isbn, judul_buku...}` merupakan kelompok data berulang (*repeating group*).

### F.2 Dependensi Fungsional
Dependensi fungsional (DF) berikut disusun berdasarkan identitas data pada entitas sistem perpustakaan kampus.

| No. | Dependensi Fungsional | Dasar Aturan Bisnis (AB) |
|---|---|---|
| DF-01 | `nim_mahasiswa → nama_mahasiswa, program_studi` | AB-01; Data mahasiswa aktif UM Metro. |
| DF-02 | `kode_buku → isbn, judul_buku, pengarang, penerbit, tahun_terbit` | AB-02; Data master katalog perpustakaan. |
| DF-03 | `id_pustakawan → nama_pustakawan` | AB-03; Identitas pengelola perpustakaan. |
| DF-04 | `no_peminjaman → tgl_peminjaman, batas_pengembalian, nim_mahasiswa, id_pustakawan` | AB-04; Data *header* transaksi sirkulasi. |
| DF-05 | `(no_peminjaman, kode_buku) → status_pengembalian` | AB-05; Pemetaan item spesifik pada transaksi. |

### F.3 Bentuk Normal Pertama (1NF)
Menghilangkan kelompok atribut berulang agar setiap baris memiliki nilai tunggal (atomik).

1. `PEMINJAMAN (no_peminjaman, tgl_peminjaman, batas_pengembalian, nim_mahasiswa, nama_mahasiswa, program_studi, id_pustakawan, nama_pustakawan)`
2. `DETAIL_PEMINJAMAN (no_peminjaman, kode_buku, isbn, judul_buku, pengarang, penerbit, tahun_terbit)`

### F.4 Bentuk Normal Kedua (2NF)
Menghilangkan ketergantungan parsial pada kunci gabungan. Pada `DETAIL_PEMINJAMAN`, atribut rincian buku hanya bergantung pada `kode_buku`, sehingga dipisah.

1. `PEMINJAMAN (no_peminjaman, tgl_peminjaman, batas_pengembalian, nim_mahasiswa, nama_mahasiswa, program_studi, id_pustakawan, nama_pustakawan)`
2. `DETAIL_PEMINJAMAN (no_peminjaman, kode_buku)`
3. `BUKU (kode_buku, isbn, judul_buku, pengarang, penerbit, tahun_terbit)`

### F.5 Bentuk Normal Ketiga (3NF)
Menghilangkan ketergantungan transitif. Atribut identitas mahasiswa dan pustakawan tidak perlu berulang kali disimpan di tabel Peminjaman.

| Tabel | Atribut | Keterangan Kunci |
|---|---|---|
| `MAHASISWA` | `nim_mahasiswa, nama_mahasiswa, program_studi` | PK: `nim_mahasiswa` |
| `PUSTAKAWAN`| `id_pustakawan, nama_pustakawan` | PK: `id_pustakawan` |
| `BUKU` | `kode_buku, isbn, judul_buku, pengarang, penerbit, tahun_terbit`| PK: `kode_buku` |
| `PEMINJAMAN`| `no_peminjaman, tgl_peminjaman, batas_pengembalian, nim_mahasiswa, id_pustakawan` | PK: `no_peminjaman`, FK: `nim_mahasiswa`, `id_pustakawan` |
| `DETAIL_PEMINJAMAN`| `no_peminjaman, kode_buku` | PK (Gabungan) & FK ke Peminjaman dan Buku |

### F.6 Pemeriksaan Boyce–Codd Normal Form (BCNF)
BCNF mengharuskan setiap penentu (determinan) pada dependensi fungsional adalah kunci kandidat (*Candidate Key*).

| Tabel | Hasil Pemeriksaan |
|---|---|
| `MAHASISWA` | Memenuhi BCNF; `nim_mahasiswa` adalah kunci kandidat tunggal penentu nama & prodi. |
| `PUSTAKAWAN` | Memenuhi BCNF; `id_pustakawan` adalah kunci kandidat tunggal. |
| `BUKU` | Memenuhi BCNF; `kode_buku` adalah penentu utama yang unik. |
| `PEMINJAMAN` | Memenuhi BCNF; `no_peminjaman` adalah kunci kandidat tunggal untuk data transaksi. |
| `DETAIL_PEMINJAMAN`| Memenuhi BCNF; Pasangan `(no_peminjaman, kode_buku)` adalah kunci kandidat penentu. |

### F.7 Keputusan Penyimpanan Nilai Turunan

| Nilai Turunan | Keputusan | Alasan Analisis |
|---|---|---|
| `hari_terlambat` | DIHITUNG | Mengurangi redundansi; dihitung secara dinamis dari `tgl_kembali_aktual` dan `batas_pengembalian`. |
| `total_denda` | DIHITUNG | Mengalikan `hari_terlambat` dengan tarif denda kampus. Menghindari anomali ubah jika kebijakan tarif dekanat direvisi di masa depan. |
| `jumlah_buku_dipinjam` | DIHITUNG | Menggunakan agregasi (COUNT) dari `DETAIL_PEMINJAMAN` saat pencetakan laporan untuk validasi limit. |

### F.8 Penyesuaian ERD
Normalisasi menghasilkan struktur konseptual yang terdiri dari 5 entitas utama: Mahasiswa, Pustakawan, Buku, Peminjaman, dan Detail Peminjaman. **ERD awal tidak mengalami perombakan arsitektur**, hanya penyesuaian penamaan atribut (*naming convention*) agar selaras ketika dieksekusi ke dalam sintaks DDL (*Data Definition Language*).