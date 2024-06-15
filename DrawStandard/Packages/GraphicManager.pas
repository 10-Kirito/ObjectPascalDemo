unit GraphicManager;

interface

uses
  Generics.Collections, SysUtils, GraphicObject;

type
  TGraphicManager = class
  private
    FGraphicDic: TDictionary<TGUID, TGraphicObject>;
  public
    constructor Create;
    destructor Destroy; override;

    procedure RegisterObject(AObject: TGraphicObject);
    procedure DeleteObject(AGUID: TGUID);
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

procedure TGraphicManager.RegisterObject(AObject: TGraphicObject);
begin
  FGraphicDic.Add(AObject.PGUID, AObject);
end;

end.
