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

select owner,Type_name,attr_name,attr_type_name|| replace('('|| nvl(length, nvl(precision, 0)) || ')', '(0)', '') attr_type,attr_no position_id
from dba_type_attrs@&&2  
where owner in (&&3)
minus
select owner,Type_name,attr_name,attr_type_name|| replace('('|| nvl(length, nvl(precision, 0)) || ')', '(0)', '') attr_type,attr_no position_id
from dba_type_attrs
where owner in (&&3);


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Type: Target Vs Source </Center>'
            ||'<Center><H2>  Types exists in TARGET and NOT in SOURCE'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       OBJECT_TYPE
From dual;


select owner,Type_name,attr_name,attr_type_name|| replace('('|| nvl(length, nvl(precision, 0)) || ')', '(0)', '') attr_type,attr_no position_id
from dba_type_attrs 
where owner in (&&3)
minus
select owner,Type_name,attr_name,attr_type_name|| replace('('|| nvl(length, nvl(precision, 0)) || ')', '(0)', '') attr_type,attr_no position_id
from dba_type_attrs@&&2 
where owner in (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Sequences: Source Vs Target </Center>'
            ||'<Center><H2>  Sequences exists in SOURCE and NOT in TARGET'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SEQUENCES
From dual;

--compare Oracle SEQUENCES:
select sequence_owner owner,sequence_name Seq_name,to_char(c.min_value) min_value,to_char(c.max_value) max_value,to_char(c.increment_by) increment_by,to_char(c.cycle_flag) cycle_flag,to_char(c.cache_size) cache_size,to_char(c.last_number) last_num
from dba_sequences@&&2 c
where sequence_owner in (&&3)
minus
select sequence_owner owner,sequence_name Seq_name,to_char(c.min_value) min_value,to_char(c.max_value) max_value,to_char(c.increment_by) increment_by,to_char(c.cycle_flag) cycle_flag,to_char(c.cache_size) cache_size,to_char(c.last_number) last_num
from dba_sequences c
where sequence_owner in (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Sequences: Target Vs Source </Center>'
            ||'<Center><H2>  Sequences exists in TARGET and NOT in SOURCE'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SEQUENCES
From dual;

select sequence_owner owner,sequence_name Seq_name,to_char(c.min_value) min_value,to_char(c.max_value) max_value,to_char(c.increment_by) increment_by,to_char(c.cycle_flag) cycle_flag,to_char(c.cache_size) cache_size,to_char(c.last_number) last_num
from dba_sequences c
where sequence_owner in (&&3)
minus
select sequence_owner owner,sequence_name Seq_name,to_char(c.min_value) min_value,to_char(c.max_value) max_value,to_char(c.increment_by) increment_by,to_char(c.cycle_flag) cycle_flag,to_char(c.cache_size) cache_size,to_char(c.last_number) last_num
from dba_sequences@&&2 c
where sequence_owner in (&&3);



Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Tables and Columns: Source Vs Target </Center>'
            ||'<Center><H2>  Table Columns exists in SOURCE and NOT in TARGET'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TABLE_COLUMN
From dual;

--compare Oracle TABLE_COLUMN:
SELECT c.owner,c.table_name,c.column_name,
c.data_type|| '('|| c.char_length||CASE WHEN c.char_used = 'C' THEN    ' CHAR'   WHEN c.char_used = 'B' THEN ' BYTE' ELSE  NULL  END|| ')' attr_type,
c.column_id position_id
		FROM dba_tab_cols@&&2  c,
			 dba_tables@&&2    t
		WHERE
			c.column_id IS NOT NULL
			AND c.owner IN (&&3)
			AND t.owner = c.owner
			AND c.hidden_column = 'NO'
			AND t.table_name = c.table_name
minus
SELECT c.owner,c.table_name,c.column_name,
c.data_type|| '('|| c.char_length||CASE WHEN c.char_used = 'C' THEN    ' CHAR'   WHEN c.char_used = 'B' THEN ' BYTE' ELSE  NULL  END|| ')' attr_type,
c.column_id position_id
		FROM dba_tab_cols   c,
			 dba_tables     t
		WHERE
			c.column_id IS NOT NULL
			AND c.owner IN (&&3)
			AND t.owner = c.owner
			AND c.hidden_column = 'NO'
			AND t.table_name = c.table_name;

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Tables and Columns: Target Vs Source </Center>'
            ||'<Center><H2>  Table Columns exists in TARGET and NOT in SOURCE'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TABLE_COLUMN
From dual;

SELECT c.owner,c.table_name,c.column_name,
c.data_type|| '('|| c.char_length||CASE WHEN c.char_used = 'C' THEN    ' CHAR'   WHEN c.char_used = 'B' THEN ' BYTE' ELSE  NULL  END|| ')' attr_type,
c.column_id position_id
		FROM dba_tab_cols  c,
			 dba_tables    t
		WHERE
			c.column_id IS NOT NULL
			AND c.owner IN (&&3)
			AND t.owner = c.owner
			AND c.hidden_column = 'NO'
			AND t.table_name = c.table_name
minus
SELECT c.owner,c.table_name,c.column_name,
c.data_type|| '('|| c.char_length||CASE WHEN c.char_used = 'C' THEN    ' CHAR'   WHEN c.char_used = 'B' THEN ' BYTE' ELSE  NULL  END|| ')' attr_type,
c.column_id position_id
		FROM dba_tab_cols@&&2   c,
			 dba_tables@&&2     t
		WHERE
			c.column_id IS NOT NULL
			AND c.owner IN (&&3)
			AND t.owner = c.owner
			AND c.hidden_column = 'NO'
			AND t.table_name = c.table_name;

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Constraints : Source Vs Target </Center>'
            ||'<Center><H2>  Constraints exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       CONSTRAINTS
From dual;

--compare Oracle CONSTRAINTS:
SELECT
		c.owner,
		c.table_name,
		c.constraint_name,
		c.column_name,
		s.constraint_type,
		c.position,
		s.status
	FROM
		dba_cons_columns@&&2  c,
		dba_constraints@&&2   s
	WHERE
			s.table_name = c.table_name
		AND c.owner = s.owner
		AND c.constraint_name = s.constraint_name
		AND c.constraint_name NOT LIKE 'BIN%'
		AND c.constraint_name NOT LIKE 'SYS_%'
		AND c.table_name NOT LIKE 'BIN%'
		AND c.table_name NOT LIKE 'SYS%'
		AND c.owner IN  (&&3)
minus
SELECT
		c.owner,
		c.table_name,
		c.constraint_name,
		c.column_name,
		s.constraint_type,
		c.position,
		s.status
	FROM
		dba_cons_columns  c,
		dba_constraints   s
	WHERE
			s.table_name = c.table_name
		AND c.owner = s.owner
		AND c.constraint_name = s.constraint_name
		AND c.constraint_name NOT LIKE 'BIN%'
		AND c.constraint_name NOT LIKE 'SYS_%'
		AND c.table_name NOT LIKE 'BIN%'
		AND c.table_name NOT LIKE 'SYS%'
		AND c.owner IN  (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Constraints : Target Vs Source </Center>'
            ||'<Center><H2>  Constraints exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       CONSTRAINTS
From dual;


SELECT
		c.owner,
		c.table_name,
		c.constraint_name,
		c.column_name,
		s.constraint_type,
		c.position,
		s.status
	FROM
		dba_cons_columns  c,
		dba_constraints   s
	WHERE
			s.table_name = c.table_name
		AND c.owner = s.owner
		AND c.constraint_name = s.constraint_name
		AND c.constraint_name NOT LIKE 'BIN%'
		AND c.constraint_name NOT LIKE 'SYS_%'
		AND c.table_name NOT LIKE 'BIN%'
		AND c.table_name NOT LIKE 'SYS%'
		AND c.owner IN  (&&3)
minus
SELECT
		c.owner,
		c.table_name,
		c.constraint_name,
		c.column_name,
		s.constraint_type,
		c.position,
		s.status
	FROM
		dba_cons_columns@&&2  c,
		dba_constraints@&&2   s
	WHERE
			s.table_name = c.table_name
		AND c.owner = s.owner
		AND c.constraint_name = s.constraint_name
		AND c.constraint_name NOT LIKE 'BIN%'
		AND c.constraint_name NOT LIKE 'SYS_%'
		AND c.table_name NOT LIKE 'BIN%'
		AND c.table_name NOT LIKE 'SYS%'
		AND c.owner IN  (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Object Counts : Source Vs Target </Center>'
            ||'<Center><H2>  Objects comparision exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       OBJECT_COUNTS
From dual;

--compare Oracle OBJECT_COUNTS:
SELECT	COUNT(DISTINCT object_name) cnt,
	object_type,
	owner
FROM
	dba_objects@&&2
WHERE
	object_name NOT LIKE '/%'
	AND object_name NOT LIKE 'BIN%'
	AND object_name NOT LIKE 'SYS%'
	AND owner IN (&&3)
GROUP BY
	owner,
	object_type
minus
SELECT	COUNT(DISTINCT object_name) cnt,
	object_type,
	owner
FROM
	dba_objects
WHERE
	object_name NOT LIKE '/%'
	AND object_name NOT LIKE 'BIN%'
	AND object_name NOT LIKE 'SYS%'
	AND owner IN (&&3)
GROUP BY
	owner,
	object_type;

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Object Counts : Target Vs Source </Center>'
            ||'<Center><H2>  Objects comparision exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       OBJECT_COUNTS
From dual;

SELECT	COUNT(DISTINCT object_name) cnt,
	object_type,
	owner
FROM
	dba_objects
WHERE
	object_name NOT LIKE '/%'
	AND object_name NOT LIKE 'BIN%'
	AND object_name NOT LIKE 'SYS%'
	AND owner IN (&&3)
GROUP BY
	owner,
	object_type
minus
SELECT	COUNT(DISTINCT object_name) cnt,
	object_type,
	owner
FROM
	dba_objects@&&2
WHERE
	object_name NOT LIKE '/%'
	AND object_name NOT LIKE 'BIN%'
	AND object_name NOT LIKE 'SYS%'
	AND owner IN (&&3)
GROUP BY
	owner,
	object_type;

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Indexes : Source Vs Target </Center>'
            ||'<Center><H2>  Indexes exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INDEXES
From dual;

--compare Oracle INDEXES:
SELECT
c.table_owner,
c.table_name,
c.index_owner,
c.index_name,
c.column_name,
c.column_position,
i.status
FROM
dba_indexes@&&2      i,
dba_ind_columns@&&2  c
WHERE i.index_name = c.index_name
AND i.owner = c.index_owner
AND i.table_owner = c.table_owner
AND i.table_name = c.table_name
AND i.table_name NOT LIKE 'SYS%'
AND i.table_name NOT LIKE 'BIN%'
AND i.index_name NOT LIKE 'SYS%'
AND i.index_name NOT LIKE 'BIN%'
AND i.owner IN (&&3)
minus
SELECT
c.table_owner,
c.table_name,
c.index_owner,
c.index_name,
c.column_name,
c.column_position,
i.status
FROM
dba_indexes      i,
dba_ind_columns  c
WHERE i.index_name = c.index_name
AND i.owner = c.index_owner
AND i.table_owner = c.table_owner
AND i.table_name = c.table_name
AND i.table_name NOT LIKE 'SYS%'
AND i.table_name NOT LIKE 'BIN%'
AND i.index_name NOT LIKE 'SYS%'
AND i.index_name NOT LIKE 'BIN%'
AND i.owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Indexes : Target Vs Source </Center>'
            ||'<Center><H2>  Indexes exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INDEXES
From dual;

SELECT
c.table_owner,
c.table_name,
c.index_owner,
c.index_name,
c.column_name,
c.column_position,
i.status
FROM
dba_indexes      i,
dba_ind_columns  c
WHERE i.index_name = c.index_name
AND i.owner = c.index_owner
AND i.table_owner = c.table_owner
AND i.table_name = c.table_name
AND i.table_name NOT LIKE 'SYS%'
AND i.table_name NOT LIKE 'BIN%'
AND i.index_name NOT LIKE 'SYS%'
AND i.index_name NOT LIKE 'BIN%'
AND i.owner IN (&&3)
minus
SELECT
c.table_owner,
c.table_name,
c.index_owner,
c.index_name,
c.column_name,
c.column_position,
i.status
FROM
dba_indexes@&&2      i,
dba_ind_columns@&&2  c
WHERE i.index_name = c.index_name
AND i.owner = c.index_owner
AND i.table_owner = c.table_owner
AND i.table_name = c.table_name
AND i.table_name NOT LIKE 'SYS%'
AND i.table_name NOT LIKE 'BIN%'
AND i.index_name NOT LIKE 'SYS%'
AND i.index_name NOT LIKE 'BIN%'
AND i.owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Views : Source Vs Target </Center>'
            ||'<Center><H2>  Views exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       VIEWS
From dual;

select owner,view_name,text_length
from dba_views@&&2 
where owner IN (&&3)
minus
select owner,view_name,text_length
from dba_views 
where owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Views : Target Vs Source </Center>'
            ||'<Center><H2>  Views exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       VIEWS
From dual;

select owner,view_name,text_length
from dba_views
where owner IN (&&3)
minus
select owner,view_name,text_length
from dba_views@&&2
where owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SYNONYMS : Source Vs Target </Center>'
            ||'<Center><H2>  SYNONYMS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SYNONYMS
From dual;

select owner,synonym_name,table_owner,table_name,db_link
from dba_synonyms@&&2 
where owner IN (&&3)
minus
select owner,synonym_name,table_owner,table_name,db_link
from dba_synonyms
where owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SYNONYMS : Target Vs Source </Center>'
            ||'<Center><H2>  SYNONYMS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SYNONYMS
From dual;

select owner,synonym_name,table_owner,table_name,db_link
from dba_synonyms
where owner IN (&&3)
minus
select owner,synonym_name,table_owner,table_name,db_link
from dba_synonyms@&&2 
where owner IN (&&3);


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle TRIGGERS : Source Vs Target </Center>'
            ||'<Center><H2>  TRIGGERS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TRIGGERS
From dual;

select owner,trigger_name,table_owner,table_name,triggering_event,trigger_type,status
from dba_triggers@&&2 
where owner IN (&&3)
minus
select owner,trigger_name,table_owner,table_name,triggering_event,trigger_type,status
from dba_triggers
where owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle TRIGGERS : Target Vs Source </Center>'
            ||'<Center><H2>  TRIGGERS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TRIGGERS
From dual;

select owner,trigger_name,table_owner,table_name,triggering_event,trigger_type,status
from dba_triggers 
where owner IN (&&3)
minus
select owner,trigger_name,table_owner,table_name,triggering_event,trigger_type,status
from dba_triggers@&&2
where owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SCHEDULER_JOBS : Source Vs Target </Center>'
            ||'<Center><H2>  SCHEDULER_JOBS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SCHEDULER_JOBS
From dual;


select owner,job_name,state
from dba_scheduler_jobs@&&2 
where owner IN (&&3)
minus
select owner,job_name,state
from dba_scheduler_jobs 
where owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SCHEDULER_JOBS : Target Vs Source </Center>'
            ||'<Center><H2>  SCHEDULER_JOBS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SCHEDULER_JOBS
From dual;

select owner,job_name,state
from dba_scheduler_jobs 
where owner IN (&&3)
minus
select owner,job_name,state
from dba_scheduler_jobs@&&2 
where owner IN (&&3);


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle QUEUES : Source Vs Target </Center>'
            ||'<Center><H2>  QUEUES exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       QUEUES
From dual;

select owner,name,queue_table,queue_type,ENQUEUE_ENABLED,DEQUEUE_ENABLED
from DBA_QUEUES@&&2 
where owner IN (&&3)
minus
select owner,name,queue_table,queue_type,ENQUEUE_ENABLED,DEQUEUE_ENABLED
from DBA_QUEUES 
where owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle QUEUES : Target Vs Source </Center>'
            ||'<Center><H2>  QUEUES exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       QUEUES
From dual;

select owner,name,queue_table,queue_type,ENQUEUE_ENABLED,DEQUEUE_ENABLED
from DBA_QUEUES 
where owner IN (&&3)
minus
select owner,name,queue_table,queue_type,ENQUEUE_ENABLED,DEQUEUE_ENABLED
from DBA_QUEUES@&&2
where owner IN (&&3);


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle RULES : Source Vs Target </Center>'
            ||'<Center><H2>  RULES exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       RULES
From dual;

select owner,object_name,object_type,status
from dba_objects@&&2 
where owner IN (&&3)
and object_type LIKE 'RULE%'
minus
select owner,object_name,object_type,status
from dba_objects 
where owner IN (&&3)
and object_type LIKE 'RULE%';



Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle RULES : Target Vs Source </Center>'
            ||'<Center><H2>  RULES exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       RULES
From dual;

select owner,object_name,object_type,status
from dba_objects
where owner IN (&&3)
and object_type LIKE 'RULE%'
minus
select owner,object_name,object_type,status
from dba_objects@&&2
where owner IN (&&3)
and object_type LIKE 'RULE%';


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle JAVA_CLASS_DATA : Source Vs Target </Center>'
            ||'<Center><H2>  JAVA_CLASS_DATA exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       JAVA_CLASS_DATA
From dual;

select owner,object_name,object_type,status
from dba_objects@&&2
where owner IN (&&3)
and object_type LIKE 'JAVA%'
minus
select owner,object_name,object_type,status
from dba_objects
where owner IN (&&3)
and object_type LIKE 'JAVA%';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle JAVA_CLASS_DATA : Target Vs Source </Center>'
            ||'<Center><H2>  JAVA_CLASS_DATA exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       JAVA_CLASS_DATA
From dual;

select owner,object_name,object_type,status
from dba_objects 
where owner IN (&&3)
and object_type LIKE 'JAVA%'
minus
select owner,object_name,object_type,status
from dba_objects@&&2
where owner IN (&&3)
and object_type LIKE 'JAVA%';

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SCHD_PROGRAMS : Source Vs Target </Center>'
            ||'<Center><H2>  SCHD_PROGRAMS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SCHD_PROGRAMS
From dual;

select owner,program_name,program_type,enabled
from DBA_SCHEDULER_PROGRAMS@&&2 
where owner IN (&&3)
minus
select owner,program_name,program_type,enabled
from DBA_SCHEDULER_PROGRAMS 
where owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SCHD_PROGRAMS : Target Vs Source </Center>'
            ||'<Center><H2>  SCHD_PROGRAMS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SCHD_PROGRAMS
From dual;

select owner,program_name,program_type,enabled
from DBA_SCHEDULER_PROGRAMS 
where owner IN (&&3)
minus
select owner,program_name,program_type,enabled
from DBA_SCHEDULER_PROGRAMS@&&2 
where owner IN (&&3);


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle TAB_PARTITIONS : Source Vs Target </Center>'
            ||'<Center><H2>  TAB_PARTITIONS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TAB_PARTITIONS
From dual;

select table_owner,table_name,partition_name
from DBA_TAB_PARTITIONS@&&2 
where table_owner IN (&&3)
minus
select table_owner,table_name,partition_name
from DBA_TAB_PARTITIONS 
where table_owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle TAB_PARTITIONS : Target Vs Source </Center>'
            ||'<Center><H2>  TAB_PARTITIONS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TAB_PARTITIONS
From dual;

select table_owner,table_name,partition_name
from DBA_TAB_PARTITIONS 
where table_owner IN (&&3)
minus
select table_owner,table_name,partition_name
from DBA_TAB_PARTITIONS@&&2
where table_owner IN (&&3);


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle INDEX_PARTITIONS : Source Vs Target </Center>'
            ||'<Center><H2>  INDEX_PARTITIONS exists in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INDEX_PARTITIONS
From dual;

select index_owner,index_name,partition_name,status
from DBA_IND_PARTITIONS@&&2 
where index_owner IN (&&3)
minus
select index_owner,index_name,partition_name,status
from DBA_IND_PARTITIONS
where index_owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle INDEX_PARTITIONS : Target Vs Source </Center>'
            ||'<Center><H2>  INDEX_PARTITIONS exists in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INDEX_PARTITIONS
From dual;

select index_owner,index_name,partition_name,status
from DBA_IND_PARTITIONS 
where index_owner IN (&&3)
minus
select index_owner,index_name,partition_name,status
from DBA_IND_PARTITIONS@&&2 
where index_owner IN (&&3);


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle CODE lines(proc,pkgs and Functions) : Source Vs Target </Center>'
            ||'<Center><H2>  Compare Number of Lines of each CODE object in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       CODE_LINE_COUNT
From dual;

--compare Oracle CODE_LINE_COUNT:
select owner,name,type,count(line)
from dba_source@&&2 
where owner IN (&&3)
group by owner,name,type
minus
select owner,name,type,count(line)
from dba_source
where owner IN (&&3)
group by owner,name,type;

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle dba_source(proc,pkgs and Functions) : Target Vs Source </Center>'
            ||'<Center><H2>  Compare Number of Lines of each CODE object in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       CODE_LINE_COUNT
From dual;

select owner,name,type,count(line)
from dba_source
where owner IN (&&3)
group by owner,name,type
minus
select owner,name,type,count(line)
from dba_source@&&2
where owner IN (&&3)
group by owner,name,type;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Invalid Objects : Source Vs Target </Center>'
            ||'<Center><H2>  Compare INVALID Objects in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INVALID_OBJECT
From dual;

--compare Oracle INVALID_OBJECT:
SELECT owner,object_name,subobject_name,object_type,status
FROM dba_objects@&&2 
WHERE status='INVALID'
AND owner IN (&&3)
minus
SELECT owner,object_name,subobject_name,object_type,status
FROM dba_objects 
WHERE status='INVALID'
AND owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Invalid Objects : Target Vs Source </Center>'
            ||'<Center><H2>  Compare INVALID Objects in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       INVALID_OBJECT
From dual;


SELECT owner,object_name,subobject_name,object_type,status
FROM dba_objects 
WHERE status='INVALID'
AND owner IN (&&3)
minus
SELECT owner,object_name,subobject_name,object_type,status
FROM dba_objects@&&2
WHERE status='INVALID'
AND owner IN (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Patch Details : Source Vs Target </Center>'
            ||'<Center><H2>  Compare Patch Details in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       PATCH_DETAILS
From dual;

select patch_id,   status, Action,Action_time 
from dba_registry_sqlpatch@&&2 
minus
select patch_id,   status, Action,Action_time 
from dba_registry_sqlpatch;

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle Patch Details : Target Vs Source </Center>'
            ||'<Center><H2>  Compare Patch Details in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       PATCH_DETAILS
From dual;

select patch_id,   status, Action,Action_time 
from dba_registry_sqlpatch
minus
select patch_id,   status, Action,Action_time 
from dba_registry_sqlpatch@&&2 ;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle DB Parameters : Source Vs Target </Center>'
            ||'<Center><H2>  Compare DB Parameters in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       DB_PARAMETERS
From dual;

SELECT inst_id,name,value,DISPLAY_VALUE,DEFAULT_VALUE FROM gv$parameter@&&2
minus
SELECT inst_id,name,value,DISPLAY_VALUE,DEFAULT_VALUE FROM gv$parameter;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle DB Parameters : Target Vs Source </Center>'
            ||'<Center><H2>  Compare DB Parameters in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       DB_PARAMETERS
From dual;

SELECT inst_id,name,value,DISPLAY_VALUE,DEFAULT_VALUE FROM gv$parameter
minus
SELECT inst_id,name,value,DISPLAY_VALUE,DEFAULT_VALUE FROM gv$parameter@&&2;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle DB Link : Source Vs Target </Center>'
            ||'<Center><H2>  Compare DB Link in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       DB_LINK
From dual;

SELECT owner,db_link,username,replace(trim(host),chr(10),'') host FROM dba_db_links@&&2
minus
SELECT owner,db_link,username,replace(trim(host),chr(10),'') host FROM dba_db_links;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle DB Link : Target Vs Source </Center>'
            ||'<Center><H2>  Compare DB Link in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       DB_LINK
From dual;

SELECT owner,db_link,username,replace(trim(host),chr(10),'') host FROM dba_db_links
minus
SELECT owner,db_link,username,replace(trim(host),chr(10),'') host FROM dba_db_links@&&2;



Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SQL_PROFILES : Source Vs Target </Center>'
            ||'<Center><H2>  Compare SQL_PROFILES in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SQL_PROFILES
From dual;

SELECT name,to_char(substr(sql_text,1,3000)) sql_text,status FROM dba_sql_profiles@&&2
minus
SELECT name,to_char(substr(sql_text,1,3000)),status FROM dba_sql_profiles;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SQL_PROFILES : Target Vs Source </Center>'
            ||'<Center><H2>  Compare SQL_PROFILES in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SQL_PROFILES
From dual;

SELECT name,to_char(substr(sql_text,1,3000)) sql_text,status FROM dba_sql_profiles
minus
SELECT name,to_char(substr(sql_text,1,3000)),status FROM dba_sql_profiles@&&2;

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle ROLES : Source Vs Target </Center>'
            ||'<Center><H2>  Compare ROLES in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       ROLES
From dual;

select ROLE,password_required,AUTHENTICATION_TYPE ,common,oracle_maintained from dba_roles@&&2
minus
select ROLE,password_required,AUTHENTICATION_TYPE ,common,oracle_maintained from dba_roles;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle ROLES : Target Vs Source </Center>'
            ||'<Center><H2>  Compare ROLES in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       ROLES
From dual;

select ROLE,password_required,AUTHENTICATION_TYPE ,common,oracle_maintained from dba_roles
minus
select ROLE,password_required,AUTHENTICATION_TYPE ,common,oracle_maintained from dba_roles@&&2;

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle USERS : Source Vs Target </Center>'
            ||'<Center><H2>  Compare USERS in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       USERS
From dual;

SELECT username,profile,account_status,PASSWORD_VERSIONS  FROM dba_users@&&2 where username in (&&3)
minus
SELECT username,profile,account_status,PASSWORD_VERSIONS  FROM dba_users where username in (&&3);


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle USERS : Target Vs Source </Center>'
            ||'<Center><H2>  Compare USERS in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       USERS
From dual;

SELECT username,profile,account_status,PASSWORD_VERSIONS  FROM dba_users where username in (&&3)
minus
SELECT username,profile,account_status,PASSWORD_VERSIONS  FROM dba_users@&&2 where username in (&&3);

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle ROLE_PRIVS : Source Vs Target </Center>'
            ||'<Center><H2>  Compare ROLE_PRIVS in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       ROLE_PRIVS
From dual;


SELECT grantee,granted_role,admin_option FROM dba_role_privs@&&2
minus
SELECT grantee,granted_role,admin_option FROM dba_role_privs;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle ROLE_PRIVS : Target Vs Source </Center>'
            ||'<Center><H2>  Compare ROLE_PRIVS in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       ROLE_PRIVS
From dual;

SELECT grantee,granted_role,admin_option FROM dba_role_privs
minus
SELECT grantee,granted_role,admin_option FROM dba_role_privs@&&2;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SYS_PRIVS : Source Vs Target </Center>'
            ||'<Center><H2>  Compare SYS_PRIVS in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SYS_PRIVS
From dual;


select grantee,PRIVILEGE ,admin_option   from dba_sys_privs@&&2
minus
select grantee,PRIVILEGE ,admin_option   from dba_sys_privs;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle SYS_PRIVS : Target Vs Source </Center>'
            ||'<Center><H2>  Compare SYS_PRIVS in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       SYS_PRIVS
From dual;

select grantee,PRIVILEGE ,admin_option   from dba_sys_privs
minus
select grantee,PRIVILEGE ,admin_option   from dba_sys_privs@&&2;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle TABLE_STATISTICS : Source Vs Target </Center>'
            ||'<Center><H2>  ---'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       TABLE_STATISTICS
From dual;


select owner, table_name, source_num_rows, target_num_rows, decode(source_num_rows,0,decode(target_num_rows,0,100,0),target_num_rows/source_num_rows) pct from
(select s.owner, s.table_name, 
decode(nvl(s.num_rows,0),0,0, s.num_rows) source_num_rows,
decode(nvl(t.num_rows,0),0,0, t.num_rows) target_num_rows
from dba_tables@&&2 s, dba_tables t
where s.owner=t.owner
and s.table_name=t.table_name
and s.owner in (&&3)
and nvl(s.num_rows,0)<>nvl(t.num_rows,0))
order by 5;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle LOB_OBJECTS : Source Vs Target </Center>'
            ||'<Center><H2>  ---'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       LOB_OBJECTS
From dual;

select s.owner, 
s.table_name, 
s.column_name, 
s.bytes/1024/1024 as "SOURCE_SIZE(MB)",
t.bytes/1024/1024 as "TARGET_SIZE(MB)", 
(t.bytes/s.bytes)*100 as "PCT(%)
from 
(select l.owner, l.table_name, l.column_name, sum(sg.bytes) bytes from dba_lobs@&&2 l, dba_segments@&&2 sg where l.owner=sg.owner and l.segment_name=sg.segment_name group by l.owner,l.table_name,l.column_name) s,
(select l.owner, l.table_name, l.column_name, sum(sg.bytes) bytes from dba_lobs l, dba_segments sg where l.owner=sg.owner and l.segment_name=sg.segment_name group by l.owner,l.table_name,l.column_name) t
where s.owner=t.owner
and s.table_name=t.table_name
and s.column_name=t.column_name
and s.column_name not like 'SYS_%'
and s.owner in (&&3)
and s.bytes<>t.bytes
order by 6;

Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle USER_PROFILES : Source Vs Target </Center>'
            ||'<Center><H2>  Compare USER_PROFILES in Source and NOT in Target'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       USER_PROFILES
From dual;


select profile,resource_name,limit from dba_profiles@&&2
minus
select profile,resource_name,limit from dba_profiles;


Select        '<Font Size=5><Font Color = "#FF0000"><Font Face ="Amazone BT">'
            ||'<Center>   Oracle USER_PROFILES : Target Vs Source </Center>'
            ||'<Center><H2>  Compare USER_PROFILES in Target and NOT in Source'
            ||'</H2></Center></Font><Font Color = Ff0000>' 
       USER_PROFILES
From dual;

select profile,resource_name,limit from dba_profiles
minus
select profile,resource_name,limit from dba_profiles@&&2;

spool off;
