unit GraphicBasic;

interface

uses
  Windows, Classes, Graphics;

type
  TGraphicReceiver = class
  private
    FBitMap: TBitmap;
  public
    constructor Create(ABitMap: TBitmap);

    procedure UpdateCanvas(ABitMap: TBitmap);

    function DrawLine(AStart: TPoint; AEnd: TPoint): TBitmap;

    function DrawRectangle(AStart: TPoint; AEnd: TPoint): TBitmap;

    // fucntion DrawCircle(): TBitmap;
  end;




implementation




{ TGraphicReceiver }

constructor TGraphicReceiver.Create(ABitMap: TBitmap);
begin
  FBitMap := ABitMap;
end;

function TGraphicReceiver.DrawLine(AStart, AEnd: TPoint): TBitmap;
begin
  FBitMap.Canvas.MoveTo(AStart.X, AStart.Y);
  FBitMap.Canvas.LineTo(AEnd.X, AEnd.Y);
  Exit(FBitMap);
end;

function TGraphicReceiver.DrawRectangle(AStart, AEnd: TPoint): TBitmap;
begin
  Exit(FBitMap);
end;

procedure TGraphicReceiver.UpdateCanvas(ABitMap: TBitmap);
begin
  FBitMap := ABitMap;
end;

end.
