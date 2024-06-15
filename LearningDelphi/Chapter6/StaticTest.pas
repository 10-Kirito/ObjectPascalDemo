unit StaticTest;

interface

type
  TTest = class
  private
    class var
      MAXSIZE: Integer;
  end;

procedure MainTest;

implementation

procedure MainTest;
begin
  Writeln(TTest.MAXSIZE);
end;

initialization
  TTest.MAXSIZE := 100;

end.
