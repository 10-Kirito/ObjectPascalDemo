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

  GUIDString := StringReplace(GUIDString, '{', '', [rfReplaceAll]);
  GUIDString := StringReplace(GUIDString, '}', '', [rfReplaceAll]);

  Writeln('Generated GUID: ', GUIDString);
end;
end.
