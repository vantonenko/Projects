program perestan;
uses crt;
const
  maxn=1000;
var
  x:array[1..maxn]of word;
  n,a,i,p,min,imin:word;
label m1;
begin
m1:clrscr;
  write('Введите N:');
  readln(n);
  while keypressed do
   readkey;
  if n=0 then
   exit;
  for i:=1 to n do
   begin
     x[i]:=i;
     write(i:3);
   end;
  writeln;
  while true do
   begin
     p:=n;
     while (p>0)and(x[p]>=x[p+1]) do
      dec(p);
     if p=0 then
      break;
     min:=65535;
     imin:=n;
     for i:=p+1 to n do
      if (x[i]<min)and(x[i]>x[p]) then
       begin
         min:=x[i];
         imin:=i;
       end;
     x[imin]:=x[p]+x[imin];
     x[p]:=x[imin]-x[p];
     x[imin]:=x[imin]-x[p];
     for i:=p+1 to p+(n-p)div 2 do
      begin
        a:=x[i];
        x[i]:=x[n-i+p+1];
        x[n-i+p+1]:=a;
      end;
     for i:=1 to n do
      write(x[i]:3);
     writeln;
   end;
  readkey;
  goto m1;
end.