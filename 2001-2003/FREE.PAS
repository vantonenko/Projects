program free;
uses crt,dos;
begin
  clrscr;
  repeat
    write('Free space on the current drive:',diskfree(0) div 1024,' kb');
    gotoxy(1,wherey);
  until keypressed;
end.