unit Commands;

interface

uses
  Generics.Collections, Classes, Windows, Graphics, GraphicReceiver, Tools;

type
  TCommand = class
  private
    FPen: TDrawPen;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Run(ABitmap: TBitmap); virtual; abstract;
  end;

  TDrawLine = class(TCommand)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create; overload;
    constructor Create(APen: TDrawPen; AStart: TPoint; AEnd: TPoint); overload;
    destructor Destroy;override;

    procedure Run(ABitmap: TBitmap); override;
  end;

  TDrawRectangle = class(TCommand)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create;overload;
    constructor Create(APen: TDrawPen; AStart: TPoint; AEnd: TPoint);overload;
    destructor Destroy;override;

    procedure Run(ABitmap: TBitmap); override;
  end;

  TDrawBrush = class(TCommand)
  private
    FPoints: TList<TPoint>;
  public
    constructor Create;overload;
    constructor Create(APen: TDrawPen; APoints: TList<TPoint>);overload;
    destructor Destroy;override;

    procedure Run(ABitmap: TBitmap); override;
  end;

implementation

{ TDrawLine }

constructor TDrawLine.Create;
begin
  inherited Create;
end;

constructor TDrawLine.Create(APen: TDrawPen; AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FPen := TDrawPen.Create;
  FPen.PColor := APen.PColor;
  FPen.PWidth := APen.PWidth;
end;

destructor TDrawLine.Destroy;
begin
  inherited;

end;

procedure TDrawLine.Run(ABitmap: TBitmap);
begin
  ABitmap.Canvas.Pen.Color := FPen.PColor;
  ABitmap.Canvas.Pen.Width := FPen.PWidth;

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

constructor TDrawRectangle.Create(APen: TDrawPen; AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FPen := TDrawPen.Create;
  FPen.PColor := APen.PColor;
  FPen.PWidth := APen.PWidth;
end;

destructor TDrawRectangle.Destroy;
begin
  inherited;

end;


procedure TDrawRectangle.Run(ABitmap: TBitmap);
begin
  ABitmap.Canvas.Pen.Color := FPen.PColor;
  ABitmap.Canvas.Pen.Width := FPen.PWidth;

  ABitmap.Canvas.Rectangle(FStartPoint.X, FStartPoint.Y, FEndPoint.X,
    FEndPoint.Y);
end;
{ TDrawBrush }

constructor TDrawBrush.Create;
begin
  inherited Create;
end;

constructor TDrawBrush.Create(APen: TDrawPen; APoints: TList<TPoint>);
var
  LPoint: TPoint;
begin
  inherited Create;

  FPen := TDrawPen.Create;
  FPen.PColor := APen.PColor;
  FPen.PWidth := APen.PWidth;
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

  ABitmap.Canvas.Pen.Color := FPen.PColor;
  ABitmap.Canvas.Pen.Width := FPen.PWidth;

  LFirstPoint := FPoints[0];
  ABitmap.Canvas.MoveTo(LFirstPoint.X, LFirstPoint.Y);

  for LIndex := 1 to FPoints.Count - 1 do
  begin
    LPoint := FPoints[LIndex];
    ABitmap.Canvas.MoveTo(LPoint.X, LPoint.Y);
  end;
end;

end.

