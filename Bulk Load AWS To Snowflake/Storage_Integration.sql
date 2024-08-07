
-- creating storage integration
CREATE OR REPLACE STORAGE INTEGRATION S3_INT
TYPE = EXTERNAL_STAGE
STORAGE_PROVIDER = S3
ENABLED = TRUE
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::009160048722:role/RETAILROLE'
STORAGE_ALLOWED_LOCATIONS = ('s3://likdataloadsnowflake');


DESC INTEGRATION S3_INT;


--creating file format
CREATE OR REPLACE FILE FORMAT retail_csv
TYPE = 'CSV'
COMPRESSION = 'none'
FIELD_DELIMITER = ','
FIELD_OPTIONALLY_ENCLOSED_BY = 'none'
SKIP_HEADER = 1

--Creating stage
CREATE OR REPLACE STAGE RETAIL
URL ='s3://likdataloadsnowflake'
file_format = retail_csv
storage_integration = s3_int;


LIST @RETAIL;

SHOW STAGES
