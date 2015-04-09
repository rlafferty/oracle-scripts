set echo off
set linesize 150
set pagesize 150
set heading on
set lines 1000

/* Script developed by Jorge Rios Blanco on 27-04-2012 */
/* Oracle Pending requests                             */
/* TATA Consultancy Services Mexico                    */

column request format a9;
column status format a11;
column user format a9;
column program format a45;
column manager format a45;
column "Start date" format a19;


        Select To_Char(request_id) "Request",
               'Pending - '||status_code "Status",
               user_name "User",
               user_concurrent_program_name "Program",
               user_concurrent_queue_name "Manager",
               To_Char(actual_start_date,'DD-MM-YYYY HH24:MI:SS') "Start date"
        From   apps.fnd_concurrent_requests cr,
               apps.fnd_concurrent_programs_vl  cp,
               apps.fnd_concurrent_queues_tl cq,
               apps.fnd_user fu
        Where     cr.phase_code = 'P'
              and cr.ACTUAL_START_DATE < SYSDATE
              and cr.CONCURRENT_PROGRAM_ID=cp.CONCURRENT_PROGRAM_ID
              and cr.PROGRAM_APPLICATION_ID=cq.APPLICATION_ID
              and cq.LANGUAGE = 'US'
              and cr.requested_by = fu.user_id
        ORDER BY 1
/
