uses crt,grafixx;
var
  t:longint;
  m:longint;
label l1;
begin
  clrscr;
  l1:t:=meml[$0040:$006C];
  m:=0;
  while meml[$0040:$006C]<t+1 do;
  repeat
    waitretrace;
    inc(m);
  until meml[$0040:$006C]>t+20;
  writeln(m*18/(meml[$0040:$006C]-t-1):0:2);
  if not(keypressed and(readkey=#27)) then
   goto l1;
end.