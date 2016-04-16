unit spaint;

interface

uses kernel,sources,graph,mouse;
const
  paintframesize:tpoint=(x:300;y:200);
  cmchangecolor=100;
type
  pcolorbutton=^tcolorbutton;
  tcolorbutton=object(tview)
    color:word;
    constructor init(x,y:integer;acolor:word);
    procedure draw;virtual;
    procedure handlevent(var event:tevent);virtual;
  end;
  ppaintframe=^tpaintframe;
  tpaintframe=object(tframe)
    color:word;
    timertask:ptask;
    constructor init(r:trect);
    procedure handlevent(var event:tevent);virtual;
    destructor done;virtual;
  end;
  ppaintapp=^tpaintapp;
  tpaintapp=object(twindow)
    paintframe:ppaintframe;
    timertask:ptask;
    constructor init(x,y:integer);
    procedure handlevent(var event:tevent);virtual;
    destructor done;virtual;
  end;

implementation

constructor tpaintapp.init;
var
  r:trect;
  i,j:integer;
begin
  r.assign(x,y,x+300,y+200);
  inherited init(r,false,'S-Paint');
  setstate(false,sfgrowx+sfgrowy+sfzoom);
  for i:=0 to 1 do
   for j:=0 to 7 do
    insert(new(pcolorbutton,init(4+20*i,24+20*j,i*8+j)));
  r.assign(46,22,size.x-4,size.y-4);
  timertask:=new(ptimertask,init(@self,cmchangecolor,90,false));
  newtask(timertask);
  paintframe:=new(ppaintframe,init(r));
  insert(paintframe);
end;
procedure tpaintapp.handlevent;
begin
  inherited handlevent(event);
  if (event.what and evcommand<>0)and(event.command=cmchangecolor) then
   paintframe^.color:=event.infoword;
  event.what:=evnothing;
end;
destructor tpaintapp.done;
begin
  inherited done;
  timertask^.kill:=true;
end;
constructor tpaintframe.init;
begin
  inherited init(r);
  color:=0;
  timertask:=new(ptimertask,init(@self,cmtime,0,false));
  newtask(timertask);
end;
procedure tpaintframe.handlevent;
var
  dx,dy,i,j,c:integer;
  r:trect;
begin
  if (event.what and evmouseauto<>0)and(event.where.x>3)and(event.where.y>3)and
     (event.where.x<size.x-3)and(event.where.y<size.y-3) then
   begin
     hidemouse;
     dx:=event.global.x-event.where.x;
     dy:=event.global.y-event.where.y;
     setcolor(color);
     setlinestyle(0,0,3);
     if (oldmousewhere.x-dx>3)and(oldmousewhere.y-dy>3)and
        (oldmousewhere.x-dx<size.x-3)and(oldmousewhere.y-dy<size.y-3) then
       line(oldmousewhere.x,oldmousewhere.y,event.global.x,event.global.y)
      else
       graph.putpixel(event.global.x,event.global.y,color);
     setlinestyle(0,0,1);
     showmouse;
   end;
  if event.what and evmouserdown<>0 then
   begin
     setfillstyle(1,color);
     hidemouse;
     floodfill(event.global.x,event.global.y,0);
     showmouse;
   end;
  c:=random(15);
  if (event.what and evcommand<>0)and(event.command=cmtime) then
   drawrect(random(size.x-2)+2,random(size.y-2)+2,random(size.x-2)+2,random(size.y-2)+2,color);
  event.what:=evnothing;
end;
destructor tpaintframe.done;
begin
  inherited done;
  timertask^.kill:=true;
end;
constructor tcolorbutton.init;
var
  r:trect;
begin
  r.assign(x,y,x+20,y+20);
  color:=acolor;
  inherited init(r);
end;
procedure tcolorbutton.draw;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(1,color);
  setcolor(0);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  rectangle(r.a.x,r.a.y,r.b.x,r.b.y);
  iorun;
end;
procedure tcolorbutton.handlevent;
begin
  if event.what and evmouseldown<>0 then
    begin
      event.what:=evcommand;
      event.command:=cmchangecolor;
      event.infoword:=color;
    end
   else
    event.what:=evnothing;
end;

end.