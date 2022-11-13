
--- Step 4
---- 1. mendapatkan order_idd dengan JOIN orders_dataset dan order_payments_dataset
---- 2. hitung revenue dengan mengaggregasi payment_installment dan payment_value
---- 3. Agregasi SUM untuk payment_total, COUNT, dan AVG dan Group by YEAR

---- payment : debit card
WITH payment_record as(
        SELECT b.order_id, order_purchase_timestamp, order_status, payment_type, payment_installments, payment_value,
               ROUND (payment_value) as total_payment
                FROM(
                            SELECT order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_payments_dataset  as b
                    ON oe.order_id = b.order_id
         ) 
SELECT DATE_TRUNC('year',order_purchase_timestamp) as year_group,
       SUM (total_payment) as total_payment_debit_card,
       COUNT (order_status) as banyaknya_debit_card,
       ROUND (AVG (total_payment)) as avg_debit
FROM payment_record
WHERE payment_type = 'debit_card'
GROUP BY year_group, payment_type
ORDER BY year_group ASC

---- payment : credit_card
WITH payment_record as(
        SELECT b.order_id, order_purchase_timestamp, order_status, payment_type, payment_installments, payment_value,
               ROUND (payment_value) as total_payment
                FROM(
                            SELECT order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_payments_dataset  as b
                    ON oe.order_id = b.order_id
         ) 
SELECT DATE_TRUNC('year',order_purchase_timestamp) as year_group,
       SUM (total_payment) as total_payment_credit_card,
       COUNT (order_status) as banyaknya_credit_card,
       ROUND (AVG (total_payment)) as avg_credit
FROM payment_record
WHERE payment_type = 'credit_card'
GROUP BY year_group, payment_type
ORDER BY year_group ASC

---- payment : voucher
WITH payment_record as(
        SELECT b.order_id, order_purchase_timestamp, order_status, payment_type, payment_installments, payment_value,
               ROUND (payment_value) as total_payment
                FROM(
                            SELECT order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_payments_dataset  as b
                    ON oe.order_id = b.order_id
         ) 
SELECT DATE_TRUNC('year',order_purchase_timestamp) as year_group,
       SUM (total_payment) as total_payment_voucher,
       COUNT (order_status) as banyaknya_voucher,
       ROUND (AVG (total_payment)) as avg_voucher
FROM payment_record
WHERE payment_type = 'voucher'
GROUP BY year_group, payment_type
ORDER BY year_group ASC

---- payment : boleto
WITH payment_record as(
        SELECT b.order_id, order_purchase_timestamp, order_status, payment_type, payment_installments, payment_value,
               ROUND (payment_value) as total_payment
                FROM(
                            SELECT order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_payments_dataset  as b
                    ON oe.order_id = b.order_id
         ) 
SELECT DATE_TRUNC('year',order_purchase_timestamp) as year_group,
       SUM (total_payment) as total_payment_boleto,
       COUNT (order_status) as banyaknya_boleto,
       ROUND (AVG (total_payment)) as avg_boleto
FROM payment_record
WHERE payment_type = 'boleto'
GROUP BY year_group, payment_type
ORDER BY year_group ASC
-------
CREATE TABLE step4_debit (
    year_group timestamp without time zone,
    nom_payment_debit numeric,
    total_transaksi_debit numeric,
    avg_payment_debit double precision
)
CREATE TABLE step4_credit (
    year_group timestamp without time zone,
    nom_payment_credit numeric,
    total_transaksi_credit numeric,
    avg_payment_credit double precision
)
CREATE TABLE step4_voucher (
    year_group timestamp without time zone,
    nom_payment_vou numeric,
    total_transaksi_vou numeric,
    avg_payment_vou double precision
)
CREATE TABLE step4_boleto (
    year_group timestamp without time zone,
    nom_payment_boleto numeric,
    total_transaksi_boleto numeric,
    avg_payment_boleto double precision
)

SELECT PA.year_group, PA.nom_payment_debit, PB.nom_payment_credit, PC.nom_payment_vou, PD.nom_payment_boleto
FROM step4_debit as PA 
LEFT JOIN step4_credit as PB ON PA.year_group = PB.year_group
LEFT JOIN step4_voucher as PC ON PA.year_group = PC.year_group
LEFT JOIN step4_boleto as PD ON PA.year_group = PD.year_group        

SELECT PA.year_group, PA.total_transaksi_debit, PB.total_transaksi_credit, PC.total_transaksi_vou, PD.total_transaksi_boleto
FROM step4_debit as PA 
LEFT JOIN step4_credit as PB ON PA.year_group = PB.year_group
LEFT JOIN step4_voucher as PC ON PA.year_group = PC.year_group
LEFT JOIN step4_boleto as PD ON PA.year_group = PD.year_group 

SELECT PA.year_group, PA.avg_payment_debit, PB.avg_payment_credit, PC.avg_payment_vou, PD.avg_payment_boleto
FROM step4_debit as PA 
LEFT JOIN step4_credit as PB ON PA.year_group = PB.year_group
LEFT JOIN step4_voucher as PC ON PA.year_group = PC.year_group
LEFT JOIN step4_boleto as PD ON PA.year_group = PD.year_group 
------------------------
WITH payment_record as(
        SELECT d.order_id, order_purchase_timestamp, order_status, payment_type, payment_installments, payment_value,
               ROUND (payment_value) as total_payment, product_category_name
                    FROM(
                            SELECT customer_idd, order_purchase_timestamp, order_id, order_status
                            FROM orders_dataset
                        ) as oe
                    INNER JOIN order_items_dataset  as b
                    ON oe.order_id = b.order_idd
                    INNER JOIN product_dataset as c
                    ON b.product_idd = c.product_id
                    INNER JOIN order_payments_dataset  as d
                    ON oe.order_id = d.order_id
         )
SELECT *
FROM(
    SELECT *,
          RANK () OVER (PARTITION BY year_group, payment_type ORDER BY total_payment DESC) revenue_rank
    FROM(
        SELECT DATE_TRUNC('year', order_purchase_timestamp) as year_group, payment_type, product_category_name,
               SUM (ROUND(payment_value)) as total_payment
        FROM payment_record
        GROUP BY year_group, payment_type, product_category_name
        ) as payment_product_rank2 
    )payment_product_rank1
WHERE revenue_rank = 1
ORDER BY year_group, payment_type ASC


SELECT DATE_TRUNC('year',order_purchase_timestamp) as year_group,
       SUM (total_payment) as total_payment_boleto
FROM payment_record
WHERE payment_type = 'boleto'
GROUP BY year_group, payment_type
ORDER BY year_group ASC





         
         
         
         
         
         
         
         
         
         