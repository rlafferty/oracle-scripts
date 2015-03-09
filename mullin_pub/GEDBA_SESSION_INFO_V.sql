CREATE OR REPLACE FORCE VIEW APPS.GEDBA_SESSION_INFO_V
(SESS_SOURCE, STATUS, SERIAL#, TYPE, DB_USER, 
 CLIENT_USER, SERVER, MACHINE, MODULE, CLIENT_INFO, 
 TERMINAL, PROGRAM, OS_PROGRAM, CONNECT_TIME, LOCK_WAIT, 
 PHYSICAL_READS, BLOCK_GETS, CONSISTENT_GETS, BLOCK_CHANGES, CONSISTENT_CHANGES, 
 PROCESS, SPID, PID, SID, AUDSID, 
 ADDRESS, SQL_HASH, ACTION, LAST_CALL)
AS 
(
SELECT   'CONC MGR' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si, fnd_concurrent_processes fcp
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND fcp.process_status_code = 'A'
   AND fcp.oracle_process_id = p.pid
UNION ALL
SELECT   'CONC REQUESTS' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND (s.ACTION = 'Concurrent Request'
   OR  s.MODULE like 'SVC:GSM%')
UNION ALL
SELECT   'BACKGROUND' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND (s.TYPE = 'BACKGROUND'
   OR S.PROGRAM LIKE '%QMN%'
   OR S.PROGRAM LIKE '%CJQ%')
UNION ALL
SELECT   'DB JDBC' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si, v$instance vi
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND upper(s.machine) = upper(vi.host_name)
   AND S.PROGRAM = 'JDBC Thin Client'
   AND s.MODULE =  'JDBC Thin Client'
UNION ALL
SELECT   'OXTA' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND s.client_info LIKE '%OXTA%'
UNION  ALL
SELECT   'APP JDBC' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si, v$instance vi
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND upper(s.machine) <> upper(vi.host_name)
   AND S.PROGRAM = 'JDBC Thin Client'
   AND s.MODULE =  'JDBC Thin Client'
   AND NVL(s.client_info,'!') NOT LIKE '%OXTA%'
UNION  ALL
SELECT   'AM POOL' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si, v$instance vi
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND upper(s.machine) <> upper(vi.host_name)
   AND S.PROGRAM = 'JDBC Thin Client'
   AND s.MODULE <>  'JDBC Thin Client'
   AND nvl(s.client_info,'!') NOT LIKE '%OXTA%'
UNION ALL
SELECT   'SQL' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND (upper(s.MODULE) IN  ('T.O.A.D.',  'T·O·A·D·','PL/SQL DEVELOPER','SQL*PLUS', 'SQL DEVELOPER')
   or s.MODULE like 'sqlplus%'
   or upper(s.MODULE) like 'C:\%'
   or upper(s.module) like 'TOAD%')
UNION ALL
SELECT   'FORMS' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si, (SELECT FORM_NAME FROM fnd_fORM UNION ALL SELECT 'FNDSCSGN' FROM DUAL) ff
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND s.MODULE = ff.FORM_NAME
UNION ALL
SELECT   'HTTPD' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND s.program LIKE 'httpd%'
UNION ALL
SELECT   'OEM' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND s.program LIKE 'jrew.exe%'
UNION ALL
SELECT   '170 Systems' "Sess_Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
         s.username "DB User", s.osuser "Client User", s.server "Server",
         s.machine "Machine", s.MODULE "Module", s.client_info "Client Info",
         s.terminal "Terminal", s.program "Program", p.program "O.S. Program",
         s.logon_time "Connect Time", lockwait "Lock Wait",
         si.physical_reads "Physical Reads", si.block_gets "Block Gets",
         si.consistent_gets "Consistent Gets",
         si.block_changes "Block Changes",
         si.consistent_changes "Consistent Changes", s.process "Process",
         p.spid, p.pid, si.SID, s.audsid, s.sql_address "Address",
         s.sql_hash_value "Sql Hash", s.action,
         SYSDATE - (s.last_call_et / 86400) "Last Call"
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+)
   AND si.SID(+) = s.SID
   AND s.username = 'MARKVIEW');


