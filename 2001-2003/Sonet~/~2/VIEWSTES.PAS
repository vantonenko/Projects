uses graph,mouse,views,crt,gdi,rect;
const
  speed=500;
var
  a,b:integer;
  f:boolean;
  m:array[1..32,1..32]of byte;
procedure handlemous(event:tevent);far;
begin
end;
var
  r1,r2:trect;
begin
  if not gdi.initgraph then
   exit;
  bar(0,0,639,479,15);
  mousehandleron(handlemous);
  showmouse;
  setdoublespeed(speed);
  setmousespeed(7,7);
  {r1.assign(100,155,155,230);
  r2.assign(130,130,200,200);
  setcolor(0);
  setoxy(100,100);
  setviewport(130,130,280,320);
  rectangle(r1.a.x,r1.a.y,r1.b.x,r1.b.y);
  rectangle(r2.a.x,r2.a.y,r2.b.x,r2.b.y);
  r2.union(r1);
  setcolor(4);
  rectangle(r2.a.x,r2.a.y,r2.b.x,r2.b.y);}
  repeat
    putpixel(random(640),random(480),random(16));
  until keypressed ;
  getimage(0,0,31,31,m);
  cleardevice;
  gdi.setviewport(100,100,639,479);
  gdi.putimage(0,0,m);
  setcolor(40);
  line(0,0,10,10);
  readkey;
  if ord(readkey)=0 then
   if ord(readkey)=0 then;
  hidemouse;
  mousehandleroff;
  closegraph;
end.