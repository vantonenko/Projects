{$A+,B-,D+,E+,F-,G+,I+,L+,N+,O-,P-,Q+,R+,S+,T-,V-,X+,Y+}
{$M 32767,0,655360}
program park;
uses crt;
const
  maxn=100;
var
  x:array[0..maxn+1,0..maxn+1]of byte;
  l,i,j,maxcol,oldc,oldk,n:byte;
  done:boolean;
  sa,sb,sc:set of byte;
procedure generation(i:byte);
var
  k:byte;
begin
  if done then
   exit;
  if i=l+1 then
   begin
     j:=j+1;
     l:=l-1;
     i:=1;
   end;
  if j=n+1 then
    done:=true
   else
    for k:=1 to maxcol+1 do
     if (x[i-1,j]<>k)and(x[i,j-1]<>k)and(x[i+1,j-1]<>k)and
        not((i=1)and(k in sa))
         and not((i=l)and(k in sb))
         and not((j=1)and(k in sc)) then
      begin
        if k>n then
         break;
        oldk:=x[i,j];
        x[i,j]:=k;
        oldc:=maxcol;
        if i=1 then
         sa:=sa+[k];
        if i=l then
         sb:=sb+[k];
        if j=1 then
         sc:=sc+[k];
        if k>maxcol then
         maxcol:=k;
        generation(i+1);
        if done then
         exit;
        if i=1 then
         sa:=sa-[k];
        if i=l then
         sb:=sb-[k];
        if j=1 then
         sc:=sc-[k];
        maxcol:=oldc;
        x[i,j]:=oldk;
      end;
  if i=1 then
   begin
     j:=j-1;
     l:=l+1;
     i:=l;
   end;
end;
label m1;
begin
  clrscr;
m1:write('Введите количество видов деревьев:');
  readln(n);
  if n=0 then
   exit;
  i:=1;j:=1;
  fillchar(x,sizeof(x),0);
  l:=n;
  done:=false;
  maxcol:=0;
  sa:=[];
  sb:=[];
  sc:=[];
  writeln('Digit...');
  generation(1);
  writeln('Done...');
  if done then
    for j:=1 to n do
     begin
       for i:=1 to n-j+1 do
       write(x[i,j]:3);
       writeln;
       for l:=1 to j do
        write(' ');
     end
   else
    writeln('NO SOLUTION');
  gotoxy(1,wherey);
  goto m1;
end.