program confer;
const
  maxn=100;
type
  tset=set of byte;
var
  a:array[1..maxn,1..maxn]of byte;
  v,n,i,j,k,m,l,pos:byte;
  lang:array[1..maxn]of tset;
  nnew:array[1..maxn]of boolean;
  st:array[1..maxn]of byte;
  finp,fout:text;
  p:boolean;
label mm;
begin
  assign(finp,'confer.dat');
  reset(finp);
  read(finp,n);
  fillchar(a,sizeof(a),0);
  for i:=1 to n do
   lang[i]:=[];
  for i:=1 to n do
   begin
     read(finp,k);
     for j:=1 to k do
      begin
        read(finp,m);
        lang[i]:=lang[i]+[m];
        for l:=1 to n do
         if m in lang[l] then
          begin
            a[i,l]:=1;
            a[l,i]:=1;
          end;
      end;
   end;
  close(finp);
  for i:=1 to n do
   lang[i]:=[];
  st[1]:=1;
  fillchar(nnew,n,true);
  nnew[1]:=false;
  pos:=1;
  while pos<>0 do
   begin
     v:=st[pos];
     i:=0;
     repeat
       if (a[v,i+1]<>0)and(i=0)and(pos=n) then
        goto mm;
       p:=(a[v,i+1]<>0)and nnew[i+1] and not((i+1)in lang[v]);
       inc(i);
     until p or(i+1>n);
     if p then
       begin
         inc(pos);
         st[pos]:=i;
         nnew[i]:=false;
       end
      else
       begin
         nnew[v]:=true;
         lang[v]:=[];
         dec(pos);
         if pos<>0 then
          lang[st[pos]]:=lang[st[pos]]+[v];
       end;
   end;
mm:assign(fout,'confer.sol');
  rewrite(fout);
  for i:=1 to pos do
   writeln(fout,st[i]);
  close(fout);
end.