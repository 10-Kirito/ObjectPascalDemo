unit Tools;

interface

uses
  Classes, Graphics, Windows, SysUtils;

type
  /// <summary>
  ///   全局绘制模式：
  ///   - 用来判断当前的绘制状态
  /// </summary>
  TDrawMode = (drawBRUSH, drawLINE, drawRECTANGLE, drawCIRCLE, drawERASE,
    drawSELECT, drawELLIPSE);

  /// <summary>
  ///   自定义画笔：
  ///   - 其中只包含属性FColor以及FWidth
  /// </summary>
  TDrawPen = class
  private
    FColor: TColor;
    FWidth: Integer;
  public
    constructor Create;overload;
    constructor Create(AColor: TColor; AWidth: Integer);overload;
    function GetWidth: Integer;
    procedure SetWidth(AWidth: Integer);
    property Color: TColor read FColor write FColor;
    property Width: Integer read GetWidth write SetWidth;
  end;

  /// <summary>
  ///   全局辅助函数类：
  ///   - 该类当中具有若干个类工具函数用来辅助其余的函数
  /// </summary>
  TTools = class
  public
    /// <summary> 获取当前的时间</summary>
    /// <returns> 返回值为'yyyy-mm-dd-hh-nn-ss'格式的字符串</returns>
    class function DrawTime: string;

    /// <summary> 计算点到线段的距离</summary>
    /// <param name="A">线段的端点A</param>
    /// <param name="B">线段的端点B</param>
    /// <param name="APoint">需要计算的顶点APoint</param>
    /// <returns>返回相应的距离</returns>
    class function PointToLineDistance(A: TPoint; B: TPoint; APoint: TPoint):Double;

    /// <summary>计算两点之间的距离</summary>
    /// <param name="APoint">其中一个顶点</param>
    /// <param name="BPoint">另外一个顶点</param>
    /// <returns>返回相应的距离</returns>
    class function DistanceBetweenPoints(APoint:TPoint; BPoint: TPoint): Double;

    /// <summary>判断一个整数X是否位于区间[A, B]之间，X和B的大小不确定</summary>
    /// <param name="A"></param>
    /// <param name="B"></param>
    /// <param name="X"></param>
    /// <returns>如果位于的话，返回True, 反之返回False</returns>
    class function IsPointInInterval(A: Integer; B: Integer; X: Integer): Boolean;

    /// <summary>判断一个顶点是否位于另外一个顶点附近</summary>
    /// <param name="APoint">顶点A</param>
    /// <param name="Another">另外一个顶点</param>
    /// <returns>如果两点之间的距离小于10，返回True, 否则返回False</returns>
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
