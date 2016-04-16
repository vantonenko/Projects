program fibonach;
uses crt;
const
  maxl=2000;{max количество цифр в числе}
type
  tlong=record
    ch:array[1..maxl]of byte;
    length:word;
  end;
var
  n,i:longint;
  f0,f1,f2:tlong;
  a:byte;
  l:word;
procedure copy(var x,y:tlong);
begin
  move(y,x,sizeof(tlong));
end;
procedure add(x,y:tlong;var z:tlong);{z:=x+y}
var
  i:word;
begin
  fillchar(z,sizeof(z),0);
  i:=maxl;
  while maxl-i+1<=x.length do
   begin
     a:=x.ch[i]+y.ch[i];
     z.ch[i]:=a mod 10;
     a:=a div 10;
     if (a<>0)and(maxl-i+2>x.length) then
      inc(x.length);
     x.ch[i-1]:=x.ch[i-1]+a;
     dec(i);
   end;
  z.length:=maxl-i;
  if z.length=0 then
   z.length:=1;
end;
procedure out(x:tlong);
var
  i:integer;
begin
  with x do
   for i:=maxl-length+1 to maxl do
    write(ch[i]);
end;
label m1;
begin
  clrscr;
m1:write('Enter N(or "0" to quit):');
  readln(n);
  if n=0 then
   exit;
  fillchar(f0,sizeof(f0),0);
  f0.length:=1;
  f0.ch[maxl]:=1;
  fillchar(f1,sizeof(f1),0);
  f1.length:=1;
  f1.ch[maxl]:=2;
  for i:=1 to n do
   begin
     add(f1,f0,f2);
     copy(f0,f1);
     copy(f1,f2);
     writeln;
     write('I:',i, ' ');
     out(f0);
   end;
  writeln;
  {write('F:');}
  out(f0);
  writeln;
  goto m1;
end.