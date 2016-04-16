uses mouse,views,crt,graph;
const
  speed=500;
var
  a,b,oldx,oldy:integer;
  f:boolean;
  color,ws:word;
  rect:boolean;
procedure handlevent(event:tevent);far;
begin
  if event.what and evmouseldown<>0 then
   begin
     if event.ctrl then
      begin
        if ws=1 then ws:=3
        else ws:=1;
        setlinestyle(0,0,ws);
        exit;
      end;
     f:=true;
     oldx:=0;
     oldy:=0;
     hidemouse;
     putpixel(event.global.x,event.global.y,color);
     showmouse;
   end;
  if event.what and evmouselup<>0 then
   f:=false;
  if f and(event.what and evmousemove<>0)then
  begin
   hidemouse;
   setcolor(color);
   if event.shift then
     begin
       if ws=1 then ws:=3
       else ws:=1;
       setlinestyle(0,0,ws);
     end;
   if(oldx=0)and(oldy=0)then
     putpixel(event.global.x,event.global.y,color)
    else
     if rect then
       line(oldx,oldy,event.global.x,event.global.y)
      else
       begin
         setfillstyle(1,color);
         bar3d(oldx,oldy,event.global.x,event.global.y,
         (abs(event.global.x-oldx)+abs(event.global.y-oldy)) div 2,true);
         {rectangle(oldx,oldy,event.global.x,event.global.y);}
       end;
   if event.shift then
     begin
       if ws=1 then ws:=3
       else ws:=1;
       setlinestyle(0,0,ws);
     end;
   showmouse;
   oldx:=event.global.x;
   oldy:=event.global.y;
  end;
  if event.what and evmouserup<>0 then
   if event.ctrl then
     rect:=not rect
    else
     begin
       inc(color);
       if color>=15 then
       color:=0;
     end;
  if event.double then
   begin
     hidemouse;
     setfillstyle(1,15{color});
     bar(0,0,639,479);
     {c:=bkcolor;
     bkcolor:=color;
     color:=c;}
     showmouse;
   end;
end;
begin
  initgraph(a,b,'..\');
  f:=false;
  color:=0;
  oldx:=0;
  oldy:=0;
  ws:=3;
  rect:=true;
  setfillstyle(1,15);
  bar(0,0,639,479);
  setlinestyle(0,0,ws);
  mousehandleron(handlevent);
  showmouse;
  setdoublespeed(speed);
  setmousespeed(6,6);
  repeat
    {nop}
  until keypressed;
  if ord(readkey)=0 then
   readkey;
  hidemouse;
  mousehandleroff;
  closegraph;
end.