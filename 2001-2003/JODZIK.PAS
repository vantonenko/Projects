program jodzik;
uses crt;
const
  m=5;
  n=4;
type
  tpoint=record
    x,y:byte;
  end;
var
  r:array[1..2,1..2*m*n-m-n]of tpoint;
  d:array[1..2*m*n-m-n]of byte;
  map:array[1..m,1..n]of byte;
  s:array[1..m,1..n]of tpoint;
  l:array[1..m,1..n]of word;
  path:array[1..m+n]of tpoint;
  c,apl:word;
  x,y,a,b,dl,smax,i,j,x1,y1,x2,y2:byte;
  finp:text;
  f:boolean;
procedure addr(a1,b1,a2,b2,dl:byte);
begin
  inc(c);
  r[1,c].x:=a1;
  r[1,c].y:=b1;
  r[2,c].x:=a2;
  r[2,c].y:=b2;
  d[c]:=dl;
end;
begin
  clrscr;
  assign(finp,'jodzik.dat');
  reset(finp);
  c:=0;
  smax:=0;
  for j:=1 to n do
   for i:=1 to m do
    begin
      read(finp,map[i,j]);
      if map[i,j]>smax then
      smax:=map[i,j];
    end;
  for j:=1 to n do
   for i:=1 to m do
     map[i,j]:=smax-map[i,j]+1;
  for j:=1 to n do
   for i:=1 to m do
    begin
      if i<>m then addr(i,j,i+1,j,map[i+1,j]);
      if j<>n then addr(i,j,i,j+1,map[i,j+1]);
    end;
  fillchar(s,sizeof(s),0);
  fillchar(l,sizeof(l),255);
  l[1,1]:=0;
  f:=true;
  while f do
   begin
     f:=false;
     for i:=1 to c do
      begin
        x1:=r[1,i].x;
        y1:=r[1,i].y;
        x2:=r[2,i].x;
        y2:=r[2,i].y;
        dl:=d[i];
        if l[x2,y2]>l[x1,y1]+dl then
         begin
           l[x2,y2]:=l[x1,y1]+dl;
           s[x2,y2].x:=x1;
           s[x2,y2].y:=y1;
           f:=true;
         end;
      end;
   end;
  x:=m;
  y:=n;
  path[1].x:=m;
  path[1].y:=n;
  j:=1;
  apl:=smax-map[m,n]+1;
  while not((s[x,y].x=0)and(s[x,y].y=0))do
   begin
     a:=s[x,y].x;
     b:=s[x,y].y;
     x:=a;
     y:=b;
     inc(j);
     path[j].x:=a;
     path[j].y:=b;
     apl:=apl+smax-map[a,b]+1;
   end;
  writeln('col:',apl);
  writeln('path:');
  for i:=j downto 1 do
    writeln(path[i].x,' ',path[i].y);
  readln
end.


