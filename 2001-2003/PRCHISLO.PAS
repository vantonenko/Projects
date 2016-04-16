program prchislo;
uses crt;
var
  n,k,l,i,col:longint;
  f:boolean;
label m1;
begin
  clrscr;
m1:write('Vvedite max chislo:');
  readln(n);
  if n=0 then
   exit;
  writeln('Prostie chisla is intervala 1..',n,':');
  col:=0;
  for i:=1 to n do
   begin
     k:=i;
     l:=2;
     f:=true;
     while (k<>1)and f do
      if k mod l=0 then
        begin
          k:=k div l;
          f:=l=i;
        end
       else
        if l*l>k then
          l:=k
         else
          inc(l);;
     if f then
      begin
        write(i:8);
        inc(col);
      end;
   end;
  writeln;
  goto m1;
end.