/*
Author 				DATE					Version
Lokesh Gurram		21-Aug-2022				1.0


Discreption:
-----------
This SQL is used to for generating the sanity. This does the differences of Source minus and Target and vice versa.
This SQL is run on TARGET_CONNSTR.

*/

-------------------------------------------------------------------
--Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
--SPDX-License-Identifier: MIT-0
-------------------------------------------------------------------



set markup HTML ON HEAD "<style type='text/css'> body {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} p {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} table,tr,td {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#f7f7e7; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;} th {font:bold 10pt Arial,Helvetica,sans-serif; color:rgb(0,0,150); background:#cccc99; align='left'; padding:0px 0px 0px 0px;} h1 {font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;-} h2 {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; margin-bottom:0pt;} a {font:9pt Arial,Helvetica,sans-serif; color:#663300; background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;}</style><title>SQL*Plus Report</title>" BODY "" TABLE "border='1' width='90%' align='center' summary='Script output'" SPOOL ON ENTMAP ON PREFORMAT OFF
set markup CSV OFF DELIMITER , QUOTE ON
set trimout on
set verify off
set termout off
--set feed off
set pagesize 50000
set linesize 350
column OBJECT_TYPE Entmap Off
column SEQUENCES entmap off
column TABLE_COLUMN entmap off
column CONSTRAINTS entmap off
column OBJECT_COUNTS entmap off
column INDEXES entmap off
column CODE_LINE_COUNT entmap off
column INVALID_OBJECT entmap off
column VIEWS entmap off
column SYNONYMS entmap off
column TRIGGERS entmap off
column SCHEDULER_JOBS entmap off
column QUEUES entmap off
column RULES entmap off 
column JAVA_CLASS_DATA entmap off
column SCHD_PROGRAMS entmap off
column TAB_PARTITIONS entmap off
column INDEX_PARTITIONS entmap off
column PATCH_DETAILS entmap off
column DB_PARAMETERS entmap off
column DB_LINK entmap off
column SQL_PROFILES entmap off
column ROLES entmap off
column USERS entmap off
column ROLE_PRIVS entmap off
column SYS_PRIVS entmap off
column TABLE_STATISTICS entmap off
column LOB_OBJECTS entmap off
column USER_PROFILES entmap off

spool &&1

--compare Oracle OBJECT_TYPE and its attributes:

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Type: Source Vs Target </Center>'
            ||'<Center><H2>  Types exists in SOURCE and NOT in TARGET'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       OBJECT_TYPE
From dual;

select f_owner owner,f_object_name Type_name,f_attribute_name attr_name,f_attribute_type attr_type,f_position_id position_id
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='OBJECT_TYPE'
minus
select f_owner,f_object_name,f_attribute_name,f_attribute_type,f_position_id
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='OBJECT_TYPE';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Type: Target Vs Source </Center>'
            ||'<Center><H2>  Types exists in TARGET and NOT in SOURCE'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       OBJECT_TYPE
From dual;

select f_owner owner,f_object_name Type_name,f_attribute_name attr_name,f_attribute_type attr_type,f_position_id position_id
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='OBJECT_TYPE'
minus	
select f_owner,f_object_name,f_attribute_name,f_attribute_type,f_position_id
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='OBJECT_TYPE';



Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Sequences: Source Vs Target </Center>'
            ||'<Center><H2>  Sequences exists in SOURCE and NOT in TARGET'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SEQUENCES
From dual;

--compare Oracle SEQUENCES:
select f_owner owner,f_object_name Seq_name,f_min_value min_value,f_max_value max_value,f_increment_by increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='SEQUENCES'
minus
select f_owner,f_object_name,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status 
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='SEQUENCES';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Sequences: Target Vs Source </Center>'
            ||'<Center><H2>  Sequences exists in TARGET and NOT in SOURCE'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SEQUENCES
From dual;

select f_owner owner,f_object_name Seq_name,f_min_value min_value,f_max_value max_value,f_increment_by increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='SEQUENCES'
minus
select f_owner,f_object_name,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status 
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='SEQUENCES';



Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Tables and Columns: Source Vs Target </Center>'
            ||'<Center><H2>  Table Columns exists in SOURCE and NOT in TARGET'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TABLE_COLUMN
From dual;

--compare Oracle TABLE_COLUMN:
select f_owner owner,f_object_name table_name,f_attribute_name col_name,f_attribute_type column_type,f_position_id position
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='TABLE_COLUMN'
minus
select f_owner,f_object_name,f_attribute_name,f_attribute_type,f_position_id
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='TABLE_COLUMN';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Tables and Columns: Target Vs Source </Center>'
            ||'<Center><H2>  Table Columns exists in TARGET and NOT in SOURCE'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TABLE_COLUMN
From dual;

select f_owner owner,f_object_name table_name,f_attribute_name col_name,f_attribute_type column_type,f_position_id position
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='TABLE_COLUMN'
minus
select f_owner,f_object_name,f_attribute_name,f_attribute_type,f_position_id
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='TABLE_COLUMN';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Constraints : Source Vs Target </Center>'
            ||'<Center><H2>  Constraints exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       CONSTRAINTS
From dual;

--compare Oracle CONSTRAINTS:
select f_owner,f_object_name table_name,f_sub_object_name constraint_name,f_attribute_name,f_attribute_type constraint_type,f_position_id,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='CONSTRAINTS'
minus
select f_owner,f_object_name,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='CONSTRAINTS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Constraints : Target Vs Source </Center>'
            ||'<Center><H2>  Constraints exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       CONSTRAINTS
From dual;


select f_owner,f_object_name table_name,f_sub_object_name constraint_name,f_attribute_name,f_attribute_type constraint_type,f_position_id,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='CONSTRAINTS'
minus
select f_owner,f_object_name,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='CONSTRAINTS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Object Counts : Source Vs Target </Center>'
            ||'<Center><H2>  Objects comparision exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       OBJECT_COUNTS
From dual;

--compare Oracle OBJECT_COUNTS:
select f_owner,f_attribute_type Object_type,f_count
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='OBJECT_COUNTS'
minus
select f_owner,f_attribute_type Object_type,f_count
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='OBJECT_COUNTS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Object Counts : Target Vs Source </Center>'
            ||'<Center><H2>  Objects comparision exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       OBJECT_COUNTS
From dual;

select f_owner,f_attribute_type Object_type,f_count
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='OBJECT_COUNTS'
minus
select f_owner,f_attribute_type Object_type,f_count
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='OBJECT_COUNTS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Indexes : Source Vs Target </Center>'
            ||'<Center><H2>  Indexes exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INDEXES
From dual;

--compare Oracle INDEXES:
select f_owner tab_owner,f_object_name tab_name,f_sub_obj_owner index_owner,f_sub_object_name index_name,f_attribute_name,f_attribute_type,f_position_id,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='INDEXES'
minus
select f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='INDEXES';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Indexes : Target Vs Source </Center>'
            ||'<Center><H2>  Indexes exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INDEXES
From dual;

select f_owner tab_owner,f_object_name tab_name,f_sub_obj_owner index_owner,f_sub_object_name index_name,f_attribute_name,f_attribute_type,f_position_id,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='INDEXES'
minus
select f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='INDEXES';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Views : Source Vs Target </Center>'
            ||'<Center><H2>  Views exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       VIEWS
From dual;

select f_owner,f_object_name view_name,f_count sql_query_length,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='VIEWS'
minus
select f_owner,f_object_name view_name,f_count sql_query_length,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='VIEWS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Views : Target Vs Source </Center>'
            ||'<Center><H2>  Views exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       VIEWS
From dual;

select f_owner,f_object_name view_name,f_count sql_query_length,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='VIEWS'
minus
select f_owner,f_object_name view_name,f_count sql_query_length,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='VIEWS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SYNONYMS : Source Vs Target </Center>'
            ||'<Center><H2>  SYNONYMS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SYNONYMS
From dual;

select f_owner,f_object_name syn_name,f_sub_obj_owner tab_owner,f_sub_object_name tab_name,f_attribute_name db_link
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='SYNONYMS'
minus
select f_owner,f_object_name syn_name,f_sub_obj_owner tab_owner,f_sub_object_name tab_name,f_attribute_name db_link
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='SYNONYMS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SYNONYMS : Target Vs Source </Center>'
            ||'<Center><H2>  SYNONYMS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SYNONYMS
From dual;

select f_owner,f_object_name syn_name,f_sub_obj_owner tab_owner,f_sub_object_name tab_name,f_attribute_name db_link
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='SYNONYMS'
minus
select f_owner,f_object_name syn_name,f_sub_obj_owner tab_owner,f_sub_object_name tab_name,f_attribute_name db_link
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='SYNONYMS';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle TRIGGERS : Source Vs Target </Center>'
            ||'<Center><H2>  TRIGGERS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TRIGGERS
From dual;

select f_owner,f_object_name trigger_name,f_sub_obj_owner tab_owner,f_sub_object_name tab_name,f_attribute_name triggering_event,f_attribute_type trigger_type,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='TRIGGERS'
minus
select f_owner,f_object_name trigger_name,f_sub_obj_owner tab_owner,f_sub_object_name tab_name,f_attribute_name triggering_event,f_attribute_type trigger_type,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='TRIGGERS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle TRIGGERS : Target Vs Source </Center>'
            ||'<Center><H2>  TRIGGERS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TRIGGERS
From dual;

select f_owner,f_object_name trigger_name,f_sub_obj_owner tab_owner,f_sub_object_name tab_name,f_attribute_name triggering_event,f_attribute_type trigger_type,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='TRIGGERS'
minus
select f_owner,f_object_name trigger_name,f_sub_obj_owner tab_owner,f_sub_object_name tab_name,f_attribute_name triggering_event,f_attribute_type trigger_type,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='TRIGGERS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SCHEDULER_JOBS : Source Vs Target </Center>'
            ||'<Center><H2>  SCHEDULER_JOBS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SCHEDULER_JOBS
From dual;


select f_owner,f_object_name job_name,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='SCHEDULER_JOBS'
minus
select f_owner,f_object_name job_name,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='SCHEDULER_JOBS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SCHEDULER_JOBS : Target Vs Source </Center>'
            ||'<Center><H2>  SCHEDULER_JOBS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SCHEDULER_JOBS
From dual;

select f_owner,f_object_name job_name,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='SCHEDULER_JOBS'
minus
select f_owner,f_object_name job_name,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='SCHEDULER_JOBS';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle QUEUES : Source Vs Target </Center>'
            ||'<Center><H2>  QUEUES exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       QUEUES
From dual;

select f_owner,f_object_name queue_name,f_sub_object_name queue_table,f_attribute_type queue_type,f_status as "ENQ:DEQ STATUS"
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='QUEUES'
minus
select f_owner,f_object_name queue_name,f_sub_object_name queue_table,f_attribute_type queue_type,f_status as "ENQ:DEQ STATUS"
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='QUEUES';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle QUEUES : Target Vs Source </Center>'
            ||'<Center><H2>  QUEUES exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       QUEUES
From dual;

select f_owner,f_object_name queue_name,f_sub_object_name queue_table,f_attribute_type queue_type,f_status as "ENQ:DEQ STATUS"
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='QUEUES'
minus
select f_owner,f_object_name queue_name,f_sub_object_name queue_table,f_attribute_type queue_type,f_status as "ENQ:DEQ STATUS"
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='QUEUES';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle RULES : Source Vs Target </Center>'
            ||'<Center><H2>  RULES exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       RULES
From dual;

select f_owner,f_object_name rule_name,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='RULES'
minus
select f_owner,f_object_name job_name,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='RULES';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle RULES : Target Vs Source </Center>'
            ||'<Center><H2>  RULES exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       RULES
From dual;

select f_owner,f_object_name rule_name,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='RULES'
minus
select f_owner,f_object_name job_name,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='RULES';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle JAVA_CLASS_DATA : Source Vs Target </Center>'
            ||'<Center><H2>  JAVA_CLASS_DATA exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       JAVA_CLASS_DATA
From dual;

select f_owner,f_object_name java_obj_name,f_attribute_type object_type,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='JAVA_CLASS_DATA'
minus
select f_owner,f_object_name java_obj_name,f_attribute_type object_type,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='JAVA_CLASS_DATA';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle JAVA_CLASS_DATA : Target Vs Source </Center>'
            ||'<Center><H2>  JAVA_CLASS_DATA exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       JAVA_CLASS_DATA
From dual;

select f_owner,f_object_name java_obj_name,f_attribute_type object_type,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='JAVA_CLASS_DATA'
minus
select f_owner,f_object_name java_obj_name,f_attribute_type object_type,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='JAVA_CLASS_DATA';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SCHD_PROGRAMS : Source Vs Target </Center>'
            ||'<Center><H2>  SCHD_PROGRAMS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SCHD_PROGRAMS
From dual;

select f_owner,f_object_name program_name,f_attribute_type program_type,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='SCHD_PROGRAMS'
minus
select f_owner,f_object_name program_name,f_attribute_type program_type,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='SCHD_PROGRAMS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SCHD_PROGRAMS : Target Vs Source </Center>'
            ||'<Center><H2>  SCHD_PROGRAMS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SCHD_PROGRAMS
From dual;

select f_owner,f_object_name program_name,f_attribute_type program_type,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='SCHD_PROGRAMS'
minus
select f_owner,f_object_name program_name,f_attribute_type program_type,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='SCHD_PROGRAMS';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle TAB_PARTITIONS : Source Vs Target </Center>'
            ||'<Center><H2>  TAB_PARTITIONS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TAB_PARTITIONS
From dual;

select f_owner,f_object_name table_name,f_sub_object_name part_name
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='TAB_PARTITIONS'
minus
select f_owner,f_object_name table_name,f_sub_object_name part_name
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='TAB_PARTITIONS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle TAB_PARTITIONS : Target Vs Source </Center>'
            ||'<Center><H2>  TAB_PARTITIONS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TAB_PARTITIONS
From dual;

select f_owner,f_object_name table_name,f_sub_object_name part_name
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='TAB_PARTITIONS'
minus
select f_owner,f_object_name table_name,f_sub_object_name part_name
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='TAB_PARTITIONS';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle INDEX_PARTITIONS : Source Vs Target </Center>'
            ||'<Center><H2>  INDEX_PARTITIONS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INDEX_PARTITIONS
From dual;

select f_owner,f_object_name index_name,f_sub_object_name ind_part_name,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='INDEX_PARTITIONS'
minus
select f_owner,f_object_name index_name,f_sub_object_name ind_part_name,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='INDEX_PARTITIONS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle INDEX_PARTITIONS : Target Vs Source </Center>'
            ||'<Center><H2>  INDEX_PARTITIONS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INDEX_PARTITIONS
From dual;

select f_owner,f_object_name index_name,f_sub_object_name ind_part_name,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='INDEX_PARTITIONS'
minus
select f_owner,f_object_name index_name,f_sub_object_name ind_part_name,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='INDEX_PARTITIONS';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle CODE lines(proc,pkgs and Functions) : Source Vs Target </Center>'
            ||'<Center><H2>  Compare Number of Lines of each CODE object in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       CODE_LINE_COUNT
From dual;

--compare Oracle CODE_LINE_COUNT:
select f_owner,f_object_name,f_attribute_type obj_type,f_count line_count
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='CODE_LINE_COUNT'
minus
select f_owner,f_object_name,f_attribute_type obj_type,f_count
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='CODE_LINE_COUNT';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle dba_source(proc,pkgs and Functions) : Target Vs Source </Center>'
            ||'<Center><H2>  Compare Number of Lines of each CODE object in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       CODE_LINE_COUNT
From dual;

select f_owner,f_object_name,f_attribute_type obj_type,f_count line_count
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='CODE_LINE_COUNT'
minus
select f_owner,f_object_name,f_attribute_type obj_type,f_count
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='CODE_LINE_COUNT';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Invalid Objects : Source Vs Target </Center>'
            ||'<Center><H2>  Compare INVALID Objects in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INVALID_OBJECT
From dual;

--compare Oracle INVALID_OBJECT:
select f_owner,f_object_name,f_sub_object_name,f_attribute_type obj_type,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='INVALID_OBJECT'
minus
select f_owner,f_object_name,f_sub_object_name,f_attribute_type obj_type,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='INVALID_OBJECT';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Invalid Objects : Target Vs Source </Center>'
            ||'<Center><H2>  Compare INVALID Objects in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INVALID_OBJECT
From dual;


select f_owner,f_object_name,f_sub_object_name,f_attribute_type obj_type,f_status
from t_object_sanity 
where f_run_server='TARGET'
and f_catagory_type='INVALID_OBJECT'
minus
select f_owner,f_object_name,f_sub_object_name,f_attribute_type obj_type,f_status
from t_object_sanity 
where f_run_server='SOURCE'
and f_catagory_type='INVALID_OBJECT';
---------

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Patch Details : Source Vs Target </Center>'
            ||'<Center><H2>  Compare Patch Details in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       PATCH_DETAILS
From dual;

select f_object_name patch_id,  f_sub_object_name version, f_status status
from t_object_sanity 
where  f_run_server='SOURCE'
and f_catagory_type='ORA_PATCH'
minus
select f_object_name patch_id,  f_sub_object_name version, f_status status
from t_object_sanity
where  f_run_server='TARGET'
and f_catagory_type='ORA_PATCH';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Patch Details : Target Vs Source </Center>'
            ||'<Center><H2>  Compare Patch Details in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       PATCH_DETAILS
From dual;

select f_object_name patch_id,  f_sub_object_name version, f_status status
from t_object_sanity 
where  f_run_server='TARGET'
and f_catagory_type='ORA_PATCH'
minus
select f_object_name patch_id,  f_sub_object_name version, f_status status
from t_object_sanity
where  f_run_server='SOURCE'
and f_catagory_type='ORA_PATCH';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle DB Parameters : Source Vs Target </Center>'
            ||'<Center><H2>  Compare DB Parameters in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       DB_PARAMETERS
From dual;


select f_owner inst_id,  f_object_name name, f_sub_obj_owner value,f_sub_object_name DISPLAY_VALUE, f_attribute_name DEFAULT_VALUE
from t_object_sanity 
where  f_run_server='SOURCE'
and f_catagory_type='DB_PARAMS'
minus
select f_owner inst_id,  f_object_name name, f_sub_obj_owner value,f_sub_object_name DISPLAY_VALUE, f_attribute_name DEFAULT_VALUE
from t_object_sanity
where  f_run_server='TARGET'
and f_catagory_type='DB_PARAMS';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle DB Parameters : Target Vs Source </Center>'
            ||'<Center><H2>  Compare DB Parameters in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       DB_PARAMETERS
From dual;

select f_owner inst_id,  f_object_name name, f_attribute_type value,f_sub_object_name DISPLAY_VALUE, f_attribute_name DEFAULT_VALUE
from t_object_sanity 
where  f_run_server='TARGET'
and f_catagory_type='DB_PARAMS'
minus
select f_owner inst_id,  f_object_name name, f_attribute_type value,f_sub_object_name DISPLAY_VALUE, f_attribute_name DEFAULT_VALUE
from t_object_sanity
where  f_run_server='SOURCE'
and f_catagory_type='DB_PARAMS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle DB Links : Source Vs Target </Center>'
            ||'<Center><H2>  Compare DB Links in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       DB_LINK
From dual;


select f_owner owner,  f_object_name db_link, f_sub_obj_owner username,f_text host_details
from t_object_sanity 
where  f_run_server='SOURCE'
and f_catagory_type='DB_LINK'
minus
select f_owner owner,  f_object_name db_link, f_sub_obj_owner username,f_text host_details
from t_object_sanity
where  f_run_server='TARGET'
and f_catagory_type='DB_LINK';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle DB Links : Target Vs Source </Center>'
            ||'<Center><H2>  Compare DB Links in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       DB_LINK
From dual;

select f_owner owner,  f_object_name db_link, f_sub_obj_owner username,f_text host_details
from t_object_sanity 
where  f_run_server='TARGET'
and f_catagory_type='DB_LINK'
minus
select f_owner owner,  f_object_name db_link, f_sub_obj_owner username,f_text host_details
from t_object_sanity
where  f_run_server='SOURCE'
and f_catagory_type='DB_LINK';
-----

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SQL_PROFILES : Source Vs Target </Center>'
            ||'<Center><H2>  Compare SQL_PROFILES in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SQL_PROFILES
From dual;


select f_owner name,  f_text sql_text,f_status status
from t_object_sanity 
where  f_run_server='SOURCE'
and f_catagory_type='SQL_PROFILES'
minus
select f_owner name,  f_text sql_text,f_status status
from t_object_sanity
where  f_run_server='TARGET'
and f_catagory_type='SQL_PROFILES';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SQL_PROFILES : Target Vs Source </Center>'
            ||'<Center><H2>  Compare SQL_PROFILES in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SQL_PROFILES
From dual;

select f_owner name,  f_text sql_text,f_status status
from t_object_sanity 
where  f_run_server='TARGET'
and f_catagory_type='SQL_PROFILES'
minus
select f_owner name,  f_text sql_text,f_status status
from t_object_sanity
where  f_run_server='SOURCE'
and f_catagory_type='SQL_PROFILES';



-------------------------------------

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle ROLES : Source Vs Target </Center>'
            ||'<Center><H2>  Compare ROLES in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       ROLES
From dual;

select f_owner  role,  f_object_name password_required ,f_sub_obj_owner AUTHENTICATION_TYPE,f_sub_object_name common,f_attribute_name oracle_maintained
from t_object_sanity 
where  f_run_server='SOURCE'
and f_catagory_type='ROLES'
minus
select f_owner  role,  f_object_name password_required ,f_sub_obj_owner AUTHENTICATION_TYPE,f_sub_object_name common,f_attribute_name oracle_maintained
from t_object_sanity
where  f_run_server='TARGET'
and f_catagory_type='ROLES';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle ROLES : Target Vs Source </Center>'
            ||'<Center><H2>  Compare ROLES in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       ROLES
From dual;

select f_owner  role,  f_object_name password_required ,f_sub_obj_owner AUTHENTICATION_TYPE,f_sub_object_name common,f_attribute_name oracle_maintained
from t_object_sanity 
where  f_run_server='TARGET'
and f_catagory_type='ROLES'
minus
select f_owner  role,  f_object_name password_required ,f_sub_obj_owner AUTHENTICATION_TYPE,f_sub_object_name common,f_attribute_name oracle_maintained
from t_object_sanity
where  f_run_server='SOURCE'
and f_catagory_type='ROLES';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle USERS : Source Vs Target </Center>'
            ||'<Center><H2>  Compare USERS in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       USERS
From dual;

select f_owner  username,  f_object_name profile ,f_sub_obj_owner PASSWORD_VERSIONS,f_status account_status
from t_object_sanity 
where  f_run_server='SOURCE'
and f_catagory_type='USERS'
minus
select f_owner  username,  f_object_name profile ,f_sub_obj_owner PASSWORD_VERSIONS,f_status account_status
from t_object_sanity
where  f_run_server='TARGET'
and f_catagory_type='USERS';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle USERS : Target Vs Source </Center>'
            ||'<Center><H2>  Compare USERS in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       USERS
From dual;

select f_owner  username,  f_object_name profile ,f_sub_obj_owner PASSWORD_VERSIONS,f_status account_status
from t_object_sanity 
where  f_run_server='TARGET'
and f_catagory_type='USERS'
minus
select f_owner  username,  f_object_name profile ,f_sub_obj_owner PASSWORD_VERSIONS,f_status account_status
from t_object_sanity
where  f_run_server='SOURCE'
and f_catagory_type='USERS';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle ROLE_PRIVS : Source Vs Target </Center>'
            ||'<Center><H2>  Compare ROLE_PRIVS in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       ROLE_PRIVS
From dual;


select f_owner  grantee,  f_object_name granted_role ,f_sub_obj_owner admin_option
from t_object_sanity 
where  f_run_server='SOURCE'
and f_catagory_type='ROLE_PRIVS'
minus
select f_owner  grantee,  f_object_name granted_role ,f_sub_obj_owner admin_option
from t_object_sanity
where  f_run_server='TARGET'
and f_catagory_type='ROLE_PRIVS';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle ROLE_PRIVS : Target Vs Source </Center>'
            ||'<Center><H2>  Compare ROLE_PRIVS in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       ROLE_PRIVS
From dual;

select f_owner  grantee,  f_object_name granted_role ,f_sub_obj_owner admin_option
from t_object_sanity 
where  f_run_server='TARGET'
and f_catagory_type='ROLE_PRIVS'
minus
select f_owner  grantee,  f_object_name granted_role ,f_sub_obj_owner admin_option
from t_object_sanity
where  f_run_server='SOURCE'
and f_catagory_type='ROLE_PRIVS';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SYS_PRIVS : Source Vs Target </Center>'
            ||'<Center><H2>  Compare SYS_PRIVS in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SYS_PRIVS
From dual;



select f_owner  grantee,  f_object_name PRIVILEGE ,f_sub_obj_owner admin_option
from t_object_sanity 
where  f_run_server='SOURCE'
and f_catagory_type='SYS_PRIVS'
minus
select f_owner  grantee,  f_object_name PRIVILEGE ,f_sub_obj_owner admin_option
from t_object_sanity
where  f_run_server='TARGET'
and f_catagory_type='SYS_PRIVS';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SYS_PRIVS : Target Vs Source </Center>'
            ||'<Center><H2>  Compare SYS_PRIVS in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SYS_PRIVS
From dual;

select f_owner  grantee,  f_object_name PRIVILEGE ,f_sub_obj_owner admin_option
from t_object_sanity 
where  f_run_server='TARGET'
and f_catagory_type='SYS_PRIVS'
minus
select f_owner  grantee,  f_object_name PRIVILEGE ,f_sub_obj_owner admin_option
from t_object_sanity
where  f_run_server='SOURCE'
and f_catagory_type='SYS_PRIVS';



Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle TABLE_STATISTICS : Source Vs Target </Center>'
            ||'<Center><H2>  ---'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TABLE_STATISTICS
From dual;


select owner, table_name, source_num_rows, target_num_rows, decode(source_num_rows,0,decode(target_num_rows,0,100,0),target_num_rows/source_num_rows) pct from
(select s.f_owner owner, s.f_object_name table_name, 
decode(nvl(s.f_sub_obj_owner,0),0,0, s.f_sub_obj_owner) source_num_rows,
decode(nvl(t.f_sub_obj_owner,0),0,0, t.f_sub_obj_owner) target_num_rows
from t_object_sanity s, t_object_sanity t
where s.f_owner=t.f_owner
--table_name join
and s.f_object_name=t.f_object_name
and s.f_run_server='SOURCE'
and s.f_catagory_type='TABLE_STATS'
and t.f_run_server='TARGET'
and t.f_catagory_type='TABLE_STATS'
--num_rows join
and nvl(s.f_sub_obj_owner,0)<>nvl(t.f_sub_obj_owner,0))



Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle LOB_OBJECTS : Source Vs Target </Center>'
            ||'<Center><H2>  ---'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       LOB_OBJECTS
From dual;

select s.f_owner owner, 
s.f_object_name table_name, 
s.f_attribute_name column_name, 
s.f_attribute_type/1024/1024 as "SOURCE_SIZE(MB)",
t.f_attribute_type/1024/1024 as "TARGET_SIZE(MB)", 
(t.f_attribute_type/s.f_attribute_type)*100 as "PCT(%)"
from 
(select  f_owner,f_object_name,f_attribute_name,f_attribute_type from t_object_sanity where f_run_server='SOURCE' and f_catagory_type='LOB_OBJECTS') s,
(select  f_owner,f_object_name,f_attribute_name,f_attribute_type from t_object_sanity where f_run_server='TARGET' and f_catagory_type='LOB_OBJECTS') t
where s.f_owner=t.f_owner
and s.f_object_name=t.f_object_name
and s.f_attribute_name=t.f_attribute_name
and s.f_attribute_name not like 'SYS_%'
--bytes comparision
and s.f_attribute_type<>t.f_attribute_type
order by 6;

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle USER_PROFILES : Source Vs Target </Center>'
            ||'<Center><H2>  Compare USER_PROFILES in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       USER_PROFILES
From dual;


select f_owner  profile,  f_object_name resource_name,f_sub_obj_owner limit
from t_object_sanity 
where  f_run_server='SOURCE'
and f_catagory_type='USER_PROFILES'
minus
select f_owner  profile,  f_object_name resource_name,f_sub_obj_owner limit
from t_object_sanity
where  f_run_server='TARGET'
and f_catagory_type='USER_PROFILES';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle USER_PROFILES : Target Vs Source </Center>'
            ||'<Center><H2>  Compare USER_PROFILES in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       USER_PROFILES
From dual;

select f_owner  profile,  f_object_name resource_name,f_sub_obj_owner limit
from t_object_sanity 
where  f_run_server='TARGET'
and f_catagory_type='USER_PROFILES'
minus
select f_owner  profile,  f_object_name resource_name,f_sub_obj_owner limit
from t_object_sanity
where  f_run_server='SOURCE'
and f_catagory_type='USER_PROFILES';



spool off;
