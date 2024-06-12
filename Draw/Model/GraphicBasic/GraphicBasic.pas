unit GraphicBasic;

interface

uses
  Graphics, Windows;

type
  TBasicProperty = class;

  IShape = Interface
    ['{02A3BA50-49FA-41B8-A4E1-BA79876288FB}']
    procedure SetProperty(AProperty: TBasicProperty);
    function GetProperty(): TBasicProperty;
    // property ShapeProperty: TBasicProperty;
  end;




  IDrawObject = Interface
    ['{C743A44E-5198-4C15-BE80-18241BB0FC53}']
  end;



  // 提前声明:
  // BasicProperty = class;
  // 抽象基类:
  TGraphicBasic = class
    procedure Draw(); virtual; abstract;
    constructor Create();
  public
    FProperty: TBasicProperty;
  private
    FCanvas: TCanvas;
  end;
  // 属性类:
  TBasicProperty = class
    // pen settings
    FColor: TColor;
    FWidth: Integer;
    // positions
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  end;
  // 直线类:
  TLine = class(TGraphicBasic)
    constructor Create(AStart: TPoint; AEnd: TPoint; ACanvas: TCanvas);
    procedure Draw(); override;
  end;
  // 矩形类:
  TRectangle = class(TGraphicBasic)
    constructor Create(AStart: TPoint; AEnd: TPoint; ACanvas: TCanvas);
    procedure Draw(); override;
  end;

implementation
{ TLine }
constructor TLine.Create(AStart: TPoint; AEnd: TPoint; ACanvas: TCanvas);
var
  Pen: TPen;
begin
  inherited Create();
  FProperty.FStartPoint := AStart;
  FProperty.FEndPoint := AEnd;
  FCanvas := ACanvas;
end;

procedure TLine.Draw();
begin
  FCanvas.MoveTo(FProperty.FStartPoint.X, FProperty.FStartPoint.Y);
  FCanvas.LineTo(FProperty.FEndPoint.X, FProperty.FEndPoint.Y);
end;

{ TRectangle }
constructor TRectangle.Create(AStart: TPoint; AEnd: TPoint; ACanvas: TCanvas);
begin
  inherited Create();
  FProperty.FStartPoint := AStart;
  FProperty.FEndPoint := AEnd;
  FCanvas := ACanvas;
end;

procedure TRectangle.Draw();
begin
  FCanvas.Rectangle(FProperty.FStartPoint.X, FProperty.FStartPoint.Y, FProperty.FEndPoint.X, FProperty.FEndPoint.Y);
end;

{ TGraphicBasic }
constructor TGraphicBasic.Create;
begin
  FProperty := TBasicProperty.Create();
end;

end.

