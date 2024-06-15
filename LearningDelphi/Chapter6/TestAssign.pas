unit TestAssign;

interface

uses
  Classes, Windows, Graphics, Rtti;

type
  TBase = class
  private
    FBitmap: TBitmap;
  public
    constructor Create;
    procedure Assign(ABase: TBase);virtual;
    function Clone: TBase; virtual;
  end;

  TDerived = class(TBase)
  private
    FPoint: TPoint;
  public
    constructor Create;overload;
    constructor Create(APoint: TPoint);overload;
    procedure Assign(ABase: TBase); override;
    function Clone: TBase; override;
  end;


procedure MainTest;

implementation

{ TBase }

procedure TBase.Assign(ABase: TBase);
begin
  if Assigned(ABase) then
  begin
    FBitmap.Assign(ABase.FBitmap);
  end;
end;

function TBase.Clone: TBase;
var
  LTemp: TBase;
begin
  LTemp := TBase.Create;
  Result := LTemp;
end;

constructor TBase.Create;
begin
  FBitmap := TBitmap.Create;
end;

{ TDerived }

procedure TDerived.Assign(ABase: TBase);
begin
  inherited;

  if ABase is TDerived then
  begin
    FPoint := TDerived(ABase).FPoint;
  end;
end;

function TDerived.Clone: TBase;
var
  LTemp: TBase;
begin
  LTemp := TDerived.Create;
  LTemp.Assign(Self);

  Result := LTemp;
end;

constructor TDerived.Create;
begin
  inherited Create;
end;

constructor TDerived.Create(APoint: TPoint);
begin
  inherited Create;
end;

procedure MainTest;
var
  LBase1: TBase;
  LBase2: TBase;
  LPoint: TPoint;
begin
  LPoint := Point(100, 200);
  LBase1 := TDerived.Create(LPoint);

  LBase2 := LBase1.Clone;

  Writeln(LBase1.ClassName);
  Writeln(LBase2.ClassName);
end;

end.
