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
    // �����¼��Ļص�������
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
    // ��¼��һ������λ��
    FStartPoint: TPoint;
    FLastPoint: TPoint;
    // ����ֱ�߱�־:
    FDrawingLine: Boolean;
    // ���ƾ��α�־:
    FDrawingRectangle: Boolean;
    // �ж��Ƿ��������
    FPolyFlag: Boolean;
    FCurveFlag: Boolean;
    /// <summary>
    /// ���滭ͼȫ��״̬��
    ///  1. drawsEMPTY: ��ʼ״̬;
    ///  2. drawsLINE: ����ֱ��;
    ///  3. drawsRECTANGLE: ���ƾ���;
    ///  ...
    /// </summary>
    FStatus: TDrawStatus;
    // ����һ��λͼ���������ǵĻ��Ʋ���:
    FBitMap: TBitmap;
    // ��ʱλͼ��ʵ����Ƥ��Ч��:
    FTempBitMap: TBitmap;
    // �����ǰ�Ļ���״̬
    procedure ClearStatus();
    // ���ƺ����ӿ�:
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
  // ��ʼ����ͼȫ��״̬
  FStatus := drawsEMPTY;

end;

{$R *.dfm}
// �������߶�Ӧ���¼�
procedure TForm1.CurveClick(Sender: TObject);
begin
  // ��������Ļ���״̬
  ClearStatus();
  FCurveFlag := False;
end;

// ��װ�Ļ��ƺ���:
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

// ��ǰ���屻������ʱ�򴥷����¼�
procedure TForm1.FormCreate(Sender: TObject);
begin
  // ��ʼ����ʱ��:
  Timer1.Enabled := True;
  Timer1.Interval := 1;
  // ��ʼ������:
  Image.Canvas.Create();
  // ��ʼ������״̬:
  ClearStatus();
  // ����λͼ����ʼ���������:
  FBitMap := TBitmap.Create();
  FBitMap.Width := Image.ClientWidth;
  FBitMap.Width := Image.ClientHeight;

  FBitMap.Assign(Image.Picture.Bitmap);
end;

// ���������¶�Ӧ���¼�
procedure TForm1.ImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  // ��ʼ����ʱλͼ:
  FTempBitMap := TBitmap.Create();
  FTempBitMap.Width := FBitMap.Width;
  FTempBitMap.Height := FBitMap.Height;
  // ����ԭʼλͼ����ʱλͼ:
  FTempBitMap.Assign(FBitMap);
  // �жϵ�ǰ�Ƿ��ǻ���ֱ��
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
    // ����ʱλͼ��ͼ����Ƶ���Ӧ���������
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
  // ����ʱλͼ���Ƶ�����λͼ����:
  FBitMap.Assign(FTempBitMap);
  Image.Picture.Bitmap.Assign(FBitMap);
  // �ͷ���ʱλͼ���´λ��Ƶ�ʱ������������ʱλͼ��Դ
  FTempBitMap.Free();
  FTempBitMap := nil;
end;

// Line ��ť��Ӧ���¼�
procedure TForm1.LineClick(Sender: TObject);
var
  Canvas: TCanvas;
begin
  FStatus := drawsLINE;
end;

// PolyLine ��ť��Ӧ���¼�
procedure TForm1.PolyLineClick(Sender: TObject);
begin
  FPolyFlag := True;
  FStatus := drawsLINE;
end;

// Rectangle ��ť��Ӧ���¼�
procedure TForm1.RectangleClick(Sender: TObject);
var
  Canvas: TCanvas;
begin
  // ��������Ļ���״̬
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

// ��ʱ��������ʵʱ����ͼ��
procedure TForm1.Timer1Timer(Sender: TObject);
var
  MousePos: TPoint;
begin
  // ��ȡ��ǰ����ʵʱλ��(x, y)
  GetCursorPos(MousePos);
  MouseX.Caption := IntToStr(MousePos.X);
  MouseY.Caption := IntToStr(MousePos.Y);
end;

end.
