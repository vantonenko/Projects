program pix;
uses crt,graph,f_mouse;
var
  b:byte;
  gd,gm,mx,my:integer;
  x,y,color:word;
  adr:word;
procedure putpixel(x,y:word;color:word);
begin
  asm
   cli
  end;
  port[$3ce]:=5;
  port[$3cf]:=2;
  adr:=y shl 6+y shl 4+x div 8;
  port[$3ce]:=8;
  port[$3cf]:=128 shr (x mod 8);
  b:=mem[$a000:adr];
  mem[$a000:adr]:=color;
  asm
   sti
  end;
end;
procedure userproc(butt,mask,x,y,dx,dy:integer);far;
begin
  mx:=x;
  my:=y;
  {setfillstyle(1,random(16));
  bar(0,0,100,100);}
end;
begin
  gd:=0;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  {showmouse;
  setmousehandler(1,userproc);}
  port[$3ce]:=5;
  port[$3cf]:=2;
  repeat
    {putpixel(random(640),random(480),random(16));}
    x:=random(640);
    y:=random(480);
    color:=random(16);
    adr:=y shl 6+y shl 4+x div 8;
    port[$3ce]:=8;
    port[$3cf]:=128 shr (x mod 8);
    b:=mem[$a000:adr];
    mem[$a000:adr]:=color;
  until keypressed;
  closegraph;
end.