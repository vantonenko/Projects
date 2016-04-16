program perestr;
uses crt;
var
  x:string;
  n,i:byte;
procedure swap(var a,b:char);
var
  c:char;
begin
  if a<>b then
   begin
     c:=a;
     a:=b;
     b:=c;
   end;
end;
procedure generation(k:byte);
var
  i:word;
begin
  if k=n then
    writeln(x)
   else
    for i:=k to n do
     begin
       swap(x[k],x[i]);
       generation(k+1);
       swap(x[k],x[i]);
     end;
end;
label m1;
begin
  clrscr;
m1:write('Введите строку:');
  readln(x);
  if x='' then
   exit;
  n:=length(x);
  generation(1);
  goto m1;
end.