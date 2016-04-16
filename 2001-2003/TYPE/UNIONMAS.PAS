program unionmas;
uses crt;
const
  maxn=100;
var
  m:array[1..2,1..maxn]of integer;
  union:array[1..maxn*2]of integer;
  n,p:array[1..3]of word;
label shut;
begin
  clrscr;
shut:writeln;
  for i:=1 to 2 do
   begin
     write('Vvedite rasmer ',i,'-go massiva:');
     readln(n[i]);
     write('Vvedite ,'i,'-y neubivauschiy massiv);
     for j:=1 to n[i] do
      begin
        read(m[i,j]);
        if (j<>1)and(m[i,j]<m[i,j-1]) then
         goto shut;
        writeln;
      end;
   end;
  write('The union massiv is:');
  p[1]:=1;
  p[2]:=1;
  p[3]:=1;
  while (p[1]<=n[1])and(p[2]<=n[2]) do
   if (m[1,p[1]]<m[2,p[2]])and(p[1] then
    begin
      union[p[3]]:=m[1,p[1]];
      inc(p[3]);
      inc(p[1]);
      if