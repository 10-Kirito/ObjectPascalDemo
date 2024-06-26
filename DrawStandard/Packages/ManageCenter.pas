unit ManageCenter;

interface

uses
  superobject, SysUtils, Generics.Collections, Dialogs, Controls, Classes, Windows, Graphics,
  ExtCtrls, GraphicReceiver, Tools, Commands, GraphicManager,
  GraphicObject, History, GraphicFile;

type
  /// <summary>
  ///  全局管理类:
  ///  - 管理全局画布绘制状态；
  ///  - 注册所有的命令；
  ///  - 处理UI页面上的所有的事件；
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
    { 注意:
      1.橡皮筋效果和命令模式是分离开的，其中橡皮筋效果借助于TGraphicReceiver类;
    }
    FReceiver: TGraphicReceiver;

    FGraphicManager: TGraphicManager;

    FHistory: THistory;
  public
    constructor Create(AImageBitmap: TBitmap);
    destructor Destroy; override;

    /// <summary> 处理鼠标按下事件</summary>
    /// <param name="Sender"></param>
    /// <param name="Button"> 按下的鼠标</param>
    /// <param name="Shift"></param>
    /// <param name="X">鼠标的X坐标</param>
    /// <param name="Y">鼠标的Y坐标</param>
    procedure HandleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    /// <summary> 处理鼠标移动事件</summary>
    /// <param name="Sender"></param>
    /// <param name="Shift"></param>
    /// <param name="X">鼠标移动的X坐标</param>
    /// <param name="Y">鼠标移动的Y坐标</param>
    procedure HandleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);

    /// <summary> 处理鼠标松开事件</summary>
    /// <param name="Sender"></param>
    /// <param name="Button">对应的鼠标按键</param>
    /// <param name="Shift"></param>
    /// <param name="X">鼠标的X坐标</param>
    /// <param name="Y">鼠标的Y坐标</param>
    procedure HandleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);

    /// <summary> 处理修改颜色事件</summary>
    /// <param name="AColor">修改后的颜色</param>
    procedure HandleColorChange(AColor: Integer);

    /// <summary> 处理修改笔刷宽度事件</summary>
    /// <param name="AWidth">修改后的宽度</param>
    procedure HandleWidthChange(AWidth: Integer);

    /// <summary> 处理撤销操作</summary>
    procedure HandleUndo;

    /// <summary> 处理重新执行操作</summary>
    procedure HandleRedo;

    /// <summary> 处理保存文件操作</summary>
    procedure HandleSaveFile;

    /// <summary> 处理打开文件操作</summary>
    procedure HandleOpenFile;

    // 判断当前绘制模式
    property Mode: TDrawMode read FMode write FMode;

    // 判断当前是否为绘制状态
    property IsDrawing: Boolean read FIsDrawing write FIsDrawing;
  private
    /// <summary> 处理导入文件</summary>
    /// <param name="APath">文件的路径</param>
    /// <param name="ABitmap">要绘制的目标Bitmap</param>
    /// <param name="AGraManager">全局图形对象管理器</param>
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
      由于实现橡皮筋效果需要对真正的画布进行操作，所以需要对其进行拷贝，待得橡皮筋
      效果展示完毕也就是鼠标按键松开的时候，将拷贝的画布重新进行赋值。
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
        // 如果返回列表当中有多个图形对象，将列表当中最后一个图形对象选中即可
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
        将画布还原到橡皮筋效果之前的样子
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
    OpenDialog.Filter := 'JSON Files (*.json)|*.json'; // 设置文件过滤器
    OpenDialog.DefaultExt := 'json'; // 设置默认文件扩展名

    if OpenDialog.Execute then
    begin
      FileName := OpenDialog.FileName; // 获取用户选择的文件名
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
    SaveDialog.Filter := 'JSON Files (*.json)|*.json'; // 设置文件过滤器
    SaveDialog.DefaultExt := 'json'; // 设置默认文件扩展名
    SaveDialog.FileName := FileName; // 设置默认文件名

    if SaveDialog.Execute then
    begin
      FileName := SaveDialog.FileName; // 获取用户选择的文件名
      // 在这里进行保存操作，例如保存 LFile 到 FileName
      FileJson.SaveTo(FileName);
    end;
  finally
    SaveDialog.Free;
  end;

  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter := 'PNG Files (*.png)|*.png'; // 设置文件过滤器
    SaveDialog.DefaultExt := 'png'; // 设置默认文件扩展名
    SaveDialog.FileName := PictureName; // 设置默认文件名

    if SaveDialog.Execute then
    begin
      PictureName := SaveDialog.FileName; // 获取用户选择的文件名
      // 在这里进行保存操作，例如保存 LFile 到 FileName
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

