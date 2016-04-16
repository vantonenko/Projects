program digitrim;
uses crt;
const
  m:array[1..4,'1'..'3']of char=(('I','V','X'),('X','L','C'),
  ('C','D','M'),('M','T','F'));
procedure drim(a:word;var s:string);
begin
  case a of
   0:s:='';
   1:s:='1';
   2:s:='11';
   3:s:='111';
   4:s:='12';
   5:s:='2';
   6:s:='21';
   7:s:='211';
   8:s:='2111';
   9:s:='13';
  end;
end;
var
  s,ss:string;
  k,a:word;
  d,i,j:word;
  c:char;
label m1;
begin
  clrscr;
m1:write('Vvedite chislo:');
  readln(k);
  if k>9999 then
   goto m1;
  if k=0 then
   exit;
  s:='';
  d:=1000;
  for i:=4 downto 1 do
   begin
     a:=k div d;
     k:=k mod d;
     d:=d div 10;
     drim(a,ss);
     for j:=1 to length(ss) do ss[j]:=m[i,ss[j]];
     s:=s+ss;
   end;
  writeln(s);
  goto m1;
end.