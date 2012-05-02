(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   {file:fsexporttohtml.pas}

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

unit fsexporttohtml;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, FBLHtmlExport;

type

  { TfrmExportToHtml }

  TfrmExportToHtml = class(TForm)
    btnSave: TBitBtn;
    BitBtn2: TBitBtn;
    gbPage: TGroupBox;
    edTitle: TLabeledEdit;
    edBody: TLabeledEdit;
    GroupBox2: TGroupBox;
    edCaption: TLabeledEdit;
    edCaptionOption: TLabeledEdit;
    edTable: TLabeledEdit;
    edTr: TLabeledEdit;
    edTh: TLabeledEdit;
    edTd: TLabeledEdit;
    lRelationName: TLabel;
    Notebook1: TNotebook;
    Page1: TPage;
    Page2: TPage;
    Panel1: TPanel;
    Panel2: TPanel;
    rgHeader: TRadioGroup;
    rdType: TRadioGroup;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure rdTypeClick(Sender: TObject);
    procedure rgHeaderClick(Sender: TObject);
  private
    { private declarations }
    function GetRelationName: string;
    procedure SetRelationName(Value: string);
    procedure SaveToHtml(const AFileName: string);
  public
    { public declarations }
    property RelationName: string read GetRelationName write SetRelationName;
  end; 

//var
  //frmExportToHtml: TfrmExportToHtml;

implementation

uses
  fsdm;

//------------------------------------------------------------------------------

procedure TfrmExportToHtml.SaveToHtml(const AFileName: string);
var
  OutFile: TFileStream;
  Exp: TFBLHtmlExport;
begin
  OutFile := TFileStream.Create(AFileName,fmCreate);
  Exp := TFBLHtmlExport.Create(dmib.qryBrowser);
  try
    Screen.Cursor := crHourGlass;
    if not dmib.trBrowser.InTransaction then dmib.trBrowser.StartTransaction;
    dmib.qryBrowser.SQL.Text := 'SELECT * FROM ' + lRelationName.Caption;
    dmib.qryBrowser.ExecSQL;
    if rdType.ItemIndex = 0 then
    begin
      Exp.HtmlPageType := hptComplete;
      Exp.TagBodyOption := edBody.Text;
      Exp.PageTitle := edTitle.Text;
    end
    else
      Exp.HtmlPageType := hptOnlyTable;

    if rgHeader.ItemIndex = 0 then
    begin
      Exp.ShowTableTitle := True;
      Exp.TagThOption := edTh.Text;
    end;

    if edCaption.Text <> '' then
    begin
      Exp.ShowTableCaption := True;
      Exp.TableCaption := edCaption.Text;
      Exp.TagTableCaptionOption := edCaptionOption.Text;
    end;
    Exp.TagTdOption := edTd.Text;
    Exp.TagTrOption := edTr.Text;
    Exp.TagTableOption := edTable.Text;
    Exp.BeginFetch;
    Exp.HtmlHeader.SaveToStream(OutFile);
    while not exp.EOF do
    begin
      Exp.HtmlCurrentRecord.SaveToStream(OutFile);
      Exp.NextRecord;
    end;
    Exp.HtmlFooter.SaveToStream(OutFile);
    Dmib.qryBrowser.Close;
    ShowMessage(Format('%d Record exported in %s',[Exp.FetchCount,AFileName]));
  finally
    OutFile.Free;
    Exp.Free;
    Screen.Cursor := crDefault;
    if dmib.trBrowser.InTransaction then dmib.trBrowser.RollBack;
  end;

end;

//------------------------------------------------------------------------------

procedure TfrmExportToHtml.btnSaveClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SaveToHtml(SaveDialog1.FileName);
end;

//------------------------------------------------------------------------------

procedure TfrmExportToHtml.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
end;

//------------------------------------------------------------------------------

procedure TfrmExportToHtml.rdTypeClick(Sender: TObject);
begin
  gbPage.Enabled := (rdType.ItemIndex = 0)
end;

//------------------------------------------------------------------------------

procedure TfrmExportToHtml.rgHeaderClick(Sender: TObject);
begin
  edTh.Enabled := (rgHeader.ItemIndex = 0);
end;

//------------------------------------------------------------------------------


function TfrmExportToHtml.GetRelationName: string;
begin
  Result := lRelationName.Caption;
end;

//------------------------------------------------------------------------------

procedure TfrmExportToHtml.SetRelationName(Value: string);
begin
  lRelationName.Caption := Value;
end;

//------------------------------------------------------------------------------

initialization
  {$I fsexporttohtml.lrs}

end.

