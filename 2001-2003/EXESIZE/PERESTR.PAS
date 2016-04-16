program perestr;
uses crt;
const
  maxn=1000;
var
  x:array[1..maxn]of word;
  n,i:word;
procedure swap(var a,b:word);
begin
  if a<>b then
   begin
     a:=a+b;
     b:=a-b;
     a:=a-b;
   end;
end;
procedure generation(k:byte);
var
  i:word;
begin
  if k=n then
    begin
      for i:=1 to n do
       write(x[i],' ');
      writeln;
    end
   else
    for i:=k to n do
     begin
       swap(x[k],x[i]);
       generation(k+1);
       swap(x[k],x[i]);
     end;
end;
label m1;
begin
  clrscr;
m1:write('Введите N:');
  readln(n);
  if n=0 then
   exit;
  for i:=1 to n do
   x[i]:=i;
  generation(1);
  goto m1;
end.