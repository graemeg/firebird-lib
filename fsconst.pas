(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fsconst.pas


  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.

*)

unit fsconst;

interface

const
  CR = #13;
  LF = #10;
  TAB = #9;
  {$IFDEF UNIX}
  NEW_LINE = LF;
  {$ELSE}
  NEW_LINE = CR + LF;
  {$ENDIF}
  //FILE_DIALOG_FILTER = 'Firebird (*.fdb)|*.fdb|Interbase/Firebird 1.0 (*.gdb)|*.gdb'; 

implementation


end.
