program rasmech;
uses crt;
const
  maxk=100;
var
  x:array[1..maxk]of word;
  k,n,i,p:word;
  c:char;
label m1;
begin
  clrscr;
m1:writeln('Vvedite dlinu posledovatelnosti:');
  readln(k);
  writeln('Vvedite N:');
  readln(n);
  for i:=1 to k do
   begin
    x[i]:=1;
    write('1 ');
   end;
  while true do
   begin
     p:=k;
     writeln;
     while(p<>0)and not(x[p]<n) do
      p:=p-1;
     if (p=0)or keypressed then break;
     x[p]:=x[p]+1;
     for i:=p+1 to k do
      x[i]:=1;
     for i:=1 to k do
      write(x[i],' ');
   end;
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.