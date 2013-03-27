(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fstablefilter.pas


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
unit fstablefilter;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, Grids, ComCtrls;

type

  { TFrmTableFilter }

  TFrmTableFilter = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    lvFields: TListView;
    mFilter: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel7: TPanel;
    Splitter1: TSplitter;
    procedure btnOkClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvFieldsDblClick(Sender: TObject);
    procedure mFilterChange(Sender: TObject);
  private
    { private declarations }
    FTableName: string;
    FFilter: string;
    FIsOrder: Boolean;
    function GetFilter: string;
    procedure SetFilter(const Value: string);
    procedure InsertStringInMemo(const AValue: string);
    procedure LoadFieldList;
  public
    { public declarations }
    constructor Create(Aower: TComponent; ATableName: string);
      reintroduce; overload;
    property Filter: string read GetFilter write SetFilter;
    property IsOrder: Boolean read FIsOrder;
  end; 

//var
  //FrmTableFilter: TFrmTableFilter;

implementation

uses
 fsdm, FBLExcept;

//------------------------------------------------------------------------------


constructor  TfrmTableFilter.Create(Aower: TComponent; ATableName: string);
var
 i: Integer;
begin
  inherited Create(AOwer);
  FTableName := ATableName;
  FIsOrder := False ;
  LoadFieldList;
end;

//------------------------------------------------------------------------------

procedure TFrmTableFilter.LoadFieldList;
var
  i: Integer;
  item: TListItem;
begin
  if not dmib.trTableView.InTransaction then
    dmib.trTableView.StartTransaction;
  dmib.qryTableFilter.SQL.Text := 'select * from ' + FTableName;
  dmib.qryTableFilter.Prepare;
  for i := 0 to dmib.qryTableFilter.FieldCount - 1 do
  begin
    item := lvFields.Items.Add;
    item.Caption := dmib.qryTableFilter.FieldName(i);
    item.SubItems.Add(dmib.qryTableFilter.FieldSQLTypeDesc(i));
  end;
  dmib.qryTableFilter.UnPrepare;
end;



//------------------------------------------------------------------------------

procedure TFrmTableFilter.btnOkClick(Sender: TObject);
begin
  if not dmib.trTableView.InTransaction then
    dmib.trTableView.StartTransaction;
  dmib.qryTableFilter.SQL.Text := 'select * from ' + FTableName + ' where ' + mFilter.Lines.Text;
  try
    dmib.qryTableFilter.Prepare;
    FisOrder := (Pos('ORDER',dmib.qryTableFilter.Plan) > 0);
    dmib.qryTableFilter.UnPrepare;
    FFilter := mFilter.Lines.Text;
    ModalResult := mrOK;
  except
     on E:EFBLError do
       ShowMessage('Error in Filter' + #10 + Format('ISC_ERROR:%d',[E.ISC_ErrorCode]) + #10 +
         E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TFrmTableFilter.FormShow(Sender: TObject);
begin
  mFilter.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TFrmTableFilter.lvFieldsDblClick(Sender: TObject);
begin
 if lvFields.Selected  <> nil then
   //ShowMessage(lvFields.Selected.Caption);
 begin
   InsertStringInMemo(lvFields.Selected.Caption);
   mFilter.SetFocus;
 end;
end;

//------------------------------------------------------------------------------

procedure TFrmTableFilter.mFilterChange(Sender: TObject);
begin
  btnOk.Enabled := (MFilter.Lines.Count > 0);
end;

//------------------------------------------------------------------------------

function TFrmTableFilter.GetFilter: string;
begin
  Result := mFilter.Lines.Text;
end;


//------------------------------------------------------------------------------

procedure TfrmTableFilter.SetFilter(const Value: string);
begin
  mFilter.Lines.Text := Value;
end;

//------------------------------------------------------------------------------

procedure TfrmTableFilter.InsertStringInMemo(const AValue: string);
var
  PosMemo: Integer;
  TextMemo: string;
begin
  PosMemo := mFilter.SelStart;
  TextMemo :=  mFilter.Lines.Text;
  Insert(AValue,TextMemo,PosMemo + 1);
  mFilter.Lines.Text := TextMemo;
  mFilter.SelStart :=  Length(TextMemo);
end;

//------------------------------------------------------------------------------

initialization
  {$I fstablefilter.lrs}

end.

