            select * --REPOSITORY_NAME, SUBJECT_AREA_NAME, START_TS, START_DT, START_HOUR_MIN, END_TS, END_DT, END_HOUR_MIN
            from GETS_DW_IDW.S_NQ_ACCT
            where START_TS > SYSDATE - 30
            and TOTAL_TIME_SEC < 3601
            and SAW_SRC_PATH NOT LIKE '%SOURCING PM%'
            and SUBJECT_AREA_NAME != 'ETL Status Tracking'
            and QUERY_SRC_CD = 'Report';
            
            select * from all_tab_modifications;


--------------------


/* Formatted on 12/18/2012 3:23:06 PM (QP5 v5.215.12089.38647) */
  SELECT SUBJECT_AREA_NAME,
         TO_CHAR (START_DT, 'YYYY') || '-' || TO_CHAR (START_DT, 'MON'),
         SAW_DASHBOARD_PG,
         PRESENTATION_NAME,
         AVG (CUM_DB_TIME_SEC)
    FROM GETS_DW_IDW.S_NQ_ACCT_PARTI
   WHERE     QUERY_SRC_CD = 'Report'
         AND CUM_NUM_DB_ROW > 0
         AND SAW_DASHBOARD_PG IS NULL
GROUP BY SUBJECT_AREA_NAME,
         TO_CHAR (START_DT, 'YYYY') || '-' || TO_CHAR (START_DT, 'MON'),
         PRESENTATION_NAME,
         SAW_DASHBOARD_PG;


SELECT *
  FROM (SELECT                                            --SUBJECT_AREA_NAME,
              TO_CHAR (START_DT, 'YYYY') || '-' || TO_CHAR (START_DT, 'MON')
                  AS TIME_TEST,
               SAW_DASHBOARD_PG,
               --PRESENTATION_NAME,
               SUBSTR (SAW_SRC_PATH,
                         INSTR (SAW_SRC_PATH,
                                '/',
                                -1,
                                1)
                       + 1,
                       100)
                  AS stuff,
               (TOTAL_TIME_SEC)
          FROM GETS_DW_IDW.S_NQ_ACCT
         WHERE     QUERY_SRC_CD = 'Report'
               AND CUM_NUM_DB_ROW > 0              --AND TOTAL_TIME_SEC < 1200
               AND SAW_SRC_PATH NOT LIKE '%users%' --AND SUBSTR (SAW_SRC_PATH,
               --              INSTR (SAW_SRC_PATH,
               --                    '/',
               --                   -1,
               --                   1)
               --         + 1,
               --      100) = 'Material Variance Summary'
               AND SAW_DASHBOARD_PG IS NOT NULL) PIVOT (AVG (TOTAL_TIME_SEC)
                                                 FOR TIME_TEST
                                                 IN  ('2012-JAN',
                                                     '2012-FEB',
                                                     '2012-MAR',
                                                     '2012-APR',
                                                     '2012-MAY',
                                                     '2012-JUN',
                                                     '2012-JUL',
                                                     '2012-AUG',
                                                     '2012-SEP',
                                                     '2012-OCT',
                                                     '2012-NOV',
                                                     '2012-DEC'));

  SELECT                                                  --SUBJECT_AREA_NAME,
         --        TO_CHAR (START_DT, 'YYYY') || '-' || TO_CHAR (START_DT, 'MON')
         --            AS TIME_TEST,
         SAW_DASHBOARD_PG,
         --PRESENTATION_NAME,
         SUBSTR (SAW_SRC_PATH,
                   INSTR (SAW_SRC_PATH,
                          '/',
                          -1,
                          1)
                 + 1,
                 100)
            AS stuff,
         (COUNT (0))
    FROM GETS_DW_IDW.S_NQ_ACCT
   WHERE     QUERY_SRC_CD = 'Report'
         AND CUM_NUM_DB_ROW > 0                    --AND TOTAL_TIME_SEC < 1200
         AND SAW_SRC_PATH NOT LIKE '%users%'       --AND SUBSTR (SAW_SRC_PATH,
         AND SAW_DASHBOARD_PG IS NOT NULL
GROUP BY     --TO_CHAR (START_DT, 'YYYY') || '-' || TO_CHAR (START_DT, 'MON'),
        SAW_DASHBOARD_PG,
         --PRESENTATION_NAME,
         SUBSTR (SAW_SRC_PATH,
                   INSTR (SAW_SRC_PATH,
                          '/',
                          -1,
                          1)
                 + 1,
                 100)
ORDER BY 3 DESC;