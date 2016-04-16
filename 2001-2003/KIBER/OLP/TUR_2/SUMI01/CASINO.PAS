{$A+,B-,D+,E+,F-,G-,I+,L+,N+,O-,P-,Q-,R-,S+,T-,V+,X+,Y+}
{$M 16384,0,655360}
program casino;
const
  maxmn=50;
  pathinp='casino.dat';
  pathout='casino.sol';
  dir:array[1..6,1..4]of byte=
      ((4,2,3,5),(4,6,3,1),(1,2,6,5),(6,2,1,5),(4,1,3,6),(3,2,4,5));
type
  plist=^tlist;
  tlist=record
    i,j,k:byte;
    next:plist;
  end;
  tp=record
    i,j,k:byte;
  end;
  ppath=^tpath;
  tpath=array[1..maxmn,1..maxmn,1..6]of tp;
  tnnew=record
    f:byte;
    p:array[1..3]of shortint;{ugli povorota graney}
  end;
var
  finp,fout:text;
  m,n,i,i1,j,j1,k,k1,k2,k3,k4,max,dk,l:byte;
  a:array[1..maxmn,1..maxmn]of byte;{2500}
  pr,pw,list,t:plist;
  nnew:array[1..maxmn,1..maxmn,1..6]of tnnew;
  path:ppath;
function fm(k:shortint):shortint;
begin
  if k>4 then
    fm:=k-4
   else
    if k<1 then
      fm:=k+4
     else
      fm:=k;
end;
function fp(k:byte):byte;
begin
  case k of
   6:fp:=1;
   5:fp:=2;
   4:fp:=3;
   else
     fp:=k;
  end;
end;
procedure addlist(i,j,k:byte);
var
  t:plist;
begin
  new(t);
  t^.next:=nil;
  t^.i:=i;
  t^.j:=j;
  t^.k:=k;
  if pw<>nil then
    pw^.next:=t
   else
    pr:=t;
  pw:=t;
end;
procedure get(var i,j,k:byte);
var
  t:plist;
begin
  i:=pr^.i;
  j:=pr^.j;
  k:=pr^.k;
  t:=pr;
  pr:=pr^.next;
  dispose(t);
  if pr=nil then
   pw:=nil;
end;
procedure add(i,j,k,ip,jp,kp,d:byte);
var
  f1,f2:byte;
begin
  addlist(i,j,k);
  nnew[i,j,k].f:=1;
  nnew[i,j,k].p:=nnew[ip,jp,kp].p;
  f1:=fp(k1);
  f2:=fp(k2);
  case d of
   1:nnew[i,j,k].p[fp(k2)]:=nnew[ip,jp,kp].p[fp(k2)]-1;
   2:nnew[i,j,k].p[fp(k1)]:=nnew[ip,jp,kp].p[fp(k1)]+1;
   3:nnew[i,j,k].p[fp(k2)]:=nnew[ip,jp,kp].p[fp(k2)]+1;
   4:nnew[i,j,k].p[fp(k1)]:=nnew[ip,jp,kp].p[fp(k1)]-1;
  end;
  with path^[i,j,k] do
   begin
     i:=ip;
     j:=jp;
     k:=kp;
   end;
  if (i=n)and(j=m)and(k>max)then
   max:=k;
end;
begin
  assign(finp,pathinp);
  reset(finp);
  read(finp,n,m);
  for i:=1 to n do
   for j:=1 to m do
    read(finp,a[i,j]);
  close(finp);
  fillchar(nnew,sizeof(nnew),0);
  nnew[1,1,1].f:=1;
  fillchar(nnew[1,1,1].p,sizeof(nnew[1,1,1].p),0);
  pr:=nil;
  pw:=nil;
  new(path);
  addlist(1,1,1);
  max:=0;
  while pr<>nil do
   begin
     get(i,j,k);
     case k of
      1,6:dk:=nnew[i,j,k].p[1];
      2,5:dk:=nnew[i,j,k].p[2];
      3,4:dk:=nnew[i,j,k].p[3];
     end;
     k1:=dir[k,fm(1-dk)];
     k2:=dir[k,fm(2-dk)];
     k3:=dir[k,fm(3-dk)];
     k4:=dir[k,fm(4-dk)];
     if (i>1)and(nnew[i-1,j,k1].f=0)
        and(a[i-1,j]=0)then
      add(i-1,j,k1,i,j,k,1);
     if (j<m)and(nnew[i,j+1,k2].f=0)
        and(a[i,j+1]=0)then
      add(i,j+1,k2,i,j,k,2);
     if (i<n)and(nnew[i+1,j,k3].f=0)
        and(a[i+1,j]=0)then
      add(i+1,j,k3,i,j,k,3);
     if (j>1)and(nnew[i,j-1,k4].f=0)
        and(a[i,j-1]=0)then
      add(i,j-1,k4,i,j,k,4);
   end;
  assign(fout,pathout);
  rewrite(fout);
  if max=0 then
    write(fout,-1)
   else
    begin
      i:=n;
      j:=m;
      k:=max;l:=0;
      while not((path^[i,j,k].i=1)and(path^[i,j,k].j=1)and(path^[i,j,k].k=1))do       begin
         inc(l);
         new(t);
         t^.next:=list;
         t^.i:=i;
         t^.j:=j;
         list:=t;
         i1:=path^[i,j,k].i;
         j1:=path^[i,j,k].j;
         k1:=path^[i,j,k].k;
         i:=i1;j:=j1;k:=k1;
       end;
      writeln(fout,l+1);
      t:=list;
      for i:=1 to l+1 do
       begin
         writeln(fout,t^.i,' ',t^.j);
         t:=t^.next;
       end;
    end;
  close(fout);
  dispose(path);
end.
