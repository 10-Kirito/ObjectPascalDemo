unit Tools;

interface

uses
  Classes, Graphics, Windows;

type
  TDrawMode = (drawBRUSH, drawLINE, drawRECTANGLE, drawCIRCLE, drawERASE,
    drawSELECT);

  TDrawPen = class
  private
    FColor: TColor;
    FWidth: Integer;
  public
    constructor Create;

    function GetWidth: Integer;
    procedure SetWidth(AWidth: Integer);

    procedure Assign(APen: TDrawPen);

    property PColor: TColor read FColor write FColor;
    property PWidth: Integer read GetWidth write SetWidth;
  end;

implementation

{ TDrawPen }

procedure TDrawPen.Assign(APen: TDrawPen);
begin
  FColor := APen.FColor;
  FWidth := APen.FWidth;
end;

constructor TDrawPen.Create;
begin
  FColor := clBlack;
  FWidth := 3;
end;

function TDrawPen.GetWidth: Integer;
begin
  Exit(FWidth);
end;

procedure TDrawPen.SetWidth(AWidth: Integer);
begin
  FWidth := AWidth;
end;

end.
