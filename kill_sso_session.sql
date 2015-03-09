-----------------------
kill_session_script.sql
-----------------------

-- Script to kill sessions inactive for more than 1 hr
-- kill_session_script.sql
set serveroutput on size 100000
set echo off
set feedback off
set lines 300
spool kill_session.sql
declare
 cursor sessinfo is 
    select *
       from     gv$session
       where     username is not null
       and substr(username, 1, 3)= 'SSO'
       and     last_call_et/60/60>1;
 sess sessinfo%rowtype;
 sql_string1 Varchar2(2000); 
 sql_string2 Varchar2(2000);
begin
dbms_output.put_line('SPOOL kill_session.log;');
 open sessinfo;
 loop
  fetch sessinfo into sess;
  exit when sessinfo%notfound;
  sql_string1:='--sid='||sess.sid||' serail#='||sess.serial#||' instance='||sess.inst_id||' machine='||sess.machine||' program='||sess.program||' username='||sess.username||' Inactive_sec='||sess.last_call_et||' OS_USER='||sess.osuser;
  dbms_output.put_line(sql_string1);
  sql_string2:='alter system disconnect session '||chr(39)||sess.sid||','||sess.serial#||',@'||sess.inst_id||chr(39)||' immediate ;';
  dbms_output.put_line(sql_string2);
 end loop;
 close sessinfo;
 dbms_output.put_line('SPOOL OFF;');
 dbms_output.put_line('exit;');
end;
/ 
spool off;
set echo on;
set feedback on;
@kill_session.sql;