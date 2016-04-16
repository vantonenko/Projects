uses graph,crt,f_mouse;
const
  sx=9;
  sy=16;
  wmask:array[1..sy]of longint=
   ($00,$80,$c0,$e0,$f0,$f8,$fc,$fe,$f8,$98,$1c,$0c,$0c,$06,$06,$00);
  bmask:array[1..sy]of longint=
   ($180,$140,$120,$110,$108,$104,$102,$101,$104,$164,$1a2,$12,$12,$9,$9,$6);
var
  gd,gm,x,y,ox,oy:integer;
  c,i,j:byte;
  d:shortint;
  b,adr:longint;
  bb:byte absolute b;
  un:pointer;
  ssx,ssy:byte;
procedure user(mask,butt,x,y,dx,dy:integer);far;
begin
  putimage(ox,oy,un^,0);
  getimage(x,y,x+sx-1,y+sy-1,un^);
  ox:=x;
  oy:=y;
  c:=(x mod 8+sx)div 8+1;
  adr:=longint(y shl 4)+longint(y shl 6)+longint(x div 8);
  for j:=1 to sy do
   begin
     for i:=1 to c do
      begin
        d:=x mod 8+sx-i shl 3;
        if d>0 then
          b:=wmask[j] shr d
         else
          b:=wmask[j] shl(-d);
        port[$3ce]:=8;
        port[$3cf]:=bb;
        b:=mem[$a000:adr];
        mem[$a000:adr]:=$ff;
        if d>0 then
          b:=bmask[j] shr d
         else
          b:=bmask[j] shl(-d);
        port[$3ce]:=8;
        port[$3cf]:=bb;
        b:=mem[$a000:adr];
        mem[$a000:adr]:=0;
        adr:=adr+1;
      end;
     adr:=adr-c+80;
   end;
end;
var
  f:file;
begin
  gd:=0;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  setfillstyle(1,3);
  bar(0,0,639,479);
  x:=200;
  y:=200;
  initmouse;
  mousewindow(0,0,640-sx,480-sy);
  getmem(un,151);
  x:=320;y:=240;
  ox:=x;oy:=y;
  getimage(x,y,x+sx-1,y+sy-1,un^);
  port[$3ce]:=5;
  port[$3cf]:=2;
  setmousehandler(1,user);
  for i:=0 to 15 do
   begin
     setfillstyle(1,i);
     bar(0,100+i*5,100,100+i*5+5);
   end;
  assign(f,'..\settings\default.cur');
  rewrite(f,1);
  ssx:=sx;
  ssy:=sy;
  blockwrite(f,ssx,1);
  blockwrite(f,ssy,1);
  blockwrite(f,wmask,sizeof(wmask));
  blockwrite(f,bmask,sizeof(bmask));
  close(f);
  readkey;
  closegraph;
end.