unit GraphicManager;

interface

uses
  Windows, Graphics, Generics.Collections, SysUtils, GraphicObject;

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

    function PointExitsObject(APoint: TPoint): TList<TGraphicObject>;

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

function TGraphicManager.PointExitsObject(
  APoint: TPoint): TList<TGraphicObject>;
var
  Graphic: TGraphicObject;
begin
  /// 由于可能存在有着重叠的图形，所以这里检查的时候返回的是一个链表
  Result := TList<TGraphicObject>.Create;

  for Graphic in FGraphicDic.Values do
  begin
    if Graphic.CheckPointExist(APoint) then
    begin
      Result.Add(Graphic);
    end;
  end;
end;

procedure TGraphicManager.RegisterObject(AObject: TGraphicObject);
begin
  FGraphicDic.Add(AObject.PGUID, AObject);
end;

end.
