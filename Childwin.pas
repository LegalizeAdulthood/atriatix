//
// Stephen C. Ferguson
//

unit Childwin;

interface

uses Windows, Classes, Graphics, Forms, Controls, TB97, Menus, PGraphic,
  ComCtrls, ExtCtrls, Dialogs, SysUtils, CoolMenu, CoolCtrls;

type
  affineArray = array [1..60] of Double;

type
  TInfo = Record
    cx, cy: Double;
    zx, zy: Double;
    CRMIN, CRMAX, CRMID, CIMIN, CIMAX, CIMID: Double;
    CRMIN_NEW, CRMAX_NEW, CRMID_NEW, CIMIN_NEW, CIMAX_NEW, CIMID_NEW: Double;
    CRMID_OLD, CIMID_OLD: Double;

    dMag_new, dMagnification: double;
    Radius_x, Radius_y: Double;
    rx_ratio, ry_ratio: Double;
    xtot, ytot: Double;
    xsav, ysav: Double;
    dFactor1, dFactor2, dFactor3: Double;
    RandomFactor: double;
    r, g, b:  Double;
    dRedStep, dBluStep, dGrnStep: Double;
    xMin, yMin, xMax, yMax: Double;

    Width, Height: Integer;
    Maxit: Integer;
    formula: Integer;
    nBlendingMethod: Integer;
    nColoringOrder: Integer;
    nCoefficients: Integer;
    T1, nPoints: Integer;
    iWidth, iHeight: Integer;
    AA, BB, C, Lyapunov: double;
    AA_Initial: double;

    bNone, bLinear, bSinusoidal, bSpherical, bSwirl, bHorseshoe, bPolar, bBent, bInversion: Bool;
    bInvert: Bool;

    bInitialize: Bool;
    Abort_Draw, bSqrt: Bool;

    af, bf: affineArray;
    aPG: TPixelGraphic;

    my_TList: TList;
    color: integer;

    bColorMix, bExpansion, bModulas: BOOL;

  end;

type
  TMDIChild = class(TForm)
    Timer1: TTimer;
    Timer2: TTimer;
    MainMenu1: TMainMenu;
    test1: TMenuItem;
    N120by901: TMenuItem;
    N160by1201: TMenuItem;
    N320by2401: TMenuItem;
    N400by3001: TMenuItem;
    N640by4801: TMenuItem;
    N800by6001: TMenuItem;
    N1024by7681: TMenuItem;
    CustomSize1: TMenuItem;
    PGSaveDialog1: TPGSaveDialog;
    Zoom1: TMenuItem;
    StatusBar1: TStatusBar;
    PGImage1: TPGImage;
    SqrtFilter1: TMenuItem;
    MDICoolFormHook1: TMDICoolFormHook;
    Dialogs1: TMenuItem;
    Parameters1: TMenuItem;
    IFSConstants1: TMenuItem;
    Formula1: TMenuItem;
    Draw01: TMenuItem;
    Draw02: TMenuItem;
    Draw03: TMenuItem;
    Draw04: TMenuItem;
    Draw05: TMenuItem;
    Draw06: TMenuItem;
    Draw07: TMenuItem;
    Draw08: TMenuItem;
    Draw09: TMenuItem;
    Draw10: TMenuItem;
    PopupMenu1: TPopupMenu;
    ZoomIn1: TMenuItem;
    ClearRectangle1: TMenuItem;
    Draw11: TMenuItem;
    Draw12: TMenuItem;
    Draw13: TMenuItem;
    Draw14: TMenuItem;
    Draw15: TMenuItem;
    Draw16: TMenuItem;
    Draw17: TMenuItem;
    Draw18: TMenuItem;
    Draw19: TMenuItem;
    Draw20: TMenuItem;
    Draw21: TMenuItem;
    Draw22: TMenuItem;
    Effects: TMenuItem;
    Modulas: TMenuItem;
    Expansion: TMenuItem;
    ColorMix: TMenuItem;
    Formula2: TMenuItem;
    Draw23: TMenuItem;
    Draw24: TMenuItem;
    Draw25: TMenuItem;
    Draw26: TMenuItem;
    Draw27: TMenuItem;
    Draw28: TMenuItem;
    Draw29: TMenuItem;
    Draw30: TMenuItem;
    Draw31: TMenuItem;
    Draw32: TMenuItem;
    Draw34: TMenuItem;
    Draw35: TMenuItem;
    Draw36: TMenuItem;
    Draw37: TMenuItem;
    Draw38: TMenuItem;
    Draw39: TMenuItem;
    Draw40: TMenuItem;
    Draw33: TMenuItem;
    AntiAlias211: TMenuItem;
    AntiAlias311: TMenuItem;
    AntiAlias411: TMenuItem;
    N1: TMenuItem;
    Formula3: TMenuItem;
    Draw41: TMenuItem;
    Draw42: TMenuItem;
    Draw43: TMenuItem;
    Draw44: TMenuItem;
    Draw45: TMenuItem;
    Draw46: TMenuItem;
    Draw47: TMenuItem;
    Draw48: TMenuItem;
    Draw49: TMenuItem;
    Draw50: TMenuItem;
    Draw51: TMenuItem;
    Draw52: TMenuItem;
    Draw53: TMenuItem;
    Draw54: TMenuItem;
    Draw55: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Sinus1: TMenuItem;
    Draw60: TMenuItem;
    Draw61: TMenuItem;
    Draw62: TMenuItem;
    Draw63: TMenuItem;
    Draw64: TMenuItem;
    Draw65: TMenuItem;
    IFS1: TMenuItem;
    Draw70: TMenuItem;
    Draw71: TMenuItem;
    Draw72: TMenuItem;
    Draw73: TMenuItem;
    Draw74: TMenuItem;
    Draw75: TMenuItem;
    Draw66: TMenuItem;
    Draw67: TMenuItem;
    Draw68: TMenuItem;
    Draw69: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure UpdateMenuItems(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);

    procedure FormPaint;
    procedure UpdateGrafX;
    procedure ResetCoordinates;
    procedure AdjustCoords;
    procedure CreateTList;
    procedure TypeFractal;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PGImage1NewAutoSize(Sender: TObject; PGImageWidth,
      PGImageHeight: Integer);

		procedure Resolution;
    procedure N120by901Click(Sender: TObject);
    procedure N160by1201Click(Sender: TObject);
    procedure N320by2401Click(Sender: TObject);
    procedure N400by3001Click(Sender: TObject);
    procedure N640by4801Click(Sender: TObject);
    procedure N800by6001Click(Sender: TObject);
    procedure N1024by7681Click(Sender: TObject);
    procedure CustomSize1Click(Sender: TObject);
		procedure SaveAs1Click(Sender: TObject);
    procedure Zoom1Click(Sender: TObject);
    procedure PGImage1PicBoxOnMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure PGImage1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PGImage1PicBoxOnDblClick(Sender: TObject);
    procedure PGImage1PicBoxOnMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PGImage1PicBoxOnMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SqrtFilter1Click(Sender: TObject);
    Procedure ApplyParameters;
    procedure Parameters1Click(Sender: TObject);
    procedure Parameters1Update;
    procedure UpdateCoefficiants;
    procedure ConstantsDialog1Click(Sender: TObject);
    procedure Draw01Click(Sender: TObject);
    procedure Draw02Click(Sender: TObject);
    procedure ClearRectangle1Click(Sender: TObject);
    procedure LoadFromParameterFile(FileName: String);
    procedure ReadFromParameterFile(Sender: TObject);
    procedure Draw03Click(Sender: TObject);
    procedure Draw04Click(Sender: TObject);
    procedure Draw05Click(Sender: TObject);
    procedure Draw06Click(Sender: TObject);
    procedure Draw07Click(Sender: TObject);
    procedure Draw08Click(Sender: TObject);
    procedure Draw09Click(Sender: TObject);
    procedure Draw10Click(Sender: TObject);
    procedure Draw11Click(Sender: TObject);
    procedure Draw12Click(Sender: TObject);
    procedure Draw13Click(Sender: TObject);
    procedure Draw14Click(Sender: TObject);
    procedure Draw15Click(Sender: TObject);
    procedure Draw16Click(Sender: TObject);
    procedure Draw17Click(Sender: TObject);
    procedure Draw18Click(Sender: TObject);
    procedure Draw19Click(Sender: TObject);
    procedure Draw20Click(Sender: TObject);
    procedure Draw21Click(Sender: TObject);
    procedure Draw22Click(Sender: TObject);
    procedure ModulasClick(Sender: TObject);
    procedure ExpansionClick(Sender: TObject);
    procedure ColorMixClick(Sender: TObject);
    procedure Draw23Click(Sender: TObject);
    procedure Draw24Click(Sender: TObject);
    procedure Draw26Click(Sender: TObject);
    procedure Draw27Click(Sender: TObject);
    procedure Draw28Click(Sender: TObject);
    procedure Draw29Click(Sender: TObject);
    procedure Draw30Click(Sender: TObject);
    procedure Draw31Click(Sender: TObject);
    procedure Draw32Click(Sender: TObject);
    procedure Draw34Click(Sender: TObject);
    procedure Draw35Click(Sender: TObject);
    procedure Draw36Click(Sender: TObject);
    procedure Draw37Click(Sender: TObject);
    procedure Draw38Click(Sender: TObject);
    procedure Draw39Click(Sender: TObject);
    procedure Draw40Click(Sender: TObject);
    procedure Draw25Click(Sender: TObject);
    procedure Draw33Click(Sender: TObject);
    procedure AntiAlias211Click(Sender: TObject);
    procedure AntiAlias311Click(Sender: TObject);
    procedure AntiAlias411Click(Sender: TObject);
    procedure Alias211(Sender: TObject);
    procedure Alias311(Sender: TObject);
    procedure Alias411(Sender: TObject);
    procedure Draw41Click(Sender: TObject);
    procedure Draw42Click(Sender: TObject);
    procedure Draw43Click(Sender: TObject);
    procedure Draw44Click(Sender: TObject);
    procedure Draw45Click(Sender: TObject);
    procedure Draw46Click(Sender: TObject);
    procedure Draw47Click(Sender: TObject);
    procedure Draw48Click(Sender: TObject);
    procedure Draw49Click(Sender: TObject);
    procedure Draw50Click(Sender: TObject);
    procedure Draw51Click(Sender: TObject);
    procedure Draw52Click(Sender: TObject);
    procedure Draw53Click(Sender: TObject);
    procedure Draw54Click(Sender: TObject);
    procedure Draw55Click(Sender: TObject);
    procedure Draw60Click(Sender: TObject);
    procedure Draw61Click(Sender: TObject);
    procedure Draw62Click(Sender: TObject);
    procedure Draw63Click(Sender: TObject);
    procedure Draw64Click(Sender: TObject);
    procedure Draw65Click(Sender: TObject);
    procedure Draw70Click(Sender: TObject);
    procedure Draw71Click(Sender: TObject);
    procedure Draw72Click(Sender: TObject);
    procedure Draw73Click(Sender: TObject);
    procedure Draw74Click(Sender: TObject);
    procedure Draw75Click(Sender: TObject);
    procedure Draw66Click(Sender: TObject);
    procedure Draw67Click(Sender: TObject);
    procedure Draw68Click(Sender: TObject);
    procedure Draw69Click(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

    SavedPG: TPixelGraphic;
    ResultPG, SourcePG: TPixelGraphic;

    InFile: TextFile;
    OutFile: TextFile;
    InString: String;

    PData: Pointer;
    v: TInfo;

    i: Integer;

    temp, ldx, ldy: Double;
    CaptionSave: String;
    strParamName: String;

    bRectangleMode: Bool;
    bZoomingIn: Bool;
    formula_saved: Integer;
    bInitialUpdate: Bool;
    iType, iSubType, iOptions, iColors: string;
    iBitsPerPixel, iGraphicCount: Integer;
    bColorControls: Bool;
		PaletteAnimater: Bool;
    X_pixel, Y_pixel: double;
    Shift_Sav: TShiftState;
    cxp, cyp: Double;
    StrTemp:  array [0..99] of Char;
    bAmerican: Bool;
    bValid: Bool;

  end;

const

  constArrayWIDTH:  Integer = 400;
  constArrayHEIGHT: Integer = 300;

  constPI:  Double   = 3.14159265359;
  const2PI: Double  = 6.28318530718;
  constHPI: Double  = 1.57079632679;     // half PI
  constOverFlow     = 1e4;
  constZeroTol      = 1e-10;
  constTest         = 10000;
  constLMin         = -10.000;

  constVersionNumber: String = 'Atriatix v0.005';

  constBifurcation = 1;
  constRandom = 2;
  constLatoof = 3;

implementation

uses Main, Formula, XYSize1, Params, Coefficients, LMString;

{$R *.DFM}

procedure TMDIChild.FormCreate(Sender: TObject);
begin
  v.Abort_Draw := False;
  bRectangleMode := True;
  bZoomingIn := True;
  bInitialUpdate := True;
  v.bInitialize := True;
  v.bInvert := False;
end;

procedure TMDIChild.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  FormPaint;

  if Application.Title = 'REDUCE211' then
     Alias211(Self);

  if Application.Title = 'REDUCE311' then
     Alias311(Self);

  if Application.Title = 'REDUCE411' then
     Alias411(Self);

end;

procedure TMDIChild.FormPaint;
begin
  if bInitialUpdate = True then
  begin
    PGImage1.ActionMode := amMoveImage;
    PGImage1.AutoSizeMaxWidth := Screen.Width - (Width - ClientWidth);
    PGImage1.AutoSizeMaxHeight := Screen.Height - (Height - ClientHeight);

    v.aPG:=TPixelGraphic.Create;

    if bRectangleMode then
      PGImage1.ActionMode := amMoveResizeCreateSelection
    else
      PGImage1.ActionMode := amNone;

    if Application.Title = 'OPEN' then
    begin
      PGImage1.Filename := Caption;
      PGFileInfo(PGImage1.FileName, 0, iType, iSubType, iOptions, v.iWidth, v.iHeight, iColors, iBitsPerPixel, iGraphicCount);
      v.aPG.SetDimension(v.iWidth, v.iHeight, bc24);
    end
    else
    if Application.Title = 'NEW' then
    begin
      v.iWidth := 400;
      v.iHeight := 300;
      v.aPG.SetDimension(v.iWidth, v.iHeight, bc24);
      PGImage1.PixelGraphic := v.aPG;
      Application.Title := 'atriatix ';
      Caption := 'atriatix    ';
      CaptionSave := Caption;
    end;

    v.aPG:=PGImage1.LendNoModifyPixelGraphic;
    v.aPG.Changed(Self);

    SavedPG:=TPixelGraphic.Create;
    SavedPG.SetDimension(v.iWidth, v.iHeight, bc24);

    SourcePG:=PGImage1.LendNoModifyPixelGraphic;

    ResultPG:=TPixelGraphic.Create;
    ResultPG.SetDimension(v.iWidth, v.iHeight, bc24);

    v.Width := v.iWidth;
    v.Height := v.iHeight;
    ResetCoordinates;
    pData := @v;

    v.dRedStep := 0.0;
    v.dGrnStep := 0.0;
    v.dBluStep := 0.0;

    v.formula := 70;
    v.dFactor1 := 10;
    v.dFactor2 := 1.0;
    v.RandomFactor := 2.0;
    v.bInitialize := True;
    v.bSqrt := False;
    v.nCoefficients := 2;
    v.BB := 1.0;
    v.cx := 5.0;
    v.cy := 5.0;

    v.bColorMix := false;
    v.bExpansion := false;
    v.bModulas := false;

    // Scott Draves Flame functions
    v.bNone        := False;
    v.bLinear      := False;
    v.bSinusoidal  := False;
    v.bSpherical   := False;
    v.bSwirl       := False;
    v.bHorseshoe   := False;
    v.bPolar       := False;
    v.bBent        := False;
    v.bInversion   := False;

    CreateTList;

    UpdateGrafX;  // call this to automatically start-up

    bInitialUpdate := False;
    bColorControls := False;

  end;
end;

procedure TMDIChild.CreateTList;
var
  n, nx, ny: Integer;
begin
  v.my_TList.Free;
  v.my_Tlist := Tlist.Create;

  if v.Width >= v.Height then
    n := v.Width
  else
    n := v.Height;

  nx := 0;
  while nx < n do  // Width
  begin
    ny := 0;
    while ny < n do  // Height
    begin
      v.aPG.Bits[nx, ny] := 0;
      v.my_TList.Add(Pointer(0));
      inc(ny);
    end;
    inc(nx);
  end;
end;

///////////////////
procedure TMDIChild.UpdateGrafX;
begin;
  if v.Abort_Draw = True then
    CaptionSave := Caption;

  v.aPG:=TPixelGraphic.Create;
  v.aPG.SetDimension(v.Width, v.Height, bc24);
  PGImage1.PixelGraphic := v.aPG;
  v.aPG.Changed(Self);

  UpdateMenuItems(Self);
  Timer2.Enabled := True;

  v.T1 := 0;

  TypeFractal;

  Timer2.Enabled := False;
  Caption := CaptionSave;
end;

procedure TMDIChild.TypeFractal;
begin
  AdjustCoords;

  v.xMin := v.CRMIN;
  v.yMin := v.CIMIN;
  v.xMax := v.CRMAX;
  v.yMax := v.CIMAX;

  ldx := (v.xMax - v.xMin) / v.iWidth;  // compute size of pixels
  ldy := (v.yMax - v.yMin) / v.iHeight;

  Timer2.Enabled := True;
  v.Abort_Draw := False;

  pData := @v;
  if v.Abort_Draw = False then
    DrawFractal(pData);

  v.aPG.Changed(Self);
  Timer2.Enabled := False;

end;

/////////////////////////////

procedure TMDIChild.UpdateMenuItems(Sender: TObject);
begin
  // bool variables
	SqrtFilter1.Checked := v.bSqrt;
  ColorMix.Checked := v.bColorMix;
  Expansion.Checked := v.bExpansion;
  Modulas.Checked := v.bModulas;

  // formula number
  Draw01.Checked := False;
  Draw02.Checked := False;
  Draw03.Checked := False;
  Draw04.Checked := False;
  Draw05.Checked := False;
  Draw06.Checked := False;
  Draw07.Checked := False;
  Draw08.Checked := False;
  Draw09.Checked := False;
  Draw10.Checked := False;
  Draw11.Checked := False;
  Draw12.Checked := False;
  Draw13.Checked := False;
  Draw14.Checked := False;
  Draw15.Checked := False;
  Draw16.Checked := False;
  Draw17.Checked := False;
  Draw18.Checked := False;
  Draw19.Checked := False;
  Draw20.Checked := False;
  Draw21.Checked := False;
  Draw22.Checked := False;
  Draw23.Checked := False;
  Draw24.Checked := False;
  Draw25.Checked := False;
  Draw26.Checked := False;
  Draw27.Checked := False;
  Draw28.Checked := False;
  Draw29.Checked := False;
  Draw30.Checked := False;
  Draw31.Checked := False;
  Draw32.Checked := False;
  Draw33.Checked := False;
  Draw34.Checked := False;
  Draw35.Checked := False;
  Draw36.Checked := False;
  Draw37.Checked := False;
  Draw38.Checked := False;
  Draw39.Checked := False;
  Draw40.Checked := False;
  Draw41.Checked := False;
  Draw42.Checked := False;
  Draw43.Checked := False;
  Draw44.Checked := False;
  Draw45.Checked := False;
  Draw46.Checked := False;
  Draw47.Checked := False;
  Draw48.Checked := False;
  Draw49.Checked := False;
  Draw50.Checked := False;
  Draw51.Checked := False;
  Draw52.Checked := False;
  Draw53.Checked := False;
  Draw54.Checked := False;
  Draw55.Checked := False;

  Draw60.Checked := False;
  Draw61.Checked := False;
  Draw62.Checked := False;
  Draw63.Checked := False;
  Draw64.Checked := False;
  Draw65.Checked := False;
  Draw66.Checked := False;
  Draw67.Checked := False;
  Draw68.Checked := False;
  Draw69.Checked := False;

  Draw70.Checked := False;
  Draw71.Checked := False;
  Draw72.Checked := False;
  Draw73.Checked := False;
  Draw74.Checked := False;
  Draw75.Checked := False;

  case v.formula of
  1: Draw01.Checked := True;
  2: Draw02.Checked := True;
  3: Draw03.Checked := True;
  4: Draw04.Checked := True;
  5: Draw05.Checked := True;
  6: Draw06.Checked := True;
  7: Draw07.Checked := True;
  8: Draw08.Checked := True;
  9: Draw09.Checked := True;
  10: Draw10.Checked := True;
  11: Draw11.Checked := True;
  12: Draw12.Checked := True;
  13: Draw13.Checked := True;
  14: Draw14.Checked := True;
  15: Draw15.Checked := True;
  16: Draw16.Checked := True;
  17: Draw17.Checked := True;
  18: Draw18.Checked := True;
  19: Draw19.Checked := True;
  20: Draw20.Checked := True;
  21: Draw21.Checked := True;
  22: Draw22.Checked := True;
  23: Draw23.Checked := True;
  24: Draw24.Checked := True;
  25: Draw25.Checked := True;
  26: Draw26.Checked := True;
  27: Draw27.Checked := True;
  28: Draw28.Checked := True;
  29: Draw29.Checked := True;
  30: Draw30.Checked := True;
  31: Draw31.Checked := True;
  32: Draw32.Checked := True;
  33: Draw33.Checked := True;
  34: Draw34.Checked := True;
  35: Draw35.Checked := True;
  36: Draw36.Checked := True;
  37: Draw37.Checked := True;
  38: Draw38.Checked := True;
  39: Draw39.Checked := True;
  40: Draw40.Checked := True;
  41: Draw41.Checked := True;
  42: Draw42.Checked := True;
  43: Draw43.Checked := True;
  44: Draw44.Checked := True;
  45: Draw45.Checked := True;
  46: Draw46.Checked := True;
  47: Draw47.Checked := True;
  48: Draw48.Checked := True;
  49: Draw49.Checked := True;
  50: Draw50.Checked := True;
  51: Draw51.Checked := True;
  52: Draw52.Checked := True;
  53: Draw53.Checked := True;
  54: Draw54.Checked := True;
  55: Draw55.Checked := True;

  60: Draw60.Checked := True;
  61: Draw61.Checked := True;
  62: Draw62.Checked := True;
  63: Draw63.Checked := True;
  64: Draw64.Checked := True;
  65: Draw65.Checked := True;
  66: Draw66.Checked := True;
  67: Draw67.Checked := True;
  68: Draw68.Checked := True;
  69: Draw69.Checked := True;

  70: Draw70.Checked := True;
  71: Draw71.Checked := True;
  72: Draw72.Checked := True;
  73: Draw73.Checked := True;
  74: Draw74.Checked := True;
  75: Draw75.Checked := True;

  end;

end;

procedure TMDIChild.Timer2Timer(Sender: TObject);
begin
  v.aPG.Changed(Self);
  Caption := 'Busy... ' + Format ('%d   %d   %f   %f   %f', [v.T1, v.color, v.AA, v.zx,v.zy]);
  v.T1 := v.T1+1;
  //MainForm.UpdateParameters;
  Application.HandleMessage;
  Invalidate;
end;

procedure TMDIChild.ResetCoordinates;
begin
  v.dMagnification := 0.01;
  //v.dMagnification := 1.0;
  v.dMag_new := v.dMagnification;

  v.CRMIN := -1;
  v.CRMAX :=  1;
  v.CIMIN := -1;
  v.CIMAX :=  1;

  v.CRMIN_NEW := -1;
  v.CRMAX_NEW :=  1;
  v.CIMIN_NEW := -1;
  v.CIMAX_NEW :=  1;

  v.CRMID := ((v.CRMAX - v.CRMIN) / 2.0) + v.CRMIN;
  v.CIMID := ((v.CIMAX - v.CIMIN) / 2.0) + v.CIMIN;
end;

procedure TMDIChild.AdjustCoords;
begin
  //v := pData;

  //str := Format('adjust coords, x=%f, y=%f', [v.x, v.y]);
  //ShowMessage(str);

  v.Radius_x := 2/v.dMagnification;
  v.Radius_y := 2/v.dMagnification;

  v.CRMAX := v.CRMID + v.Radius_x;
  v.CRMIN := v.CRMID - v.Radius_x;
  v.CIMAX := v.CIMID + v.Radius_y;
  v.CIMIN := v.CIMID - v.Radius_y;

  v.rx_ratio := v.Width/v.Height;
  v.ry_ratio := v.Height/v.Width;

  v.rx_ratio := v.rx_ratio + (1-v.rx_ratio)/2;
  v.ry_ratio := v.ry_ratio + (1-v.ry_ratio)/2;

  v.CRMAX := v.CRMAX + (v.Radius_x * (v.rx_ratio) - v.Radius_x);
  v.CRMIN := v.CRMIN - (v.Radius_x * (v.rx_ratio) - v.Radius_x);
  v.CIMAX := v.CIMAX + (v.Radius_x * (v.ry_ratio) - v.Radius_y);
  v.CIMIN := v.CIMIN - (v.Radius_x * (v.ry_ratio) - v.Radius_y);

end;

procedure TMDIChild.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	v.Abort_Draw := True;
  //Action := caFree;
end;

procedure TMDIChild.PGImage1NewAutoSize(Sender: TObject; PGImageWidth,
  PGImageHeight: Integer);
begin
// fit the form to the image
if WindowState = wsNormal then
  begin
    if PGImageWidth < MainForm.ClientWidth then
      ClientWidth := PGImageWidth + 20
    else
      ClientWidth := MainForm.ClientWidth - 50; // 50

     if PGImageHeight < MainForm.ClientHeight then
       ClientHeight := PGImageHeight + 40
     else
       ClientHeight := MainForm.ClientHeight - 70;  // 90
   end;
end;

procedure TMDIChild.Resolution;
begin
  v.aPG.SetDimension(
      Round(XYSize.RxWidth.Value), Round(XYSize.RxHeight.Value), bc24);

  v.aPG.StretchDrawRect(
      PGImage1.Left, PGImage1.Top,
      Round(XYSize.RxWidth.Value), Round(XYSize.RxHeight.Value),
      PGImage1.Left, PGImage1.Top,
      v.Width, v.Height,
      PGImage1.LendNoModifyPixelGraphic);

      v.Width        := Round(XYSize.RxWidth.Value);
      v.Height       := Round(XYSize.RxHeight.Value);
      v.iWidth       := v.Width;
      v.iHeight      := v.Height;

  Caption := CaptionSave;
  CreateTList;
  UpdateGrafX;
end;

procedure TMDIChild.N120by901Click(Sender: TObject);
begin
  XYSize.RxWidth.Value := 120;
  XYSize.RxHeight.Value := 90;
  Resolution;
end;

procedure TMDIChild.N160by1201Click(Sender: TObject);
begin
  XYSize.RxWidth.Value := 160;
  XYSize.RxHeight.Value := 120;
  Resolution;
end;

procedure TMDIChild.N320by2401Click(Sender: TObject);
begin
  XYSize.RxWidth.Value := 320;
  XYSize.RxHeight.Value := 240;
  Resolution;
end;

procedure TMDIChild.N400by3001Click(Sender: TObject);
begin
  XYSize.RxWidth.Value := 400;
  XYSize.RxHeight.Value := 300;
  Resolution;
end;

procedure TMDIChild.N640by4801Click(Sender: TObject);
begin
  XYSize.RxWidth.Value := 640;
  XYSize.RxHeight.Value := 480;
  Resolution;
end;

procedure TMDIChild.N800by6001Click(Sender: TObject);
begin
  XYSize.RxWidth.Value := 800;
  XYSize.RxHeight.Value := 600;
  Resolution;
end;

procedure TMDIChild.N1024by7681Click(Sender: TObject);
begin
  XYSize.RxWidth.Value := 1024;
  XYSize.RxHeight.Value := 758;
  Resolution;
end;

procedure TMDIChild.CustomSize1Click(Sender: TObject);
begin
  if XYSize.Visible = True then
  begin
    XYSize.Visible := False;
  end
  else begin
    XYSize.RxWidth.Value  := v.Width;
    XYSize.RxHeight.Value := v.Height;
    XYSize.Visible := True;
  end;
end;

procedure TMDIChild.SaveAs1Click(Sender: TObject);
begin
  if v.Abort_Draw = False then
    strParamName := ExtractFileName(CaptionSave)
  else
    strParamName := ExtractFileName(Caption);

  Delete(strParamName, Length(strParamName)-3, 4);
  PGSaveDialog1.Filename:=strParamName;
  if PGSaveDialog1.Execute then
  begin
    PGImage1.SaveToFile(PGSaveDialog1.Filename);
    Caption := PGSaveDialog1.Filename;

    // create a parameter file
    strParamName := ExtractFileName(Caption);
    Delete(strParamName, Length(strParamName)-2, 3);

    // created the parameter filename
    strParamName := strParamName + 'atr';

    //Identify the filename and type as OutFile
    AssignFile(OutFile, strParamName);

    // Open and create the param file
    Rewrite(OutFile);

    // Write the program name and version #
    WriteLn(OutFile, constVersionNumber);

    // Write the formula number
    WriteLn(OutFile, IntToStr(v.formula));

    // Write the magnification
    WriteLn(OutFile, FloatToStr(v.dMagnification));

    // Write CRMID, and CRMAX
    WriteLn(OutFile, FloatToStr(v.CRMID));
    WriteLn(OutFile, FloatToStr(v.CRMAX));

    // Write CIMID, and CIMAX
    WriteLn(OutFile, FloatToStr(v.CIMID));
    WriteLn(OutFile, FloatToStr(v.CIMAX));

    // Write color parameters
    WriteLn(OutFile, FloatToStr(v.dRedStep));
    WriteLn(OutFile, FloatToStr(v.dGrnStep));
    WriteLn(OutFile, FloatToStr(v.dBluStep));

    // Write dFactor1, 2 and RandomFactor
    WriteLn(OutFile, FloatToStr(v.dFactor1));
    WriteLn(OutFile, FloatToStr(v.dFactor2));
    WriteLn(OutFile, FloatToStr(v.RandomFactor));

    // Write the bool variables
    if v.bSqrt then
      WriteLn(OutFile, IntToStr(1))
    else
      WriteLn(OutFile, IntToStr(0));

    // write out the coefficiants
    i := 1;
    while (i <= 60) do
    begin
      WriteLn(OutFile, FloatToStr(v.af[i]));
      WriteLn(OutFile, FloatToStr(v.bf[i]));
      inc(i);
    end;

    // Write Gumowski - Mira variables
    WriteLn(OutFile, FloatToStr(v.AA_Initial));
    WriteLn(OutFile, FloatToStr(v.BB));

    // Write the bool variables
    if v.bColorMix then
      WriteLn(OutFile, IntToStr(1))
    else
      WriteLn(OutFile, IntToStr(0));

    // Write the bool variables
    if v.bExpansion then
      WriteLn(OutFile, IntToStr(1))
    else
      WriteLn(OutFile, IntToStr(0));

    // Write the bool variables
    if v.bModulas then
      WriteLn(OutFile, IntToStr(1))
    else
      WriteLn(OutFile, IntToStr(0));

    // write the X and Y parameters
    WriteLn(OutFile, FloatToStr(v.cx));
    WriteLn(OutFile, FloatToStr(v.cy));

    if v.bNone then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bLinear then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bSinusoidal then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bSpherical then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bSwirl then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bHorseshoe then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bPolar then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bBent then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bInversion then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));

    CloseFile(OutFile);

    //ShowMessage('Parameter filename = ' + strParamName + ' len= ' + IntToStr(Length(strParamName)));
  end;
end;

procedure TMDIChild.LoadFromParameterFile(FileName: String);
begin
  //////
  // Test for commas or decimal points in floting point numbers
  // European software writes and reads floting point with commas
  // instead of decimal points
  //Identify the filename and type as OutFile
  AssignFile(OutFile, 'root_-_-_.tmp');

  // Open and create the param file
  Rewrite(OutFile);

  // Write the magnification
  WriteLn(OutFile, FloatToStr(2.0/3.0));

  CloseFile(OutFile);

  // Identify the TextFile as InFile
  AssignFile(OutFile, 'root_-_-_.tmp');

  // Open the file identified with InFile
  Reset(OutFile);

  //PtrString := InString;
  ReadLn(OutFile, StrTemp);
  if StrScan(StrTemp, '.') <> nil then
    bAmerican := True
  else
    bAmerican := False;

  CloseFile(OutFile);

  DeleteFile('root_-_-_.tmp');

  //////////////////////////////////
  //////

  Caption := Filename;
  Application.Title := Caption;

  // Identify the TextFile as InFile
  AssignFile(InFile, Caption);

  // Open the file identified with InFile
  Reset(InFile);

try

  bValid := True;
  // Start Reading in the parameters

  //ShowMessage(FileName);

  // read past the program version info
  ReadLn(InFile, InString);

  // Read the formula number
  ReadFromParameterFile(Self);
  if bValid = True then
    v.formula := StrToInt(InString);

  // Read the magnification
  ReadFromParameterFile(Self);
  if bValid = True then
    v.dMagnification := StrToFloat(InString);

  // Read CRMID, and CRMAX
  ReadFromParameterFile(Self);
  if bValid = True then
    v.CRMID := StrToFloat(InString);

  ReadFromParameterFile(Self);
  if bValid = True then
    v.CRMAX := StrToFloat(InString);

  // Read CIMID, and CIMAX
  ReadFromParameterFile(Self);
  if bValid = True then
    v.CIMID := StrToFloat(InString);

  ReadFromParameterFile(Self);
  if bValid = True then
    v.CIMAX := StrToFloat(InString);

  // Read color parameters
  ReadFromParameterFile(Self);
  if bValid = True then
    v.dRedStep := StrToFloat(InString);

  ReadFromParameterFile(Self);
  if bValid = True then
    v.dGrnStep := StrToFloat(InString);

  ReadFromParameterFile(Self);
  if bValid = True then
    v.dBluStep := StrToFloat(InString);

  // Read dFactor1
  ReadFromParameterFile(Self);
  if bValid = True then
    v.dFactor1 := StrToFloat(InString)
  else
  begin
    bValid := True;
  end;

  // Read dFactor2
  ReadFromParameterFile(Self);
  if bValid = True then
    v.dFactor2 := StrToFloat(InString)
  else
  begin
    bValid := True;
  end;

  // Read RandomFactor
  ReadFromParameterFile(Self);
  if bValid = True then
    v.RandomFactor := StrToFloat(InString)
  else
  begin
    bValid := True;
  end;

  // read bSqrt bool variable
  ReadFromParameterFile(Self);
  if bValid = True then
    if InString = '1' then
      v.bSqrt := True
    else
      v.bSqrt := False;

  // read in the coefficiants
  i := 1;
  while (i <= 60) do
  begin
    ReadFromParameterFile(Self);
    if bValid = True then
      v.af[i] := StrToFloat(InString)
    else
    begin
      bValid := True;
    end;

    ReadFromParameterFile(Self);
    if bValid = True then
      v.bf[i] := StrToFloat(InString)
    else
    begin
      bValid := True;
    end;

    inc(i);
  end;

  // Read the Gumowski - Mira coefficiants AA
  ReadFromParameterFile(Self);
  if bValid = True then
    v.AA_Initial := StrToFloat(InString);

  // Read the Gumowski - Mira coefficiants BB
  ReadFromParameterFile(Self);
  if bValid = True then
    v.BB := StrToFloat(InString);

  // read bColorMix bool variable
  ReadFromParameterFile(Self);
  if v.bColorMix = True then
    if InString = '1' then
      v.bColorMix := True
    else
      v.bColorMix := False;

  // read bExpansion bool variable
  ReadFromParameterFile(Self);
  if v.bExpansion = True then
    if InString = '1' then
      v.bExpansion := True
    else
      v.bExpansion := False;

  // read bModulas bool variable
  ReadFromParameterFile(Self);
  if v.bModulas = True then
    if InString = '1' then
      v.bModulas := True
    else
      v.bModulas := False;

  // read the X and Y values
  ReadFromParameterFile(Self);
  if bValid = True then
    v.cx := StrToFloat(InString)
  else
    v.cx := 5.0;

  ReadFromParameterFile(Self);
  if bValid = True then
    v.cy := StrToFloat(InString)
  else
    v.cy := 5.0;

  ReadFromParameterFile(Self);
  if bValid = True then
    if InString = '1' then
      v.bNone := True
    else
      v.bNone := False;

  ReadFromParameterFile(Self);
  if bValid = True then
    if InString = '1' then
      v.bLinear := True
    else
      v.bLinear := False;

  ReadFromParameterFile(Self);
  if bValid = True then
    if InString = '1' then
      v.bSinusoidal := True
    else
      v.bSinusoidal := False;

  ReadFromParameterFile(Self);
  if bValid = True then
    if InString = '1' then
      v.bSpherical := True
    else
      v.bSpherical := False;

  ReadFromParameterFile(Self);
  if bValid = True then
    if InString = '1' then
      v.bSwirl := True
    else
      v.bSwirl := False;

  ReadFromParameterFile(Self);
  if bValid = True then
    if InString = '1' then
      v.bHorseshoe := True
    else
      v.bHorseshoe := False;

  ReadFromParameterFile(Self);
  if bValid = True then
    if InString = '1' then
      v.bPolar := True
    else
      v.bPolar := False;

  ReadFromParameterFile(Self);
  if bValid = True then
    if InString = '1' then
      v.bBent := True
    else
      v.bBent := False;

  ReadFromParameterFile(Self);
  if bValid = True then
    if InString = '1' then
      v.bInversion := True
    else
      v.bInversion := False;

except
  ShowMessage('Error reading parameter file');
end;

  CloseFile(InFile);

  v.bInitialize := False;
  UpdateGrafx;

end;

procedure TMDIChild.ReadFromParameterFile(Sender: TObject);
begin
  if bValid = True then
  begin
    ReadLn(InFile, InString);
    if InString = '' then
    begin
      ShowMessage('Missing variable in parameter file: ' + Caption + ' using defaults');
      bValid := False;
      //Abort_Draw := True;
      //Close;
    end;

    if bAmerican = True then
      InString := StrReplaceAll(InString, ',', '.')
    else
      InString := StrReplaceAll(InString, '.', ',');

  end;
end;

procedure TMDIChild.Zoom1Click(Sender: TObject);
begin
  if v.Width <> 0 then
  begin
    if (PGImage1.Selection = True) or (not bRectangleMode) then
    begin

      Timer2.Enabled := False;

      v.CRMIN := v.CRMIN_NEW;
      v.CRMAX := v.CRMAX_NEW;
      v.CIMIN := v.CIMIN_NEW;
      v.CIMAX := v.CIMAX_NEW;

      v.CRMID := ((v.CRMAX - v.CRMIN) / 2.0) + v.CRMIN;
      v.CIMID := ((v.CIMAX - v.CIMIN) / 2.0) + v.CIMIN;

      v.dMagnification := v.dMag_new;

      PGImage1.Selection := False;
      PGImage1.ActionMode := amNone;

      v.aPG.StretchDrawRect(
          0, 0,
          v.Width, v.Height,
          PGImage1.SelectionLeft, PGImage1.SelectionTop,
          PGImage1.SelectionWidth, PGImage1.SelectionHeight,
          PGImage1.LendNoModifyPixelGraphic);

      v.aPG.Changed(Self);
      UpdateGrafX;

    end
    else begin
      ShowMessage('there is nothing selected');
    end;
  end;
end;

procedure TMDIChild.PGImage1PicBoxOnMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var
  PGX, PGY: Integer;

begin
  PGX:=PGImage1.PicToGraphicX(X);
  PGY:=PGImage1.PicToGraphicY(Y);

  Shift_Sav := Shift;

  if v.Width <> 0 then
  begin
    /////////////////////////////////////////////////////////////
    ldx := (v.xMax - v.xMin) / v.Width;    // compute size of pixels
    ldy := (v.yMax - v.yMin) / v.Height;

    cxp := v.xMin + PGX * ldx;  	       // calculate coordinate at pixel
    cyp := v.yMin + PGY * ldy;

    StatusBar1.Panels[0].Text:='cx='+Format('%1.12f', [cxp]);
    StatusBar1.Panels[1].Text:='cy='+Format('%1.12f', [cyp]);
    StatusBar1.Panels[2].Text:='M='+Format('%1.12f', [v.dMagnification]);
  end;
end;

procedure TMDIChild.PGImage1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  rb_center_x, rb_center_y: Double;
  rb_avg, dim_avg: Double;
  dim_width, dim_height: Double;
  sxmin, sxmax, symin, symax: Double;
  x_size, y_size: Double;

begin
  if Shift_Sav = [ssLeft] then
  begin
    if PGImage1.Selection or not bRectangleMode then
    begin
      //if not ((v.jul = 1) and (v.jul_save = 0)) then
      begin
        if not bRectangleMode then
        begin
          // Redraw the tracking rectangle
          // Transform to display coordinates
          if bZoomingIn then
          begin
            PGImage1.SelectionWidth  := Round(v.Width*0.5);
            PGImage1.SelectionHeight := Round(v.Height*0.5);
          end
          else
          begin
            PGImage1.SelectionWidth  := Round(v.Width*2.0);
            PGImage1.SelectionHeight := Round(v.Height*2.0);
          end;

          rb_center_x := X_Pixel;
          rb_center_y := Y_Pixel;
        end
        else
        begin
          rb_center_x := (PGImage1.SelectionWidth  / 2) + PGImage1.SelectionLeft;
          rb_center_y := (PGImage1.SelectionHeight / 2) + PGImage1.SelectionTop;
        end;

        // calculate the average width & height
        rb_avg := (PGImage1.SelectionWidth + PGImage1.SelectionHeight) / 2;

        dim_width  :=  v.Width;
        dim_height :=  v.Height;
        dim_avg    := (v.Width + v.Height) / 2;

        // Calculate transformed points
        PGImage1.SelectionWidth  := Round(rb_avg * (dim_width / dim_avg));
        PGImage1.SelectionLeft   := Round(rb_center_x - rb_avg * (dim_width / dim_avg) / 2.0);
        PGImage1.SelectionHeight := Round(rb_avg * (dim_height / dim_avg));
        PGImage1.SelectionTop    := Round(rb_center_y - rb_avg * (dim_height / dim_avg) / 2.0);

        // scale the screen coordinates
        sxmin := PGImage1.SelectionLeft / dim_width;
        sxmax := (PGImage1.SelectionLeft + PGImage1.SelectionWidth) / dim_width;

        symin := PGImage1.SelectionTop / dim_height;
        symax := (PGImage1.SelectionTop + PGImage1.SelectionHeight) / dim_height;

        x_size := v.CRMAX - v.CRMIN;
        y_size := v.CIMAX - v.CIMIN;

        v.CRMIN_NEW := x_size * sxmin + v.CRMIN;
        v.CRMAX_NEW := x_size * sxmax + v.CRMIN;

        v.CIMIN_NEW := y_size * symin + v.CIMIN;
        v.CIMAX_NEW := y_size * symax + v.CIMIN;

        v.CRMID_OLD := v.CRMID;
        v.CIMID_OLD := v.CIMID;

        v.CRMID_NEW := ((v.CRMAX_NEW - v.CRMIN_NEW) / 2.0) + v.CRMIN_NEW;
        v.CIMID_NEW := ((v.CIMAX_NEW - v.CIMIN_NEW) / 2.0) + v.CIMIN_NEW;

        // Calculate the Magnification (2 / average of width & length)
        v.dMag_new := ((Abs(v.CRMAX_NEW - v.CRMIN_NEW) / 2)
                 + (Abs(v.CIMAX_NEW - v.CIMIN_NEW) / 2)) / 2;

        if v.dMag_new <> 0 then
          v.dMag_new := (1 / v.dMag_new) * 2;

      end;
    end;
  end;
end;

procedure TMDIChild.PGImage1PicBoxOnDblClick(Sender: TObject);
begin
  Zoom1Click(Self);
  PGImage1.Selection := False;
  PGImage1.ActionMode := amNone;
end;

procedure TMDIChild.PGImage1PicBoxOnMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  X_pixel := X;
  Y_pixel := (v.iHeight-Y);
  Shift_Sav := Shift;

  if Shift = [ssLeft] then
  begin
    if bRectangleMode then
       PGImage1.ActionMode := amMoveResizeCreateSelection
    else
    begin
       PGImage1.ActionMode := amNone;
    end;
  end;
end;

procedure TMDIChild.PGImage1PicBoxOnMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  rb_center_x, rb_center_y: Double;
  rb_avg, dim_avg: Double;
  dim_width, dim_height: Double;
  sxmin, sxmax, symin, symax: Double;
  x_size, y_size: Double;

begin
  if Shift_Sav = [ssLeft] then
  begin
    if PGImage1.Selection or not bRectangleMode then
    begin
      //if not ((v.jul = 1) and (v.jul_save = 0)) then
      begin
        if not bRectangleMode then
        begin
          // Redraw the tracking rectangle
          // Transform to display coordinates
          if bZoomingIn then
          begin
            PGImage1.SelectionWidth  := Round(v.Width*0.5);
            PGImage1.SelectionHeight := Round(v.Height*0.5);
          end
          else
          begin
            PGImage1.SelectionWidth  := Round(v.Width*2.0);
            PGImage1.SelectionHeight := Round(v.Height*2.0);
          end;

          rb_center_x := X_Pixel;
          rb_center_y := Y_Pixel;
        end
        else
        begin
          rb_center_x := (PGImage1.SelectionWidth  / 2) + PGImage1.SelectionLeft;
          rb_center_y := (PGImage1.SelectionHeight / 2) + PGImage1.SelectionTop;
        end;

        // calculate the average width & height
        rb_avg := (PGImage1.SelectionWidth + PGImage1.SelectionHeight) / 2;

        dim_width  :=  v.Width;
        dim_height :=  v.Height;
        dim_avg    := (v.Width + v.Height) / 2;

        // Calculate transformed points
        PGImage1.SelectionWidth  := Round(rb_avg * (dim_width / dim_avg));
        PGImage1.SelectionLeft   := Round(rb_center_x - rb_avg * (dim_width / dim_avg) / 2.0);
        PGImage1.SelectionHeight := Round(rb_avg * (dim_height / dim_avg));
        PGImage1.SelectionTop    := Round(rb_center_y - rb_avg * (dim_height / dim_avg) / 2.0);

        // scale the screen coordinates
        sxmin := PGImage1.SelectionLeft / dim_width;
        sxmax := (PGImage1.SelectionLeft + PGImage1.SelectionWidth) / dim_width;

        symin := PGImage1.SelectionTop / dim_height;
        symax := (PGImage1.SelectionTop + PGImage1.SelectionHeight) / dim_height;

        x_size := v.CRMAX - v.CRMIN;
        y_size := v.CIMAX - v.CIMIN;

        v.CRMIN_NEW := x_size * sxmin + v.CRMIN;
        v.CRMAX_NEW := x_size * sxmax + v.CRMIN;

        v.CIMIN_NEW := y_size * symin + v.CIMIN;
        v.CIMAX_NEW := y_size * symax + v.CIMIN;

        v.CRMID_OLD := v.CRMID;
        v.CIMID_OLD := v.CIMID;

        v.CRMID_NEW := ((v.CRMAX_NEW - v.CRMIN_NEW) / 2.0) + v.CRMIN_NEW;
        v.CIMID_NEW := ((v.CIMAX_NEW - v.CIMIN_NEW) / 2.0) + v.CIMIN_NEW;

        // Calculate the Magnification (2 / average of width & length)
        v.dMag_new := ((Abs(v.CRMAX_NEW - v.CRMIN_NEW) / 2)
                 + (Abs(v.CIMAX_NEW - v.CIMIN_NEW) / 2)) / 2;

        if v.dMag_new <> 0 then
          v.dMag_new := (1 / v.dMag_new) * 2;
      end;
    end;
  end;
end;

procedure TMDIChild.SqrtFilter1Click(Sender: TObject);
begin
	SqrtFilter1.Checked := not SqrtFilter1.Checked;
	v.bSqrt := SqrtFilter1.Checked;
end;

Procedure TMDIChild.ApplyParameters;
begin
  //
  v.dRedStep := Form4.RedBar1.Position;
  v.dGrnStep := Form4.GrnBar1.Position;
  v.dBluStep := Form4.BluBar1.Position;

  Form4.RedLabel1.Caption := Format('%F', [v.dRedStep]);
  Form4.GrnLabel1.Caption := Format('%F', [v.dGrnStep]);
  Form4.BluLabel1.Caption := Format('%F', [v.dBluStep]);

  v.dFactor1 := Round(Form4.Intensity.Position);
  v.dFactor2 := Round(Form4.Factor2_bar.Position)*0.1;
  v.RandomFactor := Round(Form4.Randomizer.Position)*0.2;

  Form4.Factor1.Caption := Format('%F', [v.dFactor1]);
  Form4.Factor2.Caption := Format('%F', [v.dFactor2]);
  Form4.RandomFactor.Caption := Format('%F', [v.RandomFactor]);

  v.AA_Initial := Form4.constAA.Value;
  v.C := v.AA_Initial;
  v.BB := Form4.constBB.Value;
  v.bSqrt   := Form4.square_root.Checked;
  v.bInvert := Form4.Invert.Checked;
  v.cx := Form4.parameterX.Value;
  v.cy := Form4.parameterY.Value;

  v.bNone        := Form4.None.Checked;
  v.bLinear      := Form4.Linear.Checked;
  v.bSinusoidal  := Form4.Sinusoidal.Checked;
  v.bSpherical   := Form4.Spherical.Checked;
  v.bSwirl       := Form4.Swirl.Checked;
  v.bHorseshoe   := Form4.Horseshoe.Checked;
  v.bPolar       := Form4.Polar.Checked;
  v.bBent        := Form4.Bent.Checked;
  v.bInversion   := Form4.Inversion.Checked;

end;

procedure TMDIChild.Parameters1Click(Sender: TObject);
begin
  if Form4.Visible = True then
  begin
    Form4.Visible := False;
  end
  else begin
    Parameters1Update;
    Form4.Visible := True;
  end;
end;

procedure TMDIChild.Parameters1Update;
begin
    Form4.RedBar1.Position := Round(v.dRedStep);
    Form4.GrnBar1.Position := Round(v.dGrnStep);
    Form4.BluBar1.Position := Round(v.dBluStep);

    Form4.RedLabel1.Caption := Format('%F', [v.dRedStep]);
    Form4.GrnLabel1.Caption := Format('%F', [v.dGrnStep]);
    Form4.BluLabel1.Caption := Format('%F', [v.dBluStep]);

    Form4.square_root.Checked   := v.bSqrt;
    Form4.Invert.Checked := v.bInvert;

    Form4.Intensity.Position := Round(v.dFactor1);
    Form4.Factor2_bar.Position := Round(v.dFactor2*10.0);
    Form4.Randomizer.Position := Round(v.RandomFactor)*5;

    Form4.Factor1.Caption := Format('%F', [v.dFactor1]);
    Form4.Factor2.Caption := Format('%F', [v.dFactor2]);
    Form4.RandomFactor.Caption := Format('%F', [v.RandomFactor]);

    Form4.constAA.Value := v.AA;
    Form4.constBB.Value := v.BB;
    Form4.parameterX.Value := v.cx;
    Form4.parameterY.Value := v.cy;

    // Scott Draves Flame functions
    Form4.None.Checked       := v.bNone;
    Form4.Linear.Checked     := v.bLinear;
    Form4.Sinusoidal.Checked := v.bSinusoidal;
    Form4.Spherical.Checked  := v.bSpherical;
    Form4.Swirl.Checked      := v.bSwirl;
    Form4.Horseshoe.Checked  := v.bHorseshoe;
    Form4.Polar.Checked      := v.bPolar;
    Form4.Bent.Checked       := v.bBent;
    Form4.Inversion.Checked  := v.bInversion;

    CForm.A01.Value := v.af[01];
    CForm.A02.Value := v.af[02];
    CForm.A03.Value := v.af[03];
    CForm.A04.Value := v.af[04];
    CForm.A05.Value := v.af[05];
    CForm.A06.Value := v.af[06];

    CForm.B01.Value := v.af[07];
    CForm.B02.Value := v.af[08];
    CForm.B03.Value := v.af[09];
    CForm.B04.Value := v.af[10];
    CForm.B05.Value := v.af[11];
    CForm.B06.Value := v.af[12];

    CForm.C01.Value := v.af[13];
    CForm.C02.Value := v.af[14];
    CForm.C03.Value := v.af[15];
    CForm.C04.Value := v.af[16];
    CForm.C05.Value := v.af[17];
    CForm.C06.Value := v.af[18];

end;

procedure TMDIChild.UpdateCoefficiants;
begin

  v.af[01] := CForm.A01.Value;
  v.af[02] := CForm.A02.Value;
  v.af[03] := CForm.A03.Value;
  v.af[04] := CForm.A04.Value;
  v.af[05] := CForm.A05.Value;
  v.af[06] := CForm.A06.Value;

  v.af[07] := CForm.B01.Value;
  v.af[08] := CForm.B02.Value;
  v.af[09] := CForm.B03.Value;
  v.af[10] := CForm.B04.Value;
  v.af[11] := CForm.B05.Value;
  v.af[12] := CForm.B06.Value;

  v.af[13] := CForm.C01.Value;
  v.af[14] := CForm.C02.Value;
  v.af[15] := CForm.C03.Value;
  v.af[16] := CForm.C04.Value;
  v.af[17] := CForm.C05.Value;
  v.af[18] := CForm.C06.Value;

  //v.bInitialize := False;
  //UpdateGrafX;

end;

procedure TMDIChild.ConstantsDialog1Click(Sender: TObject);
begin
  if CForm.Visible = True then
  begin
    CForm.Visible := False;
  end
  else begin
    Parameters1Update;
    CForm.Visible := True;
  end;
end;

procedure TMDIChild.ClearRectangle1Click(Sender: TObject);
begin
  PGImage1.Selection := False;
end;

procedure TMDIChild.Draw01Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 1;
  UpdateGrafX;
end;

procedure TMDIChild.Draw02Click(Sender: TObject);
begin
  v.BB := 1.005;
  v.bInitialize := True;
  v.formula := 2;
  UpdateGrafX;
end;

procedure TMDIChild.Draw03Click(Sender: TObject);
begin
  v.BB := 1.005;
  v.bInitialize := True;
  v.formula := 3;
  UpdateGrafX;
end;

procedure TMDIChild.Draw04Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 4;
  UpdateGrafX;
end;

procedure TMDIChild.Draw05Click(Sender: TObject);
begin
  v.BB := 1.005;
  v.bInitialize := True;
  v.formula := 5;
  UpdateGrafX;
end;

procedure TMDIChild.Draw06Click(Sender: TObject);
begin
  v.BB := 1.005;
  v.bInitialize := True;
  v.formula := 6;
  UpdateGrafX;
end;

procedure TMDIChild.Draw07Click(Sender: TObject);
begin
  v.BB := 1.005;
  v.bInitialize := True;
  v.formula := 7;
  UpdateGrafX;
end;

procedure TMDIChild.Draw08Click(Sender: TObject);
begin
  v.BB := 1.005;
  v.bInitialize := True;
  v.formula := 8;
  UpdateGrafX;
end;

procedure TMDIChild.Draw09Click(Sender: TObject);
begin
  v.BB := 1.005;
  v.bInitialize := True;
  v.formula := 9;
  UpdateGrafX;
end;

procedure TMDIChild.Draw10Click(Sender: TObject);
begin
  v.BB := 1.005;
  v.bInitialize := True;
  v.formula := 10;
  UpdateGrafX;
end;

procedure TMDIChild.Draw11Click(Sender: TObject);
begin
  v.BB := 1.005;
  v.bInitialize := True;
  v.formula := 11;
  UpdateGrafX;
end;

procedure TMDIChild.Draw12Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 12;
  UpdateGrafX;
end;

procedure TMDIChild.Draw13Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 13;
  UpdateGrafX;
end;

procedure TMDIChild.Draw14Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 14;
  UpdateGrafX;
end;

procedure TMDIChild.Draw15Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 15;
  UpdateGrafX;
end;

procedure TMDIChild.Draw16Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 16;
  UpdateGrafX;
end;

procedure TMDIChild.Draw17Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 17;
  UpdateGrafX;
end;

procedure TMDIChild.Draw18Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 18;
  UpdateGrafX;
end;

procedure TMDIChild.Draw19Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 19;
  UpdateGrafX;
end;

procedure TMDIChild.Draw20Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 20;
  UpdateGrafX;
end;

procedure TMDIChild.Draw21Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 21;
  UpdateGrafX;
end;

procedure TMDIChild.Draw22Click(Sender: TObject);
begin
  v.BB := 1.005;
  v.bInitialize := True;
  v.formula := 22;
  UpdateGrafX;
end;

procedure TMDIChild.Draw23Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 23;
  UpdateGrafX;
end;

procedure TMDIChild.Draw24Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 24;
  UpdateGrafX;
end;

procedure TMDIChild.Draw25Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 25;
  UpdateGrafX;
end;

procedure TMDIChild.Draw26Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 26;
  UpdateGrafX;
end;

procedure TMDIChild.Draw27Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 27;
  UpdateGrafX;
end;

procedure TMDIChild.Draw28Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 28;
  UpdateGrafX;
end;

procedure TMDIChild.Draw29Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 29;
  UpdateGrafX;
end;

procedure TMDIChild.Draw30Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 30;
  UpdateGrafX;
end;

procedure TMDIChild.Draw31Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 31;
  UpdateGrafX;
end;

procedure TMDIChild.Draw32Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 32;
  UpdateGrafX;
end;

procedure TMDIChild.Draw33Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 33;
  UpdateGrafX;
end;

procedure TMDIChild.Draw34Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 34;
  UpdateGrafX;
end;

procedure TMDIChild.Draw35Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 35;
  UpdateGrafX;
end;

procedure TMDIChild.Draw36Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 36;
  UpdateGrafX;
end;

procedure TMDIChild.Draw37Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 37;
  UpdateGrafX;
end;

procedure TMDIChild.Draw38Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 38;
  UpdateGrafX;
end;

procedure TMDIChild.Draw39Click(Sender: TObject);
begin
  v.bInitialize := True;
  v.formula := 39;
  UpdateGrafX;
end;

procedure TMDIChild.Draw40Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 40;
  UpdateGrafX;
end;

procedure TMDIChild.Draw41Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 41;
  UpdateGrafX;
end;

procedure TMDIChild.Draw42Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 42;
  UpdateGrafX;
end;

procedure TMDIChild.Draw43Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 43;
  UpdateGrafX;
end;

procedure TMDIChild.Draw44Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 44;
  UpdateGrafX;
end;

procedure TMDIChild.Draw45Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 45;
  UpdateGrafX;

end;

procedure TMDIChild.Draw46Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 46;
  UpdateGrafX;
end;

procedure TMDIChild.Draw47Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 47;
  UpdateGrafX;
end;

procedure TMDIChild.Draw48Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 48;
  UpdateGrafX;
end;

procedure TMDIChild.Draw49Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 49;
  UpdateGrafX;
end;

procedure TMDIChild.Draw50Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 50;
  UpdateGrafX;
end;

procedure TMDIChild.Draw51Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 51;
  UpdateGrafX;
end;

procedure TMDIChild.Draw52Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 52;
  UpdateGrafX;
end;

procedure TMDIChild.Draw53Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 53;
  UpdateGrafX;
end;

procedure TMDIChild.Draw54Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 54;
  UpdateGrafX;
end;

procedure TMDIChild.Draw55Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 55;
  UpdateGrafX;
end;

//-----------

procedure TMDIChild.Draw60Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 60;
  UpdateGrafX;
end;

procedure TMDIChild.Draw61Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 61;
  UpdateGrafX;
end;

procedure TMDIChild.Draw62Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 62;
  UpdateGrafX;
end;

procedure TMDIChild.Draw63Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 63;
  UpdateGrafX;
end;

procedure TMDIChild.Draw64Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 64;
  UpdateGrafX;
end;

procedure TMDIChild.Draw65Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 65;
  UpdateGrafX;
end;

procedure TMDIChild.Draw66Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 66;
  UpdateGrafX;
end;

procedure TMDIChild.Draw67Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 67;
  UpdateGrafX;
end;

procedure TMDIChild.Draw68Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 68;
  UpdateGrafX;
end;

procedure TMDIChild.Draw69Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 69;
  UpdateGrafX;
end;

procedure TMDIChild.Draw70Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 70;
  UpdateGrafX;
end;

procedure TMDIChild.Draw71Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 71;
  UpdateGrafX;
end;

procedure TMDIChild.Draw72Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 72;
  UpdateGrafX;
end;

procedure TMDIChild.Draw73Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 73;
  UpdateGrafX;
end;

procedure TMDIChild.Draw74Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 74;
  UpdateGrafX;
end;

procedure TMDIChild.Draw75Click(Sender: TObject);
begin
  v.BB := 1.00;
  v.bInitialize := True;
  v.formula := 75;
  UpdateGrafX;
end;

// ------

procedure TMDIChild.ModulasClick(Sender: TObject);
begin
  v.bModulas := not v.bModulas;
  UpdateGrafX;
end;

procedure TMDIChild.ExpansionClick(Sender: TObject);
begin
  v.bExpansion := not v.bExpansion;
  UpdateGrafX;
end;

procedure TMDIChild.ColorMixClick(Sender: TObject);
begin
  v.bColorMix := not v.bColorMix;
  UpdateGrafX;
end;

procedure TMDIChild.AntiAlias211Click(Sender: TObject);
begin
  PGImage1.ActionMode := amNone;
  PGImage1.PICBox.Cursor := crHourGlass;
  ShowCursor(True);
  Timer1.Enabled := True;
  Application.Title := 'REDUCE211';
end;

procedure TMDIChild.Alias211(Sender: TObject);
begin
  SourcePG:=PGImage1.LendNoModifyPixelGraphic;
  ResultPG:=TPixelGraphic.Create;
  ResultPG.SetDimension(SourcePG.Width div 2, SourcePG.Height div 2, bc24);
  // set ResultPG.StretchMode if desired
  ResultPG.StretchDraw(SourcePG);
  PGImage1.TakePixelGraphic(ResultPG);

  PGImage1.PICBox.Cursor := crArrow;
  PGImage1.ActionMode := amMoveImage;
  v.aPG := ResultPG;
end;

procedure TMDIChild.AntiAlias311Click(Sender: TObject);
begin
  PGImage1.ActionMode := amNone;
  PGImage1.PICBox.Cursor := crHourGlass;
  ShowCursor(True);
  Timer1.Enabled := True;
  Application.Title := 'REDUCE311';
end;

procedure TMDIChild.Alias311(Sender: TObject);
begin
  SourcePG:=PGImage1.LendNoModifyPixelGraphic;
  ResultPG:=TPixelGraphic.Create;
  ResultPG.SetDimension(SourcePG.Width div 3, SourcePG.Height div 3, bc24);
  // set ResultPG.StretchMode if desired
  ResultPG.StretchDraw(SourcePG);
  PGImage1.TakePixelGraphic(ResultPG);

  PGImage1.PICBox.Cursor := crArrow;
  PGImage1.ActionMode := amMoveImage;
  v.aPG := ResultPG;
end;

procedure TMDIChild.AntiAlias411Click(Sender: TObject);
begin
  PGImage1.ActionMode := amNone;
  PGImage1.PICBox.Cursor := crHourGlass;
  ShowCursor(True);
  Timer1.Enabled := True;
  Application.Title := 'REDUCE411';
end;

procedure TMDIChild.Alias411(Sender: TObject);
begin
  SourcePG:=PGImage1.LendNoModifyPixelGraphic;
  ResultPG:=TPixelGraphic.Create;
  ResultPG.SetDimension(SourcePG.Width div 4, SourcePG.Height div 4, bc24);
  // set ResultPG.StretchMode if desired
  ResultPG.StretchDraw(SourcePG);
  PGImage1.TakePixelGraphic(ResultPG);

  PGImage1.PICBox.Cursor := crArrow;
  PGImage1.ActionMode := amMoveImage;
  v.aPG := ResultPG;
end;


end.

