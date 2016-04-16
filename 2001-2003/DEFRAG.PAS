program defrag;
uses crt;
const
  maxn=100;
var
  x:array[1..maxn]of word;
procedure swap(var a,b:word);
begin
  writeln('Swap:',a,' and ',b);
  a:=a+b;
  b:=a-b;
  a:=a-b;
end;
var
  n,i,m,r,l:word;
label m1;
begin
  clrscr;
m1:write('Enter the size of the massive:');
  readln(n);
  for i:=1 to n do
   begin
     write('Enter ',i,' item of the massive:');
     readln(x[i]);
   end;
  l:=0;
  m:=0;
  r:=n;
  while m<r do
   if x[m+1]=1 then
     m:=m+1
    else
     if x[m+1]=1 then
       begin
         swap(x[m+1],x[r]);
         r:=r-1;
       end
      else
       begin
         swap(x[m+1],x[i+1]);
         l:=l+1;
         m:=m+1;
       end;
  for i:=1 to n do
   write(x[i],' ');
  writeln('Press Esc to quit or Enter to continue...');
  if readkey<>#27 then goto m1;
end.