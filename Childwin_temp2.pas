unit Childwin_temp2;

interface

//uses Windows, Classes, Graphics, Forms, Controls, PGraphic, ExtCtrls;

uses Windows, Classes, Graphics, Forms, Controls, TB97, Menus, PGraphic,
  ComCtrls, ExtCtrls, Dialogs, SysUtils, CoolMenu, CoolCtrls;

type
  //iArray = array [0..799, 0..599] of Integer;
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
    nBlendingMethod: Integer;
    nColoringOrder: Integer;
    nCoefficients: Integer;
    T1, nPoints: Integer;
    iWidth, iHeight: Integer;
    Lyapunov: double;

    bLatoocarfian01,  bLatoocarfian02: Bool;
    bMira_01, bIFS_01, bIFS_02: Bool;
    bAT_01, bAT_02: Bool;
    bNone, bLinear, bSinusoidal, bSpherical, bSwirl, bHorseshoe, bPolar, bBent: Bool;
    bInvert: Bool;

    bInitialize: Bool;
    Abort_Draw, bSqrt: Bool;
    bMira0101, bMira0102, bMira0103, bMira0104, bMira0105, bMira0106: Bool;
    bMira0107, bMira0108, bMira0109, bMira0110, bMira0111, bMira0112: Bool;
    bMira0113: Bool;
    bIFS0101, bIFS0102, bIFS0103, bIFS0104, bIFS0105: Bool;
    bIFS0106, bIFS0107, bIFS0108: Bool;

    af, bf: affineArray;
    aPG: TPixelGraphic;

    redTList: TList;
    grnTList: TList;
    bluTList: TList;

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
    Palette1: TMenuItem;
    Animate1: TMenuItem;
    PGSaveDialog1: TPGSaveDialog;
    Zoom1: TMenuItem;
    StatusBar1: TStatusBar;
    PGImage1: TPGImage;
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
		procedure animator(Sender: TObject);
    procedure AppIdle(Sender: TObject; var Done: Boolean);
    procedure Animate1Click(Sender: TObject);
		procedure SaveAs1Click(Sender: TObject);
    procedure Zoom1Click(Sender: TObject);

  private
    { Private declarations }

  public
    { Public declarations }

    //SavedPG: TPixelGraphic;
    //ResultPG, SourcePG: TPixelGraphic;

    ResultPG: TPixelGraphic;

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

  constVersionNumber: String = 'root-IFS v0.005';

  constBifurcation = 1;
  constRandom = 2;
  constLatoof = 3;

implementation

uses Main, Formula, XYSize1;

{$R *.DFM}

procedure TMDIChild.FormCreate(Sender: TObject);
  procedure FillPaletteEntries(Index1, Index2, R1, G1, B1, R2, G2, B2: Byte);
  var i: Integer;
  begin
    for i:=Index1 to Index2-1{!} do
         v.aPG.PaletteEntries[i]:=rgb(
            R1+(i-Index1)*(R2-R1) div (Index2-Index1),
            G1+(i-Index1)*(G2-G1) div (Index2-Index1),
            B1+(i-Index1)*(B2-B1) div (Index2-Index1)
            );
  end;

  var
   ScreenDC: HDC;
   DCBitCount: Integer;

begin
  v.Abort_Draw := False;
  bRectangleMode := True;
  bZoomingIn := True;
  bInitialUpdate := True;
  v.bInitialize := True;
  v.bInvert := False;

  ScreenDC:=GetDC(0);
  try
    DCBitCount := (GetDeviceCaps(ScreenDC,BITSPIXEL) * GetDeviceCaps(ScreenDC, PLANES));
  finally
    ReleaseDC(0, ScreenDC);
  end; // of try/finally

  if DCBitCount < 8 then
  begin
    ShowMessage('This application requires a 256 color or true color system...');
    Application.Terminate;
  end;

  v.aPG                    := TPixelGraphic.Create;
  v.aPG.BitCount           := bc8;
  v.aPG.NumPaletteEntries  := 235;

  v.iWidth := 400;
  v.iHeight := 300;

  v.aPG.SetDimension(v.iWidth, v.iHeight, bc8);

  // Setting the PaletteAnimation property to true causes that no palette entries of other
  // windows will mapped to the same entries in the system palette.
  v.aPG.PaletteAnimation   := true;

  // Fill the palette
  v.aPG.PaletteEntries[0]  := 0;

  (*
  FillPaletteEntries(1,40,      255,000,000,  255,255,000);
  FillPaletteEntries(40,79,     255,255,000,  000,255,000);
  FillPaletteEntries(79,118,    000,255,000,  000,255,255);
  FillPaletteEntries(118,157,   000,255,255,  000,000,255);
  FillPaletteEntries(157,196,   000,000,255,  255,000,255);
  FillPaletteEntries(196,235,   255,000,255,  255,000,000);
  *)

  //FillPaletteEntries(  1, 117,  64, 64, 64, 255,255,255);
  //FillPaletteEntries(117, 235,  64,254,254,  65, 65, 65);

  FillPaletteEntries(1,   40,    255, 000, 255,   255, 000, 128);
  FillPaletteEntries(40,  79,    255, 000, 128,   000, 255, 000);
  FillPaletteEntries(79, 118,    000, 255, 000,   000, 255, 255);
  FillPaletteEntries(118,157,    000, 255, 255,   000, 000, 255);
  FillPaletteEntries(157,196,    000, 000, 255,   255, 128, 255);
  FillPaletteEntries(196,235,    255, 128, 255,   255, 000, 255);

  //FillPaletteEntries(118,119, 255,255,255, 255, 255, 255);

  (*
  FillPaletteEntries(1,40,255,128,128,255,128,0);
  FillPaletteEntries(40,79,128,64,64,0,64,0);
  FillPaletteEntries(79,118,64,255,128,0,255,255);
  FillPaletteEntries(118,157,128,255,255,128,128,255);
  FillPaletteEntries(157,196,128,128,255,255,128,255);
  FillPaletteEntries(196,235,255,128,255,255,255,128);
  *)

  // This examples generates a palette that includes black, white and 254 random entries. You will create "your" palette here.
  //aPG.NumPaletteEntries:=235;
  //aPG.PaletteEntries[0]:=rgb(0, 0, 0);
  //aPG.PaletteEntries[1]:=rgb(255, 255, 255);

  (*
  Randomize;

  for i:= 1 to 235 do
    aPG.PaletteEntries[i]:=rgb(i, i, i);

  //aPG.PaletteEntries[i]:=rgb(Random(256), Random(256), Random(256));
  *)

  PGImage1.PixelGraphic := v.aPG;
  //StartTimer.Enabled:=true;
  PaletteAnimater := true;

  Application.OnIdle := AppIdle;

end;

procedure TMDIChild.AppIdle(Sender: TObject; var Done: Boolean);
begin
  if (PaletteAnimater) then
  begin
    v.T1 := v.T1 + 1;
    animator(self);
    PGImage1.Invalidate;
    sleep(5);
  end;
end;

procedure TMDIChild.animator(Sender: TObject);
var
  i: Integer;
  PaletteEntry1: TRGB;

begin
  with PGImage1.PixelGraphic do
  begin
    BeginUpdate;
    try
      PaletteEntry1 := PaletteEntries[1];
      for i:= 1 to NumPaletteEntries-2 do
        PaletteEntries[i]:=PaletteEntries[i+1];
      PaletteEntries[NumPaletteEntries-1] := PaletteEntry1;
    finally
      EndUpdate;
    end;
  end;
end;

procedure TMDIChild.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := False;
  FormPaint;
end;

procedure TMDIChild.FormPaint;
begin
  if bInitialUpdate = True then
  begin
    PGImage1.ActionMode := amMoveImage;
    PGImage1.AutoSizeMaxWidth := Screen.Width - (Width - ClientWidth);
    PGImage1.AutoSizeMaxHeight := Screen.Height - (Height - ClientHeight);

    //v.aPG:=TPixelGraphic.Create;

    if bRectangleMode then
      PGImage1.ActionMode := amMoveResizeCreateSelection
    else
      PGImage1.ActionMode := amNone;

    if Application.Title = 'OPEN' then
    begin
      PGImage1.Filename := Caption;
      PGFileInfo(PGImage1.FileName, 0, iType, iSubType, iOptions, v.iWidth, v.iHeight, iColors, iBitsPerPixel, iGraphicCount);
      v.aPG.SetDimension(v.iWidth, v.iHeight, bc8);
    end
    else
    if Application.Title = 'NEW' then
    begin
      v.iWidth := 400;
      v.iHeight := 300;

      v.aPG.SetDimension(v.iWidth, v.iHeight, bc8);

      //PGImage1.PixelGraphic := v.aPG;

      Application.Title := 'atriatix ';
      Caption := 'atriatix: ';
      CaptionSave := Caption;
    end;

    (*
    v.aPG:=PGImage1.LendNoModifyPixelGraphic;
    v.aPG.Changed(Self);

    SavedPG:=TPixelGraphic.Create;
    SavedPG.SetDimension(v.iWidth, v.iHeight, bc8);

    SourcePG:=PGImage1.LendNoModifyPixelGraphic;

    ResultPG:=TPixelGraphic.Create;
    ResultPG.SetDimension(v.iWidth, v.iHeight, bc8);

    v.aPG.SetDimension(v.iWidth, v.iHeight, bc8);
    *)

    v.aPG := PGImage1.PixelGraphic;

    v.Width := v.iWidth;
    v.Height := v.iHeight;
    ResetCoordinates;
    pData := @v;

    v.dRedStep := 0.7;
    v.dGrnStep := 0.8;
    v.dBluStep := 0.9;

    //v.formula := 3;

    v.dFactor1 := 30;
    v.dFactor2 := 0.1;
    v.RandomFactor := 2.0;

    v.bInitialize := True;
    v.bSqrt := False;

    v.nCoefficients := 3;

    //CreateTList;

    UpdateGrafX;  // call this to automatically start-up

    bInitialUpdate := False;
    bColorControls := False;

  end;
end;

procedure TMDIChild.CreateTList;
var
  n, nx, ny: Integer;
begin
  v.redTList.Free;
  v.redTlist := Tlist.Create;

  v.grnTList.Free;
  v.grnTlist := Tlist.Create;

  v.bluTList.Free;
  v.bluTlist := Tlist.Create;

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

      v.redTList.Add(Pointer(0));
      v.grnTList.Add(Pointer(0));
      v.bluTList.Add(Pointer(0));

      //v.redTList[nx*ny+nx+ny] := Pointer(0);
      //v.grnTList[nx*ny+nx+ny] := Pointer(0);
      //v.bluTList[nx*ny+nx+ny] := Pointer(0);

      //redArray[nx, ny] := 0;
      //grnArray[nx, ny] := 0;
      //bluArray[nx, ny] := 0;

      inc(ny);
    end;
    inc(nx);
  end;


  (*
  for n := 0 to v.Width*v.Height-1 do
  begin
    Pointer(Bug) := v.redTList[n];
    i := SingVar;
  end;
  *)
end;

///////////////////
procedure TMDIChild.UpdateGrafX;
begin;

  if v.Abort_Draw = True then
    CaptionSave := Caption;

  v.aPG.SetDimension(v.Width, v.Height, bc8);
  v.aPG.Changed(Self);

  UpdateMenuItems(Self);
  Timer2.Enabled := True;

  v.T1 := 0;

  //Parameters1Update;

  TypeFractal;

  v.Abort_Draw := True;
  v.aPG.Changed(Self);

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
  //
end;

procedure TMDIChild.Timer2Timer(Sender: TObject);
begin
  v.aPG.Changed(Self);
  Application.ProcessMessages;
  //Caption := 'Busy... ' + Format ('%d', [v.Height - PYGlobal]);
  //Caption := 'Busy... ' + Format ('%d', [v.T1]);
  //Caption := 'Busy... ' + Format ('%d', [v.T1]);
  //Caption := Format ('%d    %d    %F3    %F4    %F4', [v.T1, v.nPoints, v.Lyapunov, v.zx, v.zy]);

  Caption := 'Busy... ' + Format ('%d', [v.T1]);
  v.T1 := v.T1+1;
  Application.HandleMessage;
end;

procedure TMDIChild.ResetCoordinates;
begin
  v.dMagnification := 0.23;
  v.dMag_new := v.dMagnification;

  v.CRMIN := -29;
  v.CRMAX :=  29;
  v.CIMIN := -29;
  v.CIMAX :=  29;

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
      Round(XYSize.RxWidth.Value), Round(XYSize.RxHeight.Value), bc8);

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

  //CreateTList;

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

procedure TMDIChild.Animate1Click(Sender: TObject);
begin
  Animate1.Checked := not Animate1.Checked;
  PaletteAnimater := Animate1.Checked;
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
    strParamName := strParamName + 'ifs';

    //Identify the filename and type as OutFile
    AssignFile(OutFile, strParamName);

    // Open and create the param file
    Rewrite(OutFile);

    // Write the program name and version #
    WriteLn(OutFile, constVersionNumber);

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

    if v.bLatoocarfian01 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bLatoocarfian02 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira_01 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bIFS_01 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bIFS_02 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bAT_01 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bAT_02 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bNone then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bLinear then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));

    if v.bSinusoidal then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bSpherical then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bSwirl then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bHorseshoe then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bPolar then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bBent then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bSqrt then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bBent then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));

    if v.bMira0101 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0102 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0103 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0104 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0105 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0106 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0107 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0108 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0109 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0110 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0111 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0112 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bMira0113 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));

    if v.bIFS0101 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bIFS0102 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bIFS0103 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bIFS0104 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bIFS0105 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bIFS0106 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bIFS0107 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));
    if v.bIFS0108 then WriteLn(OutFile, IntToStr(1)) else  WriteLn(OutFile, IntToStr(0));

    // write out the coefficiants
    i := 1;
    while (i <= 60) do
    begin
      WriteLn(OutFile, FloatToStr(v.af[i]));
      WriteLn(OutFile, FloatToStr(v.bf[i]));
      inc(i);
    end;

    CloseFile(OutFile);

    //ShowMessage('Parameter filename = ' + strParamName + ' len= ' + IntToStr(Length(strParamName)));
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

      //ResultPG := TPixelGraphic.Create;
      //ResultPG.SetDimension(v.Width, v.Height, bc8);

      (*
      ResultPG.StretchDrawRect(
          PGImage1.Left-27, PGImage1.Top-26,  // the 26 is for the toolbar
          v.Width, v.Height,
          PGImage1.SelectionLeft, PGImage1.SelectionTop,
          PGImage1.SelectionWidth, PGImage1.SelectionHeight,
          PGImage1.LendNoModifyPixelGraphic);
      *)

      v.aPG.StretchDrawRect(
          0, 0,
          v.Width, v.Height,
          PGImage1.SelectionLeft, PGImage1.SelectionTop,
          PGImage1.SelectionWidth, PGImage1.SelectionHeight,
          PGImage1.LendNoModifyPixelGraphic);

      //PGImage1.TakePixelGraphic(ResultPG);

      //v.aPG := ResultPG;
      v.aPG.Changed(Self);

      //Application.ProcessMessages;
        ///

      UpdateGrafX;

    end
    else begin
      ShowMessage('there is nothing selected');
    end;
  end;
end;



end.



