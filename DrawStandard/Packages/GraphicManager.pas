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
    destructor Destroy;

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
begin
  FGraphicDic.Free;
end;

procedure TGraphicManager.RegisterObject(AObject: TGraphicObject);
begin
  FGraphicDic.Add(AObject.PGUID, AObject);
end;

end.
