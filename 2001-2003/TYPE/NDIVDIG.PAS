program ndivdig;
uses crt;
var
  n,i,a,d:word;
  c:char;
  f:boolean;
label m1;
begin
  clrscr;
m1:write('Vvedite chislo:');
  readln(n);
  writeln;
  for i:=1 to n do
   begin
     f:=true;
     a:=i;
     while (a>0)and f do
      begin
        d:=a mod 10;
        a:=a div 10;
        if d<>0 then
         f:=i mod d=0;
      end;
     if f then
      write(i:8);
   end;
  writeln;
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then
   goto m1;
end.