-- This query return session and process info for a specific OS Process ID 
SELECT 
  s.status "Status",
  s.serial# "Serial#",
  s.TYPE "Type",
  s.username "DB User",
  s.osuser "Client User",
  s.server "Server",
  s.machine "Machine",
  s.module "Module",
  s.client_info "Client Info",
  s.terminal "Terminal",
  s.program "Program",
  p.program "O.S. Program",
  s.logon_time "Connect Time",
  lockwait "Lock Wait",
  si.physical_reads "Physical Reads",
  si.block_gets "Block Gets",
  si.consistent_gets "Consistent Gets",
  si.block_changes "Block Changes",
  si.consistent_changes "Consistent Changes",
  s.process "Process",
  p.spid,
  p.pid,
  si.SID,
  s.audsid,
  s.sql_address "Address",
  s.sql_hash_value "Sql Hash",
  s.action,
  SYSDATE - (s.last_call_et / 86400) "Last Call"
FROM 
  v$session s,
  v$process p,
  SYS.v_$sess_io si
WHERE 
  s.paddr = p.addr(+) AND
  si.SID(+) = s.SID       and
  p.SPID = :unix_pid
  
-- This query return info on long operations for a specific Session ID    
select *
from v$session_longops
where sid = 214

-- This query return sql text for a specific hash value 
select sql_text
from v$sqltext
where hash_value = :sql_hash_value
order by piece

