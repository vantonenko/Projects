program calc;
uses crt;
type
  plist=^tlist;
  tlist=record
    sign:boolean;
    next,pred:plist;
    case boolean of
     false:(a:longint);
     true:(c:char);
  end;
var
  t,tt,list,klist:plist;
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
     if c in ['+','-','*'{,'/'}] then s[i]:=' ';
     if c in ['*'{,'/'}] then
      begin
        j:=i;
        while (s[j+1] in ['0'..'9'])and(j<=length(s))do inc(j);
        insert(c,s,j+1);
        insert('1',ss,j+1);
      end;
     if c in ['+','-'] then
      begin
        j:=i;
        while (s[j+1] in ['0'..'9','*'{,'/'}])and(j<=length(s))do inc(j);
        insert(c,s,j+1);
        insert('1',ss,j+1);
      end;
   end;
end;
label m1;
var
  s,ss:string;
  c:char;
  i:byte;
  a,b:longint;
  code:integer;
procedure push(flag:boolean;a:longint;c:char);
var
  t:plist;
begin
  new(t);
  t^.sign:=flag;
  if flag then
    t^.c:=c
   else
    t^.a:=a;
  t^.next:=nil;
  t^.pred:=klist;
  if klist<>nil then
    klist^.next:=t;
  klist:=t;
  if list=nil then
    list:=klist;
end;
function calc2(a,b:longint;c:char):longint;
begin
  case c of
   '+':calc2:=a+b;
   '-':calc2:=a-b;
   '*':calc2:=a*b;
  end;
end;
begin
  clrscr;
m1:writeln('Vvedite virazhenie:');
  readln(s);
  polska(s);
  list:=nil;
  klist:=nil;
  while s<>'' do
   begin
     i:=1;
     while not(s[i]in ['+','-','*','/',' ']) do
      inc(i);
     ss:=copy(s,1,i-1);
     if i<>1 then
      begin
       val(ss,a,code);
       push(false,a,s[i]);
      end;
     if s[i]<>' ' then
       push(true,a,s[i]);
     delete(s,1,i);
     if s[1]=' ' then
       delete(s,1,1);
   end;
  t:=list;
  while t<>klist do
   if t^.sign then
    begin
      a:=t^.pred^.pred^.a;
      b:=t^.pred^.a;
      new(tt);
      if t=klist then
       klist:=tt;
      tt^.sign:=false;
      tt^.a:=calc2(a,b,t^.c);
      if t^.pred^.pred^.pred<>nil then
        t^.pred^.pred^.pred^.next:=tt;
      tt^.pred:=t^.pred^.pred^.pred;
      tt^.next:=t^.next;
      t^.next^.pred:=tt;
      dispose(t^.pred^.pred);
      dispose(t^.pred);
      dispose(t);
      t:=tt;
      if keypressed then exit;
     end;
  if t<>nil then
   writeln(t^.a);
  c:=readkey;
  if c<>#27 then goto m1;
end.