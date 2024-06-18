{************Complex arithmetic in Delphi************}
{*   (c) 1997 Bjoern Ischo & Stephen C. Ferguson    *}
{*                                                  *}
{*Based upon COMPLEX.H header file by Louis Baker in*}
{* Handbook of C tools for Scientists and Engineers *}
{****************************************************}

{Any comments and suggestions are welcome;
 please send then to:
 bischo6639@aol.com (Bjoern)
 OR
 stephenf@HiWAAY.net   (Stephen)

 24.Nov 97: first alpha,                      Bjoern
            added cmulti,cadd,csub
}

unit complex;

  //Compiler Directives - we want it fast!

interface

uses math;
//uses Formula;

type tcomplex = record
                x, y : double; //x->real y->imaginary
                end;

     procedure z_times_z_plus_c;
     procedure z_times_z;
     procedure z_times_z_times_z;
     procedure z2_times_z;
     procedure z_plus_c;

     function cmulti_real(z,z2:tcomplex):double;
              //multiplication of real part
     function cmulti_imag(z,z2:tcomplex):double;
              //multiplication of real part
     function cmagnitude(z:tcomplex):double;
              //magnitude
     function cmulti(xz,yz:tcomplex):tcomplex;
              //multiplication
     function cmulti_CR(z_:tcomplex;r1:double):tcomplex;
              //multiplication cmplx*real
     function cadd(xz,yz:tcomplex):tcomplex;
              //addition
     function cadd_CR(z_:tcomplex;r1:double):tcomplex;
              //addition cmplx+real
     function csub(xz,yz:tcomplex):tcomplex;
              //subtraction
     function csub_CR(z_:tcomplex;r1:double):tcomplex;
              //subtraction cmlpx-real
     function cnorm(z_:tcomplex):double;
              //norm
     function cdrn(xz,yz:tcomplex):double;
              //drn
     function cdin(xz,yz:tcomplex):double;
              //cdin
     function cdiv(xz,yz:tcomplex):tcomplex;
              //complex div
     //function clog(z_:tcomplex):tcomplex;
       //       //complex natural logarythm
     function cexp(z_:tcomplex):tcomplex;
              //complex exponent
     function ccos(z_:tcomplex):tcomplex;
       //       //complex sinus
     function csin(z_:tcomplex):tcomplex;
       //       //complex cosinus
     function cintpower(z_:tcomplex;i1:integer):tcomplex;
              //rather simple integer power for complex
     function cintdiv_RC(f1:double;z_:tcomplex):tcomplex;
     function cintdiv_CR(z_:tcomplex;r1:double):tcomplex;

     function cmplx(x,y:double):tcomplex;
              //when we need an instant cmplx number;

     //FAST! stuff:
     function fastsin(x : extended): extended; assembler;
     function fastcos(x : extended): extended; assembler;

     //additional thingys:
     //function GamSmall(X1, Z : double) : double;

//some useful constants:
const
     rad=57.2958;
     lim=15;
     expo=2.7183;

var
  z, z1, z2, z3, z4, c: tcomplex;
  zs, zr, zn, zd: tcomplex;
  tmp: double;

implementation

////////

procedure z_times_z_plus_c;
begin
  tmp := z.x*z.x - z.y*z.y;
  z.y  := 2*z.x*z.y;
  z.x  := tmp;
  z.x := z.x+c.x;
  z.y := z.y+c.y;
end;

procedure z_times_z;
begin
  //{return cmplx(v.x*x-v.y*y, v.x*y+v.y*x);} // multiply
  tmp := z.x*z.x - z.y*z.y;
  z2.y  := 2*z.x*z.y;
  z2.x  := tmp;
end; // result in z2

procedure z2_times_z;
begin
  //{return cmplx(v.x*x-v.y*y, v.x*y+v.y*x);} // multiply
  tmp := z2.x*z.x - z2.y*z.y;
  z3.y  := 2*z2.x*z.y;
  z3.x  := tmp;
end;  // result in z3

procedure z_times_z_times_z;
begin
  //{return cmplx(v.x*x-v.y*y, v.x*y+v.y*x);} // multiply
  tmp := z.x*z.x*z.x - z.y*z.y*z.y;
  z3.y  := 3*z.x*z.y*z.x;
  z3.x  := tmp;
end;

procedure z_plus_c;
begin
  z.x := z.x+c.x;
  z.y := z.y+c.y;
end;

////////

function fastsin(x : extended): extended; assembler;
asm
   FLD x           { load x }
   DB $D9, $FE     { opcode for FSIN }
end;

function fastcos(x : extended): extended; assembler;
asm
   FLD x         { load angle }
   DB $D9, $FF   { opcode for FCOS }
end;

function cmulti_real(z,z2:tcomplex):double;
begin
try cmulti_real:=z.x*z2.x-z.y*z2.y except cmulti_real:=0 end
end;  //function cmulti_real(z,z2:tcomplex):double;

function cmagnitude(z:tcomplex):double;
begin
cmagnitude:=sqrt(cmulti_real(z,z)+cmulti_imag(z,z));
end;  //function cmagnitude(z:tcomplex):double;

function cmulti_imag(z,z2:tcomplex):double;
begin
try cmulti_imag:=z.y*z2.x+z.x*z2.y except cmulti_imag:=0 end;
end;  //function cmulti_imag(z,z2:tcomplex):double;

function cmulti(xz,yz:tcomplex):tcomplex;
begin
try cmulti.x:=xz.x*yz.x-xz.y*yz.y except cmulti.x:=0 end;
try cmulti.y:=xz.y*yz.x+xz.x*yz.y except cmulti.y:=0 end;
end;  //function cmulti(xz,yz:tcomplex):tcomplex;

function cmulti_CR(z_:tcomplex;r1:double):tcomplex;
begin
cmulti_CR.x:=z_.x*r1;
cmulti_CR.y:=z_.y*r1;
end;  //function cmulti_CR(z_:tcomplex;r1:double):tcomplex

function cadd(xz,yz:tcomplex):tcomplex;
begin
cadd.x:=xz.x+yz.x;
cadd.y:=xz.y+yz.y;
end;  //function cadd(xz,yz:tcomplex):tcomplex;

function cadd_CR(z_:tcomplex;r1:double):tcomplex;
begin
cadd_CR.x:=z_.x+r1;
cadd_CR.y:=z_.y;
end; //function cadd_CR(z_:tcomplex;r1:double):tcomplex;

function csub(xz,yz:tcomplex):tcomplex;
begin
csub.x:=xz.x-yz.x;
csub.y:=xz.y-yz.y;
end;  //function csub(xz,yz:tcomplex):tcomplex;

function csub_CR(z_:tcomplex;r1:double):tcomplex;
begin
csub_CR.x:=z_.x-r1;
csub_CR.y:=z_.y;
end; //function csub_CR(z_:tcomplex;r1:double):tcomplex;

function cnorm(z_:tcomplex):double;
begin
try cnorm:=z_.x*z_.x+z_.y*z_.y except cnorm:=0.00000001 end;
end; //function cnorm(z_:tcomplex):double;

function cdrn(xz,yz:tcomplex):double;
begin
try cdrn:=Xz.x*Yz.x+Yz.y*Xz.y except cdrn:=0.00000001 end;
end; //function cdrn(xz,yz:tcomplex):double;

function cdin(xz,yz:tcomplex):double;
begin
try cdin:=Xz.y*Yz.x-Xz.x*Yz.y; except cdin:=0.00000001 end;
end; //function cdin(xz,yz:tcomplex):double;

function cdiv(xz,yz:tcomplex):tcomplex;
//var tmp:double;
begin
tmp:=yz.x*yz.x+yz.y*yz.y;
try cdiv.x:=(Xz.x*Yz.x+Yz.y*Xz.y)/tmp except cdiv.x:=0 end;
try cdiv.y:=(Xz.y*Yz.x-Xz.x*Yz.y)/tmp except cdiv.y:=0 end;
end;  //function csub(xz,yz:tcomplex):tcomplex;

(*
function clog(z_:tcomplex):tcomplex;
var      r,angle,temp : double;
begin
//a lot of speed-up work is still required here
temp:=cnorm(z_);
if temp<>0 then r:=sqrt(temp) else r:=0;
if z_.x<>0 then angle:=arctan2(z_.y,z_.x) else angle:=0;
if r<>0 then clog.x:=ln(r) else clog.x:=0;
clog.y:=angle;
end; //function clog(z_:tcomplex):tcomplex;
*)

function cexp(z_:tcomplex):tcomplex;
var      temp : double;
begin
//a lot of speed-up work is still required here
temp:=exp(z_.x);
cexp.x:=temp*fastcos(z_.x);
cexp.y:=temp*fastsin(z_.y);
end; //function clog(z_:tcomplex):tcomplex;

function csin(z_:tcomplex):tcomplex;
begin
try csin.x:=fastsin(z_.x)*cosh(z_.y) except csin.x:=0 end;
try csin.y:=fastcos(z_.x)*sinh(z_.y) except csin.y:=0 end;
end; //function ccos(z_:tcomplex):tcomplex;

function ccos(z_:tcomplex):tcomplex;
begin
try ccos.x:=fastcos(z_.x)*cosh(z_.y) except ccos.x:=0 end;
try ccos.y:=-fastsin(z_.x)*sinh(z_.y) except ccos.y:=0 end;;
end; //function ccos(z_:tcomplex):tcomplex;

function cintpower(z_:tcomplex;i1:integer):tcomplex;
var xz:tcomplex;
     i:integer;
begin
xz:=z_;
for i:=i1-1 downto 1 do
 z_:=cmulti(z_,xz);
cintpower:=z_;
end; //function cintpower(z_:tcomplex;i1:integer):tcomplex;

function cintdiv_RC(f1:double;z_:tcomplex):tcomplex;
begin
try
begin
cintdiv_RC.x:=(f1*z_.x)/(z_.x*z_.x+z_.y*z_.y);
cintdiv_RC.y:=(-f1*z_.y)/((z_.x*z_.x+z_.y*z_.y));
end
except
begin
cintdiv_RC.x:=0;
cintdiv_RC.y:=0;
end
end
end;

function cintdiv_CR(z_:tcomplex;r1:double):tcomplex;
begin
if r1<>0 then
begin
cintdiv_CR.x:=z_.x/r1;
cintdiv_CR.y:=z_.y/r1;
end
else
begin
cintdiv_CR.x:=0;
cintdiv_CR.y:=0;
end;
end;

function cmplx(x,y:double):tcomplex;
begin
cmplx.x:=x;
cmplx.y:=y;
end;

end.
