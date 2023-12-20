# Wisdom-Repository-Mobile
[![Build status](https://build.appcenter.ms/v0.1/apps/23bb50db-467c-47b7-9235-032d6088cd0e/branches/main/badge)](https://appcenter.ms)

# Link Download
https://install.appcenter.ms/orgs/wisdom-repository/apps/wisdom-repository/distribution_groups/public

## Anggota Kelompok

1. Alwin Djuliansah - 2206813504
2. Anisha Putri Qonitah - 2206083256
3. Rafah Azizah - 2206083054
4. Robert Benyamin - 2206817383
5. Wahyu Ridho Anggoro - 2206811051

## Cerita Aplikasi

Data menunjukkan bahwa minat membaca masyarakat Indonesia masih rendah. Banyak faktor yang berkontribusi terhadap rendahnya minat membaca, diantaranya adalah kurangnya akses terhadap bahan bacaan yang menarik dan relevan. Oleh karena itu, dibuatlah aplikasi "Wisdom Repository" yang menjadi solusi dari permasalahan tersebut. Aplikasi ini tidak hanya mempermudah administrasi dalam peminjaman buku, tetapi juga memberikan platform bagi pengguna untuk saling berbagi ulasan dan rekomendasi buku. Dengan demikian, aplikasi ini diharapkan dapat mendorong minat membaca, meningkatkan akses ke bahan bacaan, serta menciptakan komunitas pembaca yang aktif di Indonesia.

## Daftar Modul

1. Login, Register, Logout, dan Bookmark Buku (Anisha Putri Qonitah)  
   Halaman ini digunakan untuk user mendaftarkan akun pada web dan memilih role sebagai Member Premium atau Member Reguler dan untuk user yang sudah terdaftar akan masuk dan dapat mengakses web. Halaman Bookmark berisi buku-buku yang sudah di-bookmark.
2. Daftar Buku (Wahyu Ridho Anggoro)  
   Halaman ini memperlihatkan semua daftar buku atau bisa disebut main page. Pada halaman ini, user dapat melakukan pencarian buku tertentu dengan memasukkan judul, penulis, atau genre buku yang dicari, mengurutkan buku berdasarkan tahun, judul, atau rating buku, serta memfilter buku berdasarkan genre yang disediakan. User dapat melihat detail buku dengan menekan card. Jika user belum login, maka user tidak bisa melihat deskripsi dan tombol pinjam, bookmarks, lihat review.
3. Peminjaman dan Pengembalian Buku (Alwin Djuliansah)  
   Halaman dimana member dapat meminjam buku yang diinginkan dan mengembalikan buku yang dipinjam. Setelah konfirmasi pengembalian, member akan ditawarkan untuk me-review buku yang dipinjam.
4. Review Buku (Rafah Azizah)  
   Halaman ini akan berisi buku yang sebelumnya telah dipinjam oleh member. Pada halaman ini, member bisa memberikan review terhadap buku yang sudah dipinjam.
5. Menambah, Mengedit, Menghapus Buku, dan Request Buku (Robert Benyamin)  
   Pada halaman ini, Admin dapat menambahkan atau menghapus buku dari daftar buku yang tersedia. Admin juga dapat mengedit informasi dari buku yang terdapat di daftar buku.

## Role Pengguna

1. Guest User
    - Dapat melihat daftar buku
2. Member Reguler
    - Dapat melihat daftar buku
    - Dapat meminjam buku dengan ketentuan:
        - Peminjaman maksimal 7 hari
        - Maksimal buku yang dapat dipinjam sebanyak 3 buku
    - Dapat mengembalikan buku yang dipinjam
    - Dapat memberikan review terhadap buku yang sudah dipinjam
    - Dapat request buku
3. Member Premium
    - Dapat melihat daftar buku
    - Dapat meminjam buku dengan ketentuan:
        - Peminjaman maksimal 14 hari
        - Maksimal buku yang dapat dipinjam sebanyak 7 buku
    - Dapat mengembalikan buku yang dipinjam
    - Dapat memberikan review terhadap buku yang sudah dipinjam
    - Dapat request buku
4. Admin
    - Dapat melihat daftar buku
    - Dapat menambahkan buku
    - Dapat mengedit informasi buku
    - Dapat menghapus buku
    - Dapat menyetujui request buku

## Alur pengintegrasian dengan *web service* untuk terhubung dengan aplikasi web yang sudah dibuat saat Proyek Tengah Semester

1. Menambahkan fungsi-fungsi pada proyek tengah semester untuk dapat berinteraksi dengan data JSON.
2. Menambahkan *dependency* `provider`, `pbp_django_auth`, dan `http` ke proyek. *Dependency* tersebut akan digunakan untuk melakukan `http response` dan `http request` ke proyek tengah semester.
3. Membuat model-model yang dibutuhkan untuk mengolah data JSON.
4. Membuat fungsi untuk *fetch* data dari web kemudian mengonversinya menjadi model yang telah dibuat sebelumnya.
5. Menampilkan data yang telah dikonversi ke aplikasi menggunakan widget `FutureBuilder`.

## Berita Acara

https://docs.google.com/spreadsheets/d/1vpeCIh12ZSSyEI3GTAyt5BcemeOI_Aaqu5N2J4SVORQ/edit?usp=sharing
