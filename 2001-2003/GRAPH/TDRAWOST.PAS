program ostov;
uses graph,crt;
const
  maxn=450;
type
  ta=array[1..maxn]of word;
  pa=^ta;
var
  a:array[1..maxn]of pa;
  v:array[1..maxn]of byte;
  x,y:array[1..maxn]of byte;
  i,j,k,imin,jmin:word;
  min:real;
  gd,gr,dx,dy:integer;
  n:word;
  c:char;
label m1,m2,m3;
begin
m1:clrscr;
  write('Enter the quantity of the points(n<=450):');
  readln(n);
  if (n<2)or(n>450) then goto m1;
  initgraph(gd,gr,'c:\programs\bp\bgi');
m3:cleardevice;
  randomize;
  setlinestyle(0,0,1);
  for i:=1 to n do
   begin
     x[i]:=random(127)+1;
     y[i]:=random(95)+1;
     setcolor(15);
     circle(x[i]*5,y[i]*5,2);
     setcolor(9);
     circle(x[i]*5,y[i]*5,4);
   end;
  setcolor(10);
  for i:=1 to n do
  new(a[i]);
  for i:=1 to n-1 do
   for j:=i+1 to n do
    begin
      dx:=x[i]-x[j];
      dy:=y[i]-y[j];
      a[i]^[j]:=dx*dx+dy*dy;
    end;
  for i:=2 to n do
   v[i]:=0;
  v[1]:=1;
  setlinestyle(0,0,1);

  for k:=1 to n-1 do
   begin
     min:=maxint*maxint*2;
     for i:=1 to n-1 do
      for j:=i+1 to n do
       if (v[i]+v[j]=1)and(a[i]^[j]<min) then
        begin
          min:=a[i]^[j];
          imin:=i;
          jmin:=j;
          if keypressed then
           goto m2;
        end;
     line(x[imin]*5,y[imin]*5,x[jmin]*5,y[jmin]*5);
     v[imin]:=1;
     v[jmin]:=1;
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
      if readkey<>#27 then goto m1;
    end;
  clrscr;
end.