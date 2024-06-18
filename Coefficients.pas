unit Coefficients;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  CoolCtrls, StdCtrls, RXSpin, ExtCtrls;

type
  TCForm = class(TForm)
    CoolFormHook1: TCoolFormHook;
    A01: TRxSpinEdit;
    A02: TRxSpinEdit;
    A03: TRxSpinEdit;
    A04: TRxSpinEdit;
    A05: TRxSpinEdit;
    A06: TRxSpinEdit;
    B01: TRxSpinEdit;
    B02: TRxSpinEdit;
    B03: TRxSpinEdit;
    B04: TRxSpinEdit;
    B05: TRxSpinEdit;
    B06: TRxSpinEdit;
    C01: TRxSpinEdit;
    C02: TRxSpinEdit;
    C03: TRxSpinEdit;
    C04: TRxSpinEdit;
    C05: TRxSpinEdit;
    C06: TRxSpinEdit;
    CoefficiantTimer: TTimer;
    CoolMemo1: TCoolMemo;
    procedure CoefficiantTimerTimer(Sender: TObject);
    procedure A01Change(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CForm: TCForm;
  ticks: Integer;

implementation

{$R *.DFM}

uses Main, ChildWin;

procedure TCForm.CoefficiantTimerTimer(Sender: TObject);
begin
  if ticks = 0 then
  begin
    ticks := ticks + 1;
  end
  else
  begin
    CoefficiantTimer.Enabled := False;
    MainForm.UpdateCoefficiants;
    ticks := 0;
  end;
end;

procedure TCForm.A01Change(Sender: TObject);
begin
  ticks := 0;
  CoefficiantTimer.Enabled := True;
end;

end.
