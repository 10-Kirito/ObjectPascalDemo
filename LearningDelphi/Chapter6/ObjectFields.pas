unit ObjectFields;

interface

type
  TTestFields = class(TObject)
    const TestConst: Integer = 100;
    // ����������ʾ������Ϊ�������������ΪTempΪ��̬��������Ҫ���г�ʼ��
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
