program fibonach;
uses crt;
var
  n,i:longint;
  f0,f1,f2:extended;
label m1;
begin
  clrscr;
m1:write('Enter N(or "0" to quit):');
  readln(n);
  if n=0 then
   exit;
  f0:=1;
  f1:=2;
  for i:=1 to n do
   begin
     f2:=f1+f0;
     f0:=f1;
     f1:=f2;
   end;
  writeln('F:',f0:0:0);
  goto m1;
end.