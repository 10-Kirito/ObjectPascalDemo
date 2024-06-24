unit Tools;

interface

uses
  Classes, Graphics, Windows, SysUtils;

type
  TDrawMode = (drawBRUSH, drawLINE, drawRECTANGLE, drawCIRCLE, drawERASE,
    drawSELECT, drawELLIPSE);

  TDrawPen = class
  private
    FColor: TColor;
    FWidth: Integer;
  public
    constructor Create;overload;
    constructor Create(AColor: TColor; AWidth: Integer);overload;

    function GetWidth: Integer;
    procedure SetWidth(AWidth: Integer);

    property PColor: TColor read FColor write FColor;
    property PWidth: Integer read GetWidth write SetWidth;
  end;

  TTools = class
  public
    // Get the drawing time!
    class function DrawTime: string;

    // Calculate the distance from a point to a line!
    class function PointToLineDistance(A: TPoint; B: TPoint; APoint: TPoint):Double;

    // Calculate the distance between two points!
    class function DistanceBetweenPoints(APoint:TPoint; BPoint: TPoint): Double;

    // 判断一个顶点是否位于区间[x1, x2]之间，x1和x2的大小不确定!
    class function IsPointInInterval(A: Integer; B: Integer; X: Integer): Boolean;

    // 判断一个顶点是否位于另外一个顶点附近
    class function IsPointCloseAnother(APoint:TPoint; Another: TPoint): Boolean;
  end;

implementation

{ TDrawPen }

constructor TDrawPen.Create;
begin
  FColor := clBlack;
  FWidth := 3;
end;

constructor TDrawPen.Create(AColor: TColor; AWidth: Integer);
begin
  FColor := AColor;
  FWidth := AWidth;
end;

function TDrawPen.GetWidth: Integer;
begin
  Exit(FWidth);
end;

procedure TDrawPen.SetWidth(AWidth: Integer);
begin
  FWidth := AWidth;
end;

{ TTools }

class function TTools.DistanceBetweenPoints(APoint, BPoint: TPoint): Double;
begin
  Result := Sqrt(Sqr(APoint.Y - BPoint.Y) + Sqr(BPoint.X - BPoint.X));
end;

class function TTools.DrawTime: string;
var
  CurrentTime: TDateTime;
begin
  CurrentTime := Now; // 获取当前日期和时间
  Result := FormatDateTime('yyyy-mm-dd-hh-nn-ss', CurrentTime);
end;

class function TTools.IsPointCloseAnother(APoint, Another: TPoint): Boolean;
var
  LDistance: Double;
begin
  LDistance := DistanceBetweenPoints(APoint, Another);

  Result := (LDistance <= 10);
end;

class function TTools.IsPointInInterval(A, B, X: Integer): Boolean;
var
  Min: Integer;
  Max: Integer;
begin
  if A <= B then
  begin
    Min := A;
    Max := B;
  end
  else
  begin
    Min := B;
    Max := A;
  end;
  if (X >= Min) and (X <= Max) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class function TTools.PointToLineDistance(A, B, APoint: TPoint): Double;
var
  x1, y1, x2, y2, x0, y0: Double;
  numerator, denominator: Double;
begin
  x1 := A.X;
  y1 := A.Y;
  x2 := B.X;
  y2 := B.Y;
  x0 := APoint.X;
  y0 := APoint.Y;

  numerator := Abs((y2 - y1) * x0 - (x2 - x1) * y0 + x2 * y1 - y2 * x1);
  denominator := Sqrt(Sqr(y2 - y1) + Sqr(x2 - x1));

  if denominator = 0 then
  begin
    Result := -1;
  end
  else
  begin
    Result := numerator / denominator;
  end;
end;

end.
