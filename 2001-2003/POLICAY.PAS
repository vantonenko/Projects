program policay;
uses crt;
const
  m=18;{col-vo reber}
  n=10;{col-vo vershin}
 r:array[1..3,1..m]of integer=
    ((1,1,2,2,2,3,3,3,4, 4,5,5,6,6,7,7, 8, 9),
     (2,5,3,6,7,4,5,8,6,10,6,7,8,9,8,9,10,10),
     (7,1,9,3,7,1,8,1,9, 5,5,1,6,7,2,7, 6, 1));
type
  tpath=array[1..n]of byte;
  tlen=array[1..n]of integer;
var
  c:char;
function searchpath(io,ik:integer;var s:tpath;var l:tlen):longint;
var
  smax:longint;
  i,n1,n2,dl,f:byte;
begin
  smax:=0;
  for i:=1 to m do
   inc(smax,r[3,i]);
  for i:=1 to n do
   begin
     s[i]:=0;
     l[i]:=smax;
   end;
  l[io]:=0;
  f:=1;
  while f=1 do
   begin
     f:=0;
     for i:=1 to m do
      begin
        n1:=r[1,i];
        n2:=r[2,i];
        dl:=r[3,i];
        if l[n2]>l[n1]+dl then
          begin
            l[n2]:=l[n1]+dl;
            s[n2]:=n1;
            f:=1;
          end
         else
          if l[n1]>l[n2]+dl then
           begin
             l[n1]:=l[n2]+dl;
             s[n1]:=n2;
             f:=1;
           end;
      end;
   end;
  if s[ik]=0 then
    searchpath:=0
   else
    searchpath:=l[ik];
end;
var
  i,j,im,jm:byte;
  a:array[1..n,1..n]of boolean;
  sm,s:tpath;
  l,lm:tlen;
  max,p:longint;
  mxpath:array[1..2,1..m]of byte;
  size:byte;
  len:real;
begin
  clrscr;
  max:=0;
  fillchar(a,sizeof(a),true);
  for i:=1 to n do
   a[i,i]:=false;
  for i:=1 to n do
   for j:=1 to n do
    if a[j,i] then
     begin
       p:=searchpath(i,j,s,l);
       if p>max then
        begin
          im:=i;
          jm:=j;
          sm:=s;
          lm:=l;
          max:=p;
        end;
       a[i,j]:=false;
     end;
  size:=0;
  if sm[jm]=0 then
    writeln('Path not found')
   else
    begin
      i:=jm;
      while i<>im do
       begin
         inc(size);
         mxpath[2,size]:=lm[i]-lm[sm[i]];
         i:=sm[i];
         mxpath[1,size]:=i;
       end;
      writeln;
    end;
  i:=1;
  j:=0;
  len:=max/2;
  while j<len do
   begin
     inc(j,mxpath[2,i]);
     inc(i);
   end;
  if j=len then
    writeln('V vershine ',mxpath[1,i-1])
   else
    begin
      write('Na rastoyanii ',j-len:0:2,
      ' ot vershini ',mxpath[1,i-1],
      ' k vershine ');
      if i=2 then write(jm)
       else write(mxpath[1,i-2]);
    end;
  readln;
end.