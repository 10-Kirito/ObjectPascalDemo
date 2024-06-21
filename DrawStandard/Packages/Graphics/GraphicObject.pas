unit GraphicObject;

interface

uses
  Windows, Graphics, SysUtils, Generics.Collections, Tools;

type
  TGraphicType = (FREEHAND, LINE, RECTANGLE, ELLIPSE);

  TGraphicObject = class
  private
    FType: TGraphicType;
    FColor: TColor;
    FWidth: Integer;

    FID: TGUID;

  public
    // constructor and destructor
    constructor Create;
    // get all points of the graphic
    function GetPoints: TList<TPoint>; virtual; abstract;
    // check the point if exist in the graphic
    function CheckPointExist(APoint: TPoint): Boolean; virtual; abstract;

    // draw a select box
    procedure DrawSelectBox(ABitmap: TBitmap); virtual; abstract;

    procedure SetPen(APen: TDrawPen);

    // functions and procedures
    function GetType: TGraphicType;
    procedure SetType(AType: TGraphicType);
    function GetColor: TColor;
    procedure SetColor(AColor: TColor);
    function GetWidth: Integer;
    procedure SetWidth(AWidth: Integer);
    function GetGUID: TGUID; // will created in the Create; only for read;

    // properties
    property PType: TGraphicType read GetType write SetType;
    property PColor: TColor read GetColor write SetColor;
    property PWidth: Integer read GetWidth write SetWidth;
    property PGUID: TGUID read GetGUID write FID;
  end;

  TLine = class(TGraphicObject)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create(AStart: TPoint; AEnd: TPoint);
    function GetPoints: TList<TPoint>; override;
    function CheckPointExist(APoint: TPoint): Boolean;override;
    procedure DrawSelectBox(ABitmap: TBitmap);override;
  end;

  TRectangle = class(TGraphicObject)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create(AStart: TPoint; AEnd: TPoint);
    function GetPoints: TList<TPoint>; override;
    function CheckPointExist(APoint: TPoint): Boolean;override;
    procedure DrawSelectBox(ABitmap: TBitmap);override;
  end;

  TELLIPSE = class(TGraphicObject)
  private
    FStartPoint: TPoint;
    FEndPoint: TPoint;
  public
    constructor Create(AStart: TPoint; AEnd: TPoint);
    function GetPoints: TList<TPoint>; override;
    function CheckPointExist(APoint: TPoint): Boolean;override;
    procedure DrawSelectBox(ABitmap: TBitmap);override;
  end;

  TFreeLine = class(TGraphicObject)
  private
    FPoints: TList<TPoint>;
  public
    constructor Create(APoints: TList<TPoint>);
    destructor Destroy; override;

    function GetPoints: TList<TPoint>; override;
    function CheckPointExist(APoint: TPoint): Boolean;override;
    procedure DrawSelectBox(ABitmap: TBitmap);override;
  end;

function TypeToStr(AType: TGraphicType): string;

function StrToType(AString: string): TGraphicType;

implementation

{ TGraphicObject }

constructor TGraphicObject.Create;
begin
  CreateGUID(FID);
end;

function TGraphicObject.GetColor: TColor;
begin
  Result := FColor;
end;

function TGraphicObject.GetGUID: TGUID;
begin
  Result := FID;
end;

function TGraphicObject.GetType: TGraphicType;
begin
  Result := FType;
end;

function TGraphicObject.GetWidth: Integer;
begin
  Result := FWidth;
end;

procedure TGraphicObject.SetColor(AColor: TColor);
begin
  FColor := AColor;
end;

procedure TGraphicObject.SetPen(APen: TDrawPen);
begin
  FColor := APen.PColor;
  FWidth := APen.GetWidth;
end;

procedure TGraphicObject.SetType(AType: TGraphicType);
begin
  FType := AType;
end;

procedure TGraphicObject.SetWidth(AWidth: Integer);
begin
  FWidth := AWidth;
end;

{ TLine }

function TLine.CheckPointExist(APoint: TPoint): Boolean;
var
  distance: Double;
begin
  // just need to determine the distance between the given point and the line if is zero
  //    if zero return true;
  //    else return false;
  Result := (PointToLineDistance(FStartPoint, FEndPoint, APoint) < 1);
end;

constructor TLine.Create(AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FType := LINE;
end;

procedure TLine.DrawSelectBox(ABitmap: TBitmap);
var
  LWidth: Integer;
begin
  ABitmap.Canvas.Pen.Style := psDot;
  LWidth := ABitmap.Canvas.Pen.Width;
  ABitmap.Canvas.Pen.Width := 1;
  ABitmap.Canvas.Rectangle(FStartPoint.X - 3, FStartPoint.Y - 3,
                           FEndPoint.X + 3, FEndPoint.Y + 3);
  ABitmap.Canvas.Pen.Style := psSolid;
  ABitmap.Canvas.Pen.Width := LWidth;
end;

function TLine.GetPoints: TList<TPoint>;
begin
  Result := TList<TPoint>.Create;
  Result.Add(FStartPoint);
  Result.Add(FEndPoint);
end;

{ TRectangle }
function TRectangle.CheckPointExist(APoint: TPoint): Boolean;
begin
///
///start - - - -  -
///  -   - - - -  -
///  -   - - - -  -
///  -   - - - - end
///
///end - - - -  -
///  -   - - - -  -
///  -   - - - -  -
///  -   - - - - start
///
  Result := False;

end;

constructor TRectangle.Create(AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FType := RECTANGLE;
end;

procedure TRectangle.DrawSelectBox(ABitmap: TBitmap);
begin

end;

function TRectangle.GetPoints: TList<TPoint>;
begin
  Result := TList<TPoint>.Create;
  Result.Add(FStartPoint);
  Result.Add(FEndPoint);
end;


{ TFreeLine }

function TFreeLine.CheckPointExist(APoint: TPoint): Boolean;
begin
   Result := False;
end;

constructor TFreeLine.Create(APoints: TList<TPoint>);
var
  LPoint: TPoint;
begin
  inherited Create;

  FPoints := TList<TPoint>.Create;
  if Assigned(APoints) then
  begin
    for LPoint in APoints do
    begin
      FPoints.Add(LPoint);
    end;
  end;

  FType := FREEHAND;
end;

destructor TFreeLine.Destroy;
begin
  FreeAndNil(FPoints);
end;

procedure TFreeLine.DrawSelectBox(ABitmap: TBitmap);
begin

end;

function TFreeLine.GetPoints: TList<TPoint>;
var
  LPoint: TPoint;
begin
  Result := TList<TPoint>.Create;

  for LPoint in FPoints do
  begin
    Result.Add(LPoint);
  end;
end;

{ TELLIPSE }

function TELLIPSE.CheckPointExist(APoint: TPoint): Boolean;
begin
   Result := False;
end;

constructor TELLIPSE.Create(AStart, AEnd: TPoint);
begin
  inherited Create;

  FStartPoint := AStart;
  FEndPoint := AEnd;

  FType := RECTANGLE;
end;

procedure TELLIPSE.DrawSelectBox(ABitmap: TBitmap);
begin

end;

function TypeToStr(AType: TGraphicType): string;
begin
  case AType of
    FREEHAND:
      begin
        Result := 'freehand';
      end;
    LINE:
      begin
        Result := 'line';
      end;
    RECTANGLE:
      begin
        Result := 'rectangle';
      end;
    ELLIPSE:
      begin
        Result := 'ellipse';
      end;
  end;
end;

function TELLIPSE.GetPoints: TList<TPoint>;
begin
  Result := TList<TPoint>.Create;
  Result.Add(FStartPoint);
  Result.Add(FEndPoint);
end;

function StrToType(AString: string): TGraphicType;
begin

  if AString = 'line' then
  begin
    Result := LINE;
  end
  else if AString = 'freehand' then
  begin
    Result := FREEHAND;
  end
  else if AString = 'rectangle' then
  begin
    Result := RECTANGLE;
  end
  else if AString = 'ellipse' then
  begin
    Result := ELLIPSE;
  end;
end;

end.

