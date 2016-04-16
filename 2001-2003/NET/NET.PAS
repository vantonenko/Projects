program net;
const
  maxn=100;
  maxlong=high(longint);
  pathinp='net.dat';
  pathout='net.out';
var
  a:array[1..maxn,1..maxn]of longint;
  ostov:array[1..2,1..maxn-1]of byte;
  m:byte;{size of ostov}
  x,y:array[1..maxn]of integer;
  st:array[1..maxn]of byte;
  nnew:array[1..maxn]of boolean;
  colors:array[1..maxn]of byte;
  vm:array[1..maxn]of byte;
  pos,color,v,imin,jmin:byte;
  min:longint;
  n:byte;{col-vo computerov}
  l,i,j,k:word;{col-vo svyazey}
  fdat,fout:text;
begin
  assign(fdat,pathinp);
  reset(fdat);
  read(fdat,n);
  for i:=1 to n do
   read(fdat,x[i],y[i]);
  fillchar(a,n*n*4,0);
  for i:=1 to n do
   for j:=1 to n do
    if i<>j then
     a[i,j]:=-sqr(longint(x[i])-longint(x[j]))-sqr(longint(y[i])-longint(y[j]));
  read(fdat,l);
  for k:=1 to l do
   begin
     read(fdat,i,j);
     a[i,j]:=abs(a[i,j]);
     a[j,i]:=a[i,j];
   end;
  close(fdat);
  fillchar(colors,n,0);
  color:=0;
  for k:=1 to n do
   if colors[k]=0 then
    begin
      inc(color);
      pos:=1;
      st[pos]:=k;
      fillchar(nnew,n,true);
      while pos<>0 do
       begin
         v:=st[pos];
         colors[v]:=color;
         dec(pos);
         for i:=1 to n do
          if (a[v,i]>0)and nnew[i] then
           begin
             inc(pos);
             st[pos]:=i;
             nnew[i]:=false;
           end;
       end;
    end;
  fillchar(vm,sizeof(vm),0);
  vm[1]:=1;
  m:=0;
  for k:=1 to color-1 do
   begin
     min:=maxlong;
     for i:=1 to n-1 do
      for j:=i+1 to n do
       if (vm[colors[i]]+vm[colors[j]]=1)and(abs(a[i,j])<min) then
        begin
          min:=abs(a[i,j]);
          imin:=i;
          jmin:=j;
        end;
     vm[colors[imin]]:=1;
     vm[colors[jmin]]:=1;
     inc(m);
     ostov[1,m]:=imin;
     ostov[2,m]:=jmin;
   end;
  assign(fout,pathout);
  rewrite(fout);
  writeln(fout,m);
  for i:=1 to m do
   writeln(fout,ostov[1,i],' ',ostov[2,i]);
  close(fout);
end.