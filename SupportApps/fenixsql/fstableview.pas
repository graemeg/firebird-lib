(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fstableview.pas


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

unit fstableview;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Grids, ActnList, Math, Menus;

type

  { TfrmTableView }

  TfrmTableView = class(TForm)
    aViewBlob: TAction;
    aRefresh: TAction;
    aRemoveFilter: TAction;
    aFilter: TAction;
    aFetchNext: TAction;
    ActionList1: TActionList;
    ImageList1: TImageList;
    MainMenuTableView: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    SaveDialog1: TSaveDialog;
    sdBlob: TSaveDialog;
    sbTableView: TStatusBar;
    sgData: TStringGrid;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    procedure aFetchNextExecute(Sender: TObject);
    procedure aFilterExecute(Sender: TObject);
    procedure aRefreshExecute(Sender: TObject);
    procedure aRemoveFilterExecute(Sender: TObject);
    procedure aViewBlobExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ImageList1Change(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure sgDataDblClick(Sender: TObject);
    procedure sgDataMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure sgDataSelectCell(Sender: TObject; Col, Row: Integer;
      var CanSelect: Boolean);

  private
    { private declarations }
    FTableName: string;
    FDbKey: TStringList;
    FRecCount: Integer;
    FBlobCellSelected : Boolean;
    FFilter: string;
    FIsOrder: Boolean;
    function AbjustColWidth(const ACol: Integer): Integer;
    procedure ClearGrid;
    procedure FetchGrid;
    procedure PrepareGrid;
    procedure BlobView(const ADbKey,AFieldName: string);
    procedure ExecuteSql;
  public
    { public declarations }
    property TableName: string read FTableName write FTableName;
  end; 

//var
  //frmTableView: TfrmTableView;
  const
    MAX_ROWS = 500;
    {$IFDEF UNIX}
     ROW_H = 5;
    {$ELSE}
     ROW_H = 2;
    {$ENDIF}
    DEFAULT_HEIGHT = 320;
    DEFAULT_WIDTH = 580;
    
implementation

uses
  ibase_h, fsdm, fstablefilter, fsblobviewdialog, fsblobtext, fsconfig, fsgridintf;

{ TfrmTableView }


//------------------------------------------------------------------------------

function TfrmTableView.AbjustColWidth(const ACol: Integer): integer;
var
  wn, wt: integer;
begin
  wn := sgData.Canvas.TextWidth(dmIb.qryTableView.FieldName(ACol));
  case DmIb.qryTableView.FieldType(ACol) of
    SQL_SHORT:
      wt := sgData.Canvas.TextWidth('-32768.');
    SQL_LONG:
      wt := sgData.Canvas.TextWidth('-2147483648.');
    SQL_INT64,
    SQL_FLOAT,
    SQL_D_FLOAT,
    SQL_DOUBLE:
      wt := sgData.Canvas.TextWidth(StringOfChar('9', 16));
    SQL_VARYING, SQL_TEXT:
      begin
        if Dmib.qryTableView.FieldSize(ACol) < 70 then
          wt := sgData.Canvas.TextWidth(StringOfChar('X', DmIb.qryTableView.FieldSize(ACol)))
        else
          wt := sgData.Canvas.TextWidth(StringOfChar('X', 70));
      end;
    SQL_BLOB:
      wt := sgData.Canvas.TextWidth('(BLOB) ');
    SQL_ARRAY:
      wt := sgData.Canvas.TextWidth('(ARRAY)');
    SQL_TIMESTAMP:
      wt := sgData.Canvas.TextWidth(DateTimeToStr(now));
    SQL_TYPE_TIME:
      wt := sgData.Canvas.TextWidth(TimeToStr(now));
    SQL_TYPE_DATE:
      wt := sgData.Canvas.TextWidth(DateToStr(now));
    else
      wt := 100;
  end;
  Result := IfThen(wt > wn, wt, wn) + 2;
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.ClearGrid;
{
var
  i: Integer;
  Head: TStringList;}
begin
  {
  Head := TStringList.Create;
  try
    Head.Assign(sgData.Rows[0]);
    for i := 0 to sgData.ColCount - 1 do
    begin
      sgData.Cols[i].BeginUpdate;
      sgData.Cols[i].Clear;
      sgData.Cols[i].EndUpdate;
    end;
    sgData.Rows[0].Assign(Head);
    sgData.RowCount := 2;

  finally
    Head.Free;
  end; }
  sgData.Clean;
end;


//------------------------------------------------------------------------------

procedure TfrmTableView.aFetchNextExecute(Sender: TObject);
//var
 //Head : TStringList;
begin
  //Head := TStringList.Create;
  //try
    //Head.Assign(sgData.Rows[0]);
    //ClearGrid;
    sgData.Clean([gzNormal]);
    aFetchNext.Enabled := False;
    FetchGrid;
    //sgData.Rows[0].Assign(head);
  //finally
    //head.Free;
  //end;
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.PrepareGrid;
var
  i: integer;
begin
  FRecCount := 0;
  sgData.ColCount := dmib.qryTableView.FieldCount;
  sgData.RowCount := 2;
  sgData.DefaultRowHeight := sgData.Canvas.TextHeight('X') + ROW_H ;
  for i := 0 to dmib.qryTableView.FieldCount - 1 do
  begin
    if i = 0 then
    begin
      sgData.Cells[i, 0] := 'REC. #';
      sgData.ColWidths[i] := sgData.Canvas.TextWidth('REC. ####') + 2;
    end
    else
    begin
      sgData.Cells[i, 0] := dmib.qryTableView.FieldName(i);
      sgData.Cells[i,1] := '';
      sgData.ColWidths[i] := AbjustColWidth(i);
    end;
  end;
end;

//------------------------------------------------------------------------------


procedure TfrmTableView.FetchGrid;
var
  i: Integer;
  nRows: Integer;
begin
  FDBKey.Clear;
  nRows := 0;
  sgData.RowCount := MAX_ROWS + 1;
  
  while not dmib.qryTableView.EOF  do
  begin
    Inc(FRecCount);
    for i := 0 to dmib.qryTableView.FieldCount - 1 do
    begin
      if i = 0 then
      begin
        sgData.Cells[i, nRows + 1] := IntToStr(FRecCount);
        FDBKey.Add(dmib.qryTableView.FieldAsString(i));
      end
      else
      begin
        //sgData.RowCount :=  sgData.RowCount + 1;
        if dmib.qryTableView.FieldIsNull(i) then
           sgData.Cells[i, nROws + 1] := ''
        else
        begin
        case dmib.qryTableView.FieldType(i) of
          SQL_BLOB:
              if dmib.qryTableView.FieldSubType(i) = 1 then
               //sgData.Cells[i,FRowsInGrid] := dmib.qryTableView.FieldAsString(i);
               sgData.Cells[i,nRows + 1 ] := '(Memo)'
              else
               sgData.Cells[i,nRows + 1 ] := '(Blob)';

          SQL_ARRAY:
            //sgData.Cells[i, FRowsInGrid] := dmib.qryTableView.FieldAsString(i);
              sgData.Cells[i, nRows + 1] := '(Array)';
          SQL_INT64, SQL_LONG ,SQL_SHORT ,SQL_DOUBLE, SQL_FLOAT, SQL_D_FLOAT:
            if dmib.qryTableView.FieldScale(i) <> 0 then
              sgData.Cells[i, nRows + 1 ] := fsgridintf.FormatNumericValue(
                dmib.qryTableView.FieldAsDouble(i),dmib.qryTableView.FieldScale(i))
            else
              sgData.Cells[i, nRows + 1 ] := dmib.qryTableView.FieldAsString(i);
          else
            sgData.Cells[i, nRows + 1 ] := dmib.qryTableView.FieldAsString(i);
        end;
        end;
      end;
    end;   // end for
    Inc(nRows);
    if nRows = MAX_ROWS then
    begin
      aFetchNext.Enabled := True;
      dmib.qryTableView.Next;
      Break;
    end
    else
      dmib.qryTableView.Next;
  end;

  if nRows <= 1 then
     sgData.RowCount := 2
  else
    sgData.RowCount := nRows + 1 ;
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.ExecuteSql;
var
 SqlText,SqlNumRecord:string;
begin

  if FFilter = '' then
  begin
    SqlText := 'Select RDB$DB_KEY ,' + FTableName + '.*  from ' + FTableName;
    SqlNumRecord := 'Select count(*) from ' + FTableName;
  end
  else
  begin
    SqlText := 'Select RDB$DB_KEY ,' + FTableName + '.*  from ' +
     FTableName + ' where ' + FFilter;
    if not FisOrder  then
      SqlNumRecord := 'Select count(*) from ' + FTableName + ' where ' + FFilter;
  end;

  try

    Screen.Cursor := crSQLWait;
    if not dmib.trTableView.InTransaction then
      dmib.trTableView.StartTransaction;
    if dmib.qryTableView.Prepared then dmib.qryTableView.UnPrepare;
    dmib.qryTableView.SQL.Text := SqlNumRecord;
    dmib.qryTableView.ExecSQL;

    sbTableView.Panels[0].Text := Format('Total records : %d',
      [dmib.qryTableView.FieldAsInteger(0)]);
    dmib.qryTableView.UnPrepare;
    FRecCount := 0;
    aFetchNext.Enabled := False;
    if dmib.qryTableView.Prepared then dmib.qryTableView.UnPrepare;
    dmib.qryTableView.SQL.Text := SqlText;
    dmib.qryTableView.Prepare;
    ClearGrid;
    PrepareGrid;
    //ShowMessage('ok');
    dmib.qryTableView.ExecSQL;
    FetchGrid;
  finally
    Screen.Cursor := crDefault;
  end;
end;


//------------------------------------------------------------------------------

procedure TfrmTableView.aFilterExecute(Sender: TObject);
var
 frmFilter: TfrmTableFilter;
begin
  frmFilter := TfrmTableFilter.Create(self,FTableName);
 try
   frmFilter.Caption := 'Set table filter :: ' + FTableName;
   frmFilter.Filter := FFilter;
   if frmFilter.ShowModal = mrOk then
   begin
       FFilter := frmFilter.Filter;
       FIsOrder := frmFilter.IsOrder;
       ExecuteSql;
       aFilter.Hint := 'Filter: Active' + #10 + FFilter;
       aRemoveFilter.Enabled := True;
   end;
 finally
   frmFilter.Free;
 end;
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.aRefreshExecute(Sender: TObject);
begin
   ExecuteSql;
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.aRemoveFilterExecute(Sender: TObject);
begin
  FFilter := '';
  aFilter.Hint := 'Set Filter';
  ExecuteSql;
  aRemoveFilter.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.aViewBlobExecute(Sender: TObject);
begin
  if FBlobCellSelected then
   BlobView(FdbKey.Strings[sgData.row - 1],sgData.Cells[sgData.Col,0]);
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if dmib.trTableView.InTransaction then dmib.trTableView.Commit;
  fsconfig.SaveFormPos(self);
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.FormCreate(Sender: TObject);
begin
  FDbKey := TStringList.Create;
  FFilter := '';
  FBlobCellSelected := False;
  aFetchNext.Hint := Format('Fetch next %d record',[MAX_ROWS]);
  Self.Top := (Screen.Height - DEFAULT_HEIGHT) div 2;
  Self.Left := (Screen.Width - DEFAULT_WIDTH) div 2;
  Self.Height := DEFAULT_HEIGHT;
  Self.Width := DEFAULT_WIDTH;
  fsconfig.LoadFormPos(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.FormDestroy(Sender: TObject);
begin
  FDbKey.Free;
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.FormShow(Sender: TObject);
begin
  Caption := 'View Data Table :: ' + FTableName;
  ExecuteSql;
end;

procedure TfrmTableView.ImageList1Change(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------

procedure TfrmTableView.MenuItem10Click(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.sgDataDblClick(Sender: TObject);
begin
  if FBlobCellSelected then
    BlobView(FdbKey.Strings[sgData.row - 1],sgData.Cells[sgData.Col,0]);
end;


//------------------------------------------------------------------------------

procedure TfrmTableView.sgDataMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  c, r: Integer;
begin
  sgData.MouseToCell(X,Y,c,r);
  if (c > 0) and (r > 0) then
  begin
    if (sgData.Cells[c, r] = '(Memo)') or (sgData.Cells[c, r] = '(Blob)') then
    begin
      sgData.Cursor := crHandPoint;
    end
    else
    begin
      sgData.Cursor := crDefault;
    end;
  end
  else
  begin
    sgData.Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmTableView.sgDataSelectCell(Sender: TObject; Col, Row: Integer;
  var CanSelect: Boolean);
begin
  FBlobCellSelected := (sgData.Cells[Col, Row] = '(Memo)') or (sgData.Cells[Col, Row] = '(Blob)');
  aViewBlob.Enabled := FBlobCellSelected;
end;

//------------------------------------------------------------------------------


procedure TfrmTableView.BlobView(const AdbKey,AFieldName: string);
var
  frmBlobViewDialog: TfrmBlobViewDialog;
begin
  frmBlobViewDialog := TfrmBlobViewDialog.Create(self);
  try
    if not dmib.trBlobView.InTransaction then
       dmib.trBlobView.StartTransaction;
    dmib.qryBlobView.SQL.Text := 'Select ' + AFieldName + ' from ' + FTableName +  ' where RDB$DB_KEY = ?';
    dmib.qryBlobView.Prepare;
    dmib.qryBlobView.ParamAsString(0,ADbkey);
    dmIb.qryBlobView.ExecSQL;
    frmBlobViewDialog.FieldName := dmIb.qryBlobView.FieldName(0);
    frmBlobViewDialog.BlobType := dmIb.qryBlobView.FieldSubType(0);
    if frmBlobViewDialog.ShowModal = mrOk then
    begin
      if frmBlobViewDialog.BlobType = 1 then
          FsBlobText.ViewBlobText(dmIb.qryBlobView.BlobFieldAsString(0))
      else
      begin
       if sdBlob.Execute then
        begin
          dmib.qryBlobView.BlobFieldSaveToFile(0,sdBlob.FileName);
        end;
      end;
    end;
    dmIb.qryBlobView.UnPrepare;
    dmib.trBlobView.RollBack;
  finally
    frmBlobViewdialog.Free;
  end;
end;


initialization
  {$I fstableview.lrs}

end.

