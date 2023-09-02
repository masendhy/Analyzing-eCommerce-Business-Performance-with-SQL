-- our misssion :
-- Menganalisis performa dari masing-masing kategori produk yang ada dan bagaimana kaitannya dengan pendapatan perusahaan.

-- Langkah-langkah yang dilakukan :
-- * Membuat tabel yang berisi informasi pendapatan/revenue perusahaan total untuk masing-masing tahun (Hint: Revenue adalah harga barang dan juga biaya kirim. Pastikan juga melakukan filtering terhadap order status yang tepat untuk menghitung pendapatan)
-- * Membuat tabel yang berisi informasi jumlah cancel order total untuk masing-masing tahun (Hint: Perhatikan filtering terhadap order status yang tepat untuk menghitung jumlah cancel order)
-- * Membuat tabel yang berisi nama kategori produk yang memberikan pendapatan total tertinggi untuk masing-masing tahun (Hint: Perhatikan penggunaan window function dan juga filtering yang dilakukan)
-- * Membuat tabel yang berisi nama kategori produk yang memiliki jumlah cancel order terbanyak untuk masing-masing tahun (Hint: Perhatikan penggunaan window function dan juga filtering yang dilakukan)
-- * Menggabungkan informasi-informasi yang telah didapatkan ke dalam satu tampilan tabel (Hint: Perhatikan teknik join yang dilakukan serta kolom-kolom yang dipilih)

-- RESET TABLE
-- Ensure the results do not increase or differ from the initial input

DROP TABLE IF EXISTS total_revenue_year; 
DROP TABLE IF EXISTS total_canceled_order_year;
DROP TABLE IF EXISTS top_product_category_revenue_year; 
DROP TABLE IF EXISTS top_product_category_canceled_year; 


SELECT * FROM product;

SELECT * FROM orders;

SELECT * FROM order_items;


-- 1. Membuat tabel yang berisi informasi pendapatan/revenue perusahaan total untuk masing-masing tahun 
-- (Hint: Revenue adalah harga barang dan juga biaya kirim. Pastikan juga melakukan filtering terhadap order status yang tepat untuk menghitung pendapatan)

CREATE TABLE total_revenue_year AS
WITH revenue_orders AS
(
    SELECT 
        order_id,
        SUM(price + freight_value) AS revenue
    FROM
        order_items oi
    GROUP BY 1
)
SELECT 
    year,
    SUM(revenue) AS total_revenue
FROM
    orders o
JOIN
    revenue_orders ro ON o.order_id = ro.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

CREATE rev_peryear AS


-- 2. Membuat tabel yang berisi informasi jumlah cancel order total untuk masing-masing tahun 
--(Hint: Perhatikan filtering terhadap order status yang tepat untuk menghitung jumlah cancel order)

CREATE TABLE total_canceled_order_year AS
SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    COUNT(order_id) AS total_canceled_order
FROM
    orders o
WHERE order_status = 'canceled'
GROUP BY 1
ORDER BY 1;

SELECT * FROM total_canceled_order_year;

-- 3. Membuat tabel yang berisi nama kategori produk yang memberikan pendapatan total tertinggi untuk masing-masing tahun 
--(Hint: Perhatikan penggunaan window function dan juga filtering yang dilakukan)

CREATE TABLE top_product_category_revenue_year AS
WITH revenue_orders AS
(
    SELECT 
        order_id,
        EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
        SUM(price + freight_value) AS revenue
    FROM
        order_items oi
    GROUP BY 1
)
SELECT 
    year,
    product_category_name,
    SUM(revenue) AS total_revenue
FROM
    orders o
JOIN
    revenue_orders ro ON o.order_id = ro.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1, 2
ORDER BY 1;