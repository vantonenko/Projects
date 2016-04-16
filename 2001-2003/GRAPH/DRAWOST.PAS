program drawost;
uses graph,crt;
const
  maxn=300;
type
  ta=array[1..maxn]of longint;
  pa=^ta;
var
  x,y:array[1..maxn]of integer;
  v:array[1..maxn]of byte;
  a:array[1..maxn]of pa;
  n,i,j,k,imin,jmin:word;
  xi,yi,xj,yj,min:longint;
  c:char;
label m1,m2,m3;
begin
m1:clrscr;
  write('Enter the quantity of the points(n<=',maxn,'):');
  readln(n);
  if (n<2)or(n>maxn) then
   goto m1;
  x[1]:=0;
  initgraph(x[1],y[1],'c:\programs\bp\bgi');
m3:cleardevice;
  randomize;
  for i:=1 to n do
   begin
     x[i]:=random(632)+4;
     y[i]:=random(472)+4;
     setcolor(15);
     circle(x[i],y[i],2);
     setcolor(9);
     circle(x[i],y[i],4);
   end;
  for i:=1 to n do
   new(a[i]);
  for i:=1 to n-1 do
   for j:=i+1 to n do
    begin
      xi:=longint(x[i]);
      yi:=longint(y[i]);
      xj:=longint(x[j]);
      yj:=longint(y[j]);
      a[i]^[j]:=round(sqrt(sqr(xi-xj)+sqr(yi-yj)));
    end;
  for i:=2 to n do
   v[i]:=0;
  v[1]:=1;
  setcolor(10);
  for k:=1 to n-1 do
   begin
     min:=maxint*maxint*2;
     for i:=1 to n-1 do
      for j:=i+1 to n do
       if (v[i]+v[j]=1)and(a[i]^[j]<min) then
        begin
          imin:=i;
          jmin:=j;
          min:=a[i]^[j];
          if keypressed then
           goto m2;
        end;
     v[imin]:=1;
     v[jmin]:=1;
     line(x[imin],y[imin],x[jmin],y[jmin]);
   end;
m2:for i:=1 to n do
    dispose(a[i]);
  c:=readkey;
  if c<>#27 then
    goto m3
   else
    begin
      closegraph;
      writeln('Press Esc to quit or other key to continue...');
      if readkey<>#27 then
       goto m1;
    end;
  clrscr;
end.