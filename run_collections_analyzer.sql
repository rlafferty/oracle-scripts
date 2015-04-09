COLUMN host_name NOPRINT NEW_VALUE hostname
SELECT host_name AS host_name from v$instance;
COLUMN instance_name NOPRINT NEW_VALUE instancename
SELECT instance_name AS instance_name from v$instance;
COLUMN sysdate NOPRINT NEW_VALUE when
select to_char(sysdate, 'YYYY-Mon-DD') AS "sysdate" from dual;

SPOOL ascp_collections_analyzer_&hostname._&instancename._&when..html

@ascp_collections_analyzer.sql
