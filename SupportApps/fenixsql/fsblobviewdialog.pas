(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://web.tiscali.it/fblib

   File: fsblobviewdialog.pas

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
unit fsblobviewdialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { TfrmBlobViewDialog }

  TfrmBlobViewDialog = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Label1: TLabel;
    lFieldName: TLabel;
    Label3: TLabel;
    lSubType: TLabel;
    Panel1: TPanel;
    Panel5: TPanel;
    rgType: TRadioGroup;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    function GetBlobType: Integer;
    function GetFieldName: string;
    procedure SetBlobType(Value: Integer);
    procedure SetFieldName(Value: string);
  public
    { public declarations }
    property BlobType: Integer read GetBlobType write SetBlobType;
    property FieldName: string read GetFieldName write SetFieldName;
  end; 

{var
  frmBlobViewDialog: TfrmBlobViewDialog;}

implementation

procedure TfrmBlobViewDialog.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
end;

//------------------------------------------------------------------------------

function TfrmBlobViewDialog.GetBlobType: Integer;
begin
  Result := rgType.ItemIndex;
end;

//------------------------------------------------------------------------------

function TfrmBlobViewDialog.GetFieldName: string;
begin
  Result :=  lFieldName.Caption;
end;

//------------------------------------------------------------------------------

procedure TfrmBlobViewDialog.SetBlobType(Value: Integer);
begin
 if Value = 1 then
 begin
   rgType.ItemIndex := 1;
   lSubType.Caption := '1 - TEXT'
 end
 else
 begin
   rgType.ItemIndex := 0;
   lSubType.Caption  := IntToStr(Value);
 end;
end;

//------------------------------------------------------------------------------


procedure TfrmBlobViewDialog.SetFieldName(Value: string);
begin
  lFieldName.Caption := Value;
end;

//------------------------------------------------------------------------------


initialization
  {$I fsblobviewdialog.lrs}

end.

