uses graph,crt;
var
   gd,gm,x,y:integer;
begin
  gd:=0;
  initgraph(gd,gm,'..\bgi');
  readkey;
  for y:=0 to 479 do
    {for x:=0 to 639 do}
      line(0,y,639,y);
  readkey;
  closegraph;
end.