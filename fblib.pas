{ Questo file è stato creato automaticamente da Lazarus. Da non modificare!
Questo sorgente viene usato solo per compilare ed installare il pacchetto.
 }

unit fblib; 

interface

uses
  FBLDatabase, FBLTransaction, FBLDsql, FBLMetadata, FBLScript, FBLService, 
    FBLEvents, FBLParamDsql, FBLReg, FBLConst, FBLExcept, FBLHtmlExport, 
    FBLmixf, FBLTableToSqlScriptExport, FBLTextGridExport, ibase_h, iberror_h, 
    FBLDataset, LazarusPackageIntf; 

implementation

procedure Register; 
begin
  RegisterUnit('FBLReg', @FBLReg.Register); 
end; 

initialization
  RegisterPackage('fblib', @Register); 
end.
