program limit;
uses crt;
var
  x,a:extended;
begin
  clrscr;
  x:=1;
  a:=pi/4;
  repeat
    writeln('����饥 ���祭��:',x:20:18);
    gotoxy(1,wherey-1);
    x:=x*cos(a);
    a:=a/2;
  until keypressed;
  readkey;
end.