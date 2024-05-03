// Setting up table
CREATE OR REPLACE TABLE OUR_FIRST_DATABASE.PUBLIC.TEST (
        id int,
        first_name string,
        last_name string,
        email string,
        gender string,
        job string,
        phone string
);

// Creating file format
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.csv_file 
    type='csv'
    field_delimiter=','
    skip_header=1;

// Creating new stage where storage location is public
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.time_travel_stage 
    URL='s3://data-snowflake-fundamentals/time-travel/'
    FILE_FORMAT=MANAGE_DB.FILE_FORMATS.csv_file;

LIST @MANAGE_DB.EXTERNAL_STAGES.time_travel_stage;

// Loading data into table
COPY INTO OUR_FIRST_DATABASE.PUBLIC.TEST 
FROM @MANAGE_DB.EXTERNAL_STAGES.time_travel_stage
    FILES=('customers.csv');

SELECT * FROM OUR_FIRST_DATABASE.PUBLIC.TEST;

// use-case: update data(By Mistake)
UPDATE OUR_FIRST_DATABASE.PUBLIC.TEST
SET FIRST_NAME='JOYEN';  -- Don't have any condition

// // // using time-travel method 1 - 3 minutes back
SELECT * FROM OUR_FIRST_DATABASE.PUBLIC.TEST at (OFFSET => -60*3);

TRUNCATE OUR_FIRST_DATABASE.PUBLIC.TEST;

ALTER SESSION SET TIMEZONE='UTC'
SELECT CURRENT_TIMESTAMP;

UPDATE OUR_FIRST_DATABASE.PUBLIC.TEST
SET JOB = 'Data Scientist';

// // // using time-travel method 2 - before current timestamp back
-- 2024-04-24 07:27:56.764 +0000
SELECT * FROM OUR_FIRST_DATABASE.PUBLIC.TEST before(timestamp => '2024-04-24 07:26:50.764 +0000'::timestamp);

UPDATE OUR_FIRST_DATABASE.PUBLIC.TEST
SET email=null;

// // // using time-travel method 3 - query id
SELECT * FROM OUR_FIRST_DATABASE.PUBLIC.TEST before(statement => '01b3e0e2-3201-1047-0008-872a000212ae');

// Bad method to restore data
CREATE OR REPLACE TABLE OUR_FIRST_DATABASE.PUBLIC.TEST AS
SELECT * FROM OUR_FIRST_DATABASE.PUBLIC.TEST before(statement => '01b3e0e8-3201-1045-0008-872a0001c8c6');

// Good practise to restore data
CREATE OR REPLACE TABLE OUR_FIRST_DATABASE.PUBLIC.TEST_01 AS
SELECT * FROM OUR_FIRST_DATABASE.PUBLIC.TEST before(statement => '01b3e141-3201-1047-0008-872a0002130e');

SELECT * FROM OUR_FIRST_DATABASE.PUBLIC.TEST_01;

TRUNCATE OUR_FIRST_DATABASE.PUBLIC.TEST;

INSERT INTO OUR_FIRST_DATABASE.PUBLIC.TEST
SELECT * FROM OUR_FIRST_DATABASE.PUBLIC.TEST_01;

