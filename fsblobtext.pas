(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fsblobtext.pas

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
unit fsblobtext;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, Buttons, ActnList;

type

  { TfrmBlobText }

  TfrmBlobText = class(TForm)
    aSave: TAction;
    aLoad: TAction;
    ActionList1: TActionList;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    cbNull: TCheckBox;
    edValue: TMemo;
    ImageList1: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    lParamNumber: TLabel;
    lParamType: TLabel;
    OpenDialog1: TOpenDialog;
    pBottom: TPanel;
    pParam: TPanel;
    SaveDialog1: TSaveDialog;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    procedure aLoadExecute(Sender: TObject);
    procedure aSaveExecute(Sender: TObject);
    procedure edValueChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

//var
  //frmBlobText: TfrmBlobText;
  
procedure ViewBlobText(const AValue: string);

function InputParamMemo(const AParamNum, AParamType: string;
  var AisNullable: Boolean;
  var AValue: string): Boolean;

implementation


procedure ViewBlobText(const AValue: string);
var
  dForm: TfrmBlobText;
begin
  dForm := TfrmBlobText.Create(Application);
  try
    dForm.pParam.Visible := False;
    dForm.cbNull.Visible := False;
    dForm.aLoad.Enabled := False;
    dForm.edValue.Lines.Text := AValue;
    dForm.ShowModal;
  finally
    dForm.Free;
  end;
end;


function InputParamMemo(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: string): Boolean;
var
  dForm: TfrmBlobText;
begin
  dForm := TfrmBlobText.Create(Application);
  Result := False;
  try
    dForm.cbNull.Visible := AisNullable;
    dForm.cbNull.Checked := AisNullable;
    dForm.edValue.Text := AValue;
    if not AisNullable then
      dForm.lParamType.Caption := AParamType + ' NOT NULL'
    else
      dForm.lParamType.Caption := AParamType;
    dForm.lParamNumber.Caption := AParamNum;

    dForm.edValue.Lines.Text := AValue;
    if dForm.ShowModal = mrOk then
    begin
      AValue := dForm.edValue.Lines.Text;
      AisNullable := dForm.cbNull.Checked;
      Result := True;
    end;
  finally
    dForm.Free;
  end;
end;


{ TfrmBlobText }

procedure TfrmBlobText.aLoadExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
    edValue.Lines.LoadFromFile(OpenDialog1.FileName);
end;

procedure TfrmBlobText.aSaveExecute(Sender: TObject);
begin
  if SaveDialog1.Execute then
    edValue.Lines.SaveToFile(SaveDialog1.FileName);
end;

procedure TfrmBlobText.edValueChange(Sender: TObject);
begin
  if cbNull.Checked then
     if edValue.Lines.Text <> '' then cbNull.Checked := False;
end;

initialization
  {$I fsblobtext.lrs}

end.

