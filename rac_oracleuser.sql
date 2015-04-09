set echo off
set serveroutput on size 1000000
set linesize 200
set pagesize 200
accept SSO prompt 'Enter Oracle username: '

/* Script developed by Jorge Rios Blanco on 28-03-2012 */
/* Oracle User responsibilities and profiles           */
/* TATA Consultancy Services Mexico                    */


Declare
  V_SSO_ID varchar2(30);
  V_Count Number;
  V_Name HR_EMPLOYEES_ALL_V.FULL_NAME%TYPE;

Cursor C_User_Details (VI_SSO_ID varchar2) Is
  Select fu.user_id
         ,fu.user_name
         ,fu.description description
         ,fu.email_address e_mail
         ,fu.employee_id
         ,fu.start_date
         ,fu.end_date
  From   apps.Fnd_user fu
  Where  fu.User_name = VI_SSO_ID
  Order by 1;

Cursor C_Resp (VI_USER_ID number) Is
  Select rpad(Substr(responsibility_name,1,50),50,' ') responsibility_name
        ,rpad(Substr(fa.application_name,1,40),40,' ') aplication
        ,rpad(frp.start_date,10,' ') start_date
        ,rpad(frp.end_date,9,' ') end_date
  From apps.fnd_user_resp_groups_direct frp
         ,(SELECT /* $HEADER$ */ B.ROWID ROW_ID , B.WEB_HOST_NAME , B.WEB_AGENT_NAME , B.APPLICATION_ID ,
                  B.RESPONSIBILITY_ID , B.RESPONSIBILITY_KEY , B.LAST_UPDATE_DATE , B.LAST_UPDATED_BY , B.CREATION_DATE ,
                  B.CREATED_BY , B.LAST_UPDATE_LOGIN , B.DATA_GROUP_APPLICATION_ID ,
                  B.DATA_GROUP_ID , B.MENU_ID , B.START_DATE , B.END_DATE , B.GROUP_APPLICATION_ID , B.REQUEST_GROUP_ID ,
                  B.VERSION , T.RESPONSIBILITY_NAME , T.DESCRIPTION
           FROM   apps.FND_RESPONSIBILITY_TL T
                 ,apps.FND_RESPONSIBILITY B
           WHERE     B.RESPONSIBILITY_ID = T.RESPONSIBILITY_ID
                 AND B.APPLICATION_ID = T.APPLICATION_ID
                 AND T.LANGUAGE = 'US') fv
         ,(SELECT B.ROWID ROW_ID , B.APPLICATION_ID , B.APPLICATION_SHORT_NAME , B.LAST_UPDATE_DATE , B.LAST_UPDATED_BY , B.CREATION_DATE
                , B.CREATED_BY , B.LAST_UPDATE_LOGIN , B.BASEPATH , B.PRODUCT_CODE , T.APPLICATION_NAME , T.DESCRIPTION
           FROM Apps.FND_APPLICATION_TL T, Apps.FND_APPLICATION B
           WHERE B.APPLICATION_ID = T.APPLICATION_ID AND T.LANGUAGE = 'US') fa
  Where frp.user_id=VI_USER_ID
        and fv.application_id=fa.application_id
        and frp.responsibility_id=fv.responsibility_id
  Order by 1;

Cursor C_Profile (VII_USER_ID number) Is
  Select  rpad(Substr(po.user_profile_option_name,1,50),50,' ') Profile
         ,rpad(Substr(pov.profile_option_value,1,60),60,' ') Value
    FROM (SELECT B.ROWID ROW_ID , B.APPLICATION_ID , B.PROFILE_OPTION_ID , B.PROFILE_OPTION_NAME , B.LAST_UPDATE_DATE , B.LAST_UPDATED_BY , B.CREATION_DATE
             , B.CREATED_BY , B.LAST_UPDATE_LOGIN , B.WRITE_ALLOWED_FLAG , B.READ_ALLOWED_FLAG , B.USER_CHANGEABLE_FLAG , B.USER_VISIBLE_FLAG , B.SITE_ENABLED_FLAG
             , B.SITE_UPDATE_ALLOWED_FLAG , B.APP_ENABLED_FLAG , B.APP_UPDATE_ALLOWED_FLAG , B.RESP_ENABLED_FLAG , B.RESP_UPDATE_ALLOWED_FLAG , B.USER_ENABLED_FLAG
             , B.USER_UPDATE_ALLOWED_FLAG , B.START_DATE_ACTIVE , B.SQL_VALIDATION , B.END_DATE_ACTIVE , T.USER_PROFILE_OPTION_NAME , B.HIERARCHY_TYPE
             , B.SERVER_ENABLED_FLAG , B.SERVER_UPDATE_ALLOWED_FLAG , B.ORG_ENABLED_FLAG , B.ORG_UPDATE_ALLOWED_FLAG ,B.SERVERRESP_ENABLED_FLAG
              ,B.SERVERRESP_UPDATE_ALLOWED_FLAG , T.DESCRIPTION DESCRIPTION
        FROM Apps.FND_PROFILE_OPTIONS_TL T
           , Apps.FND_PROFILE_OPTIONS B
        WHERE B.PROFILE_OPTION_NAME = T.PROFILE_OPTION_NAME AND T.LANGUAGE = 'US') po
       ,apps.fnd_profile_option_values pov
       ,apps.fnd_user usr
       ,apps.fnd_application app
       ,apps.fnd_responsibility rsp
  Where usr.User_id = VII_USER_ID
        And pov.application_id = po.application_id
        And pov.profile_option_id =   po.profile_option_id
        And usr.user_id(+) = pov.level_value
        And rsp.application_id(+) =  pov.level_value_application_id
        And rsp.responsibility_id(+) = pov.level_value
        And app.application_id(+)   = pov.level_value
  Order by 1;


Begin

  V_SSO_ID :='&SSO';
  For RegUserDetails In C_User_Details (V_SSO_ID) Loop
    V_Count:=V_Count+1;
    V_Name:=' ';

    Begin
      Select FULL_NAME
      Into V_Name
      From HR_EMPLOYEES_ALL_V
      Where Employee_Id = RegUserDetails.employee_id;
   Exception
     When Others then
       V_Name:=' ';
    End;

    dbms_output.put_line('-                                                                     ');
    dbms_output.put_line('=========================================================================');
    dbms_output.put_line('User               : '||RegUserDetails.user_name);
    dbms_output.put_line('Description        : '||RegUserDetails.description);
    dbms_output.put_line('E-mail address     : '||RegUserDetails.e_mail);
    dbms_output.put_line('Employee           : '||V_Name);
    dbms_output.put_line('Account Start Date : '||RegUserDetails.start_date);
    dbms_output.put_line('Account End Date   : '||RegUserDetails.end_date);
    dbms_output.put_line('=========================================================================');
    dbms_output.put_line('-                                                                     ');
    dbms_output.put_line('-                                                                     ');
    dbms_output.put_line('Profile                                             Value');
    dbms_output.put_line('--------------------------------------------------  ---------------------------------------------------------------');
    For RegProfile In C_Profile (RegUserDetails.user_id) Loop
      dbms_output.put_line(RegProfile.Profile||'  '||RegProfile.Value);
    End Loop;
    dbms_output.put_line('-                                                                     ');
    dbms_output.put_line('-                                                                     ');
    dbms_output.put_line('Start Date  End Date   Responsibility                                      Application');
    dbms_output.put_line('----------  ---------  --------------------------------------------------  ----------------------------------------');
    V_Count:=0;
    For RegResp In C_Resp (RegUserDetails.user_id) Loop
      V_Count:=V_Count+1;
      dbms_output.put_line(RegResp.start_date||'  '||rpad(NVL(RegResp.end_date,' '),9,' ')||'  '||RegResp.responsibility_name||'  '||RegResp.aplication);
    End Loop;
  End Loop;  -- RegUserDetails

If V_Count > 0 Then
 dbms_output.put_line('-                                                                     ');
 dbms_output.put_line('----------------------------');
 dbms_output.put_line('Total Responsibilities: '||V_Count);
 dbms_output.put_line('=========================================================================');
Else
 dbms_output.put_line('-                                                                     ');
 dbms_output.put_line('The user '||V_SSO_ID||' is not created... ');
 dbms_output.put_line('-                                                                     ');
End if;


End;
/

