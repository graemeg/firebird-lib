(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file: fsbrowser.pas


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

unit fsbrowser;

{$mode objfpc}{$H+}
//{$define TEST_}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  SynMemo, ComCtrls, ActnList, Menus, StdCtrls, Grids,
  SynEdit, FBLDatabase, FBLDsql, FBLExcept,
  FBLTextGridExport, ibase_h, FBLmixf, Math, FBLScript, StdActns;

type

  TColDesc = record
    intType, Subtype: smallint;
  end;
  
  TScriptStat = record
    stm_count, ins_rows, del_rows, upg_rows, ddl_cmds: integer;
    start_t, end_t: TDatetime;
  end;
  
  TNodeDesc = class         //store information for each node
  private
    FNodeType: Integer;
    FObjName: string;
    FObjDesc: string;
  public
    constructor Create(ANodeType: Integer; AObjName, AObjDesc: string);
    property NodeType: Integer read FNodeType write FNodeType;
    property ObjName: string read FObjName write FObjName;
    property ObjDesc: string read FObjDesc write FObjDesc;
  end;
  
  { TfrmBrowser }

  TfrmBrowser = class(TForm)
    aCommit: TAction;
    aClearHistory: TAction;
    aBackupDatabase: TAction;
    aCreateDb: TAction;
    aClearMessages: TAction;
    aDbConnections: TAction;
    aShowAbout: TAction;
    aUsers: TAction;
    aServiceMgr: TAction;
    aMbufferSelectAll: TAction;
    aShowTextOptions: TAction;
    aShowOptions: TAction;
    aShowOptionDescription: TAction;
    aGrantMgr: TAction;
    aExportToHtml: TAction;
    aExportToSql: TAction;
    aViewData: TAction;
    aDisconnect: TAction;
    aRefreshAll: TAction;
    aNext: TAction;
    aPrevious: TAction;
    aMetadata: TAction;
    aExecSqlScript: TAction;
    aExecSql: TAction;
    aRollBack: TAction;
    aSaveScript: TAction;
    aOpenScript: TAction;
    aNewScript: TAction;
    ActionList1: TActionList;
    aEditCopy: TEditCopy;
    aEditCut1: TEditCut;
    aEditPaste1: TEditPaste;
    lTitle: TLabel;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuExit: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    mPlan: TMemo;
    mMsg: TListBox;
    lvValues: TListView;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    nbMain: TPageControl;
    nbSQL: TPageControl;
    pmnItem: TPopupMenu;
    pmnDatabase: TPopupMenu;
    pmnMemo: TPopupMenu;
    pmnSql: TPopupMenu;
    pmnMessages: TPopupMenu;
    sgParams: TStringGrid;
    sgFields: TStringGrid;
    sbtvDb: TStatusBar;
    tabMessages: TTabSheet;
    tabPlan: TTabSheet;
    tabParams: TTabSheet;
    sgGrid: TStringGrid;
    mGrid: TSynMemo;
    tabFields: TTabSheet;
    pUp: TPanel;
    pDown: TPanel;
    Splitter1: TSplitter;
    mSql: TSynEdit;
    sbarEdit: TStatusBar;
    TabDLL: TTabSheet;
    TabSql: TTabSheet;
    tabGrid: TTabSheet;
    pTitle: TPanel;
    Script: TFBLScript;
    ImageList1: TImageList;
    MenuItem1: TMenuItem;
    mnMain: TMainMenu;
    odOpen: TOpenDialog;
    pListView: TPanel;
    pOut: TPanel;
    sdSave: TSaveDialog;
    slpMain: TSplitter;
    mBuffer: TSynMemo;
    ToolBar1: TToolBar;
    ToolBarMain: TToolBar;
    ToolButton1: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton14: TToolButton;
    ToolButton15: TToolButton;
    ToolButton16: TToolButton;
    ToolButton17: TToolButton;
    ToolButton18: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton9: TToolButton;
    tvDb: TTreeView;
    procedure aClearMessagesExecute(Sender: TObject);
    procedure aCreateDbExecute(Sender: TObject);
    procedure aDbConnectionsExecute(Sender: TObject);
    procedure aExportToHtmlExecute(Sender: TObject);
    procedure aExportToSqlExecute(Sender: TObject);
    procedure aMbufferSelectAllExecute(Sender: TObject);
    procedure aServiceMgrExecute(Sender: TObject);
    procedure aShowAboutExecute(Sender: TObject);
    procedure aShowOptionDescriptionExecute(Sender: TObject);
    procedure aShowOptionsExecute(Sender: TObject);
    procedure aShowTextOptionsExecute(Sender: TObject);
    procedure aUsersExecute(Sender: TObject);
    procedure aViewDataExecute(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure aBackupDatabaseExecute(Sender: TObject);
    procedure aClearHistoryExecute(Sender: TObject);
    procedure aCommitExecute(Sender: TObject);
    procedure aDisconnectExecute(Sender: TObject);
    procedure aExecSqlExecute(Sender: TObject);
    procedure aExecSqlScriptExecute(Sender: TObject);
    procedure aMetadataExecute(Sender: TObject);
    procedure aNewScriptExecute(Sender: TObject);
    procedure aNextExecute(Sender: TObject);
    procedure aOpenScriptExecute(Sender: TObject);
    procedure aPreviousExecute(Sender: TObject);
    procedure aRefreshAllExecute(Sender: TObject);
    procedure aRollBackExecute(Sender: TObject);
    procedure aSaveScriptExecute(Sender: TObject);
    procedure MenuExitClick(Sender: TObject);
    procedure mSqlChange(Sender: TObject);
    procedure mSqlClick(Sender: TObject);
    procedure mSqlKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure nbMainPageChanged(Sender: TObject);
    procedure tvDbChange(Sender: TObject; Node: TTreeNode);
    procedure tvDbClick(Sender: TObject);
    procedure tvDbDblClick(Sender: TObject);
    procedure tvDbMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvDbMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    FParamValue: array of string;
    FColDesc: array of TColDesc;
    FHistory: TStringList;
    FHistoryIdx: Integer;
    FScriptStat: TScriptStat;
    FCurrentAlias: string;
    {Database Objects List}
    FDomainList: TStringList;
    FTableList: TStringList;
    FViewList: TStringList;
    FProcList: TStringList;
    FTriggerList: TStringList;
    FGeneratorList: TStringList;
    FUdfList: TStringList;
    FExceptionList: TStringList;
    FRoleList: TStringList;
    FSysTableList: TStringList;
    FSysTriggerList: TStringList;
    FExecutedDDLStm: Boolean;
    {$IFDEF UNIX}
    FNeedRefresh: boolean;
    {$ENDIF}
    procedure DoAfterDisconnect;
    procedure CarretPos;
    procedure EndTr(ATrCommit: Boolean = False); //False rollback (default) True commit
    procedure RefreshStatusBar;
    procedure StartTr;
    procedure FetchFieldsGrid;
    procedure FetchParamGrid;
    procedure InsertParams;
    procedure ClearDataGrid;
    procedure FetchDataGrid;
    procedure AddtoHistory(const AStm: string);
    procedure ShowBuffer;
    procedure LoadTvDb;
    procedure ClearTvDB;
    procedure LoadLists;
    procedure TreeViewEvents(ANode: TTreeNode);
    procedure ShowValues;
    procedure ShowDatabaseItems;
    procedure ShowListObject(const AObjType: Integer; const AOption: string = '');
    procedure ShowDependencies(const ASqlObj: string);
    procedure ShowPrivileges(const ASqlObj: string);
    procedure DoAfterConnect;
    procedure LoadFontColor;
    procedure SetOutputType(const AType: Integer);
    function ExecuteSQL(const ASqlText: string; const AVerbose: Boolean): boolean;
    function AbjustColWidth(const ACol: integer): integer;
    procedure ShowTableView(const ATableName: string);
    procedure ShowObjectDescription(const AType: Integer ; const ASqlObject: string);
  public
    { public declarations }
  end;
  
  
const
  (*  tree view node name  *)
  CDOMAINS = 'Domains';
  CTABLES = 'Tables';
  CVIEWS = 'Views';
  CPROCEDURES = 'Procedures';
  CTRIGGERS = 'Triggers';
  CGENERATORS = ' Generators';
  CUDFS = 'UDFs';
  CEXCEPTIONS = 'Exceptions';
  CROLES = 'Roles';
  CSYSTEMTABLES = 'System Tables';
  CSYSTEMTRIGGERS = 'System Triggers';
  CDEP = 'Dependencies';
  CPRIV = 'Privileges';

  (* tree view item type *)
  CNT_DATABASE =   0;
  CNT_DOMAINS =    1;
  CNT_DOMAIN =     2;
  CNT_TABLES =     3;
  CNT_TABLE =      4;
  CNT_VIEWS =      5;
  CNT_VIEW =       6;
  CNT_PROCEDURES = 7;
  CNT_PROCEDURE =  8;
  CNT_TRIGGERS =   9;
  CNT_TRIGGER =    10;
  CNT_GENERATORS = 11;
  CNT_GENERATOR =  12;
  CNT_UDFS =       13;
  CNT_UDF =        14;
  CNT_EXCEPTIONS = 15;
  CNT_EXCEPTION =  16;
  CNT_ROLES =           17;
  CNT_ROLE =            18;
  CNT_DEP =             19;
  CNT_PRIV =            20;
  CNT_SYSTABLES =       21;
  CNT_SYSTABLE  =       22;
  CNT_SYSTRIGGERS =     23;
  CNT_SYSTRIGGER =      24;
  CNT_TRIGGERSINTABLE = 25;

  (* Tree Views Bitmaps *)
  BMP_NONE = -1;
  BMP_DOMAIN = 0;
  BMP_TABLE = 1;
  BMP_VIEW = 2;
  BMP_PROCEDURE = 3;
  BMP_TRIGGER = 4;
  BMP_GENERATOR = 5;
  BMP_UDF = 6;
  BMP_SYSTEMTABLE = 8;
  BMP_DEP = 10;
  BMP_EXCEPTION = 13;
  BMP_ROLE = 14;
  BMP_SYSTEMTRIGGER = 15;
  BMP_DATABASE = 16;
  BMP_PRIV = 17;
  {$IFDEF UNIX}
  ROW_H = 5;
  {$ELSE}
  ROW_H = 2;
  {$ENDIF}
  
  DEFAULT_HEIGHT = 500;
  DEFAULT_WIDTH = 640;

var
  frmBrowser: TfrmBrowser;

implementation

uses
  fsdm, fsconst, fsconfig, fsmixf, fsparaminput, fsblobinput, fsblobtext,
  fslogin, fsdialogtran, fstableview, fscreatedb, fsexporttohtml,
  fsdescription, fsoptions, fstextoptions, fsservice, fsusers, fsbackup,
  fsabout, fsdbconnections, fsgridintf;

{ TNodeDesc }
  
constructor TNodeDesc.Create(ANodeType: Integer; AObjName, AObjDesc: string);
begin
  FNodeType := ANodeType;
  FObjName := AObjName;
  FObjDesc := AObjDesc;
end;

{ TfrmBrowser }

{private functions procedures}

//------------------------------------------------------------------------------

procedure TfrmBrowser.DoAfterDisconnect;
begin
  {$IFNDEF UNIX}
  tabSql.TabVisible := False;
  tabGrid.TabVisible := False;
  tabFields.TabVisible := False;
  tabParams.TabVisible := False;
  {$ELSE}
  tabSql.Visible := False;
  tabGrid.Visible := False;
  tabFields.Visible := False;
  tabParams.Visible := False;
  {$ENDIF}
  aNewScript.Enabled := False;
  aOpenScript.Enabled := False;
  aSaveScript.Enabled := False;
  aCommit.Enabled := False;
  aRollback.Enabled := False;
  aExecSql.Enabled := False;
  aExecSqlScript.Enabled := False;
  aMetadata.Enabled := False;
  aClearHistory.Enabled := False;
  FCurrentAlias := '';
  FHistory.Clear;
  FHistoryIdx := 0;
  aPrevious.Enabled := False;
  aNext.Enabled := False;
  mSql.Lines.Clear;
  aBackupDatabase.Enabled := False;
  {$IFDEF UNIX}
  FNeedRefresh := False;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.DoAfterConnect;
var
  History: TStringList;
  i: integer;
begin
  History := TStringList.Create;
  {$IFNDEF UNIX}
  tabSql.TabVisible := True;
  tabGrid.TabVisible := False;
  {$ELSE}
  tabSql.Visible := True;
  tabGrid.Visible := False;
  {$ENDIF}
  aNewScript.Enabled := True;
  aOpenScript.Enabled := True;
  aExecSql.Enabled := True;
  aExecSqlScript.Enabled := True;
  aMetadata.Enabled := True;
  aClearHistory.Enabled := True;
  RefreshStatusBar;
  aBackupDatabase.Enabled := True;
  try
    FsConfig.LoadHistory(FCurrentAlias, History);
    for i := 0 to History.Count - 1 do
      AddtoHistory(History.Strings[i]);
  finally
    History.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.CarretPos;
begin
  sbarEdit.Panels[0].Text := Format('%d:%d', [mSql.CaretY, mSql.CaretX]);
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.EndTr(ATrCommit: Boolean = False); //False rollback (default) True commit;
begin
  aCommit.Enabled := False;
  aRollBack.Enabled := False;
  if FExecutedDDLStm then
  begin
    if ATrCommit then
     aRefreshAllExecute(Self);
    FExecutedDDLStm := False;
  end;
  RefreshStatusBar;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.RefreshStatusBar;
begin
  sbarEdit.Panels[0].Text := Format('%d:%d', [mSql.CaretY, mSql.CaretX]);
  if dmib.trISql.InTransaction then
  begin
    sBarEdit.Panels[1].Text := 'Transaction:Active';
    sBarEdit.Panels[1].Width := sBarEdit.Canvas.TextWidth(sBarEdit.Panels[1].Text) + 10;
  end
  else
    sBarEdit.Panels[1].Text := '';
  if FsConfig.auto_commit_ddl then
  begin
    sBarEdit.Panels[2].Text := 'Auto Commit DDL';
    sBarEdit.Panels[2].Width := sBarEdit.Canvas.TextWidth(sBarEdit.Panels[2].Text) + 10;
  end
  else
    sBarEdit.Panels[2].Text := '';

  if FsConfig.max_fetch > 0 then
  begin
    sBarEdit.Panels[3].Text := Format('Fetch limit:%d', [FsConfig.max_fetch]);
    sBarEdit.Panels[3].Width := sBarEdit.Canvas.TextWidth(sBarEdit.Panels[3].Text) + 10;
  end
  else
    sBarEdit.Panels[3].Text := '';
  sBarEdit.Panels[4].Text := Format('Dialect %d',[dmib.DbMain.SQLDialect]);
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.StartTr;
begin
  aCommit.Enabled := True;
  aRollBack.Enabled := True;
  RefreshStatusBar;
end;

//------------------------------------------------------------------------------
{ return true if error}

function TfrmBrowser.ExecuteSQL(const ASqlText: string; const AVerbose: Boolean): boolean;
var
  PrepareTimeStart, ExecTime, ExecTimeStart, FetchTime, FetchTimeStart: TDateTime;
  i: integer;
begin
  Result := False;
  if not dmib.trISql.InTransaction then
  begin
    dmib.trISql.StartTransaction;
    StartTr;
    mMsg.Items.Add(Format('Start Transaction. [%s]',[TimeToStr(Now)]));
  end;

  dmib.qryISql.Close;

  if Trim(dmib.qryISql.SQL.Text) <> Trim(ASqlText) then
    dmib.qryISql.SQL.Text := ASqlText;
    
  nbSql.PageIndex := 0;

  try
    if not dmib.qryISql.Prepared then
    begin
      if AVerbose then
        mMsg.Items.Add('Preparing...');
      PrepareTimeStart := Time;
      dmib.qryISql.Prepare;
      if AVerbose then
      begin
        mMsg.Items.Add(Format('Statement prepared. [Time :%s]',[TimeT(Time - PrepareTimeStart)]));
        mPlan.Lines.Text := dmib.qryISql.Plan;
      end;
      if Dmib.qryISql.FieldCount > 0 then
      begin
        FetchFieldsGrid;
        {$IFNDEF UNIX}
        TabGrid.TabVisible := True;
        TabFields.TabVisible := True;
        {$ELSE}
        TabGrid.Visible := True;
        TabFields.Visible := True;
        {$ENDIF}
      end
      else
      begin
        {$IFNDEF UNIX}
        TabGrid.TabVisible := False;
        TabFields.TabVisible := False;
        {$ELSE}
        TabGrid.Visible := False;
        TabFields.Visible := False;
        {$ENDIF}
      end;

      if Dmib.qryISql.ParamCount > 0 then
      begin
        {$IFNDEF UNIX}
        tabParams.TabVisible := True;
        {$ELSE}
        tabParams.Visible := True;
        {$ENDIF}
        FetchParamGrid;
      end
      else
        {$IFNDEF UNIX}
        TabParams.TabVisible := False;
        {$ELSE}
        TabParams.Visible := False;
        {$ENDIF}
    end

    else
    begin
      if AVerbose then
      begin
        mMsg.Items.Add('Statement already prepared');
      end;
    end;
  except
    on E: EFBLError do
    begin
      beep;
      mMsg.Items.Add('Error in prepare. [isc_error : ' + IntToStr(E.ISC_ErrorCode) + ']');
      mMsg.Items.Text := mMsg.Items.Text + E.Message;
      DmIB.qryISql.UnPrepare;
      Result := True;
      Exit;
    end;
  end;

  if dmib.qryISql.ParamCount > 0 then
  begin
    try
      InsertParams;
      for i := 0 to Dmib.qryISql.ParamCount - 1 do
        sgParams.Cells[1,i + 1] := FParamValue[i];
    except
      on Er: Exception do
      begin
        mMsg.Items.Add('');
        mMsg.Items.Text := mMsg.Items.Text + Er.Message;
        Exit;
      end;
    end;
  end;

  try      //execute statement
    ExecTimeStart := Time;
    case Dmib.qryISql.QueryType of
      qtSelect:
        begin
          if AVerbose then
            mMsg.Items.Add('Executing...');
          DmIb.qryISql.ExecSQL;
          ExecTime := Time - ExecTimeStart;
          FetchTimeStart := Time;
          if AVerbose then
          begin
            mMsg.Items.Add(Format('Statement executed. [Time :%s]',[TimeT(ExecTime)]));
            mMsg.Items.Add('Fetching..');
          end;
          Application.ProcessMessages;
          if FsConfig.set_output_grid = 0 then
            FetchDataGrid
          else if FsConfig.set_output_grid = 1 then
            TextGrid(dmib.qryISql, mgrid.Lines);
          FetchTime := Time - FetchTimeStart;
          mMsg.Items.Add(Format('%d Row(s) Fetched. [Time :%s]', [Dmib.qryISql.FetchCount,TimeT(FetchTime)]));
        end;
      qtInsert:
        begin
          DmIb.qryISql.ExecSQL;
          FScriptStat.ins_rows := FScriptStat.ins_rows + Dmib.qryISql.RowsAffected;
          if AVerbose then
          begin
            execTime := Time - ExecTimeStart;
            mMsg.Items.Add(Format('Statement executed. [Time :%s]',[TimeT(ExecTime)]));
            mMsg.Items.Add(Format('%d Row(s) Inserted.', [Dmib.qryISql.RowsAffected]));
          end;
        end;
      qtUpdate:
        begin
          DmIb.qryISql.ExecSQL;
          FScriptStat.upg_rows := FScriptStat.upg_rows + Dmib.qryISql.RowsAffected;
          if AVerbose then
          begin
            execTime := Time - ExecTimeStart;
            mMsg.Items.Add(Format('Statement executed. [Time :%s]',[TimeT(ExecTime)]));
            mMsg.Items.Add(Format('%d Row(s) Updated.', [Dmib.qryISql.RowsAffected]));
          end;
        end;
      qtDelete:
        begin
          DmIb.qryISql.ExecSQL;
          FScriptStat.del_rows := FScriptStat.del_rows + Dmib.qryISql.RowsAffected;
          if AVerbose then
          begin
            execTime := Time - ExecTimeStart;
            mMsg.Items.Add(Format('Statement executed. [Time :%s]',[TimeT(ExecTime)]));
            mMsg.Items.Add(Format('%d Row(s) Deleted.', [Dmib.qryISql.RowsAffected]));
          end;
        end;
      qtDDL:
        begin
          Dmib.qryISql.ExecSQL;
          Inc(FScriptStat.ddl_cmds);
          FExecutedDDLStm := True;
          if AVerbose then
          begin
            execTime := Time - ExecTimeStart;
            mMsg.Items.Add(Format('Statement executed. [Time :%s]',[TimeT(ExecTime)]));
          end;
          if auto_commit_ddl then
          begin
            dmib.trISql.CommitRetaining;
            mMsg.Items.Add('Transaction commited retaining.')
          end;
        end;
      qtExecProcedure:
        begin
          Dmib.qryISql.ExecSQL;
          if AVerbose then
          begin
            execTime := Time - ExecTimeStart;
            mMsg.Items.Add(Format('Stored procedure executed. [Time :%s]',[TimeT(ExecTime)]));
            if DmIb.qryISql.FieldCount > 0 then
            begin
              mMsg.Items.Add('Fetching...');
              if FsConfig.set_output_grid = 0 then
                FetchDataGrid
              else if FsConfig.set_output_grid = 1 then
                    TextGrid(dmib.qryISql, mgrid.Lines);
            end;
            if Dmib.qryISql.FieldCount > 0 then
              mMsg.Items.Add(Format('%d Row(s) Fetched.', [Dmib.qryISql.FetchCount]));
          end;
        end;
      qtCommit:
        begin
          Dmib.qryISql.ExecSQL;
          mMsg.Items.Add(Format('Transaction Commited. [%s]',[TimeToStr(Now)]));
          EndTr(True);
        end;
      qtRollback:
        begin
          Dmib.qryISql.ExecSQL;
          mMsg.Items.Add(Format('Transaction Rolled back. [%s]',[TimeToStr(Now)]));
          EndTr;
        end;
      qtSelectForUpdate:
        begin
          Dmib.qryISql.ExecSQL;
          if AVerbose then
          begin
            execTime := Time - ExecTimeStart;
            mMsg.Items.Add(Format('Statement executed. [Time :%s]',[TimeT(ExecTime)]));
            mMsg.Items.Add('Select for update.');
          end;
        end;
      qtSetGenerator:
        begin
          Dmib.qryISql.ExecSQL;
          Inc(FScriptStat.ddl_cmds);
          if AVerbose then
          begin
            execTime := Time - ExecTimeStart;
            mMsg.Items.Add(Format('Statement executed. [Time :%s]',[TimeT(ExecTime)]));
            mMsg.Items.Add('Generator Set.');
          end;
        end;
    end;
  except
    on E: EFBLError do
    begin
      mMsg.Items.Add('Error in execute. [isc_error : ' + IntToStr(E.ISC_ErrorCode) + ']');
      mMsg.Items.Add(' ');
      mMsg.Items.Text := mMsg.Items.Text + E.Message;
      DmIB.qryISql.Close;
      Result := True;
      Exit;
    end;
  end;
  if mMsg.Items.Count > 0 then mMsg.ItemIndex := mMsg.Items.Count - 1;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.ClearDataGrid;
begin
  sgGrid.Clean([gzNormal]);
  sgGrid.DefaultRowHeight := sgGrid.Canvas.TextHeight('X') + 2;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.FetchDataGrid;
var
  i, r, c: integer;
begin
  ClearDataGrid;
  with dmib do
  begin
    FColDesc := nil;
    SetLength(FColDesc, qryISql.FieldCount);
    sgGrid.ColCount := qryISql.FieldCount + 1;
    sgGrid.ColWidths[0] := sgGrid.canvas.TextWidth('Rec. #X') + 2;
    sgGrid.Cells[0,0] := 'Rec. #';
    
    for i := 0 to qryISql.FieldCount - 1 do
    begin
      sgGrid.ColWidths[i + 1] := AbjustColWidth(i);
      sgGrid.Cells[i + 1,0] := qryISql.FieldName(i);
      FColDesc[i].intType := qryISql.FieldType(i);
      FColDesc[i].Subtype := qryISql.FieldSubType(i);
    end;
    sgGrid.DefaultRowHeight := sgGrid.Canvas.TextHeight('TEXT') + ROW_H;


    sgGrid.RowCount := 50;
    r := 0;
    c := 0;
    
    while not qryISql.EOF do
    begin
      Inc(r);
      if r < FsConfig.max_grid_rows then
      begin
        sgGrid.Cells[0,r] := IntToStr(qryISql.FetchCount);
        for i := 0 to qryISql.FieldCount - 1 do
        begin
          if qryISql.FieldRealName(i) = 'DB_KEY' then
            sgGrid.Cells[i + 1,r] := DecodeDB_KEY(qryISql.FieldAsString(i))
          else if qryISql.FieldType(i) = SQL_BLOB then
          begin
            if qryISql.FieldSubtype(i) = 1 then // subtype text
            begin
              sgGrid.Cells[i + 1,r] := '(Memo)';
            end
            else
              sgGrid.Cells[i + 1,r] := '(Blob)';
          end
          else if qryISql.FieldType(i) = SQL_ARRAY then
            sgGrid.Cells[i + 1,r] := '(Array)'
          else if qryISql.FieldIsNull(i) then
            sgGrid.Cells[i + 1,r] := '(null)'
          //SQL_INT64, SQL_LONG ,SQL_SHORT ,SQL_DOUBLE, SQL_FLOAT, SQL_D_FLOAT
          else if (qryISql.FieldType(i) = SQL_INT64) or
            (qryISql.FieldType(i) = SQL_LONG) or (qryISql.FieldType(i) = SQL_SHORT) or
            (qryISql.FieldType(i) = SQL_DOUBLE) or (qryISql.FieldType(i) = SQL_FLOAT) or
            (qryISql.FieldType(i) = SQL_D_FLOAT) then
              if qryISql.FieldScale(i) <> 0 then
                sgGrid.Cells[i + 1,r] := fsgridintf.FormatNumericValue(
                qryISql.FieldAsDouble(i),qryIsql.FieldScale(i))
              else
                sgGrid.Cells[i + 1,r] := qryISql.FieldAsString(i)
          else
            sgGrid.Cells[i + 1,r] := qryISql.FieldAsString(i);
        end;
      end;
      qryISql.Next;
      inc(c);
      if c = 49 then
      begin
        sgGrid.RowCount := sgGrid.RowCount + 50;
        Application.ProcessMessages;
        c := 0;
      end;
    end;

    if qryISql.FetchCount = 0 then
      sgGrid.RowCount := 2
    else
      if (qryISql.FetchCount + 1) > FsConfig.max_grid_rows then
        sgGrid.RowCount :=  FsConfig.max_grid_rows
      else
        sgGrid.RowCount := qryISql.FetchCount + 1;
  end; // end with dmib
end; // end procedure

//------------------------------------------------------------------------------

procedure TfrmBrowser.InsertParams;
var
  i: integer;
  isNull: boolean;
  ParaInt: integer;
  ParaDouble: double;
  ParaFloat: single;
  ParaText: string;
  ParaDate: TDateTime;
  foo: boolean;
begin
  if not dmib.qryISql.Prepared then exit;
  FParamValue := nil;
  SetLength(FParamValue, dmib.qryISql.ParamCount);
  for i := 0 to dmib.qryISql.ParamCount - 1 do
  begin
    ParaInt := 0;
    ParaDouble := 0;
    ParaFloat := 0;
    Paratext := '';
    ParaDate := now;

    isNull := dmib.qryISql.ParamIsNullable(i);
    case dmib.qryISql.ParamType(i) of

      SQL_VARYING,
      SQL_TEXT:
        if InputParamString(Format('%d of %d', [i + 1,dmib.qryISql.ParamCount]),
          Dmib.qryISql.ParamSQLTypeDesc(i), isNull, Paratext) then
        begin
          if isNull then
          begin
            dmib.qryISql.ParamAsNull(i);
            FParamValue[i] := '<NULL>';
          end
          else
          begin
            Dmib.qryISql.ParamAsString(i, Paratext);
            FParamValue[i] := ParaText;
          end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));

        SQL_DOUBLE:
        if inputParamDouble(Format('%d of %d', [i + 1,dmib.qryISql.ParamCount]),
          Dmib.qryISql.ParamSQLTypeDesc(i), isNull, ParaDouble) then
        begin
          if isNull then
          begin
            dmib.qryISql.ParamAsNull(i);
            FParamValue[i] := '<NULL>';
          end
          else
          begin
            Dmib.qryISql.ParamAsDouble(i, ParaDouble);
            FParamValue[i] := FloatToStr(ParaDouble);
          end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));
        SQL_FLOAT,
        SQL_D_FLOAT:
        if inputParamFloat(Format('%d of %d', [i + 1,dmib.qryISql.ParamCount]),
          Dmib.qryISql.ParamSQLTypeDesc(i), isNull, ParaFloat) then
        begin
          if isnull then
          begin
            dmib.qryISql.ParamAsNull(i);
            FParamValue[i] := '<NULL>';
          end
          else
          begin
            Dmib.qryISql.ParamAsFloat(i, ParaFloat);
            FParamValue[i] := FloatToStr(ParaFloat);
          end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));


        SQL_INT64,
        SQL_LONG,
        SQL_SHORT:
        if dmib.qryISql.ParamScale(i) = 0 then
        begin
          try
          foo := inputParamInt(Format('%d of %d',
            [i + 1,dmib.qryISql.ParamCount]),
            Dmib.qryISql.ParamSQLTypeDesc(i), isNull, ParaInt);
          except
             on E: EXception do
            showMessage(E.Message);
          end;

          if foo = True then
          begin
            if isNull then
            begin
              dmib.qryISql.ParamAsNull(i);
              FParamValue[i] := '<NULL>';
            end
            else
            begin
              //showMessage('not nullvalue');
              Dmib.qryISql.ParamAsLong(i, ParaInt);
              FParamValue[i] := IntToStr(ParaInt);
            end;
          end
          else
            raise Exception.Create(Format('Param #%d not assigned', [i]))
            
        end
        else
            if inputParamDouble(Format('%d of %d', [i + 1,dmib.qryISql.ParamCount]),
              Dmib.qryISql.ParamSQLTypeDesc(i), isNull, ParaDouble) then
            begin
            
              if isnull then
              begin
                dmib.qryISql.ParamAsNull(i);
                FParamValue[i] := '<NULL>';
              end
              else
              begin
                Dmib.qryISql.ParamAsDouble(i, ParaDouble);
                FParamValue[i] := FloatToStr(ParaDouble);
              end;
        end
        else
          raise Exception.Create(Format('Param #%d not assigned', [i]));
          

        SQL_BLOB:
        if dmib.qryISql.ParamSubType(i) = 1 then
        begin
          if InputParamMemo(Format('%d of %d', [i + 1,dmib.qryISql.ParamCount]),
            Dmib.qryISql.ParamSQLTypeDesc(i), isNull, Paratext) then
          begin
            if isNull then
            begin
              dmib.qryISql.ParamAsNull(i);
              FParamValue[i] := '<NULL>';
            end
            else
            begin
              Dmib.qryISql.ParamAsString(i, Paratext);
              FParamValue[i] := '(Memo)';
            end;
          end
          else
            raise Exception.Create(Format('Param #%d not assigned', [i]));
         end
         else
         begin
           if InputParamBlob(Format('%d of %d', [i + 1,dmib.qryISql.ParamCount]),
            Dmib.qryISql.ParamSQLTypeDesc(i), isNull, Paratext) then
            begin
              if isNull then
              begin
                dmib.qryISql.ParamAsNull(i);
                FParamValue[i] := '<NULL>';
              end
              else
              begin
                Dmib.qryISql.BlobParamLoadFromFile(i, Paratext);
                FParamValue[i] := '(Blob)';
              end;
            end
            else
              raise Exception.Create(Format('Param #%d not assigned', [i]));
         end;
        SQL_ARRAY:;
      SQL_QUAD:;
      SQL_TYPE_TIME:
        begin
          if InputParamDateTime(Format('%d of %d', [i + 1,dmib.qryISql.ParamCount]),
            Dmib.qryISql.ParamSQLTypeDesc(i), isNull, ParaDate) then
          begin
            try
              Dmib.qryISql.ParamAsDateTime(i, ParaDate);
              FParamValue[i] := TimeToStr(ParaDate);
            except
              on E: Exception do ShowMessage(E.Message);
            end;
          end
          else
            raise Exception.Create(Format('Param #%d not assigned', [i]))
        end;
      SQL_TYPE_DATE:
        begin
          if InputParamDateTime(Format('%d of %d', [i + 1,dmib.qryISql.ParamCount]),
            Dmib.qryISql.ParamSQLTypeDesc(i), isNull, ParaDate) then
          begin
            try
              Dmib.qryISql.ParamAsDateTime(i, ParaDate);
              FParamValue[i] := DateToStr(ParaDate);
            except
              on E: Exception do ShowMessage(E.Message);
            end;
          end
          else
            raise Exception.Create(Format('Param #%d not assigned', [i]))
        end;
      SQL_DATE:  //timestamp
        begin
          if InputParamDateTime(Format('%d of %d', [i + 1,dmib.qryISql.ParamCount]),
            Dmib.qryISql.ParamSQLTypeDesc(i), isNull, ParaDate) then
          begin
            try
              Dmib.qryISql.ParamAsDateTime(i, ParaDate);
              FParamValue[i] := DateTimeToStr(ParaDate);
            except
              on E: Exception do ShowMessage(E.Message);
            end;
          end
          else
            raise Exception.Create(Format('Param #%d not assigned', [i]))
        end;
    end;
  end;
end;


//------------------------------------------------------------------------------

procedure TfrmBrowser.FetchFieldsGrid;
var
  i: integer;
begin
  sgFields.RowCount := Dmib.qryISql.FieldCount + 1;
  sgFields.ColCount := 9;
  sgFields.DefaultRowHeight := sgFields.Canvas.TextHeight('X') + ROW_H ;

  sgFields.Cells[0,0] := 'Alias';
  sgFields.Cells[1,0] := 'Relation';
  sgFields.Cells[2,0] := 'Field';
  sgFields.Cells[3,0] := 'Ower';
  sgFields.Cells[4,0] := 'Type';
  sgFields.Cells[5,0] := 'Sql type';
  sgFields.Cells[6,0] := 'Size(bytes)';
  sgFields.Cells[7,0] := 'Subtype';
  sgFields.Cells[8,0] := 'Scale';

  for i := 0 to Dmib.qryISql.FieldCount - 1 do
  begin
    sgFields.Cells[0,i + 1] := dmib.qryISql.FieldName(i);
    if (sgFields.ColWidths[0]) < (sgFields.Canvas.TextWidth(sgFields.Cells[0,i + 1]) + 4) then
      sgFields.ColWidths[0] := sgFields.Canvas.TextWidth(sgFields.Cells[0,i + 1]) + 4;
    sgFields.Cells[1,i + 1] := dmib.qryISql.FieldTableName(i);
    if (sgFields.ColWidths[1]) < (sgFields.Canvas.TextWidth(sgFields.Cells[1,i + 1]) + 4) then
      sgFields.ColWidths[1] := sgFields.Canvas.TextWidth(sgFields.Cells[1,i + 1]) + 4;
    sgFields.Cells[2,i + 1] := dmib.qryISql.FieldRealName(i);
    if (sgFields.ColWidths[2]) < (sgFields.Canvas.TextWidth(sgFields.Cells[2,i + 1]) + 4) then
      sgFields.ColWidths[2] := sgFields.Canvas.TextWidth(sgFields.Cells[2,i + 1]) + 4;

    sgFields.Cells[3,i + 1] := dmib.qryISql.FieldTableOwerName(i);
    if (sgFields.ColWidths[3]) < (sgFields.Canvas.TextWidth(sgFields.Cells[3,i + 1]) + 4) then
      sgFields.ColWidths[3] := sgFields.Canvas.TextWidth(sgFields.Cells[3,i + 1]) + 4;

    sgFields.Cells[4,i + 1] := TypeDesc(dmib.qryISql.FieldType(i));
    if (sgFields.ColWidths[4]) < (sgFields.Canvas.TextWidth(sgFields.Cells[4,i + 1]) + 4) then
      sgFields.ColWidths[4] := sgFields.Canvas.TextWidth(sgFields.Cells[4,i + 1]) + 4;

    sgFields.Cells[5,i + 1] := dmib.qryISql.FieldSQLTypeDesc(i);
    if (sgFields.ColWidths[5]) < (sgFields.Canvas.TextWidth(sgFields.Cells[5,i + 1]) + 4) then
      sgFields.ColWidths[5] := sgFields.Canvas.TextWidth(sgFields.Cells[5,i + 1]) + 4;

    sgFields.Cells[6,i + 1] := IntToStr(dmib.qryISql.FieldSize(i));
    if (sgFields.ColWidths[6]) < (sgFields.Canvas.TextWidth(sgFields.Cells[6,i + 1]) + 4) then
      sgFields.ColWidths[6] := sgFields.Canvas.TextWidth(sgFields.Cells[6,i + 1]) + 4;

    sgFields.Cells[7,i + 1] := IntToStr(dmib.qryISql.FieldSubType(i));
    if (sgFields.ColWidths[7]) < (sgFields.Canvas.TextWidth(sgFields.Cells[7,i + 1]) + 4) then
      sgFields.ColWidths[7] := sgFields.Canvas.TextWidth(sgFields.Cells[7,i + 1]) + 4;

    sgFields.Cells[8,i + 1] := IntToStr(dmib.qryISql.FieldScale(i));
    if (sgFields.ColWidths[8]) < (sgFields.Canvas.TextWidth(sgFields.Cells[8,i + 1]) + 4) then
      sgFields.ColWidths[8] := sgFields.Canvas.TextWidth(sgFields.Cells[8,i + 1]) + 4;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.FetchParamGrid;
var
  i: integer;
begin
  sgParams.ColCount := 5;
  sgParams.RowCount := dmib.qryISql.ParamCount + 1;
  sgParams.DefaultRowHeight := sgParams.Canvas.TextHeight('X') + ROW_H;
  sgParams.Cells[0,0] := 'Par. #';
  sgParams.Cells[1,0] := 'Value';
  sgParams.Cells[2,0] := 'Type';
  sgParams.Cells[3,0] := 'Not null';
  for i := 0 to dmib.qryISql.ParamCount - 1 do
  begin
    sgParams.Cells[0,i + 1] := IntToStr(i);
    sgParams.Cells[1,i + 1] := '';
    sgParams.Cells[2,i + 1] := dmib.qryISql.ParamSQLTypeDesc(i);
    if dmib.qryISql.ParamIsNullable(i) then
    begin
      //ShowMessage('null');
      sgParams.Cells[3,i + 1] := 'not null';
    end;
  end;
end;

//------------------------------------------------------------------------------

function TfrmBrowser.AbjustColWidth(const ACol: integer): integer;
var
  wn, wt: integer;
begin
  wn := sgGrid.Canvas.TextWidth(dmIb.qryISql.FieldName(ACol));
  case DmIb.qryISql.FieldType(ACol) of
    SQL_SHORT:
      wt := sgGrid.Canvas.TextWidth('-32768.');
    SQL_LONG:
      wt := sgGrid.Canvas.TextWidth('-2147483648.');
    SQL_INT64,
    SQL_FLOAT,
    SQL_D_FLOAT,
    SQL_DOUBLE:
      wt := sgGrid.Canvas.TextWidth(StringOfChar('9', 20));
    SQL_VARYING,
    SQL_TEXT:
      begin
        if DmIb.qryISql.FieldRealName(ACol) = 'DB_KEY' then
          wt := sgGrid.Canvas.TextWidth(StringOfChar('X',
            Dmib.qryISql.FieldSize(ACol) * 2))
        else if Dmib.qryISql.FieldSize(ACol) < 70 then
          wt := sgGrid.Canvas.TextWidth(StringOfChar('X', DmIb.qryISql.FieldSize(ACol)))
        else
          wt := sgGrid.Canvas.TextWidth(StringOfChar('X', 70));
      end;
    SQL_BLOB:
      wt := sgGrid.Canvas.TextWidth('(BLOB)');
    SQL_ARRAY:
      wt := sgGrid.Canvas.TextWidth('(ARRAY)');
    SQL_TIMESTAMP:
      wt := sgGrid.Canvas.TextWidth(DateTimeToStr(now));
    SQL_TYPE_TIME:
      wt := sgGrid.Canvas.TextWidth(TimeToStr(now));
    SQL_TYPE_DATE:
      wt := sgGrid.Canvas.TextWidth(DateToStr(now));
    else
      wt := 100;
  end;
  Result := ifthen(wt > wn, wt, wn) + 2;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.AddtoHistory(const AStm: string);
begin
  if FHistory.Count = 0 then
  begin
    FHistory.Add(AStm);
    FHistoryIDX := FHistory.Count;
    aPrevious.Enabled := True;
    aNext.Enabled := False;
  end
  else
  begin
    if FHistory.IndexOf(AStm) = -1 then
      FHistory.Add(AStm);
    FHistoryIDX := FHistory.Count;
    aPrevious.Enabled := True;
    aNext.Enabled := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.ShowBuffer;
begin
  nbMain.PageIndex := 0 ;
  if not mBuffer.Visible then
  begin
    lvValues.Visible := False;
    mBuffer.Align := alClient;
    mBuffer.Visible := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.LoadTvDb;
var
  nDb, nObj, nItem, nDepend, nPriv, nTrigTable, nTrigTableItem: TTreeNode;
  i, it: integer;
begin
  try
    Screen.Cursor := crSQLWait;
    LoadLists;
    ClearTvDb;
    tvDb.Items.BeginUpdate;
    if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
    nDb := tvDb.Items.Add(nil, FCurrentAlias);
    nDb.Data := TNodeDesc.Create(CNT_DATABASE, '', 'Database alias::' + FCurrentAlias);
    ndb.SelectedIndex := BMP_DATABASE;
    nDb.ImageIndex := BMP_DATABASE;
    // Add Domains
    nObj := tvDb.Items.AddChild(nDb, Format(CDOMAINS + ' (%d)', [FDomainList.Count]));
    nObj.SelectedIndex := BMP_DOMAIN;
    nObj.ImageIndex := BMP_DOMAIN;
    nObj.Data := TNodeDesc.Create(CNT_DOMAINS, '', 'DOMAINS');
    for i := 0 to FDomainList.Count - 1 do
    begin
      nItem := tvDb.Items.AddChild(nObj, FDomainList.Strings[i]);
      nItem.SelectedIndex := BMP_DOMAIN;
      nItem.ImageIndex := BMP_DOMAIN;
      nItem.Data := TNodeDesc.Create(CNT_DOMAIN, FDomainList.Strings[i],
        'DOMAIN::' + FDomainList.Strings[i]);
    end;
    // Add Tables
    nObj := tvDb.Items.AddChild(nDb, Format(CTABLES + ' (%d)', [FTableList.Count]));
    nObj.SelectedIndex := BMP_TABLE;
    nObj.ImageIndex := BMP_TABLE;
    nObj.Data := TNodeDesc.Create(CNT_TABLES, '', 'TABLES');
    dmib.SynSqlSyn1.TableNames.Clear;
    for i := 0 to FTableList.Count - 1 do
    begin
      nItem := tvDb.Items.AddChild(nObj, FTableList.Strings[i]);
      dmib.SynSqlSyn1.TableNames.Add(FTableList.Strings[i]);
      nItem.ImageIndex := BMP_TABLE;
      nItem.SelectedIndex := BMP_TABLE;
      nItem.Data := TNodeDesc.Create(CNT_TABLE, FTableList.Strings[i],
        'TABLE::' + FTableList.Strings[i]);
      nTrigTable := tvDb.Items.AddChild(nItem, CTRIGGERS);

      nTrigTable.Data := TNodeDesc.Create(CNT_TRIGGERSINTABLE, FTableList.Strings[i],
        'TABLE::' + FTableList.Strings[i] + '::[Triggers]');
      nTrigTable.ImageIndex := BMP_TRIGGER;
      nTrigTable.SelectedIndex := BMP_TRIGGER;
      for it := 0 to dmib.IBMeta.TriggersInTable(FTableList.Strings[i]).Count - 1 do
      begin
        nTrigTableItem := tvDb.Items.AddChild(nTrigTable,
          dmib.IBMeta.TriggersInTable(FTableList.Strings[i]).Strings[it]);
        nTrigTableItem.ImageIndex := BMP_TRIGGER;
        nTrigTableItem.SelectedIndex := BMP_TRIGGER;
        nTrigTableItem.Data := TNodeDesc.Create(CNT_TRIGGER,
          dmib.IBMeta.TriggersInTable(FTableList.Strings[i]).Strings[it],
          'TABLE::' + dmib.IBmeta.tables.Strings[i] + '::[Trigger]::' +
          dmib.IBMeta.TriggersInTable(FTableList.Strings[i]).Strings[it]);
      end;
      nDepend := tvDb.Items.AddChild(nItem, CDEP);
      nDepend.ImageIndex := BMP_DEP;
      nDepend.SelectedIndex := BMP_DEP;
      nDepend.Data := TNodeDesc.Create(CNT_DEP, FTableList.Strings[i],
        'TABLE::' + FTableList.Strings[i] + '[Dependencies]');
      nPriv := tvDb.Items.AddChild(nItem, CPRIV);
      nPriv.ImageIndex := BMP_PRIV;
      nPriv.SelectedIndex := BMP_PRIV;
      nPriv.Data := TNodeDesc.Create(CNT_PRIV, FTableList.Strings[i],
        'TABLE::' + FTableList.Strings[i] + '[Privileges]');
    end;
    // views
    nObj := tvDb.Items.AddChild(nDb, Format(CVIEWS + ' (%d)', [FViewList.Count]));
    nObj.ImageIndex := BMP_VIEW;
    nObj.SelectedIndex := BMP_VIEW;
    nObj.Data := TNodeDesc.Create(CNT_VIEWS, '', 'VIEWS');
    for i := 0 to FViewList.Count - 1 do
    begin
      nItem := tvDb.Items.AddChild(nObj, FViewList.Strings[i]);
      dmib.SynSqlSyn1.TableNames.Add(FViewList.Strings[i]);
      nItem.ImageIndex := BMP_VIEW;
      nItem.SelectedIndex := BMP_VIEW;
      nItem.Data := TNodeDesc.Create(CNT_VIEW, FViewList.Strings[i],
        'VIEW::' + FViewList.Strings[i]);
      nDepend := tvDb.Items.AddChild(nItem, CDEP);
      nDepend.ImageIndex := BMP_DEP;
      nDepend.SelectedIndex := BMP_DEP;
      nDepend.Data := TNodeDesc.Create(CNT_DEP, FViewList.Strings[i],
        'VIEW::' + FViewList.Strings[i] + '[Dependencies]');
      nPriv := tvDb.Items.AddChild(nItem, CPRIV);
      nPriv.ImageIndex := BMP_PRIV;
      nPriv.SelectedIndex := BMP_PRIV;
      nPriv.Data := TNodeDesc.Create(CNT_PRIV, FViewList.Strings[i],
        'VIEW::' + FViewList.Strings[i] + '[Privileges]');
    end;
    //Procedures
    nObj := tvDb.Items.AddChild(nDb, Format(CPROCEDURES + ' (%d)', [FProcList.Count]));
    nObj.ImageIndex := BMP_PROCEDURE;
    nObj.SelectedIndex := BMP_PROCEDURE;
    nObj.Data := TNodeDesc.Create(CNT_PROCEDURES, '', 'PROCEDURES');
    for i := 0 to FProcList.Count - 1 do
    begin
      nItem := tvDb.Items.AddChild(nObj, FProcList.Strings[i]);
      nItem.ImageIndex := BMP_PROCEDURE;
      nItem.SelectedIndex := BMP_PROCEDURE;
      nItem.Data := TNodeDesc.Create(CNT_PROCEDURE, FProcList.Strings[i],
        'PROCEDURE::' + FProcList.Strings[i]);
      nDepend := tvDb.Items.AddChild(nItem, CDEP);
      nDepend.ImageIndex := BMP_DEP;
      nDepend.SelectedIndex := BMP_DEP;
      nDepend.Data := TNodeDesc.Create(CNT_DEP, FProcList.Strings[i],
        'PROCEDURE::' + FProcList.Strings[i] + '[Dependencies]');
      nPriv := tvDb.Items.AddChild(nItem, CPRIV);
      nPriv.ImageIndex := BMP_PRIV;
      nPriv.SelectedIndex := BMP_PRIV;
      nPriv.Data := TNodeDesc.Create(CNT_PRIV, FProcList.Strings[i],
        'PROCEDURE::' + FProcList.Strings[i] + '[Privileges]');
    end;
    //Triggers
    nObj := tvDb.Items.AddChild(nDb, Format(CTRIGGERS + ' (%d)', [FTriggerList.Count]));
    nObj.ImageIndex := BMP_TRIGGER;
    nObj.SelectedIndex := BMP_TRIGGER;
    nObj.Data := TNodeDesc.Create(CNT_TRIGGERS, '', 'TRIGGERS');
    for i := 0 to FTriggerList.Count - 1 do
    begin
      nItem := tvDb.Items.AddChild(nObj, FTriggerList.Strings[i]);
      nItem.ImageIndex := BMP_TRIGGER;
      nItem.SelectedIndex := BMP_TRIGGER;
      nItem.Data := TNodeDesc.Create(CNT_TRIGGER, FTriggerList.Strings[i],
        'TRIGGER::' + FTriggerList.Strings[i]);
      nDepend := tvDb.Items.AddChild(nItem, CDEP);
      nDepend.ImageIndex := BMP_DEP;
      nDepend.SelectedIndex := BMP_DEP;
      nDepend.Data := TNodeDesc.Create(CNT_DEP, FTriggerList.Strings[i],
        'TRIGGER::' + FTriggerList.Strings[i] + '[Dependencies]');
      nPriv := tvDb.Items.AddChild(nItem, CPRIV);
      nPriv.ImageIndex := BMP_PRIV;
      nPriv.SelectedIndex := BMP_PRIV;
      nPriv.Data := TNodeDesc.Create(CNT_PRIV, FTriggerList.Strings[i],
        'TRIGGER::' + FTriggerList.Strings[i] + '[Privileges]');
    end;
    //Generators
    nObj := tvDb.Items.AddChild(nDb, Format(CGENERATORS + ' (%d)', [FGeneratorList.Count]));
    nObj.ImageIndex := BMP_GENERATOR;
    nObj.SelectedIndex := BMP_GENERATOR;
    nObj.Data := TNodeDesc.Create(CNT_GENERATORS, '', 'GENERATORS');
    for i := 0 to FGeneratorList.Count - 1 do
    begin
      nItem := tvDb.Items.AddChild(nObj, FGeneratorList.Strings[i]);
      nItem.ImageIndex := BMP_GENERATOR;
      nItem.SelectedIndex := BMP_GENERATOR;
      nItem.Data := TNodeDesc.Create(CNT_GENERATOR, FGeneratorList.Strings[i],
        'GENERATOR::' + FGeneratorList.Strings[i]);
    end;
    //UDFS
    nObj := tvDb.Items.AddChild(nDb, Format(CUDFS + ' (%d)', [FUdfList.Count]));
    nObj.ImageIndex := BMP_UDF;
    nObj.SelectedIndex := BMP_UDF;
    nObj.Data := TNodeDesc.Create(CNT_UDFS, '', 'UDFS');
    for i := 0 to FUdfList.Count - 1 do
    begin
      nItem := tvDb.Items.AddChild(nObj, FUdfList.Strings[i]);
      nItem.ImageIndex := BMP_UDF;
      nItem.SelectedIndex := BMP_UDF;
      nItem.Data := TNodeDesc.Create(CNT_UDF, FUdfList.Strings[i],
        'UDF::' + FUdfList.Strings[i]);
    end;
    // Exceptions
    nObj := tvDb.Items.AddChild(nDb, Format(CEXCEPTIONS + ' (%d)', [FExceptionList.Count]));
    nObj.ImageIndex := BMP_EXCEPTION;
    nObj.SelectedIndex := BMP_EXCEPTION;
    nObj.Data := TNodeDesc.Create(CNT_EXCEPTIONS, '', 'EXCEPTIONS');
    for i := 0 to FExceptionList.Count - 1 do
    begin
      nItem := tvDb.Items.AddChild(nObj, FExceptionList.Strings[i]);
      nItem.ImageIndex := BMP_EXCEPTION;
      nItem.SelectedIndex := BMP_EXCEPTION;
      nItem.Data := TNodeDesc.Create(CNT_EXCEPTION, FExceptionList.Strings[i],
        'EXCEPTION::' + FExceptionList.Strings[i]);
      nDepend := tvDb.Items.AddChild(nItem, CDEP);
      nDepend.ImageIndex := BMP_DEP;
      nDepend.SelectedIndex := BMP_DEP;
      nDepend.Data := TNodeDesc.Create(CNT_DEP, FExceptionList.Strings[i],
        'EXCEPTION::' + FExceptionList.Strings[i] + '[Privileges]');
    end;
    // Roles
    nObj := tvDb.Items.AddChild(nDb, Format(CROLES + ' (%d)', [FRoleList.Count]));
    nObj.ImageIndex := BMP_ROLE;
    nObj.SelectedIndex := BMP_ROLE;
    nObj.Data := TNodeDesc.Create(CNT_ROLES, '', 'ROLES');
    for i := 0 to FRoleList.Count - 1 do
    begin
      nItem := tvDb.Items.AddChild(nObj, FRoleList.Strings[i]);
      nItem.ImageIndex := BMP_ROLE;
      nItem.SelectedIndex := BMP_ROLE;
      nItem.Data := TNodeDesc.Create(CNT_ROLE, FRoleList.Strings[i],
        'ROLE::' + FRoleList.Strings[i]);
      nPriv := tvDb.Items.AddChild(nItem, CPRIV);
      nPriv.ImageIndex := BMP_PRIV;
      nPriv.SelectedIndex := BMP_PRIV;
      nPriv.Data := TNodeDesc.Create(CNT_PRIV, FRoleList.Strings[i],
        'ROLE::' + FRoleList.Strings[i] + '[Privileges]');
    end;

    if FsConfig.show_system_objs then
    begin
      //system tables
      nObj := tvDb.Items.AddChild(nDb, Format(CSYSTEMTABLES + ' (%d)',
        [FSysTableList.Count]));
      nObj.ImageIndex := BMP_SYSTEMTABLE;
      nObj.SelectedIndex := BMP_SYSTEMTABLE;
      nObj.Data := TNodeDesc.Create(CNT_SYSTABLES, '', 'SYSTEM_TABLES');
      for i := 0 to FSysTableList.Count - 1 do
      begin
        nItem := tvDb.Items.AddChild(nObj, FSysTableList.Strings[i]);
        nItem.ImageIndex := BMP_SYSTEMTABLE;
        nItem.SelectedIndex := BMP_SYSTEMTABLE;
        nItem.Data := TNodeDesc.Create(CNT_SYSTABLE, FSysTableList.Strings[i],
          'SYSTEM_TABLE::' + FSysTableList.Strings[i]);
      end;
      // system Triggers
      nObj := tvDb.Items.AddChild(nDb, Format(CSYSTEMTRIGGERS + ' (%d)',
        [FSysTriggerList.Count]));
      nObj.ImageIndex := BMP_SYSTEMTRIGGER;
      nObj.SelectedIndex := BMP_SYSTEMTRIGGER;
      nObj.Data := TNodeDesc.Create(CNT_SYSTRIGGERS, '', 'SYSTEM_TRIGGERS');
      for i := 0 to FSysTriggerList.Count - 1 do
      begin
        nItem := tvDb.Items.AddChild(nObj, FSysTriggerList.Strings[i]);
        nItem.ImageIndex := BMP_SYSTEMTRIGGER;
        nItem.SelectedIndex := BMP_SYSTEMTRIGGER;
        nItem.Data := TNodeDesc.Create(CNT_SYSTRIGGER, FSysTriggerList.Strings[i],
          'SYSTEM_TRIGGERS::' + FSysTriggerList.Strings[i]);
      end;
    end;
    nDb.Expand(False);
    sbTvDb.Panels.Items[0].Text := Format('%d: items',[tvDb.Items.Count]);
  finally
    Screen.Cursor := crDefault;
    tvDb.Items.EndUpdate;
    if dmib.trBrowser.InTransaction then dmib.trBrowser.RollBack;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.ClearTvDB;
var
  i: integer;
begin

  tvDb.Items.BeginUpdate;
  try
      for i := 0 to tvDb.Items.Count -1 do
        if Assigned(tvDB.Items[i].Data) then
        begin
          TNodeDesc(tvDB.Items[i].Data).Free;
          tvDB.Items[i].Data := nil;
        end;
        
      tvDb.Items.Clear;
      {$ifdef UNIX}
      if FNeedRefresh then
         ShowMessage('Refresh Ok');
      {$endif}
  finally
    tvDb.Items.EndUpdate;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.LoadLists;
begin
  FDomainList.Assign(dmib.IBMeta.Domains);
  FDomainList.Sort;
  FTableList.Assign(dmib.IBMeta.Tables);
  FtableList.Sort;
  FViewList.Assign(dmib.IBMeta.Views);
  FViewList.Sort;
  FProcList.Assign(dmib.IBMeta.Procedures);
  FProcList.Sort;
  FTriggerList.Assign(dmib.IBMeta.Triggers);
  FTriggerList.Sort;
  FGeneratorList.Assign(dmib.IBMeta.Generators);
  FGeneratorList.Sort;
  FUdfList.Assign(dmib.IBMeta.UDFs);
  FUdfList.Sort;
  FExceptionList.Assign(dmib.IBMeta.Exceptions);
  FExceptionList.Sort;
  FRoleList.Assign(dmib.IBMeta.Roles);
  FRoleList.Sort;
  if FSConfig.show_system_objs then
  begin
    FSysTableList.Assign(dmib.IBMeta.SystemTables);
    FSySTableLIst.Sort;
    FSysTriggerList.Assign(dmib.IBMeta.SystemTriggers);
    FSysTriggerList.Sort;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.TreeViewEvents(ANode: TTreeNode);
var
  temp, obj_Name: string;
begin
  if ANode.Data = nil then exit;
  lTitle.Caption := TNodeDesc(ANode.Data).ObjDesc;
  obj_name := TNodeDesc(ANode.Data).ObjName;
  if mBuffer.Highlighter = nil then mBuffer.Highlighter := Dmib.SynSQLSyn1;
  case TNodeDesc(ANode.Data).Nodetype of
    CNT_DATABASE:
      begin
        ShowValues;
        ShowDataBaseItems;
      end;
    CNT_DOMAINS:
      begin
        ShowValues;
        //mBuffer.Lines.Clear;
        //mBuffer.Lines.Assign(dmib.IBMeta.Domains);
        ShowListObject(CNT_DOMAINS);
      end;
    CNT_DOMAIN:
      begin
        try
          ShowBuffer;
          mBuffer.Lines.BeginUpdate;
          mBuffer.Lines.Clear;
          mBuffer.Lines.Text := dmib.IBmeta.DomainSource(obj_name);
        finally
          mBuffer.Lines.EndUpdate;
        end;
      end;
    CNT_TABLES:
      begin
        //ShowBuffer;
        //mBuffer.Lines.Clear;
        //mBuffer.Lines.Assign(dmib.IBMeta.Tables);
        ShowValues;
        ShowListObject(CNT_TABLES);
      end;
    CNT_TABLE,CNT_SYSTABLE:
      begin
        try
          ShowBuffer;
          mBuffer.Lines.BeginUpdate;
          mBuffer.Lines.Clear;
          mBuffer.Lines.Text := DMIB.IBmeta.TableSource(obj_name);
          temp := dmib.IBmeta.PrimaryKeyConstraintSource(obj_name);
          if temp <> '' then
          begin
            mBuffer.Lines.Add(' ');
            mBuffer.Lines.Add('/* Primary key */');
            mBuffer.Lines.Add('');
            mBuffer.Lines.Text := mBuffer.Lines.Text + temp;
          end;
          temp := dmib.IBmeta.ForeignKeyConstraintSource(obj_name);
          if temp <> '' then
          begin
            mBuffer.Lines.Add(' ');
            mBuffer.Lines.Add('/* Foreign key(s) */');
            mBuffer.Lines.Add('');
            mBuffer.Lines.Text := mBuffer.Lines.Text + temp;
          end;
          temp := dmib.IBmeta.CheckConstraintSource(obj_name);
          if temp <> '' then
          begin
            mBuffer.Lines.Add(' ');
            mBuffer.Lines.Add('/* Check Constraints */');
            mBuffer.Lines.Add('');
            mBuffer.Lines.Text := mBuffer.Lines.Text + temp;
          end;
          temp := dmib.IBmeta.UniqueConstraintSource(obj_name);
          if temp <> '' then
          begin
            mBuffer.Lines.Add(' ');
            mBuffer.Lines.Add('/* Unique Constraints */');
            mBuffer.Lines.Add('');
            mBuffer.Lines.Text := mBuffer.Lines.Text + temp;
          end;
          temp := dmib.IBmeta.IndexSource(obj_name);
          if temp <> '' then
          begin
            mBuffer.Lines.Add(' ');
            mBuffer.Lines.Add('/* Indices */');
            mBuffer.Lines.Add('');
            mBuffer.Lines.Text := mBuffer.Lines.Text + temp;
          end;
        finally
          mBuffer.Lines.EndUpdate;
        end;  // end try
      end;
    CNT_VIEWS:
      begin
        ShowValues;
        //mBuffer.Lines.Clear;
        ShowListObject(CNT_VIEWS);
      end;
    CNT_VIEW:
      begin
        try
          ShowBuffer;
          mBuffer.Lines.BeginUpdate;
          mBuffer.Lines.Clear;
          mBuffer.Lines.Text := dmib.IBmeta.ViewSource(obj_name);
        finally
          mBuffer.Lines.EndUpdate;
        end;
      end;
    CNT_PROCEDURES:
      begin
        ShowValues;
        //mBuffer.Lines.Clear;
        ShowListObject(CNT_PROCEDURES);
      end;
    CNT_PROCEDURE:
      begin
        try
          ShowBuffer;
          mBuffer.Lines.BeginUpdate;
          mBuffer.Lines.Clear;
          mBuffer.Lines.Text := dmib.IBmeta.ProcedureSource(obj_name);
        finally
          mBuffer.Lines.EndUpdate;
        end;
      end;
    CNT_TRIGGERS:
      begin
        ShowValues;
        //mBuffer.Lines.Clear;
        ShowListObject(CNT_TRIGGERS);
      end;
    CNT_TRIGGER,CNT_SYSTRIGGER:
      begin
        try
          ShowBuffer;
          mBuffer.Lines.BeginUpdate;
          mBuffer.Lines.Clear;
          mBuffer.Lines.Text := mBuffer.Lines.Text + dmib.IBmeta.TriggerSource(obj_name);;
        finally
          mBuffer.Lines.EndUpdate;
        end;
      end;
    CNT_GENERATORS:
      begin
        //ShowBuffer;
        ShowValues;
        //mBuffer.Lines.Clear;
        ShowListObject(CNT_GENERATORS);
      end;
    CNT_GENERATOR:
      begin
        try
          ShowBuffer;
          mBuffer.Lines.BeginUpdate;
          mBuffer.Lines.Clear;
          mBuffer.Lines.Add('CREATE GENERATOR ' + obj_name + ';');
          mBuffer.Lines.Add('');
          mBuffer.Lines.add('SET GENERATOR ' + obj_name + ' TO ' +
            dmib.IBmeta.GeneratorValue(obj_name) + ';');
        finally
          mBuffer.Lines.EndUpdate;
        end;
      end;
    CNT_UDFS:
      begin
        ShowValues;
        //mBuffer.Lines.Clear;
        ShowListObject(CNT_UDFS);
      end;
    CNT_UDF:
      begin
        try
          ShowBuffer;
          mBuffer.Lines.BeginUpdate;
          mBuffer.Lines.Clear;
          mBuffer.Lines.Text := dmib.IBmeta.UDFSource(obj_name);
        finally
          mBuffer.Lines.EndUpdate;
        end;
      end;
    CNT_EXCEPTIONS:
      begin
        ShowValues;
        //mBuffer.Lines.Clear;
        ShowListObject(CNT_EXCEPTIONS);
      end;
    CNT_EXCEPTION:
      begin
        try
          ShowBuffer;
          mBuffer.Lines.BeginUpdate;
          mBuffer.Lines.Clear;
          mBuffer.Lines.Text := dmib.IBmeta.ExceptionSource(obj_name);
        finally
          mBuffer.Lines.EndUpdate;
        end;
      end;
    CNT_ROLES:
      begin
        ShowValues;
        //mBuffer.Lines.Clear;
        ShowListObject(CNT_ROLES);
      end;
    CNT_ROLE:
      begin
        try
          ShowBuffer;
          mBuffer.Lines.BeginUpdate;
          mBuffer.Lines.Clear;
          mBuffer.Lines.Add('CREATE ROLE ' + obj_name);
        finally
          mBuffer.Lines.EndUpdate;
        end;
      end;
    CNT_PRIV:
      begin
        ShowBuffer;
        ShowPrivileges(obj_name);
        mBuffer.Highlighter := nil;
      end;
    CNT_DEP:
      begin
        ShowValues;
        ShowDependencies(obj_name);
      end;
    CNT_SYSTABLES:
      begin
        ShowValues;
        ShowListObject(CNT_SYSTABLES);
      end;
    CNT_SYSTRIGGERS:
      begin
        ShowValues;
        ShowListObject(CNT_SYSTRIGGERS);
      end;
    CNT_TRIGGERSINTABLE:
      begin
        ShowValues;
        ShowListObject(CNT_TRIGGERSINTABLE, obj_name);
      end;
    else  // else case
  end; // end case
  if dmib.trBrowser.InTransaction then dmib.trBrowser.RollBack;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.ShowValues;
begin
  nbMain.PageIndex := 0;
  if not lvValues.Visible then
  begin
    lvValues.Visible := True;
    lvValues.Align := alClient;
    mBuffer.Visible := False;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.ShowDatabaseItems;
var
  item: TListItem;
  column: TListColumn;
begin
  //lvValues.SmallImages:=nil;
  lvValues.Columns.Clear;
  column := lvValues.Columns.Add;
  column.Caption := 'Item';
  column.Width := 150;
  //column.AutoSize := True;
  column := lvValues.Columns.Add;
  column.Caption := 'Value';
  column.Width := 250;
  //column.AutoSize := True;
  try
    //lvValues.Items.BeginUpdate;
    lvValues.Items.Clear;
    item := lvValues.Items.Add;
    item.Caption := 'Server Version         ';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(dmib.dbMain.Version);
    item := lvValues.Items.Add;
    item.Caption := 'ODS Version';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(dmib.dbMain.ODSVersion));
    item := lvValues.Items.Add;
    item.Caption := 'ODS Minor Version';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(dmib.dbMain.ODSMinorVersion));
    item := lvValues.Items.Add;
    item.Caption := 'Base Level';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(dmib.dbMain.BaseLevel));
    item := lvValues.Items.Add;
    item.Caption := 'Implemetation Num';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(dmib.dbMain.ImplementationNumber));
    item := lvValues.Items.Add;
    item.Caption := 'Implemetation Class';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(dmib.dbMain.ImplementationClass));
    item := lvValues.Items.Add;
    item.Caption := 'Server type';
    item.ImageIndex := BMP_NONE;
    case Dmib.dbMain.ServerInfo of
      siSuperServer: item.SubItems.Add('Super Server');
      siClassicServer: item.SubItems.Add('Classic Server');
      else
        item.SubItems.Add(' ');
    end;
    item := lvValues.Items.Add;
    item.Caption := 'Connection type';
    item.ImageIndex := BMP_NONE;
    if Dmib.DbMain.IsLocalConnection then
      item.SubItems.Add('Local')
    else
      item.SubItems.Add('Remote');
    item := lvValues.Items.Add;
    item.Caption := 'Host name';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(Dmib.dbMain.DBSiteName);
    item := lvValues.Items.Add;
    item.Caption := 'File name';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(Dmib.dbMain.DBFileName);
    item := lvValues.Items.Add;
    item.Caption := 'Sql dialect';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(DmIb.dbMain.DBSQLDialect));
    item := lvValues.Items.Add;
    item.Caption := 'Page size';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(DmIb.dbMain.PageSize));
    item := lvValues.Items.Add;
    item.Caption := 'Current memory';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(DmIb.dbMain.CurrentMemory));
    item := lvValues.Items.Add;
    item.Caption := 'Max memory';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(DmIb.dbMain.MaxMemory));
    item := lvValues.Items.Add;
    item.Caption := 'Allocation';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(DmIb.dbMain.Allocation));
    item := lvValues.Items.Add;
    item.Caption := 'Num buffers';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(DmIb.dbMain.NumBuffers));
    item := lvValues.Items.Add;
    item.Caption := 'Sweep interval';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(DmIb.dbMain.SweepInterval));
    item := lvValues.Items.Add;
    item.Caption := 'Reads';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(DmIb.dbMain.Reads));
    item := lvValues.Items.Add;
    item.Caption := 'Writes';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(DmIb.dbMain.Writes));
    item := lvValues.Items.Add;
    item.Caption := 'Fetches';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(IntToStr(DmIb.dbMain.Fetches));
    item := lvValues.Items.Add;
    item.Caption := 'Default charset';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(DmIb.IBMeta.DefaultCharset);
    item := lvValues.Items.Add;
    item.Caption := 'Current user';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(dmib.IBMeta.User);
    item := LvValues.Items.Add;
    item.Caption := 'Client library';
    item.ImageIndex := BMP_NONE;
    item.SubItems.Add(ibase_h.DLL);
    if GetFbClientVersion = 7 then
    begin
      item := LvValues.Items.Add;
      item.Caption := 'Client Version';
      item.ImageIndex := BMP_NONE;
      item.SubItems.Add(DmIb.DbMain.ClientVersion);
      item := LvValues.Items.Add;
      item.Caption := 'Client Major Version';
      item.ImageIndex := BMP_NONE;
      item.SubItems.Add(IntToStr(DmIb.DbMain.ClientMajorVersion));
      item := LvValues.Items.Add;
      item.Caption := 'Client Minor Version';
      item.ImageIndex := BMP_NONE;
      item.SubItems.Add(IntToStr(DmIb.DbMain.ClientMinorVersion));
    end;
  finally
    //lvValues.Items.EndUpdate;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.ShowListObject(const AObjType: integer;
  const AOption: string = '');
var
  i: integer;
  Item: TListItem;
  Column: TListColumn;
begin
  lvValues.Columns.Clear;
  lvValues.Items.Clear;
  case AObjType of
    CNT_DOMAINS:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'Domains';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FDomainList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FDomainList.Strings[i];
          Item.ImageIndex := BMP_DOMAIN;
        end;
      end;
    CNT_TABLES:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'Tables';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FTableList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FTableList.Strings[i];
          Item.ImageIndex := BMP_TABLE;
        end;
      end;
    CNT_VIEWS:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'Views';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FViewList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FViewList.Strings[i];
          Item.ImageIndex := BMP_VIEW;
        end;
      end;
    CNT_PROCEDURES:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'Procedures';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FProcList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FProcList.Strings[i];
          Item.ImageIndex := BMP_PROCEDURE;
        end;
      end;
    CNT_TRIGGERS:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'Triggers';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FTriggerList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FTriggerList.Strings[i];
          Item.ImageIndex := BMP_TRIGGER;
        end;
      end;
    CNT_GENERATORS:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'Generators';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FGeneratorList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FGeneratorList.Strings[i];
          Item.ImageIndex := BMP_GENERATOR;
        end;
      end;
    CNT_UDFS:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'UDFS';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FUdfList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FUdfList.Strings[i];
          Item.ImageIndex := BMP_UDF;
        end;
      end;
    CNT_EXCEPTIONS:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'Exceptions';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FExceptionList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FExceptionList.Strings[i];
          Item.ImageIndex := BMP_UDF;
        end;
      end;
    CNT_ROLES:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'Roles';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FRoleList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FRoleList.Strings[i];
          Item.ImageIndex := BMP_ROLE;
        end;
      end;
    CNT_SYSTABLES:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'System Tables';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FSysTableList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FSysTableList.Strings[i];
          Item.ImageIndex := BMP_SYSTEMTABLE;
        end;
      end;
    CNT_SYSTRIGGERS:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'System Triggers';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to FSysTriggerList.Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := FSysTriggerList.Strings[i];
          Item.ImageIndex := BMP_SYSTEMTRIGGER;
        end;
      end;
    CNT_TRIGGERSINTABLE:
      begin
        Column := lvValues.Columns.Add;
        Column.Caption := 'Triggers';
        Column.Width := 150;
        //Column.AutoSize := True;
        for i := 0 to dmib.IBMeta.TriggersInTable(AOption).Count - 1 do
        begin
          Item := lvValues.Items.Add;
          Item.Caption := dmib.IBMeta.TriggersInTable(AOption).Strings[i];
          Item.ImageIndex := BMP_TRIGGER;
        end;
      end;
    else
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.ShowPrivileges(const ASqlOBj: string);
var
  listUsers: TStringList;
  i: integer;
  sTmp: string;
  function DesExtend(const ADesc: string): string;
  begin
    if ADesc = 'S' then
      Result := 'SELECT'
    else if ADesc = 'I' then
      Result := 'INSERT'
    else if ADesc = 'U' then
      Result := 'UPDATE'
    else if ADesc = 'D' then
      Result := 'DELETE'
    else if ADesc = 'R' then
      Result := 'REFERENCE'
    else if ADesc = 'X' then
      Result := 'EXECUTE'
    else if ADesc = 'M' then
      Result := 'MEMBER'
    else
      Result := ADesc;
  end;
const
  CFORMAT = #9 + '%-31s%-10s%-20s%';
begin
  listUsers := TStringList.Create;
  mBuffer.Lines.Clear;
  try
    if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
    with dmib do
    begin
      qryBrowser.SQL.Text :=
        'SELECT DISTINCT RDB$USER FROM RDB$USER_PRIVILEGES WHERE RDB$RELATION_NAME = ?';
      qryBrowser.Prepare;
      qryBrowser.ParamAsString(0,ASqlOBj);
      qryBrowser.ExecSQL;
      while not qryBrowser.EOF do
      begin
        ListUsers.Add(trim(qryBrowser.FieldAsString(0)));
        qryBrowser.Next;
      end;
      qryBrowser.UnPrepare;

      qryBrowser.SQL.Text := 'SELECT RDB$PRIVILEGE,RDB$GRANT_OPTION, RDB$USER_TYPE,' +
        'RDB$GRANTOR , RDB$FIELD_NAME ' +
        'FROM RDB$USER_PRIVILEGES ' +
        'WHERE RDB$RELATION_NAME = ? AND RDB$USER = ? ORDER BY RDB$PRIVILEGE';
      qryBrowser.Prepare;

      for i := 0 to ListUsers.Count - 1 do
      begin
        qryBrowser.ParamAsString(0,ASqlOBj);
        qryBrowser.ParamAsString(1,listUsers.Strings[i]);
        qryBrowser.ExecSQL;

        if qryBrowser.FieldAsLong(2) = 13 then
          sTmp := 'ROLE: ' + listUsers.Strings[i]
        else
          sTmp := 'USER: ' + listUsers.Strings[i];
        mBuffer.Lines.Add(sTmp);
        mBuffer.Lines.Add(Format(CFORMAT, ['GRANTOR', 'PRIVIL.', 'OPTION']));
        mBuffer.Lines.Add(#9 + StringOfChar('-', 61));
        while not qryBrowser.EOF do
        begin
          if (qryBrowser.FieldAsLong(1) = 1) then sTmp := 'WITH GRANT OPTION'
          else if (qryBrowser.FieldAsLong(1) = 2) then sTmp := 'WITH ADMIN OPTION'
          else
            sTmp := '';
          mBuffer.Lines.Add(format(CFORMAT,
            [trim(qryBrowser.FieldAsString(3)), DesExtend(Trim(qryBrowser.FieldAsString(0))), sTmp]));
          qryBrowser.Next;
        end;
        qryBrowser.Close;
        mBuffer.Lines.Add(' ');
      end;
      qryBrowser.UnPrepare;
    end;
  finally
    ListUsers.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TFrmBrowser.ShowDependencies(const ASqlObj: string);
  function DescType(t: integer): string;
  begin
    case t of
      0: Result := 'TABLE';
      1: Result := 'VIEW';
      2: Result := 'TRIGGER';
      3: Result := 'COMPUTED_FIELD';
      4: Result := 'VALIDATION';
      5: Result := 'PROCEDURE';
      6: Result := 'EXPRESSION_INDEX';
      7: Result := 'EXCEPTION';
      8: Result := 'USER';
      9: Result := 'FIELD';
      10: Result := 'INDEX';
      else
        Result := '';
    end;
  end;
  function ImageBmp(const ABmp: Integer): integer;
  begin
    case ABmp of
      0: Result := BMP_TABLE;     // TABLE
      1: Result := BMP_VIEW;       // VIEW
      2: Result := BMP_TRIGGER;    // TRIGGER
      3: Result := BMP_DOMAIN;     // COMPUTED_FIELD
      4: Result := -1;             // VALIDATION
      5: Result := BMP_PROCEDURE;  // PROCEDURE
      6: Result := -1;             // EXPRESSION_INDEX
      7: Result := BMP_EXCEPTION;  // EXCEPTION
      8: Result := -1;             // USER
      9: Result := BMP_DOMAIN;     // FIELD
      10: Result := -1;             // INDEX
      else
        Result := -1;
    end;
  end;
var
  item: TListItem;
  column: TListColumn;
begin
  lvValues.Columns.Clear;
  column := lvValues.Columns.Add;
  column.Caption := 'Type';
  column.Width := 150;
  //column.AutoSize := True;
  column := lvValues.Columns.Add;
  column.Caption := 'Object';
  column.Width := 150;
  //column.AutoSize := True;
  column := lvValues.Columns.Add;
  column.Caption := 'Fields';
  column.Width := 150;
  //column.AutoSize := True;

  if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
  with dmib do
  begin
    try
      //lvValues.Items.BeginUpdate;
      LvValues.Items.Clear;
      //mBuffer.Lines.Clear;
      qryBrowser.SQL.Text := 'select  RDB$DEPENDED_ON_NAME ,' +
        'RDB$FIELD_NAME,' +
        'RDB$DEPENDED_ON_TYPE ' +
        'from rdb$dependencies ' +
        'where rdb$dependent_name = ? ' +
        'ORDER BY RDB$DEPENDED_ON_NAME';
      qryBrowser.Prepare;
      qryBrowser.ParamAsString(0,ASqlObj);
      qryBrowser.ExecSQL;

      while not qryBrowser.EOF do
      begin
        item := LvValues.Items.Add;
        item.Caption := DescType(qryBrowser.FieldAsLong(2));
        item.ImageIndex := ImageBmp(qryBrowser.FieldAsLong(2));
        item.SubItems.Add(qryBrowser.FieldAsString(0));
        item.SubItems.Add(qryBrowser.FieldAsString(1));
        qryBrowser.Next;
      end;
      qryBrowser.UnPrepare;;
      qryBrowser.SQL.Text := 'SELECT RDB$DEPENDENT_NAME ,' +
        'RDB$FIELD_NAME,' +
        'RDB$DEPENDENT_TYPE ' +
        'from rdb$dependencies ' +
        'where rdb$depended_on_name = ? ' +
        'ORDER BY  RDB$DEPENDENT_NAME ';
      qryBrowser.Prepare;
      qryBrowser.ParamAsString(0,ASqlObj);
      qryBrowser.ExecSQL;

      while not qryBrowser.EOF do
      begin
        item := LvValues.Items.Add;
        item.Caption := DescType(qryBrowser.FieldAsLong(2));
        item.ImageIndex := ImageBmp(qryBrowser.FieldAsLong(2));
        item.SubItems.Add(qryBrowser.FieldAsString(0));
        item.SubItems.Add(qryBrowser.FieldAsString(1));
        qryBrowser.Next;
      end;
    finally
      //LvValues.Items.EndUpdate;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.SetOutputType(const AType: Integer);
begin
  case AType of
    1:
      begin
        sgGrid.Visible := False;
        ClearDataGrid;
        mGrid.Align := alClient;
        mGrid.Visible := True;
      end;
    else
      mGrid.Visible := False;
      mGrid.Lines.Clear;
      sgGrid.Align := alClient;
      sgGrid.Visible := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.ShowTableView(const ATableName: string);
var
  FrmTView: TfrmTableView;
begin
  FrmTView := TfrmTableView.Create(self);
  try
    FrmTView.TableName := ATableName;
    FrmTView.ShowModal;
  finally
    FrmTview.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.LoadFontColor;
var
  MyColor: TColor;
begin
  MyColor := mBuffer.Color;
  ReadConfigEdit(SECTION_FONT_BROWSER, mBuffer.Font, MyColor);
  mBuffer.Color := MyColor;
  MyColor := mSql.Color;
  ReadConfigEdit(SECTION_FONT_EDIT, mSql.Font, MyColor);
  mSql.Color := MyColor;
  MyColor := mGrid.Color;
  ReadConfigEdit(SECTION_FONT_TEXTGRID, mGrid.Font, MyColor);
  mGrid.Color := MyColor;
  ReadConfigSynEdit;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.ShowObjectDescription(const AType: Integer ; const ASqlObject: string);
var
  frmDesc: TfrmDescription;
begin
  frmDesc := TfrmDescription.Create(Self);
  try
    case AType of
      CNT_TABLE,CNT_VIEW,CNT_SYSTABLE:
        begin
          if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
          dmib.qryBrowser.SQL.Text := 'SELECT RDB$DESCRIPTION FROM RDB$RELATIONS WHERE RDB$RELATION_NAME = ?';
          dmib.qryBrowser.Prepare;
          dmib.qryBrowser.ParamAsString(0,ASqlObject);
          dmib.qryBrowser.ExecSQL;
          frmDesc.Caption := 'Description :: ' + ASqlObject;
          frmDesc.Text := dmib.qryBrowser.FieldAsString(0);
          dmib.qryBrowser.Close;
          if frmDesc.ShowModal = mrOk then
          begin
            if frmDesc.Text <> '' then
            begin
              dmib.qryBrowser.SQL.Text := 'UPDATE RDB$RELATIONS SET RDB$DESCRIPTION = ? WHERE RDB$RELATION_NAME = ?';
              dmib.qryBrowser.Prepare;
              dmib.qryBrowser.ParamAsString(0,frmDesc.Text);
              dmib.qryBrowser.ParamAsString(1,ASqlObject);
              dmib.qryBrowser.ExecSQL;
              dmib.qryBrowser.Close;
            end;
          end;
          dmib.trBrowser.Commit;
        end;

      CNT_DOMAIN:
        begin
          if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
          dmib.qryBrowser.SQL.Text := 'SELECT RDB$DESCRIPTION FROM RDB$FIELDS WHERE RDB$FIELD_NAME = ?';
          dmib.qryBrowser.Prepare;
          dmib.qryBrowser.ParamAsString(0,ASqlObject);
          dmib.qryBrowser.ExecSQL;
          frmDesc.Caption := 'Description :: ' + ASqlObject;
          frmDesc.Text := dmib.qryBrowser.FieldAsString(0);
          dmib.qryBrowser.Close;
          if frmDesc.ShowModal = mrOk then
          begin
            if frmDesc.Text <> '' then
            begin
              dmib.qryBrowser.SQL.Text := 'UPDATE RDB$FIELDS SET RDB$DESCRIPTION = ? WHERE RDB$FIELD_NAME = ?';
              dmib.qryBrowser.Prepare;
              dmib.qryBrowser.ParamAsString(0,frmDesc.Text);
              dmib.qryBrowser.ParamAsString(1,ASqlObject);
              dmib.qryBrowser.ExecSQL;
              dmib.qryBrowser.Close;
            end;
          end;
          dmib.trBrowser.Commit;
        end;

      CNT_PROCEDURE:
        begin
          if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
          dmib.qryBrowser.SQL.Text := 'SELECT RDB$DESCRIPTION FROM RDB$PROCEDURES WHERE RDB$PROCEDURE_NAME = ?';
          dmib.qryBrowser.Prepare;
          dmib.qryBrowser.ParamAsString(0,ASqlObject);
          dmib.qryBrowser.ExecSQL;
          frmDesc.Caption := 'Description :: ' + ASqlObject;
          frmDesc.Text := dmib.qryBrowser.FieldAsString(0);
          dmib.qryBrowser.Close;
          if frmDesc.ShowModal = mrOk then
          begin
            if frmDesc.Text <> '' then
            begin
              dmib.qryBrowser.SQL.Text := 'UPDATE RDB$PROCEDURES SET RDB$DESCRIPTION = ? WHERE RDB$PROCEDURE_NAME = ?';
              dmib.qryBrowser.Prepare;
              dmib.qryBrowser.ParamAsString(0,frmDesc.Text);
              dmib.qryBrowser.ParamAsString(1,ASqlObject);
              dmib.qryBrowser.ExecSQL;
              dmib.qryBrowser.Close;
            end;
          end;
          dmib.trBrowser.Commit;
        end;

      CNT_TRIGGER,CNT_SYSTRIGGER:
        begin
          if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
          dmib.qryBrowser.SQL.Text := 'SELECT RDB$DESCRIPTION FROM RDB$TRIGGERS WHERE RDB$TRIGGER_NAME = ?';
          dmib.qryBrowser.Prepare;
          dmib.qryBrowser.ParamAsString(0,ASqlObject);
          dmib.qryBrowser.ExecSQL;
          frmDesc.Caption := 'Description :: ' + ASqlObject;
          frmDesc.Text := dmib.qryBrowser.FieldAsString(0);
          dmib.qryBrowser.Close;
          if frmDesc.ShowModal = mrOk then
          begin
            if frmDesc.Text <> '' then
            begin
              dmib.qryBrowser.SQL.Text := 'UPDATE RDB$TRIGGER SET RDB$DESCRIPTION = ? WHERE RDB$TRIGGER_NAME = ?';
              dmib.qryBrowser.Prepare;
              dmib.qryBrowser.ParamAsString(0,frmDesc.Text);
              dmib.qryBrowser.ParamAsString(1,ASqlObject);
              dmib.qryBrowser.ExecSQL;
              dmib.qryBrowser.Close;
            end;
          end;
          dmib.trBrowser.Commit;
        end;

      CNT_UDF:
        begin
          if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
          dmib.qryBrowser.SQL.Text := 'SELECT RDB$DESCRIPTION FROM RDB$FUNCTIONS WHERE RDB$FUNCTION_NAME = ?';
          dmib.qryBrowser.Prepare;
          dmib.qryBrowser.ParamAsString(0,ASqlObject);
          dmib.qryBrowser.ExecSQL;
          frmDesc.Caption := 'Description :: ' + ASqlObject;
          frmDesc.Text := dmib.qryBrowser.FieldAsString(0);
          dmib.qryBrowser.Close;
          if frmDesc.ShowModal = mrOk then
          begin
            if frmDesc.Text <> '' then
            begin
              dmib.qryBrowser.SQL.Text := 'UPDATE RDB$FUNCTIONS SET RDB$DESCRIPTION = ? WHERE RDB$FUNCTION_NAME = ?';
              dmib.qryBrowser.Prepare;
              dmib.qryBrowser.ParamAsString(0,frmDesc.Text);
              dmib.qryBrowser.ParamAsString(1,ASqlObject);
              dmib.qryBrowser.ExecSQL;
              dmib.qryBrowser.Close;
            end;
          end;
          dmib.trBrowser.Commit;
        end;

      CNT_EXCEPTION:
        begin
          if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
          dmib.qryBrowser.SQL.Text := 'SELECT RDB$DESCRIPTION FROM RDB$EXCEPTIONS WHERE RDB$EXCEPTION_NAME = ?';
          dmib.qryBrowser.Prepare;
          dmib.qryBrowser.ParamAsString(0,ASqlObject);
          dmib.qryBrowser.ExecSQL;
          frmDesc.Caption := 'Description :: ' + ASqlObject;
          frmDesc.Text := dmib.qryBrowser.FieldAsString(0);
          dmib.qryBrowser.Close;
          if frmDesc.ShowModal = mrOk then
          begin
            if frmDesc.Text <> '' then
            begin
              dmib.qryBrowser.SQL.Text := 'UPDATE RDB$EXCEPTIONS SET RDB$DESCRIPTION = ? WHERE RDB$EXCEPTION_NAME = ?';
              dmib.qryBrowser.Prepare;
              dmib.qryBrowser.ParamAsString(0,frmDesc.Text);
              dmib.qryBrowser.ParamAsString(1,ASqlObject);
              dmib.qryBrowser.ExecSQL;
              dmib.qryBrowser.Close;
            end;
          end;
          dmib.trBrowser.Commit;
        end;

      CNT_ROLE:
        begin
          if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
          dmib.qryBrowser.SQL.Text := 'SELECT RDB$DESCRIPTION FROM RDB$ROLES WHERE RDB$ROLE_NAME = ?';
          dmib.qryBrowser.Prepare;
          dmib.qryBrowser.ParamAsString(0,ASqlObject);
          dmib.qryBrowser.ExecSQL;
          frmDesc.Caption := 'Description :: ' + ASqlObject;
          frmDesc.Text := dmib.qryBrowser.FieldAsString(0);
          dmib.qryBrowser.Close;
          if frmDesc.ShowModal = mrOk then
          begin
            if frmDesc.Text <> '' then
            begin
              dmib.qryBrowser.SQL.Text := 'UPDATE RDB$ROLES SET RDB$DESCRIPTION = ? WHERE RDB$ROLE_NAME = ?';
              dmib.qryBrowser.Prepare;
              dmib.qryBrowser.ParamAsString(0,frmDesc.Text);
              dmib.qryBrowser.ParamAsString(1,ASqlObject);
              dmib.qryBrowser.ExecSQL;
              dmib.qryBrowser.Close;
            end;
          end;
          dmib.trBrowser.Commit;
        end;
      else
    end;
  finally
    frmDesc.Free;
  end;
end;

//------------------------------------------------------------------------------
{Events procedure}

procedure TfrmBrowser.FormCreate(Sender: TObject);
begin
  FHIstory := TStringList.Create;
  FDomainList := TStringList.Create;
  FTableList := TStringList.Create;
  FViewList := TStringList.Create;
  FProcList := TStringList.Create;
  FTriggerList := TStringList.Create;
  FGeneratorList := TStringList.Create;
  FUdfList := TStringList.Create;
  FExceptionList := TStringList.Create;
  FRoleList := TStringList.Create;
  FSysTableList := TStringList.Create;
  FSysTriggerList := TStringList.Create;
  FHistoryIdx := 0;
  Caption := APP_TITLE + ' ' + APP_VERSION;
  FExecutedDDLstm := False;
  InitFileConfig;
  //ReadAliasNames;
  ReadConfigFile;
  DoAfterDisconnect;
  
  Self.Top := (Screen.Height - DEFAULT_HEIGHT) div 2;
  Self.Left := (Screen.Width - DEFAULT_WIDTH) div 2;
  Self.Height := DEFAULT_HEIGHT;
  Self.Width := DEFAULT_WIDTH;

  FsConfig.LoadFormPos(Self);
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aViewDataExecute(Sender: TObject);
begin
  if Assigned(tvDb.Selected) then
  begin
    if Assigned(TNodeDesc(TvDb.Selected.Data)) then
    begin
      if (TNodeDesc(TvDb.Selected.Data).NodeType = CNT_TABLE) or
         (TNodeDesc(TvDb.Selected.Data).NodeType = CNT_VIEW)  or
         (TNodeDesc(TvDb.Selected.Data).NodeType = CNT_SYSTABLE) then
        ShowTableView(TNodeDesc(TvDb.Selected.Data).ObjName);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aCreateDbExecute(Sender: TObject);
var
  frmCreate: TfrmCreateDB;
begin
  frmCreate := TfrmCreateDB.Create(self);
  try
    frmCreate.ShowModal;
  finally
    frmCreate.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aClearMessagesExecute(Sender: TObject);
begin
  try
    mMsg.Items.BeginUpdate;
    mMsg.Items.Clear;
  finally
    mMsg.Items.EndUpdate;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aExportToHtmlExecute(Sender: TObject);
var
  frmExpToHtml: TfrmExportToHtml;
begin
  frmExpToHtml := TfrmExportToHtml.Create(Self);
  try
    if Assigned(tvDB.Selected.Data) then
    begin
     if Assigned(tvDB.Selected.Data) then
     begin
       if (TNodeDesc(tvDB.Selected.Data).NodeType = CNT_TABLE) or
         (TNodeDesc(tvDB.Selected.Data).NodeType = CNT_VIEW) then
       begin
         frmExpToHtml.RelationName := TNodeDesc(tvDB.Selected.Data).ObjName;
         frmExpToHtml.ShowModal;
       end;
     end;
    end;
  finally
   frmExpToHtml.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aExportToSqlExecute(Sender: TObject);
begin
  if Assigned(tvDB.Selected.Data) then
    if TNodeDesc(tvDB.Selected.Data).NodeType = CNT_TABLE then
    begin
      sdSave.DefaultExt := 'sql';
      sdSave.Filter := 'Sql script (*.sql)|*.sql|Text (*.txt)|*.txt|Any(*.*)|*.*';
      sdSave.Title := 'Export table ::' + TNodeDesc(tvDB.Selected.Data).ObjName +
        ':: to sql script';
      if sdSave.Execute then   ;
         //ExportToSqlScipt(TNodeDesc(tvDB.Selected.Data).ObjName);
    end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aMbufferSelectAllExecute(Sender: TObject);
begin
  mBuffer.SelectAll;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aServiceMgrExecute(Sender: TObject);
var
  frmService: TfrmService;
begin
  frmService := TFrmService.Create(self);
  try
    frmService.ShowModal;
  finally
    frmService.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aShowAboutExecute(Sender: TObject);
begin
  fsabout.ShowAbout(APP_VERSION,'alessandro batisti');
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aShowOptionDescriptionExecute(Sender: TObject);
begin
   if Assigned(tvDB.Selected.Data) then
  begin
    if Assigned(tvDB.Selected.Data) then
    begin
      case TNodeDesc(tvDB.Selected.Data).Nodetype of
        CNT_DOMAIN:
          ShowObjectDescription(CNT_DOMAIN,TNodeDesc(tvDB.Selected.Data).ObjName);
        CNT_TABLE:
          ShowObjectDescription(CNT_TABLE,TNodeDesc(tvDB.Selected.Data).ObjName);
        CNT_VIEW:
          ShowObjectDescription(CNT_VIEW,TNodeDesc(tvDB.Selected.Data).ObjName);
        CNT_PROCEDURE:
          ShowObjectDescription(CNT_PROCEDURE,TNodeDesc(tvDB.Selected.Data).ObjName);
        CNT_TRIGGER:
          ShowObjectDescription(CNT_TRIGGER,TNodeDesc(tvDB.Selected.Data).ObjName);
        CNT_GENERATOR:
          ShowObjectDescription(CNT_GENERATOR,TNodeDesc(tvDB.Selected.Data).ObjName);
        CNT_UDF:
          ShowObjectDescription(CNT_UDF,TNodeDesc(tvDB.Selected.Data).ObjName);
        CNT_EXCEPTION:
          ShowObjectDescription(CNT_EXCEPTION,TNodeDesc(tvDB.Selected.Data).ObjName);
        CNT_ROLE:
          ShowObjectDescription(CNT_ROLE,TNodeDesc(tvDB.Selected.Data).ObjName);
        CNT_SYSTABLE:
          ShowObjectDescription(CNT_SYSTABLE,TNodeDesc(tvDB.Selected.Data).ObjName);
        CNT_SYSTRIGGER:
          ShowObjectDescription(CNT_SYSTRIGGER,TNodeDesc(tvDB.Selected.Data).ObjName);
        else
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aShowOptionsExecute(Sender: TObject);
var
  frmForm: TfrmOptions;
begin
  frmForm := TfrmOptions.Create(Self);
  try
    if frmForm.ShowModal = mrOk then
    begin
      dmib.qryISql.MaxFetch := FsConfig.max_fetch;
      dmib.IBMeta.SetTerm := FsConfig.show_set_term;
      SetOutputType(FsConfig.set_output_grid);
      RefreshStatusBar;
    end;
  finally
    frmForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aShowTextOptionsExecute(Sender: TObject);
var
  frmForm : TfrmTextOptions;
begin
  frmForm := TfrmTextOptions.Create(nil);
  try
    frmForm.FontDDL := mBuffer.Font;
    frmForm.ColorDDL := mBuffer.Color;
    frmForm.FontSQL := mSql.Font;
    frmForm.ColorSQL := mSql.Color;
    frmForm.FontTextGrid := mGrid.Font;
    frmForm.ColorTextGrid := mGrid.Color;
    if frmForm.ShowModal = mrOk then
    begin
      if frmForm.DDLChanged then
      begin
        mBuffer.Font := frmForm.FontDDL;
        mBuffer.Color := frmForm.ColorDDL;
        WriteConfigEdit(SECTION_FONT_BROWSER, mBuffer.Font, mBuffer.Color);
      end;
      if frmForm.SQLChanged then
      begin
        mSql.Font := frmForm.FontSQL;
        mSql.Color := frmForm.ColorSQL;
        WriteConfigEdit(SECTION_FONT_EDIT, mSql.Font, mSql.Color);
      end;
      if frmForm.TextGridChanged then
      begin
        mGrid.Font := frmForm.FontTextGrid;
        mGrid.Color := frmForm.ColorTextGrid;
        WriteConfigEdit(SECTION_FONT_TEXTGRID, mGrid.Font, mGrid.Color);
      end;
    end;
  finally
    frmForm.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aUsersExecute(Sender: TObject);
var
  frmUsers: TfrmUsers;
  pUser, pPassword: string;
  ShowLogin: boolean;
begin
  if Dmib.DbMain.Connected then
  begin
    pUser := DmIb.DbMain.User;
    pPassword := Dmib.DbMain.Password;
    //pRole := Dmib.DbMain.Role;
    ShowLogin := True;
  end
  else
    ShowLogin := fslogin.FbDbLogin('SecurDb', pUser, pPassword);

  frmUsers := TfrmUsers.Create(self, pUser, pPassword);
  try
    if ShowLogin then
      if frmUsers.TryFetchList then frmUsers.ShowModal;
  finally
    frmUsers.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if FCurrentAlias <> '' then
    fsconfig.SaveHistory(FcurrentAlias, FHistory);
  fsconfig.SaveFormPos(self);
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  frmDialogTran: TfrmDialogTran;
begin
  frmDialogTran := TfrmDialogTran.Create(self);
  try
    if Dmib.trISql.InTransaction then
      case frmDialogTran.ShowModal of
        mrYes:
          begin
            Dmib.trISql.Commit;
            CanClose := True;
          end;
        mrNo:
          begin
            dmib.trISql.RollBack;
            CanClose := True;
          end;
        mrCancel:
          CanClose := False;
      end;
  finally
    frmDialogTran.Free;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.FormDestroy(Sender: TObject);
begin
  FParamValue := nil;
  FColDesc := nil;
  FHistory.Free;
  FDomainList.Free;
  FTableList.Free;
  FViewList.Free;
  FProcList.Free;
  FTriggerList.Free;
  FGeneratorList.Free;
  FUdfList.Free;
  FExceptionList.Free;
  FRoleList.Free;
  FSysTableList.Free;
  FSysTriggerList.Free;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.FormShow(Sender: TObject);
begin
  LoadFontColor;
  dmib.qryISql.MaxFetch := FsConfig.max_fetch;
  dmib.IBMeta.SetTerm := FsConfig.show_set_term;
  SetOutputType(FsConfig.set_output_grid);
  mBuffer.Highlighter := dmib.SynSQLSyn1;
  mSql.Highlighter := dmib.SynSQLSyn1;
  mBuffer.Align := alClient;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aBackupDatabaseExecute(Sender: TObject);
begin
   fsbackup.DatabaseBackup(dmib.DbMain);
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aClearHistoryExecute(Sender: TObject);
begin
   if MessageDlg('Clear History :: ' + FCurrentAlias ,mtConfirmation,[mbYes, mbNo],0) = mrYes then
  begin
    FHistoryIdx := 0;
    aPrevious.Enabled := False;
    aNext.Enabled := False;
    FHistory.Clear;
    fsconfig.DeleteHistory(FCurrentAlias);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aCommitExecute(Sender: TObject);
begin
  try
    mMsg.Items.Add(' ');
    dmib.trISql.Commit;
    mMsg.Items.add(Format('Transaction commited. [%s]',[TimeToStr(Now)]));
    EndTr(True);
    mMsg.ItemIndex := mMsg.Items.Count -1 ;
    mMsg.ItemIndex := -1;
  except
    on E: EFBLError do
    begin
      mMsg.Items.Add(Format('Error in Transaction commit. [isc_error :%d]',[E.ISC_ErrorCode]));
      mMsg.Items.Text :=  mMsg.Items.Text + E.Message;
      mMsg.ItemIndex := mMsg.Items.Count -1 ;
      mMsg.ItemIndex := -1;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aDbConnectionsExecute(Sender: TObject);
var
  ConParams: TFsConnectionsParams;
begin
  ConParams.Alias := fsconfig.last_alias_connected;
  if not DbConnection(@ConParams) then Exit;
  
  if ConParams.Protocol = fsdbconnections.PROTOCOL_LOCAL then
    dmib.DbMain.Protocol := ptLocal
  else if ConParams.Protocol = fsdbconnections.PROTOCOL_TCP_IP then
  begin
    dmib.DbMain.Protocol := ptTcpIp;
    dmib.DbMain.Host := ConParams.Host;
  end
  else if ConParams.Protocol = fsdbconnections.PROTOCOL_NETBEUI then
  begin
    dmib.DbMain.Protocol := ptNetBeui;
    dmib.DbMain.Host := ConParams.Host;
  end;

  dmib.DbMain.TcpPort := ConParams.Port;
  dmib.DbMain.SQLDialect := ConParams.Dialect;
  dmib.DbMain.CharacterSet := ConParams.CharacterSet;
  dmib.DbMain.DBFile := ConParams.DBName;
  dmib.DbMain.User := ConParams.User;
  dmib.DbMain.Password := ConParams.Password;
  dmib.DbMain.Role := ConParams.Role;
  try
    dmib.dbMain.Connect;
    FCurrentAlias := ConParams.Alias;
    LoadtvDb;
    aDbConnections.Enabled := False;
    aDisconnect.Enabled := True;
    DoAfterConnect;
    fsconfig.last_alias_connected := ConParams.Alias;
    fsConfig.WriteConfigFile;
  except
     on E: EFBLError do
        ShowMessage(Format('Error Code : %d' ,[E.ISC_ErrorCode]) + NEW_LINE +
          Format('SQL Code : %d',[E.SqlCode]) +
          NEW_LINE + E.Message);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aDisconnectExecute(Sender: TObject);
var
  frmDialogTran: TfrmDialogTran;
begin
  frmDialogTran := TfrmDialogTran.Create(self);
  try
    if dmib.trISql.InTransaction then
      case frmDialogTran.ShowModal of
        mrYes:
          dmIb.trISql.Commit;
        mrNo:
          dmib.trISql.RollBack;
        mrCancel:
          exit;
      end;
  finally
    frmDialogTran.Free;
  end;
  
  dmIb.dbMain.Disconnect;
  FsConfig.SaveHistory(FCurrentAlias, FHistory);
  aDbConnections.Enabled := True;
  aDisconnect.Enabled := False;
  ClearTvDB;
  lTitle.Caption := '';
  mBuffer.Lines.Clear;
  ShowBuffer;
  DoAfterDisconnect;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aExecSqlExecute(Sender: TObject);
var
  stm: string;
begin
  try
    stm := Trim(mSql.Lines.Text);
    if stm = '' then
      ShowMessage('Empy Query')
    else
    begin
      Screen.Cursor := crSqlWait;
      //mMsg.Items.Clear;
      mMsg.Items.Add(' ');
      if not ExecuteSQL(stm, True) then
      begin
       AddToHistory(stm);
       RefreshStatusBar;
      end;
      mMsg.ItemIndex := mMsg.Items.Count -1 ;
      mMsg.ItemIndex := -1;
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aExecSqlScriptExecute(Sender: TObject);
var
  i: Integer;
  SqlError: Boolean;
  stm: string;
  SQLScript: TStringList;
  FParseError: Boolean;
begin
  FParseError := False;
  SqlError := True;
  FScriptStat.stm_count := 0;
  FScriptStat.ins_rows := 0;
  FScriptStat.del_rows := 0;
  FScriptStat.upg_rows := 0;
  FScriptStat.ddl_cmds := 0;
  FScriptStat.start_t := now;
  if trim(mSql.Text) = '' then
  begin
    ShowMessage('Empty query');
    Exit;
  end;
  SQLScript := TStringList.Create;
  try
    Screen.Cursor := crSqlWait;
    Script.SQLScript := mSql.Lines;
    Script.Reset;
    SQLScript.Clear;
    mMsg.Items.Add(Format('Start script. [%s]',[TimeToStr(Now)]));
    while not Script.EOF do
    begin
      stm := Script.Statement;
      if script.StatementType = stUnknow then
      begin
        FParseError := True;
        mMsg.Items.Add('ERROR : Statement Unknow.');
        mMsg.Items.Add('Statement :');
        mMsg.Items.Text :=   mMsg.Items.Text + stm;
        mMsg.Items.Add('Script stopped');
      end;
      if (Script.StatementType <> stSetTerm) and (script.StatementType <> stSelect) then
        SQLScript.Add(stm);
    end;

    if not FParseError then
    begin
      for i := 0 to SQLScript.Count - 1 do
      begin
        SqlError := ExecuteSQL(SQLScript.Strings[i], FsConfig.verbose_sql_script);
        //mMsg.Items.Add(' ');
        if SqlError then
        begin
          mMsg.Items.Add('Error in statement.');
          mMsg.Items.Text := mMsg.Items.Text + SQLScript.Strings[i];
          mMsg.Items.Add('Script stopped.');
          mMsg.Items.Add(' ');
          mMsg.Items.Add(Format('%d Row(s) Inserted.', [FScriptStat.ins_rows]));
          mMsg.Items.Add(Format('%d Row(s) Updated.', [FScriptStat.upg_rows]));
          mMsg.Items.Add(Format('%d Row(s) Deleted.', [FScriptStat.del_rows]));
          mMsg.Items.Add(Format('%d Ddl(s) Statement executed.', [FScriptStat.ddl_cmds]));
          break;
        end;
      end;
    end;
    if not SqlError then
    begin
      FScriptStat.end_t := now;
      mMsg.Items.Add(Format('Script executed. [Time: %s]',[TimeT(FScriptStat.end_t - FScriptStat.start_t)]));
      mMsg.Items.Add(' ');
      mMsg.Items.Add(Format('%d Row(s) Inserted. ', [FScriptStat.ins_rows]));
      mMsg.Items.Add(Format('%d Row(s) Updated. ', [FScriptStat.upg_rows]));
      mMsg.Items.Add(Format('%d Row(s) Deleted. ', [FScriptStat.del_rows]));
      mMsg.Items.Add(Format('%d Ddl(s) Statement executed ', [FScriptStat.ddl_cmds]));
    end;
  finally
    Screen.Cursor := crDefault;
    SQLScript.Free;
  end;
  mMsg.ItemIndex := mMsg.Items.Count - 1;
  mMsg.ItemIndex := -1;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aMetadataExecute(Sender: TObject);
begin
  if dmib.DbMain.Connected then
  begin
    ShowBuffer;
    lTitle.Caption := ' METADATA';
    try
      Screen.Cursor := crSqlWait;
      if not DMib.trBrowser.InTransaction then  DMib.trBrowser.StartTransaction;
      mBuffer.Lines := dmib.IBmeta.Metadata;
    finally
      if DMib.trBrowser.InTransaction then dmib.trBrowser.RollBack;
      Screen.Cursor := crDefault;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aNewScriptExecute(Sender: TObject);
begin
  if nbMain.PageIndex <> 1 then
    nbMain.PageIndex := 1;
  mSql.SetFocus;
  mSql.Lines.Clear;
  CarretPos;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aOpenScriptExecute(Sender: TObject);
begin
  odOpen.DefaultExt := '*.sql';
  odOpen.Filter := 'Sql scripts (*.sql)|*.sql|Text files (*.txt)|*.txt|Any file (*.*)|*.*';
  if odOpen.Execute then
  begin
    nbMain.PageIndex := 1;
    mSql.Lines.LoadFromFile(odOpen.FileName);
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aPreviousExecute(Sender: TObject);
begin
  Dec(FHistoryIDX);
  mSql.Lines.Text := FHistory.Strings[FHistoryIDX];
  if FHistoryIDX = 0 then aPrevious.Enabled := False;
  if (FHistory.Count > 1) and (FHistoryIDX < (FHistory.Count - 1)) then
    aNext.Enabled := True
  else
    anext.Enabled := False;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aRefreshAllExecute(Sender: TObject);
begin
  tvDb.OnChange := nil;
  try
    if dmib.dbMain.Connected then
    begin
      {$IFDEF UNIX}
      FNeedRefresh := True;
      {$ENDIF}
      ShowBuffer;
      mBuffer.Lines.Clear;
      tvDb.FullCollapse;
      LoadtvDb;
    end;
  finally
    tvdb.OnChange := @tvDbChange;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aNextExecute(Sender: TObject);
begin
  Inc(FHistoryIDX);
  mSql.Lines.Text := FHistory.Strings[FHistoryIDX];
  if FHistoryIdx = (FHistory.Count - 1) then  aNext.Enabled := False;
  aPrevious.Enabled := True;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aRollBackExecute(Sender: TObject);
begin
  try
    Dmib.trISql.Rollback;
    mMsg.Items.add(Format('Transaction Rolled Back. [%s]',[TimeToStr(Now)]));
    EndTr;
    mMsg.ItemIndex := mMsg.Items.Count -1 ;
    mMsg.ItemIndex := -1;
  except
    on E: EFBLError do
    begin
      mMsg.Items.Add(Format('Error in Transaction rollback. [isc_error :%d]',[E.ISC_ErrorCode]));
      mMsg.Items.Text :=  mMsg.Items.Text + E.Message;
      mMsg.ItemIndex := mMsg.Items.Count -1 ;
      mMsg.ItemIndex := -1;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.aSaveScriptExecute(Sender: TObject);
begin
  sdSave.DefaultExt := '*.sql';
  sdSave.Filter := 'Sql scripts (*.sql)|*.sql|Text files (*.txt)|*.txt|Any file (*.*)|*.*';
  sdSave.Title := 'Save Sql Script As';
  if sdSave.Execute then
    mSql.Lines.SaveToFile(sdSave.FileName);
end;

procedure TfrmBrowser.MenuExitClick(Sender: TObject);
begin
  Close;
end;



//------------------------------------------------------------------------------

procedure TfrmBrowser.mSqlChange(Sender: TObject);
begin
  aSaveScript.Enabled := mSql.Text <> '';
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.mSqlClick(Sender: TObject);
begin
  CarretPos;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.mSqlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  CarretPos;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.nbMainPageChanged(Sender: TObject);
begin
  if nbMain.PageIndex = 1 then
    mSql.SetFocus;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.tvDbChange(Sender: TObject; Node: TTreeNode);
begin
 if Dmib.dbMain.Connected then
    TreeViewEvents(Node);
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.tvDbClick(Sender: TObject);
begin
  if nbMain.PageIndex <>  0 then
    nbMain.PageIndex := 0;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.tvDbDblClick(Sender: TObject);
begin
  if Assigned(tvDb.Selected) then
  begin
    if Assigned(TNodeDesc(TvDb.Selected.Data)) then
    begin
      if (TNodeDesc(TvDb.Selected.Data).NodeType = CNT_TABLE) or
         (TNodeDesc(TvDb.Selected.Data).NodeType = CNT_VIEW)  or
         (TNodeDesc(TvDb.Selected.Data).NodeType = CNT_SYSTABLE) then
        ShowTableView(TNodeDesc(TvDb.Selected.Data).ObjName);
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.tvDbMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    if Assigned(tvDb.GetNodeAt(X,Y)) then
      tvDB.Selected := tvDb.GetNodeAt(X,Y);
end;

//------------------------------------------------------------------------------

procedure TfrmBrowser.tvDbMouseUp(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 if Button = mbRight then
 begin
   //if Assigned(tvDb.GetNodeAt(X,Y)) then
     //tvDB.Selected := tvDb.GetNodeAt(X,Y);
   //if Assigned(tvDB.Selected) then
   if Assigned(tvDb.GetNodeAt(X,Y)) then
   begin
     if Assigned(tvDB.Selected.Data) then
     begin
       aExportToSql.Enabled := False;
       aExportToHtml.Enabled := False;
       aViewData.Enabled := False;
       aGrantMgr.Enabled := False;
       case TNodeDesc(tvDB.Selected.Data).Nodetype of
         CNT_DATABASE:
           pmnDatabase.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
         CNT_DOMAIN:
           begin
             aShowOptionDescription.Enabled := True;
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         CNT_TABLE:
           begin
             aExportToSql.Enabled := True;
             aExportToHtml.Enabled := True;
             aViewData.Enabled := True;
             aGrantMgr.Enabled := True;
             aShowOptionDescription.Enabled := True;
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         CNT_VIEW:
           begin
             aShowOptionDescription.Enabled := True;
             aExportToHtml.Enabled := True;
             aViewData.Enabled := True;
             aGrantMgr.Enabled := True;
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         CNT_PROCEDURE:
           begin
             aGrantMgr.Enabled := True;
             aShowOptionDescription.Enabled := True;
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         CNT_TRIGGER:
           begin
             aShowOptionDescription.Enabled := True;
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         CNT_GENERATOR:
           begin
             aShowOptionDescription.Enabled := False;
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         CNT_UDF:
           begin
             aShowOptionDescription.Enabled := True;
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         CNT_EXCEPTION:
           begin
             aShowOptionDescription.Enabled := True;
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         CNT_ROLE:
           begin
             aShowOptionDescription.Enabled := True;
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         CNT_SYSTABLE:
           begin
             aViewData.Enabled := True;
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         CNT_SYSTRIGGER:
           begin
             pmnItem.Popup((Sender as TTreeView).ClientOrigin.X + X , (Sender as TTreeView).ClientOrigin.Y + Y);
           end;
         else
       end;
     end;
   end;
 end;
end;

//------------------------------------------------------------------------------

initialization
  {$I fsbrowser.lrs}
  {$IFNDEF UNIX}
    {$r fenixsql.res}
  {$ENDIF}

end.
