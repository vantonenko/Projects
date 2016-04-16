program summ;
uses crt;
const
  maxn=100;
type
  tx=array[1..maxn]of word;
var
  nn,s:word;
  x:tx;
procedure increm(i,n:word);
var
  j:word;
  oldx:tx;
begin
  write(x[1]);
  for j:=2 to nn do
   write('+',x[j]);
  writeln;
  if (i=1)or keypressed then
   exit;
  for j:=1 to n do
   begin
     dec(x[i]);
     inc(x[i-1]);
     oldx:=x;
     increm(i-1,j);
     x:=oldx;
   end;
end;
label m1;
begin
  clrscr;
m1:write('Enter the quantity of the numbers:');
  readln(nn);
  write('Enter the summ:');
  readln(s);
  fillchar(x,nn,0);
  x[nn]:=s;
  increm(nn,s);
  writeln('Press Esc to quit or other key to continue...');
  if readkey<>#27 then
   goto m1;
end.