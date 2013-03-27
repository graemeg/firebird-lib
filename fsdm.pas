(*
   fenixsql
   author Alessandro Batisti

   fblib@altervista.org

   http://fblib.altervista.org

   file:fsdm.pas

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
unit fsdm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Dialogs, FBLDatabase,
  SynHighlighterSQL, FBLTransaction, FBLDsql, FBLMetadata;

type

  { Tdmib }

  Tdmib = class(TDataModule)
    DbMain: TFBLDatabase;
    qryBlobView: TFBLDsql;
    trBlobView: TFBLTransaction;
    qryTableFilter: TFBLDsql;
    trTableView: TFBLTransaction;
    qryTableView: TFBLDsql;
    qryBrowser: TFBLDsql;
    IbMeta: TFBLMetadata;
    trBrowser: TFBLTransaction;
    qryISql: TFBLDsql;
    trISql: TFBLTransaction;
    SynSQLSyn1: TSynSQLSyn;
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  dmib: Tdmib;

implementation

initialization
  {$I fsdm.lrs}

end.
