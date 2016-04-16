program new;
uses grafixx,crt;
var
  i:integer;
begin
  initgraphx;
  for i:=1 to 255 do
   setcrgb(i,i mod 64,i div 4,i div 4);
  for i:=1 to 255 do
   linehx(0,i,320,i);
  readkey;
  closegraphx;
end.