unit GraphicManager;

interface

uses
  Windows, Graphics, Generics.Collections, SysUtils, GraphicObject;

type
  TGraphicManager = class
  type
    ListItem = TPair<TGUID, TGraphicObject>;
  private
    // 一开始采用的数据结构，想法是便于删除和访问;
    FGraphicDic: TDictionary<TGUID, TGraphicObject>;

    // 为了保证元素有序，使用额外的一个List来存储所有的图形对象;
    FGraphicList: TList<ListItem>;
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
  FGraphicList := TList<ListItem>.Create;
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

  FreeAndNil(FGraphicList);
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
  LItem: ListItem;
  LObject: TGraphicObject;
begin
  /// 由于可能存在有着重叠的图形，所以这里检查的时候返回的是一个链表
  Result := TList<TGraphicObject>.Create;

  for LItem in FGraphicList do
  begin
    LObject := LItem.Value;
    if LObject.CheckPointExist(APoint) then
    begin
      Result.Add(LObject);
    end;
  end;
end;

procedure TGraphicManager.RegisterObject(AObject: TGraphicObject);
var
  LItem: ListItem;
begin
  FGraphicDic.Add(AObject.PGUID, AObject);

  LItem :=  ListItem.Create(AObject.PGUID, AObject);
  FGraphicList.Add(LItem);
end;

end.
