program transper;
uses crt;
const
  maxn=1000;
var
  x:array[1..maxn]of word;
  n,i,p:word;
  dp:integer;
procedure swap(var a,b:word);
begin
  a:=a+b;
  b:=a-b;
  a:=a-b;
end;
function enable:boolean;
begin
  enable:=true;
  for i:=1 to n do
   if x[i]<>i then
    begin
      enable:=false;
      exit;
    end;
end;
label m1;
begin
  clrscr;
m1:write('Enter N:');
  readln(n);
  for i:=1 to n do
   begin
     x[i]:=i;
     write(i,' ');
   end;
  writeln;
  p:=1;
  repeat
    swap(x[p],x[p+1]);
    for i:=1 to n do
     write(x[i],' ');
    writeln;
    if p=n-1 then
     dp:=-1;
    if p=1 then
     dp:=1;
    inc(p,dp);
  until enable;
  writeln('Continue(Enter/..)?');
  if readkey=#13 then
   goto m1;
end.