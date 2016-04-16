program matrix;
uses crt;
var
  x,i,j:word;
begin
  clrscr;
  randomize;
  for i:=1 to 25 do
   for j:=1 to 80 do
    begin
      gotoxy(j,i);
      textcolor(random(8)+1);
      write(chr(ord('a')+random(26)));
    end;
  repeat
    textcolor(random(7)+9);
    x:=random(80)+1;
    for i:=1 to 25 do
     begin
       gotoxy(x,i);
       write(chr(ord('a')+random(26)));
       delay(40);
       if keypressed then
        break;
     end;
  until keypressed;
  clrscr;
  textcolor(8);
end.