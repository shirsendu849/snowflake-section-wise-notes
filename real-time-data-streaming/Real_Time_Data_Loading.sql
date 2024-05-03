// Creating external stage (create your own bucket)
CREATE OR REPLACE STAGE SCD_DEMO.SCD2.customer_ext_stage
    url='s3://real-time-data-process/stream_data'
    credentials=(AWS_KEY_ID="XYZaccessId" AWS_SECRET_KEY="abcSecretId");
   

CREATE OR REPLACE FILE FORMAT SCD_DEMO.SCD2.CSV
TYPE = CSV,
FIELD_DELIMITER = ","
SKIP_HEADER = 1;

SHOW STAGES;

LIST @customer_ext_stage;


CREATE OR REPLACE PIPE customer_s3_pipe
  auto_ingest = true
  AS
  COPY INTO customer_raw
  FROM @customer_ext_stage
  FILE_FORMAT = CSV
  ;

show pipes;

select SYSTEM$PIPE_STATUS('customer_s3_pipe');

SELECT count(*) FROM customer_raw;

TRUNCATE  customer_raw;