CREATE OR REPLACE DATABASE MANAGE_DB;

CREATE OR REPLACE SCHEMA external_stages;

// Creating external stage
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.aws_stage 
    url = 's3://dw-snowflake-bucket/instacart/'
    credentials = (aws_key_id = 'AKIAU6GDVZIRIZXR3AVR',
aws_secret_key = 'qC1EW+hCc/gykl0zJakS2gAUD6nBl3qAcvxKM3Bq');

// Description of extrenal stage
DESC STAGE MANAGE_DB.EXTERNAL_STAGES.aws_stage;

// Alter external stage
ALTER STAGE MANAGE_DB.EXTERNAL_STAGES.aws_stage
    SET credentials = (aws_key_id = 'XYZ_DUMMY_ID' aws_secret_key = '987xyz');

// Publicly accessible staging_area
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.aws_public_stage
    url = 's3://bucketsnowflakes3'
    
// List down all the files inside external stage location
LIST @MANAGE_DB.EXTERNAL_STAGES.aws_stage;
LIST @MANAGE_DB.EXTERNAL_STAGES.aws_public_stage;

// Creating new table
CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

SELECT * FROM MANAGE_DB.PUBLIC.ORDERS;

// Load data using COPY command
COPY INTO MANAGE_DB.PUBLIC.ORDERS
FROM @MANAGE_DB.EXTERNAL_STAGES.aws_public_stage
file_format = (type = 'csv' field_delimiter = ',' skip_header = 1)
files = ('OrderDetails.csv');

// Transformation in snowflake while data loading
CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDERS_trans (
    ORDER_ID VARCHAR(30),
    AMOUNT INT
); 

// Transforming data before loading using COPY command
COPY INTO MANAGE_DB.PUBLIC.ORDERS_trans
FROM (SELECT s.$1, s.$2 FROM @MANAGE_DB.EXTERNAL_STAGES.aws_public_stage s)
file_format = (type = 'csv' field_delimiter = ',' skip_header = 1)
files = ('OrderDetails.csv');

// Transformation in snowflake while data loading
CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDERS_trans_01 (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    CATEGORY_SUBSTRING VARCHAR(5)
); 



// Transforming data before loading using COPY command
COPY INTO MANAGE_DB.PUBLIC.ORDERS_trans_01
FROM (
        SELECT
        s.$1,
        s.$2,
        s.$3,
        CASE
            WHEN CAST(s.$3 as INT) > 0 THEN 'profitable' ELSE 'not profitable' END
        FROM
        @MANAGE_DB.EXTERNAL_STAGES.aws_public_stage s
     )
file_format = (type = 'csv' field_delimiter = ',' skip_header = 1)
files = ('OrderDetails.csv');

SELECT * FROM MANAGE_DB.PUBLIC.ORDERS_trans_01;

    
