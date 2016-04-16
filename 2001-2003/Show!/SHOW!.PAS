program show;
uses crt,graph;
const
  col:array[0..15]of byte=
      (0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
var
  gd,gm,i,j,x,y:integer;
  r,xx,yy:extended;
  b:byte;
  adr:word;
function color(xx,yy:integer):byte;
var
  x,y:extended;
begin
  x:=xx;
  y:=yy;
  r:=sqrt(sqr(x-320)+sqr(y-240));
  r:=r*sin(r+x);
  {r:=x*cos(x)+y*cos(y)*r;
  color:=round(7*cos(r/1000)+8);}
  color:=round(7*cos(r/50)+8);
end;
procedure moveimage;
var
  yy,y,x:longint;
begin
  port[$3ce]:=5;
  port[$3cf]:=1;
  yy:=240*80;
  for y:=239 downto 0 do
   begin
     yy:=yy-80;
     for x:=39 downto 0 do
      mem[sega000:yy+80*80+x+10]:=
       mem[sega000:yy+x];
   end;
end;
label m1;
begin
  gd:=0;
  initgraph(gd,gm,'d:\projects\segate\programs\bp\bgi');
  cleardevice;
  port[$3ce]:=5;
  port[$3cf]:=2;
  for i:=1 to 15 do
   setrgbpalette(col[i],0,30+i,30+i);
  for y:=0 to getmaxy do
   for x:=0 to getmaxx do
    begin
      adr:=word(y shl 6)+word(y shl 4)+word(x div 8);
      port[$3ce]:=8;
      port[$3cf]:=128 shr (x mod 8);
      b:=mem[sega000:adr];
      mem[sega000:adr]:=color(x,y);
      if keypressed then
       goto m1;
    end;
  readkey;
  moveimage;
m1:readkey;
  for j:=29 downto 0 do
   begin
     for i:=1 to 15 do
      setrgbpalette(col[i],0,j+i,j+i);
     delay(10);
     if keypressed then
      begin
        closegraph;
        exit;
      end;
   end;
  closegraph;
end.