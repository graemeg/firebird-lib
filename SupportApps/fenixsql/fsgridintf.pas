unit fsgridintf;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils; 
  
function FormatNumericValue(AValue: Double; AScale : Integer) : string;

implementation

function FormatNumericValue(AValue: Double; AScale : Integer) : string;
var
  FormStr: string;
begin
  if AScale < 0 then
  begin
     FormStr :=  '%.' + IntToStr(Abs(AScale)) + 'f';
     Result := Format(FormStr,[AValue]);
  end
  else
    Result := FloatToStr(AValue);
end;

end.

