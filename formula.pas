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
  procedure mask_the_color_linear;
	procedure coloring;
  procedure boundary_test;

implementation

var
  v: pDataPointer;
  x, y, z: Double;

  Pixel: TRGB;

  LSum: double;
  tx, ty: Double;
  nx, ny: Integer;

  red, grn, blu, tmp: Integer;

  //xnew, ynew, znew: double;
  xnew: double;
  my_Index: double;
  my_Counter: integer;

  i, j: Integer;
  bSearching: Bool;

  // Computer search variables
  x_save, y_save: double;

  //rs, d2, dx, dy, dz, ri, df: double;

  // Scott Draves Flame variables
  fx, fy: double;

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

    if (abs(x) * abs(y)) > 1e10 then
    begin
      initialize_data;
      //ShowMessage('start over');
      zero_init;
      //v.Abort_Draw := True;
    end
    else
    begin
      draw_points;
    end;

    Application.ProcessMessages;
  end;

  bug := 1;
end;

procedure boundary_test;
begin

    (*
    if ((abs(x) * abs(y)) > 1e5)  or ((abs(x) * abs(y)) < 1e-4) then
    begin
      //initialize_data;
      //x := 0.1;
      //y := 0.1;
    end;
    *)

    //ShowMessage('start over');

    if (abs(x) > 1e4) or (abs(x) < 1e-4) then
    begin
        x := 2*(random-0.5);
        //x := 5+sin(constPI*x);
    end;

    if (abs(y) > 1e4) or (abs(y) < 1e-4) then
    begin
        y := 2*(random-0.5);
        //y := 5+sin(constPI*y);
    end;

    if (v.nPoints mod 1000 = 0) then
    begin
      initialize_data;
    end;

    (*
    //if x*x+y*y <= 1e-2 then
    //begin
      if abs(x) <= 1e-2 then
      begin
        x := sin(constPI*x);
      end;

      if abs(y) <= 1e-2 then
      begin
        y := sin(constPI*y);
      end;
    //end;

    //if x*x+y*y > 1e2 then
    //begin
      if abs(x) > 1e5 then
      begin
        x := sin(constPI*x);
      end;

      if abs(y) > 1e5 then
      begin
        y := sin(constPI*y);
      end;
    //end;
    *)
    
    //end;
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

  AA := v.RandomFactor*(random);
  v.C  := AA;
  v.AA := AA;
  v.AA_Initial := AA;
  W := 0;

  //x := v.RandomFactor*(v.RandomFactor*(random)-0.5);
  //y := v.RandomFactor*(v.RandomFactor*(random)-0.5);

  x := v.RandomFactor*(random);
  y := v.RandomFactor*(random);

  //x := 10;
  //y := 10;

  fx := x;
  fy := y;

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

  x := fx;
  y := fy;

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
end;

procedure accumulate;
begin
  DrawPointArray;
end;

procedure TListUpdate;
begin
  if (v.bSqrt = True) then
  begin
    my_Index := 5*sqrt(5*my_Counter);
  end
  else
  begin
    my_Index := my_Counter;
  end;

  color := Round(my_Index);
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

procedure DrawPointArray;
begin
  PixelMap;

  if (nx >= 0) and (nx < v.iWidth) and (ny >= 0) and (ny < v.iHeight) then
  begin
    begin
      //LSum := abs(sin(constPI*arctan((1+x-x_save)/(1+y-y_save))));

      //LSum := abs(sin(constPI*((1+x-x_save)+(1+y-y_save))));
      LSum := 1;

      Pointer(my_Counter) := v.my_TList[nx*(v.Width-1)+ny];
      my_Counter := my_Counter + Round(10+v.dFactor1 * LSum);
      v.my_TList[nx*(v.Width-1)+ny] := Pointer(my_Counter);

      TListUpdate;
      coloring;

      (*
      Pix := v.aPG.Bits[nx, ny];

      r := GetRValue(Pix) and $FF;
      g := GetGValue(Pix) and $FF;;
      b := GetBValue(Pix) and $FF;

      if (r > red) then
        red := Round(r);

      if (g > grn) then
        grn := Round(g);

      if (b > blu) then
        blu := Round(b);
      *)

      Pixel := RGB(red, grn, blu);
      v.aPG.Bits[nx, ny] := Pixel;
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

procedure mask_the_color_linear;
begin
  // this procedure accepts values of r, g, and b between -PI/2 and PI/2
  // and returns values of red, grn, and blu

  if (red > 255) or (grn > 255) or (blu > 255) then
    bug := bug + 1;

  r := r;
  g := g;
  b := b;

  //r := r/10;
  //g := g/10;
  //b := b/10;

  r := r*v.dFactor1;
  g := g*v.dFactor1;
  b := b*v.dFactor1;

  red := Round(r*v.dRedStep);
  grn := Round(g*v.dGrnStep);
  blu := Round(b*v.dBluStep);

  if red > 255 then
    red := 255;
  if grn > 255 then
    grn := 255;
  if blu > 255 then
    blu := 255;

  if red < 0 then
    red := 0;
  if grn < 0 then
    grn := 0;
  if red < 0 then
    blu := 0;

  if v.bInvert = True then
  begin
    // invert the color
    red := not red and $FF;
    grn := not grn and $FF;
    blu := not blu and $FF;
  end;

end;

procedure Mira_01;
begin
  if (v.nPoints mod 1000 = 0) then
  begin
    if (v.bModulas = true) then
      v.AA := V.AA - 0.01*sin(V.AA);
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

  (*
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

  case v.formula of
    1: begin
         x := x - 1/sqrt(x*x+y*y)*(x * sign)/20000;
         z := x;
         x := BB*y + W;
         W := AA*x - 2*x*x*(1 - AA) / (1 + x*x);
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

  v.zx := x;
  v.zy := y;

end;

end.
