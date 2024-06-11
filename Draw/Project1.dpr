program Project1;

uses
  Forms,
  Draw in 'Draw.pas' {Form1},
  GraphicBasic in 'Model\GraphicBasic\GraphicBasic.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
