unit GenerateGUID;

interface

uses
  SysUtils;

procedure MainTest();

implementation

procedure MainTest();
var
  GUID: TGUID;
  GUIDString: string;
begin
  CreateGUID(GUID);
  GUIDString := GUIDToString(GUID);
  Writeln('Generated GUID: ', GUIDString);
end;
end.
