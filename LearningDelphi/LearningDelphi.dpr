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
  InterfaceTest in 'Chapter7\InterfaceTest.pas';

begin
//  练习一：
//  Practice1.MultiplicationFormulas();
//  Practice1.FindPrimeNumber();
//  Practice1.Verify();
  InterfaceTest.MainTest;
  Readln;
end.
