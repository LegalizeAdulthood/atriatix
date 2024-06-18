unit Params;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXCtrls, StdCtrls, RXSpin, Menus, CoolCtrls, ExtCtrls, TB97;

type
  TForm4 = class(TForm)
    RedBar1: TCoolTrackBar;
    CoolFormHook1: TCoolFormHook;
    ColorTimer: TTimer;
    GrnBar1: TCoolTrackBar;
    BluBar1: TCoolTrackBar;
    RedLabel1: TCoolLabel;
    GrnLabel1: TCoolLabel;
    BluLabel1: TCoolLabel;
    Intensity: TCoolTrackBar;
    Factor1: TCoolLabel;
    square_root: TCoolCheckRadioBox;
    Invert: TCoolCheckRadioBox;
    Randomizer: TCoolTrackBar;
    RandomFactor: TCoolLabel;
    CoolLabel1: TCoolLabel;
    CoolLabel2: TCoolLabel;
    CoolLabel3: TCoolLabel;
    CoolLabel4: TCoolLabel;
    CoolLabel5: TCoolLabel;
    constAA: TRxSpinEdit;
    CoolLabel6: TCoolLabel;
    constBB: TRxSpinEdit;
    CoolLabel7: TCoolLabel;
    Dock971: TDock97;
    Toolbar971: TToolbar97;
    ResetButton: TToolbarButton97;
    DrawRandomButton: TToolbarButton97;
    ApplyButton: TToolbarButton97;
    ToolbarButton971: TToolbarButton97;
    ToolbarButton972: TToolbarButton97;
    parameterX: TRxSpinEdit;
    parameterY: TRxSpinEdit;
    CoolLabel8: TCoolLabel;
    CoolLabel9: TCoolLabel;
    procedure ColorTimerTimer(Sender: TObject);
    procedure RedBar1Change(Sender: TObject);
    procedure GrnBar1Change(Sender: TObject);
    procedure BluBar1Change(Sender: TObject);
    procedure IntensityChange(Sender: TObject);
    procedure square_rootClick(Sender: TObject);
    procedure ProbabilityChange(Sender: TObject);
    procedure InvertClick(Sender: TObject);
    procedure constAAChange(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure DrawRandomButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure ToolbarButton972Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form4: TForm4;
  ticks: Integer;

implementation

uses Main, ChildWin;

{$R *.DFM}

procedure TForm4.ColorTimerTimer(Sender: TObject);
begin
  if ticks = 0 then
  begin
    ticks := ticks + 1;
  end
  else
  begin
    ColorTimer.Enabled := False;
    MainForm.UpdateColors;
    ticks := 0;
  end;
end;

procedure TForm4.RedBar1Change(Sender: TObject);
begin
  ticks := 0;
  ColorTimer.Enabled := True;
end;

procedure TForm4.GrnBar1Change(Sender: TObject);
begin
  ticks := 0;
  ColorTimer.Enabled := True;
end;

procedure TForm4.BluBar1Change(Sender: TObject);
begin
  ticks := 0;
  ColorTimer.Enabled := True;
end;

procedure TForm4.IntensityChange(Sender: TObject);
begin
  ticks := 0;
  ColorTimer.Enabled := True;
end;

procedure TForm4.ProbabilityChange(Sender: TObject);
begin
  ticks := 0;
  ColorTimer.Enabled := True;
end;

procedure TForm4.square_rootClick(Sender: TObject);
begin
  ticks := 0;
  ColorTimer.Enabled := True;
end;

procedure TForm4.InvertClick(Sender: TObject);
begin
  ticks := 0;
  ColorTimer.Enabled := True;
end;

procedure TForm4.constAAChange(Sender: TObject);
begin
  ticks := 0;
  ColorTimer.Enabled := True;
end;

procedure TForm4.ResetButtonClick(Sender: TObject);
begin
  MainForm.ResetButtonClick(Self);
end;

procedure TForm4.ApplyButtonClick(Sender: TObject);
begin
  MainForm.ApplyButtonClick(Self);
end;

procedure TForm4.DrawRandomButtonClick(Sender: TObject);
begin
  MainForm.DrawRandomClick(Self);
end;

procedure TForm4.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TForm4.ToolbarButton972Click(Sender: TObject);
begin
  MainForm.StopButtonClick(Self);
end;






end.


