-- ----------------------------------------------------------------------------
-- |--------------------------- < GECM_ENDDATE_POXML> ---------------------------|
-- ----------------------------------------------------------------------------
--
--PROCEDURE GECM_ENDDATE_POXML IS 
--
--
--  This Procedure End Dates POXML workflows due to Oracle Bug
--
--	Created By  : Matthew J. Mullin		Creation Date  : 08-16-2004 
--	Updated By  : Matthew J. Mullin		Update Date    : 08-16-2004 
--
--	History 
--		115.1		Original Script
--
--
-- Variables 
--
DECLARE
	v_count		 		NUMBER 	   		:= 0;
	v_wias_count		NUMBER			:= 0;
	v_wi_count			NUMBER			:= 0;
	v_run_msg			VARCHAR2(80) 	:='Start of GECM_ENDDATE_POXML';
	v_error_msg			VARCHAR2(80) 	:= null;
--
	Cursor enddate_poxml is 
	select wias.item_type, wias.item_key, wias.process_activity, wias.activity_status, wias.begin_date, wias.end_date, wias.notification_id
	from wf_item_activity_statuses wias, wf_item_activity_statuses wias2, wf_process_activities wpa
	where wias.item_type = 'POXML'
	and	  wias.item_type = 'POXML'	
	and   wias.item_key = wias2.item_key
	and	  wias2.process_activity = wpa.instance_id
	and	  wpa.PROCESS_ITEM_TYPE = 'POXML'
	AND   wpa.PROCESS_NAME = 'POXMLSETUP'
	AND   wpa.ACTIVITY_ITEM_TYPE = 'WFSTD'
	AND   wpa.ACTIVITY_NAME = 'END'
	AND   wpa.START_END IS NULL
	and	  wias2.end_date is not null
	and	  wias2.activity_status = 'COMPLETE'
	and	  wias.end_date is null;
	--
--
BEGIN
  --
  dbms_output.enable(200000);
  --
	  BEGIN
	  --
		v_run_msg := 'Before OPENING ENDDATE_POXML CURSOR';
	  	dbms_output.put_line(rpad(v_run_msg,60) ||'--'||to_char(sysdate,'mm/dd/rr hh:mi:ss'));
	  	dbms_output.put_line('----------------------------------------');
  	  	--
		 For recs in enddate_poxml Loop
		--
			v_count := v_count +1;
			--
			v_run_msg := 'Processing Item_Key '||recs.ITEM_KEY;
			--
			UPDATE WF_ITEM_ACTIVITY_STATUSES
			SET END_DATE = BEGIN_DATE + 7 ,
			ACTIVITY_STATUS = 'COMPLETE'
			WHERE ITEM_TYPE = recs.ITEM_TYPE
			AND ITEM_KEY = recs.ITEM_KEY
			AND PROCESS_ACTIVITY = recs.PROCESS_ACTIVITY
			AND ACTIVITY_STATUS = recs.ACTIVITY_STATUS;
			--
			v_wias_count := v_wias_count + SQL%ROWCOUNT;
			--
			UPDATE WF_ITEMS
			SET END_DATE = BEGIN_DATE +7
			WHERE ITEM_TYPE = recs.ITEM_TYPE
			AND ITEM_KEY = recs.ITEM_KEY
			AND ROOT_ACTIVITY = 'POXMLSETUP';
			--
			v_wi_count := v_wi_count + SQL%ROWCOUNT;
			--
			If v_count > 1000 Then
				COMMIT;
				dbms_output.put_line(v_count||' Item Keys Updated');
				dbms_output.put_line(' ');
				v_count := 0;
  	  		End IF;
			--
 		End Loop;
		--
		COMMIT;
		dbms_output.put_line(v_count||' Item Keys Updated');
		dbms_output.put_line(' ');
		v_count := 0;
		--
		dbms_output.put_line('Records Update in WF_ITEMS: '||v_wi_count);
		dbms_output.put_line(' ');
		dbms_output.put_line('Records Update in WF_ITEM_ACTIVITY_STATUSES: '||v_wias_count);
		dbms_output.put_line(' ');
		--
		EXCEPTION
			WHEN OTHERS THEN
	  			dbms_output.put_line(rpad('When Others Exception Encountered',60) ||'--'||sysdate);
 	  			v_error_msg := TO_CHAR(SQLCODE) || SQLERRM;
 	  			dbms_output.put_line(rpad(v_run_msg,100) ||'-----'||v_error_msg);
				dbms_output.put_line('----------------------------------------');
		--
	  END;
	  --
  v_run_msg := 'End of GECM_ENDDATE_POXML';
  dbms_output.put_line(rpad(v_run_msg,60) ||'--'||to_char(sysdate,'mm/dd/rr hh:mi:ss'));
  dbms_output.put_line(' ');
  --
  EXCEPTION
	WHEN OTHERS THEN
	  	dbms_output.put_line(rpad('When Others Exception Encountered',60) ||'--'||sysdate);
 	  	v_error_msg := TO_CHAR(SQLCODE) || SQLERRM;
 	  	dbms_output.put_line(rpad(v_run_msg,60) ||'-----'||v_error_msg);
END; -- GECM_ENDDATE_POXML;
--
/
