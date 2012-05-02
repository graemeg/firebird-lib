(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fsservice.pas

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


unit fsservice;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  ComCtrls, Menus, StdCtrls, FBLService, ActnList, FBLExcept, SynMemo, EditBtn,
  Buttons, IniFiles;

type

  { TfrmService }

  TfrmService = class(TForm)
    aConnect: TAction;
    aClose: TAction;
    ALoadSetting: TAction;
    aSaveSetting: TAction;
    aGFix: TAction;
    aStartRestore: TAction;
    aStartBackup: TAction;
    aRefresh: TAction;
    aGstat: TAction;
    aServerLog: TAction;
    aDisconnect: TAction;
    ActionList1: TActionList;
    btnStartGfix: TBitBtn;
    btnGstat: TBitBtn;
    btnRestore: TBitBtn;
    btnBackup: TBitBtn;
    cgBackup: TCheckGroup;
    cbPageSize: TCheckBox;
    cgRestore: TCheckGroup;
    cgGstat: TCheckGroup;
    cgGfix: TCheckGroup;
    cmbPageSize: TComboBox;
    coProtocol: TComboBox;
    edHost: TEdit;
    edBackupDB: TEditButton;
    edBackupBK: TEditButton;
    edGstatDB: TEditButton;
    edGfixDB: TEditButton;
    edRestoreBK: TEditButton;
    edRestoreDB: TEditButton;
    edUser: TEdit;
    edPassword: TEdit;
    FBLService1: TFBLService;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ImageList1: TImageList;
    Label1: TLabel;
    Host: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblServerInfo: TLabel;
    MainMenu1: TMainMenu;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mOut: TMemo;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Notebook1: TNotebook;
    odOpen: TOpenDialog;
    Page1: TPage;
    Page2: TPage;
    Page3: TPage;
    Page4: TPage;
    Page5: TPage;
    Page6: TPage;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    pServerInfo: TPanel;
    rgResAction: TRadioGroup;
    rgAccessMode: TRadioGroup;
    sdSave: TSaveDialog;
    StatusBar1: TStatusBar;
    mInfo: TSynMemo;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure aCloseExecute(Sender: TObject);
    procedure aConnectExecute(Sender: TObject);
    procedure aDisconnectExecute(Sender: TObject);
    procedure aGFixExecute(Sender: TObject);
    procedure aGstatExecute(Sender: TObject);
    procedure ALoadSettingExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aSaveSettingExecute(Sender: TObject);
    procedure aServerLogExecute(Sender: TObject);
    procedure aStartBackupExecute(Sender: TObject);
    procedure aStartRestoreExecute(Sender: TObject);
    procedure cbPageSizeChange(Sender: TObject);
    procedure edBackupBKButtonClick(Sender: TObject);
    procedure edBackupDBButtonClick(Sender: TObject);
    procedure edGfixDBButtonClick(Sender: TObject);
    procedure edGstatDBButtonClick(Sender: TObject);
    procedure edRestoreBKButtonClick(Sender: TObject);
    procedure edRestoreDBButtonClick(Sender: TObject);
    procedure FBLService1Connect(Sender: TObject);
    procedure FBLService1Disconnect(Sender: TObject);
    procedure FBLService1WriteOutput(Sender: TObject; TextLine: string;
      IscAction: integer);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    procedure ShowServerInfo;
    procedure LoadSetting(const AFileName: string);
    procedure SaveSetting(const AFileName: string);
  public
    { public declarations }
  end; 
  
  const
    DEFAULT_HEIGHT = 540;
    DEFAULT_WIDTH = 600;
//var
  //frmService: TfrmService;
  
const

  {BACKUP options}
  BK_VERBOSE = 0;
  BK_METADATAONLY = 1;
  BK_CHECKSUM = 2;
  BK_LIMBO = 3;
  BK_NOGARBAGE = 4;
  BK_OLDDESC = 5;
  BK_NOTRASP = 6;
  {RESTORE options}
  RS_VERBOSE = 0;
  RS_DEACT_IDX = 1;
  RS_NOSHADOW = 2;
  RS_NOVAL = 3;
  RS_ONEATTIME = 4;
  RS_USEALLSPACE = 5;
  {GSTAT options}
  GS_DATA = 0;
  GS_LOG = 1;
  GS_HEADER = 2;
  GS_INDEX = 3;
  GS_SYSTEM =4;
  GS_AVERAGE = 5;
  {GFIX options}
  GF_READONLY = 0;
  GF_IGNORECHECK = 1;
  GF_KILLSHADOW = 2;
  GF_PREPARE = 3;
  GF_VDATABASE = 4;
  GF_VRECORD = 5;
  GF_FORCEGARBAGE = 6;

implementation

uses
  fsconfig;

{ Tfrmservice }


//------------------------------------------------------------------------------
procedure TfrmService.LoadSetting(const AFileName: string);
var
 IniFile: TIniFile;
begin
 IniFile := TIniFile.Create(AFileName);
 try
   if inifile.ReadString('version','check','') <> 'fsservice1.0' then
   begin
      ShowMessage('Incompatible file type');
      Exit;
   end;
   //server setting
   coProtocol.ItemIndex := inifile.ReadInteger('connection','protocol',0);
   edHost.Text := inifile.ReadString('connection','host','');
   edUser.Text := inifile.ReadString('connection','user','sysdba');

   //backup setting
   {BK_VERBOSE = 0;
   BK_METADATAONLY = 1;
   BK_CHECKSUM = 2;
   BK_LIMBO = 3;
   BK_NOGARBAGE = 4;
   BK_OLDDESC = 5;
   BK_NOTRASP = 6;}
   edBackupDb.Text := inifile.ReadString('backup','file-db','');
   edBackupBk.Text := inifile.ReadString('backup','file-bk','');
   cgBackup.Checked[BK_VERBOSE] := inifile.ReadBool('backup','verbose',True);
   cgBackup.Checked[BK_METADATAONLY] := inifile.ReadBool('backup','metadata-only',False);
   cgBackup.Checked[BK_CHECKSUM] := inifile.ReadBool('backup','ignore-check',False);
   cgBackup.Checked[BK_LIMBO] := inifile.ReadBool('backup','ignore-limbo',False);
   cgBackup.Checked[BK_NOGARBAGE] := inifile.ReadBool('backup','no-garbage',False);
   cgBackup.Checked[BK_OLDDESC] := inifile.ReadBool('backup','old-description',False);
   cgBackup.Checked[BK_NOTRASP] := inifile.ReadBool('backup','non-trasportable',False);
   //restore setting
   {
   RS_VERBOSE = 0;
   RS_DEACT_IDX = 1;
   RS_NOSHADOW = 2;
   RS_NOVAL = 3;
   RS_ONEATTIME = 4;
   RS_USEALLSPACE = 5;
   }
   edRestoreBk.Text := inifile.ReadString('restore','file-bk','');
   edRestoreDb.Text := inifile.ReadString('restore','file-db','');
   cgRestore.Checked[RS_VERBOSE] := inifile.ReadBool('restore','verbose',True);
   cgRestore.Checked[RS_DEACT_IDX] := inifile.ReadBool('restore','deactivate-index',False);
   cgRestore.Checked[RS_NOSHADOW] := inifile.ReadBool('restore','no-shadow',False);
   cgRestore.Checked[RS_NOVAL] := inifile.ReadBool('restore','no-validity',False);
   cgRestore.Checked[RS_ONEATTIME] := inifile.ReadBool('restore','one-at-time',False);
   cgRestore.Checked[RS_USEALLSPACE] := inifile.ReadBool('restore','use-all-space',False);
   rgResAction.ItemIndex := inifile.ReadInteger('restore','action',0);
   rgAccessMode.ItemIndex := inifile.ReadInteger('restore','access-mode',0);
   cbPageSize.Checked := inifile.ReadBool('restore','page-size-enable',False);
   cmbPageSize.Text := inifile.ReadString('restore','page-size','');
   {
   GS_DATA = 0;
   GS_LOG = 1;
   GS_HEADER = 2;
   GS_INDEX = 3;
   GS_SYSTEM = 4;
   GS_AVERAGE = 5;
   }
   edGstatDB.Text := inifile.ReadString('gstat','file-db','');
   cgGstat.Checked[GS_DATA] := inifile.ReadBool('gstat','data-pages',False);
   cgGstat.Checked[GS_LOG] := inifile.ReadBool('gstat','log-pages',False);
   cgGstat.Checked[GS_HEADER] := inifile.ReadBool('gstat','header-pages',False);
   cgGstat.Checked[GS_INDEX] := inifile.ReadBool('gstat','index-pages',False);
   cgGstat.Checked[GS_SYSTEM] := inifile.ReadBool('gstat','system-relations',False);
   cgGstat.Checked[GS_AVERAGE] := inifile.ReadBool('gstat','record-versions',False);
   {
    GF_READONLY = 0;
    GF_IGNORECHECK = 1;
    GF_KILLSHADOW = 2;
    GF_PREPARE = 3;
    GF_VDATABASE = 4;
    GF_VRECORD = 5;
    GF_FORCEGARBAGE = 6;
   }
   edGfixDB.Text := inifile.ReadString('gfix','file-db','');
   cgGFix.Checked[GF_READONLY] := inifile.ReadBool('gfix','read-only',False);
   cgGFix.Checked[GF_IGNORECHECK] := inifile.ReadBool('gfix','ignore-check',False);
   cgGFix.Checked[GF_KILLSHADOW] := inifile.ReadBool('gfix','kill-shadow',False);
   cgGFix.Checked[GF_PREPARE] := inifile.ReadBool('gfix','mend',False);
   cgGFix.Checked[GF_VDATABASE] := inifile.ReadBool('gfix','validate',False);
   cgGFix.Checked[GF_VRECORD] := inifile.ReadBool('gfix','full',False);
   cgGFix.Checked[GF_FORCEGARBAGE] := inifile.ReadBool('gfix','sweep',False);
 finally
   IniFile.Free;
 end;
end;

//------------------------------------------------------------------------------

procedure TfrmService.SaveSetting(const AFileName: string);
var
 IniFile: TIniFile;
begin
 IniFile := TIniFile.Create(AFileName);
 try
   inifile.WriteString('version','check','fsservice1.0');
   //server setting
   inifile.WriteInteger('connection','protocol',coProtocol.ItemIndex);
   inifile.WriteString('connection','host',edHost.Text);
   inifile.WriteString('connection','user',edUser.Text);
   //backup setting
   {BK_VERBOSE = 0;
   BK_METADATAONLY = 1;
   BK_CHECKSUM = 2;
   BK_LIMBO = 3;
   BK_NOGARBAGE = 4;
   BK_OLDDESC = 5;
   BK_NOTRASP = 6;}
   inifile.WriteString('backup','file-db',edBackupDb.Text);
   inifile.WriteString('backup','file-bk',edBackupBk.Text);
   inifile.WriteBool('backup','verbose',cgBackup.Checked[BK_VERBOSE]);
   inifile.WriteBool('backup','metadata-only',cgBackup.Checked[BK_METADATAONLY]);
   inifile.WriteBool('backup','ignore-check',cgBackup.Checked[BK_CHECKSUM]);
   inifile.WriteBool('backup','ignore-limbo',cgBackup.Checked[BK_LIMBO]);
   inifile.WriteBool('backup','no-garbage',cgBackup.Checked[BK_NOGARBAGE]);
   inifile.WriteBool('backup','old-description',cgBackup.Checked[BK_OLDDESC]);
   inifile.WriteBool('backup','non-trasportable',cgBackup.Checked[BK_NOTRASP]);
   {
   RS_VERBOSE = 0;
   RS_DEACT_IDX = 1;
   RS_NOSHADOW = 2;
   RS_NOVAL = 3;
   RS_ONEATTIME = 4;
   RS_USEALLSPACE = 5;
   }
   inifile.WriteString('restore','file-bk',edRestoreBk.Text);
   inifile.WriteString('restore','file-db',edRestoreDb.Text);
   inifile.WriteBool('restore','verbose',cgRestore.Checked[RS_VERBOSE]);
   inifile.WriteBool('restore','deactivate-index',cgRestore.Checked[RS_DEACT_IDX]);
   inifile.WriteBool('restore','no-shadow',cgRestore.Checked[RS_NOSHADOW]);
   inifile.WriteBool('restore','no-validity',cgRestore.Checked[RS_NOVAL]);
   inifile.WriteBool('restore','one-at-time',cgRestore.Checked[RS_ONEATTIME]);
   inifile.WriteBool('restore','use-all-space',cgRestore.Checked[RS_USEALLSPACE]);
   inifile.WriteInteger('restore','action',rgResAction.ItemIndex);
   inifile.WriteInteger('restore','access-mode',rgAccessMode.ItemIndex);
   inifile.WriteBool('restore','page-size-enable',cbPageSize.Checked);
   inifile.WriteString('restore','page-size',cmbPageSize.Text);
   {
   GS_DATA = 0;
   GS_LOG = 1;
   GS_HEADER = 2;
   GS_INDEX = 3;
   GS_SYSTEM = 4;
   GS_AVERAGE = 5;
   }
   inifile.WriteString('gstat','file-db',edGstatDB.Text);
   inifile.WriteBool('gstat','data-pages',cgGstat.Checked[GS_DATA]);
   inifile.WriteBool('gstat','log-pages',cgGstat.Checked[GS_LOG]);
   inifile.WriteBool('gstat','header-pages',cgGstat.Checked[GS_HEADER]);
   inifile.WriteBool('gstat','index-pages',cgGstat.Checked[GS_INDEX]);
   inifile.WriteBool('gstat','system-relations',cgGstat.Checked[GS_SYSTEM]);
   inifile.WriteBool('gstat','record-versions',cgGstat.Checked[GS_AVERAGE]);
   {
   GF_READONLY = 0;
   GF_IGNORECHECK = 1;
   GF_KILLSHADOW = 2;
   GF_PREPARE = 3;
   GF_VDATABASE = 4;
   GF_VRECORD = 5;
   GF_FORCEGARBAGE = 6;
   }
   inifile.WriteString('gfix','file-db',edGfixDB.Text);
   inifile.WriteBool('gfix','read-only',cgGfix.Checked[GF_READONLY]);
   inifile.WriteBool('gfix','ignore-check',cgGfix.Checked[GF_IGNORECHECK]);
   inifile.WriteBool('gfix','kill-shadow',cgGfix.Checked[GF_KILLSHADOW]);
   inifile.WriteBool('gfix','mend',cgGfix.Checked[GF_PREPARE]);
   inifile.WriteBool('gfix','validate',cgGfix.Checked[GF_VDATABASE]);
   inifile.WriteBool('gfix','full',cgGfix.Checked[GF_VRECORD]);
   inifile.WriteBool('gfix','sweep',cgGfix.Checked[GF_FORCEGARBAGE]);
 finally
   IniFile.Free;
 end;
end;

//------------------------------------------------------------------------------

procedure TfrmService.aConnectExecute(Sender: TObject);
begin
  if edHost.Text <> '' then
    FblService1.Host := edHost.Text;
  case coProtocol.ItemIndex of
    1: FblService1.Protocol := ptTcpIp;
    2: FblService1.Protocol :=  ptNetBeui;
    else  FblService1.Protocol := ptLocal;
  end;
  FblService1.User := edUser.Text;
  FblService1.Password := edPassword.Text;
  try
   FblService1.Connect;
  except
      on E: EFBLError do
        ShowMessage(E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmService.aCloseExecute(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmService.aDisconnectExecute(Sender: TObject);
begin
  if FblService1.Connected then
    FblService1.Disconnect;
end;

//------------------------------------------------------------------------------

procedure TfrmService.aGFixExecute(Sender: TObject);
var
  GfixOption: TGfixRepairs;
begin
   if edGfixDB.Text = '' then
  begin
   ShowMessage('"Database file" cannot be blank');
   edGfixDB.SetFocus;
   Exit;
  end;
  GfixOption := [];
  {TGfixRepair = (gfrCheckDb,gfrIgnore,gfrKill,
   gfrMend,gfrValidate,gfrFull,gfrSweep)}
  {
  GF_READONLY = 0;
  GF_IGNORECHECK = 1;
  GF_KILLSHADOW = 2;
  GF_PREPARE = 3;
  GF_VDATABASE = 4;
  GF_VRECORD = 5;
  GF_FORCEGARBAGE = 6;}
  if cgGfix.Checked[GF_READONLY] then
    GfixOption := GfixOption + [gfrCheckDb];
  if cgGfix.Checked[GF_IGNORECHECK] then
    GfixOption := GfixOption + [gfrIgnore];
  if cgGfix.Checked[GF_KILLSHADOW] then
    GfixOption := GfixOption + [gfrKill];
  if cgGfix.Checked[GF_PREPARE] then
    GfixOption :=  GfixOption + [gfrMend];
  if cgGfix.Checked[GF_VDATABASE] then
    GfixOption := GfixOption + [gfrValidate];
  if cgGfix.Checked[GF_VRECORD] then
    GfixOption := GfixOption + [gfrFull];
  if cgGfix.Checked[GF_FORCEGARBAGE] then
    GfixOption := GfixOption + [gfrSweep];
  try
    FBLService1.GFixRepair(edGfixDB.Text,GfixOption);
  except
     on E:Exception do
       ShowMessage(E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmService.aGstatExecute(Sender: TObject);
var
  StatOption: TStatOptions;
begin
  if edGstatDB.Text = '' then
  begin
    ShowMessage('"Database file" cannot be blank');
    edGstatDB.SetFocus;
    Exit;
  end;
  StatOption := [];
  {
  GS_DATA = 0;
  GS_LOG = 1;
  GS_HEADER = 2;
  GS_INDEX = 3;
  GS_SYSTEM = 4;
  GS_AVERAGE = 5;}
  if cgGstat.Checked[GS_DATA] then
    StatOption := StatOption + [stsDataPages];
  if cgGstat.Checked[GS_LOG] then
    StatOption := StatOption + [stsDbLog];
  if cgGstat.Checked[GS_HEADER] then
    StatOption := StatOption + [stsHdrPages];
  if cgGstat.Checked[GS_INDEX] then
    StatOption := StatOption + [stsIdxPages];
  if cgGstat.Checked[GS_SYSTEM] then
    StatOption := StatOption + [stsSysRelations];
  if cgGstat.Checked[GS_AVERAGE] then
   StatOption := StatOption + [stsRecordVersions];

 try
   mOut.Lines.Clear;
   FBLService1.GetStatusReports(edGstatDB.Text,StatOption);
 except
   on E:EFBLError do
        ShowMessage(E.Message);
 end;
 //PageControl1.ActivePage := TabOut;
end;

//------------------------------------------------------------------------------

procedure TfrmService.ALoadSettingExecute(Sender: TObject);
begin
  odOpen.Filter := 'Firebird service setting (*.fss)|*.fss|Any files (*.*)|*.*';
  if odOpen.Execute then
    LoadSetting(odOpen.FileName);
end;

//------------------------------------------------------------------------------

procedure TfrmService.aRefreshExecute(Sender: TObject);
begin
   ShowServerInfo;
end;

//------------------------------------------------------------------------------

procedure TfrmService.aSaveSettingExecute(Sender: TObject);
begin
  sdSave.Filter := 'Firebird service setting (*.fss)|*.fss|Any files (*.*)|*.*';
  sdSave.DefaultExt := 'fss';
  sdSave.Options := [ofOverwritePrompt,ofPathMustExist,ofEnableSizing];
  if sdSave.Execute then
    SaveSetting(sdSave.FileName);
end;

//------------------------------------------------------------------------------

procedure TfrmService.aServerLogExecute(Sender: TObject);
begin
  mOut.Lines.Clear;
  FBLService1.GetLogFile;
end;

//------------------------------------------------------------------------------

procedure TfrmService.aStartBackupExecute(Sender: TObject);
var
  BkpOptions: TBackupOptions;
begin
  BkpOptions := [];
  if edBackupDB.Text = '' then
  begin
    ShowMessage('"Database File" cannot be blank');
    edBackupDB.SetFocus;
    Exit;
  end;
  
  if edBackupBK.Text = '' then
  begin
   ShowMessage('"Backup File" cannot be blank');
   edBackupBK.SetFocus;
   Exit;
  end;
  
  if cgBackup.Checked[BK_VERBOSE] then
    BkpOptions :=  BkpOptions +  [bkpVerbose];
  if cgBackup.Checked[BK_METADATAONLY] then
    BkpOptions :=  BkpOptions +  [bkpMetadataOnly];
  if cgBackup.Checked[BK_CHECKSUM] then
    BkpOptions :=  BkpOptions + [bkpIgnoreCheckSum];
  if cgBackup.Checked[BK_LIMBO] then
    BkpOptions := BkpOptions + [bkpIgnoreLimbo];
  if cgBackup.Checked[BK_NOGARBAGE] then
     BkpOptions := BkpOptions + [bkpNoGarbageCollect];
  if cgBackup.Checked[BK_OLDDESC] then
    BkpOptions := BkpOptions + [bkpOldDescription];
  if cgBackup.Checked[BK_NOTRASP] then
    BkpOptions := BkpOptions + [bkpNoTrasportable];
  mOut.Lines.Clear;
  FBLService1.Backup(edBackupDB.Text,edBackupBK.Text,BkpOptions);
  //PageControl1.ActivePage := tabOut;
end;

//------------------------------------------------------------------------------

procedure TfrmService.aStartRestoreExecute(Sender: TObject);
var
  ResOptions: TRestoreOptions;
  PagSize: Integer;
begin
  ResOptions := [];
  PagSize := 0;
  if edRestoreBK.Text = '' then
  begin
   ShowMessage('"Backup File" cannot be blank');
   edRestoreBK.SetFocus;
   Exit;
  end;
  if edRestoreDB.Text = '' then
  begin
    ShowMessage('"Database File" cannot be blank');
    edRestoreDB.SetFocus;
    Exit;
  end;

  try
    if cbPageSize.Checked then
      PagSize := StrToInt(cmbPageSize.Text);
  except
     on E:Exception do
     begin
       ShowMessage(E.Message);
       cmbPageSize.SetFocus;
     end;
  end;

  if rgResAction.ItemIndex = 0  then    //replace
    ResOptions := ResOptions + [resReplace]
  else
    ResOptions := ResOptions + [resCreate];

  if rgAccessMode.ItemIndex = 1 then
     ResOptions := ResOptions + [resAccessModeReadOnly]
  else if rgAccessMode.ItemIndex = 2  then
     ResOptions := ResOptions + [resAccessModeReadWrite];

  if cgRestore.Checked[RS_VERBOSE] then
     ResOptions := ResOptions + [resVerbose];
     
  if cgRestore.Checked[RS_DEACT_IDX] then
    ResOptions := ResOptions + [resDeactivateIdx];
    
  if cgRestore.Checked[RS_NOSHADOW] then
     ResOptions := ResOptions + [resNoShadow];
     
  if cgRestore.Checked[RS_NOVAL] then
     ResOptions := ResOptions + [resNoValidity];
     
  if cgRestore.Checked[RS_ONEATTIME] then
     ResOptions := ResOptions + [resOneAtATime];
     
  if cgRestore.Checked[RS_USEALLSPACE] then
     ResOptions := ResOptions + [resUseAllSpace];

  mOut.Lines.Clear;
  try
    FBLService1.Restore(edRestoreBk.Text,edRestoreDb.Text,ResOptions,PagSize);
  except
    on E:Exception do
       ShowMessage(E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmService.cbPageSizeChange(Sender: TObject);
begin
  cmbPageSize.Enabled := cbPageSize.Checked;
end;

//------------------------------------------------------------------------------

procedure TfrmService.edBackupBKButtonClick(Sender: TObject);
begin
  sdSave.Filter := 'Firebird Backup file (*.gbk)|*.gbk';
  if sdSave.Execute then
    edBackupBK.Text := sdSave.FileName;
end;

//------------------------------------------------------------------------------

procedure TfrmService.edBackupDBButtonClick(Sender: TObject);
begin
  odOpen.Filter := 'Firebird DB files (*.fdb;*.gdb)|*.fdb;*.gdb';
  if odOpen.Execute then
  begin
    edBackupDB.Text := odOpen.FileName;
    edBackupBK.Text := ChangeFileExt(odOpen.FileName, '.gbk');
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmService.edGfixDBButtonClick(Sender: TObject);
begin
  odOpen.Filter := 'Firebird DB files (*.fdb;*.gdb)|*.fdb;*.gdb';
  if odOpen.Execute then
    edGFixDB.Text := odOpen.FileName;
end;

//------------------------------------------------------------------------------

procedure TfrmService.edGstatDBButtonClick(Sender: TObject);
begin
   odOpen.Filter := 'Firebird DB files (*.fdb;*.gdb)|*.fdb;*.gdb';
  if odOpen.Execute then
    edGstatDB.Text := odOpen.FileName;
end;

//------------------------------------------------------------------------------

procedure TfrmService.edRestoreBKButtonClick(Sender: TObject);
begin
  sdSave.Filter := 'Firebird Backup file (*.gbk)|*.gbk|Any file(*.*)|*.*';
  if sdSave.Execute then
    edRestoreBK.Text := sdSave.FileName;
end;

//------------------------------------------------------------------------------

procedure TfrmService.edRestoreDBButtonClick(Sender: TObject);
begin
   odOpen.Filter := 'Firebird DB files (*.fdb;*.gdb)|*.fdb;*.gdb';
  if odOpen.Execute then
    edRestoreDB.Text := odOpen.FileName;
end;

//------------------------------------------------------------------------------

procedure TfrmService.FBLService1Connect(Sender: TObject);
begin
  aConnect.Enabled := False;
  aDisconnect.Enabled := True;
  aServerLog.Enabled := True;
  aGstat.Enabled := True;
  aRefresh.Enabled := True;
  aStartBackup.Enabled := True;
  aStartRestore.Enabled := True;
  aGfix.Enabled := True;
  ShowServerInfo;
  StatusBar1.Panels[0].Text := 'Service Manager : Connected';
end;

//------------------------------------------------------------------------------

procedure TfrmService.FBLService1Disconnect(Sender: TObject);
begin
  aConnect.Enabled := True;
  aDisconnect.Enabled := False;
  aServerLog.Enabled := False;
  aGstat.Enabled := False;
  aRefresh.Enabled := False;
  aStartBackup.Enabled := False;
  aStartRestore.Enabled := False;
  aGfix.Enabled := False;
  mInfo.Lines.Clear;
  StatusBar1.Panels[0].Text := 'Service Manager : Not Connected';
  mInfo.Lines.Clear;
end;

//------------------------------------------------------------------------------

procedure TfrmService.FBLService1WriteOutput(Sender: TObject; TextLine: string;
  IscAction: integer);
begin
  Notebook1.PageIndex := 5;
  //PageControl1.ActivePage := tabOut;
  mOut.Lines.Add(Trim(TextLine));
end;

//------------------------------------------------------------------------------

procedure TfrmService.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if FBLService1.Connected then FBLService1.Disconnect;
  fsconfig.SaveFormPos(self);
end;

//------------------------------------------------------------------------------

procedure TfrmService.FormCreate(Sender: TObject);
begin
  {$IFDEF UNIX}
  coProtocol.ItemIndex := 1;
  edHost.Text := 'Localhost';
  {$ENDIF}
  Self.Top := (Screen.Height - DEFAULT_HEIGHT) div 2;
  Self.Left := (Screen.Width - DEFAULT_WIDTH) div 2;
  self.Height := DEFAULT_HEIGHT;
  self.Width := DEFAULT_WIDTH;
  fsconfig.LoadFormPos(Self);
  self.Constraints.MinHeight := DEFAULT_HEIGHT;
  self.Constraints.MinWidth := DEFAULT_WIDTH;
  StatusBar1.Panels[0].Text := 'Service Manager : Not Connected';
end;

//------------------------------------------------------------------------------

procedure TfrmService.ShowServerInfo;
var
  i,n: integer;
  sList: TStringList;
begin
  sList := TStringList.Create;
  try
    mInfo.Lines.Clear;
    mInfo.Lines.Add(Format('%-20s: %s',['Version', FBLService1.ServerVersion]));
    mInfo.Lines.Add(Format('%-20s: %d',['Service Mgr Version', FBLService1.Version]));
    mInfo.Lines.Add(Format('%-20s: %s',['Implementation', FBLService1.ServerImplementation]));
    mInfo.Lines.Add(Format('%-20s: %s',['Server Path', FBLService1.ServerPath]));
    mInfo.Lines.Add(Format('%-20s: %s',['Server Lock Path', FBLService1.ServerLockPath]));
    mInfo.Lines.Add(Format('%-20s: %s',['Server Msg Path', FBLService1.ServerMsgPath]));
    mInfo.Lines.Add(Format('%-20s: %s',['User Db Path', FBLService1.UserDbPath]));
    {$IFNDEF UNIX}
    try
      mInfo.Lines.Add(Format('%-20s: %d',['Num of Attachments', FBLService1.NumOfAttachments]));
      mInfo.Lines.Add(Format('%-20s: %d',['Num of Databases', FBLService1.NumOfDatabases]));

      sList.Assign(FBLService1.DatabaseNames);
      n := sList.Count;
      if n > 0 then
      begin
        mInfo.Lines.Add('List of databases :');
        for i := 0 to n - 1 do
          mInfo.Lines.Add(Format(' %3d : %s',[(i + 1), sList.Strings[i]]));
      end;
    except on E: EFBLError do
        ShowMessage(E.Message + #10 + 'isc_error : ' + IntToStr(E.ISC_ErrorCode));

    end;
    {$ENDIF}
  finally
    sList.Free;
  end;
end;



initialization
  {$I fsservice.lrs}


end.

