{implementation of FBLDataset in free Pascal}

procedure TFBLCustomDataset.InternalInitFieldDefs;
var
  i : Integer;
  FieldDef: TFieldDef;
  mSize,TmpOffset:Integer;
begin
  FieldDefs.Clear;
  FRecordSize := 0;
  SetLength(FOffset,FDsql.FieldCount);
  TmpOffset := 0;
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
           mSize := FieldDef.Size;
         end;

       SQL_DOUBLE,
       SQL_D_FLOAT,
       SQL_FLOAT:
           begin
             FieldDef.DataType := ftFloat;
             mSize := Sizeof(Double);
           end;
           
       SQL_LONG:
           if Fdsql.FieldScale(i) <> 0 then
           begin
             if Fdsql.FieldScale(i) >= -4  then
             begin
               FieldDef.DataType := ftBCD;
               FieldDef.Size := -Fdsql.FieldScale(i);
               mSize := SizeOf(LongInt);
             end else
             begin
               FieldDef.DataType := ftFloat;
               mSize := Sizeof(Double);
             end;
           end else
           begin
             FieldDef.DataType :=  ftInteger;
             mSize := Sizeof(LongInt);
           end;

       SQL_INT64:
           if Fdsql.FieldScale(i) <> 0  then
           begin
             if Fdsql.FieldScale(i) >= -4  then
             begin
               FieldDef.DataType := ftBCD;
               FieldDef.Size := -Fdsql.FieldScale(i);
               mSize := Sizeof(Int64);
             end else
             begin
               FieldDef.DataType  :=  ftFloat;
               mSize := Sizeof(Double);
             end;
           end
           else
           begin
             FieldDef.DataType  :=  ftLargeint;
             mSize := Sizeof(Int64);
           end;

       SQL_SHORT:
           if Fdsql.FieldScale(i) <> 0  then
           begin
             if Fdsql.FieldScale(i) >= -4  then
             begin
               FieldDef.DataType := ftBCD;
               FieldDef.Size := -Fdsql.FieldScale(i);
               mSize := SizeOf(Smallint);
             end else
             begin
               FieldDef.DataType  :=  ftFloat;
               mSize := Sizeof(Double);
             end;
           end else
           begin
             FieldDef.DataType  :=  ftSmallint;
             mSize := Sizeof(Smallint);
          end;

       SQL_TYPE_TIME:
         begin
           FieldDef.DataType := ftTime;
           mSize := Sizeof(Integer);
         end;
       SQL_TYPE_DATE:
          begin
           FieldDef.DataType := ftDate;
           mSize := Sizeof(Integer);
          end;
       SQL_TIMESTAMP:
         begin
           FieldDef.DataType := ftDateTime;
           mSize := Sizeof(Double);
         end;
       SQL_BLOB:
         begin
           if FDsql.FieldSubType(i) = 1 then
             FieldDef.DataType := ftMemo else
             FieldDef.DataType := ftBlob;
           FieldDef.Size := SizeOf(Pointer);
           mSize := SizeOf(Pointer);
         end;
       SQL_ARRAY,
       SQL_QUAD:
           begin
            FieldDef.DataType := ftString;
            FieldDef.Size := 12;
            mSize := FieldDef.Size;
           end;
       else
          FieldDef.DataType := ftUnknown;
    end;
    Inc(FRecordSize,mSize + Sizeof(Boolean));
    FOffSet[i] := TmpOffSet;
    Inc(TmpOffSet,mSize + Sizeof(Boolean));
  end;
end;


//------------------------------------------------------------------------------

procedure TFBLCustomDataset.DataToBuffer(var ABuffer: PChar);
var
  i: Integer;
  TempStr: string;
  bData,
  bIsNull: PChar;
  st: TStream;

  function FixNumericValue(AValue: Double; AScale : Integer) : Double;
  var
   FormStr: string;
  begin
   FormStr :=  '%.' + IntToStr(Abs(AScale)) + 'f';
   Result := StrToFloat(Format(FormStr,[AValue]));
  end;
  
begin
  for i := 0 to FDsql.FieldCount - 1 do
  begin
    bIsNull :=  ABuffer +  FOffSet[i];
    bData :=  ABuffer  + FOffSet[i] + SizeOf(Boolean);
    
    if  FDsql.FieldIsNull(i) then
       PBoolean(bIsNull)^ := True
    else
       PBoolean(bIsNull)^ := False;

    case FDsql.FieldType(i) of
       SQL_VARYING,
       SQL_TEXT:
         begin
          TempStr := FDsql.FieldAsString(i);
          if TempStr <> '' then
            Move(TempStr[1],(bData)^,FDsql.FieldSize(i))
          else
            Move('',(bData)^,FDsql.FieldSize(i));
          end;
       SQL_D_FLOAT,
       SQL_FLOAT:
          PDouble(bData)^ := StrToFloat(FDsql.FieldAsString(i));
       SQL_DOUBLE:
           PDouble(bData)^ := FDsql.FieldAsDouble(i);
       SQL_LONG:
         begin
           if FDsql.FieldScale(i) <> 0 then
             if FDsql.FieldScale(i) >= -4 then
               PLongInt(bData)^ := PLongInt(FDSql.FieldAsXSQLVAR(i).sqldata)^
             else
               PDouble(bData)^ := FDsql.FieldAsDouble(i)
           else
             PInteger(bData)^ :=  FDsql.FieldAsLong(i);
         end;

       SQL_SHORT:
          begin
           if FDsql.FieldScale(i) <> 0 then
             if FDsql.FieldScale(i) >= -4 then
               PSmallInt(bData)^ := PSmallInt(FDSql.FieldAsXSQLVAR(i).sqldata)^
             else
               PDouble(bData)^ := FDsql.FieldAsDouble(i)
           else
             PSmallint(bData)^ :=  Smallint(FDsql.FieldAsInteger(i));
         end;

       SQL_INT64:
          begin
           if FDsql.FieldScale(i) <> 0 then
            if FDsql.FieldScale(i) >= -4 then
               PInt64(bData)^ := PInt64(FDSql.FieldAsXSQLVAR(i).sqldata)^
             else
               PDouble(bData)^ := FixNumericValue(FDsql.FieldAsDouble(i),FDsql.FieldScale(i))
           else
             PInt64(bData)^ :=  FDsql.FieldAsInt64(i);
          end;
          
       SQL_BLOB:
          begin
            if  not FDsql.FieldIsNull(i) then
            begin
              St := TMemoryStream.Create;
              PPointer(bData)^ := Pointer(st);
              //FBlobs.Add(St);
              AddToBlobList(st);
              FDsql.BlobFieldSaveToStream(i,st);
              //ShowMessage('datatobuffer blob size : ' + IntToStr(st.Size) );
              st.Seek(0,soFromBeginning);
              //ShowMessage(IntToStr(TStream(bData).Size));
            end else
            begin
              Pointer(BData) := nil;
              FBlobs.Add(nil);
            end;
          end;
          
       SQL_QUAD,
       SQL_ARRAY:
          begin
            TempStr := '<array>';
            Move(TempStr[1],(bData)^,Length(TempStr));
          end;

       SQL_TYPE_TIME:
            PInteger(bData)^ := DateTimeToTimeStamp(FDsql.FieldAsDateTime(i)).Time;
            
       SQL_TYPE_DATE:
            PInteger(bData)^ := DateTimeToTimeStamp(FDsql.FieldAsDateTime(i)).Date;
            
       SQL_TIMESTAMP:
            PDouble(bData)^ := TimeStampToMsecs(DateTimeToTimeStamp(FDsql.FieldAsDateTime(i)));
    end;
  end;
end;

//------------------------------------------------------------------------------

function TFBLCustomDataset.GetFieldData(FieldNo: Integer; Buffer: Pointer): Boolean;
var
 TempString:string;
 ftype,
 fscale: Smallint;
 pIsNull,
 pTemp: Pointer;
 st: TStream;
begin
    Dec(FieldNo);
    Result := False;
    if FisEmpty or Eof then Exit;
    //if Fdsql.FetchCount = 0 then Exit;
    pIsNull := ActiveBuffer + FOffset[FieldNo];
    pTemp := ActiveBuffer + FOffset[FieldNo] + SizeOf(Boolean);
    if Boolean(pIsNull^) then
      Exit;

    fscale := FDsql.FieldScale(FieldNo);
    ftype   :=  FDsql.FieldType(FieldNo);


    case ftype of
      SQL_VARYING,
      SQL_TEXT:
        begin
          Move((pTemp)^,Buffer^,FDsql.FieldSize(FieldNo));
        end;
      SQL_D_FLOAT,
      SQL_DOUBLE,
      SQL_FLOAT:
        PDouble(Buffer)^ := Double(pTemp^);
      SQL_LONG:
        begin
          if fscale <> 0 then
            if  fscale >= -4 then
              PCurrency(Buffer)^ := FloatToCurr(Integer(pTemp^) *  MultFactor[fscale])
              //PCurrency(Buffer)^ := 1.87
            else
              PDouble(Buffer)^ := Double(pTemp^)
          else
            PInteger(Buffer)^ := Integer(pTemp^);
        end;
      SQL_SHORT:
         if fscale <> 0 then
           if fscale >= -4 then
                //PCurrency(Buffer)^ := 1.87
                PCurrency(Buffer)^ := FloatToCurr(SmallInt(pTemp^) * MultFactor[fscale])
            else
              PDouble(Buffer)^ := Double(pTemp^)
         else
            PSmallint(Buffer)^ := Smallint(pTemp^);

      SQL_INT64:
         if fscale <> 0 then
           if  fscale >= -4 then
               PCurrency(Buffer)^ := FloatToCurr(Int64(pTemp^) *  MultFactor[fscale])
               //PCurrency(Buffer)^ := 1.8
            else
              PDouble(Buffer)^ := Double(pTemp^)
         else
            PInt64(Buffer)^ := Int64(pTemp^);

      SQL_BLOB:
          begin
            //ShowMessage('get blob  field  ' + IntToStr(Integer(Pointer(Ptemp^))));
            st := TStream(Pointer(Ptemp^));
            // not implemented yet
            //TempString := '<blob>';
            //move(pTemp^,buffer^,Length(TempString));

            //ShowMessage(IntToStr(st.Size));
            TStream(buffer).CopyFrom(st,st.Size);
            TStream(buffer).Seek(0, soFromBeginning);
          end;
      SQL_ARRAY,
      SQL_QUAD:
        begin
           TempString := '<array>';
           Move(pTemp^,buffer^,Length(TempString));
        end;
      SQL_TYPE_TIME:
        PInteger(Buffer)^ :=Integer(pTemp^);
      SQL_TYPE_DATE:
        PInteger(Buffer)^ := Integer(pTemp^);
      SQL_TIMESTAMP:
        PDouble(Buffer)^ := Double(pTemp^);
    end;
    Result := True;
    //FIsFull := GetEof();
end;

//------------------------------------------------------------------------------


procedure TFBLCustomDataset.InternalFirst;
begin
  //ShowMessage('internalFirst');

  if FIsOpen then
  begin
    EraseBlobList;
    FDsql.Close;
    FDsql.ExecSQL;
    FReload := True;
  end;
end;

//------------------------------------------------------------------------------


procedure  TFBLCustomDataset.InternalLast;
begin
  self.CheckBiDirectional;
  //EFBLDatasetError.Create('not allowed in unidiretional dataset');
end;


function  TFBLCustomDataset.GetRecord(Buffer: PChar; GetMode: TGetMode; DoCheck: Boolean): TGetResult;
{var
  fc: Integer;}
begin
  //TGetResult = (grOK, grBOF, grEOF, grError);
  Result := grOk;
  FRecordCount := FDsql.FetchCount;

  case GetMode of
      gmPrior:
        Result := grError;
        
      gmNext:
      begin
        if FRecordCount = 0 then
        begin
          FDSQL.Next;
          if Fdsql.EOF then
          begin
            FIsEmpty := True;
            Result := grEOF;
          end
          else
          begin
            DataToBuffer(buffer);
            PFBLBookMark(buffer + FRecordSize)^.BookMarkFlag := bfCurrent;
            Result := grOk;
          end;
        end;

        if FRecordCount > 0 then
        begin
          {
          if FReload then
          begin
           FReload := False;
           Exit;
          end;
          }
          FDSQL.Next;
          

          if FDsql.EOF then
            Result := grEOF
          else
            begin
              Inc(FCurrentRecord);
              DataToBuffer(buffer);
              PFBLBookMark(buffer + FRecordSize)^.BookMarkFlag := bfCurrent;
              Result := grOk;
            end;
        end;
      end;
      
      gmCurrent:
      begin
          if Fdsql.EOF then
            Result := grEOF
          else
          begin
            Result := grOK;
            DataToBuffer(buffer);
          end;
      end;
  end;
end;

//------------------------------------------------------------------------------



//------------------------------------------------------------------------------

procedure TFBLCustomDataset.InternalGotoBookmark(aBookmark: Pointer);
var
  bk: Integer;
begin
  bk := Integer(aBookmark^);
  FCurrentRecord := bk;
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.GetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  Integer(Data^) := PFBLBookmark(Buffer+FRecordSize)^.BookMark;
end;

//------------------------------------------------------------------------------

function TFBLCustomDataset.GetBookmarkFlag(Buffer: PChar): TBookmarkFlag;
begin
   Result := PFBLBookmark(Buffer + FrecordSize)^.BookMarkFlag;
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.InternalSetToRecord(Buffer: Pchar);
var
  bk:integer;
begin
  bk := PFBLBookmark(Buffer + FRecordSize)^.BookMark;
  InternalGoToBookmark(@bk);
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.SetBookmarkData(Buffer: PChar; Data: Pointer);
begin
  PFBLBookmark(Buffer + FRecordSize)^.BookMark := Integer(Data^);
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.SetBookmarkFlag(Buffer: PChar;
  Value: TBookmarkFlag);
begin
  PFBLBookmark(Buffer + FRecordSize)^.BookmarkFlag := Value;
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.EraseBlobList;
var
  i: integer;
begin
  for i := 0 to FBlobs.Count -1 do
   if Fblobs.Items[i] <> nil then
    TStream(Fblobs.Items[i]).Free;
  FBlobs.Clear;
end;

//------------------------------------------------------------------------------

procedure TFBLCustomDataset.AddToBlobList(APointer: Pointer);
var
  i,
  BlobListLimit: Integer;
begin
  BlobListLimit := BufferCount * BlobFieldCount;
  if BlobListLimit = FBlobs.Count then
  begin
    for i := 0 to  BlobFieldCount - 1 do
    begin
     if FBlobs.First <> nil then
       TStream(FBlobs.First).Free;
     FBlobs.Delete(0);
    end;
  end;
  FBlobs.Add(APointer);
end;

//------------------------------------------------------------------------------
{
function TFBLCustomDataset.GetBufferListCount: Integer;
begin
  Result := FBlobs.Count;
end;
}
//------------------------------------------------------------------------------



