program lines;
uses graph,crt;
var
  gd,gm:integer;
begin
  gd:=0;
  initgraph(gd,gm,'d:\projects\segate\programs\bp\bgi');
  repeat
    setcolor(random(8)+1);
    line(320,240,random(640),random(480));
  until keypressed;
  closegraph;
end.