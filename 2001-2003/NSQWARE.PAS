program nscware;
uses crt;
const
  maxn=100;
var
  x,y:array[1..maxn]of integer;
function ex(a:extended):extended;
begin
  if a=0 then ex:=0;
  if a>0 then
   ex:=400000000000.0
  else
   ex:=-400000000000.0;
end;
var
  n,i:byte;
  sn,di1,di2,a,b,c,p,s:extended;
  ch:char;
label m1;
begin
  clrscr;
m1:writeln('Vvedite col-vovershin N-ugolnika:');
  readln(n);
  for i:=1 to n do
   begin
     writeln('Vvedite coordinati ',i,' vershini:');
     readln(x[i],y[i]);
   end;
  sn:=0;
  for i:=1 to n-2 do
   begin
     a:=sqrt(sqr(x[1]-x[i+1])+sqr(y[1]-y[i+1]));
     b:=sqrt(sqr(x[1]-x[i+2])+sqr(y[1]-y[i+2]));
     c:=sqrt(sqr(x[i+1]-x[i+2])+sqr(y[i+1]-y[i+2]));
     p:=(a+b+c)/2;
     s:=sqrt(p*(p-a)*(p-b)*(p-c));
     if x[i+1]=x[1] then
      di1:=ex(y[i+1]-y[1])
     else
      di1:=(y[i+1]-y[1])/(x[i+1]-x[1]);
     if x[i+2]=x[1] then
      di2:=ex(y[i+2]-y[1])
     else
      di2:=(y[i+2]-y[1])/(x[i+2]-x[1]);
     if di1>di2 then
      sn:=sn+s
     else
      sn:=sn-s;
   end;
  if sn<0 then sn:=-sn;
  writeln('Sqware:',sn:0:5);
  ch:=readkey;
  if ch<>#27 then goto m1;
end.



