{$r-}
program chess;
uses crt;
const
  maxn=8;
  maxm=8;
  dxy:array[1..8,1..2]of shortint=
   ((-2,-1),(-1,-2),(1,-2),(2,-1),(2,1),(1,2),(-1,2),(-2,1));
var
  m,n,j:byte;{m=>x,n=>y}
  a:array[1..maxn,1..maxn]of byte;
  mn,length:word;
  path:array[1..2,1..maxn*maxn]of byte;
procedure generation(x,y:shortint);
var
  i:byte;
begin
  a[x,y]:=1;
  inc(length);
  path[1,length]:=x;
  path[2,length]:=y;
  if keypressed then
   begin
     i:=ord(readkey);
     i:=i;
   end;
  if length=mn then
    begin
      writeln('OK');
      i:=length;
      for j:=1 to i do
       writeln(path[1,j],' ',path[2,j]);
      if readkey=#27 then
       halt;
    end
   else
    for i:=8  downto 1 do
     if (x+dxy[i,1]>=1)and(x+dxy[i,1]<=m)and
        (y+dxy[i,2]>=1)and(y+dxy[i,2]<=n)and
        (a[x+dxy[i,1],y+dxy[i,2]]=0) then
      generation(x+dxy[i,1],y+dxy[i,2]);
  path[1,length]:=0;
  path[2,length]:=0;
  dec(length);
  a[x,y]:=0;
end;
label m1;
begin
  clrscr;
  m:=maxm;
  n:=maxn;
  mn:=m*n;
  fillchar(a,sizeof(a),0);
  writeln('I''am digiting...');
  generation(1,1);
  writeln('Vsyo!');
  readln
end.