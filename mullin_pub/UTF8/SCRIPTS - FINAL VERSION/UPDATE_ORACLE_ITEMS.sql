-- These scripts Update the Processed_Flag for the issues that must be fixed by Oracle to 'O'
-- It is important that we do not correct any of the Oracle issues as it may affect future
-- patches or cause other issues.  A patch must be obtained from Oracle to address all of these
-- issues.  By setting the Processed_flag to 'O' it allows us to investigate the root cause
-- of the issue and track whether they have been corrected or not.



-- This updates the Oracle issues from the last run that still remain and 
-- need to be fixed by Oracle
UPDATE gesss.gecm_utf8_scan_errors x
SET x.processed_flag = 'O',
	x.processed_date = SYSDATE,
	x.status_message = 'NEEDS TO BE FIXED BY ORACLE',
	x.original_text = NULL
WHERE EXISTS (SELECT b.ge_row_id
	  		  FROM gesss.gecm_utf8_scan_archive b
			  WHERE b.processed_flag = 'O'
			  AND b.table_name = x.table_name
			  AND b.column_name = x.column_name
			  AND b.GE_ROW_ID = x.ge_row_id
			  AND b.SCAN_RUN_ID = (x.scan_run_id -1))
AND x.processed_flag IS NULL


-- Verify that the number of records updated is correct.  You should know this based on the
-- Oracle issues from the last scan run and any records that were fixed by a Patch after the
-- Last Run.  This query returns records that were fixed by an Oracle process since the last run
SELECT x.*
FROM gesss.gecm_utf8_scan_archive x
WHERE  NOT EXISTS (SELECT b.ge_row_id
	  		  FROM gesss.gecm_utf8_scan_errors b
			  WHERE b.processed_flag = 'O'
			  AND b.table_name = x.table_name
			  AND b.column_name = x.column_name
			  AND b.GE_ROW_ID = x.ge_row_id
			  AND b.scan_run_id-1 = x.SCAN_RUN_ID )
AND x.processed_flag = 'O'
AND x.scan_run_id = (SELECT MAX(scan_run_id) - 1
				  	 FROM gesss.gecm_utf8_scan_headers)

--If the count is correct
COMMIT

-- If the count is not correct, rollback and investigate why
ROLLBACK  
			  
-- This updates New Oracle Issues in the selected tables.  Futher Investigation is
-- required to determine where these records are from and how they will be corrected.			  
UPDATE gesss.gecm_utf8_scan_errors x
SET x.processed_flag = 'O',
	x.processed_date = SYSDATE,
	x.status_message = 'NEEDS TO BE FIXED BY ORACLE',
	x.original_text = NULL
WHERE x.processed_flag IS NULL			  
AND x. table_name IN ('FND_NEW_MESSAGES','DR$FND_LOBS_CTX$I','HISTGRM$','FND_COLUMNS','DR$ICX_POR_ITEMS_CTX_JA$I', 'DR$ICX_POR_ITEMS_CTX_US$I')

-- If the count is correct
COMMIT

-- If the count is not correct, rollback the changes and investigate
ROLLBACK

-- This updates issues that were not looked at this run.  Futher Investigation is
-- required to determine where these records are from and how they will be corrected.			  
UPDATE gesss.gecm_utf8_scan_errors x
SET x.processed_flag = 'X',
	x.processed_date = SYSDATE,
	x.status_message = 'DID NOT LOOK AT THIS RUN',
	x.original_text = NULL
WHERE x.processed_flag IS NULL		
AND   X.TABLE_NAME = 'STATS$SQL_SUMMARY'
AND	  X.COLUMN_NAME = 'MODULE'	
AND	  NVL(x.original_text,'!') NOT LIKE 'T%O%A%D%'

UPDATE gesss.gecm_utf8_scan_errors x
SET x.processed_flag = 'W',
	x.processed_date = SYSDATE,
	x.status_message = 'FORCED WFLOAD',
	x.original_text = NULL
WHERE x.processed_flag IS NULL	
AND	  x.table_name = 'WF_MESSAGES_TL'

-- This updates issues that were not looked at this run.  Futher Investigation is
-- required to determine where these records are from and how they will be corrected.			  
UPDATE gesss.gecm_utf8_scan_errors x
SET x.processed_flag = 'I',
	x.processed_date = SYSDATE,
	x.status_message = 'MANUALLY FIXED',
	x.original_text = NULL,
	X.REVISED_TEXT = 'T.O.A.D.'
WHERE x.processed_flag IS NULL	
AND   X.TABLE_NAME = 'STATS$SQL_SUMMARY'
AND	  X.COLUMN_NAME = 'MODULE'	
AND	  x.original_text LIKE 'T%O%A%D%'

UPDATE gesss.gecm_utf8_scan_errors x
SET x.processed_flag = 'I',
	x.processed_date = SYSDATE,
	x.status_message = 'MANUALLY FIXED',
	x.original_text = NULL,
	X.REVISED_TEXT = 'asynch'
WHERE x.processed_flag IS NULL	
AND   X.TABLE_NAME = 'STATS$PARAMETER'
AND	  X.COLUMN_NAME = 'VALUE'	


-- If the count is correct
COMMIT

-- If the count is not correct, rollback the changes and investigate
ROLLBACK
			  