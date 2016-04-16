program polinom;
uses crt;
var
  a,b,c,d:extended;
label m1;
begin
  clrscr;
m1:write('Введите коеффициенты ур-я(a,b,c):');
  readln(a,b,c);
  if a=0 then
   exit;
  d:=b*b-4*a*c;
  if d<0 then
    writeln('Ур-е не имеет действительных корней!')
   else
    if d=0 then
      writeln('X=',-b/(2*a):0:5)
     else
      begin
        writeln('X1=',(-b+sqrt(d))/(2*a):0:5);
        writeln('X2=',(-b-sqrt(d))/(2*a):0:5);
      end;
  goto m1;
end.