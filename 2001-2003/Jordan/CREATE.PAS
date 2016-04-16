uses crt;
var
  f:text;
  i,j:byte;
begin
  assign(f,'');
  rewrite(f);
  for i:=1 to 14 do
   begin
     for j:=1 to 14 do
      write(f,0,'  ');
     writeln(f);
   end;
  close(f);
end.