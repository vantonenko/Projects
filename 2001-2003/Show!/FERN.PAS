program fern;
uses graph,crt;
var
  ch:char;
procedure draw;
const
  interations=50000;
var
  t,x,y,p:real;
  k:longint;
  midx,midy,radius:integer;
begin
  midx:=getmaxx div 2;
  midy:=getmaxy;
  radius:=trunc(0.1*midy);
  randomize;
  x:=1.0;
  y:=0.0;
  for k:=1 to interations do
   begin
     p:=random;
     t:=x;
     if p<=0.85 then
       begin
         x:=0.85*x+0.04*y;
         y:=-0.04*t+0.85*y+1.6;
       end
      else
       if p<=0.92 then
         begin
           x:=0.20*x-0.26*y;
           y:=0.23*t+0.22*y+1.6;
         end
        else
         if p<=0.99 then
           begin
             x:=-0.15*x+0.28*y;
             y:=0.26*t+0.24*y+0.44;
           end
          else
           begin
             x:=0.0;
             y:=0.16*y;
           end;
     putpixel(midx+round(radius*x),midy-round(radius*y),lightgreen);
   end;
end;
var
  gd,gm,i:integer;
begin
  gd:=0;
  initgraph(gd,gm,'d:\projects\segate\programs\bp\bgi');
  draw;
  ch:=readkey;
  for i:=57 downto 30 do
   begin
     setrgbpalette(egalightgreen,0,i,0);
     delay(50);
   end;
  closegraph;
end.