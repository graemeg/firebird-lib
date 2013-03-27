(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fsusermod.pas

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
unit fsusermod;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons;

type
  TUserModType = (umInsert, umModify);

  { TFrmUserMod }
  TFrmUserMod = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    edUserName: TLabeledEdit;
    edPassword: TLabeledEdit;
    edConfirmPassword: TLabeledEdit;
    edFirstName: TLabeledEdit;
    edMiddleName: TLabeledEdit;
    edLastName: TLabeledEdit;
    procedure btnOkClick(Sender: TObject);
    procedure edConfirmPasswordChange(Sender: TObject);
    procedure edFirstNameChange(Sender: TObject);
    procedure edLastNameChange(Sender: TObject);
    procedure edMiddleNameChange(Sender: TObject);
    procedure edPasswordChange(Sender: TObject);
    procedure edUserNameChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    FUserModType: TUserModType;
    function GetUserName: string;
    function GetPassword: string;
    function GetFirstName: string;
    function GetMiddleName: string;
    function GetLastName: string;
    procedure SetUserName(const Value: string);
    procedure SetFirstName(const Value: string);
    procedure SetMiddleName(const Value: string);
    procedure SetLastName(const Value: string);
  public
    { public declarations }
    property UserName: string read GetUserName write SetUserName;
    property PassWord: string read GetPassword;
    property FirstName: string read GetFirstName write SetFirstName;
    property MiddleName: string read GetMiddleName write SetMiddleName;
    property LastName: string read GetLastName write SetLastName;
    property UserModeType: TUserModType read FUserModType write FUserModType;
  end; 

//var
  //FrmUserMod: TFrmUserMod;

implementation

procedure TFrmUserMod.FormShow(Sender: TObject);
begin
  case FuserModType of
    umInsert:
      Caption := 'Add User';
    umModify:
      begin
        Caption := 'Modify User';
        edUserName.ReadOnly := True;
        edPassword.SetFocus;
      end;
  end;
end;

//------------------------------------------------------------------------------

procedure TFrmUserMod.edUserNameChange(Sender: TObject);
begin
  if FUserModType = umInsert then
    btnOk.Enabled := (edUserName.Text <> '') and (edPassword.Text <> '') and
      (edConfirmPassword.Text <> '');
end;

procedure TFrmUserMod.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
end;

//------------------------------------------------------------------------------

procedure TFrmUserMod.edPasswordChange(Sender: TObject);
begin
  if FUserModType = umInsert then
    btnOk.Enabled := (edUserName.Text <> '') and (edPassword.Text <> '') and
      (edConfirmPassword.Text <> '')
  else
    btnOk.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TFrmUserMod.edConfirmPasswordChange(Sender: TObject);
begin
   if FUserModType = umInsert then
    btnOk.Enabled := (edUserName.Text <> '') and (edPassword.Text <> '') and
      (edConfirmPassword.Text <> '');
end;

//------------------------------------------------------------------------------

procedure TFrmUserMod.btnOkClick(Sender: TObject);
begin
   if edPassword.Text <> edConfirmPassword.Text then
    ShowMessage('Password insert error')
  else
    Modalresult := mrOk;
end;

//------------------------------------------------------------------------------

procedure TFrmUserMod.edFirstNameChange(Sender: TObject);
begin
  if FuserModType = umModify then
    btnOk.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TFrmUserMod.edLastNameChange(Sender: TObject);
begin
  if FuserModType = umModify then
    btnOk.Enabled := True;
end;

procedure TFrmUserMod.edMiddleNameChange(Sender: TObject);
begin
  if FuserModType = umModify then
    btnOk.Enabled := True;
end;

//------------------------------------------------------------------------------

function TfrmUserMod.GetUserName: string;
begin
  Result := edUserName.Text;
end;

function TfrmUserMod.GetPassword: string;
begin
  if Length(edPassword.Text) > 8 then
    Result := LeftStr(edPassword.Text, 8)
  else
    Result := edPassword.Text;
end;

function TfrmUserMod.GetFirstName: string;
begin
  Result := edFirstName.Text;
end;

function TfrmUserMod.GetMiddleName: string;
begin
  Result := edMiddleName.Text;
end;

function TfrmUserMod.GetLastName: string;
begin
  Result := edLastName.Text;
end;

procedure TfrmUserMod.SetUserName(const Value: string);
begin
  edUserName.Text := Value;
end;

procedure TfrmUserMod.SetFirstName(const Value: string);
begin
  edFirstName.Text := Value;
end;

procedure TfrmUserMod.SetMiddleName(const Value: string);
begin
  edMiddleName.Text := Value;
end;

procedure TfrmUserMod.SetLastName(const Value: string);
begin
  edLastName.Text := Value;
end;



initialization
  {$I fsusermod.lrs}

end.

