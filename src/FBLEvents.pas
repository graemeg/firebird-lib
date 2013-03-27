{
   Firebird Library
   Open Source Library No Data Aware for direct access to Firebird
   Relational Database from Borland Delphi / Kylix and Free Pascal

   File:FBLEvents.pas
   Copyright (c) 2002-2004 Alessandro Batisti
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
@abstract(Managing database events)
@author(Alessandro Batisti <fblib@altervista.org>)
FbLib - Firebird Library @html(<br>)
FDBEvents.pas synchronous event  notification
}

unit FBLEvents;

interface

uses
  Classes, SysUtils,{$IFNDEF UNIX} Windows, {$ENDIF}
  SyncObjs, FBLDatabase, ibase_h, FBLExcept;

type
  {Occurs when firebird events manager notifies an event}
  TOnPostEvent = procedure(Sender: TObject; EventName: string; EventCount: integer) of
  object;
  {@exclude}
  TFBLThreadEvent = class;

  {@abstract(encapsulates the properties and methods for managing database events)}
  TFBLEvent = class(TComponent, IFBLDbEvent)
  private
    FDatabase: TFBLDatabase;
    FEventList: TStrings;
    FThreadEvent: TFBLThreadEvent;
    FOnPostEvent: TOnPostEvent;
    FThreadActive: boolean;
    procedure SetEventList(Value: TStrings);
    procedure SetDatabase(Value: TFBLDatabase);
    procedure CheckDatabase;
    procedure CheckEventList;
    procedure OnChangeEventList(Sender: TObject);
    procedure DoOnBeforeDisconnect;
    procedure DoOnAfterDisconnect;
    procedure DoOnDestroy;
  public
    {Create an instance  of a TFBLEvent}
    constructor Create(AOwner: TComponent); override;
    {Free up  all resources associated with this instance}
    destructor Destroy; override;
    {@exclude}
    procedure Notification(AComponent: TComponent;
      Operation: TOperation); override;
    {start to listen events notification}
    procedure Start;
    {stop to listen events notification}
    procedure Stop;
    {True if notification is listening for events}
    property Active: boolean read FThreadActive;
  published
    {List of register events}
    property EventList: TStrings read FEventList write SetEventList;
    {TFBLDatabase object where is attached current TFBLEvent instance }
    property Database: TFBLDatabase read FDatabase write SetDatabase;
    {Occurs when firebird events manager notifies an event}
    property OnPostEvent: TOnPostEvent read FOnPostEvent write FOnPostEvent;
  end;


  //Thread Class
  {@exclude}
  TFBLThreadEvent = class(TThread)
  private
    FPrepared: boolean;         //True if FEventBuffer and FResultBuffer is Allocated
    FFirstTime: boolean;        //True if First event of isc_que_events
    FEventBuffer: PChar;        //Buffer allocated by isc_event_block
    FResultBuffer: PChar;       //Buffer allocated by isc_event_block
    FBlockLength,               //Length of FEventBuffer and  FResultBuffer set by isc_event_block
    FEventID: ISC_LONG;         //Handle of current event  set by isc_que_events
    FNumberOfStock: Integer;    // number of events
    FEventPosted: Boolean;
    FOwner: TFBLEvent;
    FSignal: TEvent;
    FExceptObject: TObject;
    FExceptAddr: Pointer;
    procedure CheckException;
    procedure ShowThreadEventException;
    {$IFDEF FBL_THREADSAFE}
    procedure Lock;
    procedure UnLock;
    {$ENDIF}
    procedure ReadEvents;
    procedure AllocBlock;
    procedure QueEvents;
    procedure CancelEvents;
  protected
    procedure Execute; override;
  public
    constructor Create(AOwner:TFBLEvent);virtual;
    destructor Destroy; override;
    procedure StartThread;
  end;

  {$IFNDEF FPC}
  TFBL_event_block = function(EventBuffer, ResultBuffer: PPChar; IDCount: UShort;
    Event1, Event2, Event3, Event4, Event5, Event6, Event7, Event8, Event9,
    Event10, Event11, Event12, Event13, Event14, Event15: PChar): ISC_LONG; 
  cdecl;
  {$ENDIF}
const
  {@exclude}
  MAX_EVENTS = 15;
  {$IFDEF UNIX}
  INFINITE=$FFFFFFFF;
  {$ENDIF}

implementation

uses
  FBLConst;

constructor TFBLEvent.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FThreadActive := False;
  FThreadEvent := nil;
  FEventList := TStringList.Create;
  {$IFDEF FPC}
  TStringList(FEventList).OnChange := @OnChangeEventList;
  {$ELSE}
  TStringList(FEventList).OnChange := OnChangeEventList;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

destructor TFBLEvent.Destroy;
begin
  if  FThreadActive then Stop;
  TStringList(FEventList).OnChange := nil;
  FEventList.Free;
  if Assigned(FDatabase) then FDatabase.RemoveAttachObj(self);
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  if Operation = opRemove then
    if AComponent = FDatabase then FDatabase := nil;
  inherited Notification(AComponent, Operation);
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.DoOnBeforeDisconnect;
begin
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.DoOnAfterDisconnect;
begin
  if FThreadActive then
    Stop;
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.DoOnDestroy;
begin
  if FDatabase <> nil then FDatabase := nil;
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.SetEventList(Value: TStrings);
begin
  FEventList.Assign(Value);
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.OnChangeEventList(Sender: TObject);
begin
  if FThreadActive then
  begin
    Stop;
    Start;
  end;
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.SetDatabase(Value: TFBLDatabase);
begin
  if Assigned(Value) and (Value <> FDatabase) then
    Value.AddAttachObj(self);
  FDatabase := Value;
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.CheckDatabase;
begin
  if not Assigned(FDatabase) then
    FBLError(E_TR_DB_NOT_ASSIGNED);
  if not FDatabase.Connected then
    FBLError(E_DB_NOACTIVE_CON);
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.CheckEventList;
var
  nItem: integer;
begin
  nItem := FEventList.Count;
  if nItem = 0 then
    FBLError(E_EV_LIST_EMPTY);
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.Start;
begin
  CheckDatabase;
  CheckEventList;
  if (FThreadEvent = nil) and (FThreadActive = False) then
  begin
    FThreadEvent := TFBLThreadEvent.Create(self);
    FThreadEvent.StartThread;
    FThreadActive := True
  end;
end;

//------------------------------------------------------------------------------

procedure TFBLEvent.Stop;
begin
  if FThreadActive then
  begin
    FThreadEvent.Terminate;
    FThreadEvent.Free;
    FThreadEvent := nil;
    FThreadActive := False;
  end;
end;

//------------------------------------------------------------------------------
//   CALLBACK AST Function
//------------------------------------------------------------------------------

procedure ASTFunction(APointer: Pointer; ALength: UShort; AUpdate: PChar); cdecl;
begin
  with  TFBLThreadEvent(APointer) do
  begin
    Move(AUpdate^, FResultBuffer^, ALength);
    FEventPosted := True;
    FSignal.SetEvent;
  end;
end;

//-------------------------------------------------------------------------------
// TFBLThreadEvent
//-------------------------------------------------------------------------------

constructor TFBLThreadEvent.Create(AOwner:TFBLEvent);
begin
  inherited Create(True);
  {$IFNDEF UNIX}
  Priority := tpIdle;
  {$ENDIF}
  FOwner := AOwner;
  FreeOnTerminate := False;
  FPrepared := False;
  FEventPosted := False;
  FNumberOfStock := 0;
  FFirstTime := True;
  FEventBuffer := nil;
  FResultBuffer := nil;
  FSignal := TSimpleEvent.Create;
end;

//------------------------------------------------------------------------------

destructor TFBLThreadEvent.Destroy;
begin
  Terminate;
  FSignal.SetEvent;
  WaitFor;
  try
    CancelEvents;
    isc_free(FEventBuffer);
    isc_free(FResultBuffer);
  except
    CheckException;
  end;
  FSignal.Free;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TFBLThreadEvent.CheckException;
begin
  FExceptObject := ExceptObject;
  FExceptAddr := ExceptAddr;
  try
    if not (FExceptObject is EAbort) and (FExceptObject <> nil) then
    begin
       {$IFDEF FPC}
       Synchronize(@ShowThreadEventException);
       {$ELSE}
       Synchronize(ShowThreadEventException);
       {$ENDIF}
    end;
  finally
    FExceptObject := nil;
    FExceptAddr := nil;
    ReturnValue := 1;
  end;
end;

//------------------------------------------------------------------------------

procedure TFBLThreadEvent.ShowThreadEventException;
begin
  ShowException(FExceptObject,FExceptObject);
end;

//------------------------------------------------------------------------------

{$IFDEF FBL_THREADSAFE}
procedure TFBLThreadEvent.Lock;
begin
  if Assigned(FOwner.FDatabase) then
    FOwner.FDatabase.Lock;
end;

procedure TFBLThreadEvent.UnLock;
begin
  if Assigned(FOwner.FDatabase) then
    FOwner.FDatabase.UnLock;
end;
{$ENDIF}

//------------------------------------------------------------------------------


procedure TFBLThreadEvent.StartThread;
begin
  if Suspended then
    Resume;
end;

//------------------------------------------------------------------------------

procedure TFBLThreadEvent.QueEvents;
var
  Status_vector: ISC_STATUS_VECTOR;
begin
  {$IFDEF FBL_THREADSAFE}
  Lock;
  try
  {$ENDIF}
    if FOwner.FDatabase.Connected then
    begin
      isc_que_events(@Status_vector, FOwner.FDatabase.DBHandle, @FEventId, Short(FBlockLength),
        FEventBuffer,
        TISC_CALLBACK(@ASTFunction), PVoid(Self));
      if (Status_vector[0] = 1) and (Status_vector[1] > 0) then
        FBLShowError(@Status_vector);
    end;
  {$IFDEF FBL_THREADSAFE}
  finally
    UnLock;
  end;
  {$ENDIF}
end;

//------------------------------------------------------------------------------

procedure TFBLThreadEvent.AllocBlock;
  function EPB(AIdx: integer): PChar;
  begin
    if (AIdx < FNumberOfStock) and (FNumberOfStock > 0) then
      Result := PChar(FOwner.FEventList.Strings[AIdx])
    else
      Result := nil;
  end;
begin
    if not FPrepared then
    begin
      FBlockLength := 0;
      FNumberOfStock := FOwner.FEventList.Count;
      if FNumberOfStock > MAX_EVENTS then
        FNumberOfStock := MAX_EVENTS;
      {$IFDEF FPC}
      FBlockLength := isc_event_block(@FEventBuffer, @FResultBuffer,
        UShort(FNumberOfStock), EPB(0), EPB(1), EPB(2), EPB(3), EPB(4),
        EPB(5), EPB(6), EPB(7),
        EPB(8), EPB(9), EPB(10), EPB(11), EPB(12), EPB(13), EPB(14));
      {$ELSE}
      FBlockLength := TFBL_event_block(isc_event_block)(@FEventBuffer, @FResultBuffer,
        UShort(FNumberOfStock), EPB(0), EPB(1), EPB(2), EPB(3), EPB(4),
        EPB(5), EPB(6), EPB(7),
        EPB(8), EPB(9), EPB(10), EPB(11), EPB(12), EPB(13), EPB(14));
      {$ENDIF}
      FPrepared := True;
    end;
end;

//------------------------------------------------------------------------------

procedure TFBLThreadEvent.ReadEvents;
var
  i: integer;
  Status_vector: ISC_STATUS_VECTOR;
begin
  isc_event_counts(@Status_vector, Short(FBlockLength), FEventBuffer, FResultBuffer);
  if Assigned(FOwner.FOnPostEvent) and (not FFirstTime) then
  begin
    for i := 0 to FNumberOfStock - 1 do
    begin
      if Status_vector[i] <> 0 then
        FOwner.FOnPostEvent(Self, FOwner.FEventList.Strings[i], Status_vector[i]);
    end;
  end;
  FFirstTime := False;
end;

//------------------------------------------------------------------------------

procedure TFBLThreadEvent.CancelEvents;
var
  Status_vector: ISC_STATUS_VECTOR;
begin
    if FOwner.FDatabase.Connected then
    begin
      isc_cancel_events(@Status_vector, FOwner.FDatabase.DBHandle, @FEventId);
      if (status_vector[0] = 1) and (status_vector[1] > 0) then
        FBLShowError(@Status_vector);
    end;
end;

//------------------------------------------------------------------------------

procedure TFBLThreadEvent.Execute;
begin
  if not FPrepared then
    AllocBlock;
  FSignal.ResetEvent;
  {$IFDEF FPC}
  Synchronize(@QueEvents);
  {$ELSE}
  Synchronize(QueEvents);
  {$ENDIF}
  try
    while not Terminated do
    begin
      FSignal.WaitFor(INFINITE);
      if FEventPosted then
      begin
        {$IFDEF FPC}
        Synchronize(@ReadEvents);
        {$ELSE}
        Synchronize(ReadEvents);
        {$ENDIF}
        FEventPosted := False;
      end;
      {$IFDEF FPC}
      Synchronize(@QueEvents);
      {$ELSE}
      Synchronize(QueEvents);
      {$ENDIF}
      FSignal.ResetEvent;
    end;
    ReturnValue := 0;
  except
      CheckException;
  end;
end;

end.
