program demoUnit;

uses
  Forms,
  demo in 'demo.pas' {main};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tmain, main);
  Application.Run;
end.
