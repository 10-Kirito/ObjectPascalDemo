unit GraphicObject;

interface

uses
  Windows, Graphics, SysUtils, Generics.Collections, Tools;

type
  TGraphicType = (FREEHAND, LINE, RECTANGLE, ELLIPSE);

  TGraphicObject = class
  private
    FType: TGraphicType;
    FColor: TColor;
    FWidth: Integer;

    FID: TGUID;
    FRelavantObjs: TList<TGUID>;
  public
    // constructor and destructor
    constructor Create;
    // get all points of the graphic
    function GetPoints: TList<TPoint>; virtual; abstract;
    // check the point if exist in the graphic
    function CheckPointExist(APoint: TPoint): Boolean; virtual; abstract;

    // draw a select box
    procedure DrawSelectBox(ABitmap: TBitmap); virtual; abstract;

    procedure SetPen(APen: TDrawPen);

    // functions and procedures
    function GetType: TGraphicType;
    procedure SetType(AType: TGraphicType);
    function GetColor: TColor;
    procedure SetColor(AColor: TColor);
    function GetWidth: Integer;
    procedure SetWidth(AWidth: Integer);
    function GetGUID: TGUID; // will created in the Create; only for read;

    // properties
    property PType: TGraphicType read GetType write SetType;
    property PColor: TColor read GetColor write SetColor;
    property PWidth: Integer read GetWidth write SetWidth;
    property PGUID: TGUID read GetGUID write FID;
  end;

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

function TypeToStr(AType: TGraphicType): string;

function StrToType(AString: string): TGraphicType;

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
  FColor := APen.PColor;
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

function TypeToStr(AType: TGraphicType): string;
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

function TELLIPSE.GetPoints: TList<TPoint>;
begin
  Result := TList<TPoint>.Create;
  Result.Add(FStartPoint);
  Result.Add(FEndPoint);
end;

function StrToType(AString: string): TGraphicType;
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
  else if AString = 'ellipse' then
  begin
    Result := ELLIPSE;
  end;
end;

end.

