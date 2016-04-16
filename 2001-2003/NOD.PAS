program nod;
uses crt;
var
  x,y:longint;
label m1;
begin
  clrscr;
m1:write('X,Y:');
  readln(x,y);
  if x=0 then
   exit;
  while (x<>0)and(y<>0) do
   if x>y then
     x:=x mod y
    else
     y:=y mod x;
  if y>x then
   x:=y;
  writeln('NOD:',x);
  goto m1;
end.