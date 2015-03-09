SELECT DISTINCT
       c.USER_CONCURRENT_PROGRAM_NAME,
       ROUND (
          (  (a.actual_completion_date - a.actual_start_date)
           * 24
           * 60
           * 60
           / 60),
          2)
          AS Process_time,
       a.request_id,
       a.parent_request_id,
       TO_CHAR (a.request_date, 'DD-MON-YY HH24:MI:SS'),
       TO_CHAR (a.actual_start_date, 'DD-MON-YY HH24:MI:SS'),
       TO_CHAR (a.actual_completion_date, 'DD-MON-YY HH24:MI:SS'),
       (a.actual_completion_date - a.request_date) * 24 * 60 * 60
          AS end_to_end,
       (a.actual_start_date - a.request_date) * 24 * 60 * 60 AS lag_time,
       d.user_name,
       a.phase_code,
       a.status_code,
       a.argument_text,
       a.priority
  FROM apps.fnd_concurrent_requests a,
       apps.fnd_concurrent_programs b,
       apps.FND_CONCURRENT_PROGRAMS_TL c,
       apps.fnd_user d
 WHERE     a.concurrent_program_id = b.concurrent_program_id
       AND b.concurrent_program_id = c.concurrent_program_id
       AND a.requested_by = d.user_id
       AND --          trunc(a.actual_completion_date) = '24-AUG-2005'
           c.USER_CONCURRENT_PROGRAM_NAME =
              &prog_name --  and argument_text like  '%, , , , ,%';
--          and status_code!='C'