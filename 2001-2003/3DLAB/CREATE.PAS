var
  f:text;
  i,j:word;
begin
  assign(f,'newmap.map');
  rewrite(f);
  write(f,100,' ',100,' ');
  for i:=1 to 100 do
   begin
     for j:=1 to 100 do
      write(f,random(16),' ');
     writeln(f);
   end;
  close(f);
end.