unit GraphicReceiver;

interface

uses
  Windows, Classes, Graphics, SysUtils, Tools;

type
  TGraphicReceiver = class
  private
    FImageBitmap: TBitmap;
    FPrevBitmap: TBitmap;
    FTempBitmap: TBitmap;
    FPen: TDrawPen;
  public
    constructor Create(AImageBitmap: TBitmap);

    destructor Destroy; override;

    function GetCurrentBitmap: TBitmap;
    procedure SetDrawPen(APen: TDrawPen);
    function GetDrawPen: TDrawPen;

    procedure DrawLine(AStart: TPoint; AEnd: TPoint);
    procedure UpdateLine(AStart: TPoint; AEnd: TPoint);

    procedure DrawRectangle(AStart: TPoint; AEnd: TPoint);
    procedure UpdateRectangle(AStart: TPoint; AEnd: TPoint);

    procedure DrawEllipse(AStart: TPoint; AEnd: TPoint);
    procedure UpdateEllipse(AStart: TPoint; AEnd: TPoint);

    procedure DrawCircle(AStart: TPoint; AEnd: TPoint);
    procedure UpdateCircle(AStart: TPoint; AEnd: TPoint);

    procedure MovePoint(APoint: TPoint);
    procedure ConnectPoint(APoint: TPoint);

    property PPen: TDrawPen read GetDrawPen write SetDrawPen;
  end;

implementation

{ Tools functions }

procedure UpdatePen(ABitmap: TBitmap; APen: TDrawPen);
begin
  ABitmap.Canvas.Pen.Color := APen.PColor;
  ABitmap.Canvas.Pen.Width := APen.PWidth;
end;

{ TGraphicReceiver }

procedure TGraphicReceiver.MovePoint(APoint: TPoint);
begin
  UpdatePen(FImageBitmap, FPen);
  FImageBitmap.Canvas.MoveTo(APoint.X, APoint.Y);
  FPrevBitmap.Assign(FImageBitmap);
end;

procedure TGraphicReceiver.ConnectPoint(APoint: TPoint);
begin
  UpdatePen(FImageBitmap, FPen);
  FImageBitmap.Canvas.LineTo(APoint.X, APoint.Y);
  FPrevBitmap.Assign(FImageBitmap);
end;

constructor TGraphicReceiver.Create(AImageBitmap: TBitmap);
begin
  if Assigned(AImageBitmap) and not AImageBitmap.Empty then
  begin
    AImageBitmap.Canvas.Brush.Style := bsClear;
    FImageBitmap := AImageBitmap;
    FPrevBitmap := TBitmap.Create;
    FPrevBitmap.Width := FImageBitmap.Width;
    FPrevBitmap.Height := FImageBitmap.Height;
    FPrevBitmap.Assign(FImageBitmap);
  end
  else
    raise Exception.Create('Invalid or uninitialized bitmap passed to ' +
        'TGraphicReceiver.Create');
end;

destructor TGraphicReceiver.Destroy;
begin
  FreeAndNil(FPrevBitmap);
  inherited;
end;

procedure TGraphicReceiver.DrawCircle(AStart, AEnd: TPoint);
begin

end;

procedure TGraphicReceiver.DrawEllipse(AStart, AEnd: TPoint);
begin
  UpdatePen(FImageBitmap, FPen);
  FImageBitmap.Canvas.Ellipse(AStart.X, AStart.Y, AEnd.X, AEnd.Y);
  if Assigned(FPrevBitmap) then
  begin
    FPrevBitmap.Free;
  end;

  FPrevBitmap.Assign(FImageBitmap);
end;

procedure TGraphicReceiver.DrawLine(AStart, AEnd: TPoint);
begin
  UpdatePen(FImageBitmap, FPen);
  FImageBitmap.Canvas.MoveTo(AStart.X, AStart.Y);
  FImageBitmap.Canvas.LineTo(AEnd.X, AEnd.Y);
  if Assigned(FPrevBitmap) then
  begin
    FPrevBitmap.Free;
  end;
  FPrevBitmap.Assign(FImageBitmap);
end;

procedure TGraphicReceiver.DrawRectangle(AStart, AEnd: TPoint);
begin
  UpdatePen(FImageBitmap, FPen);
  FImageBitmap.Canvas.Rectangle(AStart.X, AStart.Y, AEnd.X, AEnd.Y);
  if Assigned(FPrevBitmap) then
  begin
    FPrevBitmap.Free;
  end;

  FPrevBitmap.Assign(FImageBitmap);
end;

function TGraphicReceiver.GetCurrentBitmap: TBitmap;
begin
  Result := FImageBitmap;
end;

function TGraphicReceiver.GetDrawPen: TDrawPen;
begin
  Result := FPen;
end;

procedure TGraphicReceiver.SetDrawPen(APen: TDrawPen);
begin
  FPen := APen;
end;

procedure TGraphicReceiver.UpdateCircle(AStart, AEnd: TPoint);
begin

end;

procedure TGraphicReceiver.UpdateEllipse(AStart, AEnd: TPoint);
begin
  FTempBitmap := TBitmap.Create;
  FTempBitmap.Width := FPrevBitmap.Width;
  FTempBitmap.Height := FPrevBitmap.Height;
  UpdatePen(FTempBitmap, FPen);
  FTempBitmap.Assign(FPrevBitmap);
  FTempBitmap.Canvas.Brush.Style := bsClear;
  FTempBitmap.Canvas.Ellipse(AStart.X, AStart.Y, AEnd.X, AEnd.Y);
  FImageBitmap.Assign(FTempBitmap);
  FreeAndNil(FTempBitmap);
end;

procedure TGraphicReceiver.UpdateLine(AStart, AEnd: TPoint);
begin
  FTempBitmap := TBitmap.Create;
  FTempBitmap.Width := FPrevBitmap.Width;
  FTempBitmap.Height := FPrevBitmap.Height;
  FTempBitmap.Assign(FPrevBitmap);

  UpdatePen(FTempBitmap, FPen);
  FTempBitmap.Canvas.Brush.Style := bsClear;
  FTempBitmap.Canvas.MoveTo(AStart.X, AStart.Y);
  FTempBitmap.Canvas.LineTo(AEnd.X, AEnd.Y);

  FImageBitmap.Assign(FTempBitmap);
  FreeAndNil(FTempBitmap);
end;

procedure TGraphicReceiver.UpdateRectangle(AStart, AEnd: TPoint);
begin
  FTempBitmap := TBitmap.Create;
  FTempBitmap.Width := FPrevBitmap.Width;
  FTempBitmap.Height := FPrevBitmap.Height;
  UpdatePen(FTempBitmap, FPen);
  FTempBitmap.Assign(FPrevBitmap);
  FTempBitmap.Canvas.Brush.Style := bsClear;
  FTempBitmap.Canvas.Rectangle(AStart.X, AStart.Y, AEnd.X, AEnd.Y);
  FImageBitmap.Assign(FTempBitmap);
  FreeAndNil(FTempBitmap);
end;

end.
