program lab1;
uses crt;
var
  x,a,b:extended;
function f(x:extended;n:word):extended;
var
  s,xn:extended;
begin
  s:=0;
  nf:=1;
  xn:=1;
  for i:=1 to n do
   begin
     s:=s+xn/nf;
     xn:=xn*x;
     nf:=nf*i;
   end;
  f:=s;
end;
begin
  clrscr;
  write('Enter a,b,m:');
  readln(a,b,m);

end.