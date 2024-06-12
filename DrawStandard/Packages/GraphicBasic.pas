unit GraphicBasic;

interface

uses
  Classes, Graphics, Windows;

type
  TDrawMode = (drawBRUSH, drawLINE, drawRECTANGLE, drawCIRCLE, drawERASE, drawSELECT);

  TShapeType = (shapeLINE, shapeRECTANGLE, shapeCIRCLE);

  TDrawPen = class(TPen)
  private
    FDrawMode: TDrawMode;
  public
    property PMode: TDrawMode read FDrawMode write FDrawMode;
  end;


  IShape = interface
  ['{12144A75-CEEE-4A23-A1AE-125DAAE76BE4}']
    procedure DrawShape();
  End;

  {Factory class}

  TShapeFactory = class
  public
    class function GetShape(AShapeType: TShapeType): IShape;
  end;

implementation
type
  { Basic graphics class}
  TShapeBasic = class(TInterfacedPersistent, IShape)
  protected
    FShapeType: TShapeType;
  public
    procedure DrawShape(); virtual; abstract;
  end;
  
  TLine = class(TShapeBasic)
  private
    FStartPoint, FEndPoint: TPoint;
    
  public
    procedure DrawShape();
  end;

{ TShapeFactory }

class function TShapeFactory.GetShape(AShapeType: TShapeType): IShape;
begin

end;


{ TLine }

procedure TLine.DrawShape;
begin

end;

end.
