unit ManageCenter;

interface

uses
  SysUtils, Generics.Collections, Dialogs, Controls, Classes, Windows,
  Graphics, ExtCtrls, Command, GraphicReceiver, Tools, CommandManager,
  Commands, GraphicManager, GraphicObject;

type
  {TManager:
    1. manage the canvas global status: FMode, FIsDrawing, FPen;
    2. register all commands;
    3. handler all events;
  }
  TManager = class
  private
    FImageBitmap: TBitmap; // target bitmap

    FMode: TDrawMode;
    FIsDrawing: Boolean;
    FPen: TDrawPen;

    {}
    FStartPoint: TPoint;
    FEndPoint: TPoint;
    FPoints: TList<TPoint>;
    { 注意:
      1.橡皮筋效果和命令模式是分离开的，其中橡皮筋效果借助于TGraphicReceiver类;
    }
    FReceiver: TGraphicReceiver;
    {
      1.FCommandManager管理添加所有的命令;
      2.FGraphicManager管理所有绘制的图像;
    }
    FCommandManager: TCommandManager;
    FGraphicManager: TGraphicManager;

  public
    constructor Create(AImageBitmap: TBitmap);
    destructor Destory;

    procedure HandleEvents;
    procedure HandleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HandleMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure HandleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure HandleColorChange(AColor: Integer);
    procedure HandleUndo;
    procedure HandleRedo;

    property PMode: TDrawMode read FMode write FMode;
    property PIsDrawing: Boolean read FIsDrawing write FIsDrawing;
  end;

implementation

{ TManager }

constructor TManager.Create(AImageBitmap: TBitmap);
var
  Receiver: TGraphicReceiver;
  Commands: TCommand;
begin
  // canvas settings:
  FMode := drawBRUSH;
  FIsDrawing := False;
  FPen := TDrawPen.Create;

  // copy the reference of image to change or update it
  FImageBitmap := AImageBitmap;
  // create the commands manager
  FCommandManager := TCommandManager.Create;
  // create the graphic manager
  FGraphicManager := TGraphicManager.Create;

end;

destructor TManager.Destory;
begin
  FPen.Free;
  FCommandManager.Free;
end;

procedure TManager.HandleColorChange(AColor: Integer);
begin
  FPen.PColor := TColor(AColor);
end;

procedure TManager.HandleEvents;
begin
  /// TODO!!!
end;

procedure TManager.HandleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Command: TCommand;
begin
  if Button = mbLeft then
  begin
    // special case:
    if FMode = drawSELECT then
    begin
      /// TODO!!!
      Exit;
    end;

    FReceiver := TGraphicReceiver.Create(FImageBitmap);
    FReceiver.SetDrawPen(FPen);

    FStartPoint := Point(X, Y);
    FEndPoint := FStartPoint;
    // normal case:
    case FMode of
      drawBRUSH:
      begin
          FReceiver.MovePoint(FStartPoint);

          //
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

procedure TManager.HandleMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  Command: TCommand;
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
    end;
  end;
end;

procedure TManager.HandleMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  LCommand: TCommand;
  LObject: TGraphicObject;
begin
  if Button = mbLeft then
  begin
    if FIsDrawing then
    begin
      FEndPoint := Point(X, Y);
      {Do something:
        1. create a new command into commands manager;
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
          end;
          // LCommand :=
        end;
        drawLINE:
        begin
          LCommand := TDrawLine.Create(FImageBitmap, FPen, FStartPoint, FEndPoint);
          FCommandManager.ExecuteCommand(LCommand, FImageBitmap);


        end;
        drawRECTANGLE:
        begin

        end;
        drawCIRCLE:;
        drawERASE:;
      end;
    end;
    FIsDrawing := False;
    FReceiver.Free;
    // LCommand.Free;
  end;
end;

procedure TManager.HandleRedo;
begin
  FCommandManager.Redo(FImageBitmap);
end;

procedure TManager.HandleUndo;
begin
  FCommandManager.Undo(FImageBitmap);
end;

end.

