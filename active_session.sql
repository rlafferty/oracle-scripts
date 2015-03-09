-- -----------------------------------------------------------------------------------
-- File Name    : http://oracle-base.com/dba/monitoring/sessions_rac.sql
-- Author       : Tim Hall
-- Description  : Displays information on all database sessions for whole RAC.
-- Requirements : Access to the V$ views.
-- Call Syntax  : @sessions_rac
-- Last Modified: 21/02/2005
-- -----------------------------------------------------------------------------------
SET LINESIZE 300
SET PAGESIZE 1000

COLUMN username FORMAT A15
COLUMN osuser FORMAT A15
COLUMN session_detail FORMAT A15
COLUMN machine FORMAT A25
COLUMN module FORMAT A25
COLUMN program FORMAT A20
COLUMN logon_time FORMAT A20

SELECT NVL(s.username, '(oracle)') AS username,
       s.osuser,
       s.sid||','||s.serial#||',@'||s.inst_id as session_detail,
 	   s.lockwait,
       s.status,
       substr(s.module, 1, 25) as module,
       substr(s.machine, 1,25) as machine,
       substr(s.program, 1, 20) as program,
       TO_CHAR(s.logon_Time,'DD-MON-YYYY HH24:MI:SS') AS logon_time
FROM   gv$session s,
       gv$process p
WHERE  s.paddr   = p.addr
AND    s.inst_id = p.inst_id
AND    s.status = 'ACTIVE'
AND    s.type != 'BACKGROUND'
ORDER BY s.username, s.osuser;

SET PAGESIZE 14