-- Conduct annual customer growth analysis using the following metrics: --

-- 1. Menampilkan rata-rata jumlah customer aktif bulanan (monthly active user/MAU) untuk setiap tahun
-- (Hint: Perhatikan kesesuaian format tanggal)

---Monthly Active User---
with table11 as (
    SELECT orders.customer_id,customers.customer_unique_id,orders.order_purchase_timestamp
    FROM orders
    LEFT JOIN customers ON orders.customer_id = customers.customer_id
),
table12 as (
    SELECT
        EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
        COUNT(DISTINCT customer_unique_id) AS monthly_active_user
    FROM table11
    GROUP BY 1,2    
)
SELECT
    year,
    floor(AVG(monthly_active_user)) AS monthly_active_user
FROM table12
GROUP BY 1;

-- 2. Menampilkan jumlah customer baru pada masing-masing tahun 
-- (Hint: Pelanggan baru adalah pelanggan yang melakukan order pertama kali)

--New Customers---
with 
table21 as (
    SELECT orders.customer_id,
    customers.customer_unique_id,
    orders.order_purchase_timestamp
    FROM orders
    LEFT JOIN customers ON orders.customer_id = customers.customer_id
),
table22 as (
    SELECT DISTINCT customer_unique_id,
    min(order_purchase_timestamp) AS first_order
    FROM table21
    GROUP BY customer_unique_id
)
select EXTRACT(YEAR FROM first_order) AS year,
COUNT(DISTINCT customer_unique_id) AS new_customer
FROM table22
GROUP BY YEAR
ORDER BY YEAR;

-- 3. Menampilkan jumlah customer yang melakukan pembelian lebih dari satu kali (repeat order) pada masing-masing tahun 
--(Hint: Pelanggan yang melakukan repeat order adalah pelanggan yang melakukan order lebih dari 1 kali)

---Repeat Orders---
with table31 as (
    SELECT 
    customers.customer_unique_id,
    orders.customer_id,
    EXTRACT (YEAR from order_purchase_timestamp) as year
    from orders
    left JOIN customers on orders.customer_id = customers.customer_id 
),
table32 as (
    SELECT year,
    customer_unique_id,
    count(customer_unique_id) as amount
    from table31
    GROUP BY 1,2
    HAVING count(customer_unique_id)>1
)
select year,
count(customer_unique_id) as repeat_order
from table32
group by year;

-- 4. Menampilkan rata-rata jumlah order yang dilakukan customer untuk masing-masing tahun 
-- (Hint: Hitung frekuensi order (berapa kali order) untuk masing-masing customer terlebih dahulu)

--ORDER AVERAGE--
with table41 as (
    select
    customers.customer_unique_id,
    orders.customer_id,
    EXTRACT(YEAR FROM order_purchase_timestamp) as YEAR
    from orders
    left join customers on orders.customer_id = customers.customer_id
),
table42 as (
    SELECT YEAR,
    customer_unique_id,
    count(customer_unique_id) as amount
    from table41
    GROUP BY 1,2
)
select 
year,
round(avg(amount),4) as order_avg
from table42
group by YEAR;

-- 5. Menggabungkan ketiga metrik yang telah berhasil ditampilkan menjadi satu tampilan tabel
-- (Hint: Gunakan union all)

--Merge Tables--


with table11 as (
    SELECT orders.customer_id,customers.customer_unique_id,orders.order_purchase_timestamp
    FROM orders
    LEFT JOIN customers ON orders.customer_id = customers.customer_id
),
table12 as (
    SELECT
        EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
        EXTRACT(MONTH FROM order_purchase_timestamp) AS month,
        COUNT(DISTINCT customer_unique_id) AS monthly_active_user
    FROM table11
    GROUP BY 1,2    
),
tb1 as (
    SELECT YEAR,
    floor(AVG(monthly_active_user)) AS monthly_active_user
    FROM table12
    GROUP BY 1
),
table21 as (
    SELECT orders.customer_id,
    customers.customer_unique_id,
    orders.order_purchase_timestamp
    FROM orders
    LEFT JOIN customers ON orders.customer_id = customers.customer_id
),
table22 as (
    SELECT DISTINCT customer_unique_id,
    min(order_purchase_timestamp) AS first_order
    FROM table21
    GROUP BY customer_unique_id
),
tb2 as(
    select EXTRACT(YEAR FROM first_order) AS year,
COUNT(DISTINCT customer_unique_id) AS new_customer
FROM table22
GROUP BY YEAR
ORDER BY YEAR
),
table31 as (
    SELECT 
    customers.customer_unique_id,
    orders.customer_id,
    EXTRACT (YEAR from order_purchase_timestamp) as year
    from orders
    left JOIN customers on orders.customer_id = customers.customer_id 
),
table32 as (
    SELECT year,
    customer_unique_id,
    count(customer_unique_id) as amount
    from table31
    GROUP BY 1,2
    HAVING count(customer_unique_id)>1
),
tb3 as (
    select year,
count(customer_unique_id) as repeat_order
from table32
group by year
),
table41 as (
    select
    customers.customer_unique_id,
    orders.customer_id,
    EXTRACT(YEAR FROM order_purchase_timestamp) as YEAR
    from orders
    left join customers on orders.customer_id = customers.customer_id
),
table42 as (
    SELECT YEAR,
    customer_unique_id,
    count(customer_unique_id) as amount
    from table41
    GROUP BY 1,2
),
tb4 as (
  select 
year,
round(avg(amount),4) as order_avg
from table42
group by YEAR)
SELECT tb1.YEAR,tb1.monthly_active_user,tb2.new_customer,tb3.repeat_order,tb4.order_avg
FROM tb1
LEFT JOIN tb2 ON tb1.YEAR = tb2.year
LEFT JOIN tb3 ON tb1.YEAR = tb3.year
LEFT JOIN tb4 ON tb1.YEAR = tb4.year

