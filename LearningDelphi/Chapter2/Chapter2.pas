unit Chapter2;

interface

procedure Test1();

implementation

procedure Test1();
var
  Char1: WideChar;
  Char2: AnsiChar;
  Number: 1..100;
begin
  Char1 := '��';
  Char2 := 'z';
end;

end.
