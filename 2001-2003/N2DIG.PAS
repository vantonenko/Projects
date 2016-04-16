program n2dig;
uses crt;
var
  k,c,a,n,d:longint;
  ln10:extended;
label m;
begin
  clrscr;
m:write('Enter N:');
  readln(n);
  if n=0 then
   exit;
  k:=0;
  c:=0;
  ln10:=ln(10);
  repeat
    inc(k);
    a:=k*k;
    c:=c+trunc(ln(a)/ln10)+1;
  until c>=n;
  n:=c-n+1;
  d:=a;
  for k:=1 to n do
   begin
     c:=d mod 10;
     d:=d div 10;
   end;
  writeln('A:',a);
  writeln('C:',c);
  goto m;
end.