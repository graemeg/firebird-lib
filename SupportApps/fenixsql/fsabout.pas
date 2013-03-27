(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fsabout.pas


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

unit fsabout;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls;

type

  { TfrmAbout }

  TfrmAbout = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    lblTitle2: TLabel;
    lbltitle1: TLabel;
    lUrl: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lVersion: TLabel;
    lAuthor: TLabel;
    leMail: TLabel;
    lic: TPageControl;
    mLic: TMemo;
    pgInfo: TTabSheet;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pgLicence: TTabSheet;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 
  procedure ShowAbout(AAppVersion,AAuthor: string);
//var
  //frmAbout: TfrmAbout;

implementation

{ TfrmAbout }

procedure ShowAbout(AAppVersion,AAuthor: string);
var
 frmAbout: TfrmAbout;
begin
 frmAbout := TfrmAbout.Create(nil);
 try
   frmAbout.lVersion.Caption := AAppVersion;
   frmAbout.lAuthor.Caption :=  AAuthor;
   frmAbout.ShowModal;
 finally
   frmAbout.Free;
 end;
end;

//------------------------------------------------------------------------------

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  pgLicence.Caption := 'License Agreement';
  pgInfo.Caption := 'Info';
  leMail.Cursor := crHandPoint;
  lUrl.Cursor := crHandPoint;
  {$I fsunixborder.inc}
  {$ifdef unix}
  with lblTitle1  do
  begin
      Color := clWhite;
      Font.Color := clActiveCaption;
      Font.Height := 18;
      Font.Name := '-adobe-helvetica-*-*-*-*-*-180-*-*-*-*-iso8859-1';
      Font.Pitch := fpVariable;
      Font.Style := [fsBold];
  end;
  with lblTitle2 do
  begin
      Color := clWhite;
      Font.Color := clRed;
      Font.Height := 12;
      Font.Name := '-adobe-helvetica-medium-r-normal-*-*-120-*-*-*-*-iso8859-1';
      Font.Pitch := fpVariable;
  end;
  {$endif}
end;



initialization
  {$I fsabout.lrs}

end.
