unit Commands;

interface

uses
  Classes, Windows, Graphics, GraphicReceiver, Tools;

type
  TCommand = class
  private
    {
      1. FPrevBitmap: store the previous bitmap;
      2. FCurrntBitmap: store the changed bitmap;
    }
    FPrevBitmap: TBitmap;
    FCurrntBitmap: TBitmap;

    FPen: TDrawPen;
  public
    constructor Create;
    constructor Destroy;
    procedure Execute(ABitmap: TBitmap);virtual;abstract;
    procedure Undo(ABitmap: TBitmap);virtual;abstract;
    procedure Redo(ABitmap: TBitmap);virtual;abstract;
  end;

  TDrawLine = class(TCommand)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create(ABitmap: TBitmap; APen: TDrawPen; AStart: TPoint;
      AEnd: TPoint);

    procedure Execute(ABitmap: TBitmap);override;
    procedure Undo(ABitmap: TBitmap);override;
    procedure Redo(ABitmap: TBitmap);override;
  end;

  TDrawRectangle = class(TCommand)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create(ABitmap: TBitmap; APen: TDrawPen; AStart: TPoint;
      AEnd: TPoint);
    procedure Execute(ABitmap: TBitmap);override;
    procedure Undo(ABitmap: TBitmap);override;
    procedure Redo(ABitmap: TBitmap);override;
  end;

implementation

{ TDrawLine }

constructor TDrawLine.Create(ABitmap: TBitmap; APen: TDrawPen;
  AStart, AEnd: TPoint);
var
  LBitmap: TBitmap;
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  if Assigned(ABitmap) then
  begin
    FPrevBitmap.Assign(ABitmap);
    FCurrntBitmap.Assign(ABitmap);
  end;

  if Assigned(APen) then
  begin
    FPen.Assign(APen);
  end;
end;

procedure TDrawLine.Execute(ABitmap: TBitmap);
begin
  // store the previous bitmap
  FPrevBitmap.Assign(FCurrntBitmap);

  // FReceiver.DrawLine(FStartPoint, FEndPoint);
  FCurrntBitmap.Canvas.Pen.Color := FPen.PColor;
  FCurrntBitmap.Canvas.Pen.Width := FPen.PWidth;

  FCurrntBitmap.Canvas.MoveTo(FStartPoint.X, FStartPoint.Y);
  FCurrntBitmap.Canvas.LineTo(FEndPoint.X, FEndPoint.Y);

  // update the image bitmap
  ABitmap.Assign(FCurrntBitmap);
end;

procedure TDrawLine.Redo(ABitmap: TBitmap);
begin

end;

procedure TDrawLine.Undo(ABitmap: TBitmap);
var
  LColor: TColor;
begin
  // method1: draw again using the canvas color
  LColor := FPen.PColor;
  FPen.PColor := clWhite;
  Execute(ABitmap);
  FPen.PColor := LColor;
  // method2:
  // ABitmap.Assign(FPrevBitmap);
end;

{ TCommand }

constructor TCommand.Create;
begin
  FPrevBitmap := TBitmap.Create;
  FCurrntBitmap := TBitmap.Create;
  FPen := TDrawPen.Create;
end;

constructor TCommand.Destroy;
begin
  FPrevBitmap.Free;
  FCurrntBitmap.Free;
  FPen.Free;
end;

{ TDrawRectangle }

constructor TDrawRectangle.Create(ABitmap: TBitmap; APen: TDrawPen; AStart,
  AEnd: TPoint);
var
  LBitmap: TBitmap;
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  if Assigned(ABitmap) then
  begin
    FPrevBitmap.Assign(ABitmap);
    FCurrntBitmap.Assign(ABitmap);
  end;

  if Assigned(APen) then
  begin
    FPen.Assign(APen);
  end;
end;

procedure TDrawRectangle.Execute(ABitmap: TBitmap);
begin
  FPrevBitmap.Assign(FCurrntBitmap);

  FCurrntBitmap.Canvas.Pen.Color := FPen.PColor;
  FCurrntBitmap.Canvas.Pen.Width := FPen.PWidth;

  FCurrntBitmap.Canvas.Rectangle(FStartPoint.X, FStartPoint.Y, FEndPoint.X,
    FEndPoint.Y);
  ABitmap.Assign(FCurrntBitmap);
end;

procedure TDrawRectangle.Redo(ABitmap: TBitmap);
begin

end;

procedure TDrawRectangle.Undo(ABitmap: TBitmap);
var
  LColor: TColor;
begin
  // method1: draw again using the canvas color
  LColor := FPen.PColor;
  FPen.PColor := clWhite;
  Execute(ABitmap);
  FPen.PColor := LColor;
  // method2:
  // ABitmap.Assign(FPrevBitmap);
end;

end.

