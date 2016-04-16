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
  r:=sqrt(sqr(x-160)+sqr(y-100));
  {r:=r*sin(r+x);}
  {r:=x*cos(x)+y*cos(y)*r;}
  {color:=round(7*cos(r/1000)+8);}
  color:=round(31*cos(r/50)+32);
end;
{$f-}
procedure proc;
begin
end;
{$f+}
label m1;
begin
  gd:=installuserdriver('vga256',@proc);
  initgraph(gd,gm,'');
  cleardevice;
  for i:=1 to 63 do
   setrgbpalette(i,63,i,i);
  for y:=0 to getmaxy do
   for x:=0 to getmaxx do
    begin
      putpixel(x,y,color(x,y));
      if keypressed then
       goto m1;
    end;
m1:readkey;
  closegraph;
end.