unit Manage;

interface

uses
  Command, GraphicBasic, Graphics;

type
  TManager = class
  private
    FBitMap: TBitmap;
    FGraphicReceiver: TGraphicReceiver;
  public
    constructor Create(ABitMap: TBitmap);

  end;

implementation

{ TManager }

constructor TManager.Create(ABitMap: TBitmap);
begin
  FBitMap := ABitMap;
  FGraphicReceiver := TGraphicReceiver.Create(FBitMap);

  // create commands
end;

end.