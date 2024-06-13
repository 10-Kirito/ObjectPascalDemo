unit GraphicBasic;

interface

uses
  Windows, Graphics;

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
    procedure Update(ABitmap: TBitmap; AStart: TPoint; AEnd: TPoint); virtual; abstract;
    constructor Create();
  public
    FProperty: TBasicProperty;
  private
    FCanvas: TCanvas;
    FCurrentBit: TBitmap;
    FImageBitmap: TBitmap;
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
    constructor Create(AStart: TPoint; AEnd: TPoint; ACanvas: TCanvas); overload;
    constructor Create(AStart: TPoint; AEnd: TPoint; ACurrentBit: TBitmap;
      AImageBitmap: TBitmap); overload;
    procedure Draw(); override;
    procedure Update(ABitmap: TBitmap; AStart: TPoint; AEnd: TPoint); override;
  end;
  // 矩形类:
  TRectangle = class(TGraphicBasic)
    constructor Create(AStart: TPoint; AEnd: TPoint; ACanvas: TCanvas);
    procedure Draw(); override;
    procedure Update(ABitmap: TBitmap; AStart: TPoint; AEnd: TPoint); override;
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

constructor TLine.Create(AStart, AEnd: TPoint; ACurrentBit: TBitmap;
  AImageBitmap: TBitmap);
begin
  inherited Create();
  FCurrentBit := ACurrentBit;
  FImageBitmap := AImageBitmap;
end;

procedure TLine.Draw();
begin
  FCanvas.MoveTo(FProperty.FStartPoint.X, FProperty.FStartPoint.Y);
  FCanvas.LineTo(FProperty.FEndPoint.X, FProperty.FEndPoint.Y);
end;

procedure TLine.Update(ABitmap: TBitmap; AStart: TPoint; AEnd: TPoint);
begin
  FCurrentBit.Assign(ABitmap);

  FCurrentBit.Canvas.MoveTo(AStart.X, AStart.Y);
  FCurrentBit.Canvas.LineTo(AEnd.X, AEnd.Y);

  FImageBitmap.Assign(FCurrentBit);
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

procedure TRectangle.Update(ABitmap: TBitmap; AStart: TPoint; AEnd: TPoint);
begin

end;

{ TGraphicBasic }
constructor TGraphicBasic.Create;
begin
  FProperty := TBasicProperty.Create();
end;

end.

