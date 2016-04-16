program lines_;
uses crt,graph;
var
  gd,gm:integer;
procedure lines(x1,x2,y:integer);
var
  xx1,xx2,yy:integer;
begin
  line(x1,y,x2,y);
  xx1:=x1;
  xx2:=x2;
  yy:=y;
  if y<479 then
   begin
     lines(xx1,(xx2-xx1) div 3+xx1,yy+10);
     lines(xx2-(xx2-xx1) div 3,xx2,yy+10);
   end;
end;
begin
  gd:=0;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  lines(0,639,0);
  readkey;
  closegraph;
end.