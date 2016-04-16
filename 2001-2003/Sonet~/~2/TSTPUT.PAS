uses graph;
var
  a,b:integer;
  m:array[1..32,1..32]of byte;
begin
  initgraph(a,b,'..\');
  setfillstyle(3,3);
  bar(0,0,639,479);
  readln;
  getimage(0,0,31,31,m);
  cleardevice;
  setviewport(0,0,620,460,false);
  putimage(600,450,m,0);
  readln
end.
