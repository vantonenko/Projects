program hanoi;
uses crt;
const
  {maxdig=20;}
  maxblin=100;
var
  {x:array[1..maxdig]of byte;}
  s:array[1..3,1..maxblin]of byte;
  n:array[1..3]of byte;
  f:array[1..3]of boolean;
  i,j,oldi,oldj,t,col:byte;
  c:char;
  num:longint;
{procedure incnum;
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
end;}
label m1;
begin
  clrscr;
m1:write('Vvedite cov-vo blinov:');
  readln(col);
  if col=0 then
   exit;
  fillchar(s,sizeof(s),0);
  fillchar(n,sizeof(n),0);
  fillchar(f,sizeof(f),true);
  n[1]:=col+1;
  n[2]:=1;
  n[3]:=1;
  s[1,1]:=col+1;
  s[2,1]:=col+1;
  s[3,1]:=col+1;
  f[2]:=false;
  j:=2;
  for i:=col downto 1 do
   begin
     s[1,j]:=i;
     f[1]:=not f[1];
     inc(j);
   end;
  {for i:=1 to maxdig do
   x[i]:=0;}
  while n[3]<>col+1 do
   for i:=1 to 3 do
    for j:=1 to 3 do
     if(i<>j)and(n[i]<>0)and
      (s[i,n[i]]<s[j,n[j]])and
      (f[i]<>f[j])and not((i=oldj)and(j=oldi)) then
      begin
        inc(n[j]);
        s[j,n[j]]:=s[i,n[i]];
        s[i,n[i]]:=0;
        dec(n[i]);
        {incnum;}
        inc(num);
        oldi:=i;
        oldj:=j;
        f[j]:=not f[j];
        f[i]:=not f[i];
      end;
  write('Vsego perestanovok:');
  {i:=1;
  while x[i]=0 do
   inc(i);
  for j:=i to maxdig do
   write(x[j]);}
  write(num);
  writeln;
  goto m1;
end.

