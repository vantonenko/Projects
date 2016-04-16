program parkst;
uses crt;
const
  maxn=100;
type
  ttask=record
    i,k,maxcol:byte;
  end;
var
  x:array[0..maxn+1,0..maxn+1]of byte;
  st:array[1..(maxn+2)*(maxn+2)div 2+1]of ttask;
  pos:word;
  n,i,j,k,l,m,maxcol:byte;
  done,enable:boolean;
  sa,sb,sc:set of byte;
label m1;
begin
  clrscr;
m1:write('Введите кол-во видов деревьев:');
  readln(n);
  if n=0 then
   exit;
  fillchar(x,sizeof(x),0);
  pos:=1;
  st[pos].i:=1;
  st[pos].k:=1;
  st[pos].maxcol:=0;
  done:=true;
  l:=n;
  j:=1;
  sa:=[];
  sb:=[];
  sc:=[];
  while (pos<>0)and done do
   begin
     i:=st[pos].i;
     k:=st[pos].k;
     maxcol:=st[pos].maxcol;
     if i=l+1 then
      begin
        l:=l-1;
        j:=j+1;
        i:=1;
        st[pos].i:=1;
      end;
     if j=n+1 then
      done:=false;
     enable:=true;
     for m:=k to maxcol+1 do
      if (x[i-1,j]<>m)and(x[i,j-1]<>m)
          and(x[i+1,j-1]<>m)and
         not((i=1)and(m in sa))
        and not((i=l)and(m in sb))
        and not((j=1)and(m in sc)) then
      begin
        if m>n then
         break;
        enable:=false;
        if i=1 then
         sa:=sa+[m];
        if i=l then
         sb:=sb+[m];
        if j=1 then
         sc:=sc+[m];
        x[i,j]:=m;
        break;
      end;
     if enable{вариантов нет} then
       begin
         dec(pos);
         if i=1 then
          begin
            l:=l+1;
            j:=j-1;
          end;
         if i=1 then
          sa:=sa-[x[i,j]];
         if i=l then
          sb:=sb-[x[i,j]];
         if j=1 then
          sc:=sc-[x[i,j]];
       end
      else
       begin
         st[pos].k:=m+1;
         if m>maxcol then
          st[pos].maxcol:=m;
         inc(pos);
         st[pos].maxcol:=st[pos-1].maxcol;
         st[pos].i:=i+1;
         st[pos].k:=1;
       end;
   end;
  if done then
    writeln('Вариантов нет.')
   else
    for j:=1 to n do
     begin
       for i:=1 to n-j+1 do
       write(x[i,j]:3);
       writeln;
       for l:=1 to j do
        write(' ');
     end;
  gotoxy(1,wherey);
  goto m1;
end.