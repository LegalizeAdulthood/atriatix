unit formula;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,  Menus, TB97, PGraphic, ExtCtrls,
  ComCtrls, ChildWin, Main;

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
  pDataPointer = ^TInfo;

  procedure DrawFractal(pData: Pointer);
  procedure DrawPointArray;
  procedure initialize_data;
  procedure zero_init;
  procedure draw_points;
  procedure AdvanceXY;
  procedure Mira_01;
  procedure accumulate;
  procedure TListUpdate;
  procedure PixelMap;
  //procedure mask_the_color_linear;
	procedure coloring;
  procedure boundary_test;
  procedure boundary_test_2;
	procedure average_pixel;

  procedure None;
  procedure Linear;
  procedure Sinusoidal;
  procedure Spherical;
  procedure Swirl;
  procedure Horseshoe;
  procedure Polar;
  procedure Bent;
	procedure Inversion;

implementation

var
  v: pDataPointer;
  x, y, z: Double;
  x1, y1: Double;

  //x1, x2, x3, x4: double;
  //y1, y2, y3, y4: double;

  a: double;

  Pixel: TRGB;
  Pix: TRGB;

  LSum: double;
  tx, ty: Double;
  nx, ny: Integer;

  red, grn, blu, tmp: Integer;

  //xnew, ynew, znew: double;
  xnew: double;
  ynew: double;

  my_Index: double;
  my_Counter: integer;

  i, j: Integer;
  bSearching: Bool;

  // Computer search variables
  x_save, y_save: double;

  //rs, d2, dx, dy, dz, ri, df: double;

  // Scott Draves Flame variables
  r2, c1, c2, fx, fy: double;

  // Scott Draves Flame variables
  //fx, fy, r2, c1, c2, a: double;

  // Martins variable
  sign: double;

  // Mira variables
  AA, BB, W, xn: double;

  //x_save_advance, y_save_advance, z_save_advance: double;

  //bug: Integer;
  r, g, b: double;
  //tr, tg, tb: double;
  nsq: Integer;

  bug, color, kicker: Integer;

  //mag: double;
  //MyPixel: Integer;

procedure DrawFractal(pData: Pointer);
begin
  v := pData;

  if (v.bInitialize = true) then
    initialize_data
  else
    v.AA := v.C;

  zero_init;
  bSearching := True;

  while (v.Abort_Draw = False) do
  begin

    draw_points;

    (*
    //if (abs(x) * abs(y)) > 1e10 then
		if ((abs(x) > 1e+4) and (abs(y) > 1e+4)) or
       ((abs(x) < 1e-4) and (abs(y) < 1e-4)) then
    begin
      //initialize_data;
      //ShowMessage('start over');
      //zero_init;
      v.Abort_Draw := True;
    end
    else
    begin
      draw_points;
    end;
    *)

    Application.ProcessMessages;
  end;

  bug := 1;
end;

procedure boundary_test;
begin
	if (abs(x) > 1e4) or (abs(x) < 1e-4) then
  begin
  	x := 2*(random-0.5);
  end;

  if (abs(y) > 1e4) or (abs(y) < 1e-4) then
  begin
  	y := 2*(random-0.5);
  end;

  if (v.nPoints mod 1000 = 0) then
  begin
  	initialize_data;
  end;
end;

procedure boundary_test_2;
begin
	if ((abs(x) > 1e+4) and (abs(y) > 1e+4)) or
     ((abs(x) < 1e-4) and (abs(y) < 1e-4)) then
  begin
  	x := v.RandomFactor*(random-0.5);
    y := v.RandomFactor*(random-0.5);
    x := x*x+y*y;
  	x := v.RandomFactor*(random-0.5);
    //x := sin(constPI*x);
    //y := sin(constPI*y);
  end;

  (*
  if (abs(x) > 1e4) or (abs(y) > 1e4) then
  begin
  	x := v.RandomFactor*(random-0.5);
    y := v.RandomFactor*(random-0.5);
    x := x*x+y*y;
    y := -x;
    //x := sin(constPI*x);
    //y := sin(constPI*y);
  end;
  *)
end;

procedure initialize_data;
begin
  //ShowMessage('initialize');

  Randomize;
  v.Lyapunov := 0.0;
  v.T1 := 0;
  i := 1;
  while (i <= 60) do
  begin
    v.af[i] := v.RandomFactor*(Random - 0.5);    // 9.0
    v.bf[i] := v.RandomFactor*(Random - 0.5);
    inc(i);
  end;

  v.bInitialize := false;

  AA := v.RandomFactor*(random-0.5);

  a := cos(constPI/5.5195)/2.0;
  //AA := 4.0;

  v.C  := AA;
  v.AA := AA;
  v.AA_Initial := AA;
  W := 1;

  //x := v.RandomFactor*(v.RandomFactor*(random)-0.5);
  //y := v.RandomFactor*(v.RandomFactor*(random)-0.5);

  x := v.RandomFactor*(random-0.5);
  y := v.RandomFactor*(random-0.5);

  //x := -1.25;
  //y := 1.25;

  fx := x;
  fy := y;

  v.cx := x;
  v.cy := y;

  v.zx := x;
  v.zy := y;

  sign := 1;

end;

procedure zero_init;
begin

  v.T1 := 0;
  v.nPoints := 0;
  v.xtot := 0;
  v.ytot := 0;
  kicker := 0;
  LSum := 0;
  v.AA := v.AA_Initial;

  //x := 1e1;
  //y := 1e1;
  //z := 1e-1;

  if v.Width >= v.Height then
    nsq := v.Width
  else
    nsq := v.Height;

  x := v.cx;
  y := v.cy;
  W := 0;

  nx := 0;
  while nx < nsq do  // width
  begin
    ny := 0;
    while ny < nsq do  // height
    begin
      r := 0;
      g := 0;
      b := 0;

      if (v.bInvert) then
      begin
        red := 255;
        grn := 255;
        blu := 255;
      end
      else
      begin
        red := 0;
        grn := 0;
        blu := 0;
      end;

      Pixel := RGB(red, grn, blu);
      v.aPG.Bits[nx, ny] := Pixel;
      v.my_TList[nx*nsq+ny] := Pointer(50);

      inc(ny);
    end;
    inc(nx);
  end;
	MainForm.UpdateParameters;
end;

procedure draw_points;
begin
  // grain
  case v.nCoefficients of
    1: j := Round(Random * 1*20);
    2: j := Round(Random * 2*20);
    3: j := Round(Random * 3*20);
  end;

  if (j < 19) then
    j := 0
  else
  if (j < 39) then
    j := 19
  else
    j := 39;

  AdvanceXY;
  inc(v.nPoints);
end;

procedure AdvanceXY;
begin
  Mira_01;
  accumulate;

  //LET X=mod(XNEW,1)
  //LET Y=mod(YNEW,1)

  //x := xnew;
  //y := ynew;

end;

procedure accumulate;
begin

	x1 := x;
  y1 := y;

  //fx := 0;
  //fy := 0;

  if v.bSpherical then
  begin
		Spherical;
		x := fx;
  	y := fy;

	  //DrawPointArray;
  end;

	if v.bSwirl then
  begin
	  Swirl;
		x := fx;
  	y := fy;
	  //DrawPointArray;
  end;

  if v.bSinusoidal then
  begin
		Sinusoidal;
		x := fx;
  	y := fy;
	  //DrawPointArray;
  end;

  if v.bPolar then
  begin
	  Polar;
		x := fx;
  	y := fy;
	  //DrawPointArray;
  end;

  if v.bHorseShoe then
  begin
	  HorseShoe;
		x := fx;
  	y := fy;
	  //DrawPointArray;
  end;

	if v.bLinear then
  begin
  	Linear;
		x := fx;
  	y := fy;
	  //DrawPointArray;
  end;

  if v.bBent then
  begin
	  Bent;
		x := fx;
  	y := fy;
  end;

  if v.bNone then
  begin
  	None;
  end;

  DrawPointArray;

	x := x1;
  y := y1;

	//x := fx;
  //y := fy;

  fx := x;
  fy := y;

  if v.bInversion then
  begin
  	Inversion;
		x := fx;
  	y := fy;
	  DrawPointArray;
  end;

	x := x1;
  y := y1;
  

end;

procedure TListUpdate;
begin
  if (v.bSqrt = True) then
  begin
    my_Index := 2*sqrt(2*my_Counter);
  end
  else
  begin
    my_Index := my_Counter;
  end;

  color := Round(my_Index);

  if (color < 0) then
    color := 0;
    
  v.color := color;
end;

procedure PixelMap;
begin
  v.zx := x;
  v.zy := y;

  if x > v.xMin then
    tx := v.iWidth  * ((x - v.xMin)/(v.xMax - v.xMin))
  else
  begin
    tx := v.iWidth;
  end;

  if y > v.yMin then
    ty := v.iHeight * ((y - v.yMin)/(v.yMax - v.yMin))
  else
  begin
    ty := v.iHeight;
  end;

  nx := Round(tx);
  ny := Round(ty);
end;

procedure average_pixel;
var
  red_save, grn_save, blu_save: Integer;
begin

	red_save := red;
	grn_save := grn;
	blu_save := blu;

  r := GetRValue(Pix) and $FF;
  g := GetGValue(Pix) and $FF;;
  b := GetBValue(Pix) and $FF;

  if (r > red) then
  	red := Round((r+red_save)*0.5);

  if (g > grn) then
  	grn := Round((g+grn_save)*0.5);

  if (b > blu) then
  	blu := Round((b+blu_save)*0.5);

  if (red > 255) then
    red := 255;

  if (grn > 255) then
    grn := 255;

  if (blu > 255) then
    blu := 255;


  if (red < 0) then
    red := 0;

  if (grn < 0) then
    grn := 0;

  if (blu < 0) then
    blu := 0;

  Pixel := RGB(red, grn, blu);

  red := red_save;
  grn := grn_save;
  blu := blu_save;

end;

procedure DrawPointArray;
begin
  PixelMap;

  if (nx >= 0) and (nx < v.iWidth) and (ny >= 0) and (ny < v.iHeight) then
  begin
    begin

      //LSum := abs(0.5+x*x+y*y);

      //LSum := abs(arctan((1+x-x_save)/(1+y-y_save)));
			//LSum := sin(constPI*LSum+sin(constPI*LSum));

      //LSum := 10*(1+abs(sin(constPI*arctan((1+x-x_save)/(1+y-y_save)))));

      //LSum := abs(constPI*arctan((1+x-x_save)/(1+y-y_save)));

      LSum := abs(sin(constPI*((1+x-x_save)+(1+y-y_save))));
      //LSum := 1;

      Pointer(my_Counter) := v.my_TList[nx*(v.Width-1)+ny];
      my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
      v.my_TList[nx*(v.Width-1)+ny] := Pointer(my_Counter);

      TListUpdate;
      coloring;

      Pixel := RGB(red, grn, blu);
      v.aPG.Bits[nx, ny] := Pixel;

      (*
      red := Round(red*0.85);
      grn := Round(grn*0.85);
      blu := Round(blu*0.85);

		  Pixel := RGB(red, grn, blu);

  		if (nx+1 >= 0) and (nx+1 < v.iWidth) and (ny+1 >= 0) and (ny+1 < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx+1)*(v.Width-1)+(ny+1)];
    		//if (my_counter <= 50) then

				Pix := v.aPG.Bits[nx+1, ny+1];
				average_pixel;
        v.aPG.Bits[nx+1, ny+1] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx+1)*(v.Width-1)+(ny+1)] := Pointer(my_Counter);
  		end;

  		if (nx-1 >= 0) and (nx-1 < v.iWidth) and (ny-1 >= 0) and (ny-1 < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx-1)*(v.Width-1)+(ny+1)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx-1, ny-1];
				average_pixel;
        v.aPG.Bits[nx-1, ny-1] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx-1)*(v.Width-1)+(ny-1)] := Pointer(my_Counter);
  		end;

  		if (nx+1 >= 0) and (nx+1 < v.iWidth) and (ny-1 >= 0) and (ny-1 < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx+1)*(v.Width-1)+(ny-1)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx+1, ny-1];
				average_pixel;
        v.aPG.Bits[nx+1, ny-1] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx+1)*(v.Width-1)+(ny-1)] := Pointer(my_Counter);
  		end;

  		if (nx-1 >= 0) and (nx-1 < v.iWidth) and (ny+1 >= 0) and (ny+1 < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx-1)*(v.Width-1)+(ny+1)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx-1, ny+1];
				average_pixel;
        v.aPG.Bits[nx-1, ny+1] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx-1)*(v.Width-1)+(ny+1)] := Pointer(my_Counter);
  		end;

  		/////////////

  		if (nx+0 >= 0) and (nx+0 < v.iWidth) and (ny+1 >= 0) and (ny+1 < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx+0)*(v.Width-1)+(ny+1)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx, ny+1];
				average_pixel;
        v.aPG.Bits[nx, ny+1] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx)*(v.Width-1)+(ny+1)] := Pointer(my_Counter);
  		end;

  		if (nx >= 0) and (nx < v.iWidth) and (ny-1 >= 0) and (ny-1 < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx)*(v.Width-1)+(ny-1)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx, ny-1];
				average_pixel;
        v.aPG.Bits[nx, ny-1] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx)*(v.Width-1)+(ny-1)] := Pointer(my_Counter);
  		end;

  		if (nx+1 >= 0) and (nx+1 < v.iWidth) and (ny >= 0) and (ny < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx+1)*(v.Width-1)+(ny)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx+1, ny];
				average_pixel;
        v.aPG.Bits[nx+1, ny] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx+1)*(v.Width-1)+(ny)] := Pointer(my_Counter);
  		end;

  		if (nx-1 >= 0) and (nx-1 < v.iWidth) and (ny >= 0) and (ny < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx-1)*(v.Width-1)+(ny)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx-1, ny];
				average_pixel;
        v.aPG.Bits[nx-1, ny] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx-1)*(v.Width-1)+(ny)] := Pointer(my_Counter);
  		end;

  		/////////////

  		red := Round(red*0.85);
  		grn := Round(grn*0.85);
  		blu := Round(blu*0.85);

  		if (nx >= 0) and (nx < v.iWidth) and (ny+2 >= 0) and (ny+2 < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx)*(v.Width-1)+(ny+2)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx, ny+2];
				average_pixel;
        v.aPG.Bits[nx, ny+2] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx+1)*(v.Width-1)+(ny+2)] := Pointer(my_Counter);
  		end;

  		if (nx >= 0) and (nx < v.iWidth) and (ny-2 >= 0) and (ny-2 < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx)*(v.Width-1)+(ny-2)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx, ny-2];
				average_pixel;
        v.aPG.Bits[nx, ny-2] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx)*(v.Width-1)+(ny-2)] := Pointer(my_Counter);
  		end;

  		if (nx+2 >= 0) and (nx+2 < v.iWidth) and (ny >= 0) and (ny < v.iHeight) then
      begin
    		Pointer(my_Counter) := v.my_TList[(nx+2)*(v.Width-1)+(ny)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx+2, ny];
				average_pixel;
        v.aPG.Bits[nx+2, ny] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx+2)*(v.Width-1)+(ny)] := Pointer(my_Counter);
  		end;

  		if (nx-2 >= 0) and (nx-2 < v.iWidth) and (ny >= 0) and (ny < v.iHeight) then
  		begin
    		Pointer(my_Counter) := v.my_TList[(nx-2)*(v.Width-1)+(ny)];
    		//if (my_counter <= 50) then

        Pix := v.aPG.Bits[nx-2, ny];
				average_pixel;
        v.aPG.Bits[nx-2, ny] := Pixel;

    		my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
    		v.my_TList[(nx-2)*(v.Width-1)+(ny)] := Pointer(my_Counter);
  		end;

      *)

    end;
  end;

end;

procedure coloring;
begin
  if (color > 768) then
    color := 768;

  //color := 500;

  if (color < 0) then
    ShowMessage('bug 2');

  if (color < 256) then
    red := color
  else
    red := 255;

  if (color < 512) and (color > 255) then
  begin
    grn := color - 256;
  end
  else
  begin
    if (color >= 512) then
      grn := 255
    else
      grn := 0;
  end;

  if (color <= 768) and (color > 511) then
    blu := color - 512
  else
  begin
    if (color >= 768) then
      blu := 255
    else
      blu := 0;
  end;

  if (blu > 255) then
    blu := 255;

  tmp := Round((red+grn+blu)*0.33);
  red := tmp + Round(v.dRedStep);
  grn := tmp + Round(v.dGrnStep);
  blu := tmp + Round(v.dBluStep);

  if (red > 255) then
    red := 255;

  if (grn > 255) then
    grn := 255;

  if (blu > 255) then
    blu := 255;

  if (red < 0) then
    red := 0;

  if (grn < 0) then
    grn := 0;

  if (blu < 0) then
    blu := 0;

  (*
  if ((red and $1FF) > $FF) then
    red := not red and $FF; // Invert the color

  if ((grn and $1FF) > $FF) then
    grn := not grn and $FF; // Invert the color

  if ((blu and $1FF) > $FF) then
    blu := not blu and $FF; // Invert the color
  *)

  // try swapping colors around
  //case (v.T1 mod 3) of

  (*
  if (abs(x_save-y_save) > abs(x-y)) then
    sign := 1
  else
    sign := -1;
  *)

  if (v.bColorMix = true) then
  begin

  case (kicker mod 3) of
  0:  begin
      end;

  1:  begin
        tmp := red;
        red := grn;
        grn := blu;
        blu := tmp;
      end;

   2: begin
        tmp := grn;
        grn := red;
        red := tmp;
      end;
  end;

  end;

  ////////////////////
  if (red > 255) or (red < 0) then
    ShowMessage('red bug 1');

  if (grn > 255) or (grn < 0) then
    ShowMessage('grn bug 1');

  if (blu > 255) or (blu < 0) then
    ShowMessage('blu bug 1');

  red := red and $FF;
  grn := grn and $FF;
  blu := blu and $FF;

  if v.bInvert = True then
  begin
    // invert the color
    red := not red and $FF;
    grn := not grn and $FF;
    blu := not blu and $FF;
  end;

  //red := 255;
  //grn := 255;
  //blu := 255;

end;

procedure Mira_01;
begin
  if (v.nPoints mod 1000 = 0) then
  begin
    if (v.bModulas = true) then
    begin
      v.AA := V.AA - 0.0002*sin(V.AA);
	    //MainForm.UpdateParameters;
    end;

    kicker := kicker + 1;
    //initialize_data;
  end;

  if (v.bExpansion = true) then
    x := x - 1/sqrt(x*x+y*y)*(x * sign)/20000;

  AA := v.AA;
  BB := v.BB;

  // Gumowski / Mira
  (*
  z := x;
  x := BB*y+W;
  U := x*x;
  W := AA*x + (1 - AA)*((2*U)/(1+U));
  y := W - z;
  *)

  // Gumowski / Mira
  // X(n+1) :=   by + F(x);
  // y(n+1) :=   -x + F(X(n+1));
  // F(x)   :=  AA*x + (1-AA)*x*x) / (1 + x*x);

  // used by Gumowski / Mira / Martin

  (*
  if x >= 0 then
    sign := constPI
  else
    sign := -constPI;
  *)

  if x >= 0 then
    sign := 1
  else
    sign := -1;

  x_save := x;
  y_save := y;

  case v.formula of
    1: begin
				(*
         x := x - (x*x)/10+(AA - x*x)*(x * sign)/2000;
         z := x;
         x := BB*y + W;
         W := AA*x - 2*x*x*(1 - AA) / (1 + x*x);
         y := W - z;
        *)

        (*
         x := x - sign/1000;
         z := x;
         x := BB*y + W;
         W := AA*x - 2*x*x*(1 - AA) / (1 + x*x);
         y := W - z;
         *)

         z := x;
         x := BB*y + W;
         W := AA*x - (1 - AA)*2*x*x / (1 + x*x);
         y := W - z;

       end;

    2: begin
         z := x;
         x := BB*y+W;
         W := const2PI*sign*AA + constPI + sin(constPI+sin(constPI+x));
         y := W - z;
       end;

    3: begin
         //x    := x - (x * sign)/120;
         xnew := AA * x + y + sign*sqrt(abs(sqrt(abs((x*(constPI*AA))))));
         y    := AA - x;
         x    := xnew;
       end;

    4: begin
         z := x;
         x := BB*y+W;
         W := -0.05*AA*x + (constPI-AA*x)*(AA*x*x)/(1+x*x);
         y := W - z;
       end;

    5: begin
         z := x;
         x := BB*y+W;
         W := sign*AA + AA*x*sin(constPI+x); // this is cool
         y := W - z;
       end;

    6: begin
         z := x;
         x := BB*y+W;
         W := (AA*x) + sign*((1 - AA)*(2*x*x))/(1+x*x) + sin(x);
         y := W - z;
       end;

    7: begin
         z := x;
         x := BB*y+W;
         W := sign*AA + sin(x) * sin(constPI+x); // this is cool
         y := W - z;
       end;

    8: begin
         z := x;
         x := BB*y+W;
         W := (AA*x) + (sign - AA)*(5*x*x)/(4 + x*x) + sin(sin(x));
         y := W - z;
       end;

    9: begin
         z := x;
         x := BB*y+W;
         W := sign*AA + AA + (1 - AA)*((2*x*x)/(constPI+x*x)) + sin(constPI+x);
         y := W - z;
       end;

    10: begin
         z := x;
         x := BB*y+W;
         W := sign*AA+sin(x)+AA;
         y := W - z;
       end;

    11: begin
         z := x;
         x := BB*y+W;
         W := sign*AA*(sin(x)+AA);
         y := W - z;
       end;

    12: begin
         // un - 01
         xn :=  BB * y + AA * x  + 2 * x * x / (1 + x * x + y * y + sin(x));
         y  := -x + AA * xn + 2 * xn * xn * (1 - AA) / (1 + xn * xn + sin(xn));
         x  := xn;
    	  end;

    13: begin
         // un - 01
         xn :=  BB * y + AA * x + x * x * (1 - AA) / (1 + x * x);
         y  := -x + AA * xn + y * xn * (1 - AA) / (1 +  xn * xn);
         x  := xn;
        end;

		14: begin
         // un
         xn :=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x*x);
         y  := -x + AA * xn + 2 * y * xn * (1 - AA) / (1 +  xn*xn);
         x  := xn;
        end;

    15: begin
         // 5.)
         xn :=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x*x);
         y  := -x + AA * xn + 2 * y * xn * (1 - AA) / (1 + y * xn);
         x  := xn;
        end;

    16: begin
        // 6.)
        xn := BB*y + AA * x + 2 * x*x * (1 - AA) /(1 + x*x);
        y  := -x + AA * xn + 2 * y * y * (1 - AA) / (1 + y * y);
        x  := xn;

         //xn := - x/2 + y  + 100*sin((x/5))/sqrt(abs(x*x + y*y));  //

         //y :=  -x;
         //x  := xn;

         //z := x;
         //x := BB*y+W;
         //W := AA*x + sign*((constPI - AA)*x*x)/(1 + x*x);
         //y := W - z;
         //boundary_test;

        end;

    17: begin
        //7:
        xn :=  BB * y + AA * x + 2 * x*x * (1 - AA) / (1 + x*x + y*y);
        y  :=  -x + AA * xn  + 2 * xn*xn * (1 - AA) / (1 + 2*xn*xn);
        x  := xn;
        end;

    18: begin
        // 8.)
        xn :=  BB * y + AA * x  + 2 * x * x / (1 + x * x + y * y);
        y  := -x + AA * xn + 2 * xn * xn * (1 - AA) / (1 + xn * xn);
        x  := xn;
        end;

    19: begin
        // 9.)
        xn :=  BB * y + AA * x + 2 * x*x * (1 - AA) / (1 + x*x);
        y  := -x + AA * xn + AA * xn*xn * (1 - AA) / (1 + xn *xn);
        x  := xn;
        end;

    20: begin
        // plum08
        x  := x + (x * sign)/50000;
        xn := BB * y+AA * x + 2*x*x * ((1 - AA) / (1 + x*x));
        y  := -x + AA*xn + 2*xn*xn * ((1 - AA) / (1 + xn*xn));
        x  := xn;
        end;

    21: begin
        x  := x + (x * sign)/50000;
        xn := BB * y + AA * x + 2*x*x * ((1 - AA) / (1 + x*x));
        y := -x + AA * xn + AA * 2*xn*xn * ((1 - AA) / (1 + xn*xn));
        x := xn;
        end;

    22: begin
        x := x - 1/sqrt(x*x+y*y)*(x * sign)/20000;
        z := x;
        x := BB*y + W;
        W := AA*x - 20*AA*x*x*(1 - AA) / (1 + x*x+sin(1+x));
        y := W - z;
        end;

    23: begin
        xn := -constPI / 2.0 * x + y + 100. * x / (x * x + 2.0);
        y :=  -x;
        x  := xn;
        boundary_test;
        end;

    24: begin
        xn := -x/2 + y + 100. * x / (x * x + 1.0);
        y  :=  -x;
        x  := xn;
        boundary_test;
        end;

    25: begin
        xn := -x/2 + y + sign*((x - AA) * (x + y))/(x*x + y*y);
        y  :=  -x;
        x  := xn;
        boundary_test;
        end;

    26: begin
        xn := -x/2 + y + sign * 10 * x  / (x * x + 1);
        y  :=  -x;
        x  := xn;
        boundary_test;
        end;

    27: begin
        xn := -x/2 + y + sign * (2 - constPI * x)  / (x * x + 2);
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    28: begin
        xn := -x/8 + y + sign * (2 - constPI * x)  / (x * x + 2);
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    29: begin
        xn := -sign*x/2 + y + 100 * (x - y)*(constPI - sin(x))*AA  / (x*x + y*y);
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    30: begin
        xn := -x/2 + y + 100 * (x - y)  / (x * x + y * y );  // z113
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    31: begin
        xn := -x/2 + y + 100 * ((x - y)/2 + sin(x - y))  / (x * x + y * y );
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    32: begin
        //xn := x/2 + y  + y/2;
        xn := x/2 + y  + (1 - x)/abs(x*x - y);    // z107
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    33: begin
        xn := x/2 + y  + (sign - x)/abs(x*x + y);  // z108
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    34: begin
        xn := x/2 + y  + 20*(sign + x)/(sqrt(1+abs(x*x + y*y)));   // z109
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    35: begin
        xn := x/2 + y  + (50*sign - x)/sqrt(abs(x*x + y*y));   // z110
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    36: begin
        xn := -x/3 + y  + 10*(1 - x)/sqrt(abs(x*x + y*y));   // S - letter
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    37: begin
        xn := x/2 + y + AA*10*abs(x - y)/(x+abs(x*x + y*y)/10); // z111
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    38: begin
        xn := -x/1.1 + y  + 10*abs(x - y)/(abs(x*x/10 + y*y/10)); // z111
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    39: begin
        xn := x/1.2 + y  + 100*abs(x - y)/abs(x*x + y*y);  // z112
        y  := -x;
        x  := xn;
        boundary_test;
        end;

    40: begin
        xn := -x/1.01 + y  + 100*sin(constPI+x)/abs(x*x + y*y);  // z113
        y  := -x;
        x  := xn;
        boundary_test;
        end;


  (*
  	//The following 15 formulas are from Michael Peters Plankton Explorer program

    {formula #1}

    x = -0.1
    y =  0.0

    p = { a random value between -1 and 1.
          For some formulas it must be between -1 and 0,
          but a value = 0 is not allowed }

    a = { a value that is usually = 1.0.
          With values above 1.0, most attractors 'explode',
          with values below 1.0, most attractors 'implode'.
          Try slight variations between 0.99 and 1.01 }

    loop begin

   1: xn =  a * y + p * x  + 2 * x * x * (1 - p) / (1 + x * x)
      yn = -x + p * xn + 2 * xn * xn * (1 - p) / (1 + xn * xn)

   2: xn =  a * y + p * x + 2 * sqr(x) * (1 - p) / (1 + sqr(x))
      yn = -x + p * xn + 2 * y * xn * (1 - p) / (1 + sqr(xn))

   3: xn:=  a * y + p * x + 2 * sqr(x) * (1 - p) / (1 + sqr(x));
      yn:= -x + p * xn + 2 * sqr(xn) * (sqrt(abs(y)) - p) / (1 + sqr(xn));

   4: xn =  a * y + p * x + 2 * sqr(x) * (1 - p) / (1 + sqr(x))
      yn = -x + p * xn + 2 * sqr(xn) * (1 - p) / (1 + y * xn)

   5: xn =  a * y + p * x + 2 * sqr(x) * (1 - p) / (1 + sqr(x))
      yn = -x + p * xn + 2 * y * xn * (1 - p) / (1 + y * xn)

   6: xn =  a * y + p * x + 2 * sqr(x) * (1 - p) / (1 + sqr(x))
      yn = -x + p * xn + 2 * sqr(y) * (1 - p) / (1 + sqr(y))

   7: xn =  a * y + p * x + 2 * sqr(x) * (1 - p) / (1 + sqr(x))
      yn = -x + p * xn + 2 * sqr(xn) * (y - p) / (1 + sqr(xn))

   8: xn =  a * y + p * x + 2 * sqr(x) / (1 + sqr(x) + sqr(y))
      yn = -x + p * xn + 2 * sqr(xn) * (1 - p) / (1 + sqr(xn))

   9: xn =  a * y + p * x + 2 * sqr(x) * (1 - p) / (1 + sqr(x))
      yn = -x + p * xn + p * sqr(xn) * (1 - p) / (1 + sqr(xn)) + sqr(p)

  10: xn =  a * y + p * x + 2 * sqr(x) * (1 - p) / (1 + sqr(x))
      yn = -x + p * xn + p * sqr(xn) * (1 - p) / (1 + sqr(xn)) + p

  11: xn =  a * y + p * x + 2 * sqr(x) / (1 + sqr(xn) + sqr(y))
      yn = -x + p * xn + p * sqr(xn) * (1 - p) / (1 + sqr(xn)) + p

  12: xn =  a * y + p * x + 2 * sqr(x) * (1 - p) / (1 + sqr(x))
      yn = -x + p * xn + p * y * xn * (1 - p) / (1 + sqr(xn)) + p

  13: xn =  a * y + p * x + 2 * sqr(p) * (1 - x) / (1 + sqr(x))
      yn = -x + p * xn + 2 * sqr(xn) * (1 - p) / (1 + sqr(xn))

  14: xn =  a * y + p * x + 2 * sqr(p) * (1 - x) / (1 + sqr(x))
      yn = -x + p * xn + p * sqr(xn) * (1 - p) / (1 + sqr(xn)) + p

  15: xn =  a * y + p * x + 2 * sqr(x) * (1 - p) / (1 + sqr(x))
      yn = -x + p * xn + 2 * sqr(xn) * (y - p) / (1 + sqr(xn)) + p

  Positive values for p are allowed for formula 2,5,8,12,13,14.

  *)

    41: begin
        xn :=  BB * y + AA * x  + 2 * x * x * (1 - AA) / (1 + x * x);
        y  := -x + BB * xn + 2 * xn * xn * (1 - AA) / (1 + xn * xn);
        x  := xn;
        end;

    42: begin
        xn :=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x * x);
        y  := -x + AA * xn + 2 * y * xn * (1 - AA) / (1 + xn*xn);
        x  := xn;
        end;

    43: begin
        xn:=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x * x);
        y := -x + AA * xn + 2 * xn * xn * (sqrt(abs(y)) - AA) / (1 + xn * xn);
        x  := xn;
        end;

    44: begin
        xn :=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x * x);
        y  := -x + AA * xn + 2 * xn * xn * (1 - AA) / (1 + y * xn);
        x  := xn;
        end;

    45: begin
        xn :=  BB * y + AA * x + 2 *  x * x * (1 - AA) / (1 + x * x);
        y  := -x + AA * xn + 2 * y * xn * (1 - AA) / (1 + y * xn);
        x  := xn;
        end;

    46: begin
        xn :=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x * x);
        y  := -x + AA * xn + 2 * y * y * (1 - AA) / (1 + y * y);
        x  := xn;
        end;

    47: begin
        xn :=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x * x);
        y  := -x + AA * xn + 2 * xn * xn * (y - AA) / (1 + xn * xn);
        x  := xn;
        end;

    48: begin
        xn :=  BB * y + AA * x + 2 * x * x / (1 + x * x + y * y);
        y  := -x + AA * xn + 2 * xn * xn * (1 - AA) / (1 + xn * xn);
        x  := xn;
        end;

    49: begin
        xn :=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x * x);
        y  := -x + AA * xn + AA * xn * xn * (1 - AA) / (1 + xn * xn) + AA * AA;
        x  := xn;
        end;

    50: begin
        xn :=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x * x);
        y  := -x + AA * xn + AA * xn * xn * (1 - AA) / (1 + xn * xn) + AA;
        x  := xn;
        end;

    51: begin
        xn :=  BB * y + AA * x + 2 * x * x / (1 + xn * xn + y * y);
        y  := -x + AA * xn + AA * xn * xn * (1 - AA) / (1 + xn * xn) + AA;
        x  := xn;
        end;

    52: begin
        xn :=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x * x);
        y  := -x + AA * xn + AA * y * xn * (1 - AA) / (1 + xn * xn) + AA;
        x  := xn;
        end;

    53: begin
        xn :=  BB * y + AA * x + 2 * AA * AA * (1 - x) / (1 + x * x);
        y  := -x + AA * xn + 2 * xn * xn * (1 - AA) / (1 + xn * xn);
        x  := xn;
        end;

    54: begin
        xn :=  BB * y + AA * x + 2 * AA * AA * (1 - x) / (1 + x * x);
        y  := -x + AA * xn + AA * xn * xn * (1 - AA) / (1 + xn * xn) + AA;
        x  := xn;
        end;

    55: begin
        xn :=  BB * y + AA * x + 2 * x * x * (1 - AA) / (1 + x * x);
        y  := -x + AA * xn + 2 * xn * xn * (y - AA) / (1 + xn * xn) + AA;
        x  := xn;
        end;

    60: begin

         	z := x;
			   	x := BB*y+W;

         	//x := x + x/20000*sin(x);
         	//W := AA*x + 0.2*(sin(4*constPI*x + (4*constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

         	//x := x + x/20000*sin(x);
         	//W := AA*x + 0.2*(sin(4*constPI*x + (4*constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

         	//x := x + x/20000*sin(x);
         	//W := AA*x + 0.5*(sin(2*constPI*x + (2*constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

         	//x := x + x/700*sin(x);
         	//W := AA*x + 0.6*(sin(2*constPI*x + (2*constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

  			 	//x := x + x/400*sin(x);
  			 	//W := AA*x + 0.2*(sin(constPI*x + (constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

  			 	//W := AA*x - 0.3*sin(x + sin(x)) + 2*(1 - AA)*(1 - x*x)/((1 + x*x))*sign;

  			 	//W := (1-AA*x) + (sin(2*x + sin(2*x + sin(2*x)) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

			  	W := (1-AA*x) + (sin(constPI*x + sin(constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

			  	//W := AA*x + (sin(x + sin(x - (1 - AA)*(x*x))))/(1 + x*x)*sign;

			  	//W := sign*(AA*x + (1 - AA)*(2*x*x))/(1+x*x) + sin(AA+x);

			  	//W := -0.05*v.af[1]*x + (constPI-v.af[2]*x)*(v.af[3]*x*x)/(1+x*x);

			  	//W := -0.05*AA*x + (constPI-AA*x)*(AA*x*x)/(1+x*x);

			  	//W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
			    //                     v.af[2]*x*sin(v.af[1]+x) +
			      //                   v.af[2]*x*sin(v.af[1]+x));

			  	//W := sign*AA + AA*x*sin(constPI+x); // this is cool
			  	//W := sign*AA + sin(x) * sin(constPI+x); // this is cool
			  	//W := sign*AA + sin(1/x); // this is cool

			  	//AA := constPI*AA;
			  	//W := const2PI*sign*AA + constPI + sin(constPI+sin(constPI+x)); // this is cool
			  	//W := const2PI*sign*AA + constPI + cos(x) + sin(constPI+sin(constPI+x)); // this is cool

			  	//W := AA * sign * (const2PI - x)  + sin(constPI - x); // this is cool

    			y := W - z;

	    	end;

    61: begin

         	z := x;
			   	x := BB*y+W;

				  //W := AA*x + ((1 - AA)*(2*x*x))/(1+x*x);
				  //W := (AA*x) + sign*((1 - AA)*(2*x*x))/(1+x*x);

				  W := (AA*x) + sign*(1-AA)*v.af[1]*(sin(x+sin(x)));

          //W := sign*(AA*x*sin(v.af[1]+x) + v.af[2]*x*sin(v.af[3]+x) + v.af[4]*x*sin(v.af[5]+x));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := sign*AA*x*sin(v.af[3]+x) + AA*x*sin(v.af[5]+x);

          //W :=  sign*((1 - AA)*(2*x*x))/(1+x*x);

    			//W :=        (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

    			y := W - z;

			end;

    62: begin

         	z := x;
			   	x := BB*y+W;

    			//W :=  (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := AA*x + ((1 - AA)*(2*x*x))/(1+x*x);

				  W := sign*AA*sin(v.af[3]*x) + AA*sin(v.af[5]*x); // 62

				  //W := sign*AA*sin(v.af[1]*x+sin(v.af[2]*x)) + AA*sin(v.af[3]*x+sin(v.af[4]*x)); // 63

				  //W := sign*AA*sin(v.af[1]*x)+AA*sin(v.af[2]*x);

				  //W := sign*AA*sin(v.af[1]*x)+AA*sin(v.af[2]*x+sin(v.af[3]*x)); // 64

				  //W := (AA*x) + sign*((1 - AA)*(2*x*x))/(1+x*x);

				  //W := (AA*x) + sin((1-AA)+(sin(x+sin(1+x))));

         	//x := x + x/20000*sin(x);
         	//W := AA*x + 0.2*(sin(4*constPI*x + (4*constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

          //W := sign*(AA*x*sin(v.af[1]+x) + v.af[2]*x*sin(v.af[3]+x) + v.af[4]*x*sin(v.af[5]+x));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := sign*AA*x*sin(v.af[3]+x) + AA*x*sin(v.af[5]+x);

          //W :=  sign*((1 - AA)*(2*x*x))/(1+x*x);

    			//W :=        (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

    			y := W - z;
			end;

    63: begin

         	z := x;
			   	x := BB*y+W;

    			//W :=  (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := AA*x + ((1 - AA)*(2*x*x))/(1+x*x);

				  //W := sign*AA*sin(v.af[3]*x) + AA*sin(v.af[5]*x); // OK

				  W := sign*AA*sin(v.af[1]*x+sin(v.af[2]*x)) + AA*sin(v.af[3]*x+sin(v.af[4]*x)); // OK

				  //W := sign*AA*sin(v.af[1]*x)+AA*sin(v.af[2]*x);

				  //W := sign*AA*sin(v.af[1]*x)+AA*sin(v.af[2]*x+sin(v.af[3]*x));

				  //W := (AA*x) + sign*((1 - AA)*(2*x*x))/(1+x*x);

				  //W := (AA*x) + sin((1-AA)+(sin(x+sin(1+x))));

         	//x := x + x/20000*sin(x);
         	//W := AA*x + 0.2*(sin(4*constPI*x + (4*constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

          //W := sign*(AA*x*sin(v.af[1]+x) + v.af[2]*x*sin(v.af[3]+x) + v.af[4]*x*sin(v.af[5]+x));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := sign*AA*x*sin(v.af[3]+x) + AA*x*sin(v.af[5]+x);

          //W :=  sign*((1 - AA)*(2*x*x))/(1+x*x);

    			//W :=        (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

    			y := W - z;
			end;

    64: begin

         	z := x;
			   	x := BB*y+W;

    			//W :=  (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := AA*x + ((1 - AA)*(2*x*x))/(1+x*x);

				  //W := sign*AA*sin(v.af[3]*x) + AA*sin(v.af[5]*x); // OK
				  //W := sign*AA*sin(v.af[1]*x+sin(v.af[2]*x)) + AA*sin(v.af[3]*x+sin(v.af[4]*x)); // OK

				  //W := sign*AA*sin(v.af[1]*x)+AA*sin(v.af[2]*x);

				  W := sign*AA*sin(v.af[1]*x)+AA*sin(v.af[2]*x+sin(v.af[3]*x)); // 64

				  //W := (AA*x) + sign*((1 - AA)*(2*x*x))/(1+x*x);

				  //W := (AA*x) + sin((1-AA)+(sin(x+sin(1+x))));

         	//x := x + x/20000*sin(x);
         	//W := AA*x + 0.2*(sin(4*constPI*x + (4*constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

          //W := sign*(AA*x*sin(v.af[1]+x) + v.af[2]*x*sin(v.af[3]+x) + v.af[4]*x*sin(v.af[5]+x));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := sign*AA*x*sin(v.af[3]+x) + AA*x*sin(v.af[5]+x);

          //W :=  sign*((1 - AA)*(2*x*x))/(1+x*x);

    			//W :=        (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

    			y := W - z;

			end;

    65: begin

         	z := x;
			   	x := BB*y+W;

    			//W :=  (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := AA*x + ((1 - AA)*(2*x*x))/(1+x*x);

				  //W := sign*AA*sin(v.af[3]*x) + AA*sin(v.af[5]*x); // OK
				  //W := sign*AA*sin(v.af[1]*x+sin(v.af[2]*x)) + AA*sin(v.af[3]*x+sin(v.af[4]*x)); // OK

				  //W := sign*AA*sin(v.af[1]*x)+AA*sin(v.af[2]*x);

				  //W := sign*AA*sin(v.af[1]*x)+AA*sin(v.af[2]*x+sin(v.af[3]*x)); 64

				  W := sign*AA*sin(v.af[1]*x)+sign*AA*sin(v.af[2]*x+sign*sin(v.af[3]*x));

				  //W := (AA*x) + sign*((1 - AA)*(2*x*x))/(1+x*x);

				  //W := (AA*x) + sin((1-AA)+(sin(x+sin(1+x))));

         	//x := x + x/20000*sin(x);
         	//W := AA*x + 0.2*(sin(4*constPI*x + (4*constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

          //W := sign*(AA*x*sin(v.af[1]+x) + v.af[2]*x*sin(v.af[3]+x) + v.af[4]*x*sin(v.af[5]+x));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := sign*AA*x*sin(v.af[3]+x) + AA*x*sin(v.af[5]+x);

          //W :=  sign*((1 - AA)*(2*x*x))/(1+x*x);

    			//W :=        (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

    			y := W - z;
			end;

    66: begin

         	z := x;
			   	x := BB*y+W;

    			//W :=  (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := AA*x + ((1 - AA)*(2*x*x))/(1+x*x);

				  //W := sign*AA*sin(v.af[3]*x) + AA*sin(v.af[5]*x); // OK
				  //W := sign*AA*sin(v.af[1]*x+sin(v.af[2]*x)) + AA*sin(v.af[3]*x+sin(v.af[4]*x)); // OK

				  //W := 0.5*sign*AA*abs(sin(y+sin(y))+sin(x+sin(x))); // shtoyata

				  //W := 0.5*AA*sign*(abs(y+x));  // flare

				  W := 0.5*AA*sign*(abs(y+x));

				  //W := sign*AA*sin(v.af[1]*x)+AA*sin(v.af[2]*x+sin(v.af[3]*x)); // 64

				  //W := (AA*x) + sign*((1 - AA)*(2*x*x))/(1+x*x);

				  //W := (AA*x) + sin((1-AA)+(sin(x+sin(1+x))));

         	//x := x + x/20000*sin(x);
         	//W := AA*x + 0.2*(sin(4*constPI*x + (4*constPI*x) - (1 - AA)*(x*x)))/(1 + x*x)*sign;

          //W := sign*(AA*x*sin(v.af[1]+x) + v.af[2]*x*sin(v.af[3]+x) + v.af[4]*x*sin(v.af[5]+x));

			    //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
      			//                   v.af[2]*x*sin(v.af[1]+x) +
            	//		             v.af[2]*x*sin(v.af[1]+x));

				  //W := sign*AA*x*sin(v.af[3]+x) + AA*x*sin(v.af[5]+x);

          //W :=  sign*((1 - AA)*(2*x*x))/(1+x*x);

    			//W :=        (sign*(v.af[1]*x*sin(v.af[4]+x) +
            //           v.af[2]*x*sin(v.af[5]+x) +
              //         v.af[4]*x*sin(v.af[7]+x)));

    			y := W - z;

			end;

    70: begin
	  		  //z := x*v.af[1 + j] + y*v.af[2 + j] + v.af[3 + j];
  	  		//y := x*v.af[4 + j] + y*v.af[5 + j] + v.af[6 + j];
          //x := z;

			    //xnew := (x*(AA+v.af[1 + j]) + y*(AA+v.af[3 + j]) + sign*(AA+v.af[5+j]));
			    //ynew := (x*(AA+v.af[2 + j]) + y*(AA+v.af[4 + j]) + sign*(AA+v.af[6+j]));

			    xnew := x*(v.af[1 + j] + y*(v.af[3 + j]) + (v.af[5+j]));
			    ynew := x*(v.af[2 + j] + y*(v.af[4 + j]) + (v.af[6+j]));

          x := xnew;
          y := ynew;

    		end;

    71: begin
			    z := x*v.af[1 + j] + y*v.af[1 + j] + v.af[5 + j] + sin(x) - sin(y);
    			y := x*v.af[2 + j] + y*v.af[2 + j] + v.af[6 + j] + sin(x) - sin(y);
          x := z;
    		end;

    72: begin
         	z := x;
			   	x := BB*y+W;
	  		  W := AA*sign*(x+y);
    			y := W - z;
    		end;

	end;

  // gm-03
  //W := (AA*x) + sign*((1 - AA)*(2*x*x))/(1+x*x);

  //W = sign*((AA*x) + (1 - AA)*(1*x*x))/(1 + x*x) + Math.sin(x);

  //W := sign*(AA*x + (1 - AA)*(2*x*x))/(1+x*x) + sin(AA+x);

  //W := -0.05*v.af[1]*x + (constPI-v.af[2]*x)*(v.af[3]*x*x)/(1+x*x);

  //W := -0.05*AA*x + (constPI-AA*x)*(AA*x*x)/(1+x*x);


  //W := sign*(v.af[7] + v.af[2]*x*sin(v.af[1]+x) +
    //                     v.af[2]*x*sin(v.af[1]+x) +
      //                   v.af[2]*x*sin(v.af[1]+x));

  //W := sign*AA + AA*x*sin(constPI+x); // this is cool
  //W := sign*AA + sin(x) * sin(constPI+x); // this is cool
  //W := sign*AA + sin(1/x); // this is cool

  //AA := constPI*AA;
  //W := const2PI*sign*AA + constPI + sin(constPI+sin(constPI+x)); // this is cool
  //W := const2PI*sign*AA + constPI + cos(x) + sin(constPI+sin(constPI+x)); // this is cool
  //W := AA * sign + AA + sin(x + sin(x));

  (*
  if (abs(x) <= 1e-4) or (abs(y) <= 1e-4) then
  begin
  	x := (random-0.5);
    y := (random-0.5);
    x := sin(2*constPI*x);
    y := sin(2*constPI*y);
  end;

  if (abs(x) > 1e4) or (abs(y) > 1e4) then
  begin
  	x := (random-0.5);
    y := (random-0.5);
    x := sin(x);
    y := sin(y);
  end;
  *)

  boundary_test_2;

  v.zx := x;
  v.zy := y;

end;

procedure None;
begin
  //fx := fx + x;
  //fy := fy + y;

  x := fx+x;
  y := fy+y;
end;

procedure Linear;
begin
  fx := fx + v.dFactor2 * x;
  fy := fy + v.dFactor2 * y;
end;

procedure Sinusoidal;
begin
  // Sinusoidal
  xnew := x + sin(x + sin(x));
  ynew := y + sin(y + sin(y));
  fx := v.dFactor2 * xnew;
  fy := v.dFactor2 * ynew;
end;

procedure Spherical;
begin
  // ----- SPHERICAL -----
  r2 := 1e-12+x*x+y*y;

  xnew := x/r2;
  ynew := y/r2;

  fx := fx + v.dFactor2 * xnew;
  fy := fy + v.dFactor2 * ynew;
end;

procedure Swirl;
begin
  // ----- SWIRL -----

  r2 := 1e-12+x*x+y*y;

  //c1 := sin(r2);
  //c2 := cos(r2);

  c1 := sin(r2);
  c2 := cos(r2);

  //xnew := c1 * x - c2 * y;
  //ynew := c2 * x + c1 * y;

  xnew := c1 * x - c2 * y;
  ynew := c2 * x + c1 * y;

  fx := fx + v.dFactor2 * xnew;
  fy := fy + v.dFactor2 * ynew;
end;

procedure Horseshoe;
begin
  // ----- HORSESHOE -----
  if ((x < -constZeroTol) or (x > constZeroTol) or
      (y < -constZeroTol) or (y > constZeroTol)) then
    a := ArcTan(x/y)
  else
    a := 0.0;

  c1 := sin(a);
  c2 := cos(a);

  xnew := c1 * x - c2 * y;
  ynew := c2 * x + c1 * y;

  fx := fx + v.dFactor2 * xnew;
  fy := fy + v.dFactor2 * ynew;
end;

procedure Polar;
begin
  // ----- POLAR -----
  if ((x < -constZeroTol) or (x > constZeroTol) or
      (y < -constZeroTol) or (y > constZeroTol)) then
    xnew := ArcTan(x/y) / constPI
  else
    xnew := 0.0;

  ynew := sqrt(1e-12 + x*x + y*y) - 1.0;

  fx := fx + v.dFactor2 * xnew;
  fy := fy + v.dFactor2 * ynew;
end;

procedure Bent;
begin
  // ----- BENT -----
  xnew := x;
  ynew := y;
  if (xnew < 0.0) then
    xnew := xnew *2.0;
  if (ynew < 0.0) then
    ynew := ynew / 2.0;

  fx := fx + v.dFactor2 * xnew;
  fy := fy + v.dFactor2 * ynew;
end;

procedure Inversion;
begin
	xnew := v.dFactor2*x/(x*x+y*y);
  ynew := v.dFactor2*y/(x*x+y*y);

  fx := 5*xnew;
  fy := 5*ynew;
end;

end.
