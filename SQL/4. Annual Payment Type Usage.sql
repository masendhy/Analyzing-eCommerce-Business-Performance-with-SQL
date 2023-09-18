-- 1. Menampilkan jumlah penggunaan masing-masing tipe pembayaran secara all time diurutkan dari yang terfavorit 
-- (Hint: Perhatikan struktur (kolom-kolom apa saja) dari tabel akhir yang ingin didapatkan)

SELECT payment_type, count(1) AS total_payment_type
FROM order_payments
GROUP BY 1
ORDER BY 2 DESC;

-- 2. Menampilkan detail informasi jumlah penggunaan masing-masing tipe pembayaran untuk setiap tahun 
-- (Hint: Perhatikan struktur (kolom-kolom apa saja) dari tabel akhir yang ingin didapatkan


SELECT payment_type,
sum(
    case when year = 2016 THEN total else 0 end ) as "2016",
sum(
    case when year = 2017 THEN total else 0 end ) as "2017",
sum(
    case when year = 2018 THEN total else 0 end ) as "2018"
FROM
(
    SELECT
        extract(year from orders.order_purchase_timestamp) as year,
        order_payments.payment_type,
        count(order_payments.payment_type) as total
    from orders
    join order_payments on order_payments.order_id = orders.order_id
    group by 1,2
) as sub
GROUP BY 1
ORDER BY 1;


