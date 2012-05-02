(*
   fenixsql
   author Alessandro Batisti
   abatisti@tiscali.it
   http://fblib.altervista.org

   file:fsdialogtran.pas


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

unit fsdialogtran;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ExtCtrls;

type

  { TfrmDialogTran }

  TfrmDialogTran = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

//var
  //frmDialogTran: TfrmDialogTran;

implementation

{ TfrmDialogTran }

procedure TfrmDialogTran.FormCreate(Sender: TObject);
begin
  {$I fsunixborder.inc}
end;

initialization
  {$I fsdialogtran.lrs}

end.

