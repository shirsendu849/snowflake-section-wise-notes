// Creating stage for json
CREATE OR REPLACE STAGE MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    url='s3://bucketsnowflake-jsondemo';

DESC STAGE MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE;

LIST @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE; 


// Creating file format for json
CREATE OR REPLACE file format MANAGE_DB.EXTERNAL_STAGES.JSONFORMAT
    TYPE='JSON';
    
DESC file format MANAGE_DB.EXTERNAL_STAGES.JSONFORMAT;

CREATE DATABASE our_first_database;

CREATE OR REPLACE TABLE our_first_database.public.json_raw (
    raw_file variant
);

// Loading json data using COPY command 
COPY INTO our_first_database.public.json_raw
    FROM @MANAGE_DB.EXTERNAL_STAGES.JSONSTAGE
    FILE_FORMAT=(FORMAT_NAME='MANAGE_DB.EXTERNAL_STAGES.JSONFORMAT')
    FILES=('HR_data.json');

SELECT * FROM our_first_database.public.json_raw;

// Extracting data from json 
SELECT raw_file:city, raw_file:first_name FROM our_first_database.public.json_raw;
SELECT $1:city::string, $1:first_name::string FROM our_first_database.public.json_raw;

SELECT raw_file:id::int as Id,
raw_file:first_name::string as FirstName,
raw_file:last_name::string as LastName,
raw_file:gender::string as Gender,
raw_file:job.salary::int as Salary
FROM our_first_database.public.json_raw;

SELECT coalesce(raw_file:prev_company[0]::string, 'NA') as prev_comp
FROM our_first_database.public.json_raw;

// Using flatten() method
SELECT 
    raw_file:first_name::string first_name,
    f.value language
FROM our_first_database.public.json_raw, table(flatten(raw_file:spoken_languages)) f;










