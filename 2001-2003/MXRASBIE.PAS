program maxrasbien;
uses crt;
const
  maxn=5000;
var
  pr,x:array[1..maxn]of longint;
  a,i,j,n,npr,k2,k3:longint;
  s,max:extended;
  c:char;
label m1;
begin
  clrscr;
m1:writeln('Vvedite chislo:');
  readln(a);
  if a=0 then goto m1;
  {writeln('Rasbienie:');}
  max:=1;
  x[1]:=1;
  write('1');
  for i:=2 to a do
   begin
    x[i]:=1;
    write('+1');
   end;
  pr:=x;
  n:=a;
  npr:=n;
  i:=1;
  while n>1 do
   begin
     writeln;
     inc(x[i]);
     dec(x[n]);
     if x[n]=0 then
       dec(n);
     inc(i);
     if i>=n then
       i:=1;
     write(x[1]);
     s:=x[1];
     for j:=2 to n do
      begin
        write('+',x[j]);
        s:=s*x[j];
      end;
     write(' ',s:0:0);
     if s>max then
      begin
        max:=s;
        npr:=n;
        pr:=x;
      end;
     readln;
   end;
  writeln;
  writeln('Max proisvedenie:',max:0:0);
  write('Posledovatelnost:');
  for i:=1 to npr do
   write(pr[i],' ');
  writeln;
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
  writeln(k3,' ',k2);
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.