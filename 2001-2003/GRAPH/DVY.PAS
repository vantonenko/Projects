program dvy_;
uses crt;
const
  n=9;
  m=12;
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
function min(a,b:byte):byte;
begin
  if a<b then
    min:=a
   else
    min:=b;
end;
var
  num,lowpq:array[1..n]of byte;
  nm,vv,pos:byte;
  st:array[1..2,1..m]of byte;
procedure push(v,u:byte);
begin
  inc(pos);
  st[1,pos]:=v;
  st[2,pos]:=u;
end;
procedure dvy(v,p:byte);
var
  u:byte;
begin
  inc(nm);
  num[v]:=nm;
  lowpq[v]:=num[v];
  for u:=1 to n do
   if a[v,u]<>0 then
    if num[u]=0 then
      begin
        push(v,u);
        dvy(u,v);
        lowpq[v]:=min(lowpq[v],lowpq[u]);
        if lowpq[u]>=num[v] then
         begin
           writeln('Есть!');
           repeat
             writeln(st[1,pos],' ',st[2,pos]);
             dec(pos);
           until st[1,pos+1]=v;
         end;
      end
     else
      if (u<>p)and(num[v]>num[u]) then
       begin
         {vershini "u" i "v"
          prinadlezhat odnoy componente}
         push(v,u);
         lowpq[v]:=min(lowpq[v],num[u]);
       end;
end;
begin
  clrscr;
  fillchar(num,sizeof(num),0);
  fillchar(lowpq,sizeof(lowpq),0);
  nm:=0;
  pos:=0;
  for vv:=1 to n do
   if num[vv]=0 then
    dvy(vv,0);
  writeln('Vsyo!');
  readkey;
end.