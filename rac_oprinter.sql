set echo off
set serveroutput on size 1000000
set linesize 200
set pagesize 200
accept VPrinter prompt 'Enter the Oracle printer name: '

/* Script developed by Jorge Rios Blanco on 30-04-2012 */
/* Oracle Printer added                                */
/* TATA Consultancy Services Mexico                    */

Declare
  V_Printer_Name  Varchar2(150);
  V_Count         Number:=0;
  V_Length        Number:=0;
  V_Exist         Number:=0;
  V_Optio_Exist   Number:=0;

Cursor C_Printer_Details (VI_Printer_Name varchar2) Is
  Select Printer_Name,
         Printer_Type,
         Description
  From apps.Fnd_Printer_Vl
  Where Upper(Printer_name) Like Upper('%'||VI_Printer_Name||'%')
  Order By 1;

Begin
  V_Printer_Name :='&VPrinter';

  Select Length(V_Printer_Name)
  Into V_Length
  From dual;

  If V_Length > 0 Then

   Select Count(1)
   Into   V_Exist
   From   Fnd_Printer_Vl
   Where  Upper(Printer_name) LIKE Upper('%'||V_Printer_Name||'%');

   dbms_output.put_line('-                                                                     ');

   If V_Exist > 0 Then

    dbms_output.put_line('Name                  Type                            Description ');
    dbms_output.put_line('--------------------  ------------------------------  ----------------------------------------------------------------------');

    For RegPrinter In C_Printer_Details (V_Printer_Name) Loop
      V_Count:=V_Count+1;
      dbms_output.put_line(rpad(NVL(RegPrinter.Printer_Name,' '),20,' ')||'  '||rpad(NVL(RegPrinter.Printer_Type,' '),30,' ')||'  '||rpad(NVL(RegPrinter.Description,' '),70,' '));
    End Loop;  -- RegPrinter

    dbms_output.put_line('-                                                                     ');
    dbms_output.put_line('-----------------------------');
    dbms_output.put_line('Total Oracle Printers: '||V_Count);
   Else
    dbms_output.put_line('I did not find any Oracle printer with the provided name: '||V_Printer_Name);
   End If;  -- V_Exist

  End If; --  V_Length

End;
/
undef SSO

