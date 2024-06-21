unit GraphicFile;

interface

uses
  Windows, SysUtils, Dialogs, Generics.Collections, superobject, GraphicObject,
  GraphicManager, Tools;

type
  TDataFile = class
  private
  public
    constructor Create;
    destructor Destroy; override;

    class function ImportFile(AString: string; AManager: TGraphicManager): TList<TGraphicObject>;
    class function ExportFile(AManager: TGraphicManager): ISuperObject;
  end;

implementation

{ Tools }

function ParsePoint(LPoint: TPoint): ISuperObject;
begin
  Result := SO;
  Result.I['x'] := LPoint.X;
  Result.I['y'] := LPoint.Y;
end;

function ParsePoints(LPoints: TList<TPoint>): ISuperObject;
var
  LPoint: TPoint;
begin
  Result := SA([]);
  for LPoint in LPoints do
  begin
    Result.AsArray.Add(ParsePoint(LPoint));
  end;
end;

function ParsePointFromJson(ASuperObject: ISuperObject): TPoint;
begin
   Result.X := ASuperObject.I['x'];
   Result.Y := ASuperObject.I['y'];
end;

function ParsePointsFromJson(ASuperObject: TSuperArray): TList<TPoint>;
var
 AElement: ISuperObject;
 Index: Integer;
begin
  Result := TList<TPoint>.Create;

  for Index := 0 to ASuperObject.Length - 1 do
  begin
    AElement := ASuperObject.O[Index]; // 获取数组中的对象元素
    Result.Add(ParsePointFromJson(AElement));
  end;
end;

function ParseGraphicFromJson(AElement: ISuperObject): TGraphicObject;
var
  LObject: TGraphicObject;

  LTemp: TList<TPoint>;
  AGUID: string;
begin
  case StrToType(AElement.S['type']) of
    FREEHAND:
      begin
        LTemp:= ParsePointsFromJson(AElement.O['points'].AsArray);
        LObject := TFreeLine.Create(LTemp);
        LTemp.Free;
      end;
    LINE:
      begin
        LObject := TLine.Create(ParsePointFromJson(AElement.O['startpoint']),
          ParsePointFromJson(AElement.O['endpoint']));
      end;
    RECTANGLE:
      begin
        LObject := TRectangle.Create(ParsePointFromJson(AElement.O['startpoint']),
          ParsePointFromJson(AElement.O['endpoint']));
      end;
    ELLIPSE:
      begin
        LObject := TELLIPSE.Create(ParsePointFromJson(AElement.O['startpoint']),
          ParsePointFromJson(AElement.O['endpoint']));
      end;
  end;

  AGUID := AElement.S['GUID'];
  LObject.PGUID := StringToGUID(AGUID);

  LObject.SetColor(AElement.I['color']);
  LObject.SetWidth(AElement.I['width']);

  Result := LObject;
end;



{ DrawFile }

constructor TDataFile.Create;
begin

end;

destructor TDataFile.Destroy;
begin

  inherited;
end;

class function TDataFile.ExportFile(AManager: TGraphicManager): ISuperObject;
var
  LFile: ISuperObject;
  LElement: ISuperObject;
  LElements: ISuperObject;
  LPoints: ISuperObject;
  LGraphicDic: TDictionary<TGUID, TGraphicObject>;
  LPair: TPair<TGUID, TGraphicObject>;
  LGraphicObject: TGraphicObject;
  LListPoint: TList<TPoint>;
  GUIDString: string;
  SaveDialog: TSaveDialog;
begin
  LGraphicDic := AManager.GetDictionnary;
  LFile := SO;
  LElements := SA([]);

  for LPair in LGraphicDic do
  begin
    LElement := SO;
    LGraphicObject := LPair.Value;
    LElement.S['type'] := TypeToStr(LGraphicObject.GetType);

    GUIDString := GUIDToString(LGraphicObject.GetGUID);
    // GUIDString := StringReplace(GUIDString, '{', '', [rfReplaceAll]);
    // GUIDString := StringReplace(GUIDString, '}', '', [rfReplaceAll]);
    LElement.S['GUID'] := GUIDString;
    LElement.I['width'] := LGraphicObject.GetWidth;
    LElement.I['color'] := LGraphicObject.GetColor;

    LListPoint := LGraphicObject.GetPoints;
    case LGraphicObject.GetType of
      FREEHAND:
        begin
          LPoints := ParsePoints(LListPoint);
          LElement.O['points'] := LPoints;
        end;
      LINE:
        begin
          LElement.O['startpoint'] := ParsePoint(LListPoint[0]);
          LElement.O['endpoint'] := ParsePoint(LListPoint[1]);
        end;
      RECTANGLE:
        begin
          LElement.O['startpoint'] := ParsePoint(LListPoint[0]);
          LElement.O['endpoint'] := ParsePoint(LListPoint[1]);
        end;
      ELLIPSE:
        begin
          LElement.O['startpoint'] := ParsePoint(LListPoint[0]);
          LElement.O['endpoint'] := ParsePoint(LListPoint[1]);
        end;
    end;
    LElements.AsArray.Add(LElement);
    LListPoint.Free;
  end;
  LFile.O['elements'] := LElements;

  Result := LFile;
end;

class function TDataFile.ImportFile(AString: string; AManager: TGraphicManager): TList<TGraphicObject>;
var
  AFile: ISuperObject;
  AElementsArray: TSuperArray;
  AElement: ISuperObject;
  Index: Integer;
begin
  Result := TList<TGraphicObject>.Create;

  AFile := TSuperObject.ParseFile(AString, True);
  AElementsArray := AFile.O['elements'].AsArray;

  try
    // parsing the graphic objects
    for Index := 0 to AElementsArray.Length - 1 do
    begin
      AElement := AElementsArray.O[Index]; // 获取数组中的对象元素
      AManager.RegisterObject(ParseGraphicFromJson(AElement));
      Result.Add(ParseGraphicFromJson(AElement));
    end;
  finally
  end;
end;

end.

