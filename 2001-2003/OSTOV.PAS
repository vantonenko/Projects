program ostov;
const
  maxn=60;
  pathinp='ostov.inp';
  pathout='ostov.out';
type
  tp=record
    x,y:integer;
  end;
var
  coo:array[1..maxn]of tp;
  incl:array[1..maxn]of byte;
  a:array[1..maxn,1..maxn]of longint;
  ost:array[1..maxn-1]of tp;
  n,i,j,k,imin,jmin:word;
  d,min:longint;
  finp,fout:text;
begin
  assign(finp,pathinp);
  reset(finp);
  read(finp,n);
  for i:=1 to n do
   with coo[i] do
    read(finp,x,y);
  close(finp);
  for i:=1 to n do
   for j:=1 to n do
    begin
      d:=sqr(coo[i].x-coo[j].x)+sqr(coo[i].y-coo[j].y);
      a[i,j]:=d;
      a[j,i]:=d;
    end;
  for i:=2 to n do
   incl[i]:=0;
  incl[1]:=1;
  for k:=1 to n-1 do
   begin
     min:=maxint*maxint;
     for i:=1 to n do
      for j:=1 to n do
       if (incl[i]+incl[j]=1)and(a[i,j]<min) then
        begin
          min:=a[i,j];
          imin:=i;
          jmin:=j;
        end;
     ost[k].x:=imin;
     ost[k].y:=jmin;
     incl[imin]:=1;
     incl[jmin]:=1;
   end;
  assign(fout,pathout);
  rewrite(fout);
  for i:=1 to n-1 do
   begin
     with coo[ost[i].x] do
      write(fout,x,' ',y,' ');
     with coo[ost[i].y] do
      writeln(fout,x,' ',y);
   end;
  close(fout);
end.