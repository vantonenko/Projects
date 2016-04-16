{$b-}
program p2a3a;
uses crt;
type
  plist=^tlist;
  tlist=record
    a:word;
    next:plist;
  end;
const
  k:array[1..3]of byte=(2,3,5);
var
  list,t,tt:plist;
  cur:plist;
  size,n,a,i,c:longint;
  ch:char;
label m1;
begin
  clrscr;
m1:writeln('Vvedite N:');
  readln(n);
  new(list);
  list^.a:=1;
  list^.next:=nil;
  size:=1;
  cur:=list;
  while size <n do
   begin
     a:=cur^.a;
     for i:=1 to 3 do
      begin
        t:=cur;
        c:=a*k[i];
        while(cur^.next<>nil)and(cur^.next^.a<c)do
         cur:=cur^.next;
        if (cur^.next=nil)or(cur^.next^.a<>c)then
         begin
           new(tt);
           tt^.next:=cur^.next;
           tt^.a:=c;
           cur^.next:=tt;
           inc(size);
         end;
        cur:=t;
      end;
     cur:=cur^.next;
   end;
  cur:=list;
  for i:=1 to n do
   begin
     writeln(cur^.a);
     cur:=cur^.next;
   end;
  while list<>nil do
   begin
     t:=list;
     list:=list^.next;
     dispose(t);
   end;
  ch:=readkey;
  if ch<>#27 then goto m1;
end.