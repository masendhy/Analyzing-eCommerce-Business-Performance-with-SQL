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

-- with table11 as(
--     SELECT orders.order_id, orders.order_status, orders.order_purchase_timestamp,
--     order_items.price, order_items.freight_value,(order_items.price + order_items.freight_value) as revenue,
--     extract(year from order_purchase_timestamp) as year
--     FROM orders
--     left join order_items on orders.order_id = order_items.order_id
--     WHERE orders.order_status not in ('canceled','unavailable','created')
-- ),
-- table12 as (
--     SELECT YEAR,
--     sum(revenue) as total_order_revenue
--     FROM table11
--     GROUP BY 1
-- )
-- SELECT year, total_order_revenue
-- FROM table12
-- ORDER BY 1
-- ;

CREATE TABLE total_order_revenue as
SELECT
extract(year from order_purchase_timestamp) as year,
SUM(order_items.price + order_items.freight_value) as total_order_revenue
FROM orders
Join order_items on orders.order_id = order_items.order_id
WHERE orders.order_status not in ('canceled','unavailable','created')
GROUP BY 1
;

--check the table
select * from total_order_revenue;


-- 2. Membuat tabel yang berisi informasi jumlah cancel order total untuk masing-masing tahun 
-- (Hint: Perhatikan filtering terhadap order status yang tepat untuk menghitung jumlah cancel order)

-- with table21 as (
--     SELECT orders.order_id, orders.order_status, orders.order_purchase_timestamp,
--     extract(year from order_purchase_timestamp) as year
--     FROM orders
--     WHERE orders.order_status in ('canceled')
-- ),
-- table22 as (
--     SELECT YEAR,
--     count(order_id) as total_canceled_order
--     FROM table21
--     GROUP BY 1
-- )
-- SELECT year, total_canceled_order
-- FROM table22
-- ORDER BY 1
-- ;

CREATE TABLE total_canceled_order as
SELECT
extract(year from order_purchase_timestamp) as year,
count(order_id) as total_canceled_order
FROM orders
WHERE orders.order_status in ('canceled')
GROUP BY 1
;

--check the table
select * from total_canceled_order;

--3. Membuat tabel yang berisi nama kategori produk yang memberikan pendapatan total tertinggi untuk masing-masing tahun 
--(Hint: Perhatikan penggunaan window function dan juga filtering yang dilakukan)


CREATE TABLE top_product_category as
SELECT 
    year,
    top_category,
    product_revenue
FROM (
    SELECT
    extract(year from order_purchase_timestamp) as year,
    product.product_category_name AS top_category,
    SUM(order_items.price + order_items.freight_value) AS product_revenue,
    RANK() OVER (PARTITION BY extract(year from order_purchase_timestamp) ORDER BY SUM(order_items.price + order_items.freight_value) DESC) AS ranking
    FROM orders
    Join order_items on orders.order_id = order_items.order_id
    Join product on order_items.product_id = product.product_id
    WHERE orders.order_status like 'delivered'
    GROUP BY 1,2
    ORDER BY 1
) as subquery
WHERE ranking = 1
;

--check the table
select * from top_product_category;


--4) Membuat tabel yang berisi nama kategori produk yang memiliki jumlah cancel order terbanyak untuk masing-masing tahun

CREATE TABLE most_canceled_category as
SELECT 
    year,
    most_canceled,
    total_canceled_order
FROM(
    SELECT
    extract(year from order_purchase_timestamp) as year,
    product.product_category_name AS most_canceled,
    count(orders.order_id) as total_canceled_order,
    RANK() OVER (PARTITION BY extract(year from order_purchase_timestamp) ORDER BY count(orders.order_id) DESC) AS ranking
    FROM orders
    Join order_items on orders.order_id = order_items.order_id
    Join product on order_items.product_id = product.product_id
    WHERE orders.order_status like 'canceled'
    GROUP BY 1,2
    ORDER BY 1
) as subquery
WHERE ranking = 1
;

--check the table
select * from most_canceled_category;


--delete anomali data
delete from top_product_category where year = 2020;
DELETE FROM most_canceled_category WHERE year = 2020;


--5. Menggabungkan informasi-informasi yang telah didapatkan ke dalam satu tampilan tabel 
--(Hint: Perhatikan teknik join yang dilakukan serta kolom-kolom yang dipilih)

SELECT
    total_order_revenue.year as year,
    total_order_revenue.total_order_revenue as total_revenue,
    top_product_category.top_category as top_category,
    total_canceled_order.total_canceled_order as total_canceled,
    most_canceled_category.most_canceled as top_canceled_product,
    most_canceled_category.total_canceled_order as total_canceled_order
FROM total_order_revenue
LEFT JOIN top_product_category on total_order_revenue.year = top_product_category.year
LEFT JOIN total_canceled_order on total_order_revenue.year = total_canceled_order.year
LEFT JOIN most_canceled_category on total_order_revenue.year = most_canceled_category.year
GROUP BY 1,2,3,4,5,6;

--create that table

DROP TABLE IF EXISTS product_category_quality;
CREATE TABLE product_category_quality AS
SELECT
    total_order_revenue.year as year,
    total_order_revenue.total_order_revenue as total_revenue,
    top_product_category.top_category as top_category,
    total_canceled_order.total_canceled_order as total_canceled,
    most_canceled_category.most_canceled as top_canceled_product,
    most_canceled_category.total_canceled_order as total_canceled_order
FROM total_order_revenue
LEFT JOIN top_product_category on total_order_revenue.year = top_product_category.year
LEFT JOIN total_canceled_order on total_order_revenue.year = total_canceled_order.year
LEFT JOIN most_canceled_category on total_order_revenue.year = most_canceled_category.year
GROUP BY 1,2,3,4,5,6;

--check the table
select * from product_category_quality;