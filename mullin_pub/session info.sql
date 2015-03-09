SELECT SYSDATE, machine, program, username , MODULE,  process, COUNT(*)
FROM v$session
WHERE program LIKE 'JDBC%'
--AND substr(NVL(process,0)1,5) BETWEEN 16792 AND 16803
GROUP BY machine, program, username , MODULE, process

WHERE username  = 'APPS' 
AND program LIKE 'JDBC%';



SELECT   'CONC MGR' "Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
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
SELECT   'BACKGROUND' "Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
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
SELECT   'DB JDBC' "Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
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
    FROM v$session s, v$process p, SYS.v_$sess_io si, fnd_database_instances fdi
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND s.machine = fdi.host
   AND S.PROGRAM = 'JDBC Thin Client' 
   AND s.MODULE =  'JDBC Thin Client'
UNION ALL   
SELECT   'OXTA' "Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
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
SELECT   'APP JDBC' "Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
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
    FROM v$session s, v$process p, SYS.v_$sess_io si, fnd_database_instances fdi
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND s.machine <> fdi.host
   AND S.PROGRAM = 'JDBC Thin Client' 
   AND s.MODULE =  'JDBC Thin Client'
   AND NVL(s.client_info,'!') NOT LIKE '%OXTA%'
UNION  ALL
SELECT   'AM POOL' "Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
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
    FROM v$session s, v$process p, SYS.v_$sess_io si, fnd_database_instances fdi
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND s.machine <> fdi.host
   AND S.PROGRAM = 'JDBC Thin Client' 
   AND s.MODULE <>  'JDBC Thin Client'
   AND s.client_info NOT LIKE '%OXTA%'
UNION ALL   
SELECT   'SQL' "Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
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
   AND s.MODULE IN  ('T.O.A.D.', 'SQL*Plus')
UNION ALL
SELECT   'FORMS' "Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
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
SELECT   'HTTPD' "Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
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




   
   
SELECT   'SQL' "Source", s.status "Status", s.serial# "Serial#", s.TYPE "TYPE",
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
    FROM v$session s, v$process p, SYS.v_$sess_io si, fnd_logins fl, fnd_appl_sessions fas
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND s.audsid =  fas.AUDSID
   AND fas.LOGIN_ID = fl.LOGIN_ID
   AND s.program <> 'JDBC Thin Client'



SELECT   'CONC MGR' "Source", COUNT(*)
   FROM v$session s, v$process p, SYS.v_$sess_io si, fnd_concurrent_processes fcp
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND fcp.process_status_code = 'A'
   AND fcp.oracle_process_id = p.pid
UNION ALL   
SELECT   'BACKGROUND' "Source", COUNT(*)
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND (s.TYPE = 'BACKGROUND'
   OR S.PROGRAM LIKE '%QMN%'
   OR S.PROGRAM LIKE '%CJQ%')
UNION ALL
SELECT   'DB JDBC' "Source", COUNT(*)
    FROM v$session s, v$process p, SYS.v_$sess_io si, fnd_database_instances fdi
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND s.machine = fdi.host
   AND S.PROGRAM = 'JDBC Thin Client' 
   AND s.MODULE =  'JDBC Thin Client'
UNION ALL   
SELECT   'OXTA' "Source", COUNT(*)
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND s.client_info LIKE '%OXTA%'
UNION  ALL
SELECT   'APP JDBC' "Source", COUNT(*)
    FROM v$session s, v$process p, SYS.v_$sess_io si, fnd_database_instances fdi
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND s.machine <> fdi.host
   AND S.PROGRAM = 'JDBC Thin Client' 
   AND s.MODULE =  'JDBC Thin Client'
   AND s.client_info NOT LIKE '%OXTA%'
UNION  ALL
SELECT   'AM POOL' "Source", COUNT(*)
    FROM v$session s, v$process p, SYS.v_$sess_io si, fnd_database_instances fdi
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND s.machine <> fdi.host
   AND S.PROGRAM = 'JDBC Thin Client' 
   AND s.MODULE <>  'JDBC Thin Client'
   AND s.client_info NOT LIKE '%OXTA%'
UNION ALL   
SELECT   'SQL' "Source", COUNT(*)
    FROM v$session s, v$process p, SYS.v_$sess_io si
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND s.MODULE IN  ('T.O.A.D.', 'SQL*Plus')
UNION ALL
SELECT   'FORMS' "Source", COUNT(*)
    FROM v$session s, v$process p, SYS.v_$sess_io si, fnd_form ff
   WHERE s.paddr = p.addr(+) 
   AND si.SID(+) = s.SID
   AND s.MODULE = ff.FORM_NAME
UNION ALL
SELECT   'HTTPD' "Source", COUNT(*)
    FROM v$session s
   WHERE s.MODULE LIKE 'httpd%'   
UNION ALL
SELECT 'TOTAL' "Source", COUNT(*)
   FROM v$session

   
   
   
SELECT * FROM   V$SESSION_CONNECT_INFO 