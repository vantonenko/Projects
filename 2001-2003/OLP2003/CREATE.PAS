const
  x=109;
  y=155;{x:y=col-vo "1":col-vu "0"}
  max=100;
var
  f:text;
  i,j:byte;
begin
  assign(f,'bacteria.dat');
  rewrite(f);
  writeln(f,max,' ',max);
  randomize;
  for i:=1 to max do
   begin
     for j:=1 to max do
      if random(x+y)<=x-1 then
        write(f,1,' ')
       else
        write(f,0,' ');
     writeln(f);
   end;
  close(f);
end.