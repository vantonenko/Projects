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
    '�'..'�':s[k]:=chr(ord(s[k])-ord('�')+192);
    '�'..'�':s[k]:=chr(ord(s[k])-ord('�')+224);
    '�'..'�':s[k]:=chr(ord(s[k])-ord('�')+240);
   end;
  oa:=s;
end;
var
  title:string;
begin
  title:=oa('��������� ����࠭�⢮.');
  fillchar(windowtitle,80,' ');
  for i:=0 to length(title)-1 do
   windowtitle[i]:=title[i+1];
  windowtitle[i+2]:=#0;
  initwincrt;
  {Screensize.x:=40;
  screensize.y:=7;}
  Writeln('������-   ',disksize(0) div 1024:13,' �����');
  writeln('��������- ',diskfree(0) div 1024:13,' �����');
  {Writeln(oa('������ ���� ������� ��� ��室�...'));}
  readkey;
  donewincrt;
end.
