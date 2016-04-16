program ncub;
uses crt;
const
  eps=0.5;
var
  s,n:extended;
label m1;
begin
  clrscr;
  n:=0;
  s:=0;
m1:repeat
    n:=n+1;
    s:=s+n*n*n;
    writeln('Текущее значение N:',n:0:0);
    gotoxy(1,wherey-1);
  until keypressed;
  if readkey=#0 then
   readkey;
  gotoxy(1,wherey+1);
  if abs(sqr((1+n)*n/2)-s)<eps then
    writeln('1^3+2^3+3^3+...+n^3=((1+n)*n/2)^2')
   else
    writeln('1^3+2^3+3^3+...+n^3<>((1+n)*n/2)^2');
  if readkey<>#27 then
   goto m1;
end.