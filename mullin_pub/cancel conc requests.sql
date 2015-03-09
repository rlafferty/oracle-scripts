-- This updates the status of a specific request id to completed cancelled 
UPDATE fnd_concurrent_requests
SET phase_code = 'C',
    status_code = 'D'
WHERE concurrent_program_id = :v_program_id 
AND request_id = :v_request_id


COMMIT