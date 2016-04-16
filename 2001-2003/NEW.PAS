program new;
uses crt;
var
  a,b:real;
label m;
begin
  clrscr;
m:write('Введите a,b:');
  readln(a,b);
  if a=0 then
   exit;
  writeln('X=',-b/a:0:2);
  goto m;
end.