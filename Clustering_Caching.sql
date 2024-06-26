// Publicly accessible staging_area
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.aws_public_stage
    url = 's3://bucketsnowflakes3';

LIST @MANAGE_DB.EXTERNAL_STAGES.aws_public_stage;

CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDERS (
    ORDER_ID VARCHAR(30),
    AMOUNT INT,
    PROFIT INT,
    QUANTITY INT,
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30)
);

// Load data using COPY command
COPY INTO MANAGE_DB.PUBLIC.ORDERS
FROM @MANAGE_DB.EXTERNAL_STAGES.aws_public_stage
file_format = (type = 'csv' field_delimiter = ',' skip_header = 1)
files = ('OrderDetails.csv');

CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDER_CACHING (
    ORDER_ID VARCHAR(30),
    AMOUNT NUMBER(30, 0),
    PROFIT NUMBER(30, 0),
    QUANTITY NUMBER(30, 0),
    CATEGORY VARCHAR(30),
    SUBCATEGORY VARCHAR(30),
    DATE DATE
);

INSERT INTO MANAGE_DB.PUBLIC.ORDER_CACHING
SELECT
    t1. ORDER_ID,
    t1.AMOUNT,
    t1.PROFIT,
    t1.QUANTITY,
    t1.CATEGORY,
    t1.SUBCATEGORY,
    DATE(UNIFORM(1500000000, 1700000000, RANDOM()))
FROM
    ORDERS t1
CROSS JOIN
    (SELECT * FROM ORDERS) t2
CROSS JOIN
    (SELECT TOP 100 *  FROM ORDERS) t3;

// Query performance before cluster key
SELECT TOP 100 * FROM MANAGE_DB.PUBLIC.ORDER_CACHING WHERE DATE = '2021-01-13';

// Adding cluster key & compute the result
ALTER TABLE MANAGE_DB.PUBLIC.ORDER_CACHING CLUSTER BY(DATE);

SELECT TOP 100 * FROM MANAGE_DB.PUBLIC.ORDER_CACHING WHERE DATE = '2020-01-25';











