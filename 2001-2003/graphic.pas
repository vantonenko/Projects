program graphic;
uses crt,graph,f_mouse;
const
  size:word=0;
  mode:word=3;
  modes:array[1..9]of word=(80,40,20,10,8,5,4,2,1);
  shx:integer=0;
var
  gd,gm,i,colx,coly,k,n:integer;
  x1,y1,s:extended;
  scale:word absolute size;
  c:char;
  oldv:boolean;
  A : array[1..101] of real;
const
  visible:boolean=true;
function f(x:extended):extended;
var
  s:extended;
  n, m, k:integer;
begin
  {f:=sin(x*sin(x*10));}
  f:=(sin(x)+3)*sin(x*10);
  {f:=5*sin(x/3)+0.3*cos(x*10);}
  {m := round((x + 16))+1;
  f := A[m];}
end;
label m1;
begin
  gd:=0;
  A[1]:=0;
  A[2]:=2;
  for n:=3 to 101 do
  begin
    s:=0;
    k:=2;
    while (k<n) do
    begin
      s:=s+A[k]/((n-k)*(n-k+1));
      k:=k+1;
    end;
    A[n]:=(n+n*s)/(n-1);
  end;
  initgraph(gd,gm,'..\bp\bgi');
  setrgbpalette(7,32,32,32);
m1:setcolor(7);
  size:=modes[mode];
  colx:=640 div size;
  coly:=480 div size;
  for i:=1 to colx-1 do
   line(i*size,0,i*size,479);
  for i:=1 to coly-1 do
   line(0,i*size,639,i*size);
  setcolor(11);
  line(0,240,639,240);
  line(320,0,320,479);
  line(639,240,633,242);
  line(639,240,633,238);
  line(320,0,322,6);
  line(320,0,318,6);
  setcolor(12);
  i:=0;
  x1:=i/scale-colx div 2;
  y1:=coly div 2-f(x1+shx);
  moveto(i*size div scale,round(y1*size));
  for i:=0 to (colx)*scale do
   begin
     x1:=i/scale-colx div 2;
     oldv:=visible;
     visible:=true;
     y1:=coly div 2-f(x1+shx);
     if y1<0 then
      y1:=-1;
     if y1>coly then
      y1:=coly+1;
     if visible then
       if oldv then
         lineto(i*size div scale,round(y1*size))
        else
         moveto(i*size div scale,round(y1*size));
   end;
  setcolor(11);
  line(0,240,639,240);
  line(320,0,320,479);
  line(320,0,322,6);
  line(320,0,318,6);
  setcolor(15);
  settextstyle(0,0,1);
  outtextxy(607,230,'t,c');
  outtextxy(323,7,'I,A');
  showmouse;
  repeat
    repeat
     c:=readkey;
    until (c in ['a','q','4','6',#27])and not(((c='q')and(mode=1))or((c='a')and(mode=9)));
    case c of
     'q':mode:=mode-1;
     'a':mode:=mode+1;
     '4':shx:=shx+1;
     '6':shx:=shx-1;
    end;
  until not keypressed;
  cleardevice;
  if c<>#27 then
   goto m1;
  closegraph;
end.