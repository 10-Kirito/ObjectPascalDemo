unit CommandManager;

interface

uses
  Generics.Collections, Graphics, Commands;

type
  TCommandManager = class
  private
    FCommandStack: TStack<TCommand>;
    FRedoStack: TStack<TCommand>;
  public
    constructor Create;
    destructor Destroy;
    procedure ExecuteCommand(ACommand: TCommand; ABitmap: TBitmap);
    procedure Undo(ABitmap: TBitmap);
    procedure Redo(ABitmap: TBitmap);
  end;

implementation

{ TCommandManager }

constructor TCommandManager.Create;
begin
  FCommandStack := TStack<TCommand>.Create;
  FRedoStack := TStack<TCommand>.Create;
end;

destructor TCommandManager.Destroy;
var
  LCommand: TCommand;
begin

  for LCommand in FCommandStack do
  begin
    LCommand.Free;
  end;

  for LCommand in FRedoStack do
  begin
    LCommand.Free;
  end;

  FCommandStack.Free;
  FRedoStack.Free;
end;

procedure TCommandManager.ExecuteCommand(ACommand: TCommand; ABitmap: TBitmap);
begin
  ACommand.Execute(ABitmap);
  FCommandStack.Push(ACommand);
end;

procedure TCommandManager.Undo(ABitmap: TBitmap);
var
  LCommand: TCommand;
begin
  // if commands stack is not empty
  if FCommandStack.Count > 0 then
  begin
    LCommand := FCommandStack.Pop;
    LCommand.Undo(ABitmap);
    FRedoStack.Push(LCommand);
  end;
end;

procedure TCommandManager.Redo(ABitmap: TBitmap);
var
  LCommand: TCommand;
begin
  if FRedoStack.Count > 0 then
  begin
    LCommand := FRedoStack.Pop;
    LCommand.Redo(ABitmap);
    FCommandStack.Push(LCommand);
  end;
end;
end.
