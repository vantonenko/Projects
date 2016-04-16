{b-}
program perstan;
uses crt;
const
  maxn=1000;
var
  x:array[1..maxn]of word;
  n,i,k,t,a:word;
  fl:boolean;
  c:char;
label m1;
begin
  clrscr;
m1:writeln('Vvedite col-vo el-tov:');
  readln(n);
  writeln('Perestanovki:');
  for i:=1 to n do
   begin
    x[i]:=i;
    write(i,' ');
   end;
  while true and (n<>1)do
   begin
     k:=n-1;
     writeln;
     while x[k]>x[k+1] do
      k:=k-1;
     t:=k+1;
     while(t<n)and(x[t+1]>x[k])do
      t:=t+1;
     a:=x[k];
     x[k]:=x[t];
     x[t]:=a;
     for i:=1 to n do
       write(x[i],' ');
     write(' I:');
     for i:=0 to (n-k-1)div 2 do
      begin
        a:=x[i+k+1];
        x[i+k+1]:=x[n-i];
        x[n-i]:=a;
      end;
     fl:=true;
     for i:=1 to n do
      begin
       write(x[i],' ');
       if x[i]<>n-i+1 then fl:=false;
      end;
     if keypressed or fl then break;
   end;
  writeln;
  c:=readkey;
  if c<>#27 then goto m1;
end.


