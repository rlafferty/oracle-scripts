--*****************************************************************************************
--*																						  *
--*  FILENAME: GECM_TRANSLATE_MENU_ENTRIES.sql											  *
--*	 		   																			  *
--*  CREATED BY: MATTHEW MULLIN					     CREATION DATE: DEC  , 2002 		  *
--*	 		 	 		 							 		  							  *
--*  UPDATED BY: MATTHEW MULLIN						 UPDATE DATE:   JAN 31, 2003		  *
--*	 		 	 		 							 									  *
--*  DESCRIPTION: This script will update the Prompt and Description columns of the       *
--*	 			  FND Menu Entries TL tables where a corresponding translated Prompt or   *
--*				  Description is found.  The following example explains how this is       *
--*				  accomplished:	 		 	 		   		   					 		  *
--*				  	  		  	   		   			  		  	  	   		   	  		  *
--*				  Menu A includes an entry with a Prompt of 'Users' for US Language and   *
--*				  a Prompt of 'Utilisateurs' for French Language.		   				  *
--*				  Menu B includes an entry with a Prompt of 'Users' for US Language and   *
--*				  the untranslated Prompt of 'Users' for French Language.  				  *
--*				  This script will determine that the French prompt in Menu B is not	  *
--*				  translated and will find the translation from Menu A and perform the    *
--*				  update of Menu B.	  	   	   			   			   	   		   		  *
--*				  				  	   	   				   		  		   	  			  *
--*				  THIS SCRIPT MUST BE RUN AFTER EACH NEW LANGUAGE INSTALL TO TRANSLATE	  *
--*				  ANY CUSTOM MENUS THAT WERE COPIED FROM A STANDARD MENU PRIOR TO THE	  *
--*				  LANGUAGE INSTALL.			 			   				 	   	  		  *
--*				  	   		  	   	  	  	 	 	  									  *
--*****************************************************************************************		   	  
DECLARE
	   cnt	   				NUMBER			:= 0;
	   v_error_msg			VARCHAR2(80) 	:= NULL;
--
CURSOR Update_Prompt IS 
SELECT --/*+ RULE */
DISTINCT b.menu_id, b.ENTRY_SEQUENCE, b.language, A.prompt, b.prompt orig_prompt, c.prompt translated_prompt--, c.last_updated_by
FROM fnd_menu_entries_tl A
	 ,fnd_menu_entries_tl b
	 ,fnd_menu_entries_tl c
WHERE A.language = 'US'
AND b.language <> 'US'
AND UPPER(LTRIM(RTRIM(A.prompt))) = UPPER(LTRIM(RTRIM(b.prompt)))
AND A.menu_id = c.menu_id
AND A.entry_sequence = c.entry_sequence
AND b.language = c.language
AND UPPER(LTRIM(RTRIM(A.prompt))) <> UPPER(LTRIM(RTRIM(c.prompt)))
AND c.last_updated_by IN (-1,0,1,2)
AND b.last_updated_by NOT IN (-1,0,1,2);
--
CURSOR Update_descr IS 
SELECT --/*+ RULE */
DISTINCT b.menu_id, b.ENTRY_SEQUENCE, b.language, A.description, b.description orig_descr, c.description translated_descr--, c.last_updated_by
FROM fnd_menu_entries_tl A
	 ,fnd_menu_entries_tl b
	 ,fnd_menu_entries_tl c
WHERE A.language = 'US'
AND b.language <> 'US'
AND UPPER(LTRIM(RTRIM(A.description))) = UPPER(LTRIM(RTRIM(b.description)))
AND A.menu_id = c.menu_id
AND A.entry_sequence = c.entry_sequence
AND b.language = c.language
AND UPPER(LTRIM(RTRIM(A.description))) <> UPPER(LTRIM(RTRIM(c.description)))
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
				 			dbms_output.put_line('When Others Exception Prompt'||'--'||v_error_msg||'--'||TO_CHAR(SYSDATE,'mm/dd/rr hh:mi:ss'));
		  --
	 END;
	 --
	 BEGIN
	 	  --
	 	  FOR rec1 IN Update_descr LOOP
	   	  	  UPDATE FND_MENU_ENTRIES_TL
	   		  SET description 					 	= rec1.translated_descr
	   	   	  	  ,SOURCE_LANG			  		= rec1.language
		   		  ,LAST_UPDATE_DATE	  			= SYSDATE
			  WHERE menu_id	  		  			= rec1.menu_id
			  AND	  entry_sequence			= rec1.entry_sequence
			  AND	  description				= rec1.orig_descr
			  AND	  LANGUAGE					= rec1.language;
			  --
	   		  cnt := cnt +	SQL%ROWCOUNT;
			  --
	   		  IF cnt >= 5000 THEN    -- Commit every 5,000 records
	      	  	 COMMIT;
		  		 dbms_output.put_line('Translation of Description'||'--'||cnt||' Records Updated --'||TO_CHAR(SYSDATE,'mm/dd/rr hh:mi:ss'));
		  		 cnt := 0;
	   		  END IF;
			  --
		  END LOOP;
		  --
		  COMMIT;
		  --
		  dbms_output.put_line('Translation of Description'||'--'||cnt||' Records Updated --'||TO_CHAR(SYSDATE,'mm/dd/rr hh:mi:ss'));
		  --
		  cnt	   := 0;
		  --
		  EXCEPTION 
		  		WHEN OTHERS THEN
				 	   		v_error_msg := TO_CHAR(SQLCODE) || SQLERRM;
				 			dbms_output.put_line('When Others Exception Description'||'--'||v_error_msg||'--'||TO_CHAR(SYSDATE,'mm/dd/rr hh:mi:ss'));
		  --
	 END;
END;