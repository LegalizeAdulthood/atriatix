unit XYSize1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  RXCtrls, StdCtrls, RXSpin, Menus, CoolCtrls, CoolMenu;

type
  TXYSize = class(TForm)
    MainMenu1: TMainMenu;
    Size1: TMenuItem;
    N120by801: TMenuItem;
    N160by1201: TMenuItem;
    N320by2402: TMenuItem;
    N640by4801: TMenuItem;
    N800by6001: TMenuItem;
    RxWidth: TRxSpinEdit;
    RxHeight: TRxSpinEdit;
    CoolFormHook1: TCoolFormHook;
    CoolLabel1: TCoolLabel;
    CoolLabel2: TCoolLabel;
    CoolBtn1: TCoolBtn;
    CoolMenu1: TCoolMenu;
    cm_Size1: TCoolMenuItem;
    N1024by7681: TMenuItem;
    N400by3001: TMenuItem;
    procedure N120by801Click(Sender: TObject);
    procedure N160by1201Click(Sender: TObject);
    procedure N320by2402Click(Sender: TObject);
    procedure N640by4801Click(Sender: TObject);
    procedure N800by6001Click(Sender: TObject);
    procedure N1280by9601Click(Sender: TObject);
    procedure N1960by14401Click(Sender: TObject);
    procedure N2400by18001Click(Sender: TObject);
    procedure N1600by12001Click(Sender: TObject);
    procedure N3200by24001Click(Sender: TObject);
    procedure N2560by1920Click(Sender: TObject);
    procedure CoolBtn1Click(Sender: TObject);
    procedure N400by3001Click(Sender: TObject);
    procedure N1024by7681Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  XYSize: TXYSize;

implementation

uses Main;

{$R *.DFM}


procedure TXYSize.N120by801Click(Sender: TObject);
begin
  rxWidth.Value := 120;
  rxHeight.Value := 90;
end;

procedure TXYSize.N160by1201Click(Sender: TObject);
begin
  rxWidth.Value := 160;
  rxHeight.Value := 120;
end;

procedure TXYSize.N320by2402Click(Sender: TObject);
begin
  rxWidth.Value := 320;
  rxHeight.Value := 240;
end;

procedure TXYSize.N400by3001Click(Sender: TObject);
begin
  rxWidth.Value := 400;
  rxHeight.Value := 300;
end;

procedure TXYSize.N640by4801Click(Sender: TObject);
begin
  rxWidth.Value := 640;
  rxHeight.Value := 480;
end;

procedure TXYSize.N800by6001Click(Sender: TObject);
begin
  rxWidth.Value := 800;
  rxHeight.Value := 600;
end;

procedure TXYSize.N1280by9601Click(Sender: TObject);
begin
  rxWidth.Value := 1280;
  rxHeight.Value := 960;
end;

procedure TXYSize.N1600by12001Click(Sender: TObject);
begin
  rxWidth.Value := 1600;
  rxHeight.Value := 1200;
end;

procedure TXYSize.N1960by14401Click(Sender: TObject);
begin
  rxWidth.Value := 1960;
  rxHeight.Value := 1440;
end;

procedure TXYSize.N2400by18001Click(Sender: TObject);
begin
  rxWidth.Value := 2400;
  rxHeight.Value := 1800;
end;

procedure TXYSize.N2560by1920Click(Sender: TObject);
begin
  rxWidth.Value := 2560;
  rxHeight.Value := 1920;
end;

procedure TXYSize.N3200by24001Click(Sender: TObject);
begin
  rxWidth.Value := 3200;
  rxHeight.Value := 2400;
end;

procedure TXYSize.N1024by7681Click(Sender: TObject);
begin
  rxWidth.Value := 1024;
  rxHeight.Value := 768;
end;

procedure TXYSize.CoolBtn1Click(Sender: TObject);
begin
  MainForm.TP01;
end;

end.
