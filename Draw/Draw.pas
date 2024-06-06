unit Draw;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
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
  private
    // 记录上一个鼠标的位置
    LastPoint: TPoint;
    // 记录当前是否为绘制状态
    IsDrawing: Boolean;
    // 判断是否绘制曲线
    PolyFlag: Boolean;
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
  PolyFlag := False;
  IsDrawing := False;
end;

{$R *.dfm}
// 绘制曲线对应的事件
procedure TForm1.CurveClick(Sender: TObject);
begin
  ClearStatus();
end;

// 当前窗体被创建的时候触发的事件
procedure TForm1.FormCreate(Sender: TObject);
begin
  Timer1.Enabled := True;
  Timer1.Interval := 1;
  // 初始化画布
  Image.Canvas.Create();
  // 初始化画布状态
  ClearStatus();
end;

// 鼠标左键按下对应的事件
procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // 判断当前是否是绘制直线
  if PolyFlag then
  begin
    if Button = mbLeft then
    begin
      LastPoint := Point(X, Y);
      Image.Canvas.MoveTo(X, Y);
    end;
  end;
end;

procedure TForm1.ImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if PolyFlag then
  begin
    if Button = mbLeft then
    begin
      LastPoint := Point(X, Y);
      Image.Canvas.LineTo(X, Y);
    end;
  end;
end;

// Line 按钮对应的事件
procedure TForm1.LineClick(Sender: TObject);
var
  Canvas: TCanvas;
begin
  // 清除其他的绘制状态
  ClearStatus();
  Canvas := Image.Canvas;
  // Draw a line: (100, 200) -> (400, 200)
  with Canvas do
  begin
    Pen.Color := clBlue;
    Pen.Width := 3;
    MoveTo(20, 100);
    LineTo(120, 100);
  end;
end;

// PolyLine 按钮对应的事件
procedure TForm1.PolyLineClick(Sender: TObject);
begin
  PolyFlag := True;
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
end;

// 计时器，用来实时更新图像
procedure TForm1.Timer1Timer(Sender: TObject);
var
  MousePos: TPoint;
begin
  GetCursorPos(MousePos);
  MouseX.Caption := IntToStr(MousePos.X);
  MouseY.Caption := IntToStr(MousePos.Y);
end;

end.
