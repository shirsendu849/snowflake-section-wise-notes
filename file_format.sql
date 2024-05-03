// Creating new schema 
CREATE OR REPLACE SCHEMA MANAGE_DB.file_formats;

// Creating file format object
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.my_file_format;

// Description about file format
DESC FILE FORMAT MANAGE_DB.FILE_FORMATS.my_file_format; 

// Alter file format properties
ALTER FILE FORMAT MANAGE_DB.FILE_FORMATS.my_file_format
SET SKIP_HEADER = 1;

// Altering file format type is not possible
ALTER FILE FORMAT MANAGE_DB.FILE_FORMATS.my_file_format
SET TYPE = 'CSV';

// We can replace existing file format to another
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.my_file_format
    TYPE = 'JSON'
    TIME_FORMAT = AUTO;

// Creating csv file format object
CREATE OR REPLACE FILE FORMAT MANAGE_DB.FILE_FORMATS.csv_file_format
    TYPE = 'CSV',
    FIELD_DELIMITER = ',',
    SKIP_HEADER = 1;

DESC FILE FORMAT MANAGE_DB.FILE_FORMATS.csv_file_format;

// Copying data using COPY command parsing file format obejct
TRUNCATE MANAGE_DB.PUBLIC.ORDERS_trans;

COPY INTO MANAGE_DB.PUBLIC.ORDERS_trans
FROM (SELECT s.$1, s.$2 FROM @MANAGE_DB.EXTERNAL_STAGES.aws_public_stage s)
file_format = (FORMAT_NAME = 'MANAGE_DB.FILE_FORMATS.csv_file_format')
files = ('OrderDetails.csv');

