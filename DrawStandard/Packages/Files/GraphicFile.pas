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

    class function ImportFile(AString: string): TGraphicManager;
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
  LPair: TPair<TGUID,TGraphicObject>;
  LGraphicObject: TGraphicObject;
  LListPoint: TList<TPoint>;
  GUIDString: string;

  SaveDialog: TSaveDialog;
begin
  LGraphicDic :=  AManager.GetDictionnary;
  LFile := SO;
  LElements := SA([]);

  for LPair in LGraphicDic do
  begin
    LElement := SO;
    LGraphicObject := LPair.Value;
    LElement.S['type'] := TypeToStr(LGraphicObject.GetType);

    GUIDString := GUIDToString(LGraphicObject.GetGUID);
    GUIDString := StringReplace(GUIDString, '{', '', [rfReplaceAll]);
    GUIDString := StringReplace(GUIDString, '}', '', [rfReplaceAll]);
    LElement.S['GUID'] := GUIDString;
    LElement.I['width'] := LGraphicObject.GetWidth;
    LElement.I['color'] := LGraphicObject.GetColor;

    LListPoint := LGraphicObject.GetPoints;
    case LGraphicObject.GetType of
      FREEHAND:
        begin
          LPoints := ParsePoints(LListPoint);
          LFile.O['points'] := LPoints;
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

class function TDataFile.ImportFile(AString: string): TGraphicManager;
begin

end;

end.

