/*
Author 				DATE					Version
Lokesh Gurram		21-Aug-2022				1.0


Discreption:
-----------
This SQL is used to create the STG or TEMP table in TARGET_CONNSTR. So that this table holds both Source and Target metadata for sanity.

*/

-------------------------------------------------------------------
--Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
--SPDX-License-Identifier: MIT-0
-------------------------------------------------------------------


spool &&1

truncate table t_object_sanity;

create table t_object_sanity(
f_owner varchar2(2000 char),
f_object_name varchar2(2000 char),
f_sub_obj_owner varchar2(2000 char),
f_sub_object_name varchar2(2000 char),
f_attribute_name varchar2(2000 char),
f_attribute_type varchar2(2000 char),
f_position_id number,
f_count number,
f_min_value varchar2(1000 char),
f_max_value varchar2(1000 char),
f_increment_by varchar2(1000 char),
f_cycle_flag varchar2(1000 char),
f_cache_size varchar2(1000 char),
f_last_number varchar2(1000 char),
f_status varchar2(1000 char),
f_catagory_type varchar2(2000 char),
f_run_server varchar2(1000 char),
f_text varchar2(4000 char),
f_insert_time date default sysdate);

comment on table t_object_sanity is 'Table holds the list of objects for Object Sanity';
COMMENT ON COLUMN t_object_sanity.f_owner IS 'Owner of object';
COMMENT ON COLUMN t_object_sanity.f_object_name IS 'Object name like table_name,Type_name,Sequence_name,proc_name,view_name,synonym_name';
COMMENT ON COLUMN t_object_sanity.f_sub_obj_owner IS 'Owner of index or owner of constraint';
COMMENT ON COLUMN t_object_sanity.f_sub_object_name IS 'Name of Constraint or Index Name';
COMMENT ON COLUMN t_object_sanity.f_attribute_name IS 'Column name of table or column name of object type';
COMMENT ON COLUMN t_object_sanity.f_attribute_type IS 'Data type of column or object type';
COMMENT ON COLUMN t_object_sanity.f_position_id IS 'position of column in table or object type';
COMMENT ON COLUMN t_object_sanity.f_count IS 'Hold the count of objects';
COMMENT ON COLUMN t_object_sanity.f_min_value is 'holds the Seq min values';
COMMENT ON COLUMN t_object_sanity.f_max_value is 'holds the Seq max values';
COMMENT ON COLUMN t_object_sanity.f_increment_by is 'holds the Seq Incrementy by values';
COMMENT ON COLUMN t_object_sanity.f_cycle_flag is 'holds the Seq cycle_flag values';
COMMENT ON COLUMN t_object_sanity.f_cache_size is 'holds the Seq cache size values'; 
COMMENT ON COLUMN t_object_sanity.f_last_number is 'holds the Seq last_number values';
COMMENT ON COLUMN t_object_sanity.f_status is 'holds the object_status ';
COMMENT ON COLUMN t_object_sanity.f_catagory_type IS 'Holds the type of sanity,like Table sanity or constriant sanity .. etc';
COMMENT ON COLUMN t_object_sanity.f_run_server IS 'Holds the Source or destination server mode:ex:SOURCE or TARGET';
COMMENT ON COLUMN t_object_sanity.f_text IS 'Holds variable lenght string like host or sql text details.';


spool off;
