(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fslogin.pas

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

unit fslogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls;

type

  { TfrmLogin }

  TfrmLogin = class(TForm)
    Bevel1: TBevel;
    BitBtn1: TBitBtn;
    edUser: TLabeledEdit;
    edPassword: TLabeledEdit;
    Label1: TLabel;
    lAlias: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { private declarations }
    function GetUser: string;
    function GetPassword: string;
    procedure SetAlias(const Value: string);
    procedure SetPassword(const Value: string);
    procedure SetUser(const Value: string);
  public
    { public declarations }
    property Alias: string write SetAlias;
    property User: string read GetUser write SetUser;
    property Password: string read GetPassword write SetPassword;
  end; 

//var
  //frmLogin: TfrmLogin;
  
function FbDbLogin(AAlias: string; var AUser, APassword: string): boolean;

implementation

function FbDbLogin(AAlias: string; var AUser, APassword: string): boolean;
var
  FrmLogin: TFrmLogin;
begin
  Result := False;
  FrmLogin := TFrmLogin.Create(nil);
  try
    FrmLogin.Alias := AALias;
    FrmLogin.User := AUser;
    FrmLogin.Password := APassword;
    //FrmLogin.Role := ARole;
    if FrmLogin.ShowModal = mrOk then
    begin
      AUser := FrmLogin.User;
      APassword := FrmLogin.Password;
      //ARole := FrmLogin.Role;
      Result := True;
    end;
  finally
    FrmLogin.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.FormShow(Sender: TObject);
begin
  if edUser.Text <> '' then edPassword.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
end;

//------------------------------------------------------------------------------

function TFrmLogin.GetUser: string;
begin
  Result := edUser.Text;
end;

//------------------------------------------------------------------------------

function TFrmLogin.GetPassword: string;
begin
  Result := edPassword.Text;
end;

//------------------------------------------------------------------------------
{
function TFrmLogin.GetRole: string;
begin
  Result := edRole.Text;
end;
}
//------------------------------------------------------------------------------

procedure TFrmLogin.SetAlias(const Value: string);
begin
  LAlias.Caption := Value;
end;

//------------------------------------------------------------------------------

procedure TFrmLogin.SetUser(const Value: string);
begin
  edUser.Text := Value;
end;

//------------------------------------------------------------------------------
{
procedure TfrmLogin.SetRole(const Value: string);
begin
  edRole.Text := Value;
end;
}
//------------------------------------------------------------------------------

procedure TFrmLogin.SetPassword(const Value: string);
begin
  edPassword.Text := Value;
end;

//------------------------------------------------------------------------------

initialization
  {$I fslogin.lrs}

end.

