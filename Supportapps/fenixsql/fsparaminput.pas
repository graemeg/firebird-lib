(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://web.tiscali.it/fblib

   file:FsParamInput.pas


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

unit fsparaminput;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls;

type
  TInputValueType = (ivInteger, ivDouble, ivString, ivTimeStamp, ivTime, ivDate);
  { TfrmParam }

  TfrmParam = class(TForm)
    Bevel1: TBevel;
    Bevel2: TBevel;
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    btnNow: TButton;
    cbNull: TCheckBox;
    edValue: TLabeledEdit;
    Label1: TLabel;
    lblParamNumber: TLabel;
    Label3: TLabel;
    lblParamType: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    procedure btnNowClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure cbNullClick(Sender: TObject);
    procedure edValueChange(Sender: TObject);
    procedure edValueKeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
  private
    InputValueType: TInputValueType;
    function CheckInput: boolean;
    { private declarations }
  public
    { public declarations }
    function GetNullValue: boolean;
  end; 

//var
  //frmParam: TfrmParam;

{exported functions}

function InputParamInt(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: Integer): Boolean;
function InputParamDouble(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: Double): Boolean;
function InputParamFloat(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: single): Boolean;
function InputParamString(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: string): Boolean;
function InputParamDateTime(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: TDateTime): Boolean;
  

implementation

{exported functions implementation}

function InputParamInt(const AParamNum, AParamType: string; var AisNullable: Boolean;
  var AValue: Integer): Boolean;
var
  mForm: TfrmParam;
begin
  mForm := TfrmParam.Create(Application);
  Result := False;
  try

    mForm.cbNull.Visible := AisNullable;
    mForm.cbNull.Checked := AisNullable;
    if not AisNullable then
    begin
      mForm.edValue.Text := '0';
      mForm.lblParamType.Caption := AParamType + ' NOT NULL';
    end
    else
      mForm.lblParamType.Caption := AParamType;

    mForm.lblParamNumber.Caption := AParamNum;
    mForm.inputValueType := ivInteger;
    mForm.btnNow.Visible := False;
    if mForm.ShowModal = mrOk then
    begin
      AisNullable := mForm.GetNullValue();
      if AisNullable then
         AValue := 0
      else
         AValue := StrToInt(mForm.edValue.Text);
      Result := True;
    end;
  finally
    mForm.Free;
  end;
end;

//------------------------------------------------------------------------------

function InputParamDouble(const AParamNum, AParamType: string; var AisNullable: Boolean;
  var AValue: Double): Boolean;
var
  mForm: TfrmParam;
begin
  mForm := TfrmParam.Create(Application);
  try
    Result := False;
    mForm.cbNull.Visible := AisNullable;
    mForm.cbNull.Checked := AisNullable;
    if not AisNullable then
    begin
      mForm.edValue.Text := '0';
      mForm.lblParamType.Caption := AParamType + ' NOT NULL';
    end
    else
      mForm.lblParamType.Caption := AParamType;

    mForm.lblParamNumber.Caption := AParamNum;
    mForm.lblParamType.Caption := AParamType;
    mForm.inputValueType := ivDouble;
    mForm.btnNow.Visible := False;
    if mForm.ShowModal = mrOk then
    begin
      AisNullable := mForm.GetNullValue();
      if AisNullable then
        AValue := 0
      else
        AValue := StrToFloat(mForm.edValue.Text);
      Result := True;
    end;
  finally
    mForm.Free;
  end;
end;

//------------------------------------------------------------------------------

function InputParamFloat(const AParamNum, AParamType: string; var AisNullable: boolean;
  var AValue: Single): Boolean;
var
  mForm: TfrmParam;
begin
  mForm := TfrmParam.Create(Application);
  try
    Result := False;
    mForm.cbNull.Visible := AisNullable;
    mForm.cbNull.Checked := AisNullable;
    if not AisNullable then
    begin
      mForm.edValue.Text := '0';
      mForm.lblParamType.Caption := AParamType + ' NOT NULL';
    end
    else
      mForm.lblParamType.Caption := AParamType;

    mForm.lblParamNumber.Caption := AParamNum;
    mForm.lblParamType.Caption := AParamType;
    mForm.inputValueType := ivDouble;
    mForm.btnNow.Visible := False;
    if mForm.ShowModal = mrOk then
    begin
      AisNullable := mForm.GetNullValue();
      if  AisNullable then
        AValue := 0
      else
        AValue := StrToFloat(mForm.edValue.Text);
      Result := True;
    end;
  finally
    mForm.Free;
  end;
end;

//------------------------------------------------------------------------------

function InputParamString(const AParamNum, AParamType: string; var AisNullable: Boolean;
  var AValue: string): Boolean;
var
  mForm: TfrmParam;
begin
  mForm := TfrmParam.Create(Application);
  try
    Result := False;
    mForm.cbNull.Visible := AisNullable;
    mForm.cbNull.Checked := AisNullable;
    mForm.edValue.Text := AValue;
    if not AisNullable then
      mForm.lblParamType.Caption := AParamType + ' NOT NULL'
    else
      mForm.lblParamType.Caption := AParamType;

    mForm.lblParamNumber.Caption := AParamNum;
    mForm.lblParamType.Caption := AParamType;
    mForm.inputValueType := ivString;
    mForm.btnNow.Visible := False;
    if mForm.ShowModal = mrOk then
    begin
      AisNullable := mForm.GetNullValue();
      if AisNullable then
        AValue := ''
      else
        AValue := mForm.edValue.Text;
      Result := True;
    end;
  finally
    mForm.Free;
  end;
end;

//------------------------------------------------------------------------------

function InputParamDateTime(const AParamNum, AParamType: string; var AisNullable: Boolean;
  var AValue: TDateTime): Boolean;
var
  mForm: TfrmParam;
begin
  mForm := TfrmParam.Create(Application);
  try
    Result := False;
    mForm.cbNull.Visible := AisNullable;
    mForm.cbNull.Checked := AisNullable;

    if not AisNullable then
      mForm.lblParamType.Caption := AParamType + ' NOT NULL'
    else
      mForm.lblParamType.Caption := AParamType;
    mForm.lblParamNumber.Caption := AParamNum;
    mForm.lblParamType.Caption := AParamType;

    if AParamType = 'TIMESTAMP' then
    begin
      mForm.edValue.Text := DateTimeToStr(AValue);
      mForm.inputValueType := ivTimeStamp;
      mForm.btnNow.Visible := True;
    end
    else if AParamType = 'DATE' then
    begin
      mForm.edValue.Text := DateToStr(AValue);
      mForm.inputValueType := ivDate;
      mForm.btnNow.Visible := True;
    end
    else if AParamType = 'TIME' then
    begin
      mForm.edValue.Text := TimeToStr(AValue);
      mForm.inputValueType := ivTime;
      mForm.btnNow.Visible := True;
    end;

    if mForm.ShowModal = mrOk then
    begin
      AisNullable := mForm.GetNullValue();
      if AisNullable then
        AValue := Now()
      else
        AValue := StrToDateTime(mForm.edValue.Text);
      Result := True;
    end;
  finally
    mForm.Free;
  end;
end;

{ TfrmParam }

//------------------------------------------------------------------------------

function TfrmParam.CheckInput: boolean;
begin
  Result := False;
  case inputValueType of
    ivInteger:
      try
        StrToInt(edValue.Text);
        Result := True;
      except
        on E: Exception do
          MessageDlg('Integer convert error',
            mtError, [mbOK], 0);
      end;
    ivDouble:
      try
        StrToFloat(edValue.Text);
        Result := True;
      except
        on E: Exception do
          MessageDlg('Float convert error',
            mtError, [mbOK], 0);
      end;
    ivTimeStamp:
      try
        StrToDateTime(edValue.Text);
        Result := True;
      except
        on E: Exception do
          MessageDlg('DateTime convert error',
            mtError, [mbOK], 0);
      end;
    ivTime:
      try
        StrToTime(edValue.Text);
        Result := True;
      except
        on E: Exception do
          MessageDlg('Time convert error',
            mtError, [mbOK], 0);
      end;
    ivDate:
      try
        StrToDate(edValue.Text);
        Result := True;
      except
        on E: Exception do
          MessageDlg('Date convert error',
            mtError, [mbOK], 0);
      end;
    else
      Result := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmParam.edValueChange(Sender: TObject);
begin
  if cbNull.Visible then
    cbnull.Checked := (edValue.Text = '');
end;

//------------------------------------------------------------------------------

procedure TfrmParam.cbNullClick(Sender: TObject);
begin
  if cbNull.Checked then edValue.Text := '';
end;

//------------------------------------------------------------------------------

procedure TfrmParam.btnNowClick(Sender: TObject);
begin
  case inputValueType of
    ivTimeStamp:
      edValue.Text := DateTimeToStr(now);
    ivTime:
      edValue.Text := TimeToStr(now);
    ivDate:
      edValue.Text := DateTostr(now);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmParam.btnOkClick(Sender: TObject);
begin
  if not cbNull.Checked then
  begin
    if CheckInput then ModalResult := mrOk;
  end
  else
  begin
    ModalResult := mrOk;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmParam.edValueKeyPress(Sender: TObject; var Key: char);
begin
  case inputValueType of
    ivInteger:
      if not (key in ['0'..'9', #8]) then key := #0;
    ivDouble:
      if not (key in ['0'..'9', #8, DecimalSeparator]) then key := #0;
    ivTimeStamp:
      if not (key in ['0'..'9', #8, DateSeparator, TimeSeparator]) then key := #0;
    ivDate:
      if not (key in ['0'..'9', #8, DateSeparator]) then key := #0;
    ivTime:
      if not (key in ['0'..'9', #8, TimeSeparator]) then key := #0;
  end;
end;

//------------------------------------------------------------------------------

function TfrmParam.GetNullValue: boolean;
begin
  result := cbNull.Checked;
end;


//------------------------------------------------------------------------------

procedure TfrmParam.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
end;

initialization
  {$I fsparaminput.lrs}

end.

