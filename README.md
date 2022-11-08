# Oracle To Oracle Post Migration sanity

-------------------------------------------------------------------------------------------
Helps you to perform the Oracle Object sanity post migration.
-------------------------------------------------------------------------------------------

## Synopsis

`sh oracle_to_oracle_object_sanity.sh 'current_dir_path/env.par'`

## Description

Primary use of this tool is to compare the Source DB Oracle objects against target DB Oracle objects and provide the missing objects list 
in HTML format post migration.

**Why this tool helps**

Most of the Oracle migrations have errors during export, import and walking through all errors is cumbersome.

Few such errors occur due to:

1. Oracle Object Type compilation causes errors if Type has any alterations.

   Example: 
            
            create or replace type "typ_name" as  object
                          (sno number
                          ,name varchar2(10)
                          );
                          /
            
            ALTER TYPE "typ_name" ADD ATTRIBUTE emp_location varchar2(38) CASCADE;
            /
    
    In above example, the "ALTER TYPE" script will not be in export dumps. That causes missing of Type attribue.
            

2. Schema level Export and Import of objects to Target db will minimize the downtime.However there will be lot of errors during expdp/impdp.
   Going through and identifying errors is tedious task. So, this Sanity report helps in finding the missing objects if any.
   
3. When there is no down-time of Source DB, continuous changes on Source DB and importing Source DB changes into Target DB would cause missing objects. Such missing objects can be found using this Tool.

4. At times we disable Triggers,Foreign key constraints at Target DB during data migration process and enable post migration.This tool will capture if any objects missed to enable. 

4. If source DB code has WRAPPED(using DBMS_DDL.WRAP) code and importing the same into Target fails if missing Oracle patch: 20594149.

5. If Target DB is RDS and has any missing patches and schema import into RDS may cause Index creation failures.refer the link: https://support.esri.com/en/technical-article/000011123

This tool helps in finding the missing object list in an automated and agile environment.

**Following are list of objects covered as part of sanity.**

- Data base types, attributes , attributes position, data type and data type length.
- Sequences, start position, last number, min value, max value, status , is_cycle and cache_size.
- Tables, column names, columns Position, Column Data type, Column Data length.
- Constraints , Constraint Name, Constraint attributes, Attribute type, Position and Status.
- Count comparison based on Object type in DBA_OBJECTS.
- Indexes, index name, index column name, index column position, index schema, index status .
- Views
- Synonyms
- Triggers
- Scheduler Jobs
- Queues
- RULEs
- JAVA Objects
- Scheduler Programs
- Table partitions 
- Index Partitions
- Database Links.
- CODE lines count from DBA_SOURCE.

        When we have object type alteration, then the code may get partially deployed using expdp/impdp.Hence sanity of CODE lines is must.
- Invalid Objects: Object Name and count.

        Objects tend to become invalid when we perform schema level migration for minimal downdown.Hence Invalid objects sanity is must.
- Compare the List of Oracle patches in Source and Target.

        If source and target has missing oracle patches, we might get into performance issue or code compatibility issues. Hence patch
        comparision is must.
- Compare the DB Parameters in Source and Target.

        if source and target has incorrect DB parameters, will have performance issues. Hence DB parameters comparision is must.
- SQL Profiles.

        If source has SQL profiles and not in Target will have SQL performance issues. So SQL Profile comparison is must. 


## Scope

This tool is limited to Oracle to Oracle object sanity post migration.This works for below cases Starting from Oracle 12C and above.

1. On premise Oracle to EC2 Oracle and vice versa.
2. On premise Oracle to RDS Oracle and vice versa.
3. EC2 Oracle to RDS Oracle and vice versa.

**Note:**
  Use this script for application schemas rather than for SYS or SYSTEM schema comparsions.

## Installation steps


Following are **pre-requisites** required for executing the sanity script: `sh oracle_to_oracle_object_sanity.sh 'current_dir_path/env.par'`


- SQL Plus     : 
    Is mandatory software to be installed. Refer the link to install https://www.oracle.com/database/technologies/instant-client.html

- SQL Loader   : 
    Is mandatory only if you choose the exection mode as SQL_LDR. Refer the link to install https://www.oracle.com/database/technologies/instant-client.html

    **Permissions**
    - Download the git files and provide the `chmod 755` permissions for all those files.
    - Ensure you have connectivity to Source DB and Target DB from your workspace if execution mode choosen is: ``sql_ldr``
    - Ensure you have connectivity to Only Target DB from your workspace if execution mode choosen is: ``db_link``


## Options

**Supported Operating Systems:**

    1. Windows with git bash cmd installed.
    2. Linux / Unix
    3. Macos.




**Environment variables settings**



```
**Identify the PATH variables and set it appropriatly from your workspace or ec2.**

export ORACLE_BASE="/home/oracle/"
export ORACLE_HOME="/home/oracle/19c"
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

```


```
**This is setting of Source DB and Target DB Connection strings**.
**Enter the username and TNS_STRING.Keep the "$source_db_pwd and $target_db_pwd as same,as these are variables.**
export SOURCE_CONNSTR="username/`$source_db_pwd`@TNS_STRING"
export TARGET_CONNSTR="username/`$target_db_pwd`@TNS_STRING"

or 

**Enter the username and HOST,PORT and SID .Keep the "$source_db_pwd and $target_db_pwd as same,as these are variables.**
export SOURCE_CONNSTR="username/`$source_db_pwd`@HOST:PORT/SID"
export TARGET_CONNSTR="username/`$target_db_pwd`@HOST:PORT/SID"
```



```
**Download the assets from GIT and you will find the sql path as FILE_PATH and log path as LOG_PATH.**
export FILE_PATH="/home/ec2-user/oracle_to_oralce_codesanity/sql"
export LOG_PATH="/home/ec2-user/oracle_to_oralce_codesanity/log"

**This is date setting and appended as suffix for log and sanity files.**
export dt=`date +"%d-%m-%Y-%H.%M.%S"`

**After downing the assets from GIT, setup the sanity file name with suffix as date.**
export SANITY_REPORT_FILE="/home/ec2-user/oracle_to_oralce_codesanity/sanity_report_$dt.html"

**After downing the assets from GIT, mention the control file name.**
export CONTROL_FILE="/home/ec2-user/oracle_to_oralce_codesanity/sqlloader.ctrl"

**After downing the assets from GIT, mention the csv file name suffix with date.**
export DATA_FILE="/home/ec2-user/oracle_to_oralce_codesanity/spool_metadata_$dt.csv"

**After downing the assets from GIT, mention the "spool_metadata_into_csv.sql" in sql directory.**
export SPOOL_METADATA="/home/ec2-user/oracle_to_oralce_codesanity/`sql`/spool_metadata_into_csv.sql"

**Mention the DB link name you created**
export DB_LINK_NAME="db_link_name"

```


```
**Set below variable as "true" as static value.**
export EXPORT_TO_S3=true
**Set S3 bucket name.**
export S3BUCKETNAME="lokesh-gcc-bkt"
**Set 12 digit AWS Account ID **
export AWSACCOUNTID="XXXXXXXXXXXXX"
**Role with necessary privilege to write file to your S3 bucket. Make sure you have added trust relationships with below policy
{
    “Version”: “2012-10-17",
    “Statement”: [
        {
            “Effect”: “Allow”,
            “Principal”: {
                “AWS”: “arn:aws:iam::$AWSACCOUNTID:user/Username”
            },
            “Action”: “sts:AssumeRole”
        }
    ]
}**
export S3ASSUMEROLENAME="s3accessrole"
**Set the named profile who will assume this role.**
export IAMUSERPROFILE="s3_uploadcheck"
```

```
**Enter the list of schemas to be included for sanity.**
**Example: "'SCHEMA1','SCHEMA2','SCHEMA3'"**
export INCLUDE_SCHEMAS="'APP_SCHEMA1','APP2_SCHEMA','APP3_SCHEMA'"
```




**Execution Modes**

    The mentioned tool can be run in two different execution modes.

    sql_ldr:

        This is Oracle SQL Loader utility concept. Following is the execution flow when you use the sql_ldr option.

        1. Export the Metadata from Source DB and store it in workspace in CSV format
        2. Import the CSV metadata(from Step-1) into Target DB using SQL Loader feature.
        3. Perform the Source DB and Target DB metadata comparison.
        4. Export the comparison Sanity report into workspace using sqlplus HTML report.

    db_link:

        This is Oracle DB Link concept. Following is the execution pattern when you use the db Link option.

        1. Assume, DB Link has been created in Target DB referring Source DB connection string.
        2. Ensure DB Link user has access to Source DB meta data.either SELECT_CATALOG_ROLE or DBA privilege.
        3. Run the shell script: ``oracle_to_oracle_object_sanity.sh`` with db_link option.


## Examples


1. Modify the env.par file with appropriate path variables.
2. Run the shell script and following are the details asked and output.

    Using `sql_ldr` execution method:


        
        
        $ sh oracle_to_oracle_object_sanity.sh "C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\env.par"
        Enter the mode of execution. Example: db_link or sql_ldr

        Mode of execution:
        Execution mode entered is: sql_ldr
        Enter Source DB Password:
        Enter Target DB Password:
        1.Table created successfully at Target DB.Verify the logs: C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\log/     create_table_target_log_25-10-2022-11.06.50.log and C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\log/spool_create_table_target_25-10-2022-11.06.50.log

        2.Metadata Spooling is successfully done at Source DB.Verify the Logs: C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\log/source_dump_objects_log_25-10-2022-11.06.50.log

        3.Source DB spooled data is successfully imported into Target DB using SQL Loader.Verify the logs: C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\log/source_dump_objects_log_25-10-2022-11.06.50.log and C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\log/sqlloader_target_db_log_25-10-2022-11.06.50.log

        4.Metadata is successfully inserted into STG/TMP table.Verify the logs: C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\log/target_dump_objects_log_25-10-2022-11.06.50.log

        5.Sanity Report is successfully generated at: C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\sanity_report_25-10-2022-11.06.50.html

        upload: .\sanity_report_24-10-2022-11.21.00.html to s3://mys3-lokesh/output/sanity_report_24-10-2022-11.21.00.html
        Sanity Report C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\sanity_report_24-10-2022-11.21.00.html is successfully uploaded to S3 bucket:s3:///output/



    Using `db_link` execution method:


    ```
        $ sh oracle_to_oracle_object_sanity.sh "C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\env.par"
        Enter the mode of execution. Example: db_link or sql_ldr

        Mode of execution:
        Execution mode entered is: db_link
        Enter Target DB Password:
        1.Sanity Report is successfully generated at: C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\sanity_report_25-10-2022-11.26.36.html
        upload: .\sanity_report_24-10-2022-11.21.00.html to s3://mys3-lokesh/output/sanity_report_24-10-2022-11.21.00.html
        Sanity Report C:\AZ_WorkSpace\PRJ\git\oracle_to_oralce_codesanity\sanity_report_24-10-2022-11.21.00.html is successfully uploaded to S3     bucket:s3:///output/
    ```


  
3. Sanity file is stored under "oracle_to_oracle_object_sanity" home path and suffixed with date and time stamp.
4. Log files are stored under "oracle_to_oracle_object_sanity/log" log path and suffixed with data and time stamp.

## Roadmap 

We have implemented this based on our past experience and tried to cover all the validation checks.Please use the tool and if you see anything need to be added we are open for suggestions.

## Support
Please write an email to `lgurraml@amazon.com` and `suhasraj@amazon.com` for any queries.

## License
Open source project and Open for finetuning.
