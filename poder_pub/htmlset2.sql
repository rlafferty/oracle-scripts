define _htmlset2_cell_wrap=&1
define _htmlset2_title="&2"
define _htmlset2_tab_bg=&3
define _htmlset2_tab_fg=&4

set markup HTML -
  HEAD "<style type='text/css'> - 
  BODY{ font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
  P  {  font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
  TABLE,TR,TD -
     {  font:10pt Arial,Helvetica,sans-serif; color:&_htmlset2_tab_fg; background:&_htmlset2_tab_bg; -
        padding:0px 0px 0px 0px; margin:0px 0px 0px 0px; white-space:&_htmlset2_cell_wrap;} -
  TH {  font:bold 10pt Arial,Helvetica,sans-serif; color:#336699; background:#cccc99; -
        padding:0px 0px 0px 0px;} -
  H1 {  font:16pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; -
        border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;} -
  H2 {  font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; -
        margin-top:4pt; margin-bottom:0pt;} a {font:9pt Arial,Helvetica,sans-serif; color:#663300; -
        background:#ffffff; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
  </style> -
  <title>&_htmlset2_title</title>" -
BODY "" -
TABLE "border='1' align='center' summary='Script output'" -
SPOOL ON ENTMAP ON PREFORMAT OFF


undefine _htmlset2_cell_wrap
undefine _htmlset2_title
undefine _htmlset2_tab_bg
undefine _htmlset2_tab_fg
