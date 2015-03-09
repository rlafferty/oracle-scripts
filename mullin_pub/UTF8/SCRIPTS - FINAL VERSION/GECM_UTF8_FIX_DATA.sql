-- ***************************************************************************************
-- Procedure : GECM_UTF8_FIX_DATA
-- Description : This procedure updates the base table with the corrected REVISED_TEXT from gecm_utf8_scan_errors 
-- 			   	 using dynamic sql. The cursor selects records from gecm_utf8_scan_errors where revised_text is
--				 not null and processed flag = 'I'.
--				 Valid Values for Processed_flag are 'I' - In process
--				 	   		  	  				 	 'N' - Don't Process
--													 'E' - Errored
--													 'P' - Processed.
--													 'D' - Errored record was deleted form Base Table.
--													 'X' - Errored no longer exists in current scanner run.
--													 'U' - Revised text needs to be converted to UPPER.
--													 'O' - Oracle Dev needs to supply fix.
--													 'T' - Type 1 errors Column Width 
--				The value of 'I' will be assigned to tables where it is not feasible for us to be correcting the 
--				data in this manner. For example ICX_POR_ITEMS_TL we need to fix the source data in core apps and 
--				update the record so that the Extractor maintains the appropriate values like the intermedia index
--				columns.
--
-- Created By: Matt & Mike Mullin
-- Creation Date: 12-04-01
-- History:
--
-- Modified Date  		   		 Description
-- ================				 ===========================================================
--  04-Jan-02 Mike Mullin 		 Found bug in script dynamic sql was causing error:
--								 ORA-01427: single-row subquery returns more than one row.
--								 need to add check for scan_err# = 2 in cursor get_fixes.
--								 also needed to add check for scan_err# = recs.scna_err# to
--								 the subquery in dynamic sql.
--
DECLARE
l_sql varchar2(2000);
cursor_id integer;
result integer;
error_mesg varchar2(150);
counter  Number := 0;
v_user_id Number;
cursor get_fixes is 
select a.obj#, a.column_name, a.owner,a.table_name,a.GE_ROW_ID,a.LANG,a.last_update_date,
a.revised_text, a.scan_run_id, a.scan_err#
From gesss.GECM_UTF8_SCAN_ERRORS a
Where a.REVISED_TEXT is not null
and	  a.PROCESSED_FLAG = 'I'
and   a.scan_err# = 2;
BEGIN
dbms_output.enable(1000000);
dbms_output.put_line('AT BEGIN '||to_char(SYSDATE,'DD-MON-RRRR HH24:MM:SS'));
Select u.USER_ID
into v_user_id
from fnd_user u
where u.USER_NAME = 'APPSSSS';
cursor_id:=dbms_sql.open_cursor;
FOR recs in get_fixes LOOP
  Begin
  if recs.last_update_Date is not null Then
  l_sql := 'Update '||recs.owner||'.'||recs.table_name||' SET last_update_date = sysdate , last_updated_by = '||v_user_id||' , '||recs.column_name||' = (Select revised_text from gesss.gecm_utf8_scan_errors where GE_ROW_ID ='||''''||recs.ge_row_id||''''||' and table_name = '||''''||recs.table_name||''''||' and scan_err# = '||to_char(recs.scan_err#)||' and column_name = '||''''||recs.column_name||''''||' )'||' Where rowid = '||''''||recs.GE_ROW_ID||'''';
  else
  l_sql := 'Update '||recs.owner||'.'||recs.table_name||' SET '||recs.column_name||' = (Select revised_text from gesss.gecm_utf8_scan_errors where GE_ROW_ID ='||''''||recs.ge_row_id||''''||' and table_name = '||''''||recs.table_name||''''||' and scan_err# = '||to_char(recs.scan_err#)||' and column_name = '||''''||recs.column_name||''''||' )'||' Where rowid = '||''''||recs.GE_ROW_ID||'''';
  end if;
	  dbms_sql.parse(cursor_id,l_sql,1);
      result := dbms_sql.execute(cursor_id);
   commit;
      Begin
			UPDATE gesss.GECM_UTF8_SCAN_ERRORS SET processed_flag = 'P', original_text = null,
				   							       processed_date = sysdate
			WHERE GE_ROW_ID = recs.GE_ROW_ID and
			TABLE_NAME 		= recs.table_name and
			COLUMN_NAME		= recs.column_name and
			scan_run_id 	= recs.scan_run_id and
			scan_err#		= recs.scan_err#;
			COMMIT;
      EXCEPTION
   			WHEN OTHERS THEN
			error_mesg := sqlerrm;
			dbms_output.put_line('WHEN OTHERS EXCEPTION Update Scan Errors :'||recs.ge_row_id);
			dbms_output.put_line(error_mesg);
			dbms_output.put_line(substr(l_sql,1,255));
			dbms_output.put_line(substr(l_sql,256,255));
			UPDATE gesss.GECM_UTF8_SCAN_ERRORS SET STATUS_MESSAGE = error_mesg, processed_flag = 'E',
							   							       processed_date = sysdate
			WHERE GE_ROW_ID = recs.GE_ROW_ID and
			TABLE_NAME 		= recs.table_name and
			COLUMN_NAME		= recs.column_name and
			scan_run_id 	= recs.scan_run_id and
			scan_err#		= recs.scan_err#;
			COMMIT;
   END;
   EXCEPTION
   			WHEN OTHERS THEN
			error_mesg := sqlerrm;
			dbms_output.put_line('WHEN OTHERS EXCEPTION Dynamic SQL:'||recs.ge_row_id);
			dbms_output.put_line(error_mesg);
			dbms_output.put_line(substr(l_sql,1,255));
			dbms_output.put_line(substr(l_sql,256,255));
			UPDATE gesss.GECM_UTF8_SCAN_ERRORS SET STATUS_MESSAGE = error_mesg, processed_flag = 'E'
			WHERE GE_ROW_ID = recs.GE_ROW_ID and
			TABLE_NAME 		= recs.table_name and
			COLUMN_NAME		= recs.column_name and
			scan_run_id 	= recs.scan_run_id and
			scan_err#		= recs.scan_err#;
			COMMIT;
   END;
END LOOP;
dbms_output.put_line('At End of Fixing Content '||to_char(SYSDATE,'DD-MON-RRRR HH24:MM:SS'));
COMMIT;
dbms_sql.close_cursor(cursor_id);
dbms_output.put_line('Finished '||to_char(SYSDATE,'DD-MON-RRRR HH24:MM:SS'));
 EXCEPTION
	WHEN OTHERS THEN
	dbms_output.put_line('WHEN OTHERS EXCEPTION AT END');
	dbms_output.put_line(sqlerrm);
	dbms_sql.close_cursor(cursor_id);
END;
