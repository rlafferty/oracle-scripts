
-- This query gives the number of sessions for each JVM Process 
select process, count(*)
from v$session
where process = action
group by process
union all
select 'TOTAL', count(*)
from v$session
where process = action
group by 'TOTAL'

-- This query gives the Active, Returned and Total Connections for each JVM Process 
select   returned.time "SNAP TIME"
	   , returned.process "JVM PROCESS"
	   , active.connections "ACTIVE CONNECTIONS"
	   , returned.connections "RETURNED CONNECTIONS"
	   , active.connections + returned.connections "TOTAL CONNECTIONS"
from
(  select sysdate time , process, count(*) connections
   from v$session
   where module like '%:R'
   and process in (select distinct process
 	    		   from v$session
				   where process = action)
   group by sysdate, process
 union all
  select sysdate time,'TOTAL', count(*) connections
  from v$session
  where process in (select distinct process
  				    from v$session
					where process = action)
  and module like '%:R'
  group by sysdate, 'TOTAL') Returned,
( select sysdate time, process, count(*) connections
  from v$session
  where module not like '%:R'
  and process in (select distinct process
  	  		  	  from v$session
				  where process = action)
  group by sysdate, process
union all
  select sysdate time,'TOTAL', count(*) connections
  from v$session
  where process in (select distinct process
  				    from v$session
					where process = action)
  and module not like '%:R'
  group by sysdate, 'TOTAL') Active
where returned.process = active.process

-- This query gives Processes with no corresponding Session 
select sysdate, ADDR, PID, SPID, USERNAME, PROGRAM
from v$process b
where not exists (select 'Y'
	  		from v$session a
			where a.PADDR = b.addr);
			
