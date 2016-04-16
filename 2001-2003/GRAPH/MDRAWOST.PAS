program mdrawost;
uses mouse,views,graph,crt;
const
  maxn=100;
  maxint2=maxint*maxint*2;
var
  a:array[1..maxn,1..maxn]of longint;
  n,i,j,k,imin,jmin:word;
  x,y:array[1..maxn]of integer;
  gd,gr:integer;
  v:array[1..maxn]of byte;
  xi,yi,xj,yj,min:longint;
  busy:boolean;
  c:char;
  sx,sy,oldsx,oldsy:string;
procedure drawxy;
begin
  str(mousewhere.x,sx);
  str(mousewhere.y,sy);
  setcolor(0);
  hidemouse;
  outtextxy(10,447,oldsx+' '+oldsy);
  setcolor(15);
  outtextxy(10,447,sx+' '+sy);
  showmouse;
  oldsx:=sx;
  oldsy:=sy;
end;
procedure handler(event:tevent);far;
begin
  if (mousewhere.x=639)and(mousewhere.y=0) then halt;
  if busy then
   exit;
  if event.what and evmousemove<>0 then
   drawxy;
  if event.what and evmouseldown<>0 then
   begin
     if (n=maxn)or(mousewhere.y>=440)or
        (mousewhere.y<=9)or(mousewhere.x<=9)or
        (mousewhere.x>=630) then exit;
     i:=1;
     while (i<=n)and((abs(x[i]-mousewhere.x)>6)or
           (abs(y[i]-mousewhere.y)>6))do
      inc(i);
     if i<=n then exit;
     inc(n);
     x[n]:=mousewhere.x;
     y[n]:=mousewhere.y;
     hidemouse;
     setcolor(15);
     circle(x[n],y[n],2);
     setcolor(9);
     circle(x[n],y[n],4);
     showmouse;
   end;
  if event.what and evmouserdown<>0 then
   begin
     hidemouse;
     bar(6,6,633,443);
     for i:=1 to n do
      begin
        setcolor(15);
        circle(x[i],y[i],2);
        setcolor(9);
        circle(x[i],y[i],4);
      end;
     showmouse;
     setcolor(10);
     for i:=1 to n-1 do
      for j:=i+1 to n do
       begin
         xi:=longint(x[i]);
         yi:=longint(y[i]);
         xj:=longint(x[j]);
         yj:=longint(y[j]);
         a[i,j]:=round(sqrt(sqr(xi-xj)+sqr(yi-yj)));
       end;
     for i:=2 to n do
      v[i]:=0;
     v[1]:=1;
     for k:=1 to n-1 do
      begin
        min:=maxint2;
        for i:=1 to n-1 do
         for j:=i+1 to n do
          if (v[i]+v[j]=1)and(a[i,j]<min) then
           begin
             imin:=i;
             jmin:=j;
             min:=a[i,j];
           end;
        v[imin]:=1;
        v[jmin]:=1;
        hidemouse;
        line(x[imin],y[imin],x[jmin],y[jmin]);
        showmouse;
      end;
   end;
end;
begin
  initgraph(gd,gr,'c:\programs\bp\bgi');
  setfillstyle(1,0);
  setcolor(15);
  rectangle(5,5,634,444);
  n:=0;
  busy:=false;
  oldsx:='';
  oldsy:='';
  mousehandleron(handler);
  setmousespeed(4,4);
  drawxy;
  showmouse;
  repeat
    c:=readkey;
    if (c=#13)and(n<>0) then
     begin
       busy:=true;
       n:=0;
       hidemouse;
       bar(6,6,633,443);
       drawxy;
       showmouse;
       busy:=false;
     end;
  until c=#27;
end.