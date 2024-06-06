unit demo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tmain = class(TForm)
    show: TButton;
    clear: TButton;
    quit: TButton;
    caption: TLabel;
    procedure showClick(Sender: TObject);
    procedure clearClick(Sender: TObject);
    procedure quitClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  main: Tmain;

implementation

{$R *.dfm}

procedure Tmain.clearClick(Sender: TObject);
begin
  caption.Caption := '';
end;

procedure Tmain.quitClick(Sender: TObject);
begin
  Close;
end;

procedure Tmain.showClick(Sender: TObject);
begin
  caption.Caption := '�س���˾��ӭ�㣡����';
end;

end.
