(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://web.tiscali.it/fblib

   file:fsblobinput.pas


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

unit fsblobinput;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  EditBtn, Buttons, StdCtrls;

type

  { TfrmBlobInput }

  TfrmBlobInput = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnCancel: TBitBtn;
    btnOk: TBitBtn;
    cbNull: TCheckBox;
    edValue: TFileNameEdit;
    Label1: TLabel;
    lblParamNumber: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lblParamType: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnOkClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

//var
//  frmBlobInput: TfrmBlobInput;

function InputParamBlob(const AParamNum, AParamType: string; var AisNullable: Boolean;
  var AFileName: string): Boolean;

implementation



function InputParamBlob(const AParamNum, AParamType: string; var AisNullable: Boolean;
  var AFileName: string): Boolean;
var
  mForm: TfrmBlobInput;
begin
  mForm := TfrmBlobInput.Create(Application);
  try
    Result := False;
    mForm.cbNull.Visible := AisNullable;
    mForm.cbNull.Checked := AisNullable;
    if not AisNullable then
    begin
      mForm.edValue.Text := '';
      mForm.lblParamType.Caption := AParamType + ' NOT NULL';
    end
    else
      mForm.lblParamType.Caption := AParamType;

    mForm.lblParamNumber.Caption := AParamNum;
    if mForm.ShowModal = mrOk then
    begin
      AFileName := mForm.edValue.Text;
      AisNullable := mForm.cbNull.Checked;
      Result := True;
    end;
  finally
    mForm.Free;
  end;
end;


{ TfrmBlobInput }

procedure TfrmBlobInput.btnOkClick(Sender: TObject);
begin
   if cbNull.Checked then
      ModalResult := mrOk
   else
      if FileExists(edValue.Text) then
         ModalResult := mrOk
      else
         ShowMessage('Insert a valid filename');
end;

initialization
  {$I fsblobinput.lrs}

end.

