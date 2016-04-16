program vosrost;
uses crt;
const
  maxn=1000;
var
  x:array[1..maxn]of word;
  n,i,s,k:word;
  c:char;
label m1;
begin
  clrscr;
m1:writeln('Vvedite max chislo:');
  readln(n);
  writeln('Vvedite dlinu posledovatelnosti');
  readln(k);
  if k>n then goto m1;
  writeln('Vosrostayuschie posledovatelnosti:');
  for i:= 1 to k do
   begin
    x[i]:=i;
    write(i,' ');
   end;
  while true do
   begin
     s:=k;
     writeln;
     while(s>0)and not(x[s]<s+n-k) do
      dec(s);
     if s=0 then break;
     x[s]:=x[s]+1;
     for i:=s+1 to k do
      x[i]:=x[i-1]+1;
     for i:=1 to k do
      write(x[i],' ');
   end;
  writeln('Press Esc to quit,Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.


