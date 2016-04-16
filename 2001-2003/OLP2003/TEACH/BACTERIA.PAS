program bacteria;
{$b-,r+}
const
  maxn=100;
  maxm=100;
  pathinp='bacteria.dat';
  pathout='bacteria.sol';
  unical=65535;
type
  ppoint=^tpoint;
  tpoint=record
    i,j:byte;
    next:ppoint;
  end;
var
  a:array[0..maxn+1,0..maxm+1]of word;
    {a[0,j],a[maxn+1,j],a[i,0],a[i,maxm+1]-fictive}
  m,n,i,j:byte;{size of matrix}
  st:array[1..2,1..(maxm+2)*(maxn+2)]of byte;{steck}
  pos,color:word;{the pointer of the steck}
  points,t:ppoint;
  finp,fout:text;
procedure push(i,j:byte);
begin
  inc(pos);
  st[1,pos]:=i;
  st[2,pos]:=j;
end;
procedure fill(i,j:byte;ground,color:word;enable:boolean);
{enable:true-kletki po diagonali-sosedi,else net}
var
  vi,vj:byte;
  oldpos:word;
begin
  pos:=1;
  st[1,pos]:=i;
  st[2,pos]:=j;
  while pos<>0 do
   begin
     vi:=st[1,pos];
     vj:=st[2,pos];
     a[vi,vj]:=color;
     oldpos:=pos;
     if (vi<>0)and(a[vi-1,vj]=ground) then
      push(vi-1,vj);
     if enable and(vi<>0)and(vj<>0)and(a[vi-1,vj-1]=ground) then
      push(vi-1,vj-1);
     if (vj<>0)and(a[vi,vj-1]=ground) then
      push(vi,vj-1);
     if enable and(vi<>n+1)and(vj<>0)and(a[vi+1,vj-1]=ground) then
      push(vi+1,vj-1);
     if (vi<>n+1)and(a[vi+1,vj]=ground) then
      push(vi+1,vj);
     if enable and(vi<>n+1)and(vj<>m+1)and(a[vi+1,vj+1]=ground) then
      push(vi+1,vj+1);
     if (vj<>m+1)and(a[vi,vj+1]=ground) then
      push(vi,vj+1);
     if enable and(vi<>0)and(vj<>m+1)and(a[vi-1,vj+1]=ground) then
      push(vi-1,vj+1);
     if pos=oldpos then{not filling points is epsent}
      dec(pos);
   end;
end;
begin
  assign(finp,pathinp);
  reset(finp);
  read(finp,m,n);
  fillchar(a,sizeof(a),0);
  for j:=1 to m do
   for i:=1 to n do
    read(finp,a[i,j]);
  close(finp);
  fill(0,0,0,unical,false);
  points:=nil;
  color:=1;
  for j:=1 to m do
   for i:=1 to n do
    if a[i,j]=1 then
     begin
       inc(color);
       new(t);
       t^.next:=points;
       points:=t;
       t^.i:=i;
       t^.j:=j;
       fill(i,j,1,color,true);
     end;
  t:=points;
  color:=0;
  while t<>nil do
   begin
     with t^ do
      if (a[i-1,j]<>0)or(a[i,j-1]<>0)or
       (a[i+1,j]<>0)or(a[i,j+1]<>0) then
       inc(color);
     t:=t^.next;
   end;
  assign(fout,pathout);
  rewrite(fout);
  write(fout,color);
  close(fout);
  while points<>nil do
   begin
     t:=points;
     points:=points^.next;
     dispose(t);
   end;
  writeln(color);
  readln;
end.