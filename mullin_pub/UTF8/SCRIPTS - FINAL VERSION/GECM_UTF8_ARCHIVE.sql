-- Archives Processed Records
Insert into GESSS.GECM_UTF8_SCAN_ARCHIVE
	   (select a.*
	    from GESSS.GECM_UTF8_SCAN_ERRORS a
		Where a.processed_flag is not null
		and not exists (select b.ge_row_id
	  			  	   from GESSS.GECM_UTF8_SCAN_ARCHIVE b 
				  	   where a.ge_row_id = b.ge_row_id
				  	   and	a.table_name = b.table_name
				  	   and	a.column_name = b.column_name
					   and	a.processed_date = b.processed_date
					   and  a.scan_run_id  = b.scan_run_id))

					   commit
					   
-- Removes Archived Records from Scan Errors					   
Delete GESSS.GECM_UTF8_SCAN_ERRORS a
Where a.processed_flag is not null
and exists (select b.ge_row_id
	  		from GESSS.GECM_UTF8_SCAN_ARCHIVE b 
			where a.ge_row_id = b.ge_row_id
			and	a.table_name = b.table_name
			and	a.column_name = b.column_name
			and	a.processed_date = b.processed_date
			and a.scan_run_id  = b.scan_run_id)


Update GESSS.GECM_UTF8_SCAN_ARCHIVE
	   set original_text = null
	   Where Original_text is not null
	   
	   
					   

commit

-- Updates Records that no longer exist in Current Scan
update gecm_utf8_scan_errors b
set processed_flag = 'X', status_message = status_message||'ROWID NO LONGER IN SCAN.ERR'
	,processed_date = sysdate
where not exists (select id$
	  			  from csmig.csm$errors 
				  where id$ = b.ge_row_id)
and b.processed_flag is null

commit