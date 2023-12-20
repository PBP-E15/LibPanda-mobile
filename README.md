# LibPanda - Mobile

## Anggota Kelompok

  1. Michael Marcellino Satyanegara		    - 2206083325
  2. Musthofa Joko Anggoro			          - 2206082354
  3. Nyasia Aludra Yasmina			          - 2206828185
  4. Darryl Abysha Artapradana Subiyanto 	 - 2206082846
  5. Kevin Yehezkiel Manurung 			    - 2206826974

## Tentang Aplikasi
  LibPanda adalah aplikasi pencarian dan pembelian buku yang memungkinkan pengguna untuk dengan cepat mencari, membandingkan, dan membeli buku favorit mereka. Aplikasi ini menawarkan akses ke katalog buku yang luas sehingga membuat proses mencari dan memilih buku menjadi lebih mudah dan efisien. Dengan fitur pencarian canggih, LibPanda adalah aplikasi yang sangat berguna bagi para pecinta buku.

## Manfaat Aplikasi
  Aplikasi untuk mencari dan membeli buku dapat memberikan berbagai manfaat kepada pengguna, termasuk:
  
  * Kemudahan Pencarian: Aplikasi ini memungkinkan pengguna untuk dengan mudah mencari buku berdasarkan nama buku, kategori dan harga tertentu. Ini menghemat waktu dan upaya dalam mencari buku yang diinginkan.
  * Beragam Pilihan: Aplikasi ini seringkali memiliki berbagai pilihan buku berdasarkan setiap kategori yang tersedia.
  * Akses Kapan Saja, Di Mana Saja: Dengan aplikasi ini, pengguna dapat mencari dan membeli buku kapan saja dan di mana saja, bahkan saat bepergian.

## Modul

  1. Login (**Kevin & Darryl**)

  2. Register (**Nyasia**)

  3. Logout (**Topa**)

  4. Landing Page (**Darryl**)
     * Navbar : Menu
     * Card : Menampilkan buku 
       
  5. Page untuk mencari buku (**Topa**)
     * Tombol sort (by categories, by harga)

  6. Informasi Detail Buku (**Darryl**)
     * Button wishlist
     * Button beli
     * Sinopsis
     * Detail buku (pengarang, tahun terbit, jumlah halaman)
       
  7. Form Request Buku (**Nyasia**)
     * Nama buku
     * Pengarang
     * Genre
     * Tahun terbit
       
  8. Profil akun (**Topa**)
     * Biodata
     * Wallet
       
  9. Wishlist (**Kevin**)
     * List buku
     * cancel wishlist

  10. Shopping cart (**Michael**)
      * List pembelian (nama buku + harga)
      * Pencet beli

## Role
       
  1. Member
     * Untuk melakukan segala interaksi pada aplikasi web yang tersedia
     * Dapat melakukan pencarian, pembelian, wishlist dan request buku
     * Dapat mengubah profil diri beserta walletnya


## Alur pengintegrasian dengan web service untuk terhubung dengan aplikasi web yang sudah dibuat saat Proyek Tengah Semester

- Untuk menyambungkan proyek flutter dengan proyek django tengah semester, pertama-tama kita buat app baru bernama `authentication`, setelah itu kita _update_ `settings.py` pada proyek utama dengan menambahkan `authentication` pada `INSTALLED_APPS`.
- Pada proyek django, jalankan perintah `pip install django-cors-headers` untuk menginstal library yang dibutuhkan. Lalu, Tambahkan `corsheaders` ke `INSTALLED_APPS` dan tambahkan `corsheaders.middleware.CorsMiddleware` pada main proyek `settings.py` aplikasi Django. Dan juga tambahkan beberapa variabel di bawah ke dalam `settings.py`
  ```python
  CORS_ALLOW_ALL_ORIGINS = True
  CORS_ALLOW_CREDENTIALS = True
  CSRF_COOKIE_SECURE = True
  SESSION_COOKIE_SECURE = True
  CSRF_COOKIE_SAMESITE = 'None'
  SESSION_COOKIE_SAMESITE = 'None'
  ```
- Selanjutnya membuat fungsi di `views.py` dan path url di `urls.py` aplikasi `authentication` untuk fitur `login`, `logout`, dan `register`.
- Setelah itu, _install_ lib berikut ini pada flutter
  ```
  flutter pub add provider
  flutter pub add pbp_django_auth
  ```
- Untuk mengkonversi models yang sudah ada pada proyek django tengah semester, buka _endpoint_ `JSON`, lalu _copy data_ `JSON` dan buka _website_ `Quicktype`. Pada website `Quicktype`, ubahlah _source_ type menjadi `JSON`, dan _language_ menjadi `Dart`. _Paste_ data `JSON` yang telah disalin sebelumnya ke dalam `textbox` yang tersedia pada `Quicktype`. Klik pilihan `Copy Code` pada `Quicktype` dan _paste_ pada berkas `.dart`.

## Berita Acara
https://docs.google.com/spreadsheets/d/1R02rxZ5iQ4Xf_kZ2pMGI5ohSjR8sL9KTf8LETBCZFrc/edit#gid=1750765818

## Sumber dataset katalog
https://www.kaggle.com/datasets/dylanjcastillo/7k-books-with-metadata

## Link AppCenter Deployment
https://install.appcenter.ms/orgs/admin-libpanda/apps/libpanda/distribution_groups/public