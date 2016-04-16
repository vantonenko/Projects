program minpath;
uses crt;
const
  m=18;
  n=10;
  r:array[1..3,1..m]of integer=
    ((1,1,2,2,2,3,3,3,4, 4,5,5,6,6,7,7, 8, 9),
     (2,5,3,6,7,4,5,8,6,10,6,7,8,9,8,9,10,10),
     (2,1,9,3,7,1,8,1,9, 1,5,1,6,7,2,9, 6, 1));
var
  s,l:array[1..n]of integer;
  c:char;
  smax:longint;
  i,n1,n2,dl,f,io,ik:byte;
label m1;
begin
  clrscr;
m1:write('Vvedite nomera vhodyachey i vihodyachey vershin:');
  readln(io,ik);
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
    writeln('Path not found')
   else
    begin
      write('The more short path is:');
      i:=ik;
      while i<>0 do
       begin
         write(i,' ');
         i:=s[i];
       end;
      writeln;
    end;
  writeln(l[ik]);
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.