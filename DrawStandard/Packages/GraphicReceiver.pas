unit GraphicReceiver;

interface

uses
  Windows, Classes, Graphics, SysUtils;

type
  TGraphicReceiver = class
  private
    FImageBitmap: TBitmap;
    FPrevBitmap: TBitmap;
    FTempBitmap: TBitmap;
  public
    constructor Create(AImageBitmap: TBitmap);

    destructor Destory();

    procedure DrawLine(AStart: TPoint; AEnd: TPoint);
    procedure UpdateLine(AStart: TPoint; AEnd: TPoint);

    procedure DrawRectangle(AStart: TPoint; AEnd: TPoint);
    procedure UpdateRectangle(AStart: TPoint; AEnd: TPoint);

    procedure MovePoint(APoint: TPoint);
    procedure ConnectPoint(APoint: TPoint);
  end;


implementation

{ TGraphicReceiver }

procedure TGraphicReceiver.MovePoint(APoint: TPoint);
begin
  FImageBitmap.Canvas.MoveTo(APoint.X, APoint.Y);
  FPrevBitmap.Assign(FImageBitmap);
end;

procedure TGraphicReceiver.ConnectPoint(APoint: TPoint);
begin
  FImageBitmap.Canvas.LineTo(APoint.X, APoint.Y);
  FPrevBitmap.Assign(FImageBitmap);
end;

constructor TGraphicReceiver.Create(AImageBitmap: TBitmap);
begin
  if Assigned(AImageBitmap) and not AImageBitmap.Empty then
  begin
    FImageBitmap := AImageBitmap;
    FPrevBitmap := TBitmap.Create;
    FPrevBitmap.Width := FImageBitmap.Width;
    FPrevBitmap.Height := FImageBitmap.Height;
    FPrevBitmap.Assign(FImageBitmap);
  end
  else
    raise Exception.Create('Invalid or uninitialized bitmap passed to TGraphicReceiver.Create');
end;

destructor TGraphicReceiver.Destory;
begin

end;

procedure TGraphicReceiver.DrawLine(AStart, AEnd: TPoint);
begin
  FImageBitmap.Canvas.MoveTo(AStart.X, AStart.Y);
  FImageBitmap.Canvas.LineTo(AEnd.X, AEnd.Y);
  FPrevBitmap.Assign(FImageBitmap);
end;

procedure TGraphicReceiver.DrawRectangle(AStart, AEnd: TPoint);
begin
  FImageBitmap.Canvas.Rectangle(AStart.X, AStart.Y, AEnd.X, AEnd.Y);
  FPrevBitmap.Assign(FImageBitmap);
end;

procedure TGraphicReceiver.UpdateLine(AStart, AEnd: TPoint);
begin
  FTempBitmap := TBitmap.Create;
  FTempBitmap.Width := FPrevBitmap.Width;
  FTempBitmap.Height := FPrevBitmap.Height;

  FTempBitmap.Assign(FPrevBitmap);
  FTempBitmap.Canvas.MoveTo(AStart.X, AStart.Y);
  FTempBitmap.Canvas.LineTo(AEnd.X, AEnd.Y);
  FImageBitmap.Assign(FTempBitmap);
end;

procedure TGraphicReceiver.UpdateRectangle(AStart, AEnd: TPoint);
begin
  FTempBitmap := TBitmap.Create;
  FTempBitmap.Width := FPrevBitmap.Width;
  FTempBitmap.Height := FPrevBitmap.Height;

  FTempBitmap.Assign(FPrevBitmap);
  FTempBitmap.Canvas.Rectangle(AStart.X, AStart.Y, AEnd.X, AEnd.Y);
  FImageBitmap.Assign(FTempBitmap);
end;

end.
