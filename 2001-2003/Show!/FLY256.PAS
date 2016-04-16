program show;
uses crt,graph;
const
  dir=true;
type
  trgb=record
    r,g,b:integer;
  end;
var
  gd,gm,i,j,x,y:integer;
  r,xx,yy:extended;
  b:byte;
  adr:word;
  palette:array[0..255]of trgb;
  s:trgb;
function color(xx,yy:integer):byte;
var
  x,y:extended;
begin
  x:=xx;
  y:=yy;
  r:=sqrt(sqr(x-160)+sqr(y-100));
  color:=round(r) mod 63+1;
end;
{$f-}
procedure proc;
begin
end;
{$f+}
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
  gd:=installuserdriver('vga256',@proc);
  initgraph(gd,gm,'');
  cleardevice;
  for i:=63 downto 1 do
   with palette[i] do
    begin
      r:=i;
      g:=i;
      b:=i;
      setrgbpalette(i,r,g,b);
    end;
  for y:=0 to getmaxy do
   for x:=0 to getmaxx do
    begin
      putpixel(x,y,color(x,y));
      if keypressed then
       goto m1;
    end;
  repeat
    waitretrace;
    for i:=1 to 63 do
     with palette[i] do
      setrgbpalette(i,r,g,b);
    {delay(30);}
    if dir then
      begin
        s:=palette[1];
        for i:=1 to 62 do
         palette[i]:=palette[i+1];
        palette[63]:=s;
      end
     else
      begin
        s:=palette[63];
        for i:=63 downto 2 do
         palette[i]:=palette[i-1];
        palette[1]:=s;
      end;
  until keypressed;
m1:readkey;
  closegraph;
end.