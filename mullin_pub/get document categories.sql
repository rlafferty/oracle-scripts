-- This script checks to determine if there are any document categories where the
-- Replacement Document has not been loaded.  This is necessary for the removal of 
-- File Attachments during an instance refresh.
Declare
--
  v_count	number	:=0;
--
Begin
  dbms_output.enable(200000);
  --
	 Select * into v_count
	 from (select count(distinct fdct.user_name)
		   from fnd_documents fd, fnd_document_categories fdc, fnd_document_categories_tl fdct 
		   where fd.category_id = fdc.category_id 
		   and fdc.category_id = fdct.category_id
		   and fdct.language = 'US'
		   and fd.datatype_id = 6
		   minus
		   select count(distinct fdct.user_name) 
		   from fnd_documents fd, fnd_documents_tl fdt,fnd_document_categories fdc, fnd_document_categories_tl fdct 
		   where fd.category_id = fdc.category_id 
		   and fdc.category_id = fdct.category_id
		   and fd.document_id = fdt.document_id
		   and fdt.language = 'US'
		   and fdct.language = 'US'
		   and fd.datatype_id = 6
		   and fdt.description = 'Replacement Document - LOB Storage POC');
	 --
	 If v_count <> 0 then
	 --	   
	 	   dbms_output.put_line('Replacment Document has not been uploaded for ALL Document Categories.');
		   dbms_output.put_line('Please execute $DBA_HOME/sql/check_missing_doc_categories.sql to determine what is missing.');
		   RETURN;
	 --
	 End if;
	 --	   
exception when no_data_found then
		  dbms_output.put_line('Replacement Documents are loaded for ALL Categories.');	 
end;
