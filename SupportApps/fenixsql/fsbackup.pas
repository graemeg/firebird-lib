(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fsbackup.pas

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

unit fsbackup;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, EditBtn, FBLService, FBLDatabase, FBLExcept;

type

  { TfrmFbBackup }

  TfrmFbBackup = class(TForm)
    btnStart: TBitBtn;
    BitBtn2: TBitBtn;
    cgOptions: TCheckGroup;
    edDbFile: TEdit;
    edBKPFile: TEditButton;
    FBLService1: TFBLService;
    mOut: TMemo;
    Notebook1: TNotebook;
    Page1: TPage;
    Page2: TPage;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    sdBkpFile: TSaveDialog;
    procedure btnStartClick(Sender: TObject);
    procedure edBKPFileButtonClick(Sender: TObject);
    procedure FBLService1WriteOutput(Sender: TObject; TextLine: string;
      IscAction: integer);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    function CheckInputData: Boolean;
  public
    { public declarations }
  end; 

procedure DatabaseBackup(aDb: TFBLDatabase);

//var
  //frmFbBackup: TfrmFbBackup;

implementation

{ TfrmFbBackup }

procedure TfrmFbBackup.FBLService1WriteOutput(Sender: TObject;
  TextLine: string; IscAction: integer);
begin
  mOut.Lines.Add(TextLine);
end;

//------------------------------------------------------------------------------

procedure TfrmFbBackup.FormCreate(Sender: TObject);
begin
  Constraints.MinHeight := Height;
  Constraints.MinWidth := Width;
end;

//------------------------------------------------------------------------------

procedure TfrmFbBackup.btnStartClick(Sender: TObject);
var
  BkpOptions: TBackupOptions;
begin
   BkpOptions := [];
  if not CheckInputData then Exit;
  if cgOptions.Checked[0] then
    BkpOptions :=  BkpOptions +  [bkpVerbose];
  if cgOptions.Checked[1] then
    BkpOptions :=  BkpOptions +  [bkpMetadataOnly];
  if cgOptions.Checked[2] then
    BkpOptions :=  BkpOptions + [bkpIgnoreCheckSum];
  if cgOptions.Checked[3] then
    BkpOptions := BkpOptions + [bkpIgnoreLimbo];
  if cgOptions.Checked[4] then
    BkpOptions := BkpOptions + [bkpNoGarbageCollect];
  if cgOptions.Checked[5] then
    BkpOptions := BkpOptions + [bkpOldDescription];
  if cgOptions.Checked[6] then
    BkpOptions := BkpOptions + [bkpNoTrasportable];

  try
    if not FBLService1.Connected then
      FBLService1.Connect;
    mOut.Lines.Clear;
    Notebook1.PageIndex := 1;
    FBLService1.Backup(edDBFile.Text,edBKPFile.Text,BkpOptions);
    if FBLService1.Connected then
      FBLService1.Disconnect;
  except
    on E: EFBLError do
      begin
         //PageControl1.ActivePage := tsOut;
         Notebook1.PageIndex := 1;
         mOut.Lines.Clear;
         mOut.Lines.Add('ERROR');
         mOut.Lines.Add('-------------');
         mOut.Lines.Add('isc_error: ' + IntToStr(E.ISC_ErrorCode));
         mOut.Lines.Text := mOut.Lines.Text + E.Message;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmFbBackup.edBKPFileButtonClick(Sender: TObject);
begin
  sdBkpFile.Filter := 'Firebird Backup file (*.gbk)|*.gbk';
  if sdBkpFile.Execute then
    edBkpFile.Text := sdBkpfile.FileName;
end;

//------------------------------------------------------------------------------

procedure DatabaseBackup(aDB: TFBLDatabase);
var
  frmBk: TFrmFbBackup;
begin
  frmBk := TFrmFbBackup.Create(nil);
  try
    frmBk.FBLService1.User := aDB.User;
    frmBk.FBLService1.Password := aDb.Password;
    frmBk.FBLService1.Host := aDb.Host;
    if aDB.Protocol = ptLocal then
      frmBk.FBLService1.Protocol := FBLService.ptLocal
    else if aDB.Protocol = ptTcpIp then
      frmBk.FBLService1.Protocol := FBLService.ptTcpIp
    else if aDb.Protocol = ptNetBeui then
      frmBk.FBLService1.Protocol := FBLService.ptNetBeui;
    frmBk.edDBFile.Text := aDb.DBFile;
    frmBk.ShowModal;
  finally
    frmBk.Free;
  end;
end;

//------------------------------------------------------------------------------

function TFrmFbBackup.CheckInputData: Boolean;
begin
  Result := False;
  if edDbFile.Text = '' then
  begin
    ShowMessage('"Database File" cannot be blank');
    edDbFile.SetFocus;
    Exit;
  end;
  if edBkpFile.Text = '' then
  begin
    ShowMessage('"Backup File" cannot be blank');
    edbkpFile.SetFocus;
    Exit;
  end;
  Result := True;
end;

initialization
  {$I fsbackup.lrs}

end.

