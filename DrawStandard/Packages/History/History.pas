unit History;

{$O-}

interface

uses
  SysUtils, Graphics, Generics.Collections, Commands, GraphicManager;

type
  /// <summary>
  ///   ��ʷ��¼Histiry�ײ�����ݽṹ
  ///   - ��������Ӧ�Ŀ����Լ���Ӧ�������б�;
  ///   - �����ȡ��ǰ�����Ӧ�Ļ��ƽ��;
  ///   - �����е�ǰ�����Լ�Redo����ָ��;
  /// </summary>
  THistoryItem = class
  private
    FSnapshot: TBitmap;
    FCommandList: TList<TCommand>;
    FManager: TGraphicManager;

    FCurrentIndex: Integer; // Record the current command index;
    FRedoIndex: Integer;    // FRedoIndex will only be changed when undo and redo
                            // and it will be set -1 when we add new command into history;
    FNumber: Integer;       // Record the number of the current commands, Redo commands except
    class var
      MAXSIZE: Integer;     // The maxsize of storage of commands;
  public
    constructor Create(ABitmap: TBitmap; AManager: TGraphicManager);
    destructor Destroy; override;

    /// <summary> ��������ʷ��¼����</summary>
    /// <param name="ACommand"> ��Ҫ��ӵ�����</param>
    procedure AddCommand(ACommand: TCommand);

    /// <summary> ������ʷ��¼���е�����</summary>
    procedure UndoCommand;

    /// <summary> ���¸ղų���������</summary>
    procedure RedoCommand;

    /// <summary> �жϵ�ǰ��Ӧ��THistoryItem�Ƿ�Ϊ��</summary>
    function Empty: Boolean;

    /// <summary> �жϵ�ǰ��ӦTHistoryItem�Ƿ��Ѿ���</summary>
    function Full: Boolean;

    /// <summary> �жϵ�ǰ�Ƿ���Ҫ����ִ�е�����</summary>
    function HasRedoItem: Boolean;

    /// <summary> ��ȡ��ǰTHistoryItem���д洢[0, FCurrentIndex]֮��������Ӧ�Ļ��ƽ��</summary>
    /// <returns> ����TBitmap�������ƽ��</returns>
    function ExecuteCurrentCommands: TBitmap;

    /// <summary> ���ص�ǰTHistoryItem���д洢������ĸ�������������Redo������</summary>
    function CommandNumber: Integer;

    /// <summary> �����µ�����ִ�е�ʱ�򣬽���ǰTHistoryItem�洢��������Դ�ͷ�</summary>
    procedure ReleaseRedoResource;
  end;

  /// <summary>
  ///  ��ʷ��¼�ࣺ
  ///  - ��װ����Ӧ�ĳ����Լ�����������
  /// </summary>
  THistory = class
  private
    FHistoryList: TList<THistoryItem>;
    FCurrentIndex: Integer;
    FHasRedo: Boolean;
    FGraphicManger: TGraphicManager;
  public
    constructor Create(AManager: TGraphicManager);
    destructor Destroy; override;

    /// <summary> ����µĻ�������</summary>
    /// <param name="ABitmap">��ǰ��ӵ��µ��������֮ǰ��Bitmap</param>
    /// <param name="ACommand">�µĻ�������</param>
    procedure AddHistory(ABitmap: TBitmap; ACommand: TCommand);

    /// <summary> ������ʷ��¼���еĻ�������</summary>
    /// <param name="ABitmap"> ��ǰ������Ӧ��Bitmap</param>
    procedure UndoHistory(ABitmap: TBitmap);

    /// <summary> ����ִ�иղų����Ļ�������</summary>
    /// <param name="ABitmap">��ǰ������Ӧ��Bitmap</param>
    procedure RedoHistory(ABitmap: TBitmap);

    /// <summary> �жϵ�ǰ��ʷ��¼�Ƿ�Ϊ��</summary>
    function Empty: Boolean;

    /// <summary> �����µ�������ӵ���ʷ��¼���е�ʱ���ͷ���ʷ��¼���еȴ�����ִ�е�������Դ</summary>
    procedure ReleaseRedoResource;

    /// <summary> �жϵ�ǰ�Ƿ���д�����ִ�е�����</summary>
    function HasRedoCommands: Boolean;
  end;

implementation

{ THistory }

constructor THistory.Create(AManager: TGraphicManager);
begin
  FHistoryList := TList<THistoryItem>.Create;
  FCurrentIndex := -1;
  FHasRedo := False;

  FGraphicManger := AManager;
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

// THistory�ڲ������������жϵ�ǰ�Ƿ������ҪRedo������
function THistory.HasRedoCommands: Boolean;
var
  LItem: THistoryItem;
begin

  // 1. ����FHasRedo�������жϵ�ǰ�Ƿ��ڿ���Redo��״̬
  //    ������ڿ���Redo��״̬�������жϵ�ǰ�Ƿ��д�Redo������
  //    ���û�д���Redo��״̬��ֱ�ӽ��з��ؼ��ɡ�
  if not FHasRedo then
  begin
    Result := False;
    Exit;
  end;

  {
  ʾ��ͼ��
    -> FCurrentIndex := -1 -> History is empty
       : REDO REDO REDO REDO REDO  -> Empty
       : REDO REDO REDO            -> Empty
  }

  // 2. �����ǰ��ʷ��¼��ʾΪ�յ��ǻ����ڿ���Redo��״̬��˵��֮ǰ��Undo��������
  //    ��ʷ��¼��ʾΪ�ա�
  if Empty then
  begin
    Result := (FHistoryList.Count > 0);
    Exit;
  end;

  {
  ʾ��ͼ��
  �龰һ������Undo֮�󣬽���Redo����
       FHasRedo := True;
       : COMD COMD COMD COMD COMD  -> Full    <- Item
       : COMD COMD COMD COMD COMD  -> Full    <- Item
    -> : COMD COMD COMD REDO REDO  -> UnFull  <- CurrentItem
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO            -> Empty   <- Item

  �龰��������Undo���ǵ��µ�ǰHistoryItem�л�
       FHasRedo := True;
       : COMD COMD COMD COMD COMD  -> Full    <- Item
       : COMD COMD COMD COMD COMD  -> Full    <- Item
    -> : COMD COMD COMD COMD COMD  -> Full    <- CurrentItem
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO            -> Empty   <- Item

  �龰����һֱ��Redo���µ����
       FHasRedo := True;
       : COMD COMD COMD COMD COMD  -> Full    <- Item
       : COMD COMD COMD COMD COMD  -> Full    <- Item
       : COMD COMD COMD COMD COMD  -> Full    <- Item
       : COMD COMD COMD COMD COMD  -> Full    <- Item
    -> : COMD COMD COMD            -> UnFull  <- CurrentItem
  }

  // 3. ��ǰ��ʷ��¼��ʾ��Ϊ�գ��жϵ�ǰFHistoryItem�Ƿ������ҪRedo�����
  //    �������Redo�������True��
  //    ���������Redo����ж��Ƿ���������FHistoryItem�����������FHistoryItem
  //    ȫ��������ҪRedo�����
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
    LHistoryItem := THistoryItem.Create(ABitmap, FGraphicManger);
    LHistoryItem.AddCommand(ACommand);
    FHistoryList.Add(LHistoryItem);
    FCurrentIndex := FCurrentIndex + 1;
  end
  else // if the history isn't empty, add the command into current HistoryItem
  begin
    LHistoryItem := FHistoryList[FCurrentIndex];
    if LHistoryItem.Full then
    begin
      LHistoryItem := THistoryItem.Create(ABitmap, FGraphicManger);
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
begin
  {
    1. �����жϵ�ǰ�Ƿ���ڿ���Redo���������ͨ�����ڵĺ���HasRedoCommands��ʵ�֡�
  }
  if not HasRedoCommands then
  begin
    Exit; // ���û��, ֱ���˳�...
  end;

  {
    2. ��Ȼ��ǰ���ڿ���Redo��������Ƿ�Ϊ���漸���龰��
    ʾ��ͼ��
    �龰�㣺һֱUndo����������ʷ��¼��ʾΪ��
    -> := -1 -> History is empty              <- CurrentItem
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO REDO REDO  -> Empty   <- Item
       : REDO REDO REDO            -> Empty   <- Item

    �龰һ������Undo֮�󣬽���Redo����
         FHasRedo := True;
         : COMD COMD COMD COMD COMD  -> Full    <- Item
         : COMD COMD COMD COMD COMD  -> Full    <- Item
      -> : COMD COMD COMD REDO REDO  -> UnFull  <- CurrentItem
         : REDO REDO REDO REDO REDO  -> Empty   <- Item
         : REDO REDO REDO            -> Empty   <- Item

    �龰��������Undo���ǵ��µ�ǰHistoryItem�л�
         FHasRedo := True;
         : COMD COMD COMD COMD COMD  -> Full    <- Item
         : COMD COMD COMD COMD COMD  -> Full    <- Item
      -> : COMD COMD COMD COMD COMD  -> Full    <- CurrentItem
         : REDO REDO REDO REDO REDO  -> Empty   <- Item
         : REDO REDO REDO            -> Empty   <- Item

    �龰����һֱ��Redo���µ����
         FHasRedo := True;
         : COMD COMD COMD COMD COMD  -> Full    <- Item
         : COMD COMD COMD COMD COMD  -> Full    <- Item
         : COMD COMD COMD COMD COMD  -> Full    <- Item
         : COMD COMD COMD COMD COMD  -> Full    <- Item
      -> : COMD COMD COMD            -> UnFull  <- CurrentItem
  }

  {
    2. �жϵ�ǰ��ʷ��¼�Ƿ���ʾΪ�գ���Ϊ��һ�����������һֱUndo���������µ�ǰ
       ��ʷ��¼������Ϊ�գ���ʱֻ���ֶ����ʵ�һ��THistoryItem��
       ��Ȼ�������ǰ��ʷ��¼��Ϊ�յĻ���ֱ�ӷ���FCurrentIndex��Ӧ��Item���ɡ�
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

  if LHistoryItem.HasRedoItem then // �龰һ
  begin
    LHistoryItem.RedoCommand;
    LBitmap := LHistoryItem.ExecuteCurrentCommands;
    ABitmap.Assign(LBitmap);
    LBitmap.Free;
  end
  else if not LHistoryItem.Full then // �龰��
  begin
    FHasRedo := False;
    Exit;
  end
  else // �龰��
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
  LBitmap: TBitmap;
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
  LBitmap := LItem.ExecuteCurrentCommands;
  ABitmap.Assign(LBitmap);
  LBitmap.Free;
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

constructor THistoryItem.Create(ABitmap: TBitmap; AManager: TGraphicManager);
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

  FManager := AManager;
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
  ע���ͷŵ�ǰTHistoryItem������Դ��ʱ�򣬲��ܽ�����FSnapShot�ͷŵ�����ǰ��δ���ͷŵ�
  �����Ҫʹ��FShapShot!
}
procedure THistoryItem.ReleaseRedoResource;
var
  LCommand: TCommand;
  LIndex: Integer;
begin
  // ���˵��ǰFRedoIndex���±�С��0��˵����ǰ�����鵱�в�δ����Redo����
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

