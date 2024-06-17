unit History;

{$O-}

interface

uses
  SysUtils, Graphics, Generics.Collections, Commands;

type
  THistoryItem = class
  private
    FSnapshot: TBitmap;
    FCommandList: TList<TCommand>;

    FCurrentIndex: Integer; // Record the current command index;
    FRedoIndex: Integer;    // FRedoIndex will only be changed when undo and redo
                            // and it will be set -1 when we add new command into history;
    FNumber: Integer;       // Record the number of the current commands, Redo commands except
    class var
      MAXSIZE: Integer;     // The maxsize of storage of commands;
  public
    constructor Create(ABitmap: TBitmap);
    destructor Destroy; override;

    procedure AddCommand(ACommand: TCommand);
    procedure UndoCommand;
    procedure RedoCommand;

    function Empty: Boolean;
    function Full: Boolean;
    function HasRedoItem: Boolean;
    function ExecuteCurrentCommands: TBitmap;

    function CommandNumber: Integer;

    procedure ReleaseRedoResource;
  end;

  THistory = class
  private
  private
    FHistoryList: TList<THistoryItem>;
    FCurrentIndex: Integer;

    FHasRedo: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    procedure AddHistory(ABitmap: TBitmap; ACommand: TCommand);

    procedure UndoHistory(ABitmap: TBitmap);
    procedure RedoHistory(ABitmap: TBitmap);
    function Empty: Boolean;
    procedure ReleaseRedoResource;
  end;

implementation

{ THistory }

constructor THistory.Create;
begin
  FHistoryList := TList<THistoryItem>.Create;
  FCurrentIndex := -1;
  FHasRedo := False;
end;

destructor THistory.Destroy;
begin
  FHistoryList.Free;
end;

function THistory.Empty: Boolean;
begin
  Result := (FCurrentIndex = -1);
end;

procedure THistory.AddHistory(ABitmap: TBitmap; ACommand: TCommand);
var
  LHistoryItem: THistoryItem;
begin
  // we need to release all redo resource when we add new command every time
  ReleaseRedoResource;
  // Set FHasRedo:
  FHasRedo := False;
  if Empty then // if the history is empty, create new item and add command into it
  begin
    LHistoryItem := THistoryItem.Create(ABitmap);
    LHistoryItem.AddCommand(ACommand);
    FHistoryList.Add(LHistoryItem);
    FCurrentIndex := FCurrentIndex + 1;
  end
  else // if the history isn't empty, add the command into current HistoryItem
  begin
    LHistoryItem := FHistoryList[FCurrentIndex];
    if LHistoryItem.Full then
    begin
      LHistoryItem := THistoryItem.Create(ABitmap);
      FHistoryList.Add(LHistoryItem);
      FCurrentIndex := FCurrentIndex + 1;
    end;
    LHistoryItem.AddCommand(ACommand);
  end;
end;

procedure THistory.RedoHistory(ABitmap: TBitmap);
begin

end;

/// <summary>
///   ÿһ������µ�����֮�󣬵�ǰ����֮�������ȫ��ɾ�����ͷŶ�Ӧ����Դ����֮��
///   ���ܽ������������֮ǰ��Redo������
/// </summary>
procedure THistory.ReleaseRedoResource;
var
  LItem: THistoryItem;
  LMaxIndex: Integer;
  LIndex: Integer;
begin
  {
    1. �����ǰ��û�д�Redo�������ֱ�ӷ���
  }
  if (not FHasRedo) then
  begin
    Exit;
  end;
  {
    2. �����ǰ�����ʷ��¼Ϊ�գ�������ʾ���Խ���Redo������˵����ǰ���е������Redo
       ���ʱ������µ������ʱ�򣬽����е���ʷ��¼ɾ������!!!
  }
  if Empty then
  begin
    for LItem in FHistoryList do
    begin
      LItem.Free;
    end;
    FHistoryList.DeleteRange(0, FHistoryList.Count);
    Exit;
  end;
  {
    3. �����ڵ�ǰ������A���еĴ�ִ�е�Redo����ȫ��ɾ��!!
         - : _ _ _ _ _ _ _ _ _ _
         - : _ _ _ _ _ _ _ _ _ _
    Index->: _ _ _ * _ _ _ _ _ _  A <-- Undo�����ƶ���ǰ�����±굽(*)
         - : _ _ _                B <-- Redo�������Ի��˵�����
  }
  LItem := FHistoryList[FCurrentIndex];
  LItem.ReleaseRedoResource;
  {
    4. �ж��Ƿ���Ҫɾ��֮���Redo������Ƿ���ܴ���������B��������C
  }
  // LMaxIndex := ; // ��ǰ���е�������[0, FHistoryList.Count - 1]
  LMaxIndex := FHistoryList.Count - 1;
  if FCurrentIndex < LMaxIndex then
  begin
    for LIndex := FHistoryList.Count - 1 downto FCurrentIndex + 1 do
    begin
      LItem := FHistoryList[LIndex];
      LItem.Free;
      FHistoryList.Delete(LIndex);
    end;
  end;
end;

procedure THistory.UndoHistory(ABitmap: TBitmap);
var
  LItem: THistoryItem;
begin
  // if history is empty, return directly
  if Empty then
  begin
    Exit;
  end;
  // Only we can redo if we do undo command
  FHasRedo := True;

  LItem := FHistoryList[FCurrentIndex];
  if LItem.FNumber = 1 then
  begin
    FCurrentIndex := FCurrentIndex - 1;
    LItem.UndoCommand;
    if FCurrentIndex >= 0 then
    begin
      LItem := FHistoryList[FCurrentIndex];
    end;
  end
  else
  begin
    LItem.UndoCommand;
  end;
  ABitmap.Assign(LItem.ExecuteCurrentCommands);
end;

{ THistoryItem }

procedure THistoryItem.AddCommand(ACommand: TCommand);
begin
  FCommandList.Add(ACommand);
  FCurrentIndex := FCurrentIndex + 1;
  FRedoIndex := -1;
  FNumber := FNumber + 1;
end;

function THistoryItem.CommandNumber: Integer;
begin
  Result := FCommandList.Count;
end;

constructor THistoryItem.Create(ABitmap: TBitmap);
begin
  { a snapshot for the target bitmap }
  FSnapshot := TBitmap.Create;
  if Assigned(ABitmap) then
  begin
    FSnapshot.Assign(ABitmap);
  end;

  FCommandList := TList<TCommand>.Create;
  FCurrentIndex := -1;
  FRedoIndex := -1;
  FNumber := 0;
end;

procedure THistoryItem.RedoCommand;
begin
  if (FRedoIndex >= 0) and (FRedoIndex < FNumber) then
  begin
    FCurrentIndex := FRedoIndex;
    FRedoIndex := FRedoIndex + 1;
  end;
  if FRedoIndex = FNumber then
  begin
    FRedoIndex := -1;
  end;
end;

{
  ע���ͷŵ�ǰTHistoryItem������Դ��ʱ�򣬲��ܽ�����FSnapShot�ͷŵ�����ǰ��δ���ͷŵ�
  �����Ҫʹ��FShapShot!
}
procedure THistoryItem.ReleaseRedoResource;
var
  LCommand: TCommand;
  LIndex: Integer;
begin
  for LIndex := FCommandList.Count - 1 downto FRedoIndex do
  begin
    LCommand := FCommandList[LIndex];
    LCommand.Free;
    FCommandList.Delete(LIndex);
  end;
end;

procedure THistoryItem.UndoCommand;
begin
  FRedoIndex := FCurrentIndex;
  FCurrentIndex := FCurrentIndex - 1;
  FNumber := FNumber - 1;
end;

destructor THistoryItem.Destroy;
var
  LCommand: TCommand;
begin
  FreeAndNil(FSnapshot);
  for LCommand in FCommandList do
  begin
    LCommand.Free;
  end;
  inherited;
end;

function THistoryItem.Empty: Boolean;
begin
  Result := (FCurrentIndex = -1);
end;

function THistoryItem.ExecuteCurrentCommands: TBitmap;
var
  LBitmap: TBitmap;
  LCommand: TCommand;
  Index: Integer;
begin
  LBitmap := TBitmap.Create;
  LBitmap.Assign(FSnapshot);
  for Index := 0 to FCurrentIndex do
  begin
    LCommand := FCommandList[Index];
    LCommand.Run(LBitmap);
  end;
  Result := LBitmap;
end;

function THistoryItem.Full: Boolean;
begin
  Result := (FCurrentIndex >= THistoryItem.MAXSIZE - 1);
end;

function THistoryItem.HasRedoItem: Boolean;
begin
  Result := (FRedoIndex > -1);
end;

initialization
  THistoryItem.MAXSIZE := 1;
end.

