set echo on
set head off
define sso='&sso2'
define rol='&rol2'

select 'CREATE USER SSO'||&sso||CHR(10)||
'IDENTIFIED BY '||DB_HO.FRANDOMPASS('ululnpnlulu')||CHR(10)||
'DEFAULT TABLESPACE EXA_DATA'||CHR(10)||
'TEMPORARY TABLESPACE TEMP'||CHR(10)||
'PROFILE DEFAULT'||CHR(10)||
'ACCOUNT UNLOCK;'||CHR(10)||
'GRANT CONNECT TO SSO'||&sso||';'||CHR(10)||
-- 'GRANT GET_FINREPT_LOOKER TO SSO'||&sso||';'||CHR(10)||
-- 'GRANT GET_DW_HRCONF_LOOKER TO SSO'||&sso||';'||CHR(10)||
'GRANT '||'&rol'||' TO SSO'||&sso||';'||CHR(10)||
'GRANT DEBUG ANY PROCEDURE TO SSO'||&sso||';'||CHR(10)||
'ALTER USER SSO'||&sso||' DEFAULT ROLE ALL;' from dual;
