{
   Firebird Library
   Open Source Library No Data Aware for direct access to Firebird
   Relational Database from Borland Delphi / Kylix and Free Pascal

   File:FBLDataset.pas
   Copyright (c) 2006 Alessandro Batisti
   fblib@altervista.org
   http://fblib.altervista.org

   This library is free software; you can redistribute it and/or
   modify it under the terms of the GNU Lesser General Public
   License as published by the Free Software Foundation; either
   version 2.1 of the License, or (at your option) any later version.

   This library is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   Lesser General Public License for more details.
}

{$I fbl.inc}

{
@abstract(Dataset components)
@author(Alessandro Batisti <fblib@altervista.org>)
FbLib - Firebird Library @html(<br>)
FBLDataset.pas unit contains TDataset descendant components
}

unit FBLDataset;

interface
uses
  SysUtils, Classes, DB, FBLDsql, FBLTransaction, ibase_h 
  {$IFDEF D6P},FMTBcd{$ENDIF};

type
   EFBLDatasetError = class(Exception);

   {$IFDEF FPC}
   TFBLBookmark = record
    BookMark: LongInt;
    BookMarkFlag: TBookmarkFlag;
   end;
   PFBLBookmark = ^TFBLBookmark;
   {$ENDIF}

  {@abstract(TDataset descendant <unidirectional> <readonly>)}
  TFBLCustomDataset = class(TDataSet)
  private
    FIsOpen: Boolean;
    FRecordSize,
    FRecordBufferSize: Word;
    FIsEmpty,
    FReLoad: Boolean;
    FDSql: TFBLDsql;
    FAutoStartTransaction: Boolean;
    {$IFDEF FPC}
    FRecordCount: Integer;
    FCurrentRecord: Integer;
    FBlobs: TList;
    FOffset : array of Integer;
    procedure DataToBuffer(var ABuffer: PChar);
    procedure EraseBlobList;
    procedure AddToBlobList(APointer: Pointer);
    //function GetBufferListCount: Integer;
    {$ENDIF}
    procedure CheckBeforeOpen;
    procedure InternalAfterOpen;
    function GetSQL: TStrings;
    procedure SetSQL(Value: TStrings);
    function GetTransaction: TFBLTransaction;
    procedure SetTransaction(Value: TFBLTransaction);
    procedure DoOnUnPrepare(Sender: TObject);
  protected
    function GetCanModify: Boolean; override;
    function GetRecNo: LongInt; override;
    function GetRecordCount: Integer; override;
    function AllocRecordBuffer: PChar; override;
    procedure InternalInitRecord(Buffer: PChar); override;
    procedure FreeRecordBuffer(var Buffer: PChar); override;
    function GetRecordSize: Word; override;
    procedure InternalOpen; override;
    procedure InternalClose; override;
    procedure InternalHandleException; override;
    procedure InternalInitFieldDefs; override;
    procedure InternalFirst; override;
    procedure InternalLast; override;
    function GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult;override;
    function IsCursorOpen: Boolean; override;
    {$IFDEF FPC}
    procedure InternalGotoBookmark(aBookmark: Pointer); override;
    procedure InternalSetToRecord(Buffer:Pchar); override;
    procedure SetBookmarkFlag(Buffer: PChar; Value: TBookmarkFlag); override;
    procedure SetBookmarkData(Buffer: PChar; Data: Pointer); override;
    procedure GetBookmarkData(Buffer: PChar; Data: Pointer); override;
    function GetBookmarkFlag(Buffer: PChar): TBookmarkFlag; override;
    {$ENDIF}
  public
    {$IFDEF FPC}
    {current record in buffer <freepascal only>}
    property CurrentRecord;
    {actice record in buffer <freepascal only>}
    property ActiveRecord;
    {numbers of allocated buffer <freepascal only>}
    property BufferCount;
    {number of blob fields in one record <freepascal only>}
    property BlobFieldCount;
    
    //property BufferListCount: Integer read GetBufferListCount;
    {$ENDIF}
    {Create an instace of TFBLCustomDataset}
    constructor Create(AOwen: TComponent); override;
    {Free up  all resources associated with this instance.}
    destructor Destroy; override;
    {Retrieves the current value of a field into a buffer.}
    function GetFieldData(Field: TField; Buffer: Pointer): Boolean; overload; override; 
    {Retrieves the current value of a field into a buffer.}
    function GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean; overload; {$IFNDEF FPC} override; {$ENDIF }
    {Returns number of records fetched.}
    property RecordCount: Integer read GetRecordCount;
    {Returns a TBlobStream object for reading or writing the data in a specified blob field.}
    function CreateBlobStream(Field: TField; Mode: TBlobStreamMode): TStream; override;
  published
    {if True call TFBLTransaction.StartTransaction  automaticcaly when open dataset}
    property AutoStartTransaction: Boolean  read FAutoStartTransaction write FAutoStartTransaction default False;
    {TFBLTransaction object  where current TFBLdataset object is attached }
    property Transaction: TFBLTransaction read GetTransaction write SetTransaction;
    {SQL Statement to execute}
    property SQL:TStrings read GetSQL write SetSQL;
  end;
  
  {@abstract(TDataset descendant <unidirectional> <readonly>)}
  TFBLDataset = class(TFBLCustomDataset)
  public
  published
    {Specifies whether or not a dataset is open.}
    property Active;
    {if True call TFBLTransaction.StartTransaction  automaticcaly when open dataset}
    property AutoStartTransaction;
     {SQL Statement to execute}
    property SQL;
    {TFBLTransaction object  where current TFBLdataset object is attached }
    property Transaction;
    {Occurs after an application closes a dataset.}
    property AfterClose;
    {Occurs after an application closes a dataset.}
    property AfterOpen;
    {Occurs after an application scrolls from one record to another.}
    property AfterScroll;
    {Occurs immediately before the dataset closes.}
    property BeforeClose;
    {Occurs before an application executes a request to open a dataset.}
    property BeforeOpen;
  end;

  {$IFDEF FPC}
  {@exclude}
  const MultFactor: array[-4..4] of Double = (0.0001,0.001,0.01,0.1,0,10,100,1000,10000);
  {$ENDIF}

implementation


constructor TFBLCustomDataset.Create(AOwen: TComponent);
begin
  inherited Create(AOwen);
  FDsql := TFBLDsql.Create(nil);
  FDsql.AutoFetchFirst := False;
  FAutoStartTransaction := False;
  {$IFDEF FPC}
  FDsql.OnUnPrepare := @DoOnUnPrepare;
  FBlobs := TList.Create;
  //FisFull := False;
  {$ELSE}
  FDsql.OnUnPrepare := DoOnUnPrepare;
  {$ENDIF}
  {$IFNDEF FPC}
    {$IFDEF D6P}
  inherited SetUniDirectional(True);
    {$ENDIF}
  {$ELSE}
    {$IFDEF VER2_0}
  IsUniDirectional := True;   // required for FPC 2.0.4
    {$ELSE}
  SetUniDirectional(True);    // required for FPC 2.1.1 (r6375)
    {$ENDIF}
    {$IF defined(VER2_2) or defined(VER2_3_1)}
  SetUniDirectional(False);
    {$ENDIF}
  {$ENDIF}
end;

//------------------------------------------------------------------------------

destructor TFBLCustomDataset.Destroy;
begin
  FDsql.OnUnPrepare := nil;
  FDsql.Free;
  {$IFDEF FPC}
  EraseBlobList;
  FOffset := nil;
  FBlobs.Free;
  {$ENDIF}
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.DoOnUnPrepare(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------

function TFBLCustomDataset.GetSQL: TStrings;
begin
  Result := FDsql.SQL;
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.SetSQL(Value: TStrings);
begin
  CheckInactive;
  FDsql.SQL.Assign(Value);
end;

//------------------------------------------------------------------------------

function TFBLCustomDataset.GetTransaction: TFBLTransaction;
begin
  Result := FDsql.Transaction;
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.SetTransaction(Value: TFBLTransaction);
begin
  FDsql.Transaction := Value;
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.CheckBeforeOpen;
begin
  {
  if Fdsql.Transaction.Database = nil then
     EFBLDatasetError.Create('No Database assigned');
  }

  if FDsql.Transaction = nil then
     EFBLDatasetError.Create('No Transaction assigned');

  if FDsql.SQL.Text = ''  then
      EFBLDatasetError.Create('SQL statement is empty');

  if FAutoStartTransaction then
     if not FDsql.Transaction.InTransaction then
        Fdsql.Transaction.StartTransaction;

  FDsql.Prepare;
  if fDsql.QueryType <>  qtSelect then
     EFBLDatasetError.Create('No "SELECT" Statement type');

  if fDsql.ParamCount > 0 then
     EFBLDatasetError.Create('Query with params is not implemented yet');
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.InternalAfterOpen;
begin
   FDsql.ExecSql;
   if not FDSql.EOF then
   begin
     //Close;
     //FisFirst := True;
   end;
end;

//------------------------------------------------------------------------------
{protected}
//------------------------------------------------------------------------------

function TFBLCustomDataset.GetCanModify: Boolean;
begin
  Result := False;
end;

//------------------------------------------------------------------------------

function TFBLCustomDataset.AllocRecordBuffer: PChar;
begin
  GetMem(Result, FRecordBufferSize);
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.InternalInitRecord(Buffer: PChar);
begin
  FillChar(Buffer^, FRecordBufferSize, #0);
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.FreeRecordBuffer (var Buffer: PChar);
begin
  FreeMem (Buffer);
end;

//------------------------------------------------------------------------------

function TFBLCustomDataset.GetRecordSize: Word;
begin
   Result := FRecordSize;
end;

//------------------------------------------------------------------------------

procedure  TFBLCustomDataset.InternalOpen;
begin
  CheckBeforeOpen;
  InternalInitFieldDefs;
  if DefaultFields then
     CreateFields;
  BindFields(True);
  {$IFNDEF FPC}
  FRecordSize := SizeOf(Integer);
  {$ELSE}
  FRecordBufferSize := FRecordSize + Sizeof(TFBLBookMark);
  EraseBlobList;
  {$ENDIF}
  FIsOpen := True;
  FReload := False;
  FisEmpty := False;
  InternalAfterOpen;
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.InternalClose;
begin
   BindFields(False);
   if DefaultFields then
     DestroyFields;
   FDsql.Close;
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.InternalHandleException;
begin

end;

//------------------------------------------------------------------------------

{$IFNDEF FPC}

procedure TFBLCustomDataset.InternalFirst;
begin
  if FIsOpen then
  begin
    FDsql.First;
    FReload := True;
  end;
end;

//------------------------------------------------------------------------------

procedure  TFBLCustomDataset.InternalLast;
begin
end;

//------------------------------------------------------------------------------


procedure TFBLCustomDataset.InternalInitFieldDefs;
var
  i : Integer;
  FieldDef: TFieldDef;
begin
  FieldDefs.Clear;
  for i := 0 to FDsql.FieldCount - 1 do
  begin
    FieldDef := FieldDefs.AddFieldDef;
    FieldDef.Name := FDsql.FieldName(i);
    FieldDef.Required := not FDSql.FieldIsNullable(i);
    case FDsql.FieldType(i) of
       SQL_VARYING ,
       SQL_TEXT:
         begin
           FieldDef.DataType := ftString;
           FieldDef.Size := FDSql.FieldSize(i);
         end;

       SQL_DOUBLE,
       SQL_D_FLOAT,
       SQL_FLOAT:
           FieldDef.DataType := ftFloat;

       SQL_LONG:
           if Fdsql.FieldScale(i) <> 0 then
           begin
             if  -Fdsql.FieldScale(i) > 4 then
               FieldDef.DataType := ftFloat
             else
             begin
               {$IFDEF D6P}
               FieldDef.DataType :=   ftBCD;
               FieldDef.Size := -Fdsql.FieldScale(i);
               {$ELSE}
                 FieldDef.DataType  := ftFloat;
               {$ENDIF}
             end;
           end
           else
             FieldDef.DataType :=  ftInteger;

       SQL_INT64:
           if Fdsql.FieldScale(i) <> 0 then
           begin
             if  -Fdsql.FieldScale(i) > 4 then
             begin
               {$IFDEF D6P}
               FieldDef.DataType :=  ftFMTBcd;
               FieldDef.Size := -Fdsql.FieldScale(i);
               {$ELSE}
               FieldDef.DataType := ftFloat;
               {$ENDIF}
             end else
             begin
               {$IFDEF D6P}
               FieldDef.DataType :=   ftBCD;
               FieldDef.Size := -Fdsql.FieldScale(i);
               {$ELSE}
               FieldDef.DataType  := ftFloat;
               {$ENDIF}
             end;
           end
           else
             FieldDef.DataType  :=  ftLargeint;

       SQL_SHORT:
           if Fdsql.FieldScale(i) <> 0  then
           begin
              if  -Fdsql.FieldScale(i) > 4 then
               FieldDef.DataType := ftFloat
             else
             begin
               {$IFDEF D6P}
               FieldDef.DataType :=  ftBCD;
               FieldDef.Size := -Fdsql.FieldScale(i);
               {$ELSE}
               FieldDef.DataType  := ftFloat;
               {$ENDIF};
             end;
           end
           else
             FieldDef.DataType  :=  ftSmallint;


       SQL_TYPE_TIME:
           FieldDef.DataType := ftTime;
       SQL_TYPE_DATE:
           FieldDef.DataType := ftDate;
       SQL_TIMESTAMP:
           FieldDef.DataType := ftDateTime;
       SQL_BLOB:
       begin
         if FDsql.FieldSubType(i) = 1 then
           FieldDef.DataType := ftMemo else
           FieldDef.DataType := ftBlob;
         FieldDef.Size := SizeOf(TStream);
       end;
       SQL_ARRAY,
       SQL_QUAD:
           begin
            FieldDef.DataType := ftString;
            FieldDef.Size := 12;
           end;
       else
          FieldDef.DataType := ftUnknown;
    end;
  end;
end;

//------------------------------------------------------------------------------

function  TFBLCustomDataset.GetRecord(Buffer: PAnsiChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
begin
  //TGetResult = (grOK, grBOF, grEOF, grError);
  Result := grOk;

  case GetMode of
    gmPrior:
      if FDsql.FetchCount = 0 then Result := grBof;

    gmCurrent:
        begin
            if not FDSql.EOF then
              Result := grOk
            else
              Result := grEOF;
        end;
    gmNext:
      begin
        {$IFDEF D6M}
        if FReload then
        begin
          Result := grOk;
          FReload := False;
          Exit;
        end;
        {$ENDIF}
        if FDsql.FetchCount = 0 then
        begin
          Fdsql.Next;
          if Fdsql.EOF then
          begin
            Result := grEof;
            FisEmpty := True;
          end
          else
          begin
           FisEmpty := False;
           Result := grOk;
          end;
        end
        else
        begin
          Fdsql.Next;
          if FDsql.EOF then
          begin
            Result := grEof;
          end
          else
            Result := grOk
        end;
      end;
  end;
end;


//------------------------------------------------------------------------------

function TFBLCustomDataset.GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean;
var
 TempString:string;
 ftype,
 fscale: smallint;
begin
    Dec(FieldNo);
    Result := False;
    if FisEmpty or FDsql.EOF then Exit;

    if FDsql.FieldIsNull(FieldNo) then
      Exit;
    fscale := FDsql.FieldScale(FieldNo);
    ftype   :=  FDsql.FieldType(FieldNo);
    case ftype of
      SQL_VARYING,
      SQL_TEXT:
        begin
        TempString := FDsql.FieldAsString(FieldNo);
        Move(TempString[1],Buffer^,FDsql.FieldSize(FieldNo));
        end;
      SQL_D_FLOAT,
      SQL_FLOAT:
        PDouble(Buffer)^ := StrToFloat(FDsql.FieldAsString(FieldNo));
      SQL_DOUBLE:
        PDouble(Buffer)^ := FDsql.FieldAsDouble(FieldNo);
      SQL_LONG:
        begin
          if fscale <> 0 then
            if -fscale > 4 then
               PDouble(Buffer)^ := FDsql.FieldAsDouble(FieldNo)
            else
              {$IFDEF D6P}
              DoubleToBCD(FDsql.FieldAsDouble(FieldNo),TBcd(buffer^))
              {$ELSE}
              PDouble(Buffer)^ := FDsql.FieldAsDouble(FieldNo)
              {$ENDIF}
          else
            PInteger(Buffer)^ := FDsql.FieldAsLong(FieldNo);
        end;
      SQL_SHORT:
         if fscale <> 0 then
           if -fscale > 4 then
             PDouble(Buffer)^ := FDsql.FieldAsDouble(FieldNo)
           else
            {$IFDEF D6P}
            DoubleToBCD(FDsql.FieldAsDouble(FieldNo),TBcd(buffer^))
            {$ELSE}
            PDouble(Buffer)^ := FDsql.FieldAsDouble(FieldNo)
            {$ENDIF}
         else
            PSmallint(Buffer)^ := Smallint(FDsql.FieldAsLong(FieldNo));

      SQL_INT64:
         if fscale <> 0 then
           if -fscale > 4 then
             {$IFDEF D6P}
             DoubleToBCD(FDsql.FieldAsDouble(FieldNo),TBcd(buffer^))
             {$ELSE}
             PDouble(Buffer)^ := FDsql.FieldAsDouble(FieldNo)
             {$ENDIF}
           else
             {$IFDEF D6P}
             DoubleToBCD(FDsql.FieldAsDouble(FieldNo),TBcd(buffer^))
             {$ELSE}
             PDouble(Buffer)^ := FDsql.FieldAsDouble(FieldNo)
             {$ENDIF}
         else
            PInt64(Buffer)^ := FDsql.FieldAsInt64(FieldNo);
      SQL_BLOB:
          begin
            if Buffer <> nil then
            begin
             FDsql.BlobFieldSaveToStream(FieldNo,TStream(Buffer));
             TStream(buffer).Seek(0, soFromBeginning);
            end;
          end;
      SQL_ARRAY,
      SQL_QUAD:
        begin
           TempString := '<array>';
           Move(TempString[1],buffer^,Length(TempString));
        end;
      SQL_TYPE_TIME:
        PInteger(Buffer)^ := DateTimeToTimeStamp(FDsql.FieldAsDateTime(FieldNo)).Time;
      SQL_TYPE_DATE:
        PInteger(Buffer)^ := DateTimeToTimeStamp(FDsql.FieldAsDateTime(FieldNo)).Date;
      SQL_TIMESTAMP:
        PDouble(Buffer)^ := TimeStampToMsecs(DateTimeToTimeStamp(FDsql.FieldAsDateTime(FieldNo)));

    end;
    Result := True;
end;

{$ENDIF}


//------------------------------------------------------------------------------

function TFBLCustomDataset.GetRecordCount: LongInt;
begin
    Result :=  Fdsql.FetchCount;
end;

//------------------------------------------------------------------------------

function  TFBLCustomDataset.IsCursorOpen: boolean;
begin
   Result := FIsOpen;
end;


//------------------------------------------------------------------------------

function TFBLCustomDataset.GetFieldData(Field: TField; Buffer: Pointer): Boolean;
begin
  CheckActive;
  Result := GetFieldData(Field.FieldNo, Buffer);
end;

//------------------------------------------------------------------------------

function TFBLCustomDataset.GetRecNo: LongInt;
begin
   Result := -1;
end;

//------------------------------------------------------------------------------

function TFBLCustomDataset.CreateBlobStream(Field: TField;
  Mode: TBlobStreamMode): TStream;
begin
  if (Mode = bmRead) then
  begin
    Result := TMemoryStream.Create;
    GetFieldData(Field, Result);
  end else
    Result := nil;
end;




//------------------------------------------------------------------------------

{$IFDEF FPC}
{$I fbldataset.inc}
{$ENDIF}
end.
