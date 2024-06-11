unit GraphicBasic;

interface

uses
  Graphics, Windows;

type
  // 提前声明:
  TBasicProperty = class;
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
  FCanvas.Rectangle(FProperty.FStartPoint.X, FProperty.FStartPoint.Y,
                    FProperty.FEndPoint.X, FProperty.FEndPoint.Y);
end;

{ TGraphicBasic }
constructor TGraphicBasic.Create;
begin
  FProperty := TBasicProperty.Create();
end;

end.
