program show;
uses crt,graph;
const
  dir=true;
  col:array[0..15]of byte=
      (0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
type
  trgb=record
    r,g,b:integer;
  end;
var
  gd,gm,i,j,x,y:integer;
  r,xx,yy:extended;
  b:byte;
  adr:word;
  palette:array[0..15]of trgb;
  s:trgb;
function color(xx,yy:integer):byte;
var
  x,y:extended;
begin
  x:=xx;
  y:=yy;
  r:=sqrt(sqr(x-320)+sqr(y-240));
  color:=round(r) mod 15+1;
end;
label m1;
begin
  gd:=0;
  initgraph(gd,gm,'d:\projects\segate\programs\bp\bgi');
  cleardevice;
  port[$3ce]:=5;
  port[$3cf]:=2;
  for i:=15 downto 1 do
   with palette[i] do
    begin
      r:=0+i;
      g:=0+i;
      b:=30+i;
      setrgbpalette(col[i],r,g,b);
    end;
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
  repeat
    for i:=1 to 15 do
     with palette[i] do
      setrgbpalette(col[i],r,g,b);
    delay(30);
    if dir then
      begin
        s:=palette[1];
        for i:=1 to 14 do
         palette[i]:=palette[i+1];
        palette[15]:=s;
      end
     else
      begin
        s:=palette[15];
        for i:=15 downto 2 do
         palette[i]:=palette[i-1];
        palette[1]:=s;
      end;
  until keypressed;
m1:readkey;
  closegraph;
end.