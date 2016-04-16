program nugolnik;
uses crt;
const
  maxn=100;
var
  ad:array[1..maxn,1..maxn]of byte;
  n,i,j,k,s,d,a,b:byte;
  c:char;
function inter(a,b,j,k:byte):boolean;{j<k,a<b}
begin
  inter:=((j<b)and(j>a)and(k>b))or
         ((a<k)and(a>j)and(k<b));
end;
label m1;
begin
  clrscr;
m1:write('Vvwdite col-vo vershin n-ugolnika:');
  readln(n);
  write('Vvedite col-vo diagonaley:');
  readln(d);
  fillchar(ad,n*n,0);
  s:=1;
  for i:=1 to d do
   begin
     write('Vvedite nomera vershin ',i,'-y diagonali:');
     readln(a,b);
     if a>b then
      begin
        a:=a+b;
        b:=a-b;
        a:=a-b;
      end;
     if(a=b)or(abs(a-b)=1)then continue;
     ad[a,b]:=1;
     inc(s);
     for j:=1 to n do
      for k:=1 to n do
       if(j<k)and(ad[j,k]=1)and inter(a,b,j,k)then
        inc(s);
   end;
  writeln('Col-vo chastey:',s);
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.

