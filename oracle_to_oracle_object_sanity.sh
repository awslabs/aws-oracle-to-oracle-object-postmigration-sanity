#!\bin\bash
########################################################################################################
#Author				Date			Version
#Lokesh Gurram		21-Aug-2022		1.0



#Description:
###############
#Option:1
  #Primary use of this script is to dump the Source and Target Metadata into one STG\TEMP table and Run the Sanity.
  #Detailed steps are mentioned below.
  #Step:1-Create STG\TMP table in Target DB.
  #Step:2-Spool the Source DB metadata into CSV file
  #Step:3-Insert the Source DB spooled data into table created in step:1 using SQL Loader.
  #Step:4-Insert the Target DB Metadata into table created in step:1.
  #Step:5-Generate the sanity report by comparing Source and Target DB metadata in HTML format.
#Option:2
  #Using the DB Link to generate the Sanity Report.
########################################################################################################

#-------------------------------------------------------------------
#Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
#SPDX-License-Identifier: MIT-0
#-------------------------------------------------------------------

if [ $# == 0 ]; then 
	echo "Enter input parameter for SOURCEing variables"
	echo "Example: sh oracle_to_oracle_object_sanity.sh env.par"
	exit;
fi;


echo "Enter the mode of execution. Example: db_link or sql_ldr "
echo " "
read -sp 'Mode of execution: ' exec_mode
echo " "

echo "Execution mode entered is: $exec_mode "

if [ $exec_mode = "db_link" -o $exec_mode = "sql_ldr" ]; then
  :
else
  echo "Invalid execution mode, hence exiting.."
  exit;
fi;

#source $1


#echo $ORACLE_BASE
#echo $ORACLE_HOME
#echo $PATH
#echo $LD_LIBRARY_PATH
#echo $CLASSPATH
#echo $SOURCE_CONNSTR
#echo $TARGET_CONNSTR
#echo $FILE_PATH

if [ $exec_mode = "sql_ldr" ]; then

read -sp 'Enter Source DB Password: ' source_db_pwd
echo " "
read -sp 'Enter Target DB Password: ' target_db_pwd
echo " "

source $1

#STEP:1
#######

#Creating t_object_sanity table in Target Database which is going to store the metadata of Source and Target DBs.
sqlout=`sqlplus -s $TARGET_CONNSTR << +eod+
WHENEVER SQLERROR NONE SQL.SQLCODE
alter session set nls_date_format='DD-MON-YYYY HH24:MI:SS';
@$FILE_PATH/create_table.sql "$LOG_PATH/spool_create_table_target_$dt.log"
exit;
+eod+`

if [ $? -gt 0 ] ; then 
	echo "WARN:Please check, error creating table at Target side.If table already exists ignore"
else 
	echo "1.Table created successfully at Target DB.Verify the logs: $LOG_PATH/create_table_target_log_$dt.log and $LOG_PATH/spool_create_table_target_$dt.log"
	echo " "
fi;
echo $sqlout > "$LOG_PATH/create_table_target_log_$dt.log"


#if [ $l_src_cnt -gt 0  -o $l_tar_cnt -gt 0 ] ; then
if [ -z $INCLUDE_SCHEMAS ] ; then
    echo "-----------------------------------------------------------------------------------"	
	echo "INCLUDE_SCHEMAS variable is set in var.par file and entries are must."
	echo "INCLUDE_SCHEMAS variable identified as empty.Hence exiting...."
	echo "-----------------------------------------------------------------------------------"
	exit;
fi;

#STEP:2
#######

#Spool the Metadata of Source Database into CSV file.
sqlout=`sqlplus -s $SOURCE_CONNSTR << +eod+
@$SPOOL_METADATA $DATA_FILE "$INCLUDE_SCHEMAS"
exit;
+eod+`

if [ $? -gt 0 ] ; then 
	echo "CRITICAL:Please check, Error spooling metadata from Source Database "	
	exit;
else 
	echo "2.Metadata Spooling is successfully done at Source DB.Verify the Logs: $LOG_PATH/source_dump_objects_log_$dt.log"	
	echo " "
fi;

echo $sqlout > "$LOG_PATH/source_dump_objects_log_$dt.log"

#STEP:3
#######

#Dump the spooled data generated at Source side into Target DB.
sqlldr=`sqlldr $TARGET_CONNSTR control=$CONTROL_FILE data=$DATA_FILE log="$LOG_PATH/sqlloader_target_db_log_$dt.log"`
if [ $? -gt 0 ] ; then 
	echo "CRITICAL:Please check, error Loading data into Target Database using SQL LOADER "	
	exit;
else 
	echo "3.Source DB spooled metadata is successfully imported into Target DB using SQL Loader.Verify the logs: $LOG_PATH/source_dump_objects_log_$dt.log and $LOG_PATH/sqlloader_target_db_log_$dt.log"		
	echo " "	
fi;
echo $sqlldr > "$LOG_PATH/sql_loader_dest_db_log_$dt.log"

#STEP:4
#######

#Insert the Metadata into STG/TMP table that was created above.
sqlout=`sqlplus -s $TARGET_CONNSTR << +eod+
@$FILE_PATH/dump_objects_stg_table.sql 'TARGET' "$INCLUDE_SCHEMAS"
exit;
+eod+`
if [ $? -gt 0 ] ; then 
	echo "CRITICAL:Please check, error dumping the object data into T_OBJECT_SANITY table at Target side "
	exit;
else 
	echo "4.Target DB metadata is successfully inserted into Target DB STG/TMP table.Verify the logs: $LOG_PATH/target_dump_objects_log_$dt.log"		
	echo " "	
fi;
echo $sqlout > "$LOG_PATH/target_dump_objects_log_$dt.log"


#STEP:5
########

#Generate the sanity report by comparing Source and Target DB metadata.
sqlout=`sqlplus -s $TARGET_CONNSTR << +eod+
--Run the sanity report
@$FILE_PATH/sanity_report.sql "$SANITY_REPORT_FILE"
exit;
+eod+`
if [ $? -gt 0 ] ; then 
	echo "CRITICAL:Please check, error Generating the sanity report."
	exit;
else 
	echo "5.Sanity Report is successfully generated at: $SANITY_REPORT_FILE"		
	echo " "	
fi;
echo $sqlout > "$LOG_PATH/sanity_report_log_$dt.log"

elif [ $exec_mode = "db_link" ]; then	

read -sp 'Enter Target DB Password: ' target_db_pwd
echo " "

#read -sp 'Enter DB Link Name: ' DB_LINK_NAME
#echo " "

source $1


#Generate the sanity report by comparing Source and Target DB metadata.

sqlout=`sqlplus -s $TARGET_CONNSTR << +eod+
@$FILE_PATH/sanity_report_dblink.sql "$SANITY_REPORT_FILE" "$DB_LINK_NAME" "$INCLUDE_SCHEMAS"
exit;
+eod+`

if [ $? -gt 0 ] ; then 
	echo "CRITICAL:Please check, error Generating the sanity report."
	exit;
else 
	echo "1.Sanity Report is successfully generated at: $SANITY_REPORT_FILE"		
	echo " "	
fi;
echo $sqlout > "$LOG_PATH/sanity_report_log_$dt.log"	

fi;	



upload_report_to_s3() { 
if "$EXPORT_TO_S3"
then
#Below step will assume role which has  putobject privilege to S3
#Note here profile must be for use who will assume the role
#make sure you have configured profile correctly for aws cli 

#temp_role=$(aws sts assume-role \
#--role-arn arn:aws:iam::"$AWSACCOUNTID":role/"$S3ASSUMEROLENAME" \
#--role-session-name MySessionName \
 #--profile s3_uploadcheck )

#One line command to assume role, query output and set the stage for upload 
 export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s" \
$(aws sts assume-role \
--role-arn arn:aws:iam::$AWSACCOUNTID:role/$S3ASSUMEROLENAME \
--profile s3_uploadcheck \
--role-session-name MySessionName \
--query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
--output text \
--profile $IAMUSERPROFILE ))



#Copy the report to S3

aws s3 cp "$SANITY_REPORT_FILE" s3://"$S3BUCKETNAME"/

if [ "$?" -gt 0 ] ; then 
	echo "CRITICAL:Please check, error copying file to S3."
	exit;
fi;
fi;
}

upload_report_to_s3
