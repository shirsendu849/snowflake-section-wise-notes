// Creating new schema
CREATE OR REPLACE SCHEMA OUR_FIRST_DATABASE.UNDROP_SCHEMA;

// Setting up table
CREATE OR REPLACE TABLE OUR_FIRST_DATABASE.UNDROP_SCHEMA.TEST (
        id int,
        first_name string,
        last_name string,
        email string,
        gender string,
        job string,
        phone string
);

// Creating file format
CREATE OR REPLACE FILE FORMAT OUR_FIRST_DATABASE.UNDROP_SCHEMA.csv_file 
    type='csv'
    field_delimiter=','
    skip_header=1;

// Creating new stage where storage location is public
CREATE OR REPLACE STAGE OUR_FIRST_DATABASE.UNDROP_SCHEMA.undrop_stage 
    URL='s3://data-snowflake-fundamentals/time-travel/'
    FILE_FORMAT=MANAGE_DB.FILE_FORMATS.csv_file;

LIST @OUR_FIRST_DATABASE.UNDROP_SCHEMA.undrop_stage;

// Loading data into table
COPY INTO OUR_FIRST_DATABASE.UNDROP_SCHEMA.TEST 
FROM @OUR_FIRST_DATABASE.UNDROP_SCHEMA.undrop_stage
    FILES=('customers.csv');

SELECT * FROM OUR_FIRST_DATABASE.UNDROP_SCHEMA.TEST;

// Undropping DB instances
DROP DATABASE OUR_FIRST_DATABASE;
UNDROP DATABASE OUR_FIRST_DATABASE;

DROP SCHEMA OUR_FIRST_DATABASE.UNDROP_SCHEMA;
UNDROP SCHEMA OUR_FIRST_DATABASE.UNDROP_SCHEMA;

DROP TABLE OUR_FIRST_DATABASE.UNDROP_SCHEMA.TEST;
UNDROP TABLE OUR_FIRST_DATABASE.UNDROP_SCHEMA.TEST;


