-- This query return translated content for a specific Menu Name 
select a.language, a.menu_id, d.grant_flag, c.menu_name, a.user_menu_name, a.description, a.last_update_date, b.entry_sequence, b.prompt, b.description, d.sub_menu_id, d.function_id 
from fnd_menus_tl a 
	 ,fnd_menu_entries_tl b 
	 ,fnd_menus c 
	 ,fnd_menu_entries d 
where c.menu_name = :menu 
and   c.MENU_ID = a.MENU_id 
and	  c.menu_id = d.menu_id 
and	  d.menu_id = b.menu_id 
and	  d.entry_sequence = b.entry_sequence 
and	  a.language =  b.language  
order by b.entry_sequence
