uses WinDos,WinCrt;
var
  i:byte;
  timer:longint absolute $40:$6c;
  t:longint;
function oa(s:string):string;
var
  k:integer;
begin
  for k:=1 to length(s) do
   case s[k] of
    'А'..'Я':s[k]:=chr(ord(s[k])-ord('А')+192);
    'а'..'п':s[k]:=chr(ord(s[k])-ord('а')+224);
    'р'..'я':s[k]:=chr(ord(s[k])-ord('р')+240);
   end;
  oa:=s;
end;
var
  title:string;
begin
  title:=oa('Свободное пространство.');
  fillchar(windowtitle,80,' ');
  for i:=0 to length(title)-1 do
   windowtitle[i]:=title[i+1];
  windowtitle[i+2]:=#0;
  initwincrt;
  {Screensize.x:=40;
  screensize.y:=7;}
  Writeln('╨рчьхЁ-   ',disksize(0) div 1024:13,' ╩срщЄ');
  writeln('╤тюсюфэю- ',diskfree(0) div 1024:13,' ╩срщЄ');
  {Writeln(oa('Нажмите любую клавишу для выхода...'));}
  readkey;
  donewincrt;
end.
