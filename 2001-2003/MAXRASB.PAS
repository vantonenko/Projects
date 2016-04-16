program maxrasb;
uses crt;
var
  a,k3,k2,i:longint;
label m1;
begin
  textcolor(7);
  clrscr;
m1:write('Vvedite chislo:');
  readln(a);
  case a mod 3 of
   0:begin
       k2:=0;
       k3:=a div 3;
     end;
   1:begin
       k2:=2;
       k3:=(a-4) div 3;
     end;
   2:begin
       k2:=1;
       k3:=(a-2) div 3;
     end;
  end;
  writeln('Rasbienie s maximalnim proisvedeniem:');
  for i:=1 to k3 do
   write(3,' ');
  for i:=1 to k2 do
   write(2,' ');
  writeln;
  writeln('Press Esc to quit or Enter to continue...');
  if readkey<>#27 then
   goto m1;
end.