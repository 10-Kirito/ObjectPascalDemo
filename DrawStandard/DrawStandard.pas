unit DrawStandard;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, RzButton, ImgList, ExtCtrls, RzPanel, RzCommon,
  RzBorder, RzPopups, RzDBList, Grids, RzGrids, RzCmboBx, Mask, RzEdit, Buttons,
  Menus, GraphicReceiver, Tools, Command, ManageCenter;

type
  TForm1 = class(TForm)
    ilImageList: TImageList;
    imgDrawImage: TImage;
    rztlbrToolsBar: TRzToolbar;
    btnOpen: TRzToolButton;
    btnSave: TRzToolButton;
    rzpnlTools: TRzPanel;
    btnPen: TRzToolButton;
    btnLine: TRzToolButton;
    btnRec: TRzToolButton;
    btnCircle: TRzToolButton;
    btnCurve: TRzToolButton;
    edtColor: TRzColorEdit;
    btnSelect: TRzToolButton;
    btnUndo: TRzToolButton;
    btnRedo: TRzToolButton;
    procedure FormCreate(Sender: TObject);
    procedure imgDrawImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure imgDrawImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnLineClick(Sender: TObject);
    procedure btnRecClick(Sender: TObject);
    procedure btnCircleClick(Sender: TObject);
    procedure btnCurveClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnPenClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure imgDrawImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure edtColorChange(Sender: TObject);
    procedure btnUndoClick(Sender: TObject);
    procedure btnRedoClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);

  private
    FManger: TManager;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnCircleClick(Sender: TObject);
begin
  FManger.PMode := drawCIRCLE;
end;

procedure TForm1.btnCurveClick(Sender: TObject);
begin
  ShowMessage('TODO!!!');
end;

procedure TForm1.btnLineClick(Sender: TObject);
begin
  FManger.PMode := drawLINE;
end;

procedure TForm1.btnOpenClick(Sender: TObject);
begin
  ShowMessage('TODO!!!');
end;

procedure TForm1.btnPenClick(Sender: TObject);
begin
  FManger.PMode := drawBRUSH;
end;

procedure TForm1.btnRecClick(Sender: TObject);
begin
  FManger.PMode := drawRECTANGLE;
end;

procedure TForm1.btnRedoClick(Sender: TObject);
begin
  FManger.HandleRedo;
end;

procedure TForm1.btnSelectClick(Sender: TObject);
begin
  FManger.PMode := drawSELECT;
end;

procedure TForm1.btnUndoClick(Sender: TObject);
begin
  FManger.HandleUndo;
end;

procedure TForm1.edtColorChange(Sender: TObject);
begin
  FManger.HandleColorChange(edtColor.SelectedColor);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := cafree;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  imgDrawImage.Canvas.LineTo(0,0);
  FManger := TManager.Create(imgDrawImage.Picture.Bitmap);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FManger);

end;

procedure TForm1.imgDrawImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FManger.HandleMouseDown(Sender, Button, Shift, X, Y);
end;

procedure TForm1.imgDrawImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  FManger.HandleMouseMove(Sender, Shift, X, Y);
end;

procedure TForm1.imgDrawImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FManger.HandleMouseUp(Sender, Button, Shift, X, Y);
end;

end.

