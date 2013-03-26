{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit fblib_design;

interface

uses
  FBLReg, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('FBLReg', @FBLReg.Register);
end;

initialization
  RegisterPackage('fblib_design', @Register);
end.
