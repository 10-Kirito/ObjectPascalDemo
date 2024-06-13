unit Manage;

interface

uses
  SysUtils, Generics.Collections, Dialogs, Controls, Classes, Windows,
  Graphics, ExtCtrls, Command, GraphicReceiver, Tools;

type
  {
    TManager:
      1. manage the canvas global status: FMode, FIsDrawing, FPen;
      2. register all commands;
      3. handler all events;
  }
  TManager = class
  private
    FImageBitmap: TBitmap; // target bitmap

    FMode: TDrawMode;
    FIsDrawing: Boolean;
    FPen: TPen;

    FStartPoint: TPoint;
    FEndPoint: TPoint;

    FCommands: TDictionary<TCommandType, TCommand>;

  public
    constructor Create(AImageBitmap: TBitmap);

    destructor Destory();

    procedure HandleEvents();

    procedure HandleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

    procedure HandleMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);

    procedure HandleMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);

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
  FPen := TPen.Create;
  // copy the reference of image to change or update it
  FImageBitmap := AImageBitmap;

  FCommands := TDictionary<TCommandType, TCommand>.Create;
  // create commands bind command with receiver
  Receiver := TGraphicReceiver.Create(FImageBitmap);

  // DrawLine:
  Commands := TCmdDrawLine.Create(Receiver);
  FCommands.Add(cmdLINE, Commands);
  // DrawRectangle:
  Commands := TCmdDrawRectangle.Create(Receiver);
  FCommands.Add(cmdRECTANGLE, Commands);
  // MoveTo:
  Commands := TCmdMovePoint.Create(Receiver);
  FCommands.Add(cmdMOVE, Commands);
  // LineTo:
  Commands := TCmdConnectPoint.Create(Receiver);
  FCommands.Add(cmdCONNECT, Commands);

end;

destructor TManager.Destory;
begin
  // FPrevBitmap.Free;
  FPen.Free;
  FCommands.Free;
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
    FStartPoint := Point(X, Y);
    FEndPoint := FStartPoint;
    // normal case:
    case FMode of
      drawBRUSH:
      begin

        if FCommands.TryGetValue(cmdMOVE, Command) then
        begin
          TCmdMovePoint(Command).SetPoint(FStartPoint);
          Command.Execute;
        end;
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
        if FCommands.TryGetValue(cmdCONNECT, Command) then
        begin
          TCmdConnectPoint(Command).SetPoint(Point(X, Y));
          Command.Execute;
        end;
      end;
      drawLINE:
      begin
        if FCommands.TryGetValue(cmdLINE, Command) then
        begin
          TCmdDrawLine(Command).SetPoint(FStartPoint, Point(X, Y));
          Command.Update();
        end;
      end;
      drawRECTANGLE:
      begin
        if FCommands.TryGetValue(cmdRECTANGLE, Command) then
        begin
          TCmdDrawRectangle(Command).SetPoint(FStartPoint, Point(X, Y));
          Command.Update();
        end;
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
  Command: TCommand;
begin
  if Button = mbLeft then
  begin
    if FIsDrawing then
    begin
      case FMode of
        drawBRUSH:
        begin
          if FCommands.TryGetValue(cmdCONNECT, Command) then
          begin
            TCmdConnectPoint(Command).SetPoint(Point(X, Y));
            Command.Execute();
          end;
        end;
        drawLINE:
        begin
          if FCommands.TryGetValue(cmdLINE, Command) then
          begin
            TCmdDrawLine(Command).SetPoint(FStartPoint, Point(X, Y));
            Command.Execute();
          end;
        end;
        drawRECTANGLE:
        begin
          if FCommands.TryGetValue(cmdRECTANGLE, Command) then
          begin
            TCmdDrawRectangle(Command).SetPoint(FStartPoint, Point(X, Y));
            Command.Execute();
          end;
        end;
        drawCIRCLE:;
        drawERASE:;
      end;
    end;
    FIsDrawing := False;
  end;
end;

end.

