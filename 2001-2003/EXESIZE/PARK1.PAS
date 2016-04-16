program park;
uses crt;
const
  maxn=100;
var
  x:array[0..1,1..maxn]of byte;
  sa,sb,sw:set of byte;
  n,l,k,i,j,st:byte;
label m1,m2;
begin
  clrscr;
m1:write('Введите кол-во видов деревьев("0"-выход):');
  readln(n);
  if n=0 then
   exit;
  for i:=1 to n do
   begin
     x[0,i]:=i;
     x[1,i]:=0;
   end;
  sa:=[1];
  sb:=[n];
  k:=1;
  l:=n-1;
  for j:=1 to n do
   begin
     for i:=1 to l do
      begin
        sw:=[x[1-k,i]];
        if i>1 then
         sw:=sw+[x[k,i-1]];
        if i<l then
         sw:=sw+[x[1-k,i+1]];
        if i=1 then
         sw:=sw+sa;
        if i=l then
         sw:=sw+sb;
        st:=1;
        while st in sw do
         inc(st);
        x[k,i]:=st;{-------------}
        {if st>n then
         goto m2;}
        if i=1 then
         sa:=sa+[st];
        if i=l then
         sb:=sb+[st];
      end;
     dec(l);
     k:=1-k;
   end;
m2:if st<=n then
     writeln('OK')
    else
     writeln('NO SOLUTION');
  goto m1;
end.