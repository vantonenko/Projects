program rasmech;
uses crt;
const
  maxn=1000;
var
  x:array[1..maxn]of byte;
  n,k,i,p:word;
label m1;
begin
m1:clrscr;
  write('Введите длину последовательности("0"-выход):');
  readln(k);
  if k=0 then
   exit;
  write('Введите N:');
  readln(n);
  for i:=1 to k do
   x[i]:=1;
  while true do
   begin
     p:=k;
     while (p>0)and(x[p]=p)do
      dec(p);
     if p=0 then
      break;
     for i:=p+1 to k do
      x[i]:=1;
     inc(x[p]);
     for i:=1 to k do
      write(x[i]:3);
     writeln;
   end;
  readln;
  goto m1;
  clrscr;
end.