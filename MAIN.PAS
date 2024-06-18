unit Main;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, TB97, CoolCtrls;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveAsItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    StatusBar: TStatusBar;
    Dock971: TDock97;
    Toolbar971: TToolbar97;
    StopButton: TToolbarButton97;
    ResetButton: TToolbarButton97;
    Dock972: TDock97;
    Dock973: TDock97;
    Dock974: TDock97;
    Timer1: TTimer;
    DrawRandom: TToolbarButton97;
    ParmatersButton: TToolbarButton97;
    MDICoolFormHook1: TMDICoolFormHook;
    ApplyButton: TToolbarButton97;
    Loadfromparameterfile1: TMenuItem;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure FileNewItemClick(Sender: TObject);
    procedure WindowCascadeItemClick(Sender: TObject);
    procedure UpdateMenuItems(Sender: TObject);
    procedure WindowTileItemClick(Sender: TObject);
    procedure WindowArrangeItemClick(Sender: TObject);
    procedure FileCloseItemClick(Sender: TObject);
    procedure FileOpenItemClick(Sender: TObject);
    procedure FileExitItemClick(Sender: TObject);
    procedure FileSaveAsItemClick(Sender: TObject);
    procedure CutItemClick(Sender: TObject);
    procedure CopyItemClick(Sender: TObject);
    procedure PasteItemClick(Sender: TObject);
    procedure WindowMinimizeItemClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HelpAboutItemClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure ResetButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DrawRandomClick(Sender: TObject);
    procedure TP01;
    procedure UpdateColors;
    procedure ParmatersButtonClick(Sender: TObject);
    procedure UpdateCoefficiants;
    procedure ConstantsButtonClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure UpdateParameters;
    procedure Loadfromparameterfile1Click(Sender: TObject);

  private
    { Private declarations }
    procedure CreateMDIChild(const Name: string);
    procedure ShowHint(Sender: TObject);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses ChildWin, About, Params;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Application.Title := 'NEW';
  Application.OnHint := ShowHint;
  Screen.OnActiveFormChange := UpdateMenuItems;
end;

procedure TMainForm.ShowHint(Sender: TObject);
begin
  StatusBar.SimpleText := Application.Hint;
end;

procedure TMainForm.CreateMDIChild(const Name: string);
var
  Child: TMDIChild;
begin
  { create a new MDI child window }
  Child := TMDIChild.Create(Application);
  Child.Caption := Name;
end;

procedure TMainForm.FileNewItemClick(Sender: TObject);
begin
  CreateMDIChild('NONAME' + IntToStr(MDIChildCount + 1));
end;

procedure TMainForm.FileOpenItemClick(Sender: TObject);
begin
  if OpenDialog.Execute then
    CreateMDIChild(OpenDialog.FileName);
end;

procedure TMainForm.FileCloseItemClick(Sender: TObject);
begin
  if ActiveMDIChild <> nil then
    ActiveMDIChild.Close;
end;

procedure TMainForm.FileSaveAsItemClick(Sender: TObject);
var
  Child: TMDIChild;
begin
  Child := TMDIChild(ActiveMDIChild);
  Child.SaveAs1Click(Self);
end;

procedure TMainForm.FileExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.CutItemClick(Sender: TObject);
begin
  {cut selection to clipboard}
end;

procedure TMainForm.CopyItemClick(Sender: TObject);
begin
  {copy selection to clipboard}
end;

procedure TMainForm.PasteItemClick(Sender: TObject);
begin
  {paste from clipboard}
end;

procedure TMainForm.WindowCascadeItemClick(Sender: TObject);
begin
  Cascade;
end;

procedure TMainForm.WindowTileItemClick(Sender: TObject);
begin
  Tile;
end;

procedure TMainForm.WindowArrangeItemClick(Sender: TObject);
begin
  ArrangeIcons;
end;

procedure TMainForm.WindowMinimizeItemClick(Sender: TObject);
var
  I: Integer;
begin
  { Must be done backwards through the MDIChildren array }
  for I := MDIChildCount - 1 downto 0 do
    MDIChildren[I].WindowState := wsMinimized;
end;

procedure TMainForm.UpdateMenuItems(Sender: TObject);
begin
  FileCloseItem.Enabled := MDIChildCount > 0;
  FileSaveAsItem.Enabled := MDIChildCount > 0;
  WindowCascadeItem.Enabled := MDIChildCount > 0;
  WindowTileItem.Enabled := MDIChildCount > 0;
  WindowArrangeItem.Enabled := MDIChildCount > 0;
  WindowMinimizeItem.Enabled := MDIChildCount > 0;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  Screen.OnActiveFormChange := nil;
end;

procedure TMainForm.HelpAboutItemClick(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
var
  Child: TMDIChild;
begin
  Timer1.Enabled := False;
  if (Application.Title = 'NEW') then
  begin
    FileNewItemClick(Self);
  end
  else
  begin
    Child := TMDIChild(ActiveMDIChild);
    Child.UpdateGrafX;
  end;
end;

procedure TMainForm.StopButtonClick(Sender: TObject);
var
  Child: TMDIChild;
begin
  Child := TMDIChild(ActiveMDIChild);
  Child.v.Abort_Draw := True;
end;

procedure TMainForm.ResetButtonClick(Sender: TObject);
var
  Child: TMDIChild;
begin
  Child := TMDIChild(ActiveMDIChild);
  Child.ResetCoordinates;
	Timer1.Enabled := True;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopButtonClick(Self);
end;

procedure TMainForm.DrawRandomClick(Sender: TObject);
var
  Child: TMDIChild;
begin
  Timer1.Enabled := True;
  Child := TMDIChild(ActiveMDIChild);
  Child.v.bInitialize := true;
end;

procedure TMainForm.TP01;
var
  Child: TMDIChild;
begin
  Child := TMDIChild(ActiveMDIChild);
  Child.Resolution;
end;

procedure TMainForm.UpdateColors;
var
  Child: TMDIChild;
begin
  Child := TMDIChild(ActiveMDIChild);
  Child.ApplyParameters;
end;

procedure TMainForm.ParmatersButtonClick(Sender: TObject);
var
  Child: TMDIChild;
begin
  Child := TMDIChild(ActiveMDIChild);
  Child.Parameters1Click(Self);
end;

procedure TMainForm.UpdateCoefficiants;
var
  Child: TMDIChild;
begin
  Child := TMDIChild(ActiveMDIChild);
  Child.UpdateCoefficiants;
end;

procedure TMainForm.ConstantsButtonClick(Sender: TObject);
var
  Child: TMDIChild;
begin
  Child := TMDIChild(ActiveMDIChild);
  Child.ConstantsDialog1Click(Self);
end;

procedure TMainForm.ApplyButtonClick(Sender: TObject);
var
  Child: TMDIChild;
begin
  Timer1.Enabled := True;
  Child := TMDIChild(ActiveMDIChild);
  Child.v.bInitialize := False;
end;

procedure TMainForm.UpdateParameters;
var
  Child: TMDIChild;
begin
  Child := TMDIChild(ActiveMDIChild);
  Child.Parameters1Update;;
end;

procedure TMainForm.Loadfromparameterfile1Click(Sender: TObject);
var
  Child: TMDIChild;
begin
  if OpenDialog1.Execute then
  begin
    Child := TMDIChild(ActiveMDIChild);

    Child.LoadFromParameterFile(OpenDialog1.FileName);

    Child.v.bInitialize := False;
    Child.UpdateGrafX;
  end;
end;

end.


