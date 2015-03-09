  SELECT DISTINCT
         c.USER_CONCURRENT_PROGRAM_NAME,
         ROUND ( ( (SYSDATE - a.actual_start_date) * 24 * 60 * 60 / 60), 2)
            AS Process_time,
         a.request_id,
         a.parent_request_id,
         a.request_date,
         a.actual_start_date,
         a.actual_completion_date,
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
         AND status_code = 'R'
ORDER BY Process_time DESC;