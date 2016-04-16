program calc;
uses crt;
type
  plist=^tlist;
  tlist=record
    sign:boolean;
    next:plist;
    case boolean of
     true:(a:word);
     false:(c:char);
  end;
var
  steck:plist;
procedure polska(var s:string);
var
  i,j:byte;
  c:char;
  ss:string;
begin
  i:=0;
  fillchar(ss,256,0);
  ss[0]:=chr(255);
  while i<=length(s) do
   begin
     inc(i);
     c:=s[i];
     if ss[i]='1' then continue;
     if c in ['+','-','*','/'] then s[i]:=' ';
     if c in ['*','/'] then
      begin
        j:=i;
        while (s[j+1] in ['0'..'9'])and(j<=length(s))do inc(j);
        insert(c,s,j+1);
        insert('1',ss,j+1);
      end;
     if c in ['+','-'] then
      begin
        j:=i;
        while (s[j+1] in ['0'..'9','*','/'])and(j<=length(s))do inc(j);
        insert(c,s,j+1);
        insert('1',ss,j+1);
      end;
   end;
end;
procedure push(flag:boolean;a:word;c:char);
var
  t:plist;
begin
  new(t);
  t^.sign:=flag;
  if flag then
   t^.a:=a
  else
   t^.c:=c;
  t^.next:=steck;
  steck:=t;
end;
label m1;
var
  s,ss:string;
  c:char;
  i:byte;
  a:word;
  code:integer;
begin
  clrscr;
m1:writeln('Vvedite virazhenie:');
  readln(s);
  polska(s);
  steck:=nil;
  while s<>'' do
   begin
     i:=1;
     while not(s[i]in ['+','-','*','/',' ']) do
      inc(i);
     ss:=copy(s,1,i-1);
     if i<>1 then
      begin
       val(ss,a,code);
       push(true,a,s[i]);
      end;
     if s[i]<>' ' then
       push(false,a,s[i]);
     delete(s,1,i);
     if s[1]=' ' then
       delete(s,1,1);
   end;
  writeln(s);
  c:=readkey;
  if c<>#27 then goto m1;
end.