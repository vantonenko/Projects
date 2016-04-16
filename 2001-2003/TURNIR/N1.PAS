{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+}
{$M 32767,0,655360}
program n1;
uses crt,graph;
const
  xc=320;
  yc=240;
  r=200;
  dl=0.1;
  ex=0.8;
  ex2=ex*ex;
  maxn=10000;
  temp=0;
label m1,m2;
type
  tm=record
   x,y:extended;
  end;
var
  mas:array[1..maxn]of ^tm;
  length,dal,dx,dy:extended;
  gd,gm:integer;
  m,i,ni:word;
  enable:boolean;
  sl:string;
  time:longint;
function fg(i:word):word;
begin
  if i>m then
    fg:=i-m
   else
    fg:=i;
end;
procedure fx(xn,yn,xn2,yn2:extended;var dx,dy:extended);
var
  d:extended;
begin
  d:=sqrt(sqr(xn2-xn)+sqr(yn2-yn));
  dx:=(xn2-xn)*dl/d;
  dy:=(yn2-yn)*dl/d;
end;
begin
m2:clrscr;
  gotoxy(35,12);
  write('Enter M("0"-quit):');
  readln(m);
  if m<8 then
   exit;
  gd:=0;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  setcolor(7);
  line(320,0,320,479);
  line(0,240,639,240);
  setcolor(2);
  circle(320,240,r+1);
  dal:=0;
  for i:=1 to m do
   begin
     new(mas[i]);
     mas[i]^.x:=320+r*sin(dal);
     mas[i]^.y:=240-r*cos(dal);
     dal:=dal+2*pi/m;
   end;
  length:=0;
  setcolor(12);
  while true do
   begin
     enable:=true;
     for i:=1 to m do
      with mas[i]^ do
       begin
         ni:=fg(i+2);
         if (i=m)and(i mod 2=1) then
          ni:=1;
         if (i=m-1)and((i+1) mod 2=1) then
          ni:=2;
         fx(x,y,mas[ni]^.x,mas[ni]^.y,dx,dy);
         x:=x+dx;
         y:=y+dy;
         enable:=enable and(sqr(x-320)+sqr(y-240)<=ex2);
         if getpixel(round(x),round(y))<>12 then
          if i=1 then
            putpixel(round(x),round(y),15)
           else
            if i=m-1 then
              line(round(x),round(y),round(x-dx),round(y-dy))
             else
              putpixel(round(x),round(y),3);
         if keypressed then
          goto m1;
       end;
     {delay(temp);}
     length:=length+dl;
     if enable then break;
   end;
  setcolor(10);
  length:=length/r;
  str(length:0:4,sl);
  settextstyle(0,0,3);
  outtextxy(10,10,'Время=R*'+sl+'/V сек.');
m1:readkey;
  closegraph;
  goto m2;
end.