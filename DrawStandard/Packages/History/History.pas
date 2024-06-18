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

    function HasRedoCommands: Boolean;
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
var
  LItem: THistoryItem;
begin
  for LItem in FHistoryList do
  begin
     LItem.Free;
  end;
  FHistoryList.Free;
end;

function THistory.Empty: Boolean;
begin
  Result := (FCurrentIndex = -1);
end;

// THistory内部函数，用来判断当前是否存在需要Redo的命令
function THistory.HasRedoCommands: Boolean;
var
  LItem: THistoryItem;
begin

  // 1. 利用FHasRedo变量来判断当前是否处于可以Redo的状态
  //    如果处于可以Redo的状态，进行判断当前是否有待Redo的命令
  //    如果没有处于Redo的状态，直接进行返回即可。
  if not FHasRedo then
  begin
    Result := False;
    Exit;
  end;

  {
  示意图：
    -> FCurrentIndex := -1 -> History is empty
       : REDO REDO REDO REDO REDO  -> Empty
       : REDO REDO REDO            -> Empty
  }

  // 2. 如果当前历史记录显示为空但是还处于可以Redo的状态，说明之前是Undo操作导致
  //    历史记录显示为空。
  if Empty then
  begin
    Result := (FHistoryList.Count > 0);
    Exit;
  end;

  {
  示意图：
  情景一：正常Undo之后，进行Redo操作
       FHasRedo := True;
       : COMD COMD COMD COMD COMD  -> Full    <- Item
       : COMD COMD COMD COMD COMD  -> Full    <- Item
    -> : COMD COMD COMD REDO REDO  -> UnFull  <- CurrentItem
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO            -> Empty   <- Item

  情景二：正常Undo但是导致当前HistoryItem切换
       FHasRedo := True;
       : COMD COMD COMD COMD COMD  -> Full    <- Item
       : COMD COMD COMD COMD COMD  -> Full    <- Item
    -> : COMD COMD COMD COMD COMD  -> Full    <- CurrentItem
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO            -> Empty   <- Item

  情景三：一直做Redo导致的情况
       FHasRedo := True;
       : COMD COMD COMD COMD COMD  -> Full    <- Item
       : COMD COMD COMD COMD COMD  -> Full    <- Item
       : COMD COMD COMD COMD COMD  -> Full    <- Item
       : COMD COMD COMD COMD COMD  -> Full    <- Item
    -> : COMD COMD COMD            -> UnFull  <- CurrentItem
  }

  // 3. 当前历史记录显示不为空，判断当前FHistoryItem是否存在需要Redo的命令，
  //    如果存在Redo命令，返回True；
  //    如果不存在Redo命令，判断是否存在其余的FHistoryItem，可能其余的FHistoryItem
  //    全部都是需要Redo的命令。
  LItem := FHistoryList[FCurrentIndex];
  if not LItem.Full then
  begin
    Result := LItem.HasRedoItem;
    Exit;
  end;

  Result := (FCurrentIndex < (FHistoryList.Count - 1));
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
var
  LHistoryItem: THistoryItem;
  LBitmap: TBitmap;
  LIndex: Integer;
begin
  {
    1. 首先判断当前是否存在可以Redo的命令，这里通过类内的函数HasRedoCommands来实现。
  }
  if not HasRedoCommands then
  begin
    Exit; // 如果没有, 直接退出...
  end;

  {
    2. 虽然当前存在可以Redo的命令，但是分为下面几种情景：
    示意图：
    情景零：一直Undo操作导致历史记录显示为空
    -> := -1 -> History is empty              <- CurrentItem
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO            -> Empty   <- Item

    情景一：正常Undo之后，进行Redo操作
         FHasRedo := True;
         : COMD COMD COMD COMD COMD  -> Full    <- Item
         : COMD COMD COMD COMD COMD  -> Full    <- Item
      -> : COMD COMD COMD REDO REDO  -> UnFull  <- CurrentItem
         : REDO REDO REDO REDO REDO  -> Empty   <- Item
         : REDO REDO REDO            -> Empty   <- Item

    情景二：正常Undo但是导致当前HistoryItem切换
         FHasRedo := True;
         : COMD COMD COMD COMD COMD  -> Full    <- Item
         : COMD COMD COMD COMD COMD  -> Full    <- Item
      -> : COMD COMD COMD COMD COMD  -> Full    <- CurrentItem
         : REDO REDO REDO REDO REDO  -> Empty   <- Item
         : REDO REDO REDO            -> Empty   <- Item

    情景三：一直做Redo导致的情况
         FHasRedo := True;
         : COMD COMD COMD COMD COMD  -> Full    <- Item
         : COMD COMD COMD COMD COMD  -> Full    <- Item
         : COMD COMD COMD COMD COMD  -> Full    <- Item
         : COMD COMD COMD COMD COMD  -> Full    <- Item
      -> : COMD COMD COMD            -> UnFull  <- CurrentItem
  }

  {
    2. 判断当前历史记录是否显示为空，因为有一种特殊情况是一直Undo操作，导致当前
       历史记录看起来为空，此时只能手动访问第一个THistoryItem。
       当然，如果当前历史记录不为空的话，直接访问FCurrentIndex对应的Item即可。
  }
  if Empty then
  begin
    LHistoryItem := FHistoryList[0];
    FCurrentIndex := FCurrentIndex + 1;
    LHistoryItem.RedoCommand;
    LBitmap := LHistoryItem.ExecuteCurrentCommands;
    ABitmap.Assign(LBitmap);
    LBitmap.Free;
    Exit;
  end;

  LHistoryItem := FHistoryList[FCurrentIndex];

  if LHistoryItem.HasRedoItem then // 情景一
  begin
    LHistoryItem.RedoCommand;
    LBitmap := LHistoryItem.ExecuteCurrentCommands;
    ABitmap.Assign(LBitmap);
    LBitmap.Free;
  end
  else if not LHistoryItem.Full then // 情景三
  begin
    FHasRedo := False;
    Exit;
  end
  else // 情景二
  begin
    FCurrentIndex := FCurrentIndex + 1;
    LHistoryItem := FHistoryList[FCurrentIndex];
    LHistoryItem.RedoCommand;
    LBitmap := LHistoryItem.ExecuteCurrentCommands;
    ABitmap.Assign(LBitmap);
    LBitmap.Free;
  end;
end;

/// <summary>
///   每一次添加新的命令之后，当前命令之后的命令全部删除并释放对应的资源，即之后
///   不能进行添加新命令之前的Redo操作。
/// </summary>
procedure THistory.ReleaseRedoResource;
var
  LItem: THistoryItem;
  LMaxIndex: Integer;
  LIndex: Integer;
begin
  {
    1. 如果当前并没有待Redo的命令，就直接返回
  }
  if (not FHasRedo) then
  begin
    Exit;
  end;
  {
    2. 如果当前检测历史记录为空，但是显示可以进行Redo操作，说明当前所有的命令都是Redo
       这个时候添加新的命令的时候，将所有的历史记录删除即可!!!
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
    3. 将处于当前命令组A当中的待执行的Redo命令全部删除!!
         - : _ _ _ _ _ _ _ _ _ _
         - : _ _ _ _ _ _ _ _ _ _
    Index->: _ _ _ * _ _ _ _ _ _  A <-- Undo操作移动当前命令下标到(*)
         - : _ _ _                B <-- Redo操作可以回退的命令
  }
  LItem := FHistoryList[FCurrentIndex];
  LItem.ReleaseRedoResource;
  {
    4. 判断是否需要删除之后的Redo命令，即是否可能存在命令组B和命令组C
  }
  // LMaxIndex := ; // 当前所有的命令组[0, FHistoryList.Count - 1]
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
  if (FRedoIndex >= 0) and (FRedoIndex < FCommandList.Count) then
  begin
    FCurrentIndex := FRedoIndex;
    FRedoIndex := FRedoIndex + 1;
  end;
  if FRedoIndex = FCommandList.Count then
  begin
    FRedoIndex := -1;
  end;
  FNumber := FNumber + 1;
end;

{
  注意释放当前THistoryItem命令资源的时候，不能将快照FSnapShot释放掉，当前组未被释放的
  命令还需要使用FShapShot!
}
procedure THistoryItem.ReleaseRedoResource;
var
  LCommand: TCommand;
  LIndex: Integer;
begin
  // 如果说当前FRedoIndex的下标小于0，说明当前命令组当中并未含有Redo命令
  if FRedoIndex < 0 then
  begin
    Exit;
  end;

  for LIndex := FCommandList.Count - 1 downto FRedoIndex do
  begin
    LCommand := FCommandList[LIndex];
    FCommandList.Delete(LIndex);
    LCommand.Free;
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
  FCommandList.Free;
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
  THistoryItem.MAXSIZE := 4;

end.

