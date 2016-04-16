program clock;
uses crt;
begin
  repeat
    writeln(port[$70],' ',port[$71]);
    gotoxy(1,wherey-1);
  until keypressed;
end.