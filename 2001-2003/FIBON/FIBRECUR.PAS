program fibrecur;
uses crt;
const
  maxn=500;
var
  n:longint;
  m:array[0..500]of extended;
  x:extended;
procedure fibon(n:longint;var x:extended);
var
  x1,x2:extended;
begin
  if m[n]<>0 then
    x:=m[n]
   else
    begin
      fibon(n-1,x1);
      fibon(n-2,x2);
      m[n]:=x1+x2;
      x:=m[n];
    end;
end;
label m1;
begin
  clrscr;
m1:write('Enter N:');
  readln(n);
  if n=0 then
   exit;
  fillchar(m,n*4,0);
  m[0]:=1;
  m[1]:=2;
  fibon(n,x);
  writeln('F:',x:0:0);
  goto m1;
end.