/* Formatted on 7/2/2013 9:38:47 AM (QP5 v5.215.12089.38647) */
BEGIN
   DBMS_SQLTUNE.create_sqlset (
      sqlset_name    => 'PRFC_SA_QUERIES',
      description    => 'Proficy Related OBIEE SA queries',
      sqlset_owner   => 'SSO210054305');
END;

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name     => 'CREATE_STS_TueJul2_120854_857',
      job_type     => 'PLSQL_BLOCK',
      job_action   => 'DECLARE sqlset_cur dbms_sqltune.sqlset_cursor; bf VARCHAR2(37); BEGIN bf := q''#UPPER(SQL_ID) = ''55P86JNHDQ71X'' #''; OPEN sqlset_cur FOR SELECT VALUE(P) FROM TABLE(dbms_sqltune.select_workload_repository( ''SYSTEM_MOVING_WINDOW'', bf, NULL, NULL, NULL, NULL, 1, NULL, ''TYPICAL'')) P; dbms_sqltune.load_sqlset( sqlset_name=>''PRFC_SA_QUERIES'', populate_cursor=>sqlset_cur, load_option => ''MERGE'', update_option => ''ACCUMULATE'', sqlset_owner=>''SSO210054305''); END;',
      enabled      => TRUE);
END;

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name     => 'LOAD_STS_TueJul2_122234_267',
      job_type     => 'PLSQL_BLOCK',
      job_action   => 'DECLARE sqlset_cur dbms_sqltune.sqlset_cursor; bf VARCHAR2(34); BEGIN bf := q''#PLAN_HASH_VALUE = 1082310716 #''; OPEN sqlset_cur FOR SELECT VALUE(P) FROM TABLE( dbms_sqltune.select_cursor_cache(bf, NULL, NULL, NULL, NULL, 1, NULL, ''TYPICAL'')) P; dbms_sqltune.load_sqlset( sqlset_name=>''PRFC_SA_QUERIES'', populate_cursor=>sqlset_cur, load_option => ''MERGE'', update_option => ''ACCUMULATE'', sqlset_owner=>''SSO210054305''); END;',
      enabled      => TRUE);
END;

BEGIN
   DBMS_SCHEDULER.CREATE_JOB (
      job_name     => 'LOAD_STS_TueJul2_122554_763',
      job_type     => 'PLSQL_BLOCK',
      job_action   => 'DECLARE sqlset_cur dbms_sqltune.sqlset_cursor; bf VARCHAR2(37); BEGIN bf := q''#UPPER(SQL_ID) = ''55P86JNHDQ71X'' #''; OPEN sqlset_cur FOR SELECT VALUE(P) FROM TABLE( dbms_sqltune.select_cursor_cache(bf, NULL, NULL, NULL, NULL, 1, NULL, ''TYPICAL'')) P; dbms_sqltune.load_sqlset( sqlset_name=>''PRFC_SA_QUERIES'', populate_cursor=>sqlset_cur, load_option => ''MERGE'', update_option => ''ACCUMULATE'', sqlset_owner=>''SSO210054305''); END;',
      enabled      => TRUE);
END;

DECLARE
   l_sql_tune_task_id   VARCHAR2 (100);
BEGIN
   l_sql_tune_task_id :=
      DBMS_SQLTUNE.create_tuning_task (
         sqlset_name   => 'PRFC_SA_QUERIES',
         scope         => DBMS_SQLTUNE.scope_comprehensive,
         time_limit    => 60,
         task_name     => 'PRFC_SA_QUERIES_TUNING_TASK',
         description   => 'Tuning task for an SQL tuning set.');
   DBMS_OUTPUT.put_line ('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/

SELECT log_id,
       log_date,
       owner,
       job_name,
       status
  FROM dba_scheduler_job_log
 WHERE JOB_NAME LIKE 'LOAD_STS_TueJul2_122234_267';

SELECT owner,
       schedule_name,
       TO_CHAR (start_date, 'mm/dd/yyyy hh24:mi:ss') start_date,
       TO_CHAR (end_date, 'mm/dd/yyyy hh24:mi:ss') end_date,
       repeat_interval
  FROM dba_scheduler_schedules;

SELECT owner,
       job_name,
       session_id,
       running_instance,
       elapsed_time
  FROM dba_scheduler_running_jobs;

SELECT log_id,
       log_date,
       owner,
       job_name,
       status
  FROM dba_scheduler_job_log
 WHERE JOB_NAME LIKE 'LOAD_STS_TUEJUL2_122554_763%';


  SELECT owner,
         object_type,
         object_name,
         created,
         status
    FROM dba_objects
   WHERE object_type IN ('PROGRAM', 'JOB', 'JOB CLASS', 'SCHEDULE', 'WINDOW')
--and OBJECT_NAME like 'CREATE_STS_%'
ORDER BY object_type, OBJECT_name