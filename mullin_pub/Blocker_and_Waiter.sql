--********************************************************************************************************* 
--*                                                                                                       * 
--*  Blocker and Waiter Full Details                                                                      *
--*                                                                                                       *
--*  This query return the details of Current Locks.  This included the Blocking Session, the Waiting     *
--*  Session, the Object that is Locked and the Session and Process Information.                          *
--*                                                                                                       *
--*  This information should be captured for ALL locks before any sessions are killed.  This will provide *
--*  Valuable information on the cause of the Locks and will facilitate corrective actions to minimize    *
--*  Locking Issues.                                                                                      *
--*                                                                                                       *
--*  CREATED BY: Matthew Mullin                                                                           *
--*  CREATED ON : April 7, 2005                                                                           *
--*                                                                                                       * 
--********************************************************************************************************* 
select bl.status, bl.session_id, bl.lock_type, bl.mode_held, bl.mode_requested, bl.lock_id1, bl.lock_id2
      ,dobj.object_type, dobj.object_name,sess.*
from  
(select 'BLOCKER' STATUS , SESSION_ID, LOCK_TYPE, MODE_HELD, MODE_REQUESTED, LOCK_ID1, LOCK_ID2
from dba_lock
where blocking_others = 'Blocking') bl,
(select session_id, object_id
from v$locked_object) vlo,
(select object_id, object_type, object_name
from dba_objects) dobj,
(SELECT   s.status "Status", s.serial# "Serial#", s.TYPE "TYPE", 
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
   AND si.SID(+) = s.SID ) sess
where bl.session_id = vlo.session_id
and vlo.object_id = dobj.object_id
and bl.session_id = sess.sid
union all
select wt.status, wt.session_id, wt.lock_type, wt.mode_held, wt.mode_requested, wt.lock_id1, wt.lock_id2
    , dobj.object_type, dobj.object_name, sess.*
from  
(select 'WAITER' STATUS , SESSION_ID, LOCK_TYPE, MODE_HELD, MODE_REQUESTED, LOCK_ID1, LOCK_ID2
from dba_lock
where blocking_others = 'Not Blocking'
and lock_id1 in (select blocker2.lock_id1
	   		     from dba_lock blocker2
				where blocker2.blocking_others = 'Blocking')) wt,
(select session_id, object_id
from v$locked_object) vlo,
(select object_id, object_type, object_name
from dba_objects) dobj,
(SELECT   s.status "Status", s.serial# "Serial#", s.TYPE "TYPE", 
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
   AND si.SID(+) = s.SID ) sess
where wt.session_id = vlo.session_id
and vlo.object_id = dobj.object_id
and wt.session_id = sess.sid
order by 6,1						
				