program per;
uses crt;
const
  maxn=1000;
var
  x:array[1..maxn]of word;
  n,a,i,k,ia:word;
  c:char;
label m1;
begin
  clrscr;
m1:write('Vvedite N:');
  readln(n);
  writeln('Perestanovki:');
  for i:=1 to n do
   begin
     x[i]:=i;
     write(i,' ');
   end;
  writeln;
  while true do
   begin
     k:=n-1;
     while (k>0)and(x[k]>=x[k+1]) do
      dec(k);
     if k=0 then break;
     a:=65535;
     for i:=k+1 to n do
      if (x[i]<a)and(x[i]>x[k]) then
       begin
         a:=x[i];
         ia:=i;
       end;
     a:=x[k];
     x[k]:=x[ia];
     x[ia]:=a;
     for i:=k+1 to k+(n-k)div 2 do
      begin
        a:=x[i];
        x[i]:=x[n-i+k+1];
        x[n-i+k+1]:=a;
      end;
     for i:=1 to n do
      write(x[i],' ');
     writeln;
   end;
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.

