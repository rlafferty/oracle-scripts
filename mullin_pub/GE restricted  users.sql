SELECT username
FROM DBA_USERS a
WHERE --default_tablespace IN ('GECUST')
--AND 
EXISTS (SELECT 'Y'
			    FROM gedba.ge_restricted_users b
				WHERE b.USERNAME = a.USERNAME)
				
				
    SELECT username
    FROM DBA_USERS
    WHERE default_tablespace='GECUST'
    MINUS
    (SELECT username
    FROM gedba.ge_restricted_users
    UNION
	SELECT USER
    FROM dual)