unit TestBaseClass;

interface

type
  Base = class
  public
    a: Integer;
  end;

  Derived = class(Base)
  public
    b: Integer;
  public
    constructor Create(temp: Integer);
  end;

procedure MainTest;

implementation

procedure MainTest;
var
  Test: Derived;
  Test2: Base;
begin
  Test := Derived.Create(100);
  Test.a := 20;

  Test2 := Test;

  writeln(Derived(Test2).b);
end;

{ Derived }

constructor Derived.Create(temp: Integer);
begin
  b := temp;
end;

end.
