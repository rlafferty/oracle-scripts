--prompt Running DBMS_SQLTUNE.REPORT_SQL_MONITOR for SID &3....
SELECT
	DBMS_SQLTUNE.REPORT_SQL_MONITOR(   
	   &3=>&4,   
	   report_level=>'&1',
	   type => '&2') as report   
FROM dual
/
