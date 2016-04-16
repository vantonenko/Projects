program cubdig;
uses crt;
var
  n,i,a,d,s,col:longint;
  oldper:word;
label m1;
begin
  clrscr;
m1:write('Vvedite chislo:');
  readln(n);
  writeln(' 0% ');
  oldper:=0;
  col:=0;
  for i:=1 to n do
   begin
     a:=i;
     s:=0;
     if round(i*1000/n)<>oldper then
      begin
        oldper:=round(i*1000/n);
        gotoxy(wherex,wherey-1);
        writeln(' ',oldper/10:0:1,'% ');
      end;
     while (a>0) do
      begin
        d:=a mod 10;
        a:=a div 10;
        s:=s+d*d*d;
      end;
     if s=i then
      inc(col);;
   end;
  writeln('Col-vo chisel:',col);
  writeln('Press Esc to quit or Enter to continue...');
  if readkey<>#27 then
   goto m1;
end.