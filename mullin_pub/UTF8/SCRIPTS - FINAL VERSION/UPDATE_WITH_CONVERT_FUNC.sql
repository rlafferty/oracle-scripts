-- This script attempts to convert the corrupt data.  This will only be successfull if the 
-- data was loaded without any conversion to UTF8.  After this is done, you MUST review the
-- results to see if the data was converted properly.  In order to determine this, your
-- nls_lang setting on your client must match your operating system.  For example,
-- PC clients running US version of Microsoft Windows should set the nls_lang on their
-- PC to AMERICAN_AMERICA.WE8MSWIN1252.  This will ensure what you are displaying from 
-- TOAD is correct.
--
-- The syntax for the convert function is:
-- 	   convert(text, destination_characterset, source_characterset)
--
--	   The destination_characterset must always be UTF8
--	   The source_charactersets maybe one of the following:
--	   	   			WE8MSWIN1252  - Western European - Microsoft Windows
--					US7ASCII	  - US ASCII
--					WE8ISO8859P1  - Western European ISO-8859-1
--					
UPDATE GESSS.GECM_UTF8_SCAN_ERRORS b
SET  b.REVISED_TEXT = convert(b.original_text,'UTF8','WE8MSWIN1252'),
	 b.processed_flag = 'I',
	 b.status_message = 'FIXED WITH CONVERT FUNC FROM WE8MSWIN1252'
where B.TABLE_NAME = :table_name
and b.revised_text is null
and B.PROCESSED_FLAG IS NULL
and	b.scan_err# = 2

-- Now you can run this query to display the results before committing
SELECT REVISED_TEXT,
	   ORIGINAL_TEXT
FROM GESSS.GECM_UTF8_SCAN_ERRORS b
where B.TABLE_NAME = :table_name
and b.revised_text is NOT null
and B.PROCESSED_FLAG = 'I'
AND	b.status_message LIKE 'FIXED WITH CONVERT FUNC%'

-- If all of the revised_text is correct you can commit
-- Else you must Rollback the changes and add more logic to the Update Statement
-- to just update the records that were correct.
commit

-- If any of the revised_text is not correct, you should rollback the changes
-- and try again.
ROLLBACK



UPDATE GESSS.GECM_UTF8_SCAN_ERRORS b
SET  b.REVISED_TEXT = NULL,
	 b.processed_flag = NULL,
	 b.status_message = NULL
where B.TABLE_NAME = :table_name
and b.revised_text is not null
and B.PROCESSED_FLAG = 'I'

COMMIT
