set echo off
col os form A6
col program form A45 trunc
set pages 38
col "time(tot)" form 9999999
col "time(avg)" form 9999.99
col "time(min)" form 9999.99
col "time(max)" form 9999.99
col "Req Id" form 9999999999
col "Prg Id" form 999999
col "Jobs" form 9999
col lsm head Status format a10
col earlieststart head Earliest format a10
set recsep off
set verify off

/* Script developed by Jorge Rios Blanco on 25-04-2012 */
/* Oracle time history for a concurrent request        */
/* TATA Consultancy Services Mexico                    */

accept cmprogid number prompt 'What is the program ID : '
select c.concurrent_program_name||' - '||
       ctl.user_concurrent_program_name "Program"
      ,to_char(min(actual_start_date),'mm/dd/rr') earlieststart
      ,sum(nvl(actual_completion_date-actual_start_date,0))*1440 "Time(tot)"
      ,avg(nvl(actual_completion_date-actual_start_date,0))*1440 "Time(avg)"
      ,min(nvl(actual_completion_date-actual_start_date,0))*1440 "Time(min)"
      ,max(nvl(actual_completion_date-actual_start_date,0))*1440 "Time(max)"
      ,count(*) "Jobs"
      ,ls.meaning lsm
from APPLSYS.fnd_Concurrent_requests a,APPLSYS.fnd_concurrent_programs c,
      APPLSYS.fnd_concurrent_programs_tl ctl,
      APPLSYS.fnd_lookup_values ls
where c.concurrent_program_id = &cmprogid
  and a.concurrent_program_id = c.concurrent_program_id
  and ctl.concurrent_program_id = c.concurrent_program_id
  and ctl.language = 'US'
  and a.program_application_id = c.application_id
  and ctl.application_id = c.application_id
  and ls.lookup_type = 'CP_STATUS_CODE'
  and ls.language = 'US'
  and a.status_code || '' = ls.lookup_code
  and a.phase_code || '' = 'C'
group by c.concurrent_program_name
        ,ctl.user_concurrent_program_name
        ,ls.meaning
order by 3 desc
/
set echo off
