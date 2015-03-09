-- This query gives records flagged as French that have the same prompt as US 
SELECT --/*+ RULE */ 
 c.user_menu_name, b.menu_id, b.ENTRY_SEQUENCE, b.language, A.prompt, b.prompt orig_prompt, b.last_updated_by, b.last_update_date--, c.last_updated_by 
FROM fnd_menu_entries_tl A 
	 ,fnd_menu_entries_tl b 
	 ,fnd_menus_tl c
WHERE A.language = 'US' 
AND b.language = 'F' 
AND UPPER(LTRIM(RTRIM(A.prompt))) = UPPER(LTRIM(RTRIM(b.prompt))) 
AND A.menu_id = b.menu_id 
AND A.entry_sequence = b.entry_sequence
and b.menu_id = c.menu_id
and c.language = 'US'
