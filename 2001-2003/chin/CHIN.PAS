program chinovnik;
uses crt;
const
  maxchin=100;
type
  plist=^tlist;
  tlist=record
    ch:word;
    next:plist;
  end;
  tchin=record
    nac:word;
    bax:word;
    nvar:word;
    lis:array[1..15]of plist{подчиненные};
  end;
var
  chin:array[1..maxchin]of tchin;
  colchin,i,j:word;
  fdat:text;
  t:plist;
  mins,s,c,k:word;
procedure gen(ch:word);
var
  t:plist;
  s1:word;
  flag:boolean;
  i:word;
begin
  s:=s+chin[ch].bax;
  for i:=1 to chin[ch].nvar do
   begin
     s1:=s;
     t:=chin[ch].lis[i];
     flag:=true;
     while t<>nil do
      begin
        s:=s+chin[t^.ch].bax;
        gen(t^.ch);
        flag:=flag and (chin[t^.ch].nvar=0);
        t:=t^.next;
      end;
     if flag and (s<mins) then
      mins:=s;
     s:=s1;
   end;
  s:=s-chin[ch].bax;
end;
begin
  clrscr;
  assign(fdat,'chin.dat');
  reset(fdat);
  readln(fdat,colchin);
  for i:=1 to colchin do
   with chin[i] do
    begin
      read(fdat,nac);{начальник}
      read(fdat,bax);
      read(fdat,nvar);
      for j:=1 to nvar do
       begin
         lis[j]:=nil;
         read(fdat,c);
         for k:=1 to c do
          begin
            new(t);
            read(fdat,t^.ch);
            t^.next:=lis[j];
            lis[j]:=t;
          end;
       end;
    end;
  close(fdat);
  s:=0;
  mins:=65535;
  gen(1);
  writeln(mins);
  readln;
end.
