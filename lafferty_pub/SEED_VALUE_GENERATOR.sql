  SELECT a.COLUMN_NAME || ',' AS COLUMN_NAME,
            (CASE
                WHEN COLUMN_NAME LIKE '%_KEY%'
                THEN
                   (CASE WHEN data_type = 'NUMBER' THEN '-1' ELSE '''-1''' END)
                WHEN COLUMN_NAME LIKE '%_ID%'
                THEN
                   (CASE WHEN data_type = 'NUMBER' THEN '-1' ELSE '''-1''' END)
                WHEN COLUMN_NAME LIKE '%_LKP%'
                THEN
                   (CASE WHEN data_type = 'NUMBER' THEN '-1' ELSE '''-1''' END)
                WHEN COLUMN_NAME LIKE '%ATTRIB%'
                THEN
                   (CASE WHEN data_type = 'NUMBER' THEN '-1' ELSE '''-1''' END)
                WHEN COLUMN_NAME LIKE '%CY_%'
                THEN
                   (CASE WHEN data_type = 'NUMBER' THEN '-1' ELSE '''-1''' END)
                WHEN DATA_TYPE = 'DATE'
                THEN
                   'to_date(''01/01/1901'', ''MM/DD/YYYY'')'
                WHEN COLUMN_NAME = 'MD_LOOKUP_VALUE'
                THEN
                   '''-1'''
                WHEN COLUMN_NAME = 'MD_SOURCE_SYSTEM'
                THEN
                   '1'
                ELSE
                   'NULL'
             END)
         || ','
            Commission
    FROM dba_tab_columns a
   WHERE OWNER = 'JAROSODS' AND TABLE_NAME = 'VENDOR_MAS'
ORDER BY COLUMN_ID ASC;