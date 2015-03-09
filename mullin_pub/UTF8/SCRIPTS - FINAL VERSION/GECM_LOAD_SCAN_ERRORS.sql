-- ***************************************************************************************
-- Procedure : GECM_LOAD_SCAN_ERRORS 
-- Description : This procedure takes the errrored records create via the CSSCAN process and 
-- 			   	 loads them into the interim table gecm_utf8_scan_errors.
--
-- Created By: Matt & Mike Mullin
-- Creation Date: 11-30-01
-- History:
--
-- Modified Date  		   		 Description
-- ================				 ===========================================================
--  31-Jan-01					 Added logic to insert records into Scan Headers table and 
--								 populate scan_run_id.
--
--	11-fEB-02					 Added logic to only pick-up Standard Who Columns with the correct
--								 data types of Date and Number
--
DECLARE
l_sql varchar2(2000);
cursor_id integer;
result integer;
error_mesg varchar2(150);
counter  Number := 0;
std_who_chk		Varchar2(1) := 'N';
std_who_cnt		Number := 0;
v_scan_run_id		   number;
v_create_time		   date;
cursor get_errs is 
select t.obj#, u.NAME OWNER, t.NAME Table_name , c.NAME Col_name ,  e.ID$ GE_ROW_ID,
decode(substr(t.name,-3,3),'_TL','Y','N') GET_LANG , e.err#
from sys.obj$ t, sys.col$ c, sys.user$ u , csmig.csm$errors e 
where t.OWNER# = u.USER# and
	  t.OBJ# = c.OBJ# and 
	  t.OBJ# = e.OBJ# and 
	  c.COL# =  e.COL# and 
	  t.TYPE# = 2	 and 
	  t.name  != 'GECM_UTF8_SCAN_ERRORS'; 
cursor get_obj(p_scan_run_id in number) is
select a.scan_run_id,a.obj#, a.column_name, a.owner,a.table_name,a.GE_ROW_ID,a.LANG
From gesss.GECM_UTF8_SCAN_ERRORS a
where a.scan_run_id = p_scan_run_id;
BEGIN
dbms_output.enable(2000000);
Select gesss.GECM_SCAN_RUN_ID_S.nextval
into v_scan_run_id
from dual;
dbms_output.put_line('AT BEGIN '||to_char(SYSDATE,'DD-MON-RRRR HH24:MM:SS')||'Scan Run Id: '||to_char(v_scan_run_id));
dbms_output.put_line(' INSERTING Scan Header Record '||to_char(SYSDATE,'DD-MON-RRRR HH24:MM:SS'));
Begin 
Insert Into gesss.gecm_UTF8_SCAN_HEADERS(SCAN_RUN_ID,CREATION_DATE)
(Select v_scan_run_id, sysdate from DUAL);	 
		Exception When Others Then 
 		   	error_mesg := sqlerrm;
			dbms_output.put_line('WHEN OTHERS EXCEPTION Inserting Header Records !!');
			dbms_output.put_line(error_mesg);
End; -- Insert Scan Header Records.
Begin 
Insert Into gesss.gecm_UTF8_SCAN_PARAMS(SCAN_RUN_ID,NAME,VALUE)
(Select v_scan_run_id, name, value from CSM$PARAMETERS);	 
		Exception When Others Then 
 		   	error_mesg := sqlerrm;
			dbms_output.put_line('WHEN OTHERS EXCEPTION Inserting Parameter Records !!');
			dbms_output.put_line(error_mesg);
End; -- Insert Scan Params Records.
dbms_output.put_line(' INSERTING ERRORS from CSM$ERRORS '||to_char(SYSDATE,'DD-MON-RRRR HH24:MM:SS'));
Begin
  for r in get_errs Loop
    Begin
  	  Insert into GESSS.GECM_UTF8_SCAN_ERRORS(SCAN_RUN_ID,OWNER,TABLE_NAME,COLUMN_NAME,GE_ROW_ID,LANG,OBJ#,SCAN_ERR#)
	  		 	  	Values(v_scan_run_id,r.OWNER, r.Table_name , r.Col_name ,  r.GE_ROW_ID, r.GET_LANG, r.obj#, r.err#);
	 Exception When Others Then 
 		   	error_mesg := sqlerrm;
			dbms_output.put_line('WHEN OTHERS EXCEPTION Inserting Err Records :'||to_char(v_scan_run_id)||r.OWNER||','||r.Table_name||','||r.Col_name||','||r.GE_ROW_ID||','||r.GET_LANG);
			dbms_output.put_line(error_mesg);
	End; -- Insert Error Records.
	 counter := counter + 1;
	 If mod(counter,200)= 0 Then 
	 	commit;
		counter := 0;
	 End if;
  End Loop;
     commit;
	 counter := 0;
 Exception When Others Then 
 		   	error_mesg := sqlerrm;
			dbms_output.put_line('WHEN OTHERS EXCEPTION Building Err Records :');
			dbms_output.put_line(error_mesg);
 End; -- Build Error Records 
 dbms_output.put_line(' Finished INSERTING ERRORS from CSM$ERRORS '||to_char(SYSDATE,'DD-MON-RRRR HH24:MM:SS'));
cursor_id:=dbms_sql.open_cursor;
BEGIN
dbms_output.put_line('Started Looking up Content '||to_char(SYSDATE,'DD-MON-RRRR HH24:MM:SS'));
FOR obj_rec in get_obj(v_scan_run_id) LOOP
  Begin
	 select 'Y' STD_WHO_CHK, count(c.name) STD_WHO_COUNT
	 Into std_who_chk, std_who_cnt
	 from sys.obj$ t, sys.col$ c, sys.user$ u  
	 where t.OWNER# = u.USER# and
	 	   t.OBJ# = c.OBJ# and 
	  	   t.TYPE# = 2 and 
	  	   t.obj# = obj_rec.obj# and 
	  	   c.name in ('CREATION_DATE','CREATED_BY','LAST_UPDATE_DATE','LAST_UPDATED_BY') AND
		   C.TYPE# IN (2,12) ; 		   
	EXCEPTION When NO_DATA_FOUND Then 
			   std_who_chk := 'N';
			   std_who_cnt := 0;
			   When Others Then 
			   		error_mesg := sqlerrm;
					dbms_output.put_line('WHEN OTHERS EXCEPTION Std Who Check :'||obj_rec.ge_row_id);
					dbms_output.put_line(error_mesg);
					dbms_output.put_line(substr(l_sql,1,255));
					dbms_output.put_line(substr(l_sql,256,255));
					UPDATE gesss.GECM_UTF8_SCAN_ERRORS SET STATUS_MESSAGE = error_mesg
					WHERE GE_ROW_ID = obj_rec.GE_ROW_ID and
					TABLE_NAME 		= obj_rec.table_name and
					COLUMN_NAME		= obj_rec.column_name and
					SCAN_RUN_ID		= obj_rec.scan_run_id;
					COMMIT;
   END;			   
if (obj_rec.LANG = 'Y'and std_who_chk = 'Y' and std_who_cnt = 4) Then 
l_sql := 'Update GESSS.GECM_UTF8_SCAN_ERRORS SET (LANG,STATUS_MESSAGE,creation_date,created_by,last_update_date,last_updated_by,ORIGINAL_TEXT) = (Select LANGUAGE,null,creation_date,created_by,last_update_date,last_updated_by,'||obj_rec.column_name||' From '||obj_rec.owner||'.'||obj_rec.table_name||' Where rowid = '||''''||obj_rec.GE_ROW_ID||''''||') Where table_name = '||''''||obj_rec.table_name||''''||' and column_name = '||''''||obj_rec.column_name||''''||' and GE_ROW_ID = '||''''||obj_rec.ge_row_id||'''';
Elsif (obj_rec.LANG = 'Y'and std_who_chk = 'Y' and std_who_cnt != 4)Then 
l_sql := 'Update GESSS.GECM_UTF8_SCAN_ERRORS SET (LANG,STATUS_MESSAGE,creation_date,created_by,last_update_date,last_updated_by,ORIGINAL_TEXT) = (Select LANGUAGE,null,null,null,null,null,'||obj_rec.column_name||' From '||obj_rec.owner||'.'||obj_rec.table_name||' Where rowid = '||''''||obj_rec.GE_ROW_ID||''''||') Where table_name = '||''''||obj_rec.table_name||''''||' and column_name = '||''''||obj_rec.column_name||''''||' and GE_ROW_ID = '||''''||obj_rec.ge_row_id||'''';
Elsif (obj_rec.LANG = 'Y'and std_who_chk = 'N') Then
l_sql := 'Update GESSS.GECM_UTF8_SCAN_ERRORS SET (LANG,STATUS_MESSAGE,creation_date,created_by,last_update_date,last_updated_by,ORIGINAL_TEXT) = (Select LANGUAGE,null,null,null,null,null,'||obj_rec.column_name||' From '||obj_rec.owner||'.'||obj_rec.table_name||' Where rowid = '||''''||obj_rec.GE_ROW_ID||''''||') Where table_name = '||''''||obj_rec.table_name||''''||' and column_name = '||''''||obj_rec.column_name||''''||' and GE_ROW_ID = '||''''||obj_rec.ge_row_id||'''';
Elsif  (obj_rec.LANG = 'N'and std_who_chk = 'Y' and std_who_cnt = 4) Then 
l_sql := 'Update GESSS.GECM_UTF8_SCAN_ERRORS SET (LANG,STATUS_MESSAGE,creation_date,created_by,last_update_date,last_updated_by,ORIGINAL_TEXT) = (Select null,null,creation_date,created_by,last_update_date,last_updated_by,'||obj_rec.column_name||' From '||obj_rec.owner||'.'||obj_rec.table_name||' Where rowid = '||''''||obj_rec.GE_ROW_ID||''''||') Where table_name = '||''''||obj_rec.table_name||''''||' and column_name = '||''''||obj_rec.column_name||''''||' and GE_ROW_ID = '||''''||obj_rec.ge_row_id||'''';
Else
l_sql := 'Update GESSS.GECM_UTF8_SCAN_ERRORS SET (LANG,STATUS_MESSAGE,creation_date,created_by,last_update_date,last_updated_by,ORIGINAL_TEXT) = (Select null,null,null,null,null,null,'||obj_rec.column_name||' From '||obj_rec.owner||'.'||obj_rec.table_name||' Where rowid = '||''''||obj_rec.GE_ROW_ID||''''||') Where table_name = '||''''||obj_rec.table_name||''''||' and column_name = '||''''||obj_rec.column_name||''''||' and GE_ROW_ID = '||''''||obj_rec.ge_row_id||'''';
--l_sql := 'Update GESSS.GECM_UTF8_SCAN_ERRORS SET (LANG,STATUS_MESSAGE, ORIGINAL_TEXT) = (Select null,null,'||obj_rec.column_name||' From '||obj_rec.owner||'.'||obj_rec.table_name||' Where rowid = '||''''||obj_rec.GE_ROW_ID||''''||') Where table_name = '||''''||obj_rec.table_name||''''||' and column_name = '||''''||obj_rec.column_name||''''||' and GE_ROW_ID = '||''''||obj_rec.ge_row_id||'''';
End if;
--dbms_output.put_line(l_sql);
  BEGIN
	  dbms_sql.parse(cursor_id,l_sql,1);
      result := dbms_sql.execute(cursor_id);
   commit;
   EXCEPTION
   			WHEN OTHERS THEN
			error_mesg := sqlerrm;
			dbms_output.put_line('WHEN OTHERS EXCEPTION :'||obj_rec.ge_row_id);
			dbms_output.put_line(error_mesg);
			dbms_output.put_line(substr(l_sql,1,255));
			dbms_output.put_line(substr(l_sql,256,255));
			UPDATE gesss.GECM_UTF8_SCAN_ERRORS SET STATUS_MESSAGE = error_mesg
			WHERE GE_ROW_ID = obj_rec.GE_ROW_ID and
			TABLE_NAME 		= obj_rec.table_name and
			COLUMN_NAME		= obj_rec.column_name and
			scan_run_id     = obj_rec.scan_run_id;
			COMMIT;
   END;
END LOOP;
dbms_output.put_line('At End of Content Load '||to_char(SYSDATE,'DD-MON-RRRR HH24:MM:SS'));
COMMIT;
END;
dbms_sql.close_cursor(cursor_id);
dbms_output.put_line('Finished '||to_char(SYSDATE,'DD-MON-RRRR HH24:MM:SS'));
 EXCEPTION
	WHEN OTHERS THEN
	dbms_output.put_line('WHEN OTHERS EXCEPTION AT END');
	dbms_output.put_line(sqlerrm);
	dbms_sql.close_cursor(cursor_id);
END;
