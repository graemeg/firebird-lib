unit fsoptions;
(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   File: fsoptions.pas

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

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons;

type

  { TfrmOptions }

  TfrmOptions = class(TForm)
    btnOk: TBitBtn;
    btnCancel: TBitBtn;
    cgBrowser: TCheckGroup;
    cgSql: TCheckGroup;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Notebook1: TNotebook;
    OpenDialog1: TOpenDialog;
    Page1: TPage;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    rgOutput: TRadioGroup;
    seMaxGridRows: TSpinEdit;
    seMaxFetch: TSpinEdit;
    procedure btnOkClick(Sender: TObject);
    procedure cbProtocolChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure seMaxFetchChange(Sender: TObject);
  private
    { private declarations }
    procedure EnableDisableControl;
    function ValidateInput: boolean;
  public
    { public declarations }
  end; 

//var
  //frmOptions: TfrmOptions;

implementation

uses
  fsconfig;

{ TfrmOptions }

procedure TfrmOptions.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
  cgBrowser.Checked[0] := FsConfig.show_system_objs;
  cgSql.Checked[0] := FsConfig.auto_commit_ddl;
  cgSql.Checked[1] := FsConfig.verbose_sql_script;
  cgSql.Checked[2] := FsConfig.show_set_term;
  seMaxGridRows.Value := FsConfig.max_grid_rows;
  seMaxFetch.Value := FsConfig.max_fetch;
  rgOutput.ItemIndex := FsConfig.set_output_grid;
end;


//------------------------------------------------------------------------------

procedure TfrmOptions.seMaxFetchChange(Sender: TObject);
begin
  if seMaxFetch.Value < 0 then seMaxFetch.Value := 0;
end;

//------------------------------------------------------------------------------

procedure TfrmOptions.cbProtocolChange(Sender: TObject);
begin
  EnableDisableControl;
end;

//------------------------------------------------------------------------------

procedure TfrmOptions.btnOkClick(Sender: TObject);
begin
  if ValidateInput then
  begin
    FsConfig.show_system_objs := cgBrowser.Checked[0];
    FsConfig.auto_commit_ddl := cgSql.Checked[0];
    FsConfig.verbose_sql_script := cgSql.Checked[1];
    FsConfig.show_set_term := cgSql.Checked[2];
    FsConfig.set_output_grid := rgOutput.ItemIndex;
    FsConfig.max_grid_rows := seMaxGridRows.Value;
    FsConfig.max_fetch := seMaxFetch.Value;
    FsConfig.WriteConfigFile;
    ModalResult := mrOk;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmOptions.EnableDisableControl;
begin
  {
  case cbProtocol.ItemIndex of
    0:   // Local
      begin
        sePort.Enabled := False;
        edHost.Enabled := False;
        sbDatabase.Enabled := True;
      end;

    1: //TCPIP
      begin
        sePort.Enabled := True;
        edHost.Enabled := True;
        sbDatabase.Enabled := False;
      end;
    2:  //NetBeui
      begin
        sePort.Enabled := False;
        edHost.Enabled := True;
        sbDatabase.Enabled := False;
      end;
  end;
  }
end;

//------------------------------------------------------------------------------

function TfrmOptions.ValidateInput: boolean;
begin
{
  Result := False;
  if edDatabase.Text = '' then
  begin
    ShowMessage('"Database" cannot be blank');
    edDatabase.SetFocus;
    Exit;
  end;

  if (cbProtocol.ItemIndex <> 0) and (edHost.Text = '') then
  begin
    ShowMessage('"Host" cannot be blank');
    edHost.SetFocus;
    Exit;
  end;  }
  Result := True;
end;



initialization
  {$I fsoptions.lrs}

end.

