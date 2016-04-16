{Resolution:360x480x256}
program show;
uses crt,graph,g_sharp;
const
  col:array[0..15]of byte=
      (0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
const
  maxcol=255;
  dir=false;
type
  trgb=record
    r,g,b:byte;
  end;
var
  gd,gm,i,j,x,y:integer;
  r,xx,yy:extended;
  b:byte;
  adr:word;
function color(xx,yy:integer):byte;
var
  x,y:extended;
begin
  x:=xx*640.0/360;
  y:=yy;
  r:=sqrt(sqr(x-640 div 2)+sqr(y-480 div 2));
  color:=abs(round(r)) mod maxcol+1;
end;
var
  palette:array[1..maxcol] of trgb;
  s:trgb;
  c:char;
  ncadr,t:longint;
  e:extended;
  mid:word;
Procedure WaitRetrace; Assembler;
  { This waits until you are in a Verticle Retrace ... this means that all
    screen manipulation you do only appears on screen in the next verticle
    retrace ... this removes most of the "fuzz" that you see on the screen
    when changing the pallette. It unfortunately slows down your program
    by "synching" your program with your monitor card ... it does mean
    that the program will run at almost the same speed on different
    speeds of computers which have similar monitors. In our SilkyDemo,
    we used a WaitRetrace, and it therefore runs at the same (fairly
    fast) speed when Turbo is on or off. }

Label
  L1, L2;
Asm
    Mov DX, 3DAH
L1:
    In AL,DX
    And AL,08H
    JNZ L1
L2:
    In AL,DX
    And AL,08H
    JZ  L2
End;
label m1;
begin
  gd:=0;
  inithivga256;
  fillscreen(0);
  for i:=1 to maxcol do
   with palette[i] do
    begin
      mid:=(maxcol+1) div 2;
      r:=round(31.5*cos(pi*i/mid)+31.5);
      g:=round(31.5*cos(pi*i/mid+2*pi/3)+31.5);
      b:=round(31.5*cos(pi*i/mid+4*pi/3)+31.5);
      setusercolor(i,r,g,b);
    end;
  for y:=0 to 480 do
   for x:=0 to 360 do
    begin
      putpixel(x,y,color(x,y));
      if keypressed then
       begin
         readkey;
         goto m1;
       end
    end;
m1:t:=meml[$0040:$006c];
  ncadr:=0;
  repeat
    inc(ncadr);
    waitretrace;
    for i:=1 to maxcol do
     with palette[i] do
      setusercolor(i,r,g,b);
    if dir then
      begin
        s:=palette[1];
        for i:=1 to maxcol-1 do
         palette[i]:=palette[i+1];
        palette[maxcol]:=s;
      end
     else
      begin
        s:=palette[maxcol];
        for i:=maxcol downto 2 do
         palette[i]:=palette[i-1];
        palette[1]:=s;
      end;
    if keypressed then
     begin
       c:=readkey;
       if c=#27 then
        break;
       readkey;
     end;
  until false;
  e:=ncadr*18.2/(meml[$0040:$006c]-t-1);
  closegraph;
  writeln(e:0:2);
end.