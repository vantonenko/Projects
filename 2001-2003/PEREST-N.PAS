program perestn;
uses crt;
const
  maxn=100;
var
  x:array[1..maxn]of byte;
  n,l:byte;
 function perest:boolean;
 var
   i,k,min,imin:byte;
 begin
   perest:=true;
   k:=n-1;
   while (k>0)and(x[k]>=x[k+1]) do
    dec(k);
   if k=0 then
    begin
      perest:=false;
      exit;
    end;
   min:=255;
   imin:=n;
   for i:=k+1 to n do
    if (x[i]<min)and(x[i]>x[k]) then
     begin
       min:=x[i];
       imin:=i;
     end;
   i:=x[imin];
   x[imin]:=x[k];
   x[k]:=i;
   for i:=1 to (n-k+1)div 2 do
    begin
      min:=x[k+i];
      x[k+i]:=x[n-i+1];
      x[n-i+1]:=min;
    end;
 end;
var
  i,j:byte;
label m1;
begin
  clrscr;
m1:write('Enter N:');
  readln(n);
  write('Enter L:');
  readln(l);
  if l<n then
   begin
     writeln('Error(l<n)!');
     goto m1;
   end;
  for i:=1 to n do
   begin
     x[i]:=i;
     write(i,' ');
   end;
  writeln;
  while perest do
   begin
     for j:=0 to l-i do
      for i:=1 to n do
       write(x[i]+j,' ');
     writeln;
   end;
  if readkey<>#27 then
   goto m1;
end.