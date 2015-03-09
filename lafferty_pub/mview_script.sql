REM LOCATION:   Object Management\Materialized Views and Materialized View Logs
REM FUNCTION:   Extract DDL for existing Mview and dependent Mview Logs
REM TESTED ON:  10.2.0.3, 11.1.0.6
REM PLATFORM:   non-specific
REM REQUIRES:   dbms_metadata
REM

REM  This is a part of the Knowledge Xpert for Oracle Administration library.
REM  Copyright (C) 2008 Quest Software
REM  All rights reserved.
REM

REM ******************** Knowledge Xpert for Oracle Administration ********************
UNDEF ENTER_MVIEW_OWNER
UNDEF ENTER_MVIEW_NAME
SET serveroutput on
SET feedback off
UNDEF v_sql

DECLARE
   v_task_name       VARCHAR2 (100);
   v_mview_owner     VARCHAR2 (30)   := UPPER ('&&ENTER_MVIEW_OWNER');
   v_mview_name      VARCHAR2 (30)   := UPPER ('&&ENTER_MVIEW_NAME');
   v_mview_sql       VARCHAR2 (4000);
   v_mview_log_sql   VARCHAR2 (4000);
BEGIN
   -- get mview text from data dictionary
   SELECT DBMS_METADATA.get_ddl ('MATERIALIZED_VIEW', mview_name, owner)
     INTO v_mview_sql
     FROM dba_mviews
    WHERE owner = v_mview_owner AND mview_name = v_mview_name;

   SELECT DBMS_METADATA.get_dependent_ddl ('MATERIALIZED_VIEW_LOG',
                                           referenced_name,
                                           referenced_owner
                                          )
     INTO v_mview_log_sql
     FROM dba_dependencies
    WHERE referenced_type = 'TABLE'
      AND referenced_name != v_mview_name
      AND owner = v_mview_owner
      AND NAME = v_mview_name;

   DBMS_OUTPUT.put_line ('MVIEW SQL Is: ' || v_mview_sql);
   DBMS_OUTPUT.put_line ('MVIEW LOG SQL Is: ' || v_mview_log_sql);
EXCEPTION
   WHEN OTHERS
   THEN
      NULL;
END;
/