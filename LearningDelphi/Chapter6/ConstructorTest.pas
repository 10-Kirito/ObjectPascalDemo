unit ConstructorTest;

interface

type
  TTest = class
  public
    constructor Create;
  end;

  TDerived = class(TTest)

  end;


procedure MainTest;

implementation

{ TTest }

constructor TTest.Create;
begin
  Writeln('TTest.Create is created!');
end;

procedure MainTest;
var
  Local: TTest;
begin
  Local := TDerived.Create;
end;

end.
