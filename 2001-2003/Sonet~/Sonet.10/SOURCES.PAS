unit sources;

interface

uses kernel,graph,mouse;
type
  pbutton=^tbutton;
  tbutton=object(tview)
    command:word;
    mode:boolean;
    press:boolean;
    constructor init(r:trect;acommand:word;amode:boolean);
    procedure handlevent(var event:tevent);virtual;
    procedure draw;virtual;
    procedure drawpress;virtual;
    procedure drawrelease;virtual;
    procedure putcommand(var event:tevent);
  end;

  pdialogbutton=^tdialogbutton;
  tdialogbutton=object(tbutton)
    font:tfont;
    name,promt:string;
    dx:word;
    constructor init(x,y,acommand:word;amode:boolean;aname:string;afont:tfont);
    procedure drawpress;virtual;
    procedure drawrelease;virtual;
    destructor done;virtual;
  end;

  pclosebutton=^tclosebutton;
  tclosebutton=object(tbutton)
    constructor init(x,y,sx,sy:integer);
    procedure drawpress;virtual;
    procedure drawrelease;virtual;
  end;

  pzoombutton=^tzoombutton;
  tzoombutton=object(tbutton)
    constructor init(x,y,sx,sy:integer);
    procedure drawpress;virtual;
    procedure drawrelease;virtual;
  end;

  pdownbutton=^tdownbutton;
  tdownbutton=object(tbutton)
    constructor init(x,y,sx,sy:integer);
    procedure drawpress;virtual;
    procedure drawrelease;virtual;
  end;

  pwindowtitle=^twindowtitle;
  twindowtitle=object(tgroup)
    move:boolean;
    mousestate:tpoint;
    constructor init(r:trect);
    procedure draw;virtual;
    procedure handlevent(var event:tevent);virtual;
  end;

  pwindow=^twindow;
  twindow=object(tgroup)
    constructor init(r:trect);
    procedure draw;virtual;
    procedure setstate(enable:boolean;astate:word);virtual;
    procedure handlevent(var event:tevent);virtual;
  end;

implementation

const
  textkoeffy=1+1/3;
constructor tbutton.init;
begin
  inherited init(r);
  command:=acommand;
  mode:=amode;
  press:=false;
end;

procedure tbutton.handlevent;
var
  oldpress,mousein:boolean;
begin
  oldpress:=press;
  mousein:=(event.where.x>=0)and(event.where.y>=0)and
           (event.where.x<=size.x)and
           (event.where.y<=size.y);
  if mousein and(owner^.auto=@self)and not press then
   press:=true;
  if (press and not mousein)or(event.what and evmouselup<>0) then
   press:=false;
  if press<>oldpress then
   draw;
  if (event.what and evmouseldown<>0)and mode then
   putcommand(event);
  if (event.what and evmouselup<>0)and(owner^.auto=@self)and
     mousein and not mode then
   putcommand(event);
  if event.what and evmouse<>0 then
   event.what:=evnothing;
end;

procedure tbutton.draw;
begin
  if press then
    drawpress
   else
    drawrelease;
end;

procedure tbutton.drawpress;
begin
end;

procedure tbutton.drawrelease;
begin
end;

procedure tbutton.putcommand;
begin
  event.what:=evcommand;
  event.command:=command;
end;

constructor tdialogbutton.init;
var
  r:trect;
begin
  font:=afont;
  name:=aname;
  settextstyle(font.font,0,font.charsize);
  if textwidth(name[1])>textwidth(name[length(name)])then
    dx:=textwidth(name[1])+1
   else
    dx:=textwidth(name[length(name)])+1;
  r.a.x:=x;
  r.a.y:=y;
  r.b.x:=x+dx+textwidth(name)+dx-1;
  r.b.y:=y+round(textkoeffy*textheight(name))+1;
  inherited init(r,acommand,amode);
end;

procedure tdialogbutton.drawpress;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(1,7);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  settextstyle(font.font,0,font.charsize);
  outtextxy(r.a.x+dx+1,r.a.y+1,name);
  setcolor(15);
  line(r.a.x,r.b.y,r.b.x,r.b.y);
  line(r.b.x,r.a.y,r.b.x,r.b.y-1);
  setcolor(8);
  line(r.a.x+1,r.a.y+1,r.b.x-2,r.a.y+1);
  line(r.a.x+1,r.a.y+2,r.a.x+1,r.b.y-2);
  iorun;
end;
procedure tdialogbutton.drawrelease;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(1,7);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.b.x,r.a.y,r.b.x,r.b.y);
  line(r.a.x,r.b.y,r.b.x-1,r.b.y);
  settextstyle(font.font,0,font.charsize);
  outtextxy(r.a.x+dx,r.a.y,name);
  setcolor(8);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
  line(r.a.x+1,r.b.y-1,r.b.x-2,r.b.y-1);
  setcolor(15);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  iorun;
end;

destructor tdialogbutton.done;
begin
  inherited done;
end;

constructor tclosebutton.init;
var
  r:trect;
begin
  r.a.x:=x;
  r.a.y:=y;
  r.b.x:=x+sx-1;
  r.b.y:=y+sy-1;
  inherited init(r,cmclose,false);
end;

procedure tclosebutton.drawpress;
var
  r:trect;
begin
  setfillstyle(1,7);
  getextend(r);
  iostop(r);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  line(r.a.x+5,r.a.y+4,r.b.x-4,r.b.y-3);
  line(r.a.x+5,r.b.y-3,r.b.x-4,r.a.y+4);
  line(r.a.x+6,r.a.y+4,r.b.x-3,r.b.y-3);
  line(r.a.x+6,r.b.y-3,r.b.x-3,r.a.y+4);
  setcolor(15);
  line(r.a.x,r.b.y,r.b.x,r.b.y);
  line(r.b.x,r.a.y,r.b.x,r.b.y-1);
  setcolor(8);
  line(r.a.x+1,r.a.y+1,r.b.x-2,r.a.y+1);
  line(r.a.x+1,r.a.y+2,r.a.x+1,r.b.y-2);
  iorun;
end;

procedure tclosebutton.drawrelease;
var
  r:trect;
begin
  setfillstyle(1,7);
  getextend(r);
  iostop(r);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.b.x,r.a.y,r.b.x,r.b.y);
  line(r.a.x,r.b.y,r.b.x-1,r.b.y);
  line(r.a.x+4,r.a.y+3,r.b.x-5,r.b.y-4);
  line(r.a.x+4,r.b.y-4,r.b.x-5,r.a.y+3);
  line(r.a.x+5,r.a.y+3,r.b.x-4,r.b.y-4);
  line(r.a.x+5,r.b.y-4,r.b.x-4,r.a.y+3);
  setcolor(8);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
  line(r.a.x+1,r.b.y-1,r.b.x-2,r.b.y-1);
  setcolor(15);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  iorun;
end;

constructor tzoombutton.init;
var
  r:trect;
begin
  r.a.x:=x;
  r.a.y:=y;
  r.b.x:=x+sx-1;
  r.b.y:=y+sy-1;
  inherited init(r,cmzoom,false);
end;
procedure tzoombutton.drawpress;
var
  r:trect;
begin
  setfillstyle(1,7);
  getextend(r);
  iostop(r);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  line(r.a.x+4,r.a.y+3,r.b.x-3,r.a.y+3);
  line(r.a.x+4,r.a.y+4,r.b.x-3,r.a.y+4);
  line(r.a.x+4,r.a.y+5,r.a.x+4,r.b.y-2);
  line(r.b.x-3,r.a.y+4,r.b.x-3,r.b.y-2);
  line(r.a.x+5,r.b.y-2,r.b.x-4,r.b.y-2);
  setcolor(15);
  line(r.a.x,r.b.y,r.b.x,r.b.y);
  line(r.b.x,r.a.y,r.b.x,r.b.y-1);
  setcolor(8);
  line(r.a.x+1,r.a.y+1,r.b.x-2,r.a.y+1);
  line(r.a.x+1,r.a.y+2,r.a.x+1,r.b.y-2);
  iorun;
end;

procedure tzoombutton.drawrelease;
var
  r:trect;
begin
  setfillstyle(1,7);
  getextend(r);
  iostop(r);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.b.x,r.a.y,r.b.x,r.b.y);
  line(r.a.x,r.b.y,r.b.x-1,r.b.y);
  line(r.a.x+3,r.a.y+2,r.b.x-4,r.a.y+2);
  line(r.a.x+3,r.a.y+3,r.b.x-4,r.a.y+3);
  line(r.a.x+3,r.a.y+4,r.a.x+3,r.b.y-3);
  line(r.b.x-4,r.a.y+3,r.b.x-4,r.b.y-3);
  line(r.a.x+4,r.b.y-3,r.b.x-5,r.b.y-3);
  setcolor(8);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
  line(r.a.x+1,r.b.y-1,r.b.x-2,r.b.y-1);
  setcolor(15);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  iorun;
end;

constructor tdownbutton.init;
var
  r:trect;
begin
  r.a.x:=x;
  r.a.y:=y;
  r.b.x:=x+sx-1;
  r.b.y:=y+sy-1;
  inherited init(r,cmdown,false);
end;
procedure tdownbutton.drawpress;
var
  r:trect;
begin
  setfillstyle(1,7);
  getextend(r);
  iostop(r);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  line(r.a.x+5,r.b.y-3,r.b.x-5,r.b.y-3);
  line(r.a.x+5,r.b.y-2,r.b.x-5,r.b.y-2);
  setcolor(15);
  line(r.a.x,r.b.y,r.b.x,r.b.y);
  line(r.b.x,r.a.y,r.b.x,r.b.y-1);
  setcolor(8);
  line(r.a.x+1,r.a.y+1,r.b.x-2,r.a.y+1);
  line(r.a.x+1,r.a.y+2,r.a.x+1,r.b.y-2);
  iorun;
end;

procedure tdownbutton.drawrelease;
var
  r:trect;
begin
  setfillstyle(1,7);
  getextend(r);
  iostop(r);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.b.x,r.a.y,r.b.x,r.b.y);
  line(r.a.x,r.b.y,r.b.x-1,r.b.y);
  line(r.a.x+4,r.b.y-4,r.b.x-6,r.b.y-4);
  line(r.a.x+4,r.b.y-3,r.b.x-6,r.b.y-3);
  setcolor(8);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
  line(r.a.x+1,r.b.y-1,r.b.x-2,r.b.y-1);
  setcolor(15);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  iorun;
end;

constructor twindowtitle.init;
var
  rr:trect;
  h:integer;
begin
  inherited init(r);
  h:=size.y-3;
  move:=false;
  insert(new(pclosebutton,init(size.x-h-3,2,h+2,h)));
  insert(new(pzoombutton,init(size.x-h-h-7,2,h+2,h)));
  insert(new(pdownbutton,init(size.x-h-h-h-9,2,h+2,h)));
end;
procedure twindowtitle.draw;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  if owner^.state and sffocused<>0 then
    setfillstyle(1,1)
   else
    setfillstyle(1,8);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  iorun;
  inherited draw;
end;
procedure twindowtitle.handlevent;
begin
  inherited handlevent(event);
  if (event.what and evmouse<>0)and event.double then
   begin
     event.what:=evcommand;
     event.command:=cmzoom;
   end;
  if event.what and evmouseldown<>0 then
   begin
     move:=true;
     mousestate:=event.global;
   end;
  if (event.what and evmouselup<>0)and move then
   begin
     move:=false;
     if abs(mousewhere.x-mousestate.x)+abs(mousewhere.y-mousestate.y)>1 then
      begin
        owner^.owner^.clear(owner);
        inc(owner^.origin.x,mousewhere.x-mousestate.x);
        inc(owner^.origin.y,mousewhere.y-mousestate.y);
        owner^.draw;
      end;
   end;
end;

constructor twindow.init;
var
  rr:trect;
begin
  inherited init(r);
  rr.a.x:=3;
  rr.b.x:=size.x-3;
  rr.a.y:=3;
  rr.b.y:=20;
  options:=options or oftopselect;
  insert(new(pwindowtitle,init(rr)));
end;
procedure twindow.draw;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(1,7);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.b.x,r.a.y,r.b.x,r.b.y);
  line(r.a.x,r.b.y,r.b.x-1,r.b.y);
  setcolor(8);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
  line(r.b.x-2,r.b.y-1,r.a.x+1,r.b.y-1);
  setcolor(15);
  line(r.a.x+1,r.a.y+1,r.b.x-2,r.a.y+1);
  line(r.a.x+1,r.a.y+2,r.a.x+1,r.b.y-2);
  iorun;
  inherited draw;
end;
procedure twindow.setstate;
begin
  inherited setstate(enable,astate);
  if (astate and sffocused<>0)and(state and sflife<>0) then
   draw;
end;
procedure twindow.handlevent;
begin
  inherited handlevent(event);
  if (event.what and evcommand<>0)and(event.command=cmclose) then
   begin
     event.what:=evnothing;
     free;
   end;
end;

end.