program soundeffect;
uses crt;
const
  dx=100000;
var
  x:extended;
function frec(max,min:integer;x:extended):integer;
begin
  frec:=round((max-min) div 2*sin(x)+min+(max-min) div 2);
end;
begin
  clrscr;
  x:=0;
  repeat
    sound(frec(2000,400,x*10)+frec(0,200,x*1000));
    x:=x+pi/dx;
  until keypressed;
  nosound;
end.