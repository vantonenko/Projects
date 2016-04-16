program pix;
uses crt,graph,f_mouse;
const
  rx=100;
  ry=10;
var
  b:byte;
procedure userproc(butt,mask,x,y,dx,dy:integer);far;
var
  col:word;
begin
  col:=getcolor;
  setfillstyle(1,random(16));
  bar(550,350,620,420);
  setcolor(random(16));
  rectangle(550,350,620,420);
  b:=0;
  setcolor(col);
end;
var
  gd,gm:integer;
  adr,x,y:word;
  a:real;
begin
  gd:=0;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  initmouse;
  showmouse;
  {port[$3ce]:=5;
  port[$3cf]:=2;
  x:=0;
  y:=0;
  adr:=0;
  b:=128;
  repeat
    x:=random(640);
    y:=random(100);
    b:=128 shr (x mod 8);
    adr:=y shl 4+y shl 6+x div 8;
    asm
      cli
    end;
    port[$3ce]:=8;
    port[$3cf]:=b;
    b:=mem[$a000:adr];
    mem[$a000:adr]:=random(16);
    asm
      sti
    end;
    delay(10);
  until keypressed;}
  setmousehandler(1,userproc);
  a:=0;
  repeat
    b:=1;
    asm
      cli
    end;
    setcolor(0);
    line(100,50,100+round(40*cos(a)),50+round(40*sin(a)));
    a:=a+pi/1000;
    setcolor(random(15)+1);
    line(100,50,100+round(40*cos(a)),50+round(40*sin(a)));
    if b=0 then
     b:=b;
    asm
      sti
    end;
    {delay(50);}
  until keypressed;
  closegraph;
end.