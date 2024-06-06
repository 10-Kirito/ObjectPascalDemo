unit Practice1;

interface

uses
  DateUtils, SysUtils, Windows;
//  1. 打印乘法口诀表
procedure MultiplicationFormulas();
//  2. 找质数
procedure FindPrimeNumber;
function IsPrimeNumber(ANumber: Integer): Boolean;
//  3.验证哥德巴赫猜想
procedure Verify();
procedure VerifyGlodbach(Number: Integer);

implementation

procedure MultiplicationFormulas();
var
  row: Integer;
  col: Integer;
begin
  for row := 1 to 9 do
    begin
      for col := 1 to row do
        write(col, 'X', row, '=', col * row, ' ');
      writeln;
    end;
end;

procedure FindPrimeNumber();
var
  Number: Integer;
begin
  while TRUE do
  begin
    readln(Number);
    if IsPrimeNumber(Number) then
      writeln(Number, ' is prime number.')
    else
    begin
      Number := Number + 1;
      while not IsPrimeNumber(Number) do
        Number := Number + 1;
      writeln('the next prime number is ', Number);
    end;
  end;
end;

function IsPrimeNumber(ANumber: Integer): boolean;
var
  i: Integer;
begin
  if ANumber <= 3 then
    exit(ANumber > 1);

  for i := 2 to ANumber - 1 do
    if ANumber mod i = 0 then
    begin
        // Result := FALSE;
      exit(FALSE);
    end;
  Result := TRUE;
end;

procedure VerifyGlodbach(Number: Integer);
var
  Left: Integer;
  Right: Integer;
begin
  for Left := 2 to Number - 2 do
  begin
    // 如果第一个数字是质数，接下来查看另外的一个数字
    if IsPrimeNumber(Left) then
    begin
      Right := Number - Left;
      if IsPrimeNumber(Right) then
        Writeln('the two number are ', Left, ' ', Right);
    end
  end;
end;

procedure Verify();
var
  BeginTime, EndTime, UsedTime: Cardinal;
  Number: Integer;
  tmp: Double;
begin
  BeginTime := GetTickCount();
  // You can use MaxInt to express the biggest number
  for  Number:= 2 to 1000 do
  begin
    VerifyGlodbach(Number);
  end;
  EndTime := GetTickCount();
  UsedTime := EndTime - BeginTime;
  Writeln('execution time: ', UsedTime, 'ms');
end;
end.
