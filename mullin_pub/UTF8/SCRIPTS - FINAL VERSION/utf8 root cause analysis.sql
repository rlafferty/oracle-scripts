-- These queries are helpful in determining the root causes of the current scan errors.

-- Summary Level Queries

-- This Query summarizes the number of records that have been processed from ALL Scaner Runs
-- These counts will be duplicated for all re-occurring issues.
SELECT processed_flag, COUNT(*)
FROM gesss.gecm_utf8_scan_archive
WHERE processed_flag IS NOT NULL
GROUP BY processed_flag

-- This query summarizes the Remaining Issues that need to be analyzed from the Current
-- Scan Errors run.  This is helpful in determining which detailed queries you may need
-- to run.
SELECT table_name,COUNT(*)
FROM gesss.gecm_utf8_scan_errors
WHERE PROCESSED_FLAG IS NULL
 AND scan_err# = 2
GROUP BY table_name
UNION ALL
SELECT 'TOTAL', COUNT(*)
FROM gesss.gecm_utf8_scan_errors
WHERE PROCESSED_FLAG IS NULL
 AND scan_err# = 2

-- Detailed Level Queries

-- PURCHASING SECTION

-- This summarizes the issues from PO Headers Interface by Org, Action and Process Code
SELECT A.org_id, A.action, A.PROCESS_CODE,COUNT(A.INTERFACE_HEADER_ID)
FROM PO.PO_HEADERS_INTERFACE A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'PO_HEADERS_INTERFACE'
AND b.ge_row_id = A.ROWID
GROUP BY A.org_id, A.action, A.PROCESS_CODE

-- This details the issues from PO Lines Interface
SELECT A.*
FROM PO.PO_LINES_INTERFACE A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'PO_LINES_INTERFACE'
AND b.ge_row_id = A.ROWID

-- This determines the source of issues from PO LINES
SELECT A.*--c.po_header_id, c.segment1, c.ORG_ID, c.INTERFACE_SOURCE_CODE, c.creation_date,COUNT(a.po_line_id)
FROM PO.PO_LINES_ALL A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
	 ,PO.PO_HEADERS_ALL c
WHERE b.table_name = 'PO_LINES_ALL'
AND b.ge_row_id = A.ROWID
AND	A.po_header_id = c.po_header_id
--GROUP BY c.po_header_id, c.segment1, c.ORG_ID, c.INTERFACE_SOURCE_CODE, c.creation_date

-- This determines the source of issues from PO LINES ARCHIVE
SELECT c.po_header_id, c.segment1, c.ORG_ID, c.INTERFACE_SOURCE_CODE, COUNT(A.po_line_id)
FROM PO.PO_LINES_ARCHIVE_ALL A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
	 ,PO.PO_HEADERS_ALL c
WHERE b.table_name = 'PO_LINES_ARCHIVE_ALL'
AND b.ge_row_id = A.ROWID
AND	A.po_header_id = c.po_header_id
GROUP BY c.po_header_id, c.segment1, c.ORG_ID, c.INTERFACE_SOURCE_CODE

-- This determines the source of issues from PO REQUISITION LINES ALL
SELECT A.*
FROM PO.PO_REQUISITION_LINES_ALL A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'PO_REQUISITION_LINES_ALL'
AND b.ge_row_id = A.ROWID

-- This determines the source of issues from PO VENDOR SITES
SELECT A.*
FROM po.po_vendor_sites_all A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'PO_VENDOR_SITES_ALL'
AND b.ge_row_id = A.ROWID

-- This determines the source of issues from PO VENDOR SITES
SELECT A.*
FROM po.po_vendor_contacts A
--WHERE PHONE = '6221914'
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'PO_VENDOR_CONTACTS'
AND b.ge_row_id = A.ROWID

-- This determines the source of issues from EC STAGE
SELECT A.* --TRUNC(a.creation_date),COUNT(*)
FROM ec.ece_stage A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'ECE_STAGE'
AND b.ge_row_id = A.ROWID
--GROUP BY TRUNC(a.creation_date)
ORDER BY A.creation_date DESC

-- AOL SECTION

-- This determines the source of issues from FLEX VALUES TL
SELECT d.FLEX_VALUE_SET_NAME, c.FLEX_VALUE, A.flex_value_id
FROM APPLSYS.FND_FLEX_VALUES_TL A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
	 ,APPLSYS.FND_FLEX_VALUES c
	 ,APPLSYS.FND_FLEX_VALUE_SETS d
WHERE b.table_name = 'FND_FLEX_VALUES_TL'
AND b.ge_row_id = A.ROWID
AND	A.flex_value_id = c.flex_value_id
AND	c.flex_value_set_id = d.flex_value_set_id
ORDER BY 1,2,3

-- This details the issues from FND TEMP FILES
SELECT A.*
FROM APPLSYS.FND_TEMP_FILES A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'FND_TEMP_FILES'
AND b.ge_row_id = A.ROWID

-- This details the issues from FND_NEW_MESSAGES
SELECT B.GE_ROW_ID, A.*
FROM APPLSYS.FND_NEW_MESSAGES A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'FND_NEW_MESSAGES'
AND b.ge_row_id = A.ROWID

-- This details the issues from FLEX COLUMNS
SELECT A.*
FROM APPLSYS.FND_COLUMNS A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'FND_COLUMNS'
AND b.ge_row_id = A.ROWID

-- This details the issues from FLEX COLUMNS
SELECT A.token_text, A.token_type, A.token_first,A.token_last, A.token_count
FROM APPLSYS.DR$FND_LOBS_CTX$I A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'DR$FND_LOBS_CTX$I'
AND b.ge_row_id = A.ROWID
ORDER BY 3

-- This details the issues from FLEX COLUMNS
SELECT A.token_text, A.token_type, A.token_first,A.token_last, A.token_count
FROM icx.DR$ICX_POR_ITEMS_CTX_US$I A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'DR$ICX_POR_ITEMS_CTX_US$I'
AND b.ge_row_id = A.ROWID

-- This Summarizes the issues from FLEX VALUES by Value Set Name
SELECT d.FLEX_VALUE_SET_NAME, COUNT(A.flex_value_id)
FROM APPLSYS.FND_FLEX_VALUES A
	 ,GECM_UTF8_SCAN_ERRORS b
	 ,APPLSYS.FND_FLEX_VALUE_SETS d
WHERE b.table_name = 'FND_FLEX_VALUES'
AND b.ge_row_id = A.ROWID
AND	A.flex_value_set_id = d.flex_value_set_id
GROUP BY d.FLEX_VALUE_SET_NAME

-- This details issues from Menu Entries
SELECT A.*
FROM fnd_MENU_ENTRIES_TL A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'FND_MENU_ENTRIES_TL'
AND b.ge_row_id = A.ROWID

-- This details issues from Menu Entries
SELECT A.*
FROM APPLSYS.FND_CONCURRENT_REQUESTS A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'FND_CONCURRENT_REQUESTS'
AND b.ge_row_id = A.ROWID

-- This details issues from Menu Entries
SELECT A.*
FROM APPLSYS.FND_CONCURRENT_PROGRAMS_TL A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'FND_CONCURRENT_PROGRAMS_TL'
AND b.ge_row_id = A.ROWID

-- This details issues from FND_CONCURRENT_PROCESSES
SELECT A.*
FROM APPLSYS.FND_CONCURRENT_PROCESSES A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'FND_CONCURRENT_PROCESSES'
AND b.ge_row_id = A.ROWID
ORDER BY A.last_update_date

-- This details issues from Lookup Values
SELECT A.*
FROM APPLSYS.FND_LOOKUP_VALUES A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'FND_LOOKUP_VALUES'
AND b.ge_row_id = A.ROWID

-- This details issues from Lookup Values
SELECT A.*
FROM APPLSYS.FND_USER A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'FND_USER'
AND b.ge_row_id = A.ROWID

-- This details issues from Lookup Values
SELECT A.*
FROM APPLSYS.FND_TEMP_FILES A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'FND_TEMP_FILES'
AND b.ge_row_id = A.ROWID

-- DBA Section

-- This Details the issues from Stored Procedures.  Some maybe Standard Oracle 
-- some maybe GE Custom
SELECT A.*, c.*
FROM SYS.SOURCE$ A
	 ,GESSS.GECM_UTF8_SCAN_errors b
	 ,GESSS.GESSS_ALL_OBJECTS c
WHERE b.table_name = 'SOURCE$'
AND B.PROCESSED_FLAG IS NULL
AND b.ge_row_id = A.ROWID
AND A.obj# = c.OBJECT_ID

SELECT A.*, c.*
FROM SYS.histgrm$ A
	 ,GESSS.GECM_UTF8_SCAN_errors b
	 ,GESSS.GESSS_ALL_OBJECTS c
WHERE b.table_name = 'HISTGRM$'
AND B.PROCESSED_FLAG IS NULL
AND b.ge_row_id = A.ROWID
AND A.obj# = c.OBJECT_ID

SELECT A.*, c.*
FROM SYS.ARGUMENT$ A
	 ,GESSS.GECM_UTF8_SCAN_errors b
	 ,GESSS.GESSS_ALL_OBJECTS c
WHERE b.table_name = 'ARGUMENT$'
AND B.PROCESSED_FLAG IS NULL
AND b.ge_row_id = A.ROWID
AND A.obj# = c.OBJECT_ID

-- WorkFlow Section

-- This Details the exceptions from WF Activities TL
SELECT A.*
FROM applsys.WF_ACTIVITIES_TL A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'WF_ACTIVITIES_TL'
AND b.ge_row_id = A.ROWID
AND b.processed_flag IS NULL
ORDER BY A.item_type, A.NAME

-- This Details the exceptions from WF Activity Attribute TL
SELECT A.*
FROM applsys.WF_ACTIVITY_ATTRIBUTES_TL A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'WF_ACTIVITY_ATTRIBUTES_TL'
AND b.ge_row_id = A.ROWID
AND b.processed_flag IS NULL

-- This Details the exceptions from WF_ITEM_TYPES_TL
SELECT A.*
FROM applsys.WF_ITEM_TYPES_TL A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'WF_ITEM_TYPES_TL'
AND b.ge_row_id = A.ROWID
AND b.processed_flag IS NULL

-- This Details the exceptions from WF_LOOKUPS_TL
SELECT A.*
FROM applsys.WF_LOOKUPS_TL A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'WF_LOOKUPS_TL'
AND b.ge_row_id = A.ROWID
AND b.processed_flag IS NULL

-- This Details the exceptions from WF_LOOKUP_TYPES_TL
SELECT A.*
FROM applsys.WF_LOOKUP_TYPES_TL A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'WF_LOOKUP_TYPES_TL'
AND b.ge_row_id = A.ROWID
AND b.processed_flag IS NULL

-- This Details the exceptions from WF_MESSAGES_TL
SELECT b.ge_row_id, b.COLUMN_NAME, b.ORIGINAL_TEXT, A.*
FROM applsys.WF_MESSAGES_TL A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'WF_MESSAGES_TL'
AND b.ge_row_id = A.ROWID
AND b.processed_flag IS NULL
--AND	a.TYPE = 'AZWM006'
--ORDER BY b.ge_row_id
ORDER BY A.TYPE

-- ICX Section

-- This details the issues from ICX POR BATCH JOBS
SELECT A.*
FROM ICX.ICX_POR_BATCH_JOBS A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'ICX_POR_BATCH_JOBS'
AND b.ge_row_id    = A.ROWID

-- This details the issues from ICX POR ITEMS
SELECT A.*
FROM ICX.ICX_POR_ITEMS_TL A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'ICX_POR_ITEMS_TL'
AND b.ge_row_id    = A.ROWID

-- This details the issues from ICX POR ITEMS
SELECT A.*
FROM ICX.ICX_POR_ITEMS A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
	 ,ICX.ICX_POR_ITEMS_TL c
WHERE b.table_name = 'ICX_POR_ITEMS_TL'
AND b.ge_row_id    = c.ROWID
AND A.rt_item_id   = c.rt_item_id

-- This details the PO Header ID for the issues from ICX POR ITEMS
SELECT DISTINCT A.orc_contract_id
FROM ICX.ICX_POR_ORACLE_ITEM_SUBTABLE A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
	 ,ICX.ICX_POR_ITEMS_TL c
WHERE b.table_name = 'ICX_POR_ITEMS_TL'
AND b.ge_row_id    = c.ROWID
AND A.rt_item_id   = c.rt_item_id

-- This details the issues from ICX POR CATEGORIES
SELECT A.*
FROM ICX.ICX_POR_ITEMS_TL A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'ICX_POR_CATEGORIES_TL'
AND b.ge_row_id    = A.ROWID

-- INV SECTION

-- This details the issues from Inventory Items
SELECT A.ORGANIZATION_ID, COUNT(A.INVENTORY_ITEM_ID)
FROM INV.MTL_SYSTEM_ITEMS_B A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'MTL_SYSTEM_ITEMS_B'
AND b.ge_row_id = A.ROWID
GROUP BY A.ORGANIZATION_ID

-- GE CUSTOM SECTION

-- This details the issues from CBSI Archive
SELECT D.*
FROM GECM_CBSI_PO_LINES_ARC A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
	 ,po.po_lines_all d
WHERE b.table_name = 'GECM_CBSI_PO_LINES_ARC'
AND b.ge_row_id = A.ROWID
AND	B.COLUMN_NAME = 'PO_ITEM_DESCRIPTION'
AND B.PROCESSED_FLAG IS NULL
AND A.po_header_id = d.po_header_id
AND	A.po_line_id = d.po_LINE_id

-- This details the issues from GEC HR Interface
SELECT A.*
FROM gesss.GECM_HR_INTERFACE_DATA A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'GECM_HR_INTERFACE_DATA'
AND b.ge_row_id = A.ROWID

-- This details the issues from GECC_FND_REPORT_TEXTS
SELECT A.*
FROM apps.GECC_FND_REPORT_TEXTS A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'GECC_FND_REPORT_TEXTS'
AND b.ge_row_id = A.ROWID

-- This details the issues from GEC HR Interface Errors
SELECT A.* 
FROM APPS.GECC_GLOBAL_HR_ERROR A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'GECC_GLOBAL_HR_ERROR'
AND b.ge_row_id    = A.ROWID

-- This details the corresponding issues from PER ALL PEOPLE
SELECT A.*
FROM HR.PER_ALL_PEOPLE_F A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'PER_ALL_PEOPLE_F'
AND b.ge_row_id    = A.ROWID
--AND b.column_name = 'LAST_NAME'

-- This details the corresponding issues from HR_LOCATIONS_ALL
SELECT LENGTH(A.address_line_1),LENGTH(A.address_line_2),A.TP_HEADER_ID, 
  A.ECE_TP_LOCATION_CODE, 
  A.LOCATION_ID, 
  A.ENTERED_BY, 
  A.LOCATION_CODE, 
  A.ADDRESS_LINE_1, 
  A.ADDRESS_LINE_2, 
  A.ADDRESS_LINE_3, 
  A.BILL_TO_SITE_FLAG, 
  A.COUNTRY, 
  A.DESCRIPTION, 
  A.DESIGNATED_RECEIVER_ID, 
  A.IN_ORGANIZATION_FLAG, 
  A.INACTIVE_DATE, 
  A.INVENTORY_ORGANIZATION_ID, 
  A.OFFICE_SITE_FLAG, 
  A.POSTAL_CODE, 
  A.RECEIVING_SITE_FLAG, 
  A.REGION_1, 
  A.REGION_2, 
  A.REGION_3, 
  A.SHIP_TO_LOCATION_ID, 
  A.SHIP_TO_SITE_FLAG, 
  A.STYLE, 
  A.TAX_NAME, 
  A.TELEPHONE_NUMBER_1, 
  A.TELEPHONE_NUMBER_2, 
  A.TELEPHONE_NUMBER_3, 
  A.TOWN_OR_CITY, 
  A.ATTRIBUTE_CATEGORY, 
  A.ATTRIBUTE1, 
  A.ATTRIBUTE2, 
  A.ATTRIBUTE3, 
  A.ATTRIBUTE4, 
  A.ATTRIBUTE5, 
  A.ATTRIBUTE6, 
  A.ATTRIBUTE7, 
  A.ATTRIBUTE8, 
  A.ATTRIBUTE9, 
  A.ATTRIBUTE10, 
  A.ATTRIBUTE11, 
  A.ATTRIBUTE12, 
  A.ATTRIBUTE13, 
  A.ATTRIBUTE14, 
  A.ATTRIBUTE15, 
  A.ATTRIBUTE16, 
  A.ATTRIBUTE17, 
  A.ATTRIBUTE18, 
  A.ATTRIBUTE19, 
  A.ATTRIBUTE20, 
  A.LAST_UPDATE_DATE, 
  A.GLOBAL_ATTRIBUTE_CATEGORY, 
  A.GLOBAL_ATTRIBUTE1, 
  A.GLOBAL_ATTRIBUTE2, 
  A.GLOBAL_ATTRIBUTE3, 
  A.GLOBAL_ATTRIBUTE4, 
  A.GLOBAL_ATTRIBUTE5, 
  A.GLOBAL_ATTRIBUTE6, 
  A.GLOBAL_ATTRIBUTE7, 
  A.GLOBAL_ATTRIBUTE8, 
  A.GLOBAL_ATTRIBUTE9, 
  A.GLOBAL_ATTRIBUTE10, 
  A.GLOBAL_ATTRIBUTE11, 
  A.GLOBAL_ATTRIBUTE12, 
  A.GLOBAL_ATTRIBUTE13, 
  A.GLOBAL_ATTRIBUTE14, 
  A.GLOBAL_ATTRIBUTE15, 
  A.GLOBAL_ATTRIBUTE16, 
  A.GLOBAL_ATTRIBUTE17, 
  A.GLOBAL_ATTRIBUTE18, 
  A.GLOBAL_ATTRIBUTE19, 
  A.GLOBAL_ATTRIBUTE20, 
  A.LAST_UPDATED_BY, 
  A.LAST_UPDATE_LOGIN, 
  A.CREATED_BY, 
  A.CREATION_DATE, 
  A.OBJECT_VERSION_NUMBER, 
  A.BUSINESS_GROUP_ID, 
  A.LOC_INFORMATION13, 
  A.LOC_INFORMATION14, 
  A.LOC_INFORMATION15, 
  A.LOC_INFORMATION16, 
  A.LOC_INFORMATION17, 
  A.LOC_INFORMATION18, 
  A.LOC_INFORMATION19, 
  A.LOC_INFORMATION20
FROM HR_LOCATIONS_ALL A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'HR_LOCATIONS_ALL'
AND b.ge_row_id    = A.ROWID


-- This details the issues from the Receipt Outbound process
SELECT A.*
FROM gesss.GECM_RECEIPT_LINE A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'GECM_RECEIPT_LINE'
AND b.ge_row_id = A.ROWID

-- This determines the source of issues from GSL Interface
SELECT A.*
FROM gesss.GECM_GSL_VENDOR_INTERFACE A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'GECM_GSL_VENDOR_INTERFACE'
AND b.ge_row_id = A.ROWID

-- This determines the source of issues from GEMS_DATAWAREHOUSE_TEMP_TABLE
SELECT b.column_name, A.*,DUMP(A.CHECK_REQUEST_VENDOR,1007)
FROM geMS.GEMS_DATAWAREHOUSE_TEMP_TABLE A
	 ,GESSS.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'GEMS_DATAWAREHOUSE_TEMP_TABLE'
AND b.ge_row_id = A.ROWID


-- This details the corresponding issues from STATS$SQL_SUMMARY
SELECT DUMP(b.original_text),b.ge_row_id, A.*
FROM perfstat.STATS$SQL_SUMMARY A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'STATS$SQL_SUMMARY'
AND	  b.column_name = 'MODULE'
AND b.ge_row_id    = A.ROWID
AND DUMP(b.original_text) = 'Typ=1 Len=8: 84,183,79,183,65,183,68,183'-- LIKE 'T%O%A%D%'

-- This details the corresponding issues from STATS$SQLTEXT
SELECT DUMP(b.original_text,1017),REPLACE(b.original_text,'¿','?'),A.*
FROM perfstat.STATS$SQLTEXT A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'STATS$SQLTEXT'
AND b.ge_row_id    = A.ROWID


SELECT CHR(195)  FROM dual

-- This details the corresponding issues from STATS$PARAMETER
SELECT A.*
FROM perfstat.STATS$PARAMETER A
	 ,gesss.GECM_UTF8_SCAN_ERRORS b
WHERE b.table_name = 'STATS$PARAMETER'
AND b.ge_row_id    = A.ROWID




Diego Fernando Ruiz Castañeda

SELECT DUMP(' ')--CHR(32) 
FROM DUAL

DESC geMS.GEMS_DATAWAREHOUSE_TEMP_TABLE


GEMS_DATAWAREHOUSE_TEMP_TABLE




