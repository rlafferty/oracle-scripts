ps_prog    = 'sessinfo.sql'
def aps_title   = 'Session information'
set line 100

col "Session Info" form A85
set verify off
set heading off
accept sid      prompt 'Please enter the value for Sid if known            : '
accept terminal prompt 'Please enter the value for terminal if known       : '
accept machine  prompt 'Please enter the machine name if known             : '
accept process  prompt 'Please enter the value for Application/Client Process if known : '
accept spid     prompt 'Please enter the value for DB Server Process if known : '
accept osuser   prompt 'Please enter the value for OS User if known        : '
accept username prompt 'Please enter the value for DB User if known        : '
prompt=================================================================
prompt Session Info
prompt=================================================================

select ' Sid, Serial#, Aud sid : '|| s.sid||' , '||s.serial#||' , '||
s.audsid||chr(10)||'     DB User / OS User : '||s.username||
'   /   '||s.osuser||chr(10)|| '    Machine - Terminal : '||
s.machine||'  -  '|| s.terminal||chr(10)||
'        OS Process Ids : '||
s.process||' (Client)  '||p.spid||' (Server)'|| ' (Since) '||to_char(s.logon_time,'DD-MON-YYYY HH24:MI:SS')||chr(10)||
'   Client Program Name : '||s.program||chr(10) "Session Info",
'   Action / Module     : '||s.action||'  / '||s.module||chr(10) ||
'User Name/Login ID : '||fu.description ||' / '||fu.user_name -- Added to provide login id
from gv$process p, gv$session s, apps.fnd_user fu, apps.fnd_logins f
where p.addr = s.paddr
and s.sid = nvl('&SID',s.sid)
and nvl(s.terminal,' ') = nvl('&Terminal',nvl(s.terminal,' '))
and nvl(s.process,-1) = nvl('&Process',nvl(s.process,-1))
and p.spid = nvl('&spid',p.spid)
and s.username = nvl('&username',s.username)
and nvl(s.osuser,' ') = nvl('&OSUser',nvl(s.osuser,' '))
and nvl(s.machine,' ') = nvl('&machine',nvl(s.machine,' '))
and nvl('&SID',nvl('&TERMINAL',nvl('&PROCESS',nvl('&spid',nvl('&OSUSER',nvl('&USERNAME',nvl('&MACHINE','NO VALUES'))))))) <> 'NO VALUES'
and f.spid (+)  = nvl('&Process',s.process)
and fu.user_id (+) = f.user_id
and f.end_time (+) is null
order by f.start_time
/
set heading on
set verify on
undefine sid
undefine spid
undefine process

