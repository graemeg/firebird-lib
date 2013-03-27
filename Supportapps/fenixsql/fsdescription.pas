(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   File:FsDescription.pas

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

unit fsdescription;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { TfrmDescription }

  TfrmDescription = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Memo1: TMemo;
    Panel1: TPanel;
  private
    { private declarations }
    function GetText: string;
    procedure SetText(const Value: string);
  public
    { public declarations }
    property Text: string read GetText write SetText;
  end; 
  

//var
  //frmDescription: TfrmDescription;

implementation

function TfrmDescription.GetText: string;
begin
  Result := Memo1.Lines.Text;
end;

procedure TfrmDescription.SetText(const Value: string);
begin
  Memo1.Lines.Text := Value;
end;

initialization
  {$I fsdescription.lrs}

end.

