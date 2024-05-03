CREATE OR REPLACE DATABASE DATA_S;

// Create stage 
CREATE OR REPLACE STAGE aws_stage
    URL='s3://bucketsnowflakes3';
    
// Listing files in stage
LIST @aws_stage;

// Create table
CREATE OR REPLACE TABLE orders (
        ORDER_ID VARCHAR(30),
        AMOUNT NUMERIC(38,0),
        PROFIT NUMERIC(38,0),
        QUANTITY NUMERIC(38,0),
        CATEGORY VARCHAR(30),
        SUBCATEGORY VARCHAR(30)
);

// Load data into table
COPY INTO orders
FROM @aws_stage
    FILE_FORMAT=(type='csv' skip_header=1, field_delimiter=',')
    FILES=('OrderDetails.csv');

// Creating share object
CREATE OR REPLACE SHARE SHARE_OBJECT;

// Give share privillage to the Database
GRANT USAGE ON DATABASE DATA_S TO SHARE SHARE_OBJECT;

// Give share privillage to the Schema
GRANT USAGE ON SCHEMA PUBLIC TO SHARE SHARE_OBJECT;

// Give share privillage to the table
GRANT SELECT ON TABLE DATA_S.PUBLIC.ORDERS TO SHARE SHARE_OBJECT;

// Validate grants
SHOW GRANTS TO SHARE SHARE_OBJECT;

--------Add Comsumer Account--------------
ALTER SHARE SHARE_OBJECT ADD ACCOUNT=<consumer-account-id>;

-- Reader acc

-- Create Reader Account--
CREATE MANAGED ACCOUNT tech_joy_account
ADMIN_NAME = tech_joy_admin,
ADMIN_PASSWORD = 'Sh06092002@',
TYPE = READER;

// Show accounts
SHOW MANAGED ACCOUNTS;

--------Add Reader Account--------------
ALTER SHARE SHARE_OBJECT ADD ACCOUNT=IY78730;
