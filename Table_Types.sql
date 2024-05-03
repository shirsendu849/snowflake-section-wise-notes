CREATE OR REPLACE DATABASE PDB;

// Permanent table
CREATE OR REPLACE TABLE PDB.PUBLIC.customers (
        id int,
        first_name string,
        last_name string,
        email string,
        gender string,
        job string,
        phone string
);

// Permanent table
CREATE OR REPLACE TABLE PDB.PUBLIC.helper (
        id int,
        first_name string,
        last_name string,
        email string,
        gender string,
        job string,
        phone string
);

// Creating file format
CREATE OR REPLACE FILE FORMAT PDB.PUBLIC.csv_file 
    type='csv'
    field_delimiter=','
    skip_header=1;

// Creating new stage where storage location is public
CREATE OR REPLACE STAGE PDB.PUBLIC.csv_stage 
    URL='s3://data-snowflake-fundamentals/time-travel/'
    FILE_FORMAT=MANAGE_DB.FILE_FORMATS.csv_file;

LIST @PDB.PUBLIC.csv_stage;

COPY INTO PDB.PUBLIC.CUSTOMERS 
FROM @PDB.PUBLIC.csv_stage
    FILES=('customers.csv');

COPY INTO PDB.PUBLIC.HELPER 
FROM @PDB.PUBLIC.csv_stage
    FILES=('customers.csv');

SELECT * FROM PDB.PUBLIC.CUSTOMERS;

SELECT * FROM PDB.PUBLIC.HELPER;

SHOW TABLES;

// Creating Transient DB
CREATE OR REPLACE DATABASE TDB;

// Transient table
CREATE OR REPLACE TRANSIENT TABLE TDB.PUBLIC.customers_transient (
        id int,
        first_name string,
        last_name string,
        email string,
        gender string,
        job string,
        phone string
);

ALTER TABLE TDB.PUBLIC.customers_transient
SET DATA_RETENTION_TIME_IN_DAYS = 0;

INSERT INTO TDB.PUBLIC.customers_transient
SELECT t1.* FROM PDB.PUBLIC.customers t1
CROSS JOIN (SELECT * FROM PDB.PUBLIC.customers) t2

DROP TABLE TDB.PUBLIC.customers_transient;
UNDROP TABLE TDB.PUBLIC.customers_transient;

SHOW TABLES;

// Creating transiant schema
CREATE OR REPLACE TRANSIENT SCHEMA TDB.TRANSIENT_SCHEMA;

CREATE OR REPLACE TABLE TDB.TRANSIENT_SCHEMA.customers (
        id int,
        first_name string,
        last_name string,
        email string,
        gender string,
        job string,
        phone string
);

// Creating temporary table
CREATE OR REPLACE TEMPORARY TABLE PDB.PUBLIC.customers_temp (
        id int,
        first_name string,
        last_name string,
        email string,
        gender string,
        job string,
        phone string
);

INSERT INTO PDB.PUBLIC.customers_temp
SELECT * FROM PDB.PUBLIC.customers_temp;




