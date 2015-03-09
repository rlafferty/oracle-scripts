SELECT request_id,
       TO_CHAR (request_date, 'DD-MON-YYYY HH24:MI:SS') request_date,
       TO_CHAR (requested_start_date, 'DD-MON-YYYY HH24:MI:SS')
          requested_start_date,
       TO_CHAR (actual_start_date, 'DD-MON-YYYY HH24:MI:SS')
          actual_start_date,
       TO_CHAR (actual_completion_date, 'DD-MON-YYYY HH24:MI:SS')
          actual_completion_date,
       TO_CHAR (SYSDATE, 'DD-MON-YYYY HH24:MI:SS') CURRENT_DATE,
       ROUND (
          (NVL (actual_completion_date, SYSDATE) - actual_start_date) * 24,
          2)
          duration
  FROM fnd_concurrent_requests
 WHERE request_id = TO_NUMBER ('&p_request_id');