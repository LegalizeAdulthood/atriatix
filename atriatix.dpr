program atriatix;

uses
  Forms,
  Main in 'MAIN.PAS' {MainForm},
  About in 'about.pas' {AboutBox},
  formula in 'formula.pas',
  XYSize1 in 'XYSize1.pas' {XYSize},
  Childwin in 'Childwin.pas' {MDIChild},
  Params in 'Params.pas' {Form4},
  Coefficients in 'Coefficients.pas' {CForm},
  LMString in 'Lmstring.pas',
  complex in 'complex.pas';

{$R *.RES}

begin
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TXYSize, XYSize);
  Application.CreateForm(TForm4, Form4);
  Application.CreateForm(TCForm, CForm);
  Application.Run;
end.
