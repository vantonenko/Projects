program airspd3;
uses crt,graph,f_mouse,dos,timerman;
const
  ncadr=10;{1/�,������⢮ ���஢}
  temp=1000 div ncadr;
  m=1000;{���-�� �祪 ��ࠧ���� �����孮��� �����}
  n=1800;{���-�� �祪 ��ࠧ���� ��ய���}
  s=1000;{���-�� �祪 ��ࠧ���� ����}
  d:longint=500;{䮪�᭮� ����ﭨ� ���� ����⥫�}
  minh=1000;{��,�������쭠� ����}
  ver=200;{����⭮��� ��ᢥ稢���� ������}
  {--------------}
  aspeed=10;{��/�^2,��������� �᪮७��}
  airspeed=95000;{��/�,�������쭠� ᪮���� �� �����}
  maxairspeed=1000000000;{��/�,���ᨬ��쭠� ᪮����}
  dangle=pi/4500;{ࠤ/�}
  {--------------}
  speedz:extended=aspeed/ncadr;
  maxangleh=pi/2;{ࠤ,���ᨬ���� 㣮� �����}
  maxanglep=pi/90;{ࠤ,���ᨬ���� 㣮� ��ᠤ��}
  dangleh=dangle/ncadr;{ࠤ,����� 㣫� �����}
  minspeed=airspeed div ncadr;
  maxspeedair=10000 div ncadr;{��/�,���ᨬ��쭠� ᪮���� �� ���}
  maxspeed=maxairspeed div ncadr;
  maxx=20000;{��,�ਭ� ��ய���}
  maxz=4000000;{��,����� ��ய���}
  slength=20000;
  maxasp=pi/4*5000/ncadr;
  maxvisible=100000000000.0;{}
  maxxfield=50000000;
  maxzfield=50000000;
  maxxsky=500000000;
  maxzsky=500000000;
  hsky=5000000;
  dsky=10000000;
  k=4;
type
  ppoint=^tpoint;
  tpoint=record
    x,y,z:extended;
    color:byte;
  end;
var
  timer:longint absolute $0000:$046c;
  t,cadr:longint;
  point:array[1..n+m+s]of ppoint;
  px,py:array[1..n+m+s]of longint;
  pcolor:array[1..n+m+s]of byte;
  gd,gm:integer;
  xx,yy:longint;
  ddangleh,daspeed,oldangleh:extended;
  x1,z1,y1,z11,wx,owy,wxx,wyy,wzz,wwy,wy,wz,sina,cosa,angle,speedh,speedp,angleh,sinh,cosh:extended;
  i,nvis:word;
  butt,oldbutt,mx,my,oldx:integer;
  c:char;
  speed:extended;
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
  for i:=1 to m+n+s do
   new(point[i]);
  for i:=1 to n*3 div 7 do
   with point[i]^ do
   begin
     x:=-(maxx div 2);
     y:=0;
     z:=mz*i/(n*3 div 7);
     if i mod 2=0 then
       z:=z+dz
      else
       z:=z-dz;
     color:=15;
   end;
  for i:=n*3 div 7+1 to n*4 div 7 do
   with point[i]^ do
   begin
     x:=0;
     y:=0;
     z:=mz*(i-n*3 div 7)/(n div 7);
     color:=11;
   end;
  for i:=n*4 div 7+1 to n do
   with point[i]^ do
   begin
     x:=maxx div 2;
     y:=0;
     z:=mz*(i-n*4 div 7)/(n*3 div 7);
     if i mod 2=0 then
       z:=z+dz
      else
       z:=z-dz;
     color:=15;
   end;
  for i:=1 to m do
   with point[i+n]^ do
   begin
     x:=maxxfield*random-maxxfield/2;
     y:=0;
     z:=random*maxzfield-maxzfield/2;
     color:=10;
   end;
  for i:=1 to s do
   with point[i+n+m]^ do
   begin
     x:=maxxsky*random-maxxsky/2;
     y:=-dsky*random-hsky;
     z:=random*maxzsky-maxzsky/2;
     color:=9;
   end;
end;
var
  sp,sh,ssh,scadr:string;
  smaxx,smaxy,smaxx2,smaxy2:integer;
procedure draw;
var
  i:word;
  wp,wsh:extended;
begin
  wp:=speed*ncadr*3.6/1000;
  str(wp:0:2,sp);
  wwy:=-(minh+wy)/1000;
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
  {str(cadr/(timer-t)*18.2:0:3,scadr);
  outtextxy(590,300,scadr);}
  outtextxy(20,20,'Speed:'+sp+' km/h');
  outtextxy(500,20,'High:'+sh+' m');
  outtextxy(380,20,'Angle:'+ssh+#248);
  setcolor(3);
  rectangle(0,0,getmaxx,getmaxy);
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
label m1,m2;
begin
m2:gd:=vga;
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
  mx:=smaxx2;
  my:=smaxy2;
  speed:=0;
  page:=0;
  cadr:=0;
  initdelay(1);
  ddangleh:=0;
  daspeed:=0;
  repeat
    inc(cadr);
    setactivepage(page);
    setvisualpage(1-page);
    if cadr=1 then
     begin
       initmouse;
       t:=timer;
     end;
    donedelay;
    initdelay(temp);
    page:=1-page;
    oldbutt:=butt;
    getmousestate(butt,mx,my);
    if (butt=1)or(butt=3) then
     daspeed:=daspeed+speedz*(1+1000*ord(serve and $8<>0));
    if (butt=2)and((wy=-minh)or((wy<-minh)and(speed-daspeed>=minspeed)))and
       not((oldbutt=2)and(speed=0)) then
     daspeed:=daspeed-speedz*(1+1000*ord(serve and $8<>0));
    if (oldbutt=2)and(butt=2)and(speed+daspeed<0) then
      speed:=0
     else
      if butt and $3<>0 then
        if (speed+daspeed<minspeed)and(speed>=minspeed)and(wy<-minh) then
          begin
            speed:=minspeed;
            daspeed:=0;
          end
         else
          speed:=speed+daspeed
       else
        daspeed:=0;
    if speed>maxspeed then
     speed:=maxspeed;
    c:=#0;
    if keypressed then
     c:=readkey;
    if c='=' then
     inc(d,10);
    if c='-' then
     dec(d,10);
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
    if (mx<>smaxx2)and(speed<>0) then
     begin
       angle:=angle-speedp*sin((mx-smaxx2)*(maxasp/speed)/smaxx2)/slength;{angle-(mx-smaxx2)*pi/70000;}
       sina:=sin(angle);
       cosa:=cos(angle);
     end;
    oldx:=mx;
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
     with point[i]^ do
     begin
       wxx:=x-wx;
       wyy:=y-wy;
       wzz:=z-wz;
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
          pcolor[nvis]:=color;
          if random(ver)=0 then
           case pcolor[nvis] of
            10:pcolor[nvis]:=14;
             9:pcolor[nvis]:=1;
           end;
        end;
     end;
    cleardevice;
    draw;
    f:=kill;
  until (c=#27)or(c=#9)or f;
  if c=#9 then
   begin
     setvisualpage(1-page);
     cleardevice;
     goto m1;
   end;
  if soundf then
   nosound;
  if f then
   begin
     setactivepage(page);
     cleardevice;
     delay(200);
     initdelay(50);
     setbkcolor(12);
     donedelay;
     setbkcolor(0);
     delay(200);
     setvisualpage(1-page);
     setactivepage(1-page);
     fkill:=false;
     setcolor(12);
     delay(50);
     outtextxy(300,220,'UOPS!!');
     delay(50);
     outtextxy(300,240,'Press any key to continue...');
     readkey;
     cleardevice;
     goto m1;
   end;
  setactivepage(0);
  cleardevice;
  setactivepage(1);
  cleardevice;
  closegraph;
  clrscr;
end.