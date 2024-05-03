// Create table first
CREATE OR REPLACE TABLE our_first_database.public.employees (
        id int,
        first_name string,
        last_name string,
        email string,
        location string,
        department string
);

// Create file format object
CREATE OR REPLACE FILE FORMAT manage_db.file_formats.csv_file_format
    TYPE='CSV'
    FIELD_DELIMITER=','
    SKIP_HEADER=1
    NULL_IF = ('NULL', 'null')
    EMPTY_FIELD_AS_NULL=TRUE;

// CREATE DATA INTEGRATION OBJECT
CREATE OR REPLACE STORAGE INTEGRATION S3_INIT_NEW
    TYPE = EXTERNAL_STAGE
    STORAGE_PROVIDER = 'S3'
    ENABLED = TRUE
    STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::339712789026:role/snowpipe-s3bucket-role'
    STORAGE_ALLOWED_LOCATIONS = ('s3://dw-snowflake-bucket/snowpipe/')
    COMMENT = 'Creating connection to s3';

DESC STORAGE INTEGRATION S3_INIT_NEW;

// Create stage object using data integration
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.NEW_STAGE_OBJECT
    URL='s3://dw-snowflake-bucket/snowpipe/'
    STORAGE_INTEGRATION=S3_INIT_NEW
    FILE_FORMAT=manage_db.file_formats.csv_file_format;

LIST @MANAGE_DB.EXTERNAL_STAGES.NEW_STAGE_OBJECT;

// Creating new schema to keep things organized
CREATE OR REPLACE SCHEMA MANAGE_DB.pipe;

// Creating pipe object
CREATE OR REPLACE pipe MANAGE_DB.pipe.employee_pipe
AUTO_INGEST=TRUE
AS
    COPY INTO our_first_database.public.employees
    FROM @MANAGE_DB.EXTERNAL_STAGES.NEW_STAGE_OBJECT;
    
DESC pipe MANAGE_DB.pipe.employee_pipe;

SELECT * FROM our_first_database.public.employees;

// Showing different pipes available in snowflake db
SHOW PIPES;

SHOW PIPES LIKE '%employee%';

SHOW PIPES IN DATABASE MANAGE_DB;

SHOW PIPES IN SCHEMA MANAGE_DB.PIPE;

SHOW PIPES LIKE '%employee%' IN DATABASE MANAGE_DB;

    

    