unit sources;

interface

uses kernel,graph,mouse,dos;
const
  minwindowsize:tpoint=(x:160;y:120);
  controlpanelheight=26;
  winshortcutwidth=158;
  filltype=1;

  backgroundcolor=3;
  wingreycolor=7;

  fillpattern:fillpatterntype=(255,255-$c3,255-$24,255-$24,255-$24,255-$24,255-$c3,255);
  framecolor=15;
  maxcolwindow=20;
  downcount=20;
  downtemp=30;
  zoomcount=10;
  zoomtemp=50;
  winshortcutsize:integer=winshortcutwidth;
  smallfont:tfont=(font:2;charsize:4);
  bigfont:tfont=(font:2;charsize:5);

type
  string2=string[2];
  twindowname=string[80];
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
    name:twindowname;
    dx:word;
    constructor init(x,y,acommand:word;amode:boolean;aname:twindowname;afont:tfont);
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
    name:twindowname;
    constructor init(r:trect);
    procedure draw;virtual;
    procedure handlevent(var event:tevent);virtual;
  end;

  pwinshortcut=^twinshortcut;

  pwindow=^twindow;
  twindow=object(tgroup)
    zoom,growx,growy:boolean;
    rzoom:trect;
    mousestate:tpoint;
    minsize:tpoint;
    title:pwindowtitle;
    shortcut:pwinshortcut;
    constructor init(r:trect;azoom:boolean;aname:twindowname);
    procedure draw;virtual;
    procedure handlevent(var event:tevent);virtual;
    procedure setstate(enable:boolean;astate:word);virtual;
  end;

  pframe=^tframe;
  tframe=object(tgroup)
    fillstyle,fillcolor:integer;
    constructor init(r:trect);
    procedure draw;virtual;
  end;

  pcontrolpanel=^tcontrolpanel;
  tcontrolpanel=object(tgroup)
    shortcutgroup:pgroup;
    constructor init;
    procedure draw;virtual;
    procedure clean(r:trect);virtual;
  end;

  twinshortcut=object(tview)
    name:twindowname;
    window:pwindow;
    press:boolean;
    down:boolean;
    dx:integer;
    constructor init(aname:twindowname;xx,len:word;awindow:pwindow);
    procedure draw;virtual;
    procedure handlevent(var event:tevent);virtual;
    procedure setstate(enable:boolean;astate:word);virtual;
    procedure free;virtual;
  end;

  pclock=^tclock;
  tclock=object(tview)
    ch,cm:longint;
    hs,ms:string2;
    constructor init(x:integer);
    procedure gettime(var h,m:longint);
    procedure draw;virtual;
    procedure handlevent(var event:tevent);virtual;
  end;

var
  controlpanel:pcontrolpanel;
const
  sonetself:pgroup=nil;
  clock:pview=nil;

implementation
uses crt;

const
  textkoeffy=1+1/3;

function getstrline(str:twindowname;l:word):twindowname;
begin
  if textwidth(str)>l then
    begin
      while (str<>'')and(textwidth(str+'...')>l) do
       str[0]:=chr(ord(str[0])-1);
      getstrline:=str+'...';
    end
   else
    getstrline:=str;
end;

constructor tbutton.init;
begin
  inherited init(r);
  command:=acommand;
  mode:=amode;
  press:=false;
  options:=options and not ofselectable;
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
  r.b.y:=y+round(textkoeffy*textheight(name))+3;
  inherited init(r,acommand,amode);
end;

procedure tdialogbutton.drawpress;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(1,wingreycolor);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  settextstyle(font.font,0,font.charsize);
  outtextxy(r.a.x+dx+1,r.a.y+2,name);
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
  setfillstyle(1,wingreycolor);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.b.x,r.a.y,r.b.x,r.b.y);
  line(r.a.x,r.b.y,r.b.x-1,r.b.y);
  settextstyle(font.font,0,font.charsize);
  outtextxy(r.a.x+dx,r.a.y+1,name);
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
  r.assign(x,y,x+sx-1,y+sy-1);
  inherited init(r,cmclose,false);
  growmode:=gfgrowlox+gfgrowhiy;
end;

procedure tclosebutton.drawpress;
var
  r:trect;
begin
  setfillstyle(1,wingreycolor);
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
  setfillstyle(1,wingreycolor);
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
  r.assign(x,y,x+sx-1,y+sy-1);
  inherited init(r,cmzoom,false);
  growmode:=gfgrowlox+gfgrowhiy;
end;
procedure tzoombutton.drawpress;
var
  r:trect;
begin
  setfillstyle(1,wingreycolor);
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
  setfillstyle(1,wingreycolor);
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
  r.assign(x,y,x+sx-1,y+sy-1);
  inherited init(r,cmdown,false);
  growmode:=gfgrowlox+gfgrowhiy;
end;
procedure tdownbutton.drawpress;
var
  r:trect;
begin
  setfillstyle(1,wingreycolor);
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
  setfillstyle(1,wingreycolor);
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
  growmode:=gfgrowhiy+gfgrowhix+gfgrowlox;
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
  if owner^.state and sffocused<>0 then
    setcolor(15)
   else
    setcolor(wingreycolor);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  settextstyle(smallfont.font,0,smallfont.charsize);
  outtextxy(r.a.x+5,r.a.y+2,getstrline(name,size.x-{size.y}(first^.size.x+2)*7 div 2));
  iorun;
  inherited draw;
end;
procedure twindowtitle.handlevent;
var
  r:trect;
begin
  inherited handlevent(event);
  if (event.what and evmouseldown<>0)and(owner^.state and sfmove<>0) then
   begin
     move:=true;
     blocktask:=false;
     mousestate:=event.global;
   end;
  if (owner^.state and sfmove<>0)and move and
     (event.what and evmousemove<>0) then
   begin
     owner^.getextend(r);
     hidemouse;
     setcolor(framecolor);
     setwritemode(1);
     setlinestyle(4,$5555,1);
     if event.what and evmouseldown=0 then
       rectangle(r.a.x+oldmousewhere.x-mousestate.x,r.a.y+oldmousewhere.y-mousestate.y
        ,r.b.x+oldmousewhere.x-mousestate.x,r.b.y+oldmousewhere.y-mousestate.y);
     rectangle(r.a.x+mousewhere.x-mousestate.x,r.a.y+mousewhere.y-mousestate.y
        ,r.b.x+mousewhere.x-mousestate.x,r.b.y+mousewhere.y-mousestate.y);
     setlinestyle(0,0,1);
     setwritemode(0);
     showmouse;
   end;
  if (event.what and evmouselup<>0)and move and
     (owner^.state and sfmove<>0) then
   begin
     move:=false;
     blocktask:=true;
     if abs(mousewhere.x-mousestate.x)+abs(mousewhere.y-mousestate.y)>0 then
      begin
        if mousewhere.y>rscreen.b.y-controlpanelheight-2 then
         mousewhere.y:=rscreen.b.y-controlpanelheight-2;
        owner^.owner^.clear(owner);
        inc(owner^.origin.x,mousewhere.x-mousestate.x);
        inc(owner^.origin.y,mousewhere.y-mousestate.y);
        owner^.draw;
      end
   end;
  if (event.what and evmouse<>0)and event.double then
   begin
     event.what:=evcommand;
     event.command:=cmzoom;
   end;
end;

constructor twindow.init;
var
  rr:trect;
begin
  zoom:=azoom;
  shortcut:=nil;
  if zoom then
   begin
     r.assign(0,0,rscreen.b.x+1,rscreen.b.y+1);
     rzoom:=r;
   end;
  inherited init(r);
  options:=options and not offullvisible;
  rr.assign(3,3,size.x-3,20);
  options:=options or (oftopselect+ofrefresh);
  growx:=false;
  growy:=false;
  tview.setstate(true,sfmove+sfgrowx+sfgrowy+sfzoom);
  minsize:=minwindowsize;
  title:=new(pwindowtitle,init(rr));
  title^.name:=aname;
  insert(title);
end;
procedure twindow.draw;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(1,wingreycolor);
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

procedure twindow.handlevent;
var
  r,wr,rr:trect;
  fclear,fdraw:boolean;
  gx,gy,i:integer;
  t:pview;
begin
  inherited handlevent(event);
  fclear:=false;
  fdraw:=false;
  gx:=0;
  gy:=0;
  if (event.what and evmouseldown<>0)and(state and sfgrowx<>0)and
     (event.global.x-origin.x>size.x-5) then
   begin
     growx:=true;
     mousestate:=event.global;
   end;
  if (event.what and evmouselup<>0)and growx and
     (state and sfgrowx<>0) then
   begin
     growx:=false;
     if abs(mousewhere.x-mousestate.x)>1 then
      begin
        if mousewhere.x-mousestate.x<0 then
         fclear:=true;
        if size.x+mousewhere.x-mousestate.x>=minsize.x then
          gx:=mousewhere.x-mousestate.x
         else
         gx:=minsize.x-size.x;
        fdraw:=true;
      end;
   end;
  if (event.what and evmouseldown<>0)and(state and sfgrowy<>0)and
     (event.global.y-origin.y>size.y-5) then
   begin
     growy:=true;
     mousestate:=event.global;
   end;
  if (event.what and evmouselup<>0)and growy and
     (state and sfgrowy<>0) then
   begin
     growy:=false;
     if abs(mousewhere.y-mousestate.y)>1 then
      begin
        if mousewhere.y-mousestate.y<0 then
         fclear:=true;
        if size.y+mousewhere.y-mousestate.y>=minsize.y then
          gy:=mousewhere.y-mousestate.y
         else
          gy:=minsize.y-size.y;
        fdraw:=true;
      end;
   end;
  if fclear then
   owner^.clear(@self);
  if (gx<>0)or(gy<>0) then
   growing(gx,gy);
  if fdraw then
   draw;
  if event.what and evcommand<>0 then
   case event.command of
    cmclose:begin
              event.infoptr:=shortcut;
              free;
              if shortcut<>nil then
                begin
                  dec(countwindow);
                  shortcut^.free;
                  if winshortcutsize<winshortcutwidth then
                   begin
                     winshortcutsize:=controlpanel^.shortcutgroup^.size.x div countwindow-3;
                     if winshortcutsize>winshortcutwidth then
                      winshortcutsize:=winshortcutwidth;
                     t:=controlpanel^.shortcutgroup^.first;
                     while t<>nil do
                      begin
                        t^.owner^.clear(t);
                        t:=t^.next;
                      end;
                     t:=controlpanel^.shortcutgroup^.first;
                     for i:=1 to countwindow do
                      begin
                        t^.origin.x:=(i-1)*(winshortcutsize+3);
                        t^.size.x:=winshortcutsize;
                        t^.draw;
                        t:=t^.next;
                      end;
                   end;
                end;
            end;
     cmdown:if shortcut<>nil then
             begin
               setcolor(framecolor);
               setlinestyle(3,0,3);
               setwritemode(1);
               shortcut^.getextend(wr);
               getextend(r);
               r.assign(r.a.x,r.a.y,r.b.x,r.a.y+wr.b.y-wr.a.y);
               for i:=1 to downcount do
                begin
                  rectangle(r.a.x+(wr.a.x-r.a.x)*i div downcount,
                            r.a.y+(wr.a.y-r.a.y)*i div downcount,
                            r.b.x+(wr.b.x-r.b.x)*i div downcount,
                            r.b.y+(wr.b.y-r.b.y)*i div downcount);
                  delay(downtemp);
                  rectangle(r.a.x+(wr.a.x-r.a.x)*i div downcount,
                            r.a.y+(wr.a.y-r.a.y)*i div downcount,
                            r.b.x+(wr.b.x-r.b.x)*i div downcount,
                            r.b.y+(wr.b.y-r.b.y)*i div downcount);
                end;
               setwritemode(0);
               setlinestyle(0,0,1);
               shortcut^.setstate(false,sfselected);
               shortcut^.down:=true;
               shortcut^.press:=false;
               if owner^.first=@self then
                shortcut^.owner^.select(nil);
               owner^.delete(@self);
             end;
     cmzoom:if state and sfzoom<>0 then
             begin
               event.what:=evnothing;
               zoom:=not zoom;
               getextend(wr);
               rr:=wr;
               if zoom then
                 begin
                   wr.grow(rscreen.b.x+6-size.x,rscreen.b.y+4-controlpanelheight-size.y);
                   wr.move(-origin.x-3,-origin.y-3);
                 end
                else
                 begin
                   r:=rzoom;
                   wr.grow(r.b.x-r.a.x-size.x,r.b.y-r.a.y-size.y);
                   wr.move(-origin.x+r.a.x,-origin.y+r.a.y);
                 end;
               r:=rr;
               setcolor(framecolor);
               setlinestyle(3,0,3);
               setwritemode(1);
               wr.assign(wr.a.x,wr.a.y,wr.b.x,wr.a.y+18);
               r.assign(r.a.x,r.a.y,r.b.x,r.a.y+18);
               for i:=1 to zoomcount do
                begin
                  rectangle(r.a.x+(wr.a.x-r.a.x)*i div zoomcount,
                            r.a.y+(wr.a.y-r.a.y)*i div zoomcount,
                            r.b.x+(wr.b.x-r.b.x)*i div zoomcount,
                            r.b.y+(wr.b.y-r.b.y)*i div zoomcount);
                  delay(zoomtemp);
                  rectangle(r.a.x+(wr.a.x-r.a.x)*i div zoomcount,
                            r.a.y+(wr.a.y-r.a.y)*i div zoomcount,
                            r.b.x+(wr.b.x-r.b.x)*i div zoomcount,
                            r.b.y+(wr.b.y-r.b.y)*i div zoomcount);
                end;
               setwritemode(0);
               setlinestyle(0,0,1);
               r:=rr;
               if not zoom then
                owner^.clear(@self);
               if zoom then
                 begin
                   growing(rscreen.b.x+6-size.x,rscreen.b.y+4-controlpanelheight-size.y);
                   moveing(-origin.x-3,-origin.y-3);
                   rzoom:=r;
                   setstate(false,sfmove+sfgrowx+sfgrowy);
                 end
                else
                 begin
                   r:=rzoom;
                   growing(r.b.x-r.a.x-size.x,r.b.y-r.a.y-size.y);
                   moveing(-origin.x+r.a.x,-origin.y+r.a.y);
                   setstate(true,sfmove+sfgrowx+sfgrowy);
                 end;
               draw;
             end;
   end;
end;
procedure twindow.setstate;
begin
  inherited setstate(enable,astate);
  if enable and(astate and sffocused<>0)and(shortcut<>nil) then
   controlpanel^.shortcutgroup^.select(shortcut);
end;

constructor tframe.init;
begin
  inherited init(r);
  growmode:=gfgrowhix+gfgrowhiy+gfgrowlox+gfgrowloy;
  fillstyle:={random(11)+1}1;
  fillcolor:={random(16)}15;
end;
procedure tframe.draw;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(fillstyle,fillcolor);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(8);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  setcolor(0);
  line(r.a.x+1,r.a.y+1,r.b.x-2,r.a.y+1);
  line(r.a.x+1,r.a.y+2,r.a.x+1,r.b.y-2);
  setcolor(15);
  line(r.a.x,r.b.y,r.b.x,r.b.y);
  line(r.b.x,r.a.y,r.b.x,r.b.y-1);
  setcolor(wingreycolor);
  line(r.a.x+1,r.b.y-1,r.b.x-1,r.b.y-1);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-2);
  iorun;
end;

constructor tcontrolpanel.init;
var
  r:trect;
begin
  r.assign(0,rscreen.b.y-controlpanelheight,rscreen.b.x,rscreen.b.y);
  inherited init(r);
  options:=options or oftopview;
  options:=options and not ofselectable;
  insert(new(pdialogbutton,init(2,3,cmtime,false,'γαª',bigfont)));
  r.assign(first^.size.x+5,3,rscreen.b.x-48,controlpanelheight-4);
  shortcutgroup:=new(pgroup,init(r));
  insert(shortcutgroup);
  clock:=new(pclock,init(rscreen.b.x-46));
  insert(clock);
end;
procedure tcontrolpanel.draw;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(1,wingreycolor);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  line(r.b.x,r.a.y,r.b.x,r.b.y);
  line(r.a.x,r.b.y,r.b.x-1,r.b.y);
  setcolor(8);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
  line(r.a.x+1,r.b.y-1,r.b.x-2,r.b.y-1);
  setcolor(15);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  iorun;
  inherited draw;
end;
procedure tcontrolpanel.clean;
begin
  setfillstyle(1,wingreycolor);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
end;

constructor twinshortcut.init;
var
  r:trect;
begin
  r.assign(xx,0,xx+len,controlpanelheight-7);
  press:=true;
  down:=false;
  name:=aname;
  settextstyle(smallfont.font,0,smallfont.charsize);
  if textwidth(name[1])<textwidth(name[ord(name[0])])then
    dx:=textwidth(name[1])+1
   else
    dx:=textwidth(name[ord(name[0])])+1;
  window:=awindow;
  inherited init(r);
end;
procedure twinshortcut.draw;
var
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(1,wingreycolor);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  if state and sfselected<>0 then
    begin
      setcolor(0);
      line(r.a.x,r.a.y,r.b.x-1,r.a.y);
      line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
      settextstyle(smallfont.font,0,smallfont.charsize);
      outtextxy(r.a.x+dx+1,r.a.y+4,getstrline(#178+name,size.x-dx-dx div 2));
      setcolor(15);
      line(r.a.x,r.b.y,r.b.x,r.b.y);
      line(r.b.x,r.a.y,r.b.x,r.b.y-1);
      setcolor(8);
      line(r.a.x+1,r.a.y+1,r.b.x-2,r.a.y+1);
      line(r.a.x+1,r.a.y+2,r.a.x+1,r.b.y-2);
    end
   else
    begin
      setcolor(0);
      line(r.b.x,r.a.y,r.b.x,r.b.y);
      line(r.a.x,r.b.y,r.b.x-1,r.b.y);
      settextstyle(smallfont.font,0,smallfont.charsize);
      outtextxy(r.a.x+dx,r.a.y+3,getstrline(#178+name,size.x-dx-dx div 2));
      setcolor(8);
      line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
      line(r.a.x+1,r.b.y-1,r.b.x-2,r.b.y-1);
      setcolor(15);
      line(r.a.x,r.a.y,r.b.x-1,r.a.y);
      line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
    end;
  iorun;
end;
procedure twinshortcut.handlevent;
var
  r,wr:trect;
  i:integer;
begin
  if (event.what and evmouseldown<>0)and not press then
   begin
     press:=true;
     draw;
   end;
  if event.what and evmouseldown<>0 then
   if down then
    begin
      setwritemode(1);
      getextend(r);
      window^.getextend(wr);
      wr.assign(wr.a.x,wr.a.y,wr.b.x,wr.a.y+r.b.y-r.a.y);
      setcolor(framecolor);
      setlinestyle(3,0,3);
      for i:=1 to downcount do
       begin
         rectangle(r.a.x+(wr.a.x-r.a.x)*i div downcount,
                   r.a.y+(wr.a.y-r.a.y)*i div downcount,
                   r.b.x+(wr.b.x-r.b.x)*i div downcount,
                   r.b.y+(wr.b.y-r.b.y)*i div downcount);
         delay(downtemp);
         rectangle(r.a.x+(wr.a.x-r.a.x)*i div downcount,
                   r.a.y+(wr.a.y-r.a.y)*i div downcount,
                   r.b.x+(wr.b.x-r.b.x)*i div downcount,
                   r.b.y+(wr.b.y-r.b.y)*i div downcount);
       end;
      setwritemode(0);
      setlinestyle(0,0,1);
      down:=false;
      sonetself^.insert(window);
      if state and sfselected=0 then
       owner^.select(@self);
      event.what:=evmousemove;
      sonetself^.handlevent(event);
    end
   else
    if window^.state and sffocused=0 then
      window^.owner^.select(window)
     else
      begin
        event.what:=evcommand;
        event.command:=cmdown;
        window^.handlevent(event);
      end;
  event.what:=evnothing;
end;
procedure twinshortcut.setstate;
begin
  inherited setstate(enable,astate);
  if enable and (astate and sfselected<>0) and not press then
   begin
     press:=true;
     if state and sflife<>0 then
      draw;
   end;
  if (astate and sfselected<>0) and press and not enable then
   begin
     press:=false;
     if state and sflife<>0 then
      draw;
   end;
end;
procedure twinshortcut.free;
var
  t:pview;
  ow:pgroup;
begin
  t:=next;
  while t<>nil do
   begin
     t^.owner^.clear(t);
     t^.moveing(-winshortcutsize-3,0);
     t^.draw;
     t:=t^.next;
   end;
  ow:=owner;
  inherited free;
  t:=ow^.first;
  while t<>nil do
   if pwinshortcut(t)^.down and (ow^.current=t) then
     begin
       controlpanel^.shortcutgroup^.select(nil);
       t:=nil;
     end
    else
     t:=t^.next;
end;

constructor tclock.init;
var
  r:trect;
begin
  settextstyle(smallfont.font,0,smallfont.charsize);
  r.assign(x,3,textwidth(' 00:00 ')+x+1,22);
  inherited init(r);
  growmode:=gfgrowlox+gfgrowhiy;
  newtask(new(ptask,init(@self,cmtime)));
  gettime(ch,cm);
  str(ch,hs);
  str(cm,ms);
  if ch<10 then
   hs:=' '+hs;
  if cm<10 then
   ms:='0'+ms;
end;
procedure tclock.gettime;
var
  t,k:longint;
begin
  t:=clock_val;
  t:=round(t/18.21);
  h:=t div 3600;
  k:=t mod 3600;
  m:=k div 60;
end;
procedure tclock.draw;
var
  h,m:longint;
  r:trect;
begin
  getextend(r);
  iostop(r);
  setfillstyle(1,wingreycolor);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(0);
  settextstyle(smallfont.font,0,smallfont.charsize);
  outtextxy(r.a.x+7,r.a.y+3,hs+':'+ms);
  setcolor(15);
  line(r.a.x,r.b.y,r.b.x,r.b.y);
  line(r.b.x,r.a.y,r.b.x,r.b.y-1);
  setcolor(8);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  iorun;
end;
procedure tclock.handlevent;
var
  h,m:longint;
begin
  if (event.what and evcommand<>0)and(event.command=cmtime) then
   begin
     gettime(h,m);
     if (h<>ch)or(m<>cm) then
      begin
        ch:=h;
        cm:=m;
        str(h,hs);
        str(m,ms);
        if h<10 then
         hs:=' '+hs;
        if m<10 then
         ms:='0'+ms;
        draw;
      end;
   end;
end;

end.