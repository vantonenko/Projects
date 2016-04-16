program fillmatr;
{$b-}
uses crt;
const
  m=8;
  n=6;
type
  tpoint=record
    x,y:byte;
  end;
var
  rw:word;
  st:array[1..m*n]of tpoint;
  map:array[1..m,1..n]of byte;
  new:array[1..m,1..n]of boolean;
  fl,bd,i,j,x,y:byte;
  p:boolean;
  finp,fout:text;
procedure push(i,j:byte);
begin
  inc(rw);
  st[rw].x:=i;
  st[rw].y:=j;
  map[i,j]:=fl;
  new[i,j]:=false;
  p:=false;
end;
begin
  clrscr;
  assign(finp,'fillmatr.dat');
  reset(finp);
  for j:=1 to n do
   for i:=1 to m do
    read(finp,map[i,j]);
  writeln('Vvedite koordinati,cvet zalivki,cvet granici:');
  readln(x,y,fl,bd);
  rw:=0;
  fillchar(new,sizeof(new),true);
  push(x,y);
  while rw<>0 do
   begin
     if keypressed then exit;
     x:=st[rw].x;
     y:=st[rw].y;
     p:=true;
     if(x<>1)and(map[x-1,y]<>bd)and new[x-1,y] then
       push(x-1,y);
     if(x<>m)and(map[x+1,y]<>bd)and new[x+1,y] then
       push(x+1,y);
     if(y<>1)and(map[x,y-1]<>bd)and new[x,y-1] then
       push(x,y-1);
     if(y<>n)and(map[x,y+1]<>bd)and new[x,y+1] then
       push(x,y+1);
     if p then
       dec(rw);
   end;
  assign(fout,'fillmatr.sol');
  rewrite(fout);
  for j:=1 to n do
   begin
     for i:=1 to m do
       write(fout,map[i,j]:2);
     writeln(fout);
   end;
  close(fout);
end.
