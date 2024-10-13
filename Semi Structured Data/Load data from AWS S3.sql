CREATE OR REPLACE STORAGE INTEGRATION snowpipe_integration
TYPE = external_stage
STORAGE_PROVIDER = s3
STORAGE_AWS_ROLE_ARN = 'arn:aws:iam::954976302695:role/LikinRole'
ENABLED = true
STORAGE_ALLOWED_LOCATIONS = ('*');


DESC INTEGRATION snowpipe_integration;
-- Storage_AWS_IAM_User_ARN : arn:aws:iam::084375543294:user/tmor0000-s
-- External ID : YD63693_SFCRole=2_j40tltSiOJUbHiBuYXC2AuLawWM=

--CREATING FILE FORMAT
create or replace file format iotv2_csv
type='csv'
compression='none'
field_delimiter=','
field_optionally_enclosed_by='\042' -- double quotes ASCII value
skip_header=1;


DROP STAGE iot_data_stage_EU
CREATE OR REPLACE STAGE iot_data_stage
STORAGE_INTEGRATION = snowpipe_integration
URL =  's3://lik-iot'     --  (Name of your bucket and folder)
FILE_FORMAT = (format_name = iotv2_csv);

list @iot_data_stage;

show stages;

CREATE OR REPLACE PIPE IOT_EU_SNOWPIPE 
AUTO_INGEST = TRUE
AS COPY INTO JSON_PRACTICE.IOT.IOTV2_EUEXPERIENCE00320055      --  (table name that you created in snowflake)
FROM '@iot_data_stage/IOTV2-EU/'   -- (name of the stage)
FILE_FORMAT = iotv2_csv;  



CREATE OR REPLACE PIPE IOT_JP_SNOWPIPE 
AUTO_INGEST = TRUE
AS COPY INTO JSON_PRACTICE.IOT.LOAD_IOTV2_JPEXPERIENCE00320055    --  (table name that you created in snowflake)
FROM '@iot_data_stage/IOTV2-JP/'   -- (name of the stage)
FILE_FORMAT = iotv2_csv;   



CREATE OR REPLACE PIPE IOT_NZ_SNOWPIPE 
AUTO_INGEST = TRUE
AS COPY INTO JSON_PRACTICE.IOT.LOAD_IOTV2_NZEXPERIENCE002F0052   --  (table name that you created in snowflake)
FROM '@iot_data_stage/IOTV2-NZ/'   -- (name of the stage)
FILE_FORMAT = iotv2_csv;   



ALTER PIPE IOT_EU_SNOWPIPE REFRESH;
ALTER PIPE IOT_JP_SNOWPIPE REFRESH;
ALTER PIPE IOT_NZ_SNOWPIPE REFRESH;

SELECT COUNT(*) FROM JSON_PRACTICE.IOT.IOTV2_EUEXPERIENCE00320055;
SELECT COUNT(*) FROM JSON_PRACTICE.IOT.LOAD_IOTV2_JPEXPERIENCE00320055;
SELECT COUNT(*) FROM JSON_PRACTICE.IOT.LOAD_IOTV2_NZEXPERIENCE002F0052;
