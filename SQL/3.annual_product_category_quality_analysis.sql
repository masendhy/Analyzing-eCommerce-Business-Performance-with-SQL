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

with table11 as(
    SELECT orders.order_id, orders.order_status, orders.order_purchase_timestamp,
    order_items.price, order_items.freight_value,(order_items.price + order_items.freight_value) as revenue,
    extract(year from order_purchase_timestamp) as year
    FROM orders
    left join order_items on orders.order_id = order_items.order_id
    WHERE orders.order_status not in ('canceled','unavailable','created')
),
table12 as (
    SELECT YEAR,
    sum(revenue) as total_order_revenue
    FROM table11
    GROUP BY 1
)
SELECT year, total_order_revenue
FROM table12
ORDER BY 1
;

-- 2. Membuat tabel yang berisi informasi jumlah cancel order total untuk masing-masing tahun 
-- (Hint: Perhatikan filtering terhadap order status yang tepat untuk menghitung jumlah cancel order)

with table21 as (
    SELECT orders.order_id, orders.order_status, orders.order_purchase_timestamp,
    extract(year from order_purchase_timestamp) as year
    FROM orders
    left join order_items on orders.order_id = order_items.order_id
    WHERE orders.order_status = 'canceled'
),
table22 as (
    SELECT YEAR,
    count(order_status) as total_canceled_order
    FROM table21
    GROUP BY 1
)
SELECT year, total_canceled_order
FROM table22
ORDER BY 1
;
