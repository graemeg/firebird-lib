(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org
   
   file:fsconfig.pas


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

{$mode objfpc}{$H+}

unit fsconfig;

interface

uses SysUtils, Classes, Forms, Graphics,
     iniFiles,ibase_h;

var
  max_fetch: integer;
  max_grid_rows: integer;
  auto_commit_ddl: boolean;
  show_system_objs: boolean;
  verbose_sql_script: boolean;
  show_set_term: boolean;
  set_output_grid: integer; // 0 string grid 1 memo
  FILE_DIALOG_FILTER: string;
  FILE_DIALOG_EXT: string;
  APP_DATA: string;
  last_alias_connected: string;

const
  APP_TITLE = 'fenixsql';
  APP_VERSION = '0.42 alpha';
  ALIAS_INI_FILE = 'aliases.ini';
  CONFIG_INI_FILE = 'config.ini';
  HISTORY_INI_FILE = 'history.ini';
  CONFIG_INI_DIR = '.fenixsql';
  (* config.ini section *)
  SECTION_GENERAL = 'GENERAL';
  SECTION_PATH = 'PATH';
  SECTION_SECURE_DB = 'SECURE-DB';
  SECTION_FONT_BROWSER = 'FONT/BROWSER';
  SECTION_FONT_EDIT = 'FONT/EDIT';
  SECTION_FONT_TEXTGRID = 'FONT/TEXTGRID';
  SECTION_FONT_MEMO = 'FONT/MEMO';


procedure InitFileConfig;
function GetAliasIniFile: string;
function GetConfigIniFile: string;
function GetHistoryIniFile: string;
procedure ReadConfigFile;
procedure WriteConfigFile;
procedure WriteConfigEdit(const ASection: string; AFont: TFont; ABackColor: TColor);
procedure ReadConfigEdit(const ASection: string; AFont: TFont; var ABackColor: TColor);
procedure WriteConfigSynEdit;
procedure ReadConfigSynEdit;
procedure SaveHistory(const AAlias: string; AHistory: TStrings);
procedure LoadHistory(const AAlias: string; AHistory: TStrings);
procedure DeleteHistory(const AAlias: string);
procedure SaveFormPos(AForm: TForm);
procedure LoadFormPos(AForm: TForm);
procedure GetAliasNames(AAliases: TStrings);

implementation

uses
  fsdm{$IFNDEF UNIX}, fsmixf{$ENDIF};


procedure InitFileConfig;
begin
  {$IFDEF UNIX}
  APP_DATA := GetEnvironmentVariable('HOME') + '/';
  if not DirectoryExists(APP_DATA +  CONFIG_INI_DIR) then
    mkdir(APP_DATA +  CONFIG_INI_DIR);
  {$ELSE}
  APP_DATA := GetAppDataFolder + '\';
  if not DirectoryExists(APP_DATA + CONFIG_INI_DIR) then
    mkdir(APP_DATA + CONFIG_INI_DIR);
  {$ENDIF}
end;

//------------------------------------------------------------------------------

function GetAliasIniFile: string;
begin
  {$IFDEF UNIX}
  Result := APP_DATA + CONFIG_INI_DIR + '/' + ALIAS_INI_FILE;
  {$ELSE}
  Result := APP_DATA + CONFIG_INI_DIR + '\' + ALIAS_INI_FILE;
  {$ENDIF}
end;

//------------------------------------------------------------------------------


function GetConfigIniFile: string;
begin
  {$IFDEF UNIX}
  Result := APP_DATA + CONFIG_INI_DIR + '/' + CONFIG_INI_FILE;
  {$ELSE}
  Result := APP_DATA + CONFIG_INI_DIR + '\' + CONFIG_INI_FILE;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

function GetHistoryIniFile: string;
begin
  {$IFDEF UNIX}
  Result := APP_DATA + CONFIG_INI_DIR + '/' + HISTORY_INI_FILE;
  {$ELSE}
  Result := APP_DATA + CONFIG_INI_DIR + '\' + HISTORY_INI_FILE;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure ReadConfigFile;
var
  iniFile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    last_alias_connected := iniFile.ReadString(SECTION_GENERAL,'LastAliasConnected','');
    max_fetch := inifile.ReadInteger(SECTION_GENERAL,'MaxFetch',0);
    max_grid_rows := inifile.ReadInteger(SECTION_GENERAL,'MaxGridRows',6000);
    if (max_grid_rows  < 500) and (max_grid_rows > 10000) then  max_grid_rows := 6000;
    auto_commit_ddl := inifile.ReadBool(SECTION_GENERAL, 'AutoCommitDDL', False);
    show_system_objs := inifile.ReadBool(SECTION_GENERAL, 'ShowSystemObjs', False);
    verbose_sql_script := inifile.ReadBool(SECTION_GENERAL, 'VerboseSqlScript', False);
    show_set_term := inifile.ReadBool(SECTION_GENERAL, 'ShowSetTerm', False);
    set_output_grid := inifile.ReadInteger(SECTION_GENERAL, 'SetOutputGrid', 0);
  finally
    iniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure WriteConfigFile;
var
  iniFile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    IniFile.WriteString(SECTION_GENERAL,'LastAliasConnected',last_alias_connected);
    IniFile.WriteInteger(SECTION_GENERAL,'MaxFetch',max_fetch);
    IniFile.WriteInteger(SECTION_GENERAL,'MaxGridRows',max_grid_rows);
    IniFile.WriteBool(SECTION_GENERAL, 'AutoCommitDDL', auto_commit_ddl);
    Inifile.WriteBool(SECTION_GENERAL, 'ShowSystemObjs', show_system_objs);
    Inifile.WriteBool(SECTION_GENERAL, 'VerboseSqlScript', verbose_sql_script);
    Inifile.WriteBool(SECTION_GENERAL, 'ShowSetTerm', show_set_term);
    inifile.WriteInteger(SECTION_GENERAL, 'SetOutputGrid', set_output_grid);
    iniFile.UpdateFile;
  finally
    iniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure WriteConfigEdit(const ASection: string; AFont: TFont; ABackColor: TColor);
var
  Inifile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    IniFile.WriteString(ASection, 'Name', AFont.Name);
    inifile.WriteInteger(ASection, 'Size', AFont.Size);
    inifile.WriteInteger(ASection, 'Height', AFont.Height);
    inifile.WriteString(ASection, 'Foreground', ColorToString(AFont.Color));
    inifile.WriteString(ASection, 'Background', ColorToString(ABackColor));
    inifile.WriteBool(ASection, 'Bold', fsBold in AFont.Style);
    inifile.WriteBool(ASection, 'Italic', fsItalic in AFont.Style);
    inifile.WriteBool(ASection, 'Underline', fsItalic in AFont.Style);
    inifile.WriteBool(ASection, 'StrikeOut', fsStrikeOut in AFont.Style);
    inifile.WriteInteger(ASection, 'CharSet', Integer(AFont.CharSet));
    inifile.UpdateFile;
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure ReadConfigEdit(const ASection: string; AFont: TFont; var ABackColor: TColor);
var
  Inifile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    if inifile.SectionExists(ASection) then
    begin
      AFont.Name := inifile.ReadString(ASection, 'Name', '');
      AFont.Size := Inifile.ReadInteger(ASection, 'Size', 0);
      AFont.Height := inifile.ReadInteger(ASection, 'Height',0);
      AFont.Color := StringToColor(IniFile.ReadString(ASection, 'Foreground', ''));
      ABackColor := StringToColor(Inifile.ReadString(ASection, 'Background', ''));
      if IniFile.ReadBool(ASection, 'Bold', False) then
        AFont.Style := AFont.Style + [fsBold];
      if IniFile.ReadBool(ASection, 'Italic', False) then
        AFont.Style := AFont.Style + [fsItalic];
      if IniFile.ReadBool(ASection, 'Underline', False) then
        AFont.Style := AFont.Style + [fsUnderline];
      if IniFile.ReadBool(ASection, 'StrikeOut', False) then
        AFont.Style := AFont.Style + [fsStrikeOut];
      AFont.CharSet := TFontCharSet(inifile.ReadInteger(ASection, 'CharSet', 0));
    end;
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------


procedure WriteConfigSynEdit;
var
  Inifile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    dmib.SynSQLSyn1.CommentAttri.SaveToFile(IniFile);
    dmib.SynSQLSyn1.KeyAttri.SaveToFile(IniFile);
    dmib.SynSQLSyn1.StringAttri.SaveToFile(IniFile);
    dmib.SynSQLSyn1.NumberAttri.SaveToFile(IniFile);
    dmib.SynSQLSyn1.TableNameAttri.SaveToFile(IniFile);
    dmib.SynSQLSyn1.DataTypeAttri.SaveToFile(IniFile);
    dmib.SynSQLSyn1.IdentifierAttri.SaveToFile(IniFile);
    inifile.UpdateFile;
  finally
    IniFile.Free;
  end;
end;


//------------------------------------------------------------------------------

procedure ReadConfigSynEdit;
var
  Inifile: TiniFile;
begin
  IniFile := TiniFile.Create(GetConfigIniFile);
  try
    dmib.SynSQLSyn1.CommentAttri.LoadFromFile(IniFile);
    dmib.SynSQLSyn1.KeyAttri.LoadFromFile(IniFile);
    dmib.SynSQLSyn1.StringAttri.LoadFromFile(IniFile);
    dmib.SynSQLSyn1.NumberAttri.LoadFromFile(IniFile);
    dmib.SynSQLSyn1.TableNameAttri.LoadFromFile(IniFile);
    dmib.SynSQLSyn1.DataTypeAttri.LoadFromFile(IniFile);
    dmib.SynSQLSyn1.IdentifierAttri.LoadFromFile(IniFile);
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure SaveHistory(const AAlias: string; AHistory: TStrings);
var
  Inifile: TiniFile;
  il,i: integer;
  function StringToEx(const AString: string): string;
  var
    len, i: integer;
  begin
    len := Length(AString);
    Result := '';
    for i := 1 to len do
      Result := Result + LowerCase(IntToHex(Integer(AString[i]), 2));
  end;
begin
  IniFile := TiniFile.Create(GetHistoryIniFile);
  try
    i := 0;
    il := AHistory.Count -1 ;
    if inifile.SectionExists(AAlias) then
     IniFile.EraseSection(AAlias);
    while (il > -1) and (i < 10) do
    begin
      Inifile.WriteString(AAlias, 'stm' + IntToStr(i), StringToEx(AHistory.Strings[il]));
      Dec(il);
      Inc(i);
    end;
    inifile.UpdateFile;
  finally
    inifile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure LoadHistory(const AAlias: string; AHistory: TStrings);
var
  IniFile: TiniFile;
  Key: TStringList;
  i: integer;
  function ExToString(const AString: string): string;
  var
    b: PChar;
    len: Integer;
  begin
    Len := Length(AString) div 2;
    GetMem(PChar(b), Len);
    SetLength(Result, Len);
    try
      HexToBin(PChar(AString), b, Len);
      Move(b[0], Result[1], Len);
    finally
      FreeMem(b);
    end;
  end;
begin
  IniFile := TiniFile.Create(GetHistoryIniFile);
  Key := TStringList.Create;
  try
    if IniFile.SectionExists(AAlias) then
    begin
      iniFile.ReadSection(AAlias, Key);
      for i := Key.Count -1  downto 0 do
        AHistory.Add(ExToString(IniFile.ReadString(AAlias, Key.Strings[i], '')));
    end;
  finally
    Key.Free;
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure DeleteHistory(const AAlias: string);
var
  Inifile: TiniFile;
begin
  IniFile := TIniFile.Create(GetHistoryIniFile);
  try
    if inifile.SectionExists(AAlias) then
    begin
      IniFile.EraseSection(AAlias);
      IniFile.UpdateFile;
    end;
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure SetDefaultVariable;
var
 ProgramFilesDir: string;
 FirebirdDirectory: string;
begin
  {$IFDEF UNIX}
    ProgramFilesDir := '/opt';
  {$ELSE}
    ProgramFilesDir := GetProgramFilesDir;
    FirebirdDirectory := GetFirebirdDirectory;
    if FireBirdDirectory = '' then
      if GetFbClientVersion = 7  then
        FirebirdDirectory := ProgramFilesDir + '\Firebird\Firebird_1_5\';

  {$ENDIF}
  if GetFbClientVersion = 7 then
  begin
   FILE_DIALOG_FILTER := 'Firebird (*.fdb)|*.fdb;*.FDB|Interbase/Firebird 1.0 (*.gdb)|*.gdb';
   FILE_DIALOG_EXT := 'fdb';
  end
  else
  begin
   FILE_DIALOG_FILTER := 'Interbase/Firebird 1.0 (*.gdb)|*.gdb;*.GDB|Firebird (*.fdb)|*.fdb';
   FILE_DIALOG_EXT := 'gdb';
  end;
end;

//------------------------------------------------------------------------------

procedure SaveFormPos(AForm: TForm);
var
  Inifile: TiniFile;
  Section: string;
begin
  IniFile := TIniFile.Create(GetConfigIniFile);
  Section := AForm.Name;
  try
     Inifile.WriteInteger(Section, 'Top', AForm.Top);
     Inifile.WriteInteger(Section, 'Left', AForm.Left);
     Inifile.WriteInteger(Section, 'Height', AForm.Height);
     Inifile.WriteInteger(Section, 'Width', AForm.Width);
     IniFile.UpdateFile;
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure LoadFormPos(AForm: TForm);
var
  Inifile: TiniFile;
  Section: string;
begin
  IniFile := TIniFile.Create(GetConfigIniFile);
  Section := AForm.Name;
  try
    if inifile.SectionExists(Section) then
    begin
      AForm.Left := Inifile.ReadInteger(Section,'Left',0);
      AForm.Top := Inifile.ReadInteger(Section,'Top',0);
      AForm.Height := IniFile.ReadInteger(Section,'Height',300);
      Aform.Width := Inifile.ReadInteger(Section,'Width',300);
    end;
  finally
    Inifile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure GetAliasNames(AAliases: TStrings);
var
  inifile: TIniFile;
begin
  inifile := TiniFile.Create(GetAliasIniFile);
  try
    inifile.ReadSections(AAliases);
  finally
    inifile.Free
  end;
end;

//------------------------------------------------------------------------------

initialization
 SetDefaultVariable;

end.
