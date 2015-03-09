/* Formatted on 4/3/2013 2:31:11 PM (QP5 v5.215.12089.38647) */
  SELECT *
    FROM V$TRANSACTION, v$session
   WHERE v$transaction.addr = v$session.taddr
ORDER BY USED_UREC DESC;

  SELECT *
    FROM V$SESSION_LONGOPS
ORDER BY TIME_REMAINING DESC;


SELECT *
  FROM v$parameter
 WHERE NAME LIKE '%undo%';

SELECT fs.tablespace_name "Tablespace",
       (df.totalspace - fs.freespace) "Used MB",
       fs.freespace "Free MB",
       df.totalspace "Total MB",
       ROUND (100 * (fs.freespace / df.totalspace)) "Pct. Free"
  FROM (  SELECT tablespace_name, ROUND (SUM (bytes) / 1048576) TotalSpace
            FROM dba_data_files
        GROUP BY tablespace_name) df,
       (  SELECT tablespace_name, ROUND (SUM (bytes) / 1048576) FreeSpace
            FROM dba_free_space
        GROUP BY tablespace_name) fs
 WHERE     df.tablespace_name = fs.tablespace_name
       AND df.TABLESPACE_NAME LIKE 'APPS_UNDO%';

SET PAGESIZE 400
SET LINESIZE 340
COL name FOR a25
COL program FOR a50
COL username FOR a12
COL osuser FOR a12

  SELECT a.inst_id,
         a.sid,
         c.username,
         c.osuser,
         c.program,
         b.name,
         a.VALUE,
         d.used_urec,
         d.used_ublk
    FROM gv$sesstat a,
         v$statname b,
         gv$session c,
         gv$transaction d
   WHERE     a.statistic# = b.statistic#
         AND a.inst_id = c.inst_id
         AND a.sid = c.sid
         AND c.inst_id = d.inst_id
         AND c.saddr = d.ses_addr
         AND a.statistic# = 284
         AND a.VALUE > 0
ORDER BY a.VALUE DESC;

SELECT status,
       ROUND (sum_bytes / (1024 * 1024), 0) AS MB,
       ROUND ( (sum_bytes / undo_size) * 100, 0) AS PERC
  FROM (  SELECT status, SUM (bytes) sum_bytes
            FROM dba_undo_extents
        GROUP BY status),
       (SELECT SUM (a.bytes) undo_size
          FROM dba_tablespaces c
               JOIN v$tablespace b
                  ON b.name = c.tablespace_name
               JOIN v$datafile a
                  ON a.ts# = b.ts#
         WHERE c.contents = 'UNDO' AND c.status = 'ONLINE');


select status,
  round(sum_bytes / (1024*1024), 0) as MB,
  round((sum_bytes / undo_size) * 100, 0) as PERC
  from
  (
  select status, sum(bytes) sum_bytes
  from dba_undo_extents
  group by status
  ),
 (
 select sum(a.bytes) undo_size
 from dba_tablespaces c
  join v$tablespace b on b.name = c.tablespace_name
 join v$datafile a on a.ts# = b.ts#
 where c.contents = 'UNDO'
 and c.status = 'ONLINE'
 );


set pagesize 400
set linesize 140
col name for a25
col program for a50
col username for a12
col osuser for a12
SELECT a.inst_id, a.sid, c.username, c.osuser, c.program, b.name,
a.value, d.used_urec, d.used_ublk
FROM gv$sesstat a, v$statname b, gv$session c, gv$transaction d
WHERE a.statistic# = b.statistic#
AND a.inst_id = c.inst_id
AND a.sid = c.sid
AND c.inst_id = d.inst_id
AND c.saddr = d.ses_addr
AND a.statistic# = 284
AND a.value > 0
ORDER BY a.value DESC

