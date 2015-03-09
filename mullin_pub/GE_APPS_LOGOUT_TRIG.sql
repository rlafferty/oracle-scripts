connect as system

drop table system.ge_apps_logout_tab;

create table system.ge_apps_logout_tab storage (initial 10M next 10M pctincrease 0)
as select * from v$session where 1=2;

commit;

grant all on ge_apps_logout_tab to sys

grant all on ge_apps_logout_tab to apps

********************************************************************
connect as sys

DROP SYNONYM ge_apps_logout_tab;

CREATE SYNONYM ge_apps_logout_tab FOR sytem.ge_apps_logout_tab;


create or replace trigger ge_apps_logout_trig before logoff on database
begin
     insert into system.ge_apps_logout_tab
	 select *
     from v$session
     where audsid=userenv('SESSIONID');
     commit;
    exception
       when others then
        dbms_output.put_line('Exception occurred');
end;
/

alter trigger sys.ge_apps_logout_trig enable;

alter trigger sys.ge_apps_logout_trig disable;

**************************************************************************
connect as apps

DROP SYNONYM ge_apps_logout_tab;

CREATE SYNONYM ge_apps_logout_tab FOR sytem.ge_apps_logout_tab;


select nvl(username,osuser), nvl(module,program), count(*)
from system.ge_apps_logout_tab
group by nvl(username,osuser), nvl(module,program)
union all
select 'TOTAL', ' ', count(*)
from system.ge_apps_logout_tab
group by 'TOTAL', ' '
order by 3 desc


select to_char(logon_time,'mm/dd/rrrr hh:mi AM'), count(*)
from v$session
group by to_char(logon_time,'mm/dd/rrrr hh:mi AM')
order by 1 --2 desc


select *
from dba_triggers
where trigger_name = 'GE_APPS_LOGOUT_TRIG'


