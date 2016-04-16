program eiler;
uses crt;
const
  maxn=100;
var
  a:array[1..maxn,1..maxn]of byte;
  st:array[1..maxn]of byte;
  m,n:byte;
  pos,i,x,y:byte;
  finp,fout:text;
procedure search(v:byte);
var
  j:integer;
begin
  for j:=1 to n do
   if a[v,j]<>0 then
    begin
      a[v,j]:=0;
      a[j,v]:=0;
      search(j);
    end;
  inc(pos);
  st[pos]:=v;
end;
begin
  assign(finp,'eiler.dat');
  reset(finp);
  read(finp,n,m);
  fillchar(a,sizeof(a),0);
  for i:=1 to m do
   begin
     read(finp,x,y);
     a[x,y]:=1;
     a[y,x]:=1;
   end;
  close(finp);
  pos:=0;
  search(1);
  assign(fout,'eiler.sol');
  rewrite(fout);
  if pos=m+1 then
    while pos<>0 do
     begin
       write(fout,st[pos],' ');
       dec(pos);
     end
   else
    write(fout,'no eiler');
   close(fout);
end.