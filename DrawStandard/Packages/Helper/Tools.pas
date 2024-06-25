unit Tools;

interface

uses
  Classes, Graphics, Windows, SysUtils;

type
  /// <summary>
  ///   ȫ�ֻ���ģʽ��
  ///   - �����жϵ�ǰ�Ļ���״̬
  /// </summary>
  TDrawMode = (drawBRUSH, drawLINE, drawRECTANGLE, drawCIRCLE, drawERASE,
    drawSELECT, drawELLIPSE);

  /// <summary>
  ///   �Զ��廭�ʣ�
  ///   - ����ֻ��������FColor�Լ�FWidth
  /// </summary>
  TDrawPen = class
  private
    FColor: TColor;
    FWidth: Integer;
  public
    constructor Create;overload;
    constructor Create(AColor: TColor; AWidth: Integer);overload;
    function GetWidth: Integer;
    procedure SetWidth(AWidth: Integer);
    property Color: TColor read FColor write FColor;
    property Width: Integer read GetWidth write SetWidth;
  end;

  /// <summary>
  ///   ȫ�ָ��������ࣺ
  ///   - ���൱�о������ɸ��๤�ߺ���������������ĺ���
  /// </summary>
  TTools = class
  public
    /// <summary> ��ȡ��ǰ��ʱ��</summary>
    /// <returns> ����ֵΪ'yyyy-mm-dd-hh-nn-ss'��ʽ���ַ���</returns>
    class function DrawTime: string;

    /// <summary> ����㵽�߶εľ���</summary>
    /// <param name="A">�߶εĶ˵�A</param>
    /// <param name="B">�߶εĶ˵�B</param>
    /// <param name="APoint">��Ҫ����Ķ���APoint</param>
    /// <returns>������Ӧ�ľ���</returns>
    class function PointToLineDistance(A: TPoint; B: TPoint; APoint: TPoint):Double;

    /// <summary>��������֮��ľ���</summary>
    /// <param name="APoint">����һ������</param>
    /// <param name="BPoint">����һ������</param>
    /// <returns>������Ӧ�ľ���</returns>
    class function DistanceBetweenPoints(APoint:TPoint; BPoint: TPoint): Double;

    /// <summary>�ж�һ������X�Ƿ�λ������[A, B]֮�䣬X��B�Ĵ�С��ȷ��</summary>
    /// <param name="A"></param>
    /// <param name="B"></param>
    /// <param name="X"></param>
    /// <returns>���λ�ڵĻ�������True, ��֮����False</returns>
    class function IsPointInInterval(A: Integer; B: Integer; X: Integer): Boolean;

    /// <summary>�ж�һ�������Ƿ�λ������һ�����㸽��</summary>
    /// <param name="APoint">����A</param>
    /// <param name="Another">����һ������</param>
    /// <returns>�������֮��ľ���С��10������True, ���򷵻�False</returns>
    class function IsPointCloseAnother(APoint:TPoint; Another: TPoint): Boolean;
  end;

implementation

{ TDrawPen }

constructor TDrawPen.Create;
begin
  FColor := clBlack;
  FWidth := 3;
end;

constructor TDrawPen.Create(AColor: TColor; AWidth: Integer);
begin
  FColor := AColor;
  FWidth := AWidth;
end;

function TDrawPen.GetWidth: Integer;
begin
  Exit(FWidth);
end;

procedure TDrawPen.SetWidth(AWidth: Integer);
begin
  FWidth := AWidth;
end;

{ TTools }

class function TTools.DistanceBetweenPoints(APoint, BPoint: TPoint): Double;
begin
  Result := Sqrt(Sqr(APoint.Y - BPoint.Y) + Sqr(BPoint.X - BPoint.X));
end;

class function TTools.DrawTime: string;
var
  CurrentTime: TDateTime;
begin
  CurrentTime := Now; // ��ȡ��ǰ���ں�ʱ��
  Result := FormatDateTime('yyyy-mm-dd-hh-nn-ss', CurrentTime);
end;

class function TTools.IsPointCloseAnother(APoint, Another: TPoint): Boolean;
var
  LDistance: Double;
begin
  LDistance := DistanceBetweenPoints(APoint, Another);

  Result := (LDistance <= 10);
end;

class function TTools.IsPointInInterval(A, B, X: Integer): Boolean;
var
  Min: Integer;
  Max: Integer;
begin
  if A <= B then
  begin
    Min := A;
    Max := B;
  end
  else
  begin
    Min := B;
    Max := A;
  end;
  if (X >= Min) and (X <= Max) then
  begin
    Result := True;
  end
  else
  begin
    Result := False;
  end;
end;

class function TTools.PointToLineDistance(A, B, APoint: TPoint): Double;
var
  x1, y1, x2, y2, x0, y0: Double;
  numerator, denominator: Double;
begin
  x1 := A.X;
  y1 := A.Y;
  x2 := B.X;
  y2 := B.Y;
  x0 := APoint.X;
  y0 := APoint.Y;

  numerator := Abs((y2 - y1) * x0 - (x2 - x1) * y0 + x2 * y1 - y2 * x1);
  denominator := Sqrt(Sqr(y2 - y1) + Sqr(x2 - x1));

  if denominator = 0 then
  begin
    Result := -1;
  end
  else
  begin
    Result := numerator / denominator;
  end;
end;

end.
