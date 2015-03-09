-- This updates the items with an Error Number of 1
-- These Do Not Require Corrections As Long As the Corresponding Error Number 2
-- Record is Corrected with the appropriate Substrb parameters
update gesss.gecm_utf8_scan_errors x
set x.processed_flag = 'T',
	x.processed_date = sysdate,
	x.status_message = 'TYPE 1 ERRORS ARE NOT CORRECTED',
	x.original_text = null
where x.scan_err# = 1
and	  x.processed_flag is null

-- If Number Updated is Correct
COMMIT

--Else
Rollback
			  
