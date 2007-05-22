fblib firebird library version 0.84

Compilers supported
  
  Delphi 4 standard ,pro ,ent
  Delphi 5 standard ,pro ,ent
  Delphi 6 personal* ,pro ,ent
  Delphi 7 personal* ,pro ,ent
  Turbo Delphi explore (only as library)  *

  Kylix 2  open*, pro, ent
  Kylix 3  open*, pro, ent

  * NO component TFBLDataset(1) ;

  freepascal 2.0 or above 
  lazarus ide 0.9.10 or above

Firebird server supperted

 1.0.x superserver classic
 1.5.x superserver classic
 2.0.x superserver classic


version 0.80 is thread safe (experimental feature) 
components  thread safe are TFBLDatabase,TFBLTransaction,TFBLDsql 

for default fblib is NOT thread safe for
enable this feature activate compiler directive
FBL_THREADSAFE in fbl.inc.


for generate documetation follow these steps:

1) download pasdoc from http://pasdoc.sourceforge.net
2) compile pasdoc ,I used freepascal 2.0
3) go to fblib source directory
4) in win run  makehelp.bat, in linux run makehelp.sh 
5) this script will create a directory name FblibHelp with docs, open index.html with your favorite browser. 

note for turbodelphi User

  in turbo delphi explorer You cannot install components in the ide,
  package FBLTurbo.dpk is only for turbo delphi professional.

  in turbo delphi explorer add in  library path the fblib installation path and
  use fblib as class library.
  see turbodelphi examples;  


(1)
in version 0.85 there is a new component TFBLDataset is an TDataset discendant.

Limits:
   Unidirectional 
   Read Only
   params not supported yet 

see ClientDataset example in <fblib>\examples\turbodelphi\ directory 

  
    