unit About;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, CoolCtrls, RXCtrls, Dialogs, TB97;

type
  TAboutBox = class(TForm)
    CoolMemo1: TCoolMemo;
    CoolFormHook1: TCoolFormHook;
    Dock971: TDock97;
    Toolbar971: TToolbar97;
    CloseButton: TToolbarButton97;
    CoolLabel1: TCoolLabel;
    procedure OKButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutBox: TAboutBox;

implementation

{$R *.DFM}

procedure TAboutBox.OKButtonClick(Sender: TObject);
begin
  //ShowMessage('close');
  Close;
end;

end.

