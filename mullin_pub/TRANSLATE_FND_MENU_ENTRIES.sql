-- This script updates untranslated records if it can find a translation from another menu 
DECLARE
	   cnt	   				NUMBER			:= 0;
	   v_error_msg			VARCHAR2(80) 	:= NULL;
--
CURSOR Update_Prompt IS 
SELECT --/*+ RULE */
DISTINCT b.menu_id, b.ENTRY_SEQUENCE, b.language, a.prompt, b.prompt orig_prompt, c.prompt translated_prompt--, c.last_updated_by
FROM fnd_menu_entries_tl a
	 ,fnd_menu_entries_tl b
	 ,fnd_menu_entries_tl c
WHERE a.language = 'US'
AND b.language <> 'US'
AND LTRIM(RTRIM(a.prompt)) = LTRIM(RTRIM(b.prompt))
AND LTRIM(RTRIM(a.description)) = LTRIM(RTRIM(b.description))
AND a.menu_id = c.menu_id
AND a.entry_sequence = c.entry_sequence
AND b.language = c.language
AND LTRIM(RTRIM(a.prompt)) <> LTRIM(RTRIM(c.prompt))
AND c.last_updated_by IN (-1,0,1,2)
AND b.last_updated_by NOT IN (-1,0,1,2);
--
BEGIN
	 --
	 dbms_output.enable(200000);
	 --
	 BEGIN
	 	  --
	 	  FOR rec1 IN Update_Prompt LOOP
	   	  	  UPDATE FND_MENU_ENTRIES_TL
	   		  SET prompt 					 	= rec1.translated_prompt
	   	   	  	  ,SOURCE_LANG			  		= rec1.language
		   		  ,LAST_UPDATE_DATE	  			= SYSDATE
			  WHERE menu_id	  		  			= rec1.menu_id
			  AND	  entry_sequence			= rec1.entry_sequence
			  AND	  prompt					= rec1.orig_prompt
			  AND	  LANGUAGE					= rec1.language;
			  --
	   		  cnt := cnt +	SQL%ROWCOUNT;
			  --
	   		  IF cnt >= 5000 THEN    -- Commit every 5,000 records
	      	  	 COMMIT;
		  		 dbms_output.put_line('Translation of Prompt'||'--'||cnt||' Records Updated --'||TO_CHAR(SYSDATE,'mm/dd/rr hh:mi:ss'));
		  		 cnt := 0;
	   		  END IF;
			  --
		  END LOOP;
		  --
		  COMMIT;
		  --
		  dbms_output.put_line('Translation of Prompt'||'--'||cnt||' Records Updated --'||TO_CHAR(SYSDATE,'mm/dd/rr hh:mi:ss'));
		  --
		  cnt	   := 0;
		  --
		  EXCEPTION 
		  		WHEN OTHERS THEN
				 	   		v_error_msg := TO_CHAR(SQLCODE) || SQLERRM;
				 			dbms_output.put_line('When Others Exception Attribute_Label_Long'||'--'||v_error_msg||'--'||TO_CHAR(SYSDATE,'mm/dd/rr hh:mi:ss'));
		  --
	 END;
	 --
END;