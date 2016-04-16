program rasbien;
uses crt;
const
  maxn=1000;
var
  x:array[1..maxn]of word;
  a,i,j,n:word;
  c:char;
label m1;
begin
  clrscr;
m1:write('Vvedite chislo:');
  readln(a);
  if a=0 then goto m1;
  writeln('Rasbienie:');
  x[1]:=1;
  write('1');
  for i:=2 to a do
   begin
    x[i]:=1;
    write('+1');
   end;
  n:=a;
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
     for j:=2 to n do
      write('+',x[j]);
   end;
  writeln;
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.