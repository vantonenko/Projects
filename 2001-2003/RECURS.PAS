program recurs_;
uses crt;
var
  n:byte;
  s:array[1..255]of byte;
procedure generation(i:byte);
begin

end;
label m;
begin
  clrscr;
m:writeln('Введите N:');
  readln(n);
  if n=0 then
   exit;
  generation(1);
end.