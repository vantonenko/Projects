program datchici;
uses crt;
const
  maxcol=100;
var
  dat,max:array[1..maxcol]of longint;
  dir:array[1..maxcol]of boolean;
  s,i,j,k,col:longint;
  c:char;
  f:boolean;
label m1;
begin
  clrscr;
m1:write('Vvedite col-vo datchicov:');
  readln(col);
  s:=1;
  f:=true;
  for i:=1 to col do
   begin
     write('Vvedite col-vo polozheniy,nachalnoe polozhenie ',i,'-go datchica:');
     readln(max[i],dat[i]);
     dir[i]:=not f;
     f:=dir[i];
     s:=s*max[i];
   end;
  for i:=1 to s do
   begin
     k:=col;
     while(dat[k]=max[k])and(k>0)do
      dec(k);
     for j:=k+1 to col do
      begin
        dat[j]:=1;
        dir[j]:=not dir[j];
      end;
     if k>0 then
      inc(dat[k]);
     for j:=1 to col do
      if dir[j] then
        write(max[j]-dat[j]+1)
       else
        write(dat[j]);
     writeln;
   end;
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.