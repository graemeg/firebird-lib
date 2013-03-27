(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://web.tiscali.it/fblib

   File: fscreatedb.pas

  * This file is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This file is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
*)

unit fscreatedb;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, ExtCtrls, Buttons, FBLExcept;

type

  { TfrmCreateDb }

  TfrmCreateDb = class(TForm)
    btnCreateDB: TBitBtn;
    btnCancel: TBitBtn;
    cbPageSize: TComboBox;
    cbDialect: TComboBox;
    cbCharset: TComboBox;
    edUserName: TEdit;
    edPassword: TEdit;
    edFileName: TEditButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LSql: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    sdDb: TSaveDialog;
    procedure btnCreateDBClick(Sender: TObject);
    procedure edFileNameButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    function CheckFileName(const AFileName: string): boolean;
  public
    { public declarations }
  end; 

//var
  //frmCreateDb: TfrmCreateDb;


implementation

uses
   fsdm, fsconst, fsconfig;


{ TfrmCreateDb }

function TfrmCreateDB.CheckFileName(const AFileName: string): boolean;
var
  Test: string ;
begin
  Result := False;
  if AFileName = '' then
  begin
    ShowMessage('"DB File Name" cannot be blank');
    Exit;
  end;
  if Length(AFileName) < 5 then
  begin
    ShowMessage('File Name not valid');
    Exit;
  end;
  Test :=  UpperCase(ExtractFileExt(AFileName));
  if (Test <> '.GDB') and (Test <> '.FDB') then
  begin
    ShowMessage('File Name not valid');
    Exit;
  end;
  if FileExists(AFileName) then
  begin
    ShowMessage(AFileName + ' already exists');
    Exit;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------


procedure TfrmCreateDb.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
  cbDialect.ItemIndex := 0;    // dialect 3
  cbPagesize.ItemIndex := 2;   // page size 4096
  cbCharset.ItemIndex := 0;
end;

//------------------------------------------------------------------------------

procedure TfrmCreateDb.btnCreateDBClick(Sender: TObject);
var
  FileName: string;
begin
   FileName := Trim(edFileName.Text);
  try
    if CheckFileName(FileName) then
    begin
      if cbCharset.Text = 'NONE' then
        dmib.dbMain.CreateDatabase(FileName, edUserName.Text, edPassword.Text,
          StrToInt(cbDialect.Text), StrToInt(cbPageSize.Text))
      else
        dmib.dbMain.CreateDatabase(FileName, edUserName.Text, edPassword.Text,
          StrToInt(cbDialect.Text), StrToInt(cbPageSize.Text), cbCharset.Text);
      ShowMessage('Database' + #10 + edFileName.Text + #10 + 'Created');
    end;
  except
    on E: EFBLError do
      ShowMessage(Format('Error Code : %d' ,[E.ISC_ErrorCode]) + NEW_LINE +
        Format('SQL Code : %d',[E.SqlCode]) +
        NEW_LINE + E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmCreateDb.edFileNameButtonClick(Sender: TObject);
begin
  with sdDb do
  begin
    Title := 'Create database file';
    DefaultExt := FILE_DIALOG_EXT;
    Filter :=  FILE_DIALOG_FILTER;
    if Execute then
      edFileName.Text := FileName;
  end;
end;

initialization
  {$I fscreatedb.lrs}
  


end.

