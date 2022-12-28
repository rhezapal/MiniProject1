select * from customers_dataset
select * from orders_dataset


-- Miniproject1 Step 2
-- A. Mendapatkan Monthly Active User (MAU)
-- Skill : EXTRACT DATESTAMP, JOIN, SUBQUERY, AGGREGASI, GROUPING
-- 1. Dari data orders_dataset : extract data timestamp menjadi year dan month
-- 2. Dilakukan inner join dengan customers_dataset untuk mendapatkan daftar customer yang active
-- 3. Hitung jumlah customer dengan count berdasarkan month dan year
-- 4. Hitung rata-rata jumlah customer perbulan di tahun tersebut.
SELECT year,
       AVG(customer_active) as avg_customer_active
FROM
(
    SELECT year, month,
           COUNT(customer_idd) as customer_active
    FROM
    (
        SELECT *
        FROM(
                SELECT customer_idd, order_purchase_timestamp,
                       extract (YEAR FROM order_purchase_timestamp) as year,
                       extract (MONTH FROM order_purchase_timestamp) as month
                FROM orders_dataset
            ) as oe
        INNER JOIN customers_dataset  as b
        ON oe.customer_idd = b.customer_id
     ) as order_extract
    GROUP BY year, month
) as order_avg_customer
GROUP BY year
ORDER BY year ASC

--- Tabel grouping perbulan untuk grafik pertumbuhan customer diexcel

    SELECT DATE_TRUNC('month',order_purchase_timestamp) as month_group,
           COUNT(customer_idd) as customer_active
    FROM
    (
        SELECT *
        FROM(
                SELECT customer_idd, order_purchase_timestamp
                FROM orders_dataset
            ) as oe
        INNER JOIN customers_dataset  as b
        ON oe.customer_idd = b.customer_id
     ) as order_extract
    GROUP BY DATE_TRUNC('month',order_purchase_timestamp)


-- B. Mendapatkan Jumlah Costumer Baru pertahun
-- Skill : EXTRACT DATESTAMP, ETC, SUBQUERY, AGGREGASI, GROUPING
-- 1. Membuat ETC : 1. Dari data orders_dataset : extract data timestamp menjadi year dan month, 
-- -----------------dan dilakukan inner join dengan customers_dataset untuk mendapatkan 
-- -----------------daftar customer yang active
-- 2. Menentukan dari masing-masing order dilakukan di tahun berapa, 
-- 3. Memilih tahun terkecil dengan MIN dari masing-masing customer yang berarti tahun pertama order
-- 4. Menghitung jumlah customer dari tahun tersebut.

WITH order_extract AS (
SELECT *
        FROM(
                SELECT customer_idd, order_purchase_timestamp, order_id,
                       extract (YEAR FROM order_purchase_timestamp) as year,
                       extract (MONTH FROM order_purchase_timestamp) as month
                FROM orders_dataset
            ) as oe
        INNER JOIN customers_dataset  as b
        ON oe.customer_idd = b.customer_id
)
SELECT year_first_order,
    COUNT (year_first_order) as new_customer_order
FROM(
    SELECT customer_idd,
        MIN (year) as year_first_order
    from order_extract
    GROUP BY customer_idd
    ) as year_first_order
GROUP BY year_first_order
ORDER BY year_first_order ASC

-- C. Menghitung jumlah repeat order pertahun.
-- Skill : EXTRACT DATESTAMP, ETC, AGGREGASI, GROUPING, FILTERING
-- 1. Membuat ETC : 1. Dari data orders_dataset : extract data timestamp menjadi year dan month, 
-- -----------------dan dilakukan inner join dengan customers_dataset untuk mendapatkan 
-- -----------------daftar customer yang active
-- 2. Menghitung jumlah order dari masing-masing customer
-- 3. Melakukan filter jumlah order yang lebih dari 1

WITH order_extract AS (
SELECT *
        FROM(
                SELECT customer_idd, order_purchase_timestamp, order_id,
                       extract (YEAR FROM order_purchase_timestamp) as year,
                       extract (MONTH FROM order_purchase_timestamp) as month
                FROM orders_dataset
            ) as oe
        INNER JOIN customers_dataset  as b
        ON oe.customer_idd = b.customer_id
)
SELECT year,
       COUNT (jumlah_order) as repeat_order_pertahun
FROM (
    SELECT customer_idd, year,
        COUNT (order_id) as jumlah_order
    FROM order_extract
    GROUP BY customer_idd, year
    HAVING COUNT (order_id) > 1
    ) as jumlah_orders
GROUP BY year
ORDER BY year ASC

-- D. Menghitung rata-rata jumlah order pertahun
-- Skill : EXTRACT DATESTAMP, ETC, AGGREGASI, GROUPING, FILTERING
-- 1. Membuat ETC : 1. Dari data orders_dataset : extract data timestamp menjadi year dan month, 
-- -----------------dan dilakukan inner join dengan customers_dataset untuk mendapatkan 
-- -----------------daftar customer yang active
-- 2. Menentukan dari masing-masing order dilakukan di tahun berapa,
-- 3. Menghitung jumlah order per tahun dan rata-ratanya

WITH order_extract AS (
SELECT *
        FROM(
                SELECT customer_idd, order_purchase_timestamp, order_id,
                       extract (YEAR FROM order_purchase_timestamp) as year,
                       extract (MONTH FROM order_purchase_timestamp) as month
                FROM orders_dataset
            ) as oe
        INNER JOIN customers_dataset  as b
        ON oe.customer_idd = b.customer_id
)
SELECT year,
       AVG (jumlah_order) as avg_order
from (
    SELECT order_id, year,
        COUNT (order_id) as jumlah_order
    FROM order_extract
    GROUP BY order_id, year
     ) as jumlah_order_tahun
GROUP BY year
ORDER BY year ASC

-- E -- Menggabungkan tabel dari bagian A, B, C, dan D. 
-- 1. Mendownload hasil tabel dari masing-masing task
-- 2. Create table, Import table
-- 3. Melakukan JOIN.

CREATE TABLE table_A (
    year numeric,
    order_avg_customer numeric
)

CREATE TABLE table_B (
    year numeric,
    year_first_order numeric
)

CREATE TABLE table_D (
    year numeric,
    jumlah_order_tahun numeric
)

SELECT * from table_D
SELECT TA.year, TA.order_avg_customer, TB.year_first_order, TD.jumlah_order_tahun
FROM table_A as TA 
LEFT JOIN table_B as TB ON TA.year = TB.year
LEFT JOIN table_D as TD ON TA.year = TD.year



