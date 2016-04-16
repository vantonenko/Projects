uses graph,crt,f_mouse;
const
  sizex=9;
  sizey=15;
var
  gd,gm,butt,x,y,ox,oy,i,j:integer;
  f:file;
  p,u:pointer;
  mas:array[1..sizex+1,1..sizey+1]of byte;
  a:extended;
procedure user(mask,butt,x,y,dx,dy:integer);far;
begin
  putimage(ox,oy,u^,0);
  getimage(x,y,x+sizex,y+sizey,u^);
  putimage(x,y,p^,2);
  {for j:=y to y+sizey do
   for i:=x to x+sizex do
    if mas[i-x+1,j-y+1]<>2 then
     putpixel(i,j,mas[i-x+1,j-y+1]);}
  ox:=x;
  oy:=y;
end;
begin
  gd:=0;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  assign(f,'..\settings\default.cur');
  rewrite(f,1);
  initmouse;
  getmousestate(butt,x,y);
  getmem(p,256);
  getmem(u,256);
  {setfillstyle(1,3);
  bar(0,0,639,479);}
  showmouse;
  for j:=y to y+sizey do
   for i:=x to x+sizex do
    if (getpixel(i,j)=0)and
      ((getpixel(i-1,j)=15)or(getpixel(i+1,j)=15)) then
     putpixel(i,j,8);
  getimage(x,y,x+sizex,y+sizey,p^);
  {for j:=y to y+sizey do
   for i:=x to x+sizex do
    mas[i-x+1,j-y+1]:=getpixel(i,j);}
  hidemouse;
  setfillstyle(1,3);
  bar(0,0,639,479);
  {repeat
    setcolor(random(16));
    line(random(640),random(480),random(640),random(480));
  until keypressed;readkey;}
  getimage(x,y,x+sizex,y+sizey,u^);
  ox:=x;
  oy:=y;
  ox:=x;oy:=y;
  for j:=1 to sizey+1 do
   for i:=1 to sizex+1 do
    case mas[i,j] of
     8:mas[i,j]:=0;
     0:mas[i,j]:=2;
    end;
  setmousehandler(1,user);
  a:=0;
  repeat
    {setcolor(3);
    line(500,400,500+round(50*cos(a)),400+round(50*sin(a)));
    setcolor(12);
    a:=a+pi/1000;
    if a>2*pi then
     a:=a-2*pi;
    line(500,400,500+round(50*cos(a)),400+round(50*sin(a)));}
  until keypressed;
  clearmousehandler;
end.