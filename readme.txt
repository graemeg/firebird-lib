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

  Free Pascal 2.0 or above
  Lazarus IDE 0.9.10 or above

Firebird server supported

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
2) compile pasdoc, I used Free Pascal 2.0
3) go to fblib source directory
4) in Windows run makehelp.bat, in Linux run makehelp.sh
5) this script will create a directory name FblibHelp with docs, open
   index.html with your favorite web browser.

note for Turbo Delphi users

  In Turbo Delphi Explorer you cannot install components in the IDE.
  The package FBLTurbo.dpk is only for Turbo Delphi Professional.

  In Turbo Delphi Explorer add in library path the fblib installation path and
  use fblib as class library.
  see turbodelphi examples;  


(1)
in version 0.85 there is a new component TFBLDataset is an TDataset descendant.

Limits:
   Unidirectional 
   Read Only
   params not supported yet 

see ClientDataset example in <fblib>\examples\turbodelphi\ directory 

  
    
