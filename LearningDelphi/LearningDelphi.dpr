﻿program LearningDelphi;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  Chapter1 in 'Chapter1\Chapter1.pas',
  Test1 in 'Chapter1\Test1.pas',
  Practice1 in 'Practices\Practice1.pas',
  Chapter2 in 'Chapter2\Chapter2.pas',
  ClassTest in 'Chapter6\ClassTest.pas',
  Chapter4 in 'Chapter4\Chapter4.pas',
  InheritedTest in 'Chapter6\InheritedTest.pas',
  ObjectFields in 'Chapter6\ObjectFields.pas',
  ObjectFunc in 'Chapter6\ObjectFunc.pas',
  ReferenceTest in 'Chapter6\ReferenceTest.pas',
  InterfaceTest in 'Chapter7\InterfaceTest.pas',
  GenerateGUID in 'Practices\GenerateGUID.pas',
  TestAssign in 'Chapter6\TestAssign.pas',
  StaticTest in 'Chapter6\StaticTest.pas',
  TestInterface in 'Chapter6\TestInterface.pas',
  ConstructorTest in 'Chapter6\ConstructorTest.pas',
  JsonTest in 'Json-learning\JsonTest.pas',
  superdate in 'Json-learning\src\superdate.pas',
  superobject in 'Json-learning\src\superobject.pas',
  supertimezone in 'Json-learning\src\supertimezone.pas',
  supertypes in 'Json-learning\src\supertypes.pas',
  superxmlparser in 'Json-learning\src\superxmlparser.pas',
  TestBaseClass in 'Chapter7\TestBaseClass.pas';

begin
//  练习一：
//  Practice1.MultiplicationFormulas();
//  Practice1.FindPrimeNumber();
//  Practice1.Verify();
  TestBaseClass.MainTest;
  System.ReportMemoryLeaksOnShutdown := True;
  Readln;
end.
