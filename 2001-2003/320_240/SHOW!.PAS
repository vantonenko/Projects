program show;
uses crt,grafixx;
const
  maxcol=255;
  dir=false;
  speed=1;
  dr:extended=0;
  dg:extended=2*pi/3;
  db:extended=4*pi/3;
type
  trgb=record
    r,g,b:byte;
  end;
var
  gd,gm,i,j,x,y:integer;
  r,rr,xx,yy:extended;
  b:byte;
  adr:word;
function arct(x,y:extended):extended;
var
  r:extended;
begin
  if x>0 then
    r:=arctan(y/x)
   else
    if x<0 then
      r:=arctan(y/x)+pi
     else
      if y>=0 then
        r:=pi/2
       else
        r:=3*pi/2;
  r:=r+pi;
  while r>2*pi do
   r:=r-2*pi;
  r:=40.584544769*r;
  arct:=r;
end;
function color(xx,yy:integer):byte;
var
  x,y,d:extended;
begin
  x:=xx-getmaxx div 2;
  y:=-yy+getmaxy div 2;
  d:=sqrt(sqr(x)+sqr(y));
  color:=abs(round(d*sin(x*y))) mod maxcol+1;
end;
var
  s,palette:array[1..maxcol] of trgb;
  c:char;
  ncadr,t:longint;
  e:extended;
  mid:word;
label m1;
begin
  gd:=0;
  initgraphx;
  clearscreenx(0);
  randomize;
  mid:=(maxcol+1) div 2;
  for i:=1 to maxcol do
   with palette[i] do
    begin
      r:=round(31.5*cos(pi*i/mid+dr)+31.5);
      g:=round(31.5*cos(pi*i/mid+dg)+31.5);
      b:=round(31.5*cos(pi*i/mid+db)+31.5);
      setcrgb(i,r,g,b);
    end;
  for y:=0 to getmaxy do
   for x:=0 to getmaxx do
    begin
      putpixelx(x,y,color(x,y));
      if keypressed then
       begin
         readkey;
         goto m1;
       end
    end;
m1:t:=meml[$0040:$006c];
  ncadr:=0;
  {repeat
    c:=readkey;
    case c of
     'a':dr:=dr+pi/50;
     'q':dr:=dr-pi/50;
     'w':dg:=dg+pi/50;
     's':dg:=dg-pi/50;
     'e':db:=db+pi/50;
     'd':db:=db-pi/50;
    end;
    for i:=1 to maxcol do
     with palette[i] do
      begin
        r:=round(31.5*cos(pi*i/mid+dr)+31.5);
        g:=round(31.5*cos(pi*i/mid+dg)+31.5);
        b:=round(31.5*cos(pi*i/mid+db)+31.5);
        setcrgb(i,r,g,b);
      end;
  until c=#27;}
  readkey;
  repeat
    inc(ncadr);
    waitretrace;
    for i:=1 to maxcol do
     with palette[i] do
      setcrgb(i,r,g,b);
    if dir then
      begin
        for i:=1 to speed do
         s[i]:=palette[i];
        for i:=1 to maxcol-speed do
         palette[i]:=palette[i+speed];
        for i:=1 to speed do
         palette[maxcol-speed+i]:=s[i];
      end
     else
      begin
        for i:=1 to speed do
         s[i]:=palette[maxcol-speed+i];
        for i:=maxcol downto speed+1 do
         palette[i]:=palette[i-speed];
        for i:=1 to speed do
         palette[i]:=s[i];
      end;
    if keypressed then
     begin
       c:=readkey;
       if c=#27 then
        break;
       readkey;
     end;
  until false;
  e:=ncadr*18.2/(meml[$0040:$006c]-t-1);
  closegraphx;
  writeln(e:0:2);
end.