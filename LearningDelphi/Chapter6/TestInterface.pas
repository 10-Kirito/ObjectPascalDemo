unit TestInterface;

interface

uses
  Classes;

type

  ITest = interface
    function Calculater: Integer;
  end;

  TCalu = class(TInterfacedPersistent, ITest)
    function Calculater: Integer;
  end;

procedure Main;



implementation

{ TCalu }

function TCalu.Calculater: Integer;
begin

end;

procedure Main;
var
  Ltest:  ITest;
begin
  Ltest := TCalu.Create;
  Ltest.Calculater;
end;

end.
