{236-4 bacteria.pas}
program bacteria;
{$b-}
const
  maxm=100;{really-63}
  maxn=100;{really-63}
  enablecol=65535;
var
  a:array[1..maxn,1..maxm]of byte;
  colors:array[1..maxn,1..maxm]of word;
  nnew:array[1..maxn,1..maxm]of boolean;
  fdat,fsol:text;
  m,n,i,j:byte;
  color:word;
  enflag:boolean;
procedure setcolors(i,j:byte);
begin
  colors[i,j]:=color;
  if (i>1)and(a[i-1,j]<>0)and(colors[i-1,j]=0) then
   setcolors(i-1,j);
  if (i>1)and(j>1)and(a[i-1,j-1]<>0)and(colors[i-1,j-1]=0) then
   setcolors(i-1,j-1);
  if (j>1)and(a[i,j-1]<>0)and(colors[i,j-1]=0) then
   setcolors(i,j-1);
  if (i<n)and(j>1)and(a[i+1,j-1]<>0)and(colors[i+1,j-1]=0) then
   setcolors(i+1,j-1);
  if (i<n)and(a[i+1,j]<>0)and(colors[i+1,j]=0) then
   setcolors(i+1,j);
  if (i<n)and(j<m)and(a[i+1,j+1]<>0)and(colors[i+1,j+1]=0) then
   setcolors(i+1,j+1);
  if (j<m)and(a[i,j+1]<>0)and(colors[i,j+1]=0) then
   setcolors(i,j+1);
  if (i>1)and(j<m)and(a[i-1,j+1]<>0)and(colors[i-1,j+1]=0) then
   setcolors(i-1,j+1);
end;
procedure fillfull(i,j:byte);
begin
  if not enflag then
   enflag:=((i=1)or(i=n)or(j=1)or(j=m))and(a[i,j]=0);
  if enflag then
   exit;
  nnew[i,j]:=false;
  if (i>1)and(a[i-1,j]=0)and(nnew[i-1,j]) then
   fillfull(i-1,j);
  if (j>1)and(a[i,j-1]=0)and(nnew[i,j-1]) then
   fillfull(i,j-1);
  if (i<n)and(a[i+1,j]=0)and(nnew[i+1,j]) then
   fillfull(i+1,j);
  if (j<m)and(a[i,j+1]=0)and(nnew[i,j+1]) then
   fillfull(i,j+1);
end;
function enable(i,j:byte):boolean;{vhodit li eta figura v druguyu figuru}
var
  c:word;
begin                     {true-yes;false-no}
  enable:=false;
  if colors[i,j]=enablecol then
   exit;
  {the begining of the corrective}
  enable:=true;
  if (i=1)or(i=n)or(j=1)or(j=m) then
   exit;
  {the end of the corrective}
  fillchar(nnew,maxn*maxm,true);
  enflag:=false;
  fillfull(i,j);
  enable:=enflag;
  if enflag then
   begin
     c:=color;
     color:=enablecol;
     setcolors(i,j);
     color:=c;
   end;
end;
begin
  {j=>m i=>n}
  assign(fdat,'bacteria.dat');
  reset(fdat);
  read(fdat,m,n);
  for j:=1 to m do
   for i:=1 to n do
    read(fdat,a[i,j]);
  close(fdat);
  color:=0;
  fillchar(colors,sizeof(colors),0);
  for j:=1 to m do
   for i:=1 to n do
    if (a[i,j]<>0)and(colors[i,j]=0)and enable(i,j) then
     begin
       inc(color);
       setcolors(i,j);
     end;
  assign(fsol,'bacteria.sol');
  rewrite(fsol);
  write(fsol,color);
  close(fsol);
  writeln(color);
  readln;
end.