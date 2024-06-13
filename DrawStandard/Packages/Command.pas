unit Command;

interface

uses
  Classes, Windows, GraphicReceiver, Graphics, Rtti;

type
  {Command Types}
  TCommandType = (cmdLINE, cmdRECTANGLE, cmdMOVE, cmdCONNECT);

  {Base Command Class}

  TCommand = class
  private
    FReceiver: TGraphicReceiver;
  public
    constructor Create(AReceiver: TGraphicReceiver);
    destructor Destroy; virtual;
    procedure Execute; virtual; abstract;
    procedure Update; virtual; abstract;
    procedure Undo; virtual; abstract;
  end;

  TCmdDrawLine = class(TCommand)
  private
    FStart, FEnd: TPoint;
  public
    destructor Destroy; override;

    procedure Execute(); override;
    procedure Update(); override;
    procedure Undo(); override;

    procedure SetPoint(AStart: TPoint; AEnd: TPoint);
  end;

  TCmdDrawRectangle = class(TCommand)
  private
    FStart, FEnd: TPoint;
  public
    destructor Destroy(); override;

    procedure Execute(); override;
    procedure Update(); override;
    procedure Undo(); override;

    procedure SetPoint(AStart: TPoint; AEnd: TPoint);
  end;

  TCmdMovePoint = class(TCommand)
  private
    FPoint: TPoint;
  public
    destructor Destroy();override;

    procedure Execute(); override;
    procedure Update(); override;
    procedure Undo(); override;

    procedure SetPoint(APoint: TPoint);
  end;

  TCmdConnectPoint = class(TCommand)
  private
    FPoint: TPoint;
  public
    destructor Destroy();override;

    procedure Execute(); override;
    procedure Update(); override;
    procedure Undo(); override;

    procedure SetPoint(APoint: TPoint);
  end;

implementation

{ IDrawLine }

destructor TCmdDrawLine.Destroy;
begin
  inherited;
end;

procedure TCmdDrawLine.Execute;
begin
  FReceiver.DrawLine(FStart, FEnd);
end;

procedure TCmdDrawLine.SetPoint(AStart, AEnd: TPoint);
begin
  FStart := AStart;
  FEnd := AEnd;
end;

procedure TCmdDrawLine.Undo;
begin

end;

procedure TCmdDrawLine.Update;
begin
  FReceiver.UpdateLine(FStart, FEnd);
end;

{ TCmdDrawRectangle }

destructor TCmdDrawRectangle.Destroy;
begin
  inherited;
end;

procedure TCmdDrawRectangle.Execute;
begin
  FReceiver.DrawRectangle(FStart, FEnd);
end;

procedure TCmdDrawRectangle.SetPoint(AStart, AEnd: TPoint);
begin
  FStart := AStart;
  FEnd := AEnd;
end;

procedure TCmdDrawRectangle.Undo;
begin

end;

procedure TCmdDrawRectangle.Update;
begin
  FReceiver.UpdateRectangle(FStart, FEnd);
end;

{ TCmdMovePoint }

destructor TCmdMovePoint.Destroy;
begin
  inherited;
end;

procedure TCmdMovePoint.Execute;
begin
  FReceiver.MovePoint(FPoint);
end;

procedure TCmdMovePoint.SetPoint(APoint: TPoint);
begin
  FPoint := APoint;
end;

procedure TCmdMovePoint.Undo;
begin

end;

procedure TCmdMovePoint.Update;
begin

end;

{ TCommand }

constructor TCommand.Create(AReceiver: TGraphicReceiver);
begin
  FReceiver := AReceiver;
end;

destructor TCommand.Destroy;
begin
  FReceiver.Free;
end;

{ TCmdConnectPoint }

destructor TCmdConnectPoint.Destroy;
begin
  inherited;
end;

procedure TCmdConnectPoint.Execute;
begin
  FReceiver.ConnectPoint(FPoint);
end;

procedure TCmdConnectPoint.SetPoint(APoint: TPoint);
begin
  FPoint := APoint;
end;

procedure TCmdConnectPoint.Undo;
begin

end;

procedure TCmdConnectPoint.Update;
begin

end;

end.
