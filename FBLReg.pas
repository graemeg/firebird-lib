(*
   Firebird Library
   Open Source Library No Data Aware for direct access to Firebird
   Relational Database from Borland Delphi / Kylix and Free Pascal

   File:FBLReg.pas
   Copyright (c) 2002-2004 Alessandro Batisti
   fblib@altervista.org
   http://fblib.altervista.org

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.
*)


unit FBLReg;

{$I fbl.inc}

{$IFNDEF FPC}
{$R fblpalette.res}
{$ENDIF}

interface

uses
  Classes,
  FBLDatabase,
  FBLTransaction,
  FBLDsql,
  FBLMetadata,
  FBLScript,
  FBLService,
  FBLEvents,
  FBLParamDsql
  {$IFNDEF DELPHI_PE}
   ,FBLDataset
  {$ENDIF}
  {$IFDEF FPC}
   ,LResources
  {$ENDIF};

const
  PALETTE_NAME = 'FBLib';

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents(PALETTE_NAME, [TFBLDatabase, TFBLTransaction,
    TFBLDsql, TFBLMetadata, TFBLSCript, TFBLService, TFBLEvent, TFBLParamDsql
    {$IFNDEF DELPHI_PE},TFBLDataset{$ENDIF}]);
end;




{$IFDEF FPC}
initialization
  {$I fblpalette.lrs}
{$ENDIF}
end.
