--- TABLE AND OBJECT COUNTS 

 SELECT obj.OWNER AS SCHEMA,
         COUNT (0) AS "OBJECT COUNT",
         (SELECT COUNT (0)
            FROM dba_tables
           WHERE owner = obj.owner)
            AS "TABLE COUNT"
    FROM DBA_OBJECTS obj
   WHERE     OWNER IN
                (SELECT USERNAME
                   FROM DBA_USERS
                  WHERE     DEFAULT_TABLESPACE NOT LIKE 'SYS%'
                        AND DEFAULT_TABLESPACE NOT IN
                               ('USERS', 'CWMLITE_DATA', 'TOOLS'))
         AND OWNER NOT LIKE 'SSO%'
GROUP BY OWNER
ORDER BY 1;

--- DATABASE SIZE

col "Database Size" format a20 
col "Free space" format a20 
select round(sum(used.bytes) / 1024 / 1024 ) || ' MB' "Database Size" 
,      round(free.p / 1024 / 1024) || ' MB' "Free space" 
from (select bytes from v$datafile 
      union all 
      select bytes from v$tempfile 
      union all 
      select bytes from v$log) used 
,    (select sum(bytes) as p from dba_free_space) free 
group by free.p 
/