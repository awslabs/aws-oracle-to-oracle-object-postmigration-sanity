/*
Author 				DATE					Version
Lokesh Gurram		21-Aug-2022				1.0


Discreption:
-----------
This SQL is used to insert the TARGET_CONNSTR metadata into T_OBJECT_SANITY table. 

*/

-------------------------------------------------------------------
--Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
--SPDX-License-Identifier: MIT-0
-------------------------------------------------------------------




declare
 p_in_run_server varchar2(100):= '&&1';
begin

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		SELECT owner,type_name,null,null,attr_name,attr_type_name|| replace('('|| nvl(length, nvl(precision, 0)) || ')', '(0)', ''),attr_no,null,null,null,null,null,null,null,null,'OBJECT_TYPE',p_in_run_server
		FROM dba_type_attrs
		WHERE owner in (&&2);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20001,'INSERT into t_object_sanity.dba_type_attrs failed'||sqlerrm);
	END;

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		SELECT c.sequence_owner,c.sequence_name,null,null,null,null,null,null,to_char(c.min_value),to_char(c.max_value),to_char(c.increment_by),to_char(c.cycle_flag),to_char(c.cache_size),to_char(c.last_number),null,'SEQUENCES',p_in_run_server
		FROM dba_sequences c 
		WHERE sequence_owner in (&&2);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20002,'INSERT into t_object_sanity.dba_sequences failed'||sqlerrm);
	END;

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		SELECT c.owner,c.table_name,null,null,c.column_name,
c.data_type|| '('|| c.char_length||CASE WHEN c.char_used = 'C' THEN    ' CHAR'   WHEN c.char_used = 'B' THEN ' BYTE' ELSE  NULL  END|| ')' ,
c.column_id,null,null,null,null,null,null,null,null,'TABLE_COLUMN', p_in_run_server
		FROM dba_tab_cols  c,
			 dba_tables    t
		WHERE
			c.column_id IS NOT NULL
			AND c.owner IN (&&2)
			AND t.owner = c.owner
			AND c.hidden_column = 'NO'
			AND t.table_name = c.table_name;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.dba_tab_cols failed'||sqlerrm);
	END;
	
	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		SELECT
		c.owner,
		c.table_name,
		null,
		c.constraint_name,
		c.column_name,
		s.constraint_type,
		c.position,
		null,
		null,null,null,null,null,null,s.status,
		'CONSTRAINTS',
		p_in_run_server
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
		AND c.owner IN  (&&2);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.dba_cons_columns failed'||sqlerrm);
	END;
		
	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		SELECT owner,null,null,null,null,object_type,null,cnt,null,null,null,null,null,null,null,'OBJECT_COUNTS',p_in_run_server
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
					AND owner IN (&&2)
				GROUP BY
					owner,
					object_type
			);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.dba_objects failed'||sqlerrm);
	END;	

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		SELECT
		c.table_owner,
		c.table_name,
		c.index_owner,
		c.index_name,
		c.column_name,
		null,		
		c.column_position,
		null,
		null,null,null,null,null,null,i.status,
		'INDEXES',
		p_in_run_server
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
		AND i.owner IN (&&2);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.dba_indexes failed'||sqlerrm);
	END;	

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select owner,view_name,null,null,null,null,null,text_length,null,null,null,null,null,null,null,'VIEWS',p_in_run_server 
		from dba_views 
		where owner IN (&&2);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.dba_views failed'||sqlerrm);
	END;	

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select owner,synonym_name,table_owner,table_name,db_link,null,null,null,null,null,null,null,null,null,null,'SYNONYMS',p_in_run_server 
		from dba_synonyms 
		where owner IN (&&2);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.dba_synonyms failed'||sqlerrm);
	END;

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select owner,trigger_name,table_owner,table_name,triggering_event,trigger_type,null,null,null,null,null,null,null,null,status,'TRIGGERS',p_in_run_server
		from dba_triggers 
		where owner IN (&&2);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.dba_triggers failed'||sqlerrm);
	END;


	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select owner,job_name,null,null,null,null,null,null,null,null,null,null,null,null,state,'SCHEDULER_JOBS',p_in_run_server
		from dba_scheduler_jobs 
		where owner IN (&&2);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.dba_scheduler_jobs failed'||sqlerrm);
	END;

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select owner,name,null,queue_table,null,queue_type,null,null,null,null,null,null,null,null,ENQUEUE_ENABLED||':'||DEQUEUE_ENABLED,'QUEUES',p_in_run_server 
		from DBA_QUEUES 
		where owner IN (&&2);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.dba_queue failed'||sqlerrm);
	END;

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select owner,object_name,null,null,null,object_type,null,null,null,null,null,null,null,null,status,'RULES',p_in_run_server 
		from dba_objects 
		where owner IN (&&2)
		and object_type LIKE 'RULE%';
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.RULE failed'||sqlerrm);
	END;

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select owner,object_name,null,null,null,object_type,null,null,null,null,null,null,null,null,status,'JAVA_CLASS_DATA',p_in_run_server
		from dba_objects 
		where owner IN (&&2)
		and object_type LIKE 'JAVA%';
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.JAVA failed'||sqlerrm);
	END;

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select owner,program_name,null,null,null,program_type,null,null,null,null,null,null,null,null,enabled,'SCHD_PROGRAMS',p_in_run_server 
		from DBA_SCHEDULER_PROGRAMS 
		where owner IN (&&2);		
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.DBA_SCHEDULER_PROGRAMS failed'||sqlerrm);
	END;

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select table_owner,table_name,null,partition_name,null,null,null,null,null,null,null,null,null,null,null,'TAB_PARTITIONS',p_in_run_server
		from DBA_TAB_PARTITIONS 
		where table_owner IN (&&2);		
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.DBA_TAB_PARTITIONS failed'||sqlerrm);
	END;

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select index_owner,index_name,null,partition_name,null,null,null,null,null,null,null,null,null,null,status,'INDEX_PARTITIONS',p_in_run_server
		from DBA_IND_PARTITIONS 
		where index_owner IN (&&2);		
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.DBA_IND_PARTITIONS failed'||sqlerrm);
	END;

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select owner,name,null,null,null,type,null,count(line),null,null,null,null,null,null,null,'CODE_LINE_COUNT',p_in_run_server 
		from dba_source 
		where owner IN (&&2)
		group by owner,name,type;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20003,'INSERT into t_object_sanity.dba_source failed'||sqlerrm);
	END;	
	
	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		SELECT owner,object_name,NULL,subobject_name,NULL,object_type,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,status,'INVALID_OBJECT',p_in_run_server FROM dba_objects WHERE status='INVALID'
		AND owner IN (&&2);
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.invalid_object failed'||sqlerrm);
	END;	

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		select null,patch_id,NULL,null,NULL,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,status,'ORA_PATCH',p_in_run_server
		from dba_registry_sqlpatch;
	EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.patch_details failed'||sqlerrm);
	END;	
	
	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server)
		SELECT inst_id,name,null,DISPLAY_VALUE,DEFAULT_VALUE,value,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,null,'DB_PARAMS',p_in_run_server
		FROM gv$parameter WHERE isdefault = 'FALSE';
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.DB_PARAMS failed'||sqlerrm);
	END;	

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server,f_text)
		SELECT owner,db_link,username,null,null,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,null,'DB_LINK',p_in_run_server,host
		FROM dba_db_links;
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.db_links failed'||sqlerrm);
	END;
	

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server,f_text)
		--SELECT name,null,null,null,null,value,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,status,'SQL_PROFILES',p_in_run_server,to_char(regexp_replace(replace(substr(sql_text,1,500),chr(10),''),' +', ' '))
		SELECT name,null,null,null,null,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,status,'SQL_PROFILES',p_in_run_server,null
		FROM dba_sql_profiles;
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.sql_profiles failed'||sqlerrm);
	END;	
	
	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server,f_text)
		SELECT role,password_required,AUTHENTICATION_TYPE,common,oracle_maintained,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,null,'ROLES',p_in_run_server,null
		FROM dba_roles;
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.dba_roles failed'||sqlerrm);
	END;	

	
	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server,f_text)
		SELECT username,profile,PASSWORD_VERSIONS,null,null,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,account_status,'USERS',p_in_run_server,null
		FROM dba_users where username in (&&2);
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.dba_users failed'||sqlerrm);
	END;	

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server,f_text)
		SELECT grantee,granted_role,admin_option,null,null,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,null,'ROLE_PRIVS',p_in_run_server,null
		FROM dba_role_privs;
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.dba_role_privs failed'||sqlerrm);
	END;
	
	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server,f_text)
		SELECT grantee,PRIVILEGE,admin_option,null,null,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,null,'SYS_PRIVS',p_in_run_server,null
		FROM dba_sys_privs;
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.dba_sys_privs failed'||sqlerrm);
	END;	

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server,f_text)
		select owner,table_name,num_rows,null,null,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,null,'TABLE_STATS',p_in_run_server,null
		from
		(select s.owner, s.table_name, 
		decode(nvl(s.num_rows,0),0,0, s.num_rows) num_rows
		from dba_tables s
		where s.owner in (&&2));
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.table_stats failed'||sqlerrm);
	END;
	
	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server,f_text)
		select owner,table_name,null,null,column_name,bytes,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,null,'LOB_OBJECTS',p_in_run_server,null
		from (
		select l.owner, l.table_name, l.column_name, sum(sg.bytes) bytes 
		from dba_lobs l, dba_segments sg 
		where l.owner=sg.owner and l.segment_name=sg.segment_name 
		and l.owner in (&&2)
		group by l.owner,l.table_name,l.column_name);
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.lob_objects failed'||sqlerrm);
	END;	

	BEGIN
		insert into t_object_sanity( f_owner,f_object_name,f_sub_obj_owner,f_sub_object_name,f_attribute_name,f_attribute_type,f_position_id,f_count,f_min_value,f_max_value,f_increment_by,f_cycle_flag,f_cache_size,f_last_number,f_status,f_catagory_type,f_run_server,f_text)
		select profile,resource_name,limit,null,null,null,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,null,'USER_PROFILES',p_in_run_server,null
		from dba_profiles;
		EXCEPTION
		WHEN OTHERS THEN
			raise_application_error(-20004,'INSERT into t_object_sanity.user_profiles failed'||sqlerrm);
	END;
	
	commit;

end;
/



