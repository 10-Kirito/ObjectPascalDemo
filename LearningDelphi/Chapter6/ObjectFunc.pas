unit ObjectFunc;

interface

type
  TTestFunc = class(TObject)
    procedure F1; virtual;
  end;

  TTestFunc2 = class(TTestFunc)
    procedure F1; override;
  end;

  TTestFunc3 = class(TTestFunc)
    procedure F1; override;
  end;

procedure MainTest();

implementation

procedure TTestFunc.F1;
begin
  Writeln('TTestFunc.F1 is called!');
end;

procedure TTestFunc2.F1;
begin
  Writeln('TTestFunc2.F1 is called!');
end;

procedure TTestFunc3.F1;
begin
  Writeln('TTestFunc3.F1 is called!');
end;

procedure MainTest();
var
  Obj: TTestFunc;
  Obj1: TTestFunc;
  Obj2: TTestFunc;
begin
  Obj := TTestFunc.Create();
  Obj.F1();
  Obj1 := TTestFunc2.Create();
  Obj1.F1();
  Obj2 := TTestFunc3.Create();
  Obj2.F1();
end;
end.
