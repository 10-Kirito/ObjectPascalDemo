unit vcl_forms;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    settings: TButton;
    main: TButton;
    exit: TButton;
    screen: TLabel;
    procedure mainClick(Sender: TObject);
    procedure settingsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.mainClick(Sender: TObject);
begin
  screen.Caption:= '÷˜“≥';
end;

procedure TForm1.settingsClick(Sender: TObject);
begin
  screen.Caption:= '…Ë÷√'
end;

end.
