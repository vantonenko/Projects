{$r-}
program solve_;
uses crt;
const
  n=5;
  a:array[1..n,1..n]of byte=
   ((0,0,0,1,1),
    (0,0,0,1,1),
    (0,0,0,1,1),
    (1,1,1,0,1),
    (1,1,1,1,0));
var
  nnew:array[1..n]of boolean;
  tree:array[1..2,1..n]of byte;
  turn:array[1..n]of byte;
  r,w,numb:byte;
procedure solve(v,q:byte);
var
  j,i:byte;
begin
  if (r>=w)or keypressed then
   exit;
  j:=q;
  while (j<=n)and(numb<n-1) do
   begin
     if (a[v,j]<>0)and nnew[j] then
      begin
        nnew[j]:=false;
        inc(numb);
        tree[1,numb]:=v;
        tree[2,numb]:=j;
        turn[w]:=j;
        inc(w);
        solve(v,j+1);
        nnew[j]:=true;
        dec(numb);
        dec(w);
      end;
     inc(j);
   end;
  if numb=n-1 then
   begin
     writeln('Yo-o-o-o-u-u!!');
     for i:=1 to numb do
      writeln(tree[1,i],' ',tree[2,i]);
   end;
  if j=n+1 then
   begin
     inc(r);
     solve(turn[r],1);
     dec(r);
   end;
end;
begin
  fillchar(nnew,n,true);
  fillchar(tree,sizeof(tree),0);
  nnew[1]:=false;
  turn[1]:=1;
  r:=1;
  w:=2;
  numb:=0;
  solve(1,1);
  readkey;
end.