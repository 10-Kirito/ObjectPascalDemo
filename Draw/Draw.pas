unit Draw;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Contnrs, GraphicBasic, RzButton, RzPanel,
  RzGroupBar, ImgList, CodeSiteLogging;

type
  TForm1 = class(TForm)
    btn1: TRzButton;
    rzbtbtn1: TRzBitBtn;
    il1: TImageList;
  published
    btnLine: TButton;
    btnRectangle: TButton;
    lblMouseX: TLabel;
    lblMouseY: TLabel;
    tmr1: TTimer;
    btnDrawPen: TButton;
    imgMain: TImage;
    btnCurve: TButton;
    // 各种事件的回调函数：
    procedure btnLineClick(Sender: TObject);
    procedure btnRectangleClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
    procedure btnDrawPenClick(Sender: TObject);
    procedure imgMainMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgMainMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnCurveClick(Sender: TObject);
    procedure imgMainMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
  private type
    TDrawStatus = (drawsEMPTY, drawsLINE, drawsRECTANGLE, drawsPEN);
  private
    // 记录上一个鼠标的位置
    FStartPoint: TPoint;
    FLastPoint: TPoint;
    // 绘制直线标志:
    FDrawingLine: Boolean;
    // 绘制矩形标志:
    FDrawingRectangle: Boolean;
    // 判断是否绘制曲线
    FPenDrawing: Boolean;
    FCurveFlag: Boolean;
    /// <summary>
    /// 保存画图全局状态：
    /// 1. drawsEMPTY: 初始状态;
    /// 2. drawsLINE: 绘制直线;
    /// 3. drawsRECTANGLE: 绘制矩形;
    /// ...
    /// </summary>
    FStatus: TDrawStatus;
    // 创建一个位图来保存我们的绘制操作:
    FBitMap: TBitmap;
    // 临时位图来实现橡皮筋效果:
    FCanvasObject: TGraphicBasic;
    FTempBitMap: TBitmap;
    // 清除当前的绘制状态
    procedure ClearStatus();
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

procedure TForm1.ClearStatus();
begin
  FPenDrawing := False;
  FDrawingLine := False;
  FCurveFlag := False;
  FDrawingRectangle := False;
  // 初始化画图全局状态
  FStatus := drawsEMPTY;

end;
{$R *.dfm}

// 绘制曲线对应的事件
procedure TForm1.btnCurveClick(Sender: TObject);
begin
  // 清除其他的绘制状态
  ClearStatus();
  FCurveFlag := False;
end;

// 当前窗体被创建的时候触发的事件
procedure TForm1.FormCreate(Sender: TObject);
begin
  // 初始化计时器:
  tmr1.Enabled := True;
  tmr1.Interval := 1;
  // 初始化画布:

  CodeSite.Send('a', Assigned(imgMain.Canvas));

  imgMain.Canvas.Create();

  CodeSite.Send('a', Assigned(imgMain.Canvas));

  // 初始化画布状态:
  ClearStatus();
  FStatus := drawsPEN;
  // 创建位图并初始化相关配置:
  FBitMap := TBitmap.Create();
  // FTempBitMap := TBitmap.Create();

  FBitMap.Assign(imgMain.Picture.Bitmap);
end;

// 鼠标左键按下对应的事件
procedure TForm1.imgMainMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // if left mouse is pressed
  if Button = mbLeft then
  begin
    // create a temp bitmap to store the prev image:
    FTempBitMap := TBitmap.Create();
    // copy the prev image into temp bitmap:
    FTempBitMap.Assign(FBitMap);
    // check the current drawing status
    case FStatus of
      drawsEMPTY:
        begin
          // DO NOTHING
        end;
      drawsLINE: // draw line settings
        begin
          FStartPoint := Point(X, Y);
          FLastPoint := FStartPoint;
          FDrawingLine := True;

          FCanvasObject := TLine.Create(FStartPoint, FLastPoint, FTempBitMap,
            imgMain.Picture.Bitmap);
        end;
      drawsRECTANGLE: // draw rectangle
        begin
          FStartPoint := Point(X, Y);
          FLastPoint := FStartPoint;
          FDrawingRectangle := True;
        end;
      drawsPEN: // draw pen
        begin
          FLastPoint := Point(X, Y);
          FTempBitMap.Canvas.Pen.Width := 3;
          FTempBitMap.Canvas.MoveTo(X, Y);
          FPenDrawing := True;
        end;
    end;
  end;
end;

procedure TForm1.imgMainMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  // drawing the line
  if FDrawingLine then
  begin
    // copy the temp bitmap to update
//    FTempBitMap.Assign(FBitMap);
//    FLastPoint := Point(X, Y);
//    FCanvasObject := TLine.Create(FStartPoint, FLastPoint, FTempBitMap.Canvas);
//    FCanvasObject.Draw();
//    // display the temp bitmap in the TImage
//    imgMain.Picture.Bitmap.Assign(FTempBitMap);
      FLastPoint := Point(X, Y);
      FCanvasObject.Update(FBitMap, FStartPoint, FLastPoint);

//    FLastPoint := Point(X, Y);
//    FTempBitMap.Assign(FBitMap);
//    FCanvasObject := TLine.Create(FStartPoint, FLastPoint, FTempBitMap);
//    if FCanvasObject is TLine then
//    begin
//      imgMain.Picture.Bitmap.Assign(TLine(FCanvasObject).NewDraw);
//    end;
  end;
  // drawing the pen
  if FPenDrawing then
  begin
    // FTempBitMap.Assign(FBitMap);
    FTempBitMap.Canvas.LineTo(X, Y);
    FLastPoint := Point(X, Y);
    imgMain.Picture.Bitmap.Assign(FTempBitMap);
  end;
  // darwing the rectangle
  if FDrawingRectangle then
  begin
    FTempBitMap.Assign(FBitMap);
    FLastPoint := Point(X, Y);
    FCanvasObject := TRectangle.Create(FStartPoint, FLastPoint,
      FTempBitMap.Canvas);
    FCanvasObject.Draw();
    imgMain.Picture.Bitmap.Assign(FTempBitMap);
  end;
end;

procedure TForm1.imgMainMouseUp(Sender: TObject; Button: TMouseButton;
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
          FDrawingLine := False;
        end;
      drawsRECTANGLE:
        begin
          FDrawingRectangle := False;
        end;
      drawsPEN:
        begin
          FPenDrawing := False;
          // ClearStatus();
        end;
    end;
  end;
  // 将临时位图复制到最终位图当中:
  FBitMap.Assign(FTempBitMap);
  imgMain.Picture.Bitmap.Assign(FBitMap);
  // 释放临时位图，下次绘制的时候重新申请临时位图资源
  FTempBitMap.Free();
  FTempBitMap := nil;
end;

// Line 按钮对应的事件
procedure TForm1.btnLineClick(Sender: TObject);
begin
  FStatus := drawsLINE;
end;

// DrawPen 按钮对应的事件
procedure TForm1.btnDrawPenClick(Sender: TObject);
begin
  FStatus := drawsPEN;
end;

// Rectangle 按钮对应的事件
procedure TForm1.btnRectangleClick(Sender: TObject);
begin
  FStatus := drawsRECTANGLE;
end;

// 计时器，用来实时更新图像
procedure TForm1.tmr1Timer(Sender: TObject);
var
  MousePos: TPoint;
begin
  // 获取当前鼠标的实时位置(x, y)
  GetCursorPos(MousePos);
  lblMouseX.Caption := IntToStr(MousePos.X);
  lblMouseY.Caption := IntToStr(MousePos.Y);
end;

end.
