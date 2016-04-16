uses graph,dos,crt,f_mouse;
const
  nfig=5;
  npoint=2;
  temp=10;
  spx=5;
  spy=5;
  spr=1;
  spg=1;
  spb=1;
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
  rgb:array[1..3{,1..nfig}]of integer;
  exitf:boolean;
procedure mouse(mask,butt,x,y,dx,dy:integer);far;
begin
  clearmousehandler;
  exitf:=true;
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
     line(fig[i,1].x,fig[i,1].y,fig[i,npoint].x,fig[i,npoint].y);
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
end;
procedure draw;
var
  i,j:integer;
begin
  for i:=1 to nfig do
   begin
     setcolor(colors[i]);
     setrgbpalette(i,rgb[1],rgb[2],rgb[3]);
     for j:=2 to npoint do
      line(fig[i,j-1].x,fig[i,j-1].y,fig[i,j].x,fig[i,j].y);
     line(fig[i,1].x,fig[i,1].y,fig[i,npoint].x,fig[i,npoint].y);
   end;
end;
procedure generation(j,n2:byte);
var
  i:byte;
begin
  if (j=4)or keypressed or exitf then
   begin
     oldfig:=fig;
     move;
     delay(temp);
     clear(oldfig);
     draw;
     exit;
   end;
  for i:=n2 downto 0 do
   begin
     rgb[j]:=i;
     generation(j+1,63-i);
   end;
end;
var
  path:string;
begin
  getdir(0,path);
  {chdir('c:\programs\dosnav\ssavers');}
  initgraph(gd,gr,'');
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
     rgb[1{,i}]:={random(64)}63;
     rgb[2{,i}]:={random(64-rgb[1,i])}63;
     rgb[3{,i}]:=63{-rgb[1,i]-rgb[2,i]};
     setrgbpalette(i,rgb[1{,i}],rgb[2{,i}],rgb[3{,i}]);
   end;
  draw;
  exitf:=false;
  repeat
    generation(1,63);
  until keypressed or exitf;
  if keypressed then
   if readkey=#0 then
    readkey;
  closegraph;
  chdir(path);
end.