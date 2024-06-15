unit History;

interface

uses
  Graphics, Generics.Collections, Commands;

type
  THistory = class
  private
  type
    TCommandList = TList<TCommand>;
    TItem = TPair<TBitmap, TCommandList>;
  private
    FHistoryList: TList<TItem>;
    FIndex: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    procedure AddHistory(ACommand: TCommand);
    procedure UndoHistory(ABitmap: TBitmap);
    procedure RedoHistory(ABitmap: TBitmap);
  end;

implementation


{ THistory }

constructor THistory.Create;
begin
  FHistoryList := TList<TItem>.Create;
  FIndex := 0;
end;

destructor THistory.Destroy;
begin
  FHistoryList.Free;
end;

procedure THistory.AddHistory(ACommand: TCommand);
var
  LCmdList: TCommandList;
  LCommand: TCommand;
begin


end;

procedure THistory.RedoHistory(ABitmap: TBitmap);
begin

end;

procedure THistory.UndoHistory(ABitmap: TBitmap);
begin

end;

end.
