object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 638
  ClientWidth = 1121
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object MouseX: TLabel
    Left = 528
    Top = 36
    Width = 8
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object MouseY: TLabel
    Left = 656
    Top = 36
    Width = 8
    Height = 29
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Image: TImage
    Left = 24
    Top = 88
    Width = 1073
    Height = 529
    OnMouseDown = ImageMouseDown
    OnMouseUp = ImageMouseUp
  end
  object Line: TButton
    Left = 32
    Top = 24
    Width = 97
    Height = 41
    Caption = 'Line'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = LineClick
  end
  object Rectangle: TButton
    Left = 168
    Top = 24
    Width = 97
    Height = 41
    Caption = 'Rectangle'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = RectangleClick
  end
  object PolyLine: TButton
    Left = 296
    Top = 24
    Width = 97
    Height = 41
    Caption = 'PolyLine'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
    OnClick = PolyLineClick
  end
  object Curve: TButton
    Left = 425
    Top = 24
    Width = 97
    Height = 41
    Caption = 'Curve'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -24
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
    OnClick = CurveClick
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 800
    Top = 24
  end
end
