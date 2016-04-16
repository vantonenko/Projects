program z1;
uses crt;
var
  a,b,s,n:word;
  c:char;
procedure swap(var a,b:word);
begin
  a:=a+b;
  b:=a-b;
  a:=a-b;
end;
label m1;
begin
  clrscr;
m1:write('A,B:');
  read(a,b);
  if b>a then
   swap(a,b);
  s:=0;
  while b<>0 do
   begin
     n:=a div b;
     a:=a mod b;
     s:=s+n;
     if b>a then
      swap(a,b);
   end;
  writeln;
  writeln('K:',s);
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.