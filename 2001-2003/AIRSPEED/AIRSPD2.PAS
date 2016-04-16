program airspd2;
uses crt,graph,f_mouse,dos,timerman;
const
  ncadr=10;{1/с,количество кадров}
  temp=1000 div ncadr;
  m=50;{кол-во точек образующих поверхность Земли}
  n=180;{кол-во точек образующих аэропорт}
  s=100;{кол-во точек образующих небо}
  d:longint=320;{фокусное расстояние линз наблюдателя}
  minh=100;{sm,минимальная высота}
  {--------------}
  aspeed=200;{см/с^2,ускорение}
  airspeed=19500;{см/с,минимальная скорость при полёте}
  dangle=pi/900;{рад/с}
  inercia=0.2;{см/с}
  inera=500;
  {--------------}
  speedz:longint=aspeed div ncadr;
  maxangleh=pi/2;{рад,максимальный угол взлёта}
  maxanglep=pi/90;{рад,максимальный угол посадки}
  dangleh=dangle/ncadr;{рад,прирост угла взлёта}
  minspeed=airspeed div ncadr;
  maxspeedair=1000 div ncadr;{см/с,максимальная скорость ёзды вне}
  maxx=2000;{см,ширина аэропорта}
  maxz=300000;{см,длина аэропорта}
  maxvisible=100000000000.0;{}
  maxxfield=500000;
  maxzfield=500000;
  maxxsky=50000000;
  maxzsky=50000000;
  hsky=500000;
  dsky=1000000;
  {mindplightair=maxz*63;}
  k=4;
var
  timer:longint absolute $0000:$046c;
  t,t1,cadr:longint;
  x,y,z:array[1..n+m+s]of extended;
  px,py:array[1..n+m+s]of longint;
  pcolor,color:array[1..n+m+s]of byte;
  gd,gm:integer;
  xx,yy:longint;
  ddangleh,inerspeed,oldangleh:extended;
  x1,z1,y1,z11,wx,owy,wxx,wyy,wzz,wwy,wy,wz,sina,cosa,angle,speedh,speedp,angleh,sinh,cosh:extended;
  i,nvis:word;
  butt,oldbutt,mx,my,oldx:integer;
  c:char;
  speed:longint;
  serve:byte absolute $0000:$0417;
  fkill:boolean;
procedure initpoints;
var
  i:word;
  mz,dz:extended;
begin
  wx:=0;
  wy:=-minh;
  wz:=0;
  mz:=maxz;
  dz:=maxz/(n*3 div 7)/k;
  for i:=1 to n*3 div 7 do
   begin
     x[i]:=-(maxx div 2);
     y[i]:=0;
     z[i]:=mz*i/(n*3 div 7);
     if i mod 2=0 then
       z[i]:=z[i]+dz
      else
       z[i]:=z[i]-dz;
     color[i]:=15;
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
     if i mod 2=0 then
       z[i]:=z[i]+dz
      else
       z[i]:=z[i]-dz;
     color[i]:=15;
   end;
  for i:=1 to m do
   begin
     x[i+n]:=maxxfield*random-maxxfield/2;
     y[i+n]:=0;
     z[i+n]:=random*maxzfield-maxzfield/2;
     color[i+n]:=10;
   end;
  for i:=1 to s do
   begin
     x[i+n+m]:=maxxsky*random-maxxsky/2;
     y[i+n+m]:=-dsky*random-hsky;
     z[i+n+m]:=random*maxzsky-maxzsky/2;
     color[i+n+m]:=9;
   end;
end;
var
  sp,sh,ssh:string;
  smaxx,smaxy,smaxx2,smaxy2:integer;
procedure draw;
var
  i:word;
  wp,wsh:extended;
begin
  wp:=speed*ncadr*3.6/100;
  str(wp:0:0,sp);
  wwy:=-(minh+wy)/100;
  str(wwy:0:0,sh);
  if sh='-0' then
   sh:='0';
  wsh:=angleh/pi*180;
  if wsh<>0 then
   wsh:=-wsh;
  str(wsh:0:2,ssh);
  if (abs(wsh)<0.01)and(ssh[1]='-') then
   delete(ssh,1,1);
  setcolor(2);
  outtextxy(20,20,'Speed:'+sp+' km/h');
  outtextxy(500,20,'High:'+sh+' m');
  outtextxy(380,20,'Angle:'+ssh+#248);
  setcolor(12);
  if abs(angleh)<0.01 then
    outtextxy(370,20,#15)
   else
    if angleh>0 then
      outtextxy(370,20,#31)
     else
      outtextxy(370,20,#30);
  if speed>=minspeed then
    outtextxy(10,20,#2)
   else
    outtextxy(10,20,#33);
  for i:=1 to nvis do
   if (px[i]>=0)and(px[i]<=smaxx)and
     (py[i]>=0)and(py[i]<=smaxy) then
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
  page,light:byte;
  dd:extended;
label m1;
begin
  gd:=vga;
  gm:=vgamed;
  initgraph(gd,gm,'');
  smaxx:=getmaxx;
  smaxy:=getmaxy;
  smaxx2:=smaxx div 2+1;
  smaxy2:=smaxy div 2+1;
  soundf:=false;
  m1:randomize;
  initpoints;
  oldx:=smaxx2;
  f:=true;
  angle:=0;
  cosa:=cos(angle);
  sina:=sin(angle);
  angleh:=0;
  cosh:=cos(angleh);
  sinh:=sin(angleh);
  initmouse;
  mx:=smaxx2;
  my:=smaxy2;
  speed:=0;
  page:=0;
  t:=timer;
  cadr:=0;
  initdelay(0);
  ddangleh:=0;
  repeat
    inc(cadr);
    setactivepage(page);
    setvisualpage(1-page);
    donedelay;
    initdelay(temp);
    {dd:=sqrt(sqr(wy)+sqr(wz)+sqr(wx));
    if dd<maxz then
      light:=63
     else
      light:=round(63/dd*maxz);
    setrgbpalette(15,light,light,light);}
    page:=1-page;
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
    oldangleh:=angleh;
    if (serve and $6<>0)and(speed>=minspeed) then
      ddangleh:=ddangleh+dangleh
     else
      ddangleh:=0;
    if serve and $2<>0 then
     angleh:=angleh+ddangleh;
    if serve and $4<>0 then
     angleh:=angleh-ddangleh;
    if angleh<=-maxangleh then
     angleh:=-maxangleh;
    if angleh>=maxangleh then
     angleh:=maxangleh;
    if ((angleh>0)and(wy=-minh))or(speed<minspeed) then
     angleh:=0;
    sinh:=sin(angleh);
    cosh:=cos(angleh);
    if oldx<>mx then
     begin
       angle:=angle-(mx-oldx)*pi/1000;
       sina:=sin(angle);
       cosa:=cos(angle);
       oldx:=mx;
       if (mx=0)or(mx=smaxx) then
        begin
          r.ax:=4;
          r.cx:=smaxx2;
          r.dx:=my;
          oldx:=smaxx2;
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
    if (oldangleh=0)and(angleh>0)then
     inerspeed:=-inercia*speedh;
    if speedh<>0 then
     begin
       wwy:=wy+speedh{+inerspeed};
       owy:=wy;
       if ((wy<-minh)or((wy=-minh)and(speed>=minspeed)))and(wwy<=-minh) then
         wy:=wwy
        else
           wy:=-minh;
       if (owy<-minh)and(wy=-minh) then
        begin
          if abs(angleh)-0.01>maxanglep then
            fkill:=true
           else
            angleh:=0;
          sinh:=0;
          cosh:=1;
        end;
     end;
    nvis:=0;
    for i:=1 to n+m+s do
     begin
       wxx:=x[i]-wx;
       wyy:=y[i]-wy;
       wzz:=z[i]-wz;
       x1:=wzz*sina+wxx*cosa;
       z1:=wzz*cosa-wxx*sina;
       z11:=z1*cosh+wyy*sinh;
       y1:=wyy*cosh-z1*sinh;
       z1:=z11;
       if (z1>0)and(z1<maxvisible) then
        begin
          inc(nvis);
          xx:=round(x1*d/(z1+d));
          yy:=round(y1*d/(z1+d));
          px[nvis]:=longint(xx)+smaxx2;
          py[nvis]:=longint(yy)+smaxy2;
          pcolor[nvis]:=color[i];
        end;
     end;
    cleardevice;
    draw;
    f:=kill;
    if inerspeed<0 then
     inerspeed:=inerspeed+inera div ncadr;
  until (c=#27)or(c=#9)or f;
  t1:=timer;
  if soundf then
   nosound;
  if f then
   begin
     setvisualpage(1-page);
     fkill:=false;
     setcolor(12);
     outtextxy(300,220,'UOPS!!');
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
  writeln('Ncadr:',cadr/(t1-t)*18.2:0:1);
  readln;
  clrscr;
end.