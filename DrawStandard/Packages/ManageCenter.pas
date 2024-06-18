unit ManageCenter;

interface

uses
  SysUtils, Generics.Collections, Dialogs, Controls, Classes, Windows, Graphics,
  ExtCtrls, Command, GraphicReceiver, Tools, CommandManager, Commands,
  GraphicManager, GraphicObject, History;

type
  {TManager:
    1. manage the canvas global status: FMode, FIsDrawing, FPen;
    2. register all commands;
    3. handler all events;
  }
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
    {
      1.FCommandManager����������е�����;
      2.FGraphicManager�������л��Ƶ�ͼ��;
    }
    FCommandManager: TCommandManager;
    FGraphicManager: TGraphicManager;

    FHistory: THistory;
  public
    constructor Create(AImageBitmap: TBitmap);
    destructor Destroy; override;

    procedure HandleEvents;
    procedure HandleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HandleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure HandleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HandleColorChange(AColor: Integer);
    procedure HandleWidthChange(AWidth: Integer);
    procedure HandleUndo;
    procedure HandleRedo;

    property PMode: TDrawMode read FMode write FMode;
    property PIsDrawing: Boolean read FIsDrawing write FIsDrawing;
  end;

implementation

{ TManager }

constructor TManager.Create(AImageBitmap: TBitmap);
begin
  // canvas settings:
  FMode := drawBRUSH;
  FIsDrawing := False;
  FPen := TDrawPen.Create;

  // copy the reference of image to change or update it
  FImageBitmap := AImageBitmap;

  FTempBitmap := TBitmap.Create;
  FTempBitmap.Assign(AImageBitmap);

  // create the commands manager
  FCommandManager := TCommandManager.Create;
  // create the graphic manager
  FGraphicManager := TGraphicManager.Create;

  FHistory := THistory.Create;
end;

destructor TManager.Destroy;
begin
  FreeAndNil(FPen);
  FreeAndNil(FCommandManager);
  FreeAndNil(FPoints);
  FreeAndNil(FGraphicManager);
  FreeAndNil(FTempBitmap);
  FreeAndNil(FHistory);
end;

procedure TManager.HandleColorChange(AColor: Integer);
begin
  FPen.PColor := TColor(AColor);
end;

procedure TManager.HandleEvents;
begin
  /// TODO!!!
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
begin
  if Button = mbLeft then
  begin
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
              LCommand := TDrawBrush.Create(FPen, FPoints);
              FHistory.AddHistory(FImageBitmap, LCommand);
              LCommand.Run(FImageBitmap);

              LObject := TFreeLine.Create(FPoints);
              FGraphicManager.RegisterObject(LObject);
            end;
          end;
        drawLINE:
          begin
            // 1. create the command and insert it into FHistory
            LCommand := TDrawLine.Create(FPen, FStartPoint, FEndPoint);
            FHistory.AddHistory(FImageBitmap, LCommand);
            LCommand.Run(FImageBitmap);
            // 2. register the object in FGraphicManager
            LObject := TLine.Create(FStartPoint, FEndPoint);
            FGraphicManager.RegisterObject(LObject);
          end;
        drawRECTANGLE:
          begin
            LCommand := TDrawRectangle.Create(FPen, FStartPoint, FEndPoint);
            FHistory.AddHistory(FImageBitmap, LCommand);
            LCommand.Run(FImageBitmap);
          end;
        drawCIRCLE:
          ;
        drawERASE:
          ;
        drawELLIPSE:
          begin
            LCommand := TDrawELLIPSE.Create(FPen, FStartPoint, FEndPoint);
            FHistory.AddHistory(FImageBitmap, LCommand);
            LCommand.Run(FImageBitmap);
          end;
      end;
    end;
    FIsDrawing := False;
    FReceiver.Free;
  end;
end;

procedure TManager.HandleRedo;
begin
  FHistory.RedoHistory(FImageBitmap);
end;

procedure TManager.HandleUndo;
begin
  FHistory.UndoHistory(FImageBitmap);
end;

procedure TManager.HandleWidthChange(AWidth: Integer);
begin
  FPen.PWidth := AWidth;
end;

end.

