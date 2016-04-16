program _3dspace;
uses crt,graph,f_mouse,dos;
const
  n=200;{кол-во точек}
  d:longint=300;{фокусное расстояние линз наблюдателя}
  minh=30000;{минимальная высота}
  speedz:longint=3000;{ускорение}
  maxangleh=pi/6;{максимальный угол взлёта}
  maxanglep=pi/36;{максимальный угол посадки}
  dangleh=pi/1800;{прирост угла взлёта}
  minspeed=400000;{минимальная скорость при полёте}
  maxspeedair=20000;{максимальная скорость ёзды вне}
  maxx=600000;{ширина аэропорта}
  maxz=40000000;{длина аэропорта}
  maxvisible=6000000000.0;{}
  correcttime=15;{}
var
  x,y,z:array[1..n]of extended;
  px,py:array[1..n]of longint;
  pcolor,color:array[1..n]of byte;
  gd,gm:integer;
  xx,yy:longint;
  x1,z1,wx,owy,wwy,wy,wz,sina,cosa,angle,speedh,speedp,angleh,sinh,cosh:extended;
  i,nvis:word;
  butt,oldbutt,mx,my,oldx:integer;
  c:char;
  speed:longint;
  serve:byte absolute $0000:$0417;
  fkill:boolean;
procedure initpoints;
var
  i:word;
  mz:extended;
begin
  wx:=0;
  wy:=-minh;
  wz:=0;
  mz:=maxz;
  for i:=1 to n*3 div 7 do
   begin
     x[i]:=-(maxx div 2);
     y[i]:=0;
     z[i]:=mz*i/(n*3 div 7);
     color[i]:=14;
   end;
  for i:=n*3 div 7+1 to n*4 div 7 do
   begin
     x[i]:=0;
     y[i]:=0;
     z[i]:=mz*(i-n*3 div 7)/(n div 7);
     color[i]:=11;
   end;
  for i:=n*4 div 7+1 to n do
   begin
     x[i]:=maxx div 2;
     y[i]:=0;
     z[i]:=mz*(i-n*4 div 7)/(n*3 div 7);
     color[i]:=14;
   end;
end;
var
  sp,sh,ssh:string;
procedure draw;
var
  i:word;
  wp,wsh:extended;
begin
  wp:=speed/1000;
  str(wp:0:0,sp);
  wwy:=-wy/10000;
  str(wwy:0:0,sh);
  wsh:=angleh/pi*180;
  if wsh<>0 then
   wsh:=-wsh;
  str(wsh:0:2,ssh);
  setcolor(2);
  outtextxy(20,20,'Sp:'+sp+' km/h');
  outtextxy(500,20,'H:'+sh+' m');
  outtextxy(400,20,'Sh:'+ssh+' gr');
  if nvis=0 then
    delay(correcttime)
   else
    for i:=1 to nvis do
     if (px[i]>=0)and(px[i]<=639)and
        (py[i]>=0)and(py[i]<=479) then
      putpixel(word(px[i]),word(py[i]),pcolor[i]);
end;
function kill:boolean;
begin
  kill:=(abs(speed)>=maxspeedair)and(wy>=-minh*3)and
   ((wz>maxz)or(wz<0)or(wx<-maxx div 2)or(wx>maxx div 2));
  if fkill then
   kill:=true;
end;
var
  r:registers;
  f,soundf:boolean;
label m1;
begin
  initgraph(gd,gm,'c:\programs\bp\bgi');
  soundf:=false;
  m1:randomize;
  initpoints;
  oldx:=320;
  f:=true;
  angle:=0;
  cosa:=cos(angle);
  sina:=sin(angle);
  angleh:=0;
  cosh:=cos(angleh);
  sinh:=sin(angleh);
  initmouse;
  mx:=320;
  my:=240;
  speed:=0;
  repeat
    if soundf then
      if wy<-minh then
        sound(round(abs(speed)/minspeed*300+20))
       else
        sound(round(abs(speed)/minspeed*200+20))
     else
      nosound;
    oldbutt:=butt;
    getmousestate(butt,mx,my);
    if (butt=1)or(butt=3) then
     speed:=speed+speedz;
    if (butt=2)and((wy=-minh)or((wy<-minh)and(speed-speedz>=minspeed)))and
       not((oldbutt=2)and(speed=0)) then
     speed:=speed-speedz;
    c:=#0;
    if keypressed then
     c:=readkey;
    if c='=' then
     inc(d,10);
    if c='-' then
     dec(d,10);
    if c=#32 then
     soundf:=not soundf;
    if serve and $2<>0 then
     angleh:=angleh+dangleh;
    if serve and $4<>0 then
     angleh:=angleh-dangleh;
    if angleh<=-maxangleh then
     angleh:=-maxangleh;
    if angleh>=maxangleh then
     angleh:=maxangleh;
    if (angleh>0)and(wy=-minh) then
     angleh:=0;
    sinh:=sin(angleh);
    cosh:=cos(angleh);
    if oldx<>mx then
     begin
       angle:=angle-(mx-oldx)*pi/1000;
       sina:=sin(angle);
       cosa:=cos(angle);
       oldx:=mx;
       if (mx=0)or(mx=639) then
        begin
          r.ax:=4;
          r.cx:=320;
          r.dx:=my;
          oldx:=320;
          intr($33,r);
        end;
     end;
    speedp:=speed*cosh;
    if speedp<>0 then
     begin
       wx:=wx-speedp*sina;
       wz:=wz+speedp*cosa;
     end;
    speedh:=speed*sinh;
    if speedh<>0 then
     begin
       wwy:=wy+speedh;
       owy:=wy;
       if ((wy<-minh)or((wy=-minh)and(speed>=minspeed)))and(wwy<=-minh) then
         wy:=wwy
        else
           wy:=-minh;
       if (owy<-minh)and(wy=-minh) then
        begin
          if abs(angleh)>maxanglep then
           fkill:=true;
          angleh:=0;
          sinh:=0;
          cosh:=1;
        end;
     end;
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
    cleardevice;
    draw;
    f:=kill;
  until (c=#27)or f;
  if soundf then
   nosound;
  if f then
   begin
     fkill:=false;
     setcolor(12);
     outtextxy(300,220,'UOPS!');
     sound(5000);
     delay(50);
     sound(round(abs(speed)/minspeed*100+20));
     delay(100);
     nosound;
     outtextxy(300,240,'Press any key to continue...');
     readkey;
     cleardevice;
     goto m1;
   end;
  closegraph;
end.