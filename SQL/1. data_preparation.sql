-- Active: 1690037820527@@127.0.0.1@5432@minpro_ecommerce@public

-- Data Preparation

-- 1. Create Database --
-- CREATE DATABASE minpro_ecommerce;

-- 2. Create Tables --

-- === Tabel Customers === -- 
CREATE TABLE customers (
    customer_id VARCHAR PRIMARY KEY,
    customer_unique_id VARCHAR(255),
    customer_zip_code_prefix INTEGER,
    customer_city VARCHAR(255),
    customer_state VARCHAR(255)
);

import csv 
COPY customers(customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state) FROM '/Users/masendhy/Documents/rakamin/mini project/1. Analyzing eCommerce Business Performance with SQL/Analyzing_eCommerce_Business_Performance_with_SQL/dataset/customers_dataset.csv' DELIMITER ',' CSV HEADER;

--check customers 
select * from customers;

-- === Tabel Geolocation === --

CREATE TABLE geolocation (
    geolocation_id SERIAL PRIMARY KEY,
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat DECIMAL,
    geolocation_lng DECIMAL,
    geolocation_city VARCHAR(255),
    geolocation_state VARCHAR(255)
    
);

import csv
COPY geolocation (geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state) FROM '/Users/masendhy/Documents/rakamin/mini project/1. Analyzing eCommerce Business Performance with SQL/Analyzing_eCommerce_Business_Performance_with_SQL/dataset/geolocation_dataset.csv' DELIMITER ',' CSV HEADER;

--check geolocation 
select * from geolocation;

-- === Tabel Order Items === --

CREATE TABLE order_items (
    order_id VARCHAR ,
    order_item_id INT ,
    product_id VARCHAR,
    seller_id VARCHAR,
    shipping_limit_date TIMESTAMP,
    price FLOAT,
    freight_value FLOAT
    
);

import CSV
COPY order_items(order_id,order_item_id,product_id,seller_id,shipping_limit_date,price,freight_value) FROM '/Users/masendhy/Documents/rakamin/mini project/1. Analyzing eCommerce Business Performance with SQL/Analyzing_eCommerce_Business_Performance_with_SQL/dataset/order_items_dataset.csv' DELIMITER ',' CSV HEADER ;

--check order_items 
SELECT * FROM order_items;

set PRIMARY KEY
ALTER TABLE order_items ADD PRIMARY KEY (order_id,order_item_id);

-- === Tabel Order Payments === --

CREATE TABLE order_payments (
    order_id VARCHAR ,
    payment_sequential INTEGER,
    payment_type VARCHAR,
    payment_installments INTEGER,
    payment_value FLOAT
    
);

import CSV
COPY order_payments (order_id,payment_sequential,payment_type,payment_installments,payment_value) FROM '/Users/masendhy/Documents/rakamin/mini project/1. Analyzing eCommerce Business Performance with SQL/Analyzing_eCommerce_Business_Performance_with_SQL/dataset/order_payments_dataset.csv' DELIMITER ',' CSV HEADER ;

--check order_payments tabel
SELECT * FROM order_payments;

set PRIMARY KEY
ALTER TABLE order_payments ADD PRIMARY KEY (order_id,payment_sequential);

-- === Tabel Order Reviews === --

CREATE TABLE order_reviews(
    review_id VARCHAR(50),
    order_id VARCHAR(50),
    review_score INT,
    review_comment_title VARCHAR (50),
    review_comment_message VARCHAR (250),
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP

);

import CSV
COPY order_reviews(review_id,order_id,review_score,review_comment_title,review_comment_message,review_creation_date,review_answer_timestamp) FROM '/Users/masendhy/Documents/rakamin/mini project/1. Analyzing eCommerce Business Performance with SQL/Analyzing_eCommerce_Business_Performance_with_SQL/dataset/order_reviews_dataset.csv' DELIMITER ',' CSV HEADER ;

--check order_reviews
SELECT * FROM order_reviews;

set PRIMARY KEY
ALTER TABLE order_reviews ADD PRIMARY KEY (review_id,order_id);

-- === Tabel Orders === --

CREATE TABLE orders(
    order_id VARCHAR,
    customer_id VARCHAR,
    order_status VARCHAR,
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

import CSV
COPY orders(order_id,customer_id,order_status,order_purchase_timestamp,order_approved_at,order_delivered_carrier_date,order_delivered_customer_date,order_estimated_delivery_date) FROM '/Users/masendhy/Documents/rakamin/mini project/1. Analyzing eCommerce Business Performance with SQL/Analyzing_eCommerce_Business_Performance_with_SQL/dataset/orders_dataset.csv' DELIMITER ',' CSV HEADER ;

--check orders 
SELECT * FROM orders;

set PRIMARY KEY
ALTER TABLE orders ADD PRIMARY KEY (order_id);

-- === Tabel Products === --

CREATE TABLE product(
    column1 INT NULL,
    product_id VARCHAR,
    product_category_name VARCHAR,
    product_name_length FLOAT,
    product_description_length FLOAT,
    product_photos_qty FLOAT,
    product_weight_g FLOAT,
    product_length_cm FLOAT,
    product_height_cm FLOAT,
    product_width_cm FLOAT,
    CONSTRAINT product_pk PRIMARY KEY (product_id)

)

import CSV
COPY product( column1,product_id,product_category_name,product_name_length,product_description_length,product_photos_qty,product_weight_g,product_length_cm,product_height_cm,product_width_cm) FROM'/Users/masendhy/Documents/rakamin/mini project/1. Analyzing eCommerce Business Performance with SQL/Analyzing_eCommerce_Business_Performance_with_SQL/dataset/product_dataset.csv' DELIMITER ',' CSV HEADER;

--check product 
SELECT * FROM product;


-- === Tabel Sellers === --

CREATE TABLE sellers(
    seller_id VARCHAR,
    seller_zip_code_prefix INTEGER,
    seller_city VARCHAR,
    seller_state VARCHAR

);

import CSV
COPY sellers(seller_id,seller_zip_code_prefix,seller_city,seller_state) FROM '/Users/masendhy/Documents/rakamin/mini project/1. Analyzing eCommerce Business Performance with SQL/Analyzing_eCommerce_Business_Performance_with_SQL/dataset/sellers_dataset.csv'    DELIMITER ',' CSV HEADER;

--check sellers 
SELECT * FROM sellers;

set PRIMARY KEY
ALTER TABLE sellers ADD PRIMARY KEY (seller_id);
