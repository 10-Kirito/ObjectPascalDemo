unit Commands;

interface

uses
  Generics.Collections, Classes, Windows, Graphics, GraphicReceiver, Tools;

type

  /// <summary>
  ///   抽象命令基类
  /// </summary>
  TCommand = class
  private
    FPen: TDrawPen;
    FID: TGUID;
  public
    constructor Create;
    destructor Destroy; override;

    /// <summary>在给定的Bitmap当中执行该命令</summary>
    /// <param name="ABitmap"> 给定的Bitmap</param>
    procedure Run(ABitmap: TBitmap); virtual; abstract;
  end;

  /// <summary>
  ///   绘制直线命令
  /// </summary>
  TDrawLine = class(TCommand)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create; overload;
    constructor Create(APen: TDrawPen; AStart: TPoint; AEnd: TPoint); overload;
    constructor Create(APen: TDrawPen; AStart: TPoint; AEnd: TPoint; AGUID: TGUID); overload;
    destructor Destroy;override;

    procedure Run(ABitmap: TBitmap); override;
  end;

  /// <summary>
  ///   绘制矩形命令
  /// </summary>
  TDrawRectangle = class(TCommand)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create;overload;
    constructor Create(APen: TDrawPen; AStart: TPoint; AEnd: TPoint); overload;
    constructor Create(APen: TDrawPen; AStart: TPoint; AEnd: TPoint; AGUID: TGUID);overload;
    destructor Destroy;override;

    procedure Run(ABitmap: TBitmap); override;
  end;

  /// <summary>
  ///   绘制椭圆命令
  /// </summary>
  TDrawELLIPSE = class(TCommand)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create;overload;
    constructor Create(APen: TDrawPen; AStart: TPoint; AEnd: TPoint); overload;
    constructor Create(APen: TDrawPen; AStart: TPoint; AEnd: TPoint; AGUID: TGUID);overload;
    destructor Destroy;override;

    procedure Run(ABitmap: TBitmap); override;
  end;

  /// <summary>
  ///   自由笔刷绘制命令
  /// </summary>
  TDrawBrush = class(TCommand)
  private
    FPoints: TList<TPoint>;
  public
    constructor Create;overload;
    constructor Create(APen: TDrawPen; APoints: TList<TPoint>);overload;
    constructor Create(APen: TDrawPen; APoints: TList<TPoint>; AGUID: TGUID);overload;
    destructor Destroy;override;

    procedure Run(ABitmap: TBitmap); override;
  end;

implementation

{ TDrawLine }

constructor TDrawLine.Create;
begin
  inherited Create;
end;

constructor TDrawLine.Create(APen: TDrawPen; AStart, AEnd: TPoint; AGUID: TGUID);
begin
  inherited Create;

  FID := AGUID;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FPen := TDrawPen.Create;
  FPen.Color := APen.Color;
  FPen.Width := APen.Width;
end;

constructor TDrawLine.Create(APen: TDrawPen; AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FPen := TDrawPen.Create;
  FPen.Color := APen.Color;
  FPen.Width := APen.Width;
end;

destructor TDrawLine.Destroy;
begin
  inherited;

end;

procedure TDrawLine.Run(ABitmap: TBitmap);
begin
  ABitmap.Canvas.Pen.Color := FPen.Color;
  ABitmap.Canvas.Pen.Width := FPen.Width;
  // ABitmap.Canvas.Brush.Style := bsClear;
  ABitmap.Canvas.MoveTo(FStartPoint.X, FStartPoint.Y);
  ABitmap.Canvas.LineTo(FEndPoint.X, FEndPoint.Y);
end;

constructor TCommand.Create;
begin
  inherited Create;
end;

destructor TCommand.Destroy;
begin
  FPen.Free;
end;

{ TDrawRectangle }

constructor TDrawRectangle.Create;
begin
  inherited Create;
end;

constructor TDrawRectangle.Create(APen: TDrawPen; AStart, AEnd: TPoint; AGUID: TGUID);
begin
  inherited Create;

  FID := AGUID;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FPen := TDrawPen.Create;
  FPen.Color := APen.Color;
  FPen.Width := APen.Width;
end;

constructor TDrawRectangle.Create(APen: TDrawPen; AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FPen := TDrawPen.Create;
  FPen.Color := APen.Color;
  FPen.Width := APen.Width;
end;

destructor TDrawRectangle.Destroy;
begin
  inherited;

end;


procedure TDrawRectangle.Run(ABitmap: TBitmap);
begin
  ABitmap.Canvas.Pen.Color := FPen.Color;
  ABitmap.Canvas.Pen.Width := FPen.Width;
  ABitmap.Canvas.Brush.Style := bsClear;
  ABitmap.Canvas.Rectangle(FStartPoint.X, FStartPoint.Y, FEndPoint.X,
    FEndPoint.Y);
end;
{ TDrawBrush }

constructor TDrawBrush.Create;
begin
  inherited Create;
end;

constructor TDrawBrush.Create(APen: TDrawPen; APoints: TList<TPoint>; AGUID: TGUID);
var
  LPoint: TPoint;
begin
  inherited Create;

  FID := AGUID;

  FPen := TDrawPen.Create;
  FPen.Color := APen.Color;
  FPen.Width := APen.Width;
  FPoints := TList<TPoint>.Create;

  for LPoint in APoints do
  begin
    FPoints.Add(LPoint);
  end;
end;

constructor TDrawBrush.Create(APen: TDrawPen; APoints: TList<TPoint>);
var
  LPoint: TPoint;
begin
  inherited Create;

  FPen := TDrawPen.Create;
  FPen.Color := APen.Color;
  FPen.Width := APen.Width;
  FPoints := TList<TPoint>.Create;

  for LPoint in APoints do
  begin
    FPoints.Add(LPoint);
  end;
end;

destructor TDrawBrush.Destroy;
begin
  FPoints.Free;
  inherited;
end;

procedure TDrawBrush.Run(ABitmap: TBitmap);
var
  LFirstPoint: TPoint;
  LPoint: TPoint;
  LIndex: Integer;
begin
  if FPoints.Count = 0 then
  begin
    Exit;
  end;
  ABitmap.Canvas.Brush.Style := bsClear;
  ABitmap.Canvas.Pen.Color := FPen.Color;
  ABitmap.Canvas.Pen.Width := FPen.Width;

  LFirstPoint := FPoints[0];
  ABitmap.Canvas.MoveTo(LFirstPoint.X, LFirstPoint.Y);

  for LIndex := 1 to FPoints.Count - 1 do
  begin
    LPoint := FPoints[LIndex];
    ABitmap.Canvas.LineTo(LPoint.X, LPoint.Y);
  end;
end;

{ TDrawELLIPSE }

constructor TDrawELLIPSE.Create;
begin
  inherited Create;
end;

constructor TDrawELLIPSE.Create(APen: TDrawPen; AStart, AEnd: TPoint; AGUID: TGUID);
begin
  inherited Create;

  FID := AGUID;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FPen := TDrawPen.Create;
  FPen.Color := APen.Color;
  FPen.Width := APen.Width;
end;

constructor TDrawELLIPSE.Create(APen: TDrawPen; AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FPen := TDrawPen.Create;
  FPen.Color := APen.Color;
  FPen.Width := APen.Width;
end;

destructor TDrawELLIPSE.Destroy;
begin

  inherited;
end;

procedure TDrawELLIPSE.Run(ABitmap: TBitmap);
begin
  ABitmap.Canvas.Pen.Color := FPen.Color;
  ABitmap.Canvas.Pen.Width := FPen.Width;

  ABitmap.Canvas.Brush.Style := bsClear;
  ABitmap.Canvas.Ellipse(FStartPoint.X, FStartPoint.Y, FEndPoint.X,
    FEndPoint.Y);
end;

end.

