program soundtest;
uses crt;
var
  f:word;
begin
  repeat
    clrscr;
    write('Vvedite f:');
    readln(f);
    sound(f);
  until f=0;
  nosound;
end.