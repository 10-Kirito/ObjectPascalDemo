unit Chapter4;
// 测试Routine的参数和返回值

interface

procedure ChangeNumber(var ANumber: Integer);
procedure ValuePass(ANumber: Integer);
procedure Test();

implementation

procedure ChangeNumber(var ANumber: Integer);
begin
  ANumber := 100;
end;

procedure ValuePass(ANumber: Integer);
begin
  ANumber := 300;  
end;

procedure Test();
var 
  Number: Integer;
begin 
  Number := 200;
  Writeln('The number before is ', Number);
  ChangeNumber(Number);
  Writeln('The number after is ', Number);
  ValuePass(Number);
  Writeln('The number after is ', Number);
end;

end.
