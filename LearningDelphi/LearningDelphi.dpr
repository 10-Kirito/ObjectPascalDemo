program LearningDelphi;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Chapter1 in 'Chapter1\Chapter1.pas',
  Test1 in 'Chapter1\Test1.pas',
  Practice1 in 'Practices\Practice1.pas',
  Chapter2 in 'Chapter2\Chapter2.pas',
  ClassTest in 'Chapter6\ClassTest.pas',
  Chapter4 in 'Chapter4\Chapter4.pas';

begin
//  练习一：
//  Practice1.MultiplicationFormulas();
//  Practice1.FindPrimeNumber();
//  Practice1.Verify();

  Chapter4.Test();
  Readln;
end.
