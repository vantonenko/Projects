program determ;
uses crt;
const
  size=200;
type
  ts=array[1..size] of extended;
  ps=^ts;
var
  m:array[1..size] of ps;
  sm:ts;
  det,koeff:extended;
  s,i,j:byte;
  sign:shortint;
label l;
begin
  clrscr;
l:writeln('Digit...');
  randomize;
  for i:=1 to size do
   begin
     new(m[i]);
     for j:=1 to size do
      m[i]^[j]:=random(10)+1;
   end;
  det:=0;
  sign:=1;
  for s:=1 to size do
   begin
     i:=s;
     while (i<=size)and(m[s]^[i]=0) do
      inc(i);
     if i=size+1 then
      break;
     if i>s then
      begin
        sm:=m[s]^;
        m[s]:=m[i];
        m[i]^:=sm;
        sign:=-sign;
      end;
     for i:=s+1 to size do
      begin
        koeff:=m[i]^[s]/m[s]^[s];
        for j:=s to size do
         m[i]^[j]:=m[i]^[j]-m[s]^[j]*koeff;
      end;
   end;
  if i<>size+1 then
   begin
     det:=sign;
     for i:=1 to size do
      det:=det*m[i]^[i];
   end;
  for i:=1 to size do
   dispose(m[i]);
  writeln('DET=',det:0:18);
  if readkey<>#13 then
   goto l;
end.