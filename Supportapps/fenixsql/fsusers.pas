(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fsusers.pas

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
unit fsusers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, FBLExcept, FBLService;

type

  { TfrmUsers }

  TfrmUsers = class(TForm)
    btnClose: TBitBtn;
    btnAdd: TButton;
    btnModify: TButton;
    btnDelete: TButton;
    Button1: TButton;
    FblService1: TFBLService;
    GroupBox1: TGroupBox;
    lbUsers: TListBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    {private declarations }
    FUser, FPassword: string;
    FLocalConnection: boolean;

  public
    { public declarations }
    constructor Create(Aower: TComponent; AUser, APassword: string);
      reintroduce; overload;
    function TryFetchList: boolean;
  end; 

//var
  //frmUsers: TfrmUsers;

implementation

uses fsconfig, fsusermod;

//------------------------------------------------------------------------------

procedure TfrmUsers.btnAddClick(Sender: TObject);
var
  frmUserMod: TfrmUserMod;
begin
  frmUserMod := TfrmUserMod.Create(self);
  try
     frmUserMod.UserModeType := umInsert;
     if frmUserMod.ShowModal = mrOk then
     begin
       try
         FBLService1.AddUser(frmUserMod.UserName,frmUserMod.PassWord,frmUserMod.FirstName,
           frmUserMod.MiddleName,frmUserMod.LastName);
         ShowMessage('User "' +  frmUserMod.UserName + '" added');
         TryFetchList;
       except on E:EFBLError do
         ShowMessage(E.Message);
       end;
     end;
  finally
    frmUserMod.Free;
  end;
end;


//------------------------------------------------------------------------------

procedure TfrmUsers.btnDeleteClick(Sender: TObject);
var
 UserName: string;
begin
  UserName := lbUsers.Items.Strings[lbUsers.ItemIndex];
  if MessageDlg('Delete user ' +
    UserName +
    #10 + 'Are You sure ?',
    mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FBLService1.DeleteUser(UserName);
      ShowMessage('User "' + UserName + '" deleted');
      TryFetchList;
    except on
      E:EFBLError do
        ShowMessage(E.Message);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUsers.btnModifyClick(Sender: TObject);
var
  frmUserMod: TfrmUserMod;
  UserName,FirstName,MidName,LastName: string;
  UserID, GroupId: Longint;
begin
  frmUserMod := TfrmUserMod.Create(self);
  try
    UserName := LbUsers.Items[lbUsers.ItemIndex];
    try
      FBLService1.ViewUser(UserName,FirstName,MidName,LastName,UserId,GroupId);
      frmUserMod.UserName := UserName;
      frmUserMod.FirstName := FirstName;
      frmUserMod.MiddleName := MidName;
      frmUserMod.LastName := LastName;
      frmUserMod.UserModeType := umModify;
      if frmUserMod.ShowModal = mrOk then
      begin
        FBLService1.ModifyUser(frmUserMod.UserName,frmUserMod.PassWord,
          frmUserMod.FirstName,FrmUserMod.MiddleName,frmUserMod.LastName);
        ShowMessage('User "' + UserName + '" Modified');
      end;
    except on
      E:EFBLError do
         ShowMessage(E.Message);
    end;
  finally
    frmUserMod.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmUsers.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if fblservice1.Connected  then
    fblservice1.Disconnect;
end;

procedure TfrmUsers.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
end;

//------------------------------------------------------------------------------

constructor TfrmUsers.Create(AOwer: TComponent; AUser, Apassword: string);
begin
  inherited Create(AOwer);
  Fuser := AUser;
  FPassword := APassword;
end;

//------------------------------------------------------------------------------

function TfrmUsers.TryFetchList: boolean;
begin
  Result := False;
  if not fblservice1.Connected then
  begin
    fblservice1.Host := '127.0.0.1'; // localhost
    fblservice1.Protocol := FBLService.ptTcpIp;
    fblservice1.User := FUser;
    fblservice1.Password := FPassword;
  end;
  try
    if not fblservice1.Connected then
      fblservice1.Connect;

    lbUsers.items.Assign(fblservice1.UserNames);
    if lbUsers.Items.Count > 0 then
        LbUsers.ItemIndex := 0;
    Result := True;

  except
    on E: EFBLError do
      MessageDlg(Format('Error number: %d ' + #10 + 'Sql Error: %d' + #10 + #10 + E.Message,
        [E.ISC_errorCode, E.SqlCode]),
        mtError, [mbOK], 0);
  end;
end;

//------------------------------------------------------------------------------


initialization
  {$I fsusers.lrs}

end.

