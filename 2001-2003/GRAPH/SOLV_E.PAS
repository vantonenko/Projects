{$r-}
program solvetest;
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
  turn:array[1..n]of byte;
  nnew:array[1..n]of boolean;
  tree:array[1..2,1..n-1]of byte;
  numb,up,down:byte;
procedure solve(v,q:integer);
var
  j,i:byte;
begin
  if down>=up then
   exit;
  j:=q;
  while(j<=n)and(numb<n-1) do
   begin
     if (a[v,j]<>0)and nnew[j] then
      begin
        nnew[j]:=false;
        inc(numb);
        tree[1,numb]:=v;
        tree[2,numb]:=j;
        turn[up]:=j;
        inc(up);
        solve(v,j+1);
        dec(up);
        nnew[j]:=true;
        tree[1,numb]:=0;
        tree[2,numb]:=0;
        dec(numb);
      end;
     inc(j);
   end;
  if numb=n-1 then
   begin
     writeln('YOU!');
     for i:=1 to numb do
      write(tree[1,i],' ',tree[2,i],'  ');
     writeln;
     exit;
   end;
  if j=n+1 then
   begin
     inc(down);
     solve(turn[down],1);
     dec(down);
   end;
end;
begin
  clrscr;
  fillchar(nnew,sizeof(nnew),true);
  fillchar(tree,sizeof(tree),0);
  nnew[1]:=false;
  turn[1]:=1;
  down:=1;
  up:=2;
  numb:=0;
  solve(1,1);
  readkey;
end.