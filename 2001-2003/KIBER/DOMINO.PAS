program domino;
uses crt;
const
  maxk=100;
  pathdat='domino.dat';
var
  n,m:array[1..maxk]of byte;
  path:array[1..3,1..maxk]of byte;
  nnew:array[1..maxk]of boolean;
  fdat:text;
  k,i:byte;
procedure gen(ch,l:byte);
var
  i:byte;
begin
  if l=k then
    begin
      writeln('I''am find!');
      for i:=1 to k do
       writeln('num:',path[1,i],' ch1:',path[2,i],' ch2:',path[3,i]);
    end
   else
    for i:=1 to k do
     if ((m[i]=ch)or(n[i]=ch))and nnew[i] then
      begin
        nnew[i]:=false;
        path[1,l+1]:=i;
        path[2,l+1]:=ch;
        if m[i]=ch then
          path[3,l+1]:=n[i]
         else
          path[3,l+1]:=m[i];
        if m[i]=ch then
          gen(n[i],l+1)
         else
          gen(m[i],l+1);
        nnew[i]:=true;
      end;
end;
begin
  clrscr;
  assign(fdat,pathdat);
  reset(fdat);
  read(fdat,k);
  for i:=1 to k do
   read(fdat,n[i],m[i]);
  fillchar(nnew,sizeof(nnew),true);
  for i:=1 to k do
   begin
     nnew[i]:=false;
     path[1,1]:=i;
     path[2,1]:=n[i];
     path[3,1]:=m[i];
     gen(m[i],1);
     path[2,1]:=m[i];
     path[3,1]:=n[i];
     gen(n[i],1);
     nnew[i]:=true;
   end;
  writeln('Done.');
  readln;
end.