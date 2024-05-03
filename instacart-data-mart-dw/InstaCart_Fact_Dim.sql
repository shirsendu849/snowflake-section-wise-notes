-- Creating connection to connect with aws s3
CREATE STAGE my_stage
URL = "s3://dw-snowflake-bucket/instacart/"
CREDENTIALS = (AWS_KEY_ID = '' AWS_SECRET_KEY = 
'');

-- Creating file format object
CREATE OR REPLACE FILE FORMAT csv_file_format
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY = '"';

-- Creating aisles table
CREATE OR REPLACE TABLE aisles (
       aisle_id INTEGER PRIMARY KEY,
       aisle VARCHAR
    );
-- Copy aisles data from s3 staging to aisles table
COPY INTO aisles(aisle_id, aisle)
FROM @my_stage/aisles.csv
FILE_FORMAT = (FORMAT_NAME = 'csv_file_format');

-- Creating departments table
CREATE OR REPLACE TABLE departments (
       department_id INTEGER PRIMARY KEY,
       department VARCHAR
);
-- Copy departments data from s3 staging to departments table
COPY INTO departments(department_id, department)
FROM @my_stage/departments.csv
FILE_FORMAT = (FORMAT_NAME = 'csv_file_format');

-- Creating products table
CREATE OR REPLACE TABLE products (
        product_id INTEGER PRIMARY KEY,
        product_name VARCHAR,
        aisle_id INTEGER,
        department_id INTEGER
    );
-- Copy products data from s3 staging to aisles table
COPY INTO products (product_id, product_name, aisle_id, department_id)
FROM @my_stage/products.csv
FILE_FORMAT = (FORMAT_NAME = 'csv_file_format');

-- Creating orders table
CREATE OR REPLACE TABLE orders (
        order_id INTEGER PRIMARY KEY,
        user_id INTEGER,
        eval_set STRING,
        order_number INTEGER,
        order_dow INTEGER,
        order_hour_of_day INTEGER,
        days_since_prior_order INTEGER
    );
-- Copy aisles data from s3 staging to aisles table
COPY INTO orders (order_id, user_id, eval_set, order_number, order_dow, order_hour_of_day, days_since_prior_order)
FROM @my_stage/orders.csv
FILE_FORMAT = (FORMAT_NAME = 'csv_file_format');

-- Creating order_products table
CREATE OR REPLACE TABLE order_products (
        order_id INTEGER,
        product_id INTEGER,
        add_to_cart_order INTEGER,
        reordered INTEGER,
        PRIMARY KEY (order_id, product_id)
    );  
-- Copy order_products data from s3 staging to aisles table
COPY INTO order_products (order_id, product_id, add_to_cart_order, reordered)
FROM @my_stage/order_products.csv
FILE_FORMAT = (FORMAT_NAME = 'csv_file_format');

-- Creating dim_orders table using CTA
CREATE OR REPLACE TABLE dim_orders AS (
    SELECT order_id, order_number, order_dow,
    order_hour_of_day, days_since_prior_order
    FROM orders
);

-- Creating dim_products table using CTA
CREATE OR REPLACE TABLE dim_products AS (
    SELECT product_id, product_name
    FROM products
);

-- Creating dim_users table using CTA
CREATE OR REPLACE TABLE dim_users AS (
    SELECT user_id FROM orders
);

-- Creating dim_aisles table using CTA
CREATE OR REPLACE TABLE dim_aisles AS (
    SELECT aisle_id, aisle
    FROM aisles
);

-- Creating dim_departments table using CTA
CREATE OR REPLACE TABLE dim_departments AS (
    SELECT department_id, department
    FROM departments
);

-- Creating fact_order_products using CTA
CREATE OR REPLACE TABLE fact_order_products AS (
        SELECT 
           op.order_id,
           op.product_id,
           o.user_id,
           p.aisle_id,
           p.department_id,
           op.add_to_cart_order,
           op.reordered
        FROM
           order_products op
        JOIN
           orders o ON op.order_id = o.order_id
        JOIN
           products p ON op.product_id = p.product_id
);

    
