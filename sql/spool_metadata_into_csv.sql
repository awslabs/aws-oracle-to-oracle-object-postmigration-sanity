/*
AUTHOR			Version				DATE			
Lokesh Gurram	1.0					29-Aug-2022


Discreption:
-----------
This SQL is used to generate the Metadata and spool into CSV file. This will be called from SOURCE_CONNSTR.

*/

-------------------------------------------------------------------
--Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
--SPDX-License-Identifier: MIT-0
-------------------------------------------------------------------


set linesize 32000
set verify off
set termout off
set trim on
set trimout on
set trimspool on
set feed off
set pagesize 0

set head off


spool &&1

SELECT owner||'`^!'||type_name||'`^!'||null||'`^!'||null||'`^!'||attr_name||'`^!'||
attr_type_name||replace('('|| nvl(length, nvl(precision, 0)) || ')', '(0)', '')||'`^!'||
attr_no||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||'OBJECT_TYPE'||'`^!'||'SOURCE'||'`^!'||null
FROM dba_type_attrs
WHERE owner in (&&2) union all 
SELECT c.sequence_owner||'`^!'||c.sequence_name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||to_char(c.min_value)||'`^!'||to_char(c.max_value)||'`^!'||to_char(c.increment_by)||'`^!'||to_char(c.cycle_flag)||'`^!'||to_char(c.cache_size)||'`^!'||to_char(c.last_number)||'`^!'||null||'`^!'||'SEQUENCES'||'`^!'||'SOURCE'||'`^!'||null
FROM dba_sequences c 
WHERE sequence_owner in (&&2) 
union all 
SELECT c.owner||'`^!'||c.table_name||'`^!'||null||'`^!'||null||'`^!'||c.column_name||'`^!'||
c.data_type|| '('|| c.char_length||CASE WHEN c.char_used = 'C' THEN    ' CHAR'   WHEN c.char_used = 'B' THEN ' BYTE' ELSE  NULL  END|| ')' ||'`^!'||
c.column_id||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||'TABLE_COLUMN'||'`^!'|| 'SOURCE'||'`^!'||null
FROM dba_tab_cols  c,
dba_tables    t
WHERE
c.column_id IS NOT NULL
AND c.owner in (&&2)
AND t.owner = c.owner
AND c.hidden_column = 'NO'
AND t.table_name = c.table_name 
union all 
SELECT
c.owner||'`^!'||
c.table_name||'`^!'||
null||'`^!'||
c.constraint_name||'`^!'||
c.column_name||'`^!'||
s.constraint_type||'`^!'||
c.position||'`^!'||
null||'`^!'||
null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||s.status||'`^!'||
'CONSTRAINTS'||'`^!'||
'SOURCE'||'`^!'||null
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
AND c.owner IN  (&&2) 
union all 
SELECT owner||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||object_type||'`^!'||null||'`^!'||cnt||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||'OBJECT_COUNTS'||'`^!'||'SOURCE'||'`^!'||null
FROM
(
SELECT
COUNT(DISTINCT object_name) cnt,
object_type,
owner
FROM
dba_objects
WHERE
object_name NOT LIKE '/%'
AND object_name NOT LIKE 'BIN%'
AND object_name NOT LIKE 'SYS%'
AND owner NOT LIKE 'PEG%'
AND owner in (&&2)
GROUP BY
owner,
object_type
) 
union all 
SELECT
c.table_owner||'`^!'||
c.table_name||'`^!'||
c.index_owner||'`^!'||
c.index_name||'`^!'||
c.column_name||'`^!'||
null||'`^!'||		
c.column_position||'`^!'||
null||'`^!'||
null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||i.status||'`^!'||
'INDEXES'||'`^!'||
'SOURCE'||'`^!'||null
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
AND i.owner in (&&2) 
union all 
select owner||'`^!'||view_name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||text_length||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||'VIEWS'||'`^!'||'SOURCE'||'`^!'||null 
from dba_views where owner in (&&2)
union all
select owner||'`^!'||synonym_name||'`^!'||table_owner||'`^!'||table_name||'`^!'||db_link||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||'SYNONYMS'||'`^!'||'SOURCE'||'`^!'||null 
from dba_synonyms where owner in (&&2)
union all
select owner||'`^!'||trigger_name||'`^!'||table_owner||'`^!'||table_name||'`^!'||triggering_event||'`^!'||trigger_type||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||status||'`^!'||'TRIGGERS'||'`^!'||'SOURCE'||'`^!'||null 
from dba_triggers where owner in (&&2)
union all
select owner||'`^!'||job_name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||state||'`^!'||'SCHEDULER_JOBS'||'`^!'||'SOURCE'||'`^!'||null 
from dba_scheduler_jobs where owner in (&&2)
union all
select owner||'`^!'||name||'`^!'||null||'`^!'||queue_table||'`^!'||null||'`^!'||queue_type||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||ENQUEUE_ENABLED||':'||DEQUEUE_ENABLED||'`^!'||'QUEUES'||'`^!'||'SOURCE'||'`^!'||null 
from DBA_QUEUES where owner in (&&2)
union all
select owner||'`^!'||object_name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||object_type||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||status||'`^!'||'RULES'||'`^!'||'SOURCE'||'`^!'||null 
from dba_objects where owner in (&&2) and object_type LIKE 'RULE%'
union all
select owner||'`^!'||object_name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||object_type||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||status||'`^!'||'JAVA_CLASS_DATA'||'`^!'||'SOURCE'||'`^!'||null 
from dba_objects where owner in (&&2) and object_type LIKE 'JAVA%'
union all
select owner||'`^!'||program_name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||program_type||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||enabled||'`^!'||'SCHD_PROGRAMS'||'`^!'||'SOURCE'||'`^!'||null 
from DBA_SCHEDULER_PROGRAMS where owner in (&&2) 
union all
select table_owner||'`^!'||table_name||'`^!'||null||'`^!'||partition_name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||'TAB_PARTITIONS'||'`^!'||'SOURCE'||'`^!'||null 
from DBA_TAB_PARTITIONS where table_owner in (&&2) 
union all
select index_owner||'`^!'||index_name||'`^!'||null||'`^!'||partition_name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||status||'`^!'||'INDEX_PARTITIONS'||'`^!'||'SOURCE'||'`^!'||null 
from DBA_IND_PARTITIONS where index_owner in (&&2)
union all
select owner||'`^!'||name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||type||'`^!'||null||'`^!'||count(line)||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||'CODE_LINE_COUNT'||'`^!'||'SOURCE'||'`^!'||null 
from dba_source 
where owner in (&&2)
group by owner,name,type 
UNION all
SELECT owner||'`^!'||object_name||'`^!'||NULL||'`^!'||subobject_name||'`^!'||NULL||'`^!'||object_type||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||status||'`^!'||'INVALID_OBJECT'||'`^!'||'SOURCE'||'`^!'||null FROM dba_objects WHERE status='INVALID'
AND owner in (&&2)
union all
select null||'`^!'||patch_id||'`^!'||NULL||'`^!'||null||'`^!'||NULL||'`^!'||null||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||status||'`^!'||'ORA_PATCH'||'`^!'||'SOURCE'||'`^!'||null
--patch_id,  version, status, Action,Action_time 
from dba_registry_sqlpatch
union all
SELECT owner||'`^!'||db_link||'`^!'||username||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||null||'`^!'||'DB_LINK'||'`^!'||'SOURCE'||'`^!'||chr(34)||replace(trim(host),chr(10),'')||chr(34)
FROM dba_db_links
union all
SELECT inst_id||'`^!'||name||'`^!'||null||'`^!'||DISPLAY_VALUE||'`^!'||DEFAULT_VALUE||'`^!'||value||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||null||'`^!'||'DB_PARAMS'||'`^!'||'SOURCE'||'`^!'||null
FROM gv$parameter
union all
--SELECT name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||status||'`^!'||'SQL_PROFILES'||'`^!'||'SOURCE'||'`^!'||chr(34)||to_char(regexp_replace(replace(substr(sql_text,1,500),chr(10),''),' +', ' '))||chr(34)
SELECT name||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||status||'`^!'||'SQL_PROFILES'||'`^!'||'SOURCE'||'`^!'||null
FROM dba_sql_profiles
union all
SELECT role||'`^!'||password_required||'`^!'||AUTHENTICATION_TYPE||'`^!'||common||'`^!'||oracle_maintained||'`^!'||null||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||null||'`^!'||'ROLES'||'`^!'||'SOURCE'||'`^!'||null
FROM dba_roles
union all
SELECT username||'`^!'||profile||'`^!'||PASSWORD_VERSIONS||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||account_status||'`^!'||'USERS'||'`^!'||'SOURCE'||'`^!'||null
FROM dba_users where username in (&&2)
union all
SELECT grantee||'`^!'||granted_role||'`^!'||admin_option||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||null||'`^!'||'ROLE_PRIVS'||'`^!'||'SOURCE'||'`^!'||null
FROM dba_role_privs
union all
SELECT grantee||'`^!'||PRIVILEGE||'`^!'||admin_option||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||null||'`^!'||'SYS_PRIVS'||'`^!'||'SOURCE'||'`^!'||null
FROM dba_sys_privs
union all
select owner||'`^!'||table_name||'`^!'||num_rows||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||null||'`^!'||'TABLE_STATS'||'`^!'||'SOURCE'||'`^!'||null
from
(select s.owner, s.table_name, 
decode(nvl(s.num_rows,0),0,0, s.num_rows) num_rows
from dba_tables s
where s.owner in (&&2))
union all
select owner||'`^!'||table_name||'`^!'||null||'`^!'||null||'`^!'||column_name||'`^!'||bytes||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||null||'`^!'||'LOB_OBJECTS'||'`^!'||'SOURCE'||'`^!'||null
from (
select l.owner, l.table_name, l.column_name, sum(sg.bytes) bytes 
from dba_lobs l, dba_segments sg 
where l.owner=sg.owner and l.segment_name=sg.segment_name 
and l.owner in (&&2)
group by l.owner,l.table_name,l.column_name)
union all
select profile||'`^!'||resource_name||'`^!'||limit||'`^!'||null||'`^!'||null||'`^!'||null||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||NULL||'`^!'||null||'`^!'||'USER_PROFILES'||'`^!'||'SOURCE'||'`^!'||null
from dba_profiles;

spool off;
