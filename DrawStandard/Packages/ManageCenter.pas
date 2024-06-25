unit ManageCenter;

interface

uses
  superobject, SysUtils, Generics.Collections, Dialogs, Controls, Classes, Windows, Graphics,
  ExtCtrls, GraphicReceiver, Tools, Commands, GraphicManager,
  GraphicObject, History, GraphicFile;

type
  /// <summary>
  ///  ȫ�ֹ�����:
  ///  - ����ȫ�ֻ�������״̬��
  ///  - ע�����е����
  ///  - ����UIҳ���ϵ����е��¼���
  /// </summary>
  TManager = class
  private
    FImageBitmap: TBitmap; // target bitmap
    FTempBitmap: TBitmap; // temp bitmap

    FMode: TDrawMode;
    FIsDrawing: Boolean;
    FPen: TDrawPen;

    FStartPoint: TPoint;
    FEndPoint: TPoint;
    FPoints: TList<TPoint>;
    { ע��:
      1.��Ƥ��Ч��������ģʽ�Ƿ��뿪�ģ�������Ƥ��Ч��������TGraphicReceiver��;
    }
    FReceiver: TGraphicReceiver;

    FGraphicManager: TGraphicManager;

    FHistory: THistory;
  public
    constructor Create(AImageBitmap: TBitmap);
    destructor Destroy; override;

    /// <summary> ������갴���¼�</summary>
    /// <param name="Sender"></param>
    /// <param name="Button"> ���µ����</param>
    /// <param name="Shift"></param>
    /// <param name="X">����X����</param>
    /// <param name="Y">����Y����</param>
    procedure HandleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    /// <summary> ��������ƶ��¼�</summary>
    /// <param name="Sender"></param>
    /// <param name="Shift"></param>
    /// <param name="X">����ƶ���X����</param>
    /// <param name="Y">����ƶ���Y����</param>
    procedure HandleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    /// <summary> ��������ɿ��¼�</summary>
    /// <param name="Sender"></param>
    /// <param name="Button">��Ӧ����갴��</param>
    /// <param name="Shift"></param>
    /// <param name="X">����X����</param>
    /// <param name="Y">����Y����</param>
    procedure HandleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    /// <summary> �����޸���ɫ�¼�</summary>
    /// <param name="AColor">�޸ĺ����ɫ</param>
    procedure HandleColorChange(AColor: Integer);

    /// <summary> �����޸ı�ˢ����¼�</summary>
    /// <param name="AWidth">�޸ĺ�Ŀ��</param>
    procedure HandleWidthChange(AWidth: Integer);

    /// <summary> ����������</summary>
    procedure HandleUndo;

    /// <summary> ��������ִ�в���</summary>
    procedure HandleRedo;

    /// <summary> �������ļ�����</summary>
    procedure HandleSaveFile;

    /// <summary> ������ļ�����</summary>
    procedure HandleOpenFile;

    // �жϵ�ǰ����ģʽ
    property Mode: TDrawMode read FMode write FMode;

    // �жϵ�ǰ�Ƿ�Ϊ����״̬
    property IsDrawing: Boolean read FIsDrawing write FIsDrawing;
  private
    /// <summary> �������ļ�</summary>
    /// <param name="APath">�ļ���·��</param>
    /// <param name="ABitmap">Ҫ���Ƶ�Ŀ��Bitmap</param>
    /// <param name="AGraManager">ȫ��ͼ�ζ��������</param>
    procedure HandleImportFile(APath: string; ABitmap: TBitmap; AGraManager: TGraphicManager);
  end;

implementation

{ TManager }

constructor TManager.Create(AImageBitmap: TBitmap);
begin
  // AImageBitmap.Canvas.Brush.Style := bsClear;

  // canvas settings:
  FMode := drawBRUSH;
  FIsDrawing := False;
  FPen := TDrawPen.Create;

  // copy the reference of image to change or update it
  FImageBitmap := AImageBitmap;

  FTempBitmap := TBitmap.Create;
  FTempBitmap.Assign(AImageBitmap);

  // create the graphic manager
  FGraphicManager := TGraphicManager.Create;

  FHistory := THistory.Create(FGraphicManager);
end;

destructor TManager.Destroy;
begin
  FreeAndNil(FPen);
  FreeAndNil(FGraphicManager);
  FreeAndNil(FTempBitmap);
  FreeAndNil(FHistory);
end;

procedure TManager.HandleColorChange(AColor: Integer);
begin
  FPen.Color := TColor(AColor);
end;

procedure DrawFromGraphics(ABitmap: TBitmap; AList: TList<TGraphicObject>);
var
  LObject: TGraphicObject;
  LCommand: TCommand;
  LPen: TDrawPen;

  LPoints: TList<TPoint>;
begin
  for LObject in AList do
  begin
    LPen := TDrawPen.Create(LObject.GetColor, LObject.GetWidth);
    LPoints := LObject.GetPoints;

    LCommand := nil;

    case LObject.GetType of
      FREEHAND:
        begin
          LCommand := TDrawBrush.Create(LPen, LPoints);
        end;
      LINE:
        begin
          LCommand := TDrawLine.Create(LPen, LPoints[0], LPoints[1]);
        end;
      RECTANGLE:
        begin
          LCommand := TDrawRectangle.Create(LPen, LPoints[0], LPoints[1]);
        end;
      ELLIPSE:
        begin
          LCommand := TDrawELLIPSE.Create(LPen, LPoints[0], LPoints[1]);
        end;
    end;

    if Assigned(LCommand) then
    begin
      LCommand.Run(ABitmap);
      LCommand.Free;
    end;
    LPen.Free;
    LPoints.Free;
  end;
end;

procedure TManager.HandleImportFile(APath: string; ABitmap: TBitmap; AGraManager: TGraphicManager);
var
  LList: TList<TGraphicObject>;
  LObject: TGraphicObject;
begin
  ///
  /// 1. Parsing the import file:
  ///  1.1 create and insert the graphics into AGraManager;
  ///  1.2 create the related command and execute the command to update the ABitmap
  ///
  LList := TDataFile.ImportFile(APath, AGraManager);
  DrawFromGraphics(ABitmap, LList);

  for LObject in LList do
  begin
    LObject.Free;
  end;

  LList.Free;
end;

procedure TManager.HandleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then
  begin
    // special case:
    if FMode = drawSELECT then
    begin
      /// TODO!!!
      Exit;
    end;

    // normal case:
    {
      ����ʵ����Ƥ��Ч����Ҫ�������Ļ������в�����������Ҫ������п�����������Ƥ��
      Ч��չʾ���Ҳ������갴���ɿ���ʱ�򣬽������Ļ������½��и�ֵ��
    }
    FTempBitmap.Assign(FImageBitmap);
    FReceiver := TGraphicReceiver.Create(FImageBitmap);
    FReceiver.SetDrawPen(FPen);

    FStartPoint := Point(X, Y);
    FEndPoint := FStartPoint;
    // normal case:
    case FMode of
      drawBRUSH:
        begin
          FReceiver.MovePoint(FStartPoint);

          FPoints := TList<TPoint>.Create;
          FPoints.Add(FStartPoint);
        end;
      drawLINE:
        ;
      drawRECTANGLE:
        ;
      drawCIRCLE:
        ;
      drawERASE:
        ;
    end;
    FIsDrawing := True;
  end;
end;

procedure TManager.HandleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  /// TODO!!!
  if FMode = drawSELECT then
  begin
    Exit;
  end;

  if FIsDrawing then
  begin
    case FMode of
      drawBRUSH:
        begin
          FReceiver.ConnectPoint(Point(X, Y));

          if Assigned(FPoints) then
          begin
            FPoints.Add(Point(X, Y));
          end;
        end;
      drawLINE:
        begin
          FReceiver.UpdateLine(FStartPoint, Point(X, Y));
        end;
      drawRECTANGLE:
        begin
          FReceiver.UpdateRectangle(FStartPoint, Point(X, Y));
        end;
      drawCIRCLE:
        ;
      drawERASE:
        ;
      drawELLIPSE:
        begin
          FReceiver.UpdateEllipse(FStartPoint, Point(X, Y));
        end;
    end;
  end;
end;

procedure TManager.HandleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  LCommand: TCommand;
  LObject: TGraphicObject;
  SelectObjects: TList<TGraphicObject>;
  SelectObject: TGraphicObject;
  LCount: Integer;
begin
  if Button = mbLeft then
  begin
    if FMode = drawSELECT then
    begin
      SelectObjects := FGraphicManager.PointExitsObject(Point(X, Y));
      if SelectObjects.Count <> 0 then
      begin
        LCount := SelectObjects.Count;
        // ��������б����ж��ͼ�ζ��󣬽��б������һ��ͼ�ζ���ѡ�м���
        SelectObject := SelectObjects[LCount - 1];
        SelectObject.DrawSelectBox(FImageBitmap);
      end;
      SelectObjects.Free;
      Exit;
    end;

    // Drawing!!!
    if FIsDrawing then
    begin
      {
        ��������ԭ����Ƥ��Ч��֮ǰ������
      }
      FImageBitmap.Assign(FTempBitmap);
      FEndPoint := Point(X, Y);
      { Do something:
        1. create a new command and insert it into FHistory;
        2. register a new Graphic object in the object manager;
      }
      case FMode of
        drawBRUSH:
          begin
            if Assigned(FPoints) then
            begin
              FPoints.Add(FEndPoint);

              LObject := TFreeLine.Create(FPoints);
              FGraphicManager.RegisterObject(LObject);
              LObject.SetPen(FPen);
              LCommand := TDrawBrush.Create(FPen, FPoints, LObject.GUID);
              FHistory.AddHistory(FImageBitmap, LCommand);
              LCommand.Run(FImageBitmap);

              FreeAndNil(FPoints);
            end;
          end;
        drawLINE:
          begin
            LObject := TLine.Create(FStartPoint, FEndPoint);
            FGraphicManager.RegisterObject(LObject);
            LObject.SetPen(FPen);
            LCommand := TDrawLine.Create(FPen, FStartPoint, FEndPoint, LObject.GUID);
            FHistory.AddHistory(FImageBitmap, LCommand);
            LCommand.Run(FImageBitmap);
          end;
        drawRECTANGLE:
          begin
            LObject := TRectangle.Create(FStartPoint, FEndPoint);
            FGraphicManager.RegisterObject(LObject);
            LObject.SetPen(FPen);
            LCommand := TDrawRectangle.Create(FPen, FStartPoint, FEndPoint, LObject.GUID);
            FHistory.AddHistory(FImageBitmap, LCommand);
            LCommand.Run(FImageBitmap);
          end;
        drawCIRCLE:
          ;
        drawERASE:
          ;
        drawELLIPSE:
          begin
            LObject := TELLIPSE.Create(FStartPoint, FEndPoint);
            FGraphicManager.RegisterObject(LObject);
            LObject.SetPen(FPen);
            LCommand := TDrawELLIPSE.Create(FPen, FStartPoint, FEndPoint, LObject.GUID);
            FHistory.AddHistory(FImageBitmap, LCommand);
            LCommand.Run(FImageBitmap);
          end;
      end;
      FIsDrawing := False;
      FReceiver.Free;
    end;
  end;
end;

procedure TManager.HandleOpenFile;
var
  OpenDialog: TOpenDialog;
  FileName: string;
begin
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := 'JSON Files (*.json)|*.json'; // �����ļ�������
    OpenDialog.DefaultExt := 'json'; // ����Ĭ���ļ���չ��

    if OpenDialog.Execute then
    begin
      FileName := OpenDialog.FileName; // ��ȡ�û�ѡ����ļ���
      HandleImportFile(FileName, FImageBitmap, FGraphicManager);
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure TManager.HandleRedo;
begin
  FHistory.RedoHistory(FImageBitmap);
end;

procedure TManager.HandleSaveFile;
var
  FileJson: ISuperObject;
  SaveDialog: TSaveDialog;
  FileName: string;
  PictureName: string;

begin
  FileJson := TDataFile.ExportFile(FGraphicManager);

  PictureName := TTools.DrawTime + '.png';
  FileName := TTools.DrawTime + '.json';

  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter := 'JSON Files (*.json)|*.json'; // �����ļ�������
    SaveDialog.DefaultExt := 'json'; // ����Ĭ���ļ���չ��
    SaveDialog.FileName := FileName; // ����Ĭ���ļ���

    if SaveDialog.Execute then
    begin
      FileName := SaveDialog.FileName; // ��ȡ�û�ѡ����ļ���
      // ��������б�����������籣�� LFile �� FileName
      FileJson.SaveTo(FileName);
    end;
  finally
    SaveDialog.Free;
  end;

  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter := 'PNG Files (*.png)|*.png'; // �����ļ�������
    SaveDialog.DefaultExt := 'png'; // ����Ĭ���ļ���չ��
    SaveDialog.FileName := PictureName; // ����Ĭ���ļ���

    if SaveDialog.Execute then
    begin
      PictureName := SaveDialog.FileName; // ��ȡ�û�ѡ����ļ���
      // ��������б�����������籣�� LFile �� FileName
      FImageBitmap.SaveToFile(PictureName);
    end;
  finally
    SaveDialog.Free;
  end;
end;

procedure TManager.HandleUndo;
begin
  FHistory.UndoHistory(FImageBitmap);
end;

procedure TManager.HandleWidthChange(AWidth: Integer);
begin
  FPen.Width := AWidth;
end;

end.

