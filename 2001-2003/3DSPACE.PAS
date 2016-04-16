program _3dspace;
uses crt,graph,f_mouse,dos;
const
  n=100;
  d:longint=320;
  speedx=30;
  speedy=30;
  speedz=300;
  maxx=10000;
  maxy=10000;
  maxz=10000;
var
  x,y,z:array[1..n]of longint;
  px,py:array[1..n]of longint;
  color:array[1..n]of byte;
  gd,gm:integer;
  wx,wy,wz,xx,yy:longint;
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
     y[i]:=longint(random(maxy))-349 div 2;
     z[i]:=random(maxz);
     color[i]:={random(15)+1}15;
   end;
end;
procedure draw;
var
  i:word;
begin
  for i:=1 to n do
   if (px[i]>=0)and(px[i]<=639)and
      (py[i]>=0)and(py[i]<=349) then
    putpixel(word(px[i]),word(py[i]),color[i]);
end;
procedure clear;
var
  i:word;
begin
  for i:=1 to n do
   if (px[i]>=0)and(px[i]<=639)and
      (py[i]>=0)and(py[i]<=349) then
    putpixel(word(px[i]),word(py[i]),0);
end;
var
  r:registers;
  f:boolean;
  page:byte;
begin
  gd:=vga;
  gm:=vgalo;
  initgraph(gd,gm,'d:\projects\segate\programs\bp\bgi');
  randomize;
  initpoints;
  oldx:=0;
  oldy:=0;
  f:=true;
  page:=0;
  repeat
    setvisualpage(1-page);
    setactivepage(page);
    page:=1-page;
    getmousestate(butt,mx,my);
    if butt=1 then
     inc(wz,speedz);
    if butt=2 then
     dec(wz,speedz);
    if (oldx<>mx)or(oldy<>my) then
     begin
       f:=true;
       {if mx>oldx then
         inc(wx,speedx)
        else
         dec(wx,speedx);
       if my>oldy then
         inc(wy,speedy)
        else
         dec(wy,speedy);}
       inc(wx,(mx-oldx)*speedx);
       inc(wy,(my-oldy)*speedy);
       oldx:=mx;
       oldy:=my;
       if (mx=0)or(mx=639)or(my=0)or(my=349) then
        begin
          r.ax:=4;
          r.cx:=320;
          r.dx:=350 div 2+1;
          intr($33,r);
          oldx:=320;
          oldy:=350 div 2+1;
        end;
     end;
    if (butt=1)or(butt=2)or f then
     begin
       cleardevice;
       for i:=1 to n do
        if z[i]-wz<=0 then
          begin
            px[i]:=-1;
            py[i]:=-1;
          end
         else
          begin
            xx:=round((x[i]-wx)*d/(z[i]-wz+d));
            yy:=round((y[i]-wy)*d/(z[i]-wz+d));
            px[i]:=xx+320;
            py[i]:=yy+350 div 2+1;
          end;
       draw;
       f:=false;
     end;
  until keypressed;
  closegraph;
end.