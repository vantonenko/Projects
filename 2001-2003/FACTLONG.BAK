program factlong;
uses crt;
const
  maxl=2000;
type
  tlong=record
    ch:array[1..maxl]of byte;
    length:word;
  end;
var
  k:word;
  s,fact:tlong;
  n:word;
procedure add(x,y:tlong;var zz:tlong);{z:=x+y}
var
  i:word;
  a:byte;
  z:tlong;
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
  zz:=z;
end;
procedure out(x:tlong);
var
  i:word;
begin
  with x do
   for i:=maxl-length+1 to maxl do
    write(ch[i]);
end;
procedure shift(var x:tlong;dl:word);
var
  i:word;
begin
  for i:=maxl-x.length-dl+1 to maxl-dl do
   x.ch[i]:=x.ch[i+dl];
  for i:=maxl-dl+1 to maxl do
   x.ch[i]:=0;
  inc(x.length,dl);
end;
procedure mul1(x:tlong;c:byte;var y:tlong);
var
  dx:word;
  d:word;
  i:word;
begin
  dx:=0;
  y.length:=x.length;
  for i:=maxl downto maxl-x.length+1 do
   begin
     d:=x.ch[i]*c+dx;
     y.ch[i]:=d mod 10;
     dx:=d div 10;
     if (i=maxl-x.length+1)and(dx<>0) then
      begin
        inc(y.length);
        y.ch[i-1]:=dx;
      end;
   end;
end;
procedure mul(x,y:tlong;var zz:tlong);
var
  i:word;
  dl:word;
  z:tlong;
  s:tlong;
begin
  fillchar(z,sizeof(z),0);
  dl:=0;
  for i:=maxl downto maxl-y.length+1 do
   begin
     fillchar(s,sizeof(s),0);
     mul1(x,y.ch[i],s);
     shift(s,dl);
     inc(dl);
     add(s,z,z);
   end;
  zz:=z;
end;
procedure incx(var x:tlong);
var
  i,j:word;
begin
  i:=maxl;
  while (maxl-i+1<=x.length)and(x.ch[i]=9) do
   dec(i);
  if maxl-i+1>x.length then
   inc(x.length);
  inc(x.ch[i]);
  for j:=i+1 to maxl do
   x.ch[j]:=0;
end;
var
  x,y:tlong;
label m1;
begin
  clrscr;
m1:write('Enter N:');
  readln(n);
  if n=0 then
   exit;
  fillchar(fact,sizeof(fact),0);
  fact.length:=1;
  fact.ch[maxl]:=1;
  fillchar(s,sizeof(s),0);
  for k:=1 to n do
   begin
     incx(s);
     mul(fact,s,fact);
   end;
  write('F!:');
  out(fact);
  writeln;
  goto m1;
end.