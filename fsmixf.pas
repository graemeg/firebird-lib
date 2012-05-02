(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fsmixf.pas


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


unit fsmixf;

{$mode objfpc}{$H+}

interface

uses
  SysUtils{$IFNDEF UNIX},Registry, Windows{$ENDIF},ibase_h;


function TimeT(ADateTime: TDateTime): string;
function TypeDesc(const AType: SmallInt): string;
{$IFNDEF UNIX}
function GetProgramFilesDir: string;
function GetFirebirdDirectory: string;     // Firebird 1.5.x
function GetAppDataFolder: string;
{$ENDIF}
//function GetFileDialogFilter: string;

implementation

function TypeDesc(const AType: SmallInt): string;
begin
  Result := '';
  case AType of
    SQL_VARYING: Result := 'VARYING';
    SQL_TEXT: Result := 'TEXT';
    SQL_DOUBLE: Result := 'DOUBLE';
    SQL_FLOAT: Result := 'FLOAT';
    SQL_LONG: Result := 'LONG';
    SQL_SHORT: Result := 'SHORT';
    SQL_TIMESTAMP: Result := 'TIMESTAMP';
    SQL_BLOB: Result := 'BLOB';
    SQL_D_FLOAT: Result := 'D_FLOAT';
    SQL_ARRAY: Result := 'ARRAY';
    SQL_QUAD: Result := 'QUAD';
    SQL_TYPE_TIME: Result := 'TIME';
    SQL_TYPE_DATE: Result := 'DATE';
    SQL_INT64: Result := 'INT64';
  end;
end;

//------------------------------------------------------------------------------

function TimeT(ADateTime: TDateTime): string;
var
  h, m, s, ms: word;
begin
  DecodeTime(ADateTime, h, m, s, ms);
  if m > 0 then
    Result := Format('%dm and %d.%d s', [m, s, ms])
  else
    Result := Format('%d.%d s', [s, ms]);
end;

//------------------------------------------------------------------------------
{$IFNDEF UNIX}
function GetProgramFilesDir: string;
var
 Reg: TRegistry;
begin
 Result := '';
 Reg := TRegistry.Create;
  try
    Reg.Access := KEY_QUERY_VALUE;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion', False) then
    begin
      Result := Reg.ReadString('ProgramFilesDir');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

//------------------------------------------------------------------------------

function GetFirebirdDirectory: string;
var
 Reg: TRegistry;
begin
 Result := '';
 Reg := TRegistry.Create;
  try
    Reg.Access := KEY_QUERY_VALUE;
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\Software\Firebird Project\Firebird Server\Instances', False) then
    begin
      Result := Reg.ReadString('DefaultInstance');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;

//------------------------------------------------------------------------------

function GetAppDataFolder: string;
var
 Reg: TRegistry;
begin
 Result := '';
 Reg := TRegistry.Create;
  try
    Reg.Access := KEY_QUERY_VALUE;
    Reg.RootKey := HKEY_CURRENT_USER;
    if Reg.OpenKey('\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders', False) then
    begin
      Result := Reg.ReadString('AppData');
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
end;
    
{$ENDIF}

end.
