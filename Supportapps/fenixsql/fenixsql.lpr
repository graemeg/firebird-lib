program fenixsql;

{$mode objfpc}{$H+}
{$IFDEF MSWINDOWS} {$appmode gui} {$ENDIF}

uses
  Interfaces, // this includes the LCL widgetset
  Forms,
  fsbrowser, fsdm, fsconfig, fsparaminput,
  fsblobinput, fsblobtext, fslogin, fsconst, fsdialogtran, fstableview,
  fstablefilter, fsblobviewdialog, fsmixf, fscreatedb, fsexporttohtml, 
  fsdescription, fsoptions, fstextoptions, fsservice, fsusers, fsusermod,
  fsbackup, fsabout, fsdbconnections, fsgridintf;
{$IFNDEF UNIX}
{$R fenixsql.res}
{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TfrmBrowser, frmBrowser);
  Application.CreateForm(Tdmib, dmib);
  Application.Run;
end.


