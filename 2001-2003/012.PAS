program _012;
uses crt;
const
  maxn=100;
var
  n:word;
  x:array[
procedure swap(var a,b:integer);
begin
  a:=a+b;
  b:=a-b;
  a:=a-b;
end;
begin

  l:=0;
  m:=0;
  r:=n;
  while m<r do
   if x[m+1]=1 then
     m:=m+1
    else
     if x[m+1]=2 then
       begin
         swap(x[m+1],x[r]);
         writeln('Change:',m+1,' ',r);
         r:=r-1;
       end
      else
       begin
         swap(x[m+1],x[l+1];
         writeln('Change:',m+1,' ',l+1);
         l:=l+1;
         m:=m+1;
       end;
end.