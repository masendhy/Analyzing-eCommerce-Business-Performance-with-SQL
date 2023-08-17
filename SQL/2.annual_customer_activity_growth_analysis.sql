
-- Conduct annual customer growth analysis using the following metrics: --

-- 1. Menampilkan rata-rata jumlah customer aktif bulanan (monthly active user/MAU) untuk setiap tahun
-- (Hint: Perhatikan kesesuaian format tanggal)

SELECT 
    year,
    floor(AVG(monthly_active_user)) AS monthly_active_user
FROM
    (
        SELECT 
            EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
            EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
            COUNT(DISTINCT customers.customer_unique_id) AS monthly_active_user
        FROM
            orders
        JOIN
            customers ON orders.customer_id = customers.customer_id
        GROUP BY 1, 2
    ) AS monthly_active_user
GROUP BY 1
ORDER BY 1;


-- 2. Menampilkan jumlah customer baru pada masing-masing tahun 
-- (Hint: Pelanggan baru adalah pelanggan yang melakukan order pertama kali)

SELECT
    date_part('year', first_date_order) AS year,
	count(customer_unique_id) AS new_customers

FROM
    (
        SELECT 
            customers.customer_unique_id,
            min( orders.order_purchase_timestamp) AS first_date_order
        FROM
            orders
        JOIN
            customers ON orders.customer_id = customers.customer_id
        GROUP BY 1
    ) AS first_order
GROUP BY 1
ORDER BY 1;

-- 3. Menampilkan jumlah customer yang melakukan pembelian lebih dari satu kali (repeat order) pada masing-masing tahun 
--(Hint: Pelanggan yang melakukan repeat order adalah pelanggan yang melakukan order lebih dari 1 kali)

SELECT
    year,
    COUNT(DISTINCT customer_unique_id) AS repeat_order
FROM
    (
        SELECT 
            EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
            customers.customer_unique_id,
            COUNT(DISTINCT orders.order_id) AS n_orders,
            COUNT(DISTINCT customers.customer_unique_id) AS n_customers
        FROM
            orders
        JOIN
            customers ON orders.customer_id = customers.customer_id
        GROUP BY 1,2
        HAVING COUNT(orders.order_id) > 1
    ) AS repeat_order
GROUP BY 1
ORDER BY 1;

-- 4. Menampilkan rata-rata jumlah order yang dilakukan customer untuk masing-masing tahun 
-- (Hint: Hitung frekuensi order (berapa kali order) untuk masing-masing customer terlebih dahulu)

SELECT
    year,
    ROUND(AVG(n_orders), 2) AS avg_order
FROM
    (
        SELECT 
            EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
            customers.customer_unique_id,
            COUNT(DISTINCT customers.customer_unique_id) AS n_customers,
            COUNT(DISTINCT orders.order_id) AS n_orders
        FROM
            orders
        JOIN
            customers ON orders.customer_id = customers.customer_id
        GROUP BY 1, 2
    ) AS n_orders
GROUP BY 1
ORDER BY 1;

-- 5. Menggabungkan ketiga metrik yang telah berhasil ditampilkan menjadi satu tampilan tabel
-- (Hint: Gunakan union all)

WITH
    monthly_active_user AS (
        SELECT 
    year,
    floor(AVG(monthly_active_user)) AS monthly_active_user
FROM
    (
        SELECT 
            EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
            EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
            COUNT(DISTINCT customers.customer_unique_id) AS monthly_active_user
        FROM
            orders
        JOIN
            customers ON orders.customer_id = customers.customer_id
        GROUP BY 1, 2
    ) AS monthly_active_user
GROUP BY 1),


    new_customer AS (
        SELECT
    date_part('year', first_date_order) AS year,
	count(customer_unique_id) AS new_customers

FROM
    (
        SELECT 
            customers.customer_unique_id,
            min( orders.order_purchase_timestamp) AS first_date_order
        FROM
            orders
        JOIN
            customers ON orders.customer_id = customers.customer_id
        GROUP BY 1
    ) AS first_order
GROUP BY 1),


    repeat_order AS (
        SELECT
    year,
    COUNT(DISTINCT customer_unique_id) AS repeat_order
FROM
    (
        SELECT 
            EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
            customers.customer_unique_id,
            COUNT(DISTINCT orders.order_id) AS n_orders,
            COUNT(DISTINCT customers.customer_unique_id) AS n_customers
        FROM
            orders
        JOIN
            customers ON orders.customer_id = customers.customer_id
        GROUP BY 1,2
        HAVING COUNT(orders.order_id) > 1
    ) AS repeat_order
GROUP BY 1
    ),

    
    avg_order AS (
        SELECT
    year,
    ROUND(AVG(n_orders), 2) AS avg_order
FROM
    (
        SELECT 
            EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
            customers.customer_unique_id,
            COUNT(DISTINCT customers.customer_unique_id) AS n_customers,
            COUNT(DISTINCT orders.order_id) AS n_orders
        FROM
            orders
        JOIN
            customers ON orders.customer_id = customers.customer_id
        GROUP BY 1, 2
    ) AS n_orders
GROUP BY 1)

SELECT
    monthly_active_user.year,
    monthly_active_user.monthly_active_user,
    new_customer.new_customers,
    repeat_order.repeat_order,
    avg_order.avg_order
FROM
    monthly_active_user
JOIN
    new_customer ON monthly_active_user.year = new_customer.year
JOIN
    repeat_order ON monthly_active_user.year = repeat_order.year
JOIN
    avg_order ON monthly_active_user.year = avg_order.year
ORDER BY 1;
    

    



