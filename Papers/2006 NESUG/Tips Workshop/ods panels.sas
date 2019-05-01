*** ODS & GRAPH FEATURES ;
*** PUTTING MULTIPLE GRAPHS & TABLES ON AN HTML PAGE ;
/* The guys at SAS have produced a wonderful new tagset (thanks Eric!) called the HTML Panel tagset. This will be available in SAS 9.2, but can be downloaded and used now from this page http://support.sas.com/rnd/base/topics/odsmarkup/htmlpanel.html, which also describes how to use it.
The tagset lets you do pretty much anything that you can do with the normal ODS HTML destination, except you can break your page up into rows and columns. So you could have 2 graphs at the top, followed by a table, then perhaps 3 columns with graphs in each, etc. Just use your imagination.
The following code gives you a bit of an idea what can be done with this tagset. It starts with 4 columns of bar charts, over 3 rows. Then it has a report. And finally 5 columns of pie charts over 2 rows.
Note: before you can use this tagset you need to download it and run the proc template code in SAS to define it. 
*/

%let panelcolumns = 4;
%let panelborder = 4;
ods tagsets.htmlpanel file="C:\workshop\hw06\bypanel2.html" gpath='c:\workshop\hw06\' options(doc='help');
goptions device=java xpixels=320 ypixels=240;

title1 'Product Reports' ;
footnote1 ;
proc summary data=sashelp.shoes nway ;
  class region product ;
  var stores sales inventory returns ;
  output out=sum sum= mean= /autolabel autoname ;
run ;

proc gchart data=sum ;
  by region ;
  vbar product / sumvar=sales_sum pattid=midpoint discrete ;
run;
quit;

proc summary data=sashelp.shoes nway ;
  class region subsidiary ;
  var stores sales inventory returns ;
  output out=sum sum= mean= /autolabel autoname ;
run ;

%let panelcolumns = 5;
%let panelborder = 1;
ods tagsets.htmlpanel ;

title 'Summary data' ;
proc print data=sum ;
run ;

title 'Subsidiary Reports' ;
%let panelcolumns = 5;
%let panelborder = 1;
ods tagsets.htmlpanel ;
goptions dev=java xpixels=160 ypixels=120;
proc gchart data=sum ;
  by region ;
  pie subsidiary / sumvar=sales_sum discrete ;
run;
quit;
ods _all_ close;

