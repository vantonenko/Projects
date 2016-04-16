program hanoi;
uses crt;
const
  maxdig=70;
type
  pcol=^tcol;
  tcol=record
    size:byte;
    flag:boolean;
    next:pcol;
  end;
var
  x:array[1..maxdig]of byte;
  s:array[1..3]of pcol;
  n:array[1..3]of byte;
  t:pcol;
  col,i,j,oldi,oldj:byte;
  c:char;
procedure incnum;
var
  i,k:byte;
begin
  i:=maxdig;
  while (x[i]=9)and(i>0) do
   dec(i);
  if i>0 then
    inc(x[i]);
  for k:=i+1 to maxdig do
   x[k]:=0;
end;
label m1,m2;
begin
  clrscr;
m1:write('Vedite col-vo blinov:');
  readln(col);
  if col=0 then
   exit;
  for i:=1 to 3 do
   begin
     new(s[i]);
     s[i]^.size:=col+1;
     s[i]^.next:=nil;
     s[i]^.flag:=false;
     n[i]:=1;
   end;
  s[2]^.flag:=true;
  n[1]:=col+1;
  for i:=col downto 1 do
   begin
     new(t);
     t^.size:=i;
     t^.flag:=not s[1]^.flag;
     t^.next:=s[1];
     s[1]:=t;
   end;
  oldi:=0;
  oldj:=0;
  for i:=1 to maxdig do
   x[i]:=0;
  while n[3]<>col+1 do
   begin
    for i:=1 to 3 do
     for j:=1 to 3 do
      if(i<>j)and(n[i]<>1)and
      (s[i]^.size<s[j]^.size)and
       (s[i]^.flag<>s[j]^.flag)and
       not((i=oldj)and(j=oldi))then
       begin
         t:=s[i];
         writeln(i,'=>',j);
         s[i]:=s[i]^.next;
         t^.next:=s[j];
         s[j]:=t;
         dec(n[i]);
         incnum;
         inc(n[j]);
         oldi:=i;
         oldj:=j;
         goto m2;
       end;
m2:end;
  write('Vsego perestanovok:');
  i:=1;
  while x[i]=0 do
   inc(i);
  for j:=i to maxdig do
   write(x[j]);
  writeln;
  goto m1;
end.




