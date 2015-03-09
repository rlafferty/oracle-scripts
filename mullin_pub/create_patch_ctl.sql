-- This query can be used to create a patch control file for all Langs 
select :patchnbr||'_'||language_code
from fnd_languages
where installed_flag = 'I'