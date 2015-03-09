WITH HIERARCHY_ERRORS
     AS (    SELECT /*+ MATERIALIZE */
                   DISTINCT CONNECT_BY_ROOT c.REQUEST_ID AS TOP_LEVEL
               FROM applsys.fnd_concurrent_requests c
              WHERE STATUS_CODE IN ('D', 'E', 'S', 'T', 'X', 'R')
         CONNECT BY PRIOR c.REQUEST_ID = c.PARENT_REQUEST_ID
         START WITH c.PARENT_REQUEST_ID = -1),
     HIERARCHY_DATA
     AS (           SELECT ROWNUM AS HROWNUM,
                           LEVEL AS HLEVEL,
                           LPAD (' ', 3 * LEVEL, ' ') || REQUEST_ID AS REQUEST_PATH,
                           CONNECT_BY_ROOT c.REQUEST_ID AS TOP_LEVEL,
                           c.request_id,
                           c.parent_request_id,
                           TRUNC (c.request_date) AS REQUEST_DATE,
                           FLOOR (
                              (c.actual_completion_date - c.actual_start_date) * 24 * 60)
                              AS elapsed_minutes,
                           c.actual_start_date,
                           c.actual_completion_date,
                           TO_CHAR (c.actual_start_date, 'DD-MON-YYYY') run_start_date,
                           TO_CHAR (c.actual_start_date, 'HH24:MI:SS') run_start_time,
                           TO_CHAR (c.actual_completion_date, 'DD-MON-YYYY')
                              run_end_date,
                           TO_CHAR (c.actual_completion_date, 'HH24:MI:SS') run_end_time, -- NEED ELAPSED TIME CALCULATION
                           p.user_concurrent_program_name,
                           u.user_name requested_by_user,
                           c.STATUS_CODE,
                           c.PHASE_CODE,
                           r.responsibility_name,
                           c.completion_text,
                           c.logfile_name,
                           c.logfile_node_name,
                           c.outfile_name,
                           c.outfile_node_name,
                           c.CONCURRENT_PROGRAM_ID
                      FROM applsys.fnd_concurrent_requests c,
                           apps.fnd_concurrent_programs_vl p,
                           apps.fnd_user u,
                           apps.fnd_responsibility_vl r
                     WHERE     p.concurrent_program_id = c.concurrent_program_id
                           AND p.application_id = c.program_application_id
                           AND u.user_id = c.requested_by
                           AND r.responsibility_id = c.responsibility_id
                           AND r.responsibility_name = 'Advanced Supply Chain Planner'
                           AND c.request_date > SYSDATE - 30
                CONNECT BY PRIOR c.REQUEST_ID = c.PARENT_REQUEST_ID
                START WITH c.PARENT_REQUEST_ID = -1
         ORDER SIBLINGS BY c.REQUEST_ID, c.REQUEST_DATE)
  SELECT ROUND (
            AVG (
               FLOOR ( (actual_completion_date - actual_start_date) * 24 * 60))
            OVER (PARTITION BY CONCURRENT_PROGRAM_ID),
            1)
            AVERAGE_RUN_TIME,
         A.ELAPSED_MINUTES,
         A.HLEVEL,
         a.REQUEST_PATH,
         A.REQUEST_ID,
         A.REQUEST_DATE,
         USER_CONCURRENT_PROGRAM_NAME,
         STATUS_CODE
    FROM HIERARCHY_DATA a
   WHERE TOP_LEVEL NOT IN (SELECT TOP_LEVEL FROM HIERARCHY_ERRORS)
ORDER BY A.HROWNUM;