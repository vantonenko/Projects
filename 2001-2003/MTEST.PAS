program mtest;
uses crt,f_mouse;
var
  butt,x,y:integer;
begin
  clrscr;
  showmouse;
  setsteptopixel(8,8);
  repeat
    getmousestate(butt,x,y);
    if butt<>0 then
     begin
       sound(100);
       delay(30);
       nosound;
     end;
  until keypressed;
end.