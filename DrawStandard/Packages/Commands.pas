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
    destructor Destroy; override;
    procedure Execute(ABitmap: TBitmap);virtual;abstract;
    procedure Undo(ABitmap: TBitmap);virtual;abstract;
    procedure Redo(ABitmap: TBitmap);virtual;abstract;
    procedure Assign(ACommand: TCommand); virtual;
    function Copy(ACommand: TCommand): TCommand; virtual;
  end;

  TDrawLine = class(TCommand)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create; overload;
    constructor Create(ABitmap: TBitmap; APen: TDrawPen; AStart: TPoint;  AEnd: TPoint); overload;

    destructor Destroy;override;
    procedure Execute(ABitmap: TBitmap);override;
    procedure Undo(ABitmap: TBitmap);override;
    procedure Redo(ABitmap: TBitmap);override;
    procedure Assign(ACommand: TCommand);override;
    function Copy(ACommand: TCommand): TCommand; override;
  end;

  TDrawRectangle = class(TCommand)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create;overload;
    constructor Create(ABitmap: TBitmap; APen: TDrawPen; AStart: TPoint;
      AEnd: TPoint);overload;

    destructor Destroy;override;
    procedure Execute(ABitmap: TBitmap);override;
    procedure Undo(ABitmap: TBitmap);override;
    procedure Redo(ABitmap: TBitmap);override;
    procedure Assign(ACommand: TCommand);override;
    function Copy(ACommand: TCommand): TCommand; override;
  end;

implementation

{ TDrawLine }

procedure TDrawLine.Assign(ACommand: TCommand);
begin
  inherited;

  if ACommand is TDrawLine then
  begin
    FStartPoint := TDrawLine(ACommand).FStartPoint;
    FEndPoint := TDrawLine(ACommand).FEndPoint;
  end;
end;

function TDrawLine.Copy(ACommand: TCommand): TCommand;
var
  LCmd: TCommand;
begin
  LCmd := TDrawLine.Create;
  LCmd.Assign(ACommand);
  Result := LCmd;
end;

constructor TDrawLine.Create;
begin
  inherited Create;
end;

constructor TDrawLine.Create(ABitmap: TBitmap; APen: TDrawPen;
  AStart, AEnd: TPoint);
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

destructor TDrawLine.Destroy;
begin
  inherited;

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

procedure TCommand.Assign(ACommand: TCommand);
begin
  if Assigned(ACommand) then
  begin
    FPrevBitmap.Assign(ACommand.FPrevBitmap);
    FCurrntBitmap.Assign(ACommand.FCurrntBitmap);
    FPen.Assign(ACommand.FPen);
  end;
end;

function TCommand.Copy(ACommand: TCommand): TCommand;
begin

end;

constructor TCommand.Create;
begin
  FPrevBitmap := TBitmap.Create;
  FCurrntBitmap := TBitmap.Create;
  FPen := TDrawPen.Create;
end;

destructor TCommand.Destroy;
begin
  FPrevBitmap.Free;
  FCurrntBitmap.Free;
  FPen.Free;
end;

{ TDrawRectangle }

procedure TDrawRectangle.Assign(ACommand: TCommand);
begin
  inherited;

  if ACommand is TDrawRectangle then
  begin
    FStartPoint := TDrawRectangle(ACommand).FStartPoint;
    FEndPoint := TDrawRectangle(ACommand).FEndPoint;
  end;
end;

function TDrawRectangle.Copy(ACommand: TCommand): TCommand;
var
  LCmd: TCommand;
begin
  LCmd := TDrawRectangle.Create;
  LCmd.Assign(ACommand);
  Result := LCmd;
end;

constructor TDrawRectangle.Create;
begin
  inherited Create;
end;

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

destructor TDrawRectangle.Destroy;
begin
  inherited;

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

