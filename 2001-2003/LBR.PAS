program lbr;
uses crt;
const
  maxn=100;
var
  n,l,r,b:word;
  x:array[1..maxn]of byte;
procedure swap(var a,b:byte);
begin
  a:=a+b;
  b:=a-b;
  a:=a-b;
end;
label m1;
begin
  clrscr;
m1:write('Enter N:');
  readln(n);
  write('Enter B:');
  readln(b);
  l:=0;
  r:=n;
  while l<>r do
   if x[l+1]<=b then
     l:=l+1
    else
     if x[r]>=b then
       r:=r-l
      else
       begin
         swap(x[l+1],x[r]);
         l:=l+1;
         r:=r-1;
       end;
end.