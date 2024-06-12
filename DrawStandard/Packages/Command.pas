unit Command;

interface

uses
  Classes, Windows, GraphicBasic, Graphics;

type
  ICommand = interface
  ['{77B93657-BAE9-4962-8B7A-EFCAFC729047}']
    function Execute(): TBitmap;
    procedure Undo();
  end;

  IDrawLine = class(TInterfacedPersistent, ICommand)
  private
    FReceiver: TGraphicReceiver;
    FStart, FEnd: TPoint;
  public
    constructor Create(AReceiver: TGraphicReceiver; AStart: TPoint; AEnd: TPoint);
    function Execute(): TBitmap;
    procedure Undo();
  end;

implementation

{ IDrawLine }

constructor IDrawLine.Create(AReceiver: TGraphicReceiver; AStart: TPoint; AEnd: TPoint);
begin
  FReceiver := AReceiver;
  FStart := AStart;
  FEnd := AEnd;
end;

function IDrawLine.Execute: TBitmap;
begin
  Exit(FReceiver.DrawLine(FStart, FEnd));
end;

procedure IDrawLine.Undo;
begin

end;

end.