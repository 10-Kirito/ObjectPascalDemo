unit Tools;

interface

uses
  Classes, Graphics, Windows, SysUtils;

type
  TDrawMode = (drawBRUSH, drawLINE, drawRECTANGLE, drawCIRCLE, drawERASE,
    drawSELECT, drawELLIPSE);

  TDrawPen = class
  private
    FColor: TColor;
    FWidth: Integer;
  public
    constructor Create;

    function GetWidth: Integer;
    procedure SetWidth(AWidth: Integer);

    property PColor: TColor read FColor write FColor;
    property PWidth: Integer read GetWidth write SetWidth;
  end;

function DrawTime: string;

implementation

{ TDrawPen }

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

function DrawTime: string;
var
  CurrentTime: TDateTime;
begin
  CurrentTime := Now; // ��ȡ��ǰ���ں�ʱ��
  Result := FormatDateTime('yyyy-mm-dd-hh-nn-ss', CurrentTime);
end;

end.
