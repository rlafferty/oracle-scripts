/* Formatted on 3/8/2013 9:52:50 AM (QP5 v5.215.12089.38647) */
SELECT 'drop table ' || owner || '.' || segment_name || ' purge;'
  FROM (  SELECT owner,
                 segment_name,
                 segment_type,
                 bytes / 1024 / 1024 "MB"
            FROM dba_segments
           WHERE     tablespace_name = 'EXA_DATA'
                 AND SEGMENT_NAME LIKE '%_BKP%'
                 AND OWNER = 'GET_FINREPT'
        ORDER BY bytes DESC);

SELECT 'truncate table ' || OWNER || '.' || OBJECT_NAME || ';'
  FROM dba_objects
 WHERE OWNER = 'GETS_UTF8' AND OBJECT_NAME LIKE '%_BKP%';

SELECT COUNT (0) FROM JAROSODS.MSC_ITEM_CATEGORIES_ODW;