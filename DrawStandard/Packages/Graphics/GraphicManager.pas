unit GraphicManager;

interface

uses
  Windows, Graphics, Generics.Collections, SysUtils, GraphicObject;

type
  /// <summary>
  ///   所有绘制的图形对象管理中心
  ///   - 其中提供有注册图形对象，删除对象，返回满足条件的图形对象等方法
  /// </summary>
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

    /// <summary> 注册图形对象</summary>
    /// <param name="AObject"> 待注册的图形对象</param>
    procedure RegisterObject(AObject: TGraphicObject);

    /// <summary> 获取GUID对应的图形对象</summary>
    /// <param name="AGUID"> 图形对象的GUID</param>
    /// <returns> 返回GUID对应的图形对象</returns>
    function GetObject(AGUID: TGUID): TGraphicObject;

    /// <summary> 删除GUID对应的图形对象</summary>
    /// <param name="AGUID"> 传入的GUID参数</param>
    procedure DeleteObject(AGUID: TGUID);

    /// <summary> 获取字典</summary>
    function GetDictionnary: TDictionary<TGUID, TGraphicObject>;

    /// <summary> 返回所有包含给定顶点的图形对象</summary>
    /// <param name="APoint">给定的顶点</param>
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
  FGraphicDic.Add(AObject.GUID, AObject);

  LItem :=  ListItem.Create(AObject.GUID, AObject);
  FGraphicList.Add(LItem);
end;

end.
