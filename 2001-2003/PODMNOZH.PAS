{$b-}
program podmnozh;
uses crt;
const
  maxn=1000;
var
  x:array[1..maxn]of byte;
  n,k,i,s,num:word;
  c:char;
label m1;
begin
  clrscr;
m1:writeln('Vvedite col-vo edinic:');
  readln(k);
  writeln('Vvedite rasmer posledovatelnosti:');
  readln(n);
  for i:=1 to n-k do
   x[i]:=0;
  for i:=n-k+1 to n do
   x[i]:=1;
  for i:=1 to n do
   write(x[i],' ');
  writeln;
  while true do
   begin
     s:=n-1;
     while(s>0)and  not((x[s]=0)and(x[s+1]=1))do
      dec(s);
     if (s=0)or keypressed then break;
     num:=0;
     for i:=s to n do{schitaem col-vo edinic}
      num:=num+x[i];
     x[s]:=1;
     for i:=s+1 to n-num+1 do
      x[i]:=0;
     for i:=n-num+2 to n do
      x[i]:=1;
     for i:=1 to n do
      write(x[i],' ');
     writeln;
   end;
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.



