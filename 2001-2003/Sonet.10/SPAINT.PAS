unit spaint;

interface

uses kernel,sources,graph,mouse;
const
  paintframesize:tpoint=(x:320;y:240);
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
    constructor init(r:trect);
    procedure handlevent(var event:tevent);virtual;
  end;
  ppaintapp=^tpaintapp;
  tpaintapp=object(twindow)
    paintframe:ppaintframe;
    constructor init(x,y:integer);
    procedure handlevent(var event:tevent);virtual;
  end;

implementation

constructor tpaintapp.init;
var
  r:trect;
  i,j:integer;
begin
  r.assign(x,y,x+paintframesize.x,y+paintframesize.y);
  inherited init(r,false,'S-Paint');
  {setstate(false,sfgrowx+sfgrowy+sfzoom);}
  for i:=0 to 1 do
   for j:=0 to 7 do
    insert(new(pcolorbutton,init(4+20*i,24+20*j,i*8+j)));
  r.assign(46,22,size.x-4,size.y-4);
  paintframe:=new(ppaintframe,init(r));
  insert(paintframe);
end;
procedure tpaintapp.handlevent;
begin
  inherited handlevent(event);
  if (event.what and evcommand<>0)and(event.command=cmchangecolor) then
   begin
     paintframe^.color:=event.infoword;
     event.what:=evnothing;
   end;
end;
constructor tpaintframe.init;
begin
  inherited init(r);
  color:=0;
end;
procedure tpaintframe.handlevent;
var
  dx,dy:integer;
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
       putpixel(event.global.x,event.global.y,color);
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
  event.what:=evnothing;
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
   end;
end;

end.