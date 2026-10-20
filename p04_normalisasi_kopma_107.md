# Langkah Percobaan: Normalisasi Kasus Kopma

## A. Bentuk Tidak Ternormalisasi (UNF)
Dokumen sumber yang digunakan adalah **Nota Penjualan Kopma**. Pada nota ini, satu nomor nota dapat memuat banyak barang (grup berulang), sehingga belum memenuhi syarat normalisasi.
`PENJUALAN_UNF (no_nota, tgl_nota, id_anggota, nama_anggota, {kode_barang, nama_barang, harga_satuan, qty, subtotal}, total)`

## B. Dependensi Fungsional (FD)
Berikut adalah pemetaan dependensi fungsional (DF) berdasarkan aturan bisnis Kopma:

| Kode | Dependensi Fungsional | Keterangan Aturan Bisnis |
|---|---|---|
| DF-01 | `no_nota → tgl_nota, id_anggota` | Satu transaksi nota mengikat waktu dan identitas pembeli. |
| DF-02 | `id_anggota → nama_anggota` | Identitas anggota bersifat unik berdasarkan ID-nya. |
| DF-03 | `kode_barang → nama_barang, harga_satuan_aktif` | Identitas katalog master barang Kopma. |
| DF-04 | `(no_nota, kode_barang) → qty, harga_satuan_jual` | Kuantitas dan harga riil saat transaksi bergantung pada barang spesifik di nota spesifik. |
| DF-05 | `(qty, harga_satuan_jual) → subtotal` | Subtotal adalah nilai turunan (perkalian). |

## C. Bentuk Normal Pertama (1NF)
Menghilangkan grup berulang sehingga setiap atribut bernilai atomik. Kunci komposit `(no_nota, kode_barang)` mulai terbentuk secara implisit.
`PENJUALAN_1NF (no_nota, kode_barang, tgl_nota, id_anggota, nama_anggota, nama_barang, harga_satuan, qty, subtotal, total)`

## D. Bentuk Normal Kedua (2NF)
Menghilangkan ketergantungan parsial. Atribut yang hanya bergantung pada sebagian kunci komposit (`kode_barang` atau `no_nota` saja) dipisah. Nilai turunan (`subtotal`, `total`) mulai dieliminasi dari tabel operasional.

1. `PENJUALAN (no_nota, tgl_nota, id_anggota, nama_anggota)`
2. `BARANG (kode_barang, nama_barang, harga_satuan)`
3. `DETAIL_PENJUALAN (no_nota, kode_barang, qty, harga_satuan_jual)`

## E. Bentuk Normal Ketiga (3NF)
Menghilangkan ketergantungan transitif. Atribut `nama_anggota` bergantung pada `id_anggota`, bukan langsung pada `no_nota`, sehingga dipisah menjadi tabel baru.

| Tabel | Atribut | Keterangan Kunci |
|---|---|---|
| `ANGGOTA` | `id_anggota, nama_anggota` | PK: `id_anggota` |
| `BARANG` | `kode_barang, nama_barang, harga_satuan_aktif` | PK: `kode_barang` |
| `PENJUALAN` | `no_nota, tgl_nota, id_anggota` | PK: `no_nota`, FK: `id_anggota` |
| `DETAIL_PENJUALAN`| `no_nota, kode_barang, qty, harga_satuan_jual` | PK (Gabungan) & FK ke Penjualan dan Barang |

---

## F. Jawaban Titik Analisis & Latihan

### 1. Titik Analisis 1: Harga Satuan di Detail
Atribut `harga_satuan` wajib diletakkan di `DETAIL_PENJUALAN` untuk merekam data historis. Jika hanya mengandalkan tabel `BARANG`, perubahan harga di masa depan akan mengubah total omzet nota lama secara tidak sengaja (anomali).

### 2. Titik Analisis 2: Nilai Turunan (Subtotal/Total)
Penyimpanan nilai turunan pada tabel operasional akan memicu anomali ubah jika kuantitas barang direvisi oleh kasir. Keduanya cukup dihitung menggunakan kueri SQL.

### 3. Titik Analisis 3: Asal Pemasok
Menyimpan informasi pemasok ke dalam tabel master `BARANG` akan memicu redundansi jika satu barang disuplai oleh vendor berbeda. Kopma menyimpannya pada relasi terpisah melalui tabel Pembelian.

### 4. Latihan (Modifikasi Multivalued Attribute)
Jika pemasok memiliki banyak nomor telepon, atribut tersebut tidak boleh digabung (melanggar 1NF). Solusinya dipecah menjadi tabel: `PEMASOK_TELEPON (id_pemasok, nomor_telepon)`.

### 5. Latihan (Bukti Pelanggaran 3NF)
Jika `nama_anggota` tetap di tabel `PENJUALAN`, akan timbul anomali ubah. Saat anggota mengubah ejaan namanya, sistem harus mengeksekusi `UPDATE` pada ratusan baris nota lamanya. Jika ada yang terlewat, data menjadi inkonsisten.