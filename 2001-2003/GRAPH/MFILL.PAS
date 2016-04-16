program mfill;
uses graph,crt,views,mouse;
type
  plist=^tlist;
  tlist=record
    x,y:integer;
    next:plist;
  end;
var
  bq,eq:plist;
  x,y,oldx,oldy,i:integer;
  f:boolean;
  c:char;
  c1,c2,c3,c4:byte;
procedure init;
begin
  bq:=nil;
  eq:=nil;
end;
procedure add(x,y:integer);
var
  t:plist;
begin
  new(t);
  t^.next:=nil;
  t^.x:=x;
  t^.y:=y;
  if eq<>nil then
    eq^.next:=t
   else
    bq:=t;
  eq:=t;
end;
procedure get(var x,y:integer);
var
  t:plist;
begin
  if (bq=nil)or(eq=nil) then
   exit;
  t:=bq;
  bq:=bq^.next;
  x:=t^.x;
  y:=t^.y;
  dispose(t);
  if bq=nil then
   eq:=nil;
end;
procedure handlevent(event:tevent);far;
begin
  if event.what and evmouseldown<>0 then
   begin
     f:=true;
     oldx:=0;
     oldy:=0;
     hidemouse;
     putpixel(event.global.x,event.global.y,15);
     showmouse;
   end;
  if event.what and evmouselup<>0 then
   f:=false;
  if f and(event.what and evmousemove<>0)then
  begin
   hidemouse;
   if(oldx=0)and(oldy=0)then
     putpixel(event.global.x,event.global.y,15)
    else
     line(oldx,oldy,event.global.x,event.global.y);
   showmouse;
   oldx:=event.global.x;
   oldy:=event.global.y;
  end;
  if event.what and evmouserup<>0 then
   begin
     x:=mousewhere.x;
     y:=mousewhere.y;
     hidemouse;
     init;
     add(x,y);
     while bq<>nil do
      begin
        get(x,y);
        putpixel(x,y,4);
        if getpixel(x-1,y)=0 then
         add(x-1,y);
        if getpixel(x,y-1)=0 then
         add(x,y-1);
        if getpixel(x+1,y)=0 then
         add(x+1,y);
        if getpixel(x,y+1)=0 then
         add(x,y+1);
      end;
     showmouse;
   end;
end;
begin
  initgraph(x,y,'c:\programs\bp\bgi');
  oldx:=0;
  oldy:=0;
  f:=false;
  mousehandleron(handlevent);
  showmouse;
  repeat
    c:=readkey;
    if c=#13 then
     begin
       hidemouse;
       cleardevice;
       showmouse;
     end;
  until c=#27;
end.