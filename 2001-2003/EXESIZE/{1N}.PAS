program _1n;
uses crt;
const
  maxn=1000;
var
  x:array[1..maxn]of word;
  n,i:word;
label m1;
begin
  clrscr;
  write('Введите N,K:');
  readln(n,k);
  for i:=1 to n-k do
   x[i]:=0;
  for i:=n-k+1 to n do
   x[i]:=1;
  while true do
   begin
     s:=n-1;
     while not((x[s]=0)and(x[s+1]=1)) do
      dec(s);
