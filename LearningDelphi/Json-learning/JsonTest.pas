unit JsonTest;

interface

uses
  superobject, Graphics;

procedure MainTest;
procedure FileTest;

implementation

const JsonStr = '{"No1":"张三", "No2":"李四"}';

procedure MainTest;
var
  LColor: TColor;
begin
  FileTest;
  LColor := clRed;
  Writeln(LColor);
end;

procedure FileTest;
var
  LArr: ISuperObject;
  LFile: ISuperObject;
  LBeginPoint: ISuperObject;
  LEndPoint: ISuperObject;
  LItem: ISuperObject;
begin
  LFile := SO;
  LArr := SA([]);

  LItem := SO;
  LItem.I['x'] := 100;
  LItem.I['y'] := 200;
  LArr.AsArray.Add(LItem);
  LArr.AsArray.Add(LItem);
  LArr.AsArray.Add(LItem);
  LArr.AsArray.Add(LItem);

  LBeginPoint := SO;
  LEndPoint := SO;
  LBeginPoint.I['x'] := 100;
  LBeginPoint.I['y'] := 200;

  LEndPoint.I['x'] := 100;
  LEndPoint.I['y'] := 200;

  LFile.O['points'] := LArr;
  LFile.S['type'] := 'line';
  LFile.S['GUID'] := 'B69727A5-7A83-4ABE-92E3-98C99C54711C';
  LFile.O['startpoint'] := LBeginPoint;
  LFile.O['endpoint'] := LBeginPoint;
  LFile.I['width'] := 100;
  LFile.S['color'] := '#FF0000';

  Writeln(LFile.AsJSon(True, True));
end;

procedure ExportComplexJSON;
var
  LFile: ISuperObject;
  PersonArray: TSuperArray;
  Person: ISuperObject;
begin
//  LFile := SO;
//
//  // 创建一个数组
//  PersonArray := TSuperArray.Create;
//
//  //
//  Person := SO;
//  Person.S['name'] := 'Kirito';
//  Person.I['age'] := 30;
//  Person.O['address'] := TSuperObject.Create;
//
//  Person.O['address'].S['city'] := 'New York';
//  Person.O['address'].S['street'] := '123 Elm Street';
//
//  Person.O['phones'] := SA(['123-456-789', '123-123-123']);
//
//  PersonArray.Add(Person);
//
//  LFile.A['persons'] := PersonArray;
//
//  LFile.SaveTo('./test.json');
end;

end.
