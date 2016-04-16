uses crt;
var
  n,i:longint;
  s:extended;
label m1;
begin
  clrscr;
m1:write('Enter N:');
  readln(n);
  if n=0 then
   exit;
  s:=1;
  for i:=1 to n do
   s:=s*i;
  writeln('N!:',s:0:0);
  goto m1;
end.