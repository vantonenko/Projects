unit gdi;
{-------}
interface
{-------}
uses rect;
function initgraph:boolean;
procedure setoxy(x,y:integer);{"global"}
procedure setviewport(x1,y1,x2,y2:integer);{"global"}
procedure setbaseview(r:trect);
procedure setmaxbaseview;
procedure putimage(x,y:integer;var buff);
procedure putpixel(x,y:integer;color:word);
procedure bar(x1,y1,x2,y2:integer;color:word);
procedure setcolor(color:word);
procedure rectangle(x1,y1,x2,y2:integer);
procedure closegraph;
{------------}
implementation
{------------}
uses graph;
const
  ox:integer=0;
  oy:integer=0;
  wx1:integer=0;
  wy1:integer=0;
  wx2:integer=639;
  wy2:integer=479;
var
  baseview:trect;
function px(x:integer):integer;
begin
  px:=ox+x-wx1;
end;
function py(y:integer):integer;
begin
  py:=oy+y-wy1;
end;
function initgraph;
var
  a,b:integer;
begin
  a:=detect;
  graph.initgraph(a,b,'');
  if graphresult<>0 then
    initgraph:=false
   else
    initgraph:=true;
end;
procedure setoxy;
begin
  ox:=x;
  oy:=y;
end;
procedure setviewport;
var
  r:trect;
begin
  r.a.x:=x1;
  r.a.y:=x2;
  r.b.x:=y1;
  r.b.y:=y2;
  {r.inter(baseview);}
  graph.setviewport(r.a.x,r.a.y,r.b.x,r.b.y,true);
end;
procedure setbaseview;
begin
  baseview:=r;
end;
procedure setmaxbaseview;
begin
  baseview.a.x:=0;
  baseview.a.y:=0;
  baseview.b.x:=639;
  baseview.b.y:=479;
end;
procedure putpixel;
begin
  graph.putpixel(px(x),py(y),color);
end;
procedure bar;
begin
  setfillstyle(1,color);
  graph.bar(px(x1),py(y1),px(x2),py(y2))
end;
procedure setcolor;
begin
  graph.setcolor(color);
end;
procedure rectangle;
begin
  graph.rectangle(px(x1),py(y1),px(x2),py(y2));
end;
procedure putimage;
begin
  graph.putimage(px(x),py(y),buff,0);
end;
procedure closegraph;
begin
  graph.closegraph;
end;
begin
  setmaxbaseview;
end.
