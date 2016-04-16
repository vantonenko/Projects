program maxr;
uses crt;
var
  n,n2,n3,i:word;
  s:extended;
procedure set23(a,b:word);
begin
  n2:=a;
  n3:=b;
end;
label m1;
begin
  clrscr;
m1:write('Vvedite N:');
  readln(n);
  if n=0 then
   exit;
  n2:=0;
  n3:=0;
  case n mod 3 of
   0:set23(0,n div 3);
   1:set23(2,(n-4)div 3);
   2:set23(1,(n-2)div 3);
  end;
  s:=1;
  for i:=1 to n3 do
   begin
     write('3+');
     s:=s*3;
   end;
  for i:=1 to n2 do
   begin
     write('2+');
     s:=s*2;
   end;
  gotoxy(wherex-1,wherey);
  writeln(' ');
  writeln('Smax:',s:0:0);
  goto m1;
end.