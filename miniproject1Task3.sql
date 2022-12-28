select * from product_dataset
select * from orders_dataset
select * from order_items_dataset
select * from order_payments_dataset

-- Step 3
-- A. Menentukan revenue per tahun dengan cara :
---- 1. mendapatkan order_idd dengan JOIN orders_dataset dan order_items_dataset
---- 2. mendapatkan product_idd dengan JOIN order_items_dataset dan product_id
---- 3. hitung revenue dengan mengaggregasi  order_item_id, price, freight_value
---- 4. group by YEAR

SELECT DATE_TRUNC('year',order_purchase_timestamp) as year_group,
       SUM (revenue) as sum_revenue
       FROM(
        SELECT order_idd, product_idd, order_purchase_timestamp, order_status, order_item_id, price, freight_value, product_category_name,
            (order_item_id*price + freight_value) as revenue
                    FROM(
                            SELECT customer_idd, order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_items_dataset  as b
                    ON oe.order_id = b.order_idd
                    INNER JOIN product_dataset as c
                    ON b.product_idd = c.product_id
         ) as revenue_year
GROUP BY DATE_TRUNC('year',order_purchase_timestamp)
ORDER BY year_group ASC

---- A. 4. group by MONTH
WITH revenue_year as(
        SELECT order_idd, product_idd, order_purchase_timestamp, order_status, order_item_id, price, freight_value, product_category_name,
            ROUND(order_item_id*price + freight_value) as revenue
                    FROM(
                            SELECT customer_idd, order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_items_dataset  as b
                    ON oe.order_id = b.order_idd
                    INNER JOIN product_dataset as c
                    ON b.product_idd = c.product_id
         )
SELECT DATE_TRUNC('month',order_purchase_timestamp) as month_group,
       SUM (revenue) as sum_revenue
FROM revenue_year
GROUP BY DATE_TRUNC('month',order_purchase_timestamp)
ORDER BY month_group ASC

-- Step 3
--- B. Cancel Order
--- 1. buat ETC : mendapatkan order_idd dengan JOIN orders_dataset dan order_items_dataset,
----------------- mendapatkan product_idd dengan JOIN order_items_dataset dan product_id,
----------------- hitung revenue dengan mengaggregasi  order_item_id, price, freight_value,
--- 2. filtering dan Groupin by year,
WITH revenue_year as(
        SELECT order_idd, product_idd, order_purchase_timestamp, order_status, order_item_id, price, freight_value, product_category_name,
            (order_item_id*price + freight_value) as revenue
                    FROM(
                            SELECT customer_idd, order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_items_dataset  as b
                    ON oe.order_id = b.order_idd
                    INNER JOIN product_dataset as c
                    ON b.product_idd = c.product_id
         )
SELECT DATE_TRUNC('year',order_purchase_timestamp) as year_group,
       COUNT (order_idd) as jumlah_cancel_order
FROM revenue_year
WHERE order_status = 'canceled'
GROUP BY DATE_TRUNC('year',order_purchase_timestamp)
ORDER BY year_group ASC


---- buat month
WITH revenue_year as(
        SELECT order_idd, product_idd, order_purchase_timestamp, order_status, order_item_id, price, freight_value, product_category_name,
            (order_item_id*price + freight_value) as revenue
                    FROM(
                            SELECT customer_idd, order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_items_dataset  as b
                    ON oe.order_id = b.order_idd
                    INNER JOIN product_dataset as c
                    ON b.product_idd = c.product_id
         )
SELECT DATE_TRUNC('month',order_purchase_timestamp) as month_group,
       COUNT (order_idd) as jumlah_order_delivered
FROM revenue_year
WHERE order_status = 'delivered'
GROUP BY DATE_TRUNC('month',order_purchase_timestamp), order_status
ORDER BY month_group, order_status ASC

-- Step 3
--- C. Cancel Order
--- 1. buat ETC : mendapatkan order_idd dengan JOIN orders_dataset dan order_items_dataset,
----------------- mendapatkan product_idd dengan JOIN order_items_dataset dan product_id,
----------------- hitung revenue dengan mengaggregasi  order_item_id, price, freight_value,
--- 2. Aggregasi SUM (revenue) per category_product_name
--- 3. Grouping per year
--- 4. Menggunakan Fungsi RANK untuk mengurutkan berdasarkan sum_revenue tertinggi pertahunnya
--- 5. Filtering RANK nomor 1 di setiap tahunnya.
WITH revenue_year as(
        SELECT order_idd, product_idd, order_purchase_timestamp, order_status, order_item_id, price, freight_value, product_category_name,
            (order_item_id*price + freight_value) as revenue
                    FROM(
                            SELECT customer_idd, order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_items_dataset  as b
                    ON oe.order_id = b.order_idd
                    INNER JOIN product_dataset as c
                    ON b.product_idd = c.product_id
         )
SELECT *
FROM(
    SELECT *,
          RANK () OVER (PARTITION BY year_group ORDER BY sum_revenue DESC) revenue_rank
    FROM(
        SELECT DATE_TRUNC('year', order_purchase_timestamp) as year_group, product_category_name,
               SUM (revenue) as sum_revenue
        FROM revenue_year
        GROUP BY year_group, product_category_name
        ) as revenue_rank2 
    )revenue_rank1
WHERE revenue_rank = 1
ORDER BY year_group ASC
------------
---permonth

WITH revenue_year as(
        SELECT order_idd, product_idd, order_purchase_timestamp, order_status, order_item_id, price, freight_value, product_category_name,
            ROUND(order_item_id*price + freight_value) as revenue
                    FROM(
                            SELECT customer_idd, order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_items_dataset  as b
                    ON oe.order_id = b.order_idd
                    INNER JOIN product_dataset as c
                    ON b.product_idd = c.product_id
         )
SELECT *
FROM(
    SELECT *,
          RANK () OVER (PARTITION BY month_group ORDER BY sum_revenue DESC) revenue_rank
    FROM(
        SELECT DATE_TRUNC('month', order_purchase_timestamp) as month_group, product_category_name,
               SUM (revenue) as sum_revenue
        FROM revenue_year
        GROUP BY month_group, product_category_name
        ) as revenue_rank2 
    )revenue_rank1
WHERE revenue_rank = 1  
ORDER BY month_group ASC


-- Step 3
--- D. Cancel Order
--- 1. buat ETC : mendapatkan order_idd dengan JOIN orders_dataset dan order_items_dataset,
----------------- mendapatkan product_idd dengan JOIN order_items_dataset dan product_id,
----------------- hitung revenue dengan mengaggregasi  order_item_id, price, freight_value,
--- 2. filtering dan Groupin by year,
WITH revenue_year as(
        SELECT order_idd, product_idd, order_purchase_timestamp, order_status, order_item_id, price, freight_value, product_category_name,
            (order_item_id*price + freight_value) as revenue
                    FROM(
                            SELECT customer_idd, order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_items_dataset  as b
                    ON oe.order_id = b.order_idd
                    INNER JOIN product_dataset as c
                    ON b.product_idd = c.product_id
         )
SELECT *
FROM(
    SELECT *,
          RANK () OVER (PARTITION BY year_group ORDER BY jumlah_cancel_order DESC) cancelled_rank
    FROM(
        SELECT DATE_TRUNC('year', order_purchase_timestamp) as year_group, product_category_name,
               COUNT (order_idd) as jumlah_cancel_order
        FROM revenue_year
        WHERE order_status = 'canceled'
        GROUP BY year_group, product_category_name
        ) as cancelled_rank2 
    )cancelled_rank1
WHERE cancelled_rank = 1
ORDER BY year_group ASC
----
CREATE TABLE step3_sumrevenue (
    year_group timestamp without time zone,
    sum_revenue double precision
)

CREATE TABLE step3_jumlah_cancel_order (
    year_group timestamp without time zone,
    jumlah_cancel_order integer
)

CREATE TABLE step3_category_high_revenue(
    year_group timestamp without time zone,
    product_category_name varchar,
    sum_revenue double precision,
    revenue_rank integer
)
ALTER TABLE step3_category_high_revenue RENAME COLUMN product_category_name TO product_category_high_revenue;
ALTER TABLE step3_category_high_revenue RENAME COLUMN sum_revenue TO sum_high_revenue;

CREATE TABLE step3_category_cancel(
    year_group timestamp without time zone,
    product_category_name varchar,
    jumlah_cancel_order int,
    cancelled_rank integer
)
ALTER TABLE step3_category_cancel RENAME COLUMN product_category_name TO product_category_cancel;

SELECT * FROM step3_sumrevenue
SELECT * FROM step3_jumlah_cancel_order
SELECT * FROM step3_category_high_revenue
SELECT * FROM step3_category_cancel


SELECT T1.year_group, ROUND (sum_revenue) as sum_revenue, T2.jumlah_cancel_order, product_category_high_revenue, ROUND(sum_high_revenue) as sum_high_revenue, product_category_cancel, T4.jumlah_cancel_order
FROM step3_sumrevenue as T1 
LEFT JOIN step3_jumlah_cancel_order as T2   ON T1.year_group = T2.year_group
LEFT JOIN step3_category_high_revenue as T3 ON T1.year_group = T3.year_group
LEFT JOIN step3_category_cancel as T4       ON T1.year_group = T4.year_group 


