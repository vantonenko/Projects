uses graph,dos,crt,f_mouse;
const
  nfig=5;
  npoint=2;
  temp=10;
  spx=4;
  spy=4;
  spr=1;
  spg=1;
  spb=1;
  sr=10;
  sg=10;
  sb=10;
  rr=54;
  rg=54;
  rb=54;

  egacolors:array[0..15]of byte=
      (0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
type
  tpoint=record
    speedx,speedy,x,y:integer;
    dirx,diry:boolean;
  end;
  tfig=array[1..nfig,1..npoint]of tpoint;
var
  gd,gr,i,j:integer;
  fig,oldfig:tfig;
  colors:array[1..nfig]of byte;
  r,g,b:array[1..nfig]of extended;
  dirrgb:array[1..nfig,1..3]of boolean;
  exit:boolean;
procedure mouse(mask,butt,x,y,dx,dy:integer);far;
begin
  clearmousehandler;
  exit:=true;
end;
procedure clear(fig:tfig);
var
  i,j:integer;
begin
  for i:=1 to nfig do
   begin
     setcolor(0);
     for j:=2 to npoint do
      line(fig[i,j-1].x,fig[i,j-1].y,fig[i,j].x,fig[i,j].y);
     if npoint>2 then
      line(fig[i,1].x,fig[i,1].y,fig[i,npoint].x,fig[i,npoint].y);
     if npoint=1 then
      putpixel(fig[i,1].x,fig[i,1].y,0);
   end;
end;
procedure digit(var x:integer;sp,min,max:integer;var dir:boolean);
begin
  if dir then
    if x+sp>max then
      dir:=not dir
     else
      x:=x+sp
   else
    if x-sp<min then
      dir:=not dir
     else
      x:=x-sp;
end;
procedure digitr(var x:extended;sp,min,max:extended;var dir:boolean);
begin
  if dir then
    if x+sp>max then
      dir:=not dir
     else
      x:=x+sp
   else
    if x-sp<min then
      dir:=not dir
     else
      x:=x-sp;
end;
procedure move;
var
  i,j:integer;
  f1,f2:boolean;
begin
  for i:=1 to nfig do
   for j:=1 to npoint do
    with fig[i,j] do
     begin
       f1:=dirx;
       f2:=diry;
       digit(x,speedx,0,getmaxx,dirx);
       digit(y,speedy,0,getmaxy,diry);
       if f1<>dirx then
        speedx:=random(spx-1)+2;
       if f2<>diry then
        speedy:=random(spy-1)+2;
     end;
  for i:=1 to nfig do
   begin
     digitr(r[i],spr*random,20,63,dirrgb[i,1]);
     digitr(g[i],spg*random,20,63,dirrgb[i,2]);
     digitr(b[i],spb*random,20,63,dirrgb[i,3]);
   end;
end;
procedure draw;
var
  i,j:integer;
begin
  for i:=1 to nfig do
   begin
     setcolor(colors[i]);
     setrgbpalette(egacolors[i],round(r[i]),round(g[i]),round(b[i]));
     for j:=2 to npoint do
      line(fig[i,j-1].x,fig[i,j-1].y,fig[i,j].x,fig[i,j].y);
     if npoint>2 then
      line(fig[i,1].x,fig[i,1].y,fig[i,npoint].x,fig[i,npoint].y);
     if npoint=1 then
      putpixel(fig[i,1].x,fig[i,1].y,colors[i]);
   end;
end;
var
  path:string;
begin
  gd:=vga;
  gr:=vgamed;
  initgraph(gd,gr,'bgi');
  initmouse;
  setmousehandler(255,mouse);
  randomize;
  for i:=1 to nfig do
   for j:=1 to npoint do
    with fig[i,j] do
     begin
       x:=random(getmaxx);
       y:=random(getmaxy);
       speedx:=random(spx)+1;
       speedy:=random(spy)+1;
       if random(2)=0 then
         dirx:=false
        else
         dirx:=true;
       if random(2)=0 then
         diry:=false
        else
         diry:=true;
     end;
  for i:=1 to nfig do
   begin
     colors[i]:=i;
     r[i]:=sr+random(rr);
     g[i]:=sg+random(rg);
     b[i]:=sb+random(sb);
     setrgbpalette(egacolors[i],round(r[i]),round(g[i]),round(b[i]));
     for j:=1 to 3 do
      if random(2)=0 then
        dirrgb[i,j]:=false
       else
        dirrgb[i,j]:=true;
   end;
  draw;
  exit:=false;
  repeat
    oldfig:=fig;
    move;
    delay(temp);
    if exit then break;
    {clear(oldfig);}
    draw;
  until keypressed;
  if keypressed then
   if readkey=#0 then
    readkey;
  closegraph;
end.