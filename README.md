# MiniProject1 - Analyzing eCommerce Business Performance with SQL
Rakamin Academy
Created by: Rheza Paleva Uyanto
uyantorheza@gmail.com
https://www.linkedin.com/in/rheza-uyanto/

## Latar Belakang dan Objektif
“Dalam suatu perusahaan mengukur performa bisnis sangatlah penting untuk melacak, memantau, dan menilai keberhasilan atau kegagalan dari berbagai proses bisnis. Oleh karena itu, dalam paper ini akan menganalisa performa bisnis untuk sebuah perusahan eCommerce,  dengan memperhitungkan beberapa metrik bisnis yaitu pertumbuhan pelanggan, kualitas produk, dan tipe pembayaran.”

## Pertanyaan Riset
" Bagaimana pertumbuhan performa perusahaan dilihat dari pelanggan, produk dan tipe pembayaran ?"

## Tujuan:
- Dapat mengidentifikasi metrik bisnis sebuah perusahaaan eCommerce dari sisi pelanggan, produk dan tipe pembayaran.

## Tools:
- PostgreSQL

## Data Awal:
- Data awal berupa 8 tabel yang tidak saling berhubungan. Tabel - tabel tersebut antara lain: sellers_dataset, product_dataset, order_payments_dataset, order_reviews_dataset, geolocation_dataset, order_items_dataset, orders_dataset, dan customer_dataset.
- Menentukan Primary Key dan Foreign Key untuk membuat ERD.
- Karena tidak semua tabel memiliki primary key, karena syarat untuk primary key adalah nilai harus unique, sehingga untuk tabel order_payments_dataset, order_reviews_dataset, dan geolocation_dataset, perlu adanya tambahan tabel yang berisi nilai unik saja.

## Data Preprocessing via SQL:
- Untuk menunjukkan perkembangan customer, hal yang dilihat antara lain : Rata-rata Monthly Active User (MAU) per tahun, Total customer baru per tahun, Jumlah customer yang melakukan repeat order per tahun, dan Rata-rata frekuensi order untuk setiap tahun.
- Untuk menunjukkan perkembangan produk, hal yang dilihat adalah : Revenue per tahun, Jumlah cancel order per tahun, Top kategori yang menghasilkan revenue terbesar per tahun, dan Kategori yang mengalami cancel order terbanyak per tahun.
- Sedangkan untuk tipe pembayaran, hal yang dilihat adalah: Perolehan transaksi dari jenis payment per tahun, dan Top kategori produk dari masing-masing payment per tahun

## Data Perkembangan Customer :
- Tabel yang digunakan : customers_dataset dan orders_dataset.
- Paling tinggi di tahun 2018 sebanyak 54.011 customer. Customer tidak melakukan repeat order kembali di tahun berikutnya.
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/114345988/207607566-7b3f5b65-2dfd-4e5b-b7bd-b43331b0c478.png">

## Data Produk :
- Tabel yang digunakan : product_dataset, orders_dataset, dan order_items_dataset.
- Berikut grafik revenue dalam periode waktu tertentu. Berdasarkan grafik tersebur, revenue tertinggi dicapai pada bulan November 2017
<img width="1000" alt="image" src="https://user-images.githubusercontent.com/114345988/207607809-845e65ca-2bce-45de-8556-6055403b27cb.png">

## Data Tipe Pembayaran :
- Tabel yang digunakan : orders_payment_dataset dan orders_dataset.
- Berdasarkan data, terdapat 4 jenis pembayaran yang digunakan : debit card, credit card, voucher, dan boleto. Nominal pembayaran menggunakan credit card mendominasi pembayaran.
<img width="700" alt="image" src="https://user-images.githubusercontent.com/114345988/207608547-b00fcc35-cb75-47a3-bead-00a66301472f.png">

## Skill yang didapatkan:
- Membuat ERD, Primary Key dan Foreign Key dalam Database SQL
- Import Table, Extract DATESTAMP, JOIN, SUBQUERY, AGGREGASI, GROUPING, Membuat CTE dan RANK

## Kesimpulan
- Performa perusahaan dari segi pelanggan sedikit memprihatinkan, karena terjadi penurunan yang cukup drastis pada akhir September dan Okotber 2018, dan tidak ada customer yang repeat order.
- Dari segi produk, jumlah produk yang disediakan oleh perusahaan cukup beragam, sehingga membuat customer memiliki banyak pilihan dalam berbelanja.
- Dari segi tipe pembayaran, jumlah pembayaran masih cukup sedikit. Hal ini membuat pelanggan cukup kesulitan dalam melakukan pembayaran.

## Saran
- Perlu adanya strategi marketing agar pelanggan dapat repeat order, sehingga jumlah custoomer tidak turun.
- Memperluas tipe pembayaran, sehingga dapat mempercepat proses pembelanjaan. Mungkin perlu menggunakan transfer atau uang elektronik.

