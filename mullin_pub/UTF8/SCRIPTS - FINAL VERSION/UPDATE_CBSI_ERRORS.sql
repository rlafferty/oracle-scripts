-- This script corrects the corrupt records created by the CBSI extract.  This extracts currently
-- converts the multi-byte UTF8 characters to single-byte US7ASCII characters inorder to create
-- the extract file for CBSI.  This converted data is stored in Custom tables to facilitate the
-- extract and provide historical reporting.  Here we are updating these custom tables to match
-- the original data from the PO tables which is still UTF8 characters.


-- This updates the GECM_CBSI_PO_LINES_ARC with the original po item description
-- substrb is used to ensure the data does not exceed the column length in the Custom table
UPDATE GESSS.GECM_UTF8_SCAN_ERRORS b
SET  b.REVISED_TEXT = (SELECT SUBSTRB(A.ITEM_DESCRIPTION,1,40)
	 				   FROM PO.PO_LINES_ALL A
					   WHERE PO_LINE_ID = (SELECT C.PO_LINE_ID
					   		 			   FROM GESSS.GECM_CBSI_PO_LINES_ARC C,
										   		GESSS.GECM_UTF8_SCAN_ERRORS X
											WHERE X.TABLE_NAME = 'GECM_CBSI_PO_LINES_ARC'
											AND X.COLUMN_NAME = 'PO_ITEM_DESCRIPTION'
											AND X.PROCESSED_FLAG IS NULL
											AND X.GE_ROW_ID = C.ROWID
											AND B.TABLE_NAME = 'GECM_CBSI_PO_LINES_ARC'
											AND B.COLUMN_NAME = 'PO_ITEM_DESCRIPTION'
											AND B.GE_ROW_ID = X.GE_ROW_ID
											AND B.SCAN_ERR# = 2
											AND X.SCAN_ERR# = 2)),
	 b.processed_flag = 'I',
	 b.status_message = 'UPDATED FROM PO LINES ALL ITEM DESCRIPTION'
where B.TABLE_NAME = 'GECM_CBSI_PO_LINES_ARC'
AND B.COLUMN_NAME = 'PO_ITEM_DESCRIPTION' 
and b.revised_text is null
and B.PROCESSED_FLAG IS NULL
AND	B.SCAN_ERR# = 2

-- If the counts are correct then
commit

--
Rollback

-- This updates the GECM_CBSI_PO_LINES with the original po item description
-- substrb is used to ensure the data does not exceed the column length in the Custom table
UPDATE GESSS.GECM_UTF8_SCAN_ERRORS b
SET  b.REVISED_TEXT = (SELECT SUBSTRB(A.ITEM_DESCRIPTION,1,40)
	 				   FROM PO.PO_LINES_ALL A
					   WHERE PO_LINE_ID = (SELECT C.PO_LINE_ID
					   		 			   FROM GESSS.GECM_CBSI_PO_LINES C,
										   		GESSS.GECM_UTF8_SCAN_ERRORS X
											WHERE X.TABLE_NAME = 'GECM_CBSI_PO_LINES'
											AND X.COLUMN_NAME = 'PO_ITEM_DESCRIPTION'
											AND X.PROCESSED_FLAG IS NULL
											AND X.GE_ROW_ID = C.ROWID
											AND B.TABLE_NAME = 'GECM_CBSI_PO_LINES'
											AND B.COLUMN_NAME = 'PO_ITEM_DESCRIPTION'
											AND B.GE_ROW_ID = X.GE_ROW_ID
											AND B.SCAN_ERR# = 2
											AND X.SCAN_ERR# = 2)),
	 b.processed_flag = 'I',
	 b.status_message = 'UPDATED FROM PO LINES ALL ITEM DESCRIPTION'
where B.TABLE_NAME = 'GECM_CBSI_PO_LINES'
AND B.COLUMN_NAME = 'PO_ITEM_DESCRIPTION' 
and b.revised_text is null
and B.PROCESSED_FLAG IS NULL
AND	B.SCAN_ERR# = 2

