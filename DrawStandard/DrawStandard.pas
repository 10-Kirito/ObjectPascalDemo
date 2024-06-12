unit DrawStandard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, RzButton, ImgList, ExtCtrls, RzPanel, RzCommon,
  RzBorder, RzPopups, RzDBList, Grids, RzGrids, RzCmboBx, Mask, RzEdit, Buttons,
  Menus, GraphicBasic;

type
  TForm1 = class(TForm)
    ilImageList: TImageList;
    imgCanvas: TImage;
    rztlbrToolsBar: TRzToolbar;
    btnOpen: TRzToolButton;
    btnSave: TRzToolButton;
    rzpnlTools: TRzPanel;
    btnPen: TRzToolButton;
    btnLine: TRzToolButton;
    btnRec: TRzToolButton;
    btnCircle: TRzToolButton;
    btnCurve: TRzToolButton;
    edtColor: TRzColorEdit;
    btnSelect: TRzToolButton;
    procedure FormCreate(Sender: TObject);
    procedure imgCanvasMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgCanvasMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnLineClick(Sender: TObject);
    procedure btnRecClick(Sender: TObject);
    procedure btnCircleClick(Sender: TObject);
    procedure btnCurveClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnPenClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure imgCanvasMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    FMode: TDrawMode;
    FIsDrawing: Boolean;
    FPen: TPen;

    FBitMap: TBitMap;
    FTempBitMap: TBitmap;

    FStartPoint: TPoint;
    FLastPoint: TPoint;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnCircleClick(Sender: TObject);
begin
  Self.FMode := drawCIRCLE;
end;

procedure TForm1.btnCurveClick(Sender: TObject);
begin
  ShowMessage('TODO!!!');
end;

procedure TForm1.btnLineClick(Sender: TObject);
begin
  Self.FMode := drawLINE;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  ShowMessage('TODO!!!');
end;

procedure TForm1.btnPenClick(Sender: TObject);
begin
  Self.FMode := drawBRUSH;
end;

procedure TForm1.btnRecClick(Sender: TObject);
begin
  Self.FMode := drawRECTANGLE;
end;

procedure TForm1.btnSelectClick(Sender: TObject);
begin
  Self.FMode := drawSELECT;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Self.FMode := drawBRUSH;
  Self.FIsDrawing := False;

  imgCanvas.Canvas.Create;

  FBitMap := TBitmap.Create;
  FBitMap.Width := imgCanvas.ClientWidth;
  FBitMap.Height := imgCanvas.ClientHeight;

  FBitMap.Assign(imgCanvas.Picture.Bitmap);
end;

procedure TForm1.imgCanvasMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    // 如果当前模式为选择模式，另外进行处理
    if Self.FMode = drawSELECT then
    begin
      /// TODO!!!
      Exit;
    end;

    // 除了选择模式之外，均为绘制模式，其中包含软件启动之后的页面(drawBRUSH模式)
    FIsDrawing := True;
    // 复制当前的图像位图
    FTempBitMap := TBitmap.Create;
    FTempBitMap.Width := FBitMap.Width;
    FTempBitMap.Height := FBitMap.Height;
    FTempBitMap.Assign(FBitMap);
    case FMode of
      drawBRUSH:
      begin

      end;
      drawLINE:
      begin
        FStartPoint := Point(X, Y);
        FLastPoint := FStartPoint;
      end;
    end;
  end;

end;

procedure TForm1.imgCanvasMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  // 判断当前是否处于绘制状态
  if FIsDrawing then
  begin
    case Self.FMode of
      drawLINE:
      begin
         FLastPoint := Point(X, Y);

//         imgCanvas.Picture.Bitmap.Assign();

      end;
    end;
  end;
end;

procedure TForm1.imgCanvasMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ShowMessage('Hello, world!');
end;

end.

