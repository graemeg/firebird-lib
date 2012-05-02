(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fstextoptions.pas

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
unit fstextoptions;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, SynMemo, SynHighlighterSQL, ColorBox;

type

  { TfrmTextOptions }

  TfrmTextOptions = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    btnFont: TBitBtn;
    btnFontTextGrid: TButton;
    btnTextGridColor: TButton;
    cgStyle: TCheckGroup;
    cdFont: TColorDialog;
    cbFore: TColorButton;
    cbBack: TColorButton;
    FontDialog1: TFontDialog;
    frnColor: TBitBtn;
    btnFontSql: TBitBtn;
    btnColorSql: TBitBtn;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblFontTextGrid: TLabel;
    lblFontDDL: TLabel;
    lblFontSql: TLabel;
    lbElements: TListBox;
    Notebook1: TNotebook;
    Page1: TPage;
    Page2: TPage;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelDown: TPanel;
    PanelUp: TPanel;
    smPreview: TSynMemo;
    SynSQLTemp: TSynSQLSyn;
    procedure btnColorSqlClick(Sender: TObject);
    procedure btnFontClick(Sender: TObject);
    procedure btnFontSqlClick(Sender: TObject);
    procedure btnFontTextGridClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure btnTextGridColorClick(Sender: TObject);
    procedure cbBackChangeBounds(Sender: TObject);
    procedure cbBackColorChanged(Sender: TObject);
    procedure cbForeColorChanged(Sender: TObject);
    //procedure cbBackChange(Sender: TObject);
    //procedure cbForeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cgStyleItemClick(Sender: TObject; Index: integer);
    procedure frnColorClick(Sender: TObject);
    //procedure lbElementsChangeBounds(Sender: TObject);
    procedure lbElementsClick(Sender: TObject);
  private
    { private declarations }
    FDDLChanged, FSQLChanged, FTextGridChanged: Boolean;
    function GetFontDDL: TFont;
    function GetColorDDL: TColor;
    function GetFontSQL: TFont;
    function GetColorSQL: TColor;
    function GetFontTextGrid: TFont;
    function GetColorTextGrid: TColor;
    procedure SetFontDDL(Value: TFont);
    procedure SetColorDDL(Value: TColor);
    procedure SetFontSQL(Value: TFont);
    procedure SetColorSQL(Value: TColor);
    procedure SetFontTextGrid(Value: TFont);
    procedure SetColorTextGrid(Value: TColor);
    procedure LoadSynAttrib;
    procedure SaveSynAttrib;
    procedure SetAttrib;
  public
    { public declarations }
    property FontDDL: TFont read GetFontDDL write SetFontDDL;
    property ColorDDL: TColor read GetColorDDL write SetColorDDL;
    property DDLChanged: Boolean read FDDLChanged;

    property FontSQL: TFont read GetFontSQL write SetFontSQL;
    property ColorSQL: TColor read GetColorSQL write SetColorSQL;
    property SQLChanged: Boolean read FSQLChanged;
    
    property FontTextGrid: TFont read GetFontTextGrid write SetFontTextGrid;
    property ColorTextGrid: TColor read GetColorTextGrid write SetColorTextGrid;
    property TextGridChanged: Boolean read FTextGridChanged;

  end; 

//var
  //frmTextOptions: TfrmTextOptions;
const
  BOLD = 0;
  ITALIC = 1;
  UNDERLINE = 2;

implementation

uses
  fsconfig, fsdm;


{ TfrmTextOptions }


function TfrmTextOptions.GetFontDDL: TFont;
begin
  Result := lblFontDDL.Font;
end;

//------------------------------------------------------------------------------

function TfrmTextOptions.GetColorDDL: TColor;
begin
  Result := lblFontDDL.Color;
end;

//------------------------------------------------------------------------------

function TfrmTextOptions.GetFontSQL: TFont;
begin
  Result := lblFontSQL.Font;
end;

//------------------------------------------------------------------------------

function TfrmTextOptions.GetColorSQL: TColor;
begin
  Result := lblFontSql.Color;
end;

//------------------------------------------------------------------------------

function TfrmTextOptions.GetFontTextGrid: TFont;
begin
  Result := lblFontTextGrid.Font;
end;

//------------------------------------------------------------------------------

function TfrmTextOptions.GetColorTextGrid: TColor;
begin
  Result := lblFontTextGrid.Color;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.SetFontDDL(Value: TFont);
begin
  lblFontDDL.Font := Value;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.SetColorDDL(Value: TColor);
begin
  lblFontDDL.Color := Value;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.SetFontSQL(Value: TFont);
begin
  lblFontSQL.Font := Value;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.SetColorSQL(Value: TColor);
begin
  lblFontSQL.Color := Value;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.SetFontTextGrid(Value: TFont);
begin
  lblFontTextGrid.Font := Value;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.SetColorTextGrid(Value: TColor);
begin
  lblFontTextGrid.Color := Value;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.btnFontClick(Sender: TObject);
begin
   FontDialog1.Font := lblFontDDL.Font;
   if FontDialog1.Execute then
   begin
     lblFontDDL.Font := FontDialog1.Font;
     FDDLChanged := True;
   end;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.frnColorClick(Sender: TObject);
begin
  cdFont.Color := lblFontDDL.Color;
  if cdFont.Execute then
  begin
    lblFontDDL.Color := cdFont.Color;
    FDDLChanged := True;
  end;
end;


//------------------------------------------------------------------------------

procedure TfrmTextOptions.lbElementsClick(Sender: TObject);
var
  item : string;
begin
  cbFore.OnColorChanged := nil;
  cbBack.OnColorChanged := nil;
  //ShowMessage(IntToStr(lbelements.ItemIndex));
  try
    if lbelements.ItemIndex  >= 0 then
    begin
      item := lbElements.Items.Strings[lbelements.ItemIndex];

      if item = 'Comment' then
      begin
        cbFore.ButtonColor := SynSQLTemp.CommentAttri.Foreground;
        //cbFore.Hint := ColorToString(cbFore.ButtonColor);
        cbBack.ButtonColor := SynSQLTemp.CommentAttri.Background;
        
        cgStyle.Checked[BOLD] := fsBold in SynSQLTemp.CommentAttri.Style;
        cgStyle.Checked[ITALIC]:= fsItalic in SynSQLTemp.CommentAttri.Style;
        cgStyle.Checked[UNDERLINE] := fsUnderline in SynSQLTemp.CommentAttri.Style;
      end
      else if item = 'Reserved word' then
      begin
        cbFore.ButtonColor := SynSQLTemp.KeyAttri.Foreground;
        cbBack.ButtonColor := SynSQLTemp.KeyAttri.Background;
        cgStyle.Checked[BOLD] := fsBold in SynSQLTemp.KeyAttri.Style;
        cgStyle.Checked[ITALIC] := fsItalic in SynSQLTemp.KeyAttri.Style;
        cgStyle.Checked[UNDERLINE] := fsUnderline in SynSQLTemp.KeyAttri.Style;
      end
      else if item = 'Number' then
      begin
        cbFore.ButtonColor := SynSQLTemp.NumberAttri.Foreground;
        cbBack.ButtonColor := SynSQLTemp.NumberAttri.Background;
        cgStyle.Checked[BOLD] := fsBold in SynSQLTemp.NumberAttri.Style;
        cgStyle.Checked[ITALIC]:= fsItalic in SynSQLTemp.NumberAttri.Style;
        cgStyle.Checked[UNDERLINE] := fsUnderline in SynSQLTemp.NumberAttri.Style;
      end
      else if item = 'String' then
      begin
        cbFore.ButtonColor := SynSQLTemp.StringAttri.Foreground;
        cbBack.ButtonColor := SynSQLTemp.StringAttri.Background;
        cgStyle.Checked[BOLD] := fsBold in SynSQLTemp.StringAttri.Style;
        cgStyle.Checked[ITALIC] := fsItalic in SynSQLTemp.StringAttri.Style;
        cgStyle.Checked[UNDERLINE] := fsUnderline in SynSQLTemp.StringAttri.Style;
      end
      else if item = 'Tablenames' then
      begin
        cbFore.ButtonColor := SynSQLTemp.TableNameAttri.Foreground;
        cbBack.ButtonColor := SynSQLTemp.TableNameAttri.Background;
        cgStyle.Checked[BOLD] := fsBold in SynSQLTemp.TableNameAttri.Style;
        cgStyle.Checked[ITALIC] := fsItalic in SynSQLTemp.TableNameAttri.Style;
        cgStyle.Checked[UNDERLINE] := fsUnderline in SynSQLTemp.TableNameAttri.Style;
      end
      else if item = 'Datatype' then
      begin
        cbFore.ButtonColor := SynSQLTemp.DataTypeAttri.Foreground;
        cbBack.ButtonColor := SynSQLTemp.DataTypeAttri.Background;
        cgStyle.Checked[BOLD] := fsBold in SynSQLTemp.DataTypeAttri.Style;
        cgStyle.Checked[ITALIC] := fsItalic in SynSQLTemp.DataTypeAttri.Style;
        cgStyle.Checked[UNDERLINE] := fsUnderline in SynSQLTemp.DataTypeAttri.Style;
      end
      else if item = 'Identifier' then
      begin
        cbFore.ButtonColor := SynSQLTemp.IdentifierAttri.Foreground;
        cbBack.ButtonColor := SynSQLTemp.IdentifierAttri.Background;
        cgStyle.Checked[BOLD] := fsBold in SynSQLTemp.IdentifierAttri.Style;
        cgStyle.Checked[ITALIC] := fsItalic in SynSQLTemp.IdentifierAttri.Style;
        cgStyle.Checked[UNDERLINE] := fsUnderline in SynSQLTemp.IdentifierAttri.Style;
      end;
       cbFore.Hint := ColorToString(cbFore.ButtonColor);
       cbBack.Hint := ColorToString(cbBack.ButtonColor);
    end;
  finally
    cbFore.OnColorChanged := @cbForeColorChanged;
    cbBack.OnColorChanged := @cbBackColorChanged;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.btnFontSqlClick(Sender: TObject);
begin
  FontDialog1.Font := lblFontSql.Font;
  if FontDialog1.Execute then
  begin
    lblFontSql.Font :=  FontDialog1.Font;
    FSQLChanged := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.btnColorSqlClick(Sender: TObject);
begin
  cdFont.Color := lblFontSQL.Color;
  if cdFont.Execute then
  begin
    lblFontSQL.Color := cdFont.Color;
    FSQLChanged := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.btnFontTextGridClick(Sender: TObject);
begin
  FontDialog1.Font := lblFontTextGrid.Font;
  if FontDialog1.Execute then
  begin
    lblFontTextGrid.Font := FontDialog1.Font;
    FTextGridChanged := True;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.btnOkClick(Sender: TObject);
begin
  SaveSynAttrib;
  FsConfig.WriteConfigSynEdit;
  ModalResult := mrOk;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.btnTextGridColorClick(Sender: TObject);
begin
  cdFont.Color := lblFontTextGrid.Color;
  if cdFont.Execute then
  begin
    lblFontTextGrid.Color := cdFont.Color;
    FTextGridChanged := True;
  end;
end;

procedure TfrmTextOptions.cbBackChangeBounds(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.cbBackColorChanged(Sender: TObject);
begin
 SetAttrib;
 cbBack.Hint :=  ColorToString(cbBack.ButtonColor);
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.cbForeColorChanged(Sender: TObject);
begin
  SetAttrib;
  cbFore.Hint := ColorToString(cbFore.ButtonColor);
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
  FDDLChanged := False;
  FSQLChanged := False;
  FTextGridChanged := False ;
  LoadSynAttrib;
  SynSQLTemp.TableNames.Clear;
  SynSQLTemp.TableNames.Add('Table1');
  lbElements.ItemIndex := 0;
  lbElementsClick(self);
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.FormShow(Sender: TObject);
begin
  //smPreview.Font := lblFontDDL.Font;
   //lbElementsClick(self);
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.cgStyleItemClick(Sender: TObject; Index: integer);
begin
  //ShowMessage(IntToStr(Index));
  SetAttrib;
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.LoadSynAttrib;
begin
  SynSqlTemp.CommentAttri.Assign(dmib.SynSQLSyn1.CommentAttri);
  SynSqlTemp.KeyAttri.Assign(dmib.SynSQLSyn1.KeyAttri);
  SynSqlTemp.NumberAttri.Assign(dmib.SynSQLSyn1.NumberAttri);
  SynSqlTemp.StringAttri.Assign(dmib.SynSQLSyn1.StringAttri);
  SynSqlTemp.TableNameAttri.Assign(dmib.SynSQLSyn1.TableNameAttri);
  SynSqlTemp.DataTypeAttri.Assign(dmib.SynSQLSyn1.DataTypeAttri);
  SynSqlTemp.IdentifierAttri.Assign(dmib.SynSQLSyn1.IdentifierAttri);
end;

//------------------------------------------------------------------------------

procedure TfrmTextOptions.SaveSynAttrib;
begin
  dmib.SynSqlSyn1.CommentAttri.Assign(SynSQLTemp.CommentAttri);
  dmib.SynSqlSyn1.KeyAttri.Assign(SynSQLTemp.KeyAttri);
  dmib.SynSqlSyn1.NumberAttri.Assign(SynSQLTemp.NumberAttri);
  dmib.SynSqlSyn1.StringAttri.Assign(SynSQLTemp.StringAttri);
  dmib.SynSqlSyn1.TableNameAttri.Assign(SynSQLTemp.TableNameAttri);
  dmib.SynSqlSyn1.DataTypeAttri.Assign(SynSQLTemp.DataTypeAttri);
  dmib.SynSqlSyn1.IdentifierAttri.Assign(SynSQLTemp.IdentifierAttri);
end;
//------------------------------------------------------------------------------

procedure TfrmTextOptions.SetAttrib;
var
  item: string;
begin
  item := lbElements.Items.Strings[lbelements.ItemIndex];
  if item = 'Comment' then
  begin
    SynSQLTemp.CommentAttri.Foreground := cbFore.ButtonColor;
    SynSQLTemp.CommentAttri.Background := cbBack.ButtonColor;
    if cgStyle.Checked[BOLD] then
      SynSQLTemp.CommentAttri.Style := SynSQLTemp.CommentAttri.Style + [fsBold]
    else
      SynSQLTemp.CommentAttri.Style := SynSQLTemp.CommentAttri.Style - [fsBold];
    if cgStyle.Checked[ITALIC] then
      SynSQLTemp.CommentAttri.Style := SynSQLTemp.CommentAttri.Style + [fsItalic]
    else
      SynSQLTemp.CommentAttri.Style := SynSQLTemp.CommentAttri.Style - [fsItalic];
    if cgStyle.Checked[UNDERLINE] then
      SynSQLTemp.CommentAttri.Style := SynSQLTemp.CommentAttri.Style + [fsUnderline]
    else
      SynSQLTemp.CommentAttri.Style := SynSQLTemp.CommentAttri.Style - [fsUnderline];
  end;

  if item = 'Reserved word' then
  begin
    SynSQLTemp.KeyAttri.Foreground := cbFore.ButtonColor;
    SynSQLTemp.KeyAttri.Background := cbBack.ButtonColor;
    if cgStyle.Checked[BOLD] then
      SynSQLTemp.KeyAttri.Style := SynSQLTemp.KeyAttri.Style + [fsBold]
    else
      SynSQLTemp.KeyAttri.Style := SynSQLTemp.KeyAttri.Style - [fsBold];
    if cgStyle.Checked[ITALIC] then
      SynSQLTemp.KeyAttri.Style := SynSQLTemp.KeyAttri.Style + [fsItalic]
    else
      SynSQLTemp.KeyAttri.Style := SynSQLTemp.KeyAttri.Style - [fsItalic];
    if cgStyle.Checked[UNDERLINE] then
      SynSQLTemp.KeyAttri.Style := SynSQLTemp.KeyAttri.Style + [fsUnderline]
    else
      SynSQLTemp.KeyAttri.Style := SynSQLTemp.KeyAttri.Style - [fsUnderline];
  end;

  if item = 'Number' then
  begin
    SynSQLTemp.NumberAttri.Foreground := cbFore.ButtonColor;
    SynSQLTemp.NumberAttri.Background := cbBack.ButtonColor;
    if cgStyle.Checked[BOLD] then
      SynSQLTemp.NumberAttri.Style := SynSQLTemp.NumberAttri.Style + [fsBold]
    else
      SynSQLTemp.NumberAttri.Style := SynSQLTemp.NumberAttri.Style - [fsBold];
    if cgStyle.Checked[ITALIC] then
      SynSQLTemp.NumberAttri.Style := SynSQLTemp.NumberAttri.Style + [fsItalic]
    else
      SynSQLTemp.NumberAttri.Style := SynSQLTemp.NumberAttri.Style - [fsItalic];
    if cgStyle.Checked[UNDERLINE] then
      SynSQLTemp.NumberAttri.Style := SynSQLTemp.NumberAttri.Style + [fsUnderline]
    else
      SynSQLTemp.NumberAttri.Style := SynSQLTemp.NumberAttri.Style - [fsUnderline];
  end;

  if item = 'String' then
  begin
    SynSQLTemp.StringAttri.Foreground := cbFore.ButtonColor;
    SynSQLTemp.StringAttri.Background := cbBack.ButtonColor;
    if cgStyle.Checked[BOLD] then
      SynSQLTemp.StringAttri.Style := SynSQLTemp.StringAttri.Style + [fsBold]
    else
      SynSQLTemp.StringAttri.Style := SynSQLTemp.StringAttri.Style - [fsBold];
    if cgStyle.Checked[ITALIC] then
      SynSQLTemp.StringAttri.Style := SynSQLTemp.StringAttri.Style + [fsItalic]
    else
      SynSQLTemp.StringAttri.Style := SynSQLTemp.StringAttri.Style - [fsItalic];
    if cgStyle.Checked[UNDERLINE] then
      SynSQLTemp.StringAttri.Style := SynSQLTemp.StringAttri.Style + [fsUnderline]
    else
      SynSQLTemp.StringAttri.Style := SynSQLTemp.StringAttri.Style - [fsUnderline];
  end;

  if item = 'Tablenames' then
  begin
    SynSQLTemp.TableNameAttri.Foreground := cbFore.ButtonColor;
    SynSQLTemp.TableNameAttri.Background := cbBack.ButtonColor;
    if cgStyle.Checked[BOLD] then
      SynSQLTemp.TableNameAttri.Style := SynSQLTemp.TableNameAttri.Style + [fsBold]
    else
      SynSQLTemp.TableNameAttri.Style := SynSQLTemp.TableNameAttri.Style - [fsBold];
    if cgStyle.Checked[ITALIC] then
      SynSQLTemp.TableNameAttri.Style := SynSQLTemp.TableNameAttri.Style + [fsItalic]
    else
      SynSQLTemp.TableNameAttri.Style := SynSQLTemp.TableNameAttri.Style - [fsItalic];
    if cgStyle.Checked[UNDERLINE] then
      SynSQLTemp.TableNameAttri.Style := SynSQLTemp.TableNameAttri.Style + [fsUnderline]
    else
      SynSQLTemp.TableNameAttri.Style := SynSQLTemp.TableNameAttri.Style - [fsUnderline];
  end;

  if item = 'Datatype' then
  begin
    SynSQLTemp.DataTypeAttri.Foreground := cbFore.ButtonColor;
    SynSQLTemp.DataTypeAttri.Background := cbBack.ButtonColor;
    if cgStyle.Checked[BOLD] then
      SynSQLTemp.DataTypeAttri.Style := SynSQLTemp.DataTypeAttri.Style + [fsBold]
    else
      SynSQLTemp.DataTypeAttri.Style := SynSQLTemp.DataTypeAttri.Style - [fsBold];
    if cgStyle.Checked[ITALIC] then
      SynSQLTemp.DataTypeAttri.Style := SynSQLTemp.DataTypeAttri.Style + [fsItalic]
    else
      SynSQLTemp.DataTypeAttri.Style := SynSQLTemp.DataTypeAttri.Style - [fsItalic];
    if cgStyle.Checked[UNDERLINE] then
      SynSQLTemp.DataTypeAttri.Style := SynSQLTemp.DataTypeAttri.Style + [fsUnderline]
    else
      SynSQLTemp.DataTypeAttri.Style := SynSQLTemp.DataTypeAttri.Style - [fsUnderline];
  end;

  if item = 'Identifier' then
  begin
    SynSQLTemp.IdentifierAttri.Foreground := cbFore.ButtonColor;
    SynSQLTemp.IdentifierAttri.Background := cbBack.ButtonColor;
    if cgStyle.Checked[BOLD] then
      SynSQLTemp.IdentifierAttri.Style := SynSQLTemp.IdentifierAttri.Style + [fsBold]
    else
      SynSQLTemp.IdentifierAttri.Style := SynSQLTemp.IdentifierAttri.Style - [fsBold];
    if cgStyle.Checked[ITALIC] then
      SynSQLTemp.IdentifierAttri.Style := SynSQLTemp.IdentifierAttri.Style + [fsItalic]
    else
      SynSQLTemp.IdentifierAttri.Style := SynSQLTemp.IdentifierAttri.Style - [fsItalic];
    if cgStyle.Checked[UNDERLINE] then
      SynSQLTemp.IdentifierAttri.Style := SynSQLTemp.IdentifierAttri.Style + [fsUnderline]
    else
      SynSQLTemp.IdentifierAttri.Style := SynSQLTemp.IdentifierAttri.Style - [fsUnderline];
  end;
end;


initialization
  {$I fstextoptions.lrs}

end.

