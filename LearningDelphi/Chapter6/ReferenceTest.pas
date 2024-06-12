unit ReferenceTest;

interface

type
  TTest = class
    Name: string;
    constructor Create(AName: string);
  end;

function ChangeName(ATest: TTest; ANew: string): TTest;
procedure ShowName(ATest: TTest);
procedure MainTest();

implementation

function ChangeName(ATest: TTest; ANew: string): TTest;
begin
  ATest.Name := ANew;
  Exit(ATest);
end;

procedure ShowName(ATest: TTest);
begin
  Writeln(ATest.Name);
end;

procedure MainTest();
var
  Obj: TTest;
begin
  Obj := TTest.Create('Kirito');
  ShowName(Obj);
  ChangeName(ChangeName(Obj, 'zpf'), 'baby');
  ShowName(Obj);

end;

{ TTest }

constructor TTest.Create(AName: string);
begin
  self.Name := AName;
end;

end.
