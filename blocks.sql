SET LINESIZE 200
COLUMN sid FORMAT 99999999999999

select inst_id, sid, blocking_instance, blocking_session from gv$session
 where blocking_instance is not null and blocking_session is not null order by 1, 2;