program dvycomp;
uses crt;
const
  n=9;
  a:array[1..n,1..n]of byte=
  ((0,1,1,0,0,0,0,0,0),
   (1,0,1,1,0,0,0,0,0),
   (1,1,0,1,0,0,0,0,0),
   (0,1,1,0,1,1,1,0,0),
   (0,0,0,1,0,1,0,1,0),
   (0,0,0,1,1,0,1,0,0),
   (0,0,0,1,0,1,0,0,1),
   (0,0,0,0,1,0,0,0,0),
   (0,0,0,0,0,0,1,0,0));
var
  num,lowpg:array[1..n]of byte;
  col,i,pos:byte;
  st:array[1..2,1..n*n]of byte;
function min(a,b:byte):byte;
begin
  if a<b then
    min:=a
   else
    min:=b;
end;
procedure search(v,p:byte);
var
  u:byte;
begin
  inc(col);
  num[v]:=col;
  lowpg[v]:=col;
  for u:=1 to n do
   if a[v,u]<>0 then
    if num[u]=0 then
      begin
        inc(pos);
        st[1,pos]:=v;
        st[2,pos]:=u;
        search(u,v);
        lowpg[v]:=min(lowpg[v],lowpg[u]);
        if lowpg[u]>=num[v] then
         begin
           writeln('I''am find!');
           repeat
             writeln(st[1,pos],' ',st[2,pos]);
             dec(pos);
           until st[1,pos+1]=v;
         end;
      end
     else
      if (u<>p)and(num[v]>num[u]) then
       begin
         inc(pos);
         st[1,pos]:=v;
         st[2,pos]:=u;
         lowpg[v]:=min(lowpg[v],num[u]);
       end;
end;
begin
  clrscr;
  fillchar(num,sizeof(num),0);
  col:=0;
  pos:=0;
  fillchar(lowpg,sizeof(lowpg),0);
  for i:=1 to n do
   if num[i]=0 then
    search(i,0);
  readln
end.