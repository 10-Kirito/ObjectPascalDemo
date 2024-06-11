unit ObjectFields;

interface

type
  TTestFields = class(TObject)
    const TestConst: Integer = 100;
    // 编译器会提示错误，因为这里编译器会认为Temp为静态变量，需要进行初始化
    // Temp: Integer;
    var
      Name: string;
  end;

  TTest2 = class(TObject)
    Temp: Integer;
    const TestConst: Integer = 100;
    var Name: string;
  end;

procedure TestObjectFields();

implementation

procedure TestObjectFields();
var
  field1: TTestFields;
begin
end;

end.
