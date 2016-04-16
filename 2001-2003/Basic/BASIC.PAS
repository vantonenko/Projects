uses crt;
const
  find=' ƒŽ‘’ ';
var
  f,out:text;
  c:char;
  s:string;
  i,j:integer;
begin
  assign(f,'basic.txt');
  reset(f);
  assign(out,'out.txt');
  rewrite(out);
  j:=0;
  while not eof(f) do
   begin
     readln(f,s);
     inc(j);
     i:=pos(find,s);
     if (i<>0)and(s[i+length(find)] in ['0'..'9']) then
      writeln(out,j,' ',i);
   end;
  close(f);
  close(out);
end.