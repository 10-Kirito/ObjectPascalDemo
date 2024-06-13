program Draw;

uses
  Forms,
  DrawStandard in 'DrawStandard.pas' {Form1};

{$R *.res}

begin
   System.ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
