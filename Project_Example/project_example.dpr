program project_example;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  vcl_forms in '.\VCL-Forms-Application\vcl_forms.pas',
  Unit1 in '.\Unit\Unit1.pas',
  Form in '.\Form\Form.pas';

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
