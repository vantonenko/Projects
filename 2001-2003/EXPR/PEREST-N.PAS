program perestn;
uses crt;
const
  maxn=100;
var
  x:array[1..maxn]of byte;
  n,l,i:byte;
  used:set of byte;
procedure generation(j:byte);
var
  i:byte;
begin
  if j=l+1 then
   begin
     for i:=1 to l do
      write(x[i],' ');
     writeln;
     exit;
   end;
  for i:=0 to n do
   if not(i in used) then
    begin
      include(used,i);
      x[j]:=i;
      generation(j+1);
      exclude(used,i);
    end;
end;
label m1;
begin
  clrscr;
m1:write('Enter the length of the line:');
  readln(l);
  write('Enter the max evaluate:');
  readln(n);
  if n<l then
   exit;
  used:=[];
  fillchar(x,l,0);
  generation(1);
  writeln('Vsyo!');
  if readkey=#13 then
   goto m1;
end.