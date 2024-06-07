unit Draw;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Contnrs;

type
  TForm1 = class(TForm)
  type
    TDrawStatus = (drawsEMPTY, drawsLINE, drawsRECTANGLE);
  published
    Line: TButton;
    Rectangle: TButton;
    MouseX: TLabel;
    MouseY: TLabel;
    Timer1: TTimer;
    PolyLine: TButton;
    Image: TImage;
    Curve: TButton;
    // 各种事件的回调函数：
    procedure LineClick(Sender: TObject);
    procedure RectangleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure PolyLineClick(Sender: TObject);
    procedure ImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CurveClick(Sender: TObject);
    procedure ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    // 记录上一个鼠标的位置
    FStartPoint: TPoint;
    FLastPoint: TPoint;
    // 绘制直线标志:
    FDrawingLine: Boolean;
    // 绘制矩形标志:
    FDrawingRectangle: Boolean;
    // 判断是否绘制曲线
    FPolyFlag: Boolean;
    FCurveFlag: Boolean;
    /// <summary>
    /// 保存画图全局状态：
    ///  1. drawsEMPTY: 初始状态;
    ///  2. drawsLINE: 绘制直线;
    ///  3. drawsRECTANGLE: 绘制矩形;
    ///  ...
    /// </summary>
    FStatus: TDrawStatus;
    // 创建一个位图来保存我们的绘制操作:
    FBitMap: TBitmap;
    // 临时位图来实现橡皮筋效果:
    FTempBitMap: TBitmap;
    // 清除当前的绘制状态
    procedure ClearStatus();
    // 绘制函数接口:
    procedure DrawLine(const StartPoint, EndPoint: TPoint);
    procedure DrawRectangle(const StartPoint, EndPoint: TPoint);
  public
    { Public declarations }
  end;
var
  Form1: TForm1;


implementation

procedure TForm1.ClearStatus();
begin
  FPolyFlag := False;
  FDrawingLine := False;
  FCurveFlag := False;
  FDrawingRectangle := False;
  // 初始化画图全局状态
  FStatus := drawsEMPTY;

end;

{$R *.dfm}
// 绘制曲线对应的事件
procedure TForm1.CurveClick(Sender: TObject);
begin
  // 清除其他的绘制状态
  ClearStatus();
  FCurveFlag := False;
end;

// 封装的绘制函数:
procedure TForm1.DrawLine(const StartPoint, EndPoint: TPoint);
begin
//  Image.Canvas.MoveTo(StartPoint.X, StartPoint.Y);
//  Image.Canvas.LineTo(EndPoint.X, EndPoint.Y);
  FTempBitMap.Canvas.MoveTo(StartPoint.X, StartPoint.Y);
  FTempBitMap.Canvas.LineTo(EndPoint.X, EndPoint.Y);
end;

procedure TForm1.DrawRectangle(const StartPoint, EndPoint: TPoint);
begin
  Image.Canvas.Rectangle(StartPoint.X, StartPoint.Y, EndPoint.X, EndPoint.Y);
  FBitMap.Assign(Image.Picture.Bitmap);
end;

// 当前窗体被创建的时候触发的事件
procedure TForm1.FormCreate(Sender: TObject);
begin
  // 初始化计时器:
  Timer1.Enabled := True;
  Timer1.Interval := 1;
  // 初始化画布:
  Image.Canvas.Create();
  // 初始化画布状态:
  ClearStatus();
  // 创建位图并初始化相关配置:
  FBitMap := TBitmap.Create();
  FBitMap.Width := Image.ClientWidth;
  FBitMap.Width := Image.ClientHeight;

  FBitMap.Assign(Image.Picture.Bitmap);
end;

// 鼠标左键按下对应的事件
procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // 初始化临时位图:
  FTempBitMap := TBitmap.Create();
  FTempBitMap.Width := FBitMap.Width;
  FTempBitMap.Height := FBitMap.Height;
  // 复制原始位图到临时位图:
  FTempBitMap.Assign(FBitMap);
  // 判断当前是否是绘制直线
  case FStatus of
    drawsEMPTY:
    begin
      // DO NOTHING
    end;
    drawsLINE:
    begin
      if(Button = mbLeft) then
      begin
        FStartPoint := Point(X, Y);
        FLastPoint := FStartPoint;
        Image.Canvas.MoveTo(X, Y);
        FDrawingLine := True;
        Image.Canvas.Pen.Mode := pmNotXor;
      end;
    end;
    drawsRECTANGLE:
    begin
      /// TODO
    end;
  end;
end;

procedure TForm1.ImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if FDrawingLine then
  begin
    FTempBitMap.Assign(FBitMap);
    case FStatus of
      drawsEMPTY:
      begin
        // DO NOTHING
      end;
      drawsLINE:
      if FDrawingLine then
      begin
        // Erase the last shape
        DrawLine(FStartPoint, FLastPoint);
        // Draw the new shape
        FLastPoint := Point(X, Y);
        DrawLine(FStartPoint, FLastPoint);
      end;
      drawsRECTANGLE:
      begin
        // TODO
      end;
    end;
    // 将临时位图的图像绘制到对应的组件当中
    Image.Picture.Bitmap.Assign(FTempBitMap);
  end;
end;

procedure TForm1.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    case FStatus of
      drawsEMPTY:
      begin
        // DO NOTHING
      end;
      drawsLINE:
      begin
        // Finish the drawing
        DrawLine(FStartPoint, FLastPoint);
        FLastPoint := Point(X, Y);
        DrawLine(FStartPoint, FLastPoint);
        FDrawingLine := False;
        Image.Canvas.Pen.Mode := pmCopy;
      end;
      drawsRECTANGLE:
      begin
        // TODO
      end;
    end;
  end;
  // 将临时位图复制到最终位图当中:
  FBitMap.Assign(FTempBitMap);
  Image.Picture.Bitmap.Assign(FBitMap);
  // 释放临时位图，下次绘制的时候重新申请临时位图资源
  FTempBitMap.Free();
  FTempBitMap := nil;
end;

// Line 按钮对应的事件
procedure TForm1.LineClick(Sender: TObject);
var
  Canvas: TCanvas;
begin
  FStatus := drawsLINE;
end;

// PolyLine 按钮对应的事件
procedure TForm1.PolyLineClick(Sender: TObject);
begin
  FPolyFlag := True;
  FStatus := drawsLINE;
end;

// Rectangle 按钮对应的事件
procedure TForm1.RectangleClick(Sender: TObject);
var
  Canvas: TCanvas;
begin
  // 清除其他的绘制状态
  ClearStatus();
  Canvas := Image.Canvas;
  with Canvas do
  begin
    Pen.Color := clBlue;
    Pen.Width := 3;
    Rectangle(40, 200, 140, 300);
  end;
  FBitMap.Assign(Image.Picture.Bitmap);
end;

// 计时器，用来实时更新图像
procedure TForm1.Timer1Timer(Sender: TObject);
var
  MousePos: TPoint;
begin
  // 获取当前鼠标的实时位置(x, y)
  GetCursorPos(MousePos);
  MouseX.Caption := IntToStr(MousePos.X);
  MouseY.Caption := IntToStr(MousePos.Y);
end;

end.
