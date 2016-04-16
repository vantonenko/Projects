program _3dspace;
uses crt,graph,f_mouse,dos;
const
  n=300;
  d:longint=500;
  speedy=1000;
  minh=speedy*5;
  speedz:longint=300;
  minspeed=200000;
  maxx=600000;
  maxy={600000}0;
  maxz=60000000;
  maxvisible=6000000000.0;
  st=10000;
var
  x,y,z:array[1..n]of extended;
  px,py:array[1..n]of longint;
  pcolor,color:array[1..n]of byte;
  gd,gm:integer;
  xx,yy:longint;
  x1,z1,wx,wwy,wy,wz,sina,cosa,angle:extended;
  i,nvis:word;
  butt,mx,my,oldx,oldy:integer;
  c:char;
  speed:longint;
procedure initpoints;
var
  i:word;
begin
  wx:=0;
  wy:=-5*speedy;
  wz:=0;
  {for i:=1 to n do
   begin
     x[i]:=longint(random(word(maxx div st)))*st-maxx div 2;;
     y[i]:=longint(random(word(maxy div st)))*st-maxy div 2;
     z[i]:=longint(random(word(maxz div st)))*st-maxz div 2;
     color[i]:=15;
   end;}
  for i:=1 to n div 3 do
   begin
     x[i]:=-(maxx div 2);
     y[i]:=0;
     z[i]:=longint(random(word(maxz div st)))*st;
     color[i]:=15;
   end;
  for i:=n div 3+1 to (n div 3)*2 do
   begin
     x[i]:=0;
     y[i]:=0;
     z[i]:=longint(random(word(maxz div st)))*st;
     color[i]:=11;
   end;
  for i:=(n div 3)*2+1 to n do
   begin
     x[i]:=maxx div 2;
     y[i]:=0;
     z[i]:=longint(random(word(maxz div st)))*st;
     color[i]:=15;
   end;
end;
procedure draw;
var
  i:word;
begin
  for i:=1 to nvis do
   if (px[i]>=0)and(px[i]<=639)and
      (py[i]>=0)and(py[i]<=479) then
    putpixel(word(px[i]),word(py[i]),pcolor[i]);
end;
var
  r:registers;
  f:boolean;
begin
  initgraph(gd,gm,'d:\segate\programs\bp\bgi');
  randomize;
  initpoints;
  oldx:=320;
  oldy:=240;
  f:=true;
  angle:=0;
  cosa:=cos(angle);
  sina:=sin(angle);
  initmouse;
  mx:=320;
  my:=240;
  c:=#0;
  repeat
    getmousestate(butt,mx,my);
    if (butt=1)or(butt=3) then
     speed:=speed+speedz;
    if butt=2 then
     speed:=speed-speedz;
    if keypressed then
     begin
       c:=readkey;
       {if c='w' then
        speed:=speed+speedz;
       if c='a' then
        speed:=speed-speedz;
       if c='e' then
        wy:=wy-speedy;
       if c='d' then
        wy:=wy+speedy;
       if not (c in ['w','a','e','d']) then
        speed:=0;
       if (speedy<>0) and not(c in ['w','a',#27]) then
        c:='w';}
     end;
    {if c='=' then
     inc(d,10);
    if c='-' then
     dec(d,10);}
    if speed<>0{c in['w','a']} then
     begin
       wx:=wx-speed*sina;
       wz:=wz+speed*cosa;
     end;
    {if butt=2 then
     begin
       wx:=wx+speed*sina;
       wz:=wz-speed*cosa;
     end;}
    if (oldx<>mx)or(oldy<>my) then
     begin
       f:=true;
       angle:=angle-(mx-oldx)*pi/1000;
       sina:=sin(angle);
       cosa:=cos(angle);
       wwy:=wy+(my-oldy)*longint(speedy);
       if ((wy<-minh)or((wy=-minh)and(speed>=minspeed)))and(wwy<=-minh) then
        wy:=wwy;
       oldx:=mx;
       oldy:=my;
       if (mx=0)or(mx=639)or(my=0)or(my=479) then
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
       nvis:=0;
       for i:=1 to n do
        begin
          x1:=(z[i]-wz)*sina+(x[i]-wx)*cosa;
          z1:=(z[i]-wz)*cosa-(x[i]-wx)*sina;
          if (z1>0)and(z1<maxvisible) then
           begin
             inc(nvis);
             xx:=round(x1*d/(z1+d));
             yy:=round((y[i]-wy)*d/(z1+d));
             px[nvis]:=longint(xx)+320;
             py[nvis]:=longint(yy)+240;
             pcolor[nvis]:=color[i];
           end;
        end;
       draw;
       f:=false;
     end;
  until c=#27;
  closegraph;
end.