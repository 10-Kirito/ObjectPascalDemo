unit GraphicReceiver;

interface

uses
  Windows, Classes, Graphics, SysUtils, Tools;

type
  /// <summary>
  ///   橡皮筋效果调用的绘制方法都位于该类当中
  /// </summary>
  TGraphicReceiver = class
  private
    FImageBitmap: TBitmap;
    FPrevBitmap: TBitmap;
    FTempBitmap: TBitmap;
    FPen: TDrawPen;
  public
    constructor Create(AImageBitmap: TBitmap);
    destructor Destroy; override;

    /// <summary> 获取当前的Bitmap</summary>
    function GetCurrentBitmap: TBitmap;

    /// <summary> 设置以及获取画笔的相关属性</summary>
    procedure SetDrawPen(APen: TDrawPen);
    function GetDrawPen: TDrawPen;

    /// <summary> 绘制直线</summary>
    /// <param name="AStart"></param>
    /// <param name="AEnd"></param>
    procedure DrawLine(AStart: TPoint; AEnd: TPoint);
    procedure UpdateLine(AStart: TPoint; AEnd: TPoint);

    /// <summary> 绘制矩形</summary>
    /// <param name="AStart"></param>
    /// <param name="AEnd"></param>
    procedure DrawRectangle(AStart: TPoint; AEnd: TPoint);
    procedure UpdateRectangle(AStart: TPoint; AEnd: TPoint);

    /// <summary> 绘制椭圆</summary>
    /// <param name="AStart"></param>
    /// <param name="AEnd"></param>
    procedure DrawEllipse(AStart: TPoint; AEnd: TPoint);
    procedure UpdateEllipse(AStart: TPoint; AEnd: TPoint);

    /// <summary> 绘制圆</summary>
    /// <param name="AStart"></param>
    /// <param name="AEnd"></param>
    procedure DrawCircle(AStart: TPoint; AEnd: TPoint);
    procedure UpdateCircle(AStart: TPoint; AEnd: TPoint);

    /// <summary> 绘制自由线条</summary>
    /// <param name="APoint"></param>
    procedure MovePoint(APoint: TPoint);
    procedure ConnectPoint(APoint: TPoint);
    property Pen: TDrawPen read GetDrawPen write SetDrawPen;
  end;

implementation

{ Tools functions }

procedure UpdatePen(ABitmap: TBitmap; APen: TDrawPen);
begin
  ABitmap.Canvas.Pen.Color := APen.Color;
  ABitmap.Canvas.Pen.Width := APen.Width;
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
    // AImageBitmap.Canvas.Brush.Style := bsClear;
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
