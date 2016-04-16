program mhgdrtydfgfdg;
uses crt;
var
  y:integer;
const
  x=6;
begin
  clrscr;
  y:=x+8;
  writeln(y);
  if x>5 then
    begin
      writeln('Вася');
      writeln('vasya')
    end
   else
    writeln('Петя');
  readln;
end.