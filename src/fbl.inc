{$IFDEF VER120}      //delphi 4
  {$DEFINE D6M}
  {$DEFINE D6MFPC}
{$ENDIF}

{$IFDEF VER130}     // delphi 5
  {$DEFINE D6M}
  {$DEFINE D6MFPC}
{$ENDIF}

{$IFDEF VER140}     //delphi 6
  {$DEFINE D6P}
{$ENDIF}

{$IFDEF VER145}     //kylix
  {$DEFINE D6P}
{$ENDIF}

{$IFDEF VER150}
  {$DEFINE D6P}
{$ENDIF}

{$IFDEF VER180}    // turbo delphi 2006
  {$DEFINE D6P}
{$ENDIF}

{$IFDEF FPC}
  //{$MODE DELPHI}
  {$mode objfpc}{$H+}
  {$DEFINE D6MFPC}
{$ENDIF} 

{$IFDEF LINUX}
  {$IFNDEF UNIX}
    {$DEFINE UNIX}
  {$ENDIF}
{$ENDIF}

//enamble this switch for Interbase version < 6.0
//{$DEFINE FBL_IB5} 

//enable to switch to Interbase 6 or Firebird 1.0.x under Linux with Free Pascal
//{$DEFINE LIBCRYPT}

//enable this switch with Free Pascal < 1.9.8
//{$DEFINE FPC_INFD}


//enable this switch for thread-safe feature for classes TFBLDatabase,TFBLTransaction,TFBDSql
//{$DEFINE FBL_THREADSAFE}
