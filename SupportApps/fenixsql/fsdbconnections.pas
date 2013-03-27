(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fsdbconnections.pas

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

{$I fenixsql.inc}

unit fsdbconnections;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, EditBtn, Spin, IniFiles ,FBLDatabase, FBLExcept;

type

  { TfrmDbConnections }

  TfrmDbConnections = class(TForm)
    btnTest: TBitBtn;
    btnConnect: TBitBtn;
    btnCancel: TBitBtn;
    btnSave: TButton;
    btnDelete: TButton;
    cmbAlias: TComboBox;
    cmbProtocol: TComboBox;
    cmbCharacterSet: TComboBox;
    edHost: TEdit;
    edUser: TEdit;
    edPassword: TEdit;
    edRole: TEdit;
    edDatabase: TEditButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lblDialect: TLabel;
    Label9: TLabel;
    odDBFile: TOpenDialog;
    sePort: TSpinEdit;
    seDialect: TSpinEdit;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnTestClick(Sender: TObject);
    procedure cmbAliasChange(Sender: TObject);
    procedure cmbAliasSelect(Sender: TObject);
    procedure cmbProtocolSelect(Sender: TObject);
    procedure edDatabaseButtonClick(Sender: TObject);
    procedure edPasswordChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    FAlias: string;
    procedure LoadAliasName(const AAlias: string);
    procedure SaveAliasName(const AAlias: string);
    function DeleteAlias(const AAlias: string): boolean; //True if alias deleted
    function ValidateInputTest: boolean;
    function ValidateInputConn: boolean;
  public
    { public declarations }
    property Alias: string read FAlias write FAlias;
  end; 
  
  TFsConnectionsParams = record
    Alias, Host, DBName, User, Password ,Role: string;
    CharacterSet: string;
    Protocol, Port, Dialect : Word;
  end;
  
  PFsConnectionsParams = ^TFsConnectionsParams;
  
  const
    PROTOCOL_LOCAL = 0;
    PROTOCOL_TCP_IP = 1;
    PROTOCOL_NETBEUI = 2;
    

  function DbConnection(AParams: PFsConnectionsParams): boolean;

//var
  //frmDbConnections: TfrmDbConnections;

implementation

uses
  fsconfig, fsconst;

//------------------------------------------------------------------------------
  
function DbConnection(AParams: PFsConnectionsParams): boolean;
var
  form: TfrmDbConnections;
begin
  Result := False;
  form := TfrmDbConnections.Create(nil);
  try
     form.Alias := AParams^.Alias;
     if form.ShowModal = mrOk then
     begin
       AParams^.Alias := form.cmbAlias.Text;
       AParams^.Host := form.edHost.Text;
       AParams^.DBName := form.edDatabase.Text;
       AParams^.User := form.edUser.Text;
       APArams^.Password := form.edPassword.Text;
       AParams^.Role := form.edRole.Text;
       AParams^.Protocol := form.cmbProtocol.ItemIndex;
       AParams^.Port := form.sePort.Value;
       AParams^.Dialect := form.seDialect.Value;
       AParams^.CharacterSet := form.cmbCharacterSet.Text;
       Result := True;
     end;
  finally
    form.Free;
  end;
end;

//------------------------------------------------------------------------------

{ TfrmDbConnections }

procedure TfrmDbConnections.LoadAliasName(const AAlias: string);
var
  inifile: TIniFile;
  sProtocol: string;
begin
  inifile := TiniFile.Create(GetAliasIniFile);
  try
    if inifile.SectionExists(AAlias) then
    begin
      sProtocol := inifile.ReadString(AAlias, 'Protocol', 'LOCAL');
      if sProtocol = 'LOCAL' then
        cmbProtocol.ItemIndex := 0
      else if sProtocol = 'TCPIP' then
        cmbProtocol.ItemIndex := 1
      else if sProtocol = 'NETBEUI' then
        cmbProtocol.ItemIndex := 2;
      cmbProtocolSelect(nil);
      edHost.Text := inifile.ReadString(AAlias, 'Host', '');
      edDatabase.Text := inifile.ReadString(AAlias, 'Database', '');
      edRole.Text := inifile.ReadString(AAlias, 'Role', '');
      edUser.Text := inifile.ReadString(AAlias, 'User', '');
      //edPassword.Text := inifile.ReadString(AAlias, 'Password', '');
      cmbCharacterSet.Text := inifile.ReadString(AAlias, 'CharacterSet', 'NONE');
      seDialect.Value := inifile.ReadInteger(AAlias, 'Dialect', 3);
      sePort.Value := inifile.ReadInteger(AAlias, 'Port', 3050);
    end;
  finally
    inifile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.SaveAliasName(const AAlias: string);
var
  inifile: TIniFile;
begin
  inifile := TiniFile.Create(GetAliasIniFile);
  try
    if cmbProtocol.ItemIndex = 0 then
      inifile.WriteString(AAlias,'Protocol','LOCAL')
    else if  cmbProtocol.ItemIndex = 1  then
      inifile.WriteString(AAlias,'Protocol','TCPIP')
    else if  cmbProtocol.ItemIndex = 2  then
      inifile.WriteString(AAlias,'Protocol','NETBEUI');
    inifile.WriteString(AAlias,'Host',edHost.Text);
    inifile.WriteString(AAlias,'Database',edDatabase.Text);
    inifile.WriteString(AAlias,'User',edUser.Text);
    //inifile.WriteString(AAlias,'Password',edPassword.Text);
    Inifile.WriteString(AAlias,'CharacterSet',cmbCharacterSet.Text);
    inifile.WriteInteger(AAlias,'Dialect',seDialect.Value);
    inifile.WriteInteger(AAlias,'Port',sePort.Value);
    inifile.UpdateFile;
  finally
    inifile.Free;
  end;
end;

//------------------------------------------------------------------------------

function TfrmDbConnections.DeleteAlias(const AAlias: string): boolean;
var
  inifile: TIniFile;
begin
  Result := False;
  inifile := TiniFile.Create(GetAliasIniFile);
  try
    if inifile.SectionExists(AAlias) then
    begin
       Inifile.EraseSection(AAlias);
       inifile.UpdateFile;
       fsconfig.DeleteHistory(AAlias);
       Result := True;
    end;
  finally
    IniFile.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
  {$IFDEF fenixsql_test}
  edPassword.Text := 'masterkey';
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.FormShow(Sender: TObject);
var
 item: Integer;
begin
   fsconfig.GetAliasNames(cmbAlias.Items);
   if cmbAlias.Items.Count > 0 then
   begin
     item := cmbAlias.Items.IndexOf(Alias);
     if item > -1 then
     begin
      cmbAlias.ItemIndex := item;
      LoadAliasName(cmbAlias.Text);
     end;
   end;
end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.cmbProtocolSelect(Sender: TObject);
begin
  case cmbProtocol.ItemIndex of
    PROTOCOL_LOCAL:
    begin
      edHost.Enabled := False;
      sePort.Enabled := False;
    end;
    else
    begin
      edHost.Enabled := True;
      sePort.Enabled := True;
    end;
   end;
end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.edDatabaseButtonClick(Sender: TObject);
begin
  with odDBFile do
  begin
    Title := 'Select database file';
    Filter := FILE_DIALOG_FILTER;
    if Execute then
      edDatabase.Text := FileName;
  end;
end;

procedure TfrmDbConnections.edPasswordChange(Sender: TObject);
begin
  btnConnect.Default := edPassword.Text <> '';
end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.btnConnectClick(Sender: TObject);
begin
  if ValidateInputConn then
  begin
    SaveAliasName(cmbAlias.Text);
    ModalResult := mrOk;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.btnDeleteClick(Sender: TObject);
begin
  if cmbAlias.Text = '' then Exit;
  if MessageDlg('Delete Alias ' + cmbAlias.Text + NEW_LINE + 'Are You sure ?',
      mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    if self.DeleteAlias(cmbAlias.Text) then
    begin
      cmbAlias.Text := '';
      fsconfig.GetAliasNames(cmbAlias.Items);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.btnSaveClick(Sender: TObject);
begin
  if cmbAlias.Text <> ''  then
    SaveAliasName( cmbAlias.Text);
end;

//------------------------------------------------------------------------------

function TfrmDbConnections.ValidateInputTest: boolean;
begin
  Result := False;

  if cmbProtocol.ItemIndex > 0 then
    if edHost.Text = '' then
    begin
      ShowMessage('"Host" cannot be blank');
      EdHost.SetFocus;
      Exit;
    end;

  if edDatabase.Text = '' then
  begin
    ShowMessage('"Database" cannot be blank');
    EdDatabase.SetFocus;
    Exit;
  end;

  if edUser.Text = '' then
  begin
    ShowMessage('"User" cannot be blank');
    EdUser.SetFocus;
    Exit;
  end;
  
  if edPassword.Text = '' then
  begin
    ShowMessage('"Password" cannot be blank');
    EdPassword.SetFocus;
    Exit;
  end;
  Result := True;
end;

//------------------------------------------------------------------------------

function TfrmDbConnections.ValidateInputConn: boolean;
begin
  Result :=  False;
  if cmbAlias.Text = '' then
  begin
    ShowMessage('"Aliases" cannot be blank');
    cmbAlias.SetFocus;
    Exit;
  end;
  Result := ValidateInputTest;
end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.btnTestClick(Sender: TObject);
var
  dbTest: TFBLDatabase;
begin
  dbTest := TFBLDatabase.Create(self);
  try
    if not ValidateInputTest then Exit;
    dbTest.Host := edHost.Text;
    dbTest.User := edUser.Text;
    dbTest.Role := edRole.Text;
    
    case cmbProtocol.ItemIndex of
    1:
      dbTest.Protocol := ptTcpIp;
    2:
      dbTest.Protocol := ptNetBeui;
    else
      dbTest.Protocol := ptLocal;
    end;

    dbTest.Password := edPassword.Text;
    dbTest.TcpPort := sePort.Value;
    dbTest.DBFile := edDatabase.Text;
    try
      dbtest.Connect;
      ShowMessage('Connection Ok');
      dbTest.Disconnect;
    except
      on E: EFBLError do
      begin
        ShowMessage(Format('Error Code : %d' ,[E.ISC_ErrorCode]) + NEW_LINE +
          Format('SQL Code : %d',[E.SqlCode]) +
          NEW_LINE + E.Message);
      end;
    end;
  finally
    dbTest.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.cmbAliasChange(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------

procedure TfrmDbConnections.cmbAliasSelect(Sender: TObject);
begin
  LoadAliasName(cmbAlias.Text);
end;

//------------------------------------------------------------------------------

initialization
  {$I fsdbconnections.lrs}

end.

