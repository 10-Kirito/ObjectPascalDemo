unit GraphicManager;

interface

uses
  Graphics, Generics.Collections, SysUtils, GraphicObject;

type
  TGraphicManager = class
  private
    FGraphicDic: TDictionary<TGUID, TGraphicObject>;

  public
    constructor Create;
    destructor Destroy; override;

    procedure RegisterObject(AObject: TGraphicObject);

    function GetObject(AGUID: TGUID): TGraphicObject;
    procedure DeleteObject(AGUID: TGUID);

    function GetDictionnary: TDictionary<TGUID, TGraphicObject>;

  end;

implementation

{ TGraphicManager }

constructor TGraphicManager.Create;
begin
  FGraphicDic := TDictionary<TGUID, TGraphicObject>.Create;
end;

procedure TGraphicManager.DeleteObject(AGUID: TGUID);
begin
  FGraphicDic.Remove(AGUID);
end;

destructor TGraphicManager.Destroy;
var
  Graphic: TGraphicObject;
begin
  if Assigned(FGraphicDic) then
  begin
    for Graphic in FGraphicDic.Values do
    begin
      // FreeAndNil(Graphic);
      Graphic.Free;
    end;

    FreeAndNil(FGraphicDic);
  end;
end;

function TGraphicManager.GetDictionnary: TDictionary<TGUID, TGraphicObject>;
begin
  Result := FGraphicDic;
end;

function TGraphicManager.GetObject(AGUID: TGUID): TGraphicObject;
begin
  Result := FGraphicDic.Items[AGUID];
end;

procedure TGraphicManager.RegisterObject(AObject: TGraphicObject);
begin
  FGraphicDic.Add(AObject.PGUID, AObject);
end;

end.
