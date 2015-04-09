set echo off
set heading on
set lines 1000
set pages 40
col os form A7 head AppProc
col spid form a6 head SPID
col program form A60 trunc
col time form 99999.99 head Elapsed
col "Req Id" form 9999999999
col "Parent" form a9
col "Prg Id" form 9999999
col serial# form 999999 head Serial#
col qname head "Manager" format a20 trunc
col sid format 9999 head SID
col user_name form A12 head User trunc
set recsep off

/* Script developed by Jorge Rios Blanco on 25-04-2012 */
/* Oracle concurrent programs running                  */
/* TATA Consultancy Services Mexico                    */

select
       q.concurrent_queue_name qname
      ,f.user_name
      ,a.request_id "Req Id"
      ,decode(a.parent_request_id,-1,NULL,a.parent_request_id) "Parent"
      ,a.concurrent_program_id "Prg Id"
      ,a.phase_code,a.status_code
      ,a.oracle_process_id "spid"
      ,(nvl(a.actual_completion_date,sysdate)-a.actual_start_date)*1440 "Time"
      ,c.concurrent_program_name||' - '||
       c2.user_concurrent_program_name||' '||a.description "Program"
from APPLSYS.fnd_Concurrent_requests a
    ,APPLSYS.fnd_concurrent_processes b
    ,applsys.fnd_concurrent_queues q
    ,APPLSYS.fnd_concurrent_programs_tl c2
    ,APPLSYS.fnd_concurrent_programs c
    ,APPLSYS.fnd_user f
where
      a.controlling_manager = b.concurrent_process_id
  and a.concurrent_program_id = c.concurrent_program_id
  and a.program_application_id = c.application_id
  and c2.concurrent_program_id = c.concurrent_program_id
  and c2.application_id = c.application_id
  and a.phase_code in ('I','P','R','T')
  and a.requested_by = f.user_id
  and b.queue_application_id = q.application_id
  and b.concurrent_queue_id = q.concurrent_queue_id
  and c2.language = 'US'
order by 9 desc

/


exit
