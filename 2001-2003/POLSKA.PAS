program p;
uses crt;
procedure polska(var s:string);
var
  i,j:byte;
  c:char;
  ss:string;
begin
  i:=0;
  if s[1]='-' then s:='0'+s;
  fillchar(ss,256,0);
  ss[0]:=chr(255);
  while i<=length(s) do
   begin
     inc(i);
     c:=s[i];
     if ss[i]='1' then continue;
     if c in ['+','-','*','/'] then s[i]:=' ';
     if c in ['*','/'] then
      begin
        j:=i;
        while (s[j+1] in ['0'..'9'])and(j<=length(s))do inc(j);
        insert(c,s,j+1);
        insert('1',ss,j+1);
      end;
     if c in ['+','-'] then
      begin
        j:=i;
        while (s[j+1] in ['0'..'9','*','/'])and(j<=length(s))do inc(j);
        insert(c,s,j+1);
        insert('1',ss,j+1);
      end;
   end;
end;
label m1;
var
  s:string;
  c:char;
begin
  clrscr;
m1:writeln('Vvedite virazhenie:');
  readln(s);
  polska(s);
  writeln(s);
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.
