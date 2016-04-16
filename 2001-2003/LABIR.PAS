program searchpath;
uses crt;
const
  m=13;
  n=7;
type
  tpoint=record
    x,y:word;
  end;
var
  path,og:array[1..m*n]of tpoint;
  r,w,bx,by,a,b,i,j,x,y:word;
  map:array[1..m,1..n]of byte;
  st:array[1..m,1..n]of tpoint;
  new:array[1..m,1..n]of boolean;
  finp:text;
  f:boolean;
{$b-}
function addog(a,b:word):boolean;
begin
  if not f then exit;
  og[w].x:=a;
  og[w].y:=b;
  inc(w);
  new[a,b]:=false;
  st[a,b].x:=x;
  st[a,b].y:=y;
  addog:=not((a=1)or(a=m)or(b=1)or(b=n));
end;
begin
  clrscr;
  assign(finp,'labir.dat');
  reset(finp);
  for i:=1 to n do
    for j:=1 to m do
      read(finp,map[j,i]);
  writeln('Vvedite koordinati');
  readln(a,b);
  close(finp);
  fillchar(new,sizeof(new),true);
  r:=1;
  w:=1;
  x:=0;
  y:=0;
  f:=true;
  f:=addog(a,b);
  while(r<w)and f do
   begin
     x:=og[r].x;
     y:=og[r].y;
     inc(r);
     if(x<>1)and new[x-1,y]and (map[x-1,y]=0 )then
       f:=addog(x-1,y);
     if(y<>1)and new[x,y-1]and (map[x,y-1]=0) then
       f:=addog(x,y-1);
     if(x<>m)and new[x+1,y]and (map[x+1,y]=0) then
       f:=addog(x+1,y);
     if(y<>n)and new[x,y+1]and (map[x,y+1]=0) then
       f:=addog(x,y+1);
   end;
  if f then writeln('path not found')
  else
   begin
     j:=1;
     x:=og[w-1].x;
     y:=og[w-1].y;
     path[j].x:=x;
     path[j].y:=y;
     while not((st[x,y].x=0)and(st[x,y].y=0))do
      begin
        a:=st[x,y].x;
        b:=st[x,y].y;
        x:=a;
        y:=b;
        inc(j);
        path[j].x:=x;
        path[j].y:=y
      end;
     writeln('path:');
     for i:=j downto 1 do
       writeln(path[i].x,' ',path[i].y);
   end;
  readln
end.

