unit GraphicObject;

interface

uses
  Windows, Graphics, SysUtils, Generics.Collections, Tools;

type
  /// <summary>
  ///   图形对象的类型
  /// </summary>
  TGraphicType = (FREEHAND, LINE, RECTANGLE, ELLIPSE);

  /// <summary>
  ///   图形对象的抽象基类：
  ///   - 存储图形对象共有属性以及方法
  /// </summary>
  TGraphicObject = class
  private
    FType: TGraphicType;
    FColor: TColor;
    FWidth: Integer;

    FID: TGUID;
  public
    constructor Create;

    /// <summary> 获取当前图形对象的所有的顶点</summary>
    /// <returns> 返回一个列表</returns>
    function GetPoints: TList<TPoint>; virtual; abstract;

    /// <summary> 判断给定点是否属于当前图形对象</summary>
    /// <param name="APoint"> 传入鼠标所在的位置</param>
    function CheckPointExist(APoint: TPoint): Boolean; virtual; abstract;

    /// <summary> 在当前图形的周围绘制一个选择框</summary>
    /// <param name="ABitmap"> 传入当前Canvas对应的Bitmap</param>
    procedure DrawSelectBox(ABitmap: TBitmap); virtual; abstract;

    // functions and procedures
    procedure SetPen(APen: TDrawPen);
    function GetType: TGraphicType;
    procedure SetType(AType: TGraphicType);
    function GetColor: TColor;
    procedure SetColor(AColor: TColor);
    function GetWidth: Integer;
    procedure SetWidth(AWidth: Integer);
    function GetGUID: TGUID;

    /// <summary> 当前图形对象所对应的类型</summary>
    property GraphicType: TGraphicType read GetType write SetType;

    /// <summary> 绘制该图形对象的颜色</summary>
    property Color: TColor read GetColor write SetColor;

    /// <summary> 绘制该图形对象的宽度</summary>
    property Width: Integer read GetWidth write SetWidth;

    /// <summary> 该图形对象对应的GUID</summary>
    property GUID: TGUID read GetGUID write FID;

    /// <summary> 将图形类型转换为字符串返回</summary>
    /// <param name="AType">图形类型</param>
    class function TypeToStr(AType: TGraphicType): string;

    /// <summary> 将字符串转换为图形类型</summary>
    /// <param name="AType">字符串</param>
    class function StrToType(AString: string): TGraphicType;
  end;

  /// <summary>
  ///  线段图形对象
  /// </summary>
  TLine = class(TGraphicObject)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create(AStart: TPoint; AEnd: TPoint);
    function GetPoints: TList<TPoint>; override;
    function CheckPointExist(APoint: TPoint): Boolean;override;
    procedure DrawSelectBox(ABitmap: TBitmap);override;
  end;

  /// <summary>
  ///  矩形图形对象
  /// </summary>
  TRectangle = class(TGraphicObject)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create(AStart: TPoint; AEnd: TPoint);
    function GetPoints: TList<TPoint>; override;
    function CheckPointExist(APoint: TPoint): Boolean;override;
    procedure DrawSelectBox(ABitmap: TBitmap);override;
  end;

  /// <summary>
  ///  椭圆图形对象
  /// </summary>
  TELLIPSE = class(TGraphicObject)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create(AStart: TPoint; AEnd: TPoint);
    function GetPoints: TList<TPoint>; override;
    function CheckPointExist(APoint: TPoint): Boolean;override;
    procedure DrawSelectBox(ABitmap: TBitmap);override;
  end;

  /// <summary>
  ///  自由绘制对应的图形对象
  /// </summary>
  TFreeLine = class(TGraphicObject)
  private
    FPoints: TList<TPoint>;
  public
    constructor Create(APoints: TList<TPoint>);
    destructor Destroy; override;

    function GetPoints: TList<TPoint>; override;
    function CheckPointExist(APoint: TPoint): Boolean;override;
    procedure DrawSelectBox(ABitmap: TBitmap);override;
  end;
implementation

{ TGraphicObject }

constructor TGraphicObject.Create;
begin
  CreateGUID(FID);
end;

function TGraphicObject.GetColor: TColor;
begin
  Result := FColor;
end;

function TGraphicObject.GetGUID: TGUID;
begin
  Result := FID;
end;

function TGraphicObject.GetType: TGraphicType;
begin
  Result := FType;
end;

function TGraphicObject.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TGraphicObject.SetColor(AColor: TColor);
begin
  FColor := AColor;
end;

procedure TGraphicObject.SetPen(APen: TDrawPen);
begin
  FColor := APen.Color;
  FWidth := APen.GetWidth;
end;

procedure TGraphicObject.SetType(AType: TGraphicType);
begin
  FType := AType;
end;

procedure TGraphicObject.SetWidth(AWidth: Integer);
begin
  FWidth := AWidth;
end;

class function TGraphicObject.StrToType(AString: string): TGraphicType;
begin
  if AString = 'line' then
  begin
    Result := LINE;
  end
  else if AString = 'freehand' then
  begin
    Result := FREEHAND;
  end
  else if AString = 'rectangle' then
  begin
    Result := RECTANGLE;
  end
  else
  begin
    Result := ELLIPSE;
  end;
end;

class function TGraphicObject.TypeToStr(AType: TGraphicType): string;
begin
  case AType of
    FREEHAND:
      begin
        Result := 'freehand';
      end;
    LINE:
      begin
        Result := 'line';
      end;
    RECTANGLE:
      begin
        Result := 'rectangle';
      end;
    ELLIPSE:
      begin
        Result := 'ellipse';
      end;
  end;
end;

{ TLine }

function TLine.CheckPointExist(APoint: TPoint): Boolean;
var
  LDistance: Double;
begin
  // just need to determine the distance between the given point and the line if is zero
  //    if zero return true;
  //    else return false;
  LDistance := TTools.PointToLineDistance(FStartPoint, FEndPoint, APoint);
  Result := (LDistance < 10);
end;

constructor TLine.Create(AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FType := LINE;
end;

procedure TLine.DrawSelectBox(ABitmap: TBitmap);
var
  LWidth: Integer;
begin
  ABitmap.Canvas.Pen.Style := psDot;
  LWidth := ABitmap.Canvas.Pen.Width;
  ABitmap.Canvas.Pen.Width := 1;
  ABitmap.Canvas.Brush.Style := bsClear;
  ABitmap.Canvas.Rectangle(FStartPoint.X - 4, FStartPoint.Y - 4,
                           FEndPoint.X + 4, FEndPoint.Y + 4);
  ABitmap.Canvas.Pen.Style := psSolid;
  ABitmap.Canvas.Pen.Width := LWidth;
  ABitmap.Canvas.Brush.Style := bsSolid;
end;

function TLine.GetPoints: TList<TPoint>;
begin
  Result := TList<TPoint>.Create;
  Result.Add(FStartPoint);
  Result.Add(FEndPoint);
end;

{ TRectangle }
function TRectangle.CheckPointExist(APoint: TPoint): Boolean;
begin
  if TTools.IsPointInInterval(FStartPoint.X, FEndPoint.X, APoint.X)
    and TTools.IsPointInInterval(FStartPoint.Y, FEndPoint.Y, APoint.Y) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

constructor TRectangle.Create(AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FType := RECTANGLE;
end;

procedure TRectangle.DrawSelectBox(ABitmap: TBitmap);
var
  LWidth: Integer;
begin
  ABitmap.Canvas.Pen.Style := psDot;
  LWidth := ABitmap.Canvas.Pen.Width;
  ABitmap.Canvas.Pen.Width := 1;
  ABitmap.Canvas.Brush.Style := bsClear;
  ABitmap.Canvas.Rectangle(FStartPoint.X - 4, FStartPoint.Y - 4,
                           FEndPoint.X + 4, FEndPoint.Y + 4);
  ABitmap.Canvas.Pen.Style := psSolid;
  ABitmap.Canvas.Pen.Width := LWidth;
  ABitmap.Canvas.Brush.Style := bsSolid;
end;

function TRectangle.GetPoints: TList<TPoint>;
begin
  Result := TList<TPoint>.Create;
  Result.Add(FStartPoint);
  Result.Add(FEndPoint);
end;


{ TFreeLine }

function TFreeLine.CheckPointExist(APoint: TPoint): Boolean;
var
  Another: TPoint;
begin
  for Another in FPoints do
  begin
    if TTools.IsPointCloseAnother(Another, APoint) then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

constructor TFreeLine.Create(APoints: TList<TPoint>);
var
  LPoint: TPoint;
begin
  inherited Create;

  FPoints := TList<TPoint>.Create;
  if Assigned(APoints) then
  begin
    for LPoint in APoints do
    begin
      FPoints.Add(LPoint);
    end;
  end;

  FType := FREEHAND;
end;

destructor TFreeLine.Destroy;
begin
  FreeAndNil(FPoints);
end;

procedure TFreeLine.DrawSelectBox(ABitmap: TBitmap);
var
  StartPoint: TPoint;
  EndPoint: TPoint;
  LWidth: Integer;
begin
  StartPoint := FPoints.First;
  EndPoint := FPoints.Last;
  ABitmap.Canvas.Pen.Style := psDot;
  LWidth := ABitmap.Canvas.Pen.Width;
  ABitmap.Canvas.Pen.Width := 1;
  ABitmap.Canvas.Brush.Style := bsClear;
  ABitmap.Canvas.Rectangle(StartPoint.X - 4, StartPoint.Y - 4,
                           EndPoint.X + 4, EndPoint.Y + 4);
  ABitmap.Canvas.Pen.Style := psSolid;
  ABitmap.Canvas.Pen.Width := LWidth;
  ABitmap.Canvas.Brush.Style := bsSolid;
end;

function TFreeLine.GetPoints: TList<TPoint>;
var
  LPoint: TPoint;
begin
  Result := TList<TPoint>.Create;

  for LPoint in FPoints do
  begin
    Result.Add(LPoint);
  end;
end;

{ TELLIPSE }

function TELLIPSE.CheckPointExist(APoint: TPoint): Boolean;
var
  h, k: Double;
  a, b: Double;
  x, y: Double;
  EquationValue: Double;
begin
  // 计算椭圆的中心点
  h := (FStartPoint.X + FEndPoint.X) / 2;
  k := (FStartPoint.Y + FEndPoint.Y) / 2;

  // 计算椭圆的水平半轴长度和垂直半轴长度
  a := Abs(FEndPoint.X - FStartPoint.X) / 2;
  b := Abs(FEndPoint.Y - FStartPoint.Y) / 2;

  // 将给定点转换为双精度浮点数
  x := APoint.X;
  y := APoint.Y;

  // 计算椭圆方程值
  EquationValue := Sqr((x - h) / a) + Sqr((y - k) / b);
  // 判断点是否在椭圆内
  Result := EquationValue <= 1;
end;

constructor TELLIPSE.Create(AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FType := RECTANGLE;
end;

procedure TELLIPSE.DrawSelectBox(ABitmap: TBitmap);
var
  LWidth: Integer;
begin
  ABitmap.Canvas.Pen.Style := psDot;
  LWidth := ABitmap.Canvas.Pen.Width;
  ABitmap.Canvas.Pen.Width := 1;
  ABitmap.Canvas.Brush.Style := bsClear;
  ABitmap.Canvas.Rectangle(FStartPoint.X - 4, FStartPoint.Y - 4,
                           FEndPoint.X + 4, FEndPoint.Y + 4);
  ABitmap.Canvas.Pen.Style := psSolid;
  ABitmap.Canvas.Pen.Width := LWidth;
  ABitmap.Canvas.Brush.Style := bsSolid;
end;

function TELLIPSE.GetPoints: TList<TPoint>;
begin
  Result := TList<TPoint>.Create;
  Result.Add(FStartPoint);
  Result.Add(FEndPoint);
end;

end.

