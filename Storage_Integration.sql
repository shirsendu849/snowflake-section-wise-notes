CREATE OR REPLACE STORAGE INTEGRATION S3_INIT
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::339712789026:role/snowflake-s3bucket-storage-integration'
    STORAGE_ALLOWED_LOCATIONS = ('s3://dw-snowflake-bucket/instacart/')
    COMMENT = 'Creating connection to s3';

DESC STORAGE INTEGRATION S3_INIT;

// Creating new table
CREATE OR REPLACE TABLE MANAGE_DB.PUBLIC.ORDERS_S3_INT (
        order_id INTEGER PRIMARY KEY,
        user_id INTEGER,
        eval_set STRING,
        order_number INTEGER,
        order_dow INTEGER,
        order_hour_of_day INTEGER,
        days_since_prior_order INTEGER
);

// Creating new file format
CREATE OR REPLACE FILE FORMAT MANAGE_DB.EXTERNAL_STAGES.csv_file_format_storage_int
    TYPE='CSV'
    FIELD_DELIMITER=','
    SKIP_HEADER=1;
    

// Creating new stage using storage 
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.aws_stage_storage_integration 
    URL = 's3://dw-snowflake-bucket/instacart/'
    STORAGE_INTEGRATION = S3_INIT
    FILE_FORMAT = MANAGE_DB.EXTERNAL_STAGES.csv_file_format_storage_int;

DESC STAGE MANAGE_DB.EXTERNAL_STAGES.aws_stage_storage_integration;

LIST @MANAGE_DB.EXTERNAL_STAGES.aws_stage_storage_integration;

COPY INTO MANAGE_DB.PUBLIC.ORDERS_S3_INT
FROM @MANAGE_DB.EXTERNAL_STAGES.aws_stage_storage_integration
    FILES=('orders.csv');

SELECT * FROM MANAGE_DB.PUBLIC.ORDERS_S3_INT;