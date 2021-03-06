SELECT SYSDATE,Sess_SOURCE, COUNT(*)
FROM GEDBA_SESSION_INFO_V
GROUP BY SYSDATE, Sess_SOURCE
UNION ALL
SELECT SYSDATE, 'UNKNOWN', COUNT(*)
FROM v$session s
WHERE NOT EXISTS ( SELECT 'Y'
	  	  		   FROM GEDBA_SESSION_INFO_V b
				   WHERE s.SID = b.SID)
GROUP BY SYSDATE, 'UNKNOWN'
UNION ALL
SELECT SYSDATE, 'TOTAL', COUNT(*)
FROM v$session
GROUP BY SYSDATE, 'TOTAL'

SELECT SYSDATE, process, MODULE, client_info, COUNT(*)
FROM GEDBA_SESSION_INFO_V
WHERE sess_source = 'AM POOL'
GROUP BY SYSDATE, process, MODULE, client_info

SELECT *
FROM v$session s
WHERE NOT EXISTS ( SELECT 'Y'
	  	  		   FROM GEDBA_SESSION_INFO_V b
				   WHERE s.SID = b.SID)
				   
				   
				   
