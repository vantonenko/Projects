program _3dspace;
uses crt,graph,f_mouse,dos;
const
  n=2000;
  d:longint=320;
  {speedx=30;}
  speedy=20;
  speedz=200;
  maxx=60000;
  maxy=60000;
  maxz=60000;
var
  x,y,z:array[1..n]of longint;
  px,py:array[1..n]of longint;
  color:array[1..n]of byte;
  gd,gm:integer;
  xx,yy:longint;
  x1,z1,wx,wy,wz,sina,cosa,angle:extended;
  i:word;
  butt,mx,my,oldx,oldy:integer;
procedure initpoints;
var
  i:word;
begin
  wx:=0;
  wy:=0;
  wz:=0;
  for i:=1 to n do
   begin
     x[i]:=longint(random(maxx))-maxx div 2;
     y[i]:=longint(random(maxy))-maxy div 2;
     z[i]:=random(maxz);
     z[i]:=z[i]*10;
     color[i]:=random(8)+8;
   end;
end;
procedure draw;
var
  i:word;
begin
  for i:=1 to n do
   if (px[i]>=0)and(px[i]<=639)and
      (py[i]>=0)and(py[i]<=479) then
    putpixel(word(px[i]),word(py[i]),color[i]);
end;
procedure clear;
var
  i:word;
begin
  for i:=1 to n do
   if (px[i]>=0)and(px[i]<=639)and
      (py[i]>=0)and(py[i]<=479) then
    putpixel(word(px[i]),word(py[i]),0);
end;
var
  r:registers;
  f:boolean;
  page:byte;
begin
  gd:=vga;
  gm:=vgamed;
  initgraph(gd,gm,'..\..\BP\bgi');
  randomize;
  initpoints;
  oldx:=320;
  oldy:=240;
  f:=true;
  angle:=0;
  cosa:=cos(angle);
  sina:=sin(angle);
  initmouse;
  page:=0;
  repeat
    setactivepage(page);
    setvisualpage(1-page);
    page:=1-page;
    getmousestate(butt,mx,my);
    {if butt and 3<>0 then
     wy:=wy+50-random*100;}
    if butt=1 then
     begin
       wx:=wx-speedz*sina;
       wz:=wz+speedz*cosa;
     end;
    if butt=2 then
     begin
       wx:=wx+speedz*sina;
       wz:=wz-speedz*cosa;
     end;
    if (oldx<>mx)or(oldy<>my) then
     begin
       f:=true;
       angle:=angle-(mx-oldx)*pi/640;
       sina:=sin(angle);
       cosa:=cos(angle);
       wy:=wy+(my-oldy)*speedy;
       oldx:=mx;
       oldy:=my;
       if (mx=0)or(mx=639)or(my=0)or(my=349) then
        begin
          r.ax:=4;
          r.cx:=320;
          r.dx:=240;
          intr($33,r);
          oldx:=320;
          oldy:=240;
        end;
     end;
    f:=true;
    if (butt=1)or(butt=2)or f then
     begin
       cleardevice;
       for i:=1 to n do
        begin
          x1:=(z[i]-wz)*sina+(x[i]-wx)*cosa;
          z1:=(z[i]-wz)*cosa-(x[i]-wx)*sina;
          if z1<=0 then
            begin
              px[i]:=-1;
              py[i]:=-1;
            end
           else
            begin
              xx:=round(x1*d/(z1+d));
              yy:=round((y[i]-wy)*d/(z1+d));
              px[i]:=xx+320;
              py[i]:=yy+350 div 2+1;
            end;
        end;
       draw;
       f:=false;
     end;
  until keypressed;
  readkey;
  closegraph;
end.