/* EXPORTING DATA TO MICROSOFT ACCESS VIA XML */

libname access xml 'c:\workshop\hw06\test.xml'
         xmltype=msaccess xmlmeta=schemadata;

data test(index=(year month)) ;
  set sashelp.retail ;
run ;

proc copy in=work out=access index=yes ;
  select test ;
run ;

libname access ;
