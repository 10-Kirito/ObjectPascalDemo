unit History;

interface

uses
  Graphics, Generics.Collections, Commands;

type
  THistoryItem = class
  private
    FSnapshot: TBitmap;
    FCommandList: TList<TCommand>;

    FIndex: Integer; // record the current command index

    class var
      MAXSIZE: Integer; // the maxsize of storage of commands
  public
    constructor Create;
    destructor Destroy; override;

    function ExecuteCommands: TBitmap;

    procedure DeleteSnapshot;
  end;

  THistory = class
  private
  private
    FHistoryList: TList<THistoryItem>;
    FIndex: Integer;

  public
    constructor Create;
    destructor Destroy; override;

    procedure AddHistory(ABitmap: TBitmap; ACommand: TCommand);
    // return the target bitmap
    function UndoHistory: TBitmap;
    function RedoHistory: TBitmap;


  end;

implementation


{ THistory }

constructor THistory.Create;
begin
  FHistoryList := TList<THistoryItem>.Create;
  FIndex := 0;
end;

destructor THistory.Destroy;
begin
  FHistoryList.Free;
end;

procedure THistory.AddHistory(ACommand: TCommand);
begin


end;

procedure THistory.RedoHistory(ABitmap: TBitmap);
begin

end;

procedure THistory.UndoHistory(ABitmap: TBitmap);
begin

end;

initialization
  THistoryItem.MAXSIZE := 10;


end.
