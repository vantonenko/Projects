unit sources;
{-------}
interface
{-------}
uses kernel,mouse,crt;

const
  {"twindow"}
  btclose=1;
  btzoom=2;
  btturn=4;
  btall=btclose+btzoom+btturn;
  wintitlefont:tfont=(font:2;charsize:5);
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
  string50=string[50];
  pmenuitem=^tmenuitem;
  pmenu=^tmenu;
  tmenuitem=object(tview)
    submenu,ownermenu:pmenu;
    open:boolean;
    command:word;
    constructor init(r:trect;asubmenu:pmenu;acommand:word);
    procedure draw;virtual;
    procedure drawlighton;virtual;
    procedure drawlightoff;virtual;
    procedure setstate(enable:boolean;astate:word);virtual;
    procedure handlevent(var event:tevent);virtual;
    destructor done;virtual;
  end;
  tmenu=object(tgroup)
    ownermenu:pmenu;
    submenu:pmenu;
    constructor init(x,y:integer);
    procedure correctpos(var r:trect);
    procedure setstate(enable:boolean;astate:word);virtual;
  end;

  pclosebutton=^tclosebutton;
  tclosebutton=object(tbutton)
    constructor init(x,y,s:integer);
    procedure drawpress;virtual;
    procedure drawrelease;virtual;
  end;
  {pzoombutton=^tzoombutton;
  tzoombutton=object(tbutton)
    procedure drawpress;virtual;
    procedure drawrelease;virtual;
  end;
  pturnbutton=^tturnbutton;
  tturnbutton=object(tbutton)
    procedure drawpress;virtual;
    procedure drawrelease;virtual;
  end;}
  tmovframe=record
    ddx,ddy,x0,y0:integer;
  end;
  pwindow=^twindow;
  twindow=object(tgroup)
    title:string50;
    titlefont:tfont;
    titleheight,buttsize:integer;
    movflag:boolean;
    movframe:tmovframe;
    buttons:byte;
    constructor init(atitle:string50;afont:tfont;r:trect;abuttons:byte);
    procedure handlevent(var event:tevent);virtual;
    procedure setstate(enable:boolean;astate:word);virtual;
    procedure draw;virtual;
    destructor done;virtual;
  end;

  {ptitlewin=^ttitlewin;
  ttitlewin=object(tgroup)
    constructor init(atitle:ttitle;font:tfont;buttons:byte);
    procedure handlevent}

  pshortcutman=^tshortcutman;
  tshortcutman=object(tgroup)
  end;

  pfolderman=^tfolderman;
  tfolderman=object(tshortcutman)
    procedure draw;virtual;
  end;
{------------}
implementation
{------------}
uses graph;
const
  textkoeffy=1+1/3;
constructor tbutton.init;
begin
  inherited init(r);
  command:=acommand;
  mode:=amode;
  press:=false;
  options:=oftopselect or options;
  eventmask:=eventmask-evmousemove;
end;

procedure tbutton.handlevent;
var
  oldpress:boolean;
begin
  oldpress:=press;
  if (state and sflight<>0)and
     (state and sfauto<>0)and not press then
   press:=true;
  if ((state and sflight=0)and press)or(event.what and evmouselup<>0) then
   press:=false;
  if press<>oldpress then
   draw;
  if (event.what and evmouseldown<>0)and mode then
   putcommand(event);
  if (event.what and evmouselup<>0)and(stateview and sfauto<>0)and
     (state and sflight<>0)and not mode then
   putcommand(event);
  if not event.putflag then
   clearevent(event);
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
  fillevent(event);
  event.what:=evcommand;
  event.command:=command;
  putevent(event);
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
  hidemouse;
  setfillstyle(1,c_base);
  getextend(r);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(c_basetext);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  settextstyle(font.font,0,font.charsize);
  outtextxy(r.a.x+dx+1,r.a.y+1,name);
  setcolor(c_white);
  line(r.a.x,r.b.y,r.b.x,r.b.y);
  line(r.b.x,r.a.y,r.b.x,r.b.y-1);
  setcolor(c_shadow);
  line(r.a.x+1,r.a.y+1,r.b.x-2,r.a.y+1);
  line(r.a.x+1,r.a.y+2,r.a.x+1,r.b.y-2);
  showmouse;
end;
procedure tdialogbutton.drawrelease;
var
  r:trect;
begin
  hidemouse;
  setfillstyle(1,c_base);
  getextend(r);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(c_basetext);
  line(r.b.x,r.a.y,r.b.x,r.b.y);
  line(r.a.x,r.b.y,r.b.x-1,r.b.y);
  settextstyle(font.font,0,font.charsize);
  outtextxy(r.a.x+dx,r.a.y,name);
  setcolor(c_shadow);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
  line(r.a.x+1,r.b.y-1,r.b.x-2,r.b.y-1);
  setcolor(c_white);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  showmouse;
end;

destructor tdialogbutton.done;
begin
  inherited done;
end;

constructor tmenuitem.init;
begin
  inherited init(r);
  submenu:=asubmenu;
  command:=acommand;
end;

procedure tmenuitem.draw;
begin
end;

procedure tmenuitem.handlevent;
begin
  if (event.what and(evmouselup+evmouseldown)<>0)or
     ((event.what and evcommand<>0)and(event.command=cmtime)
      and(state and sflight<>0))then
   if submenu<>nil then
     begin
       open:=true;
       submenu^.ownermenu:=pmenu(owner);
       ownermenu^.submenu:=submenu;
       submenu^.init(global.x+size.x+2,global.y);
       owner^.owner^.insert(submenu);
       clearevent(event);
     end
    else
     begin
       event.what:=evcommand;
       event.command:=command;
       putevent(event);
     end;
end;

procedure tmenuitem.drawlighton;
begin
end;

procedure tmenuitem.drawlightoff;
begin
end;

destructor tmenuitem.done;
begin
  if submenu<>nil then
   dispose(submenu);
end;

procedure tmenuitem.setstate;
begin
  inherited setstate(enable,astate);
  if state and sflight<>0 then
   if enable then
     begin
       drawlighton;
       if not open then
        kernel.self^.newtask(new(ptimertask,init(@self,cmtime,menuopeninterval,true)),0);
     end
    else
     begin
       if submenu<>nil then
        submenu^.owner^.delete(submenu);
       drawlightoff;
     end;
end;

constructor tmenu.init;
begin
  owner:=nil;
end;

procedure tmenu.correctpos;
var
  t:integer;
begin
  if r.b.x>getmaxx then
   begin
     t:=r.b.x-r.a.x;
     r.b.x:=r.a.x;
     r.a.x:=r.b.x-t;
   end;
  if r.b.y>getmaxy then
   begin
     t:=r.b.y-getmaxy;
     r.a.y:=r.a.y-t;
     r.b.y:=getmaxy;
   end;
end;

procedure tmenu.setstate;
begin
  {if (astate and sflight<>0)and enable then}
  inherited setstate(enable,astate);
  if (astate and sffocused<>0)and(submenu=nil)and not enable then
   begin
     owner^.delete(@self);
     dispose(pmenu(@self),done);
   end;
end;

constructor tclosebutton.init;
var
  r:trect;
begin
  r.a.x:=x;
  r.a.y:=y;
  r.b.x:=x+s-1;
  r.b.y:=y+s-1;
  inherited init(r,cmclose,false);
end;

procedure tclosebutton.drawpress;
var
  r:trect;
begin
  hidemouse;
  setfillstyle(1,c_base);
  getextend(r);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(c_basetext);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  line(r.a.x+5,r.a.y+5,r.b.x-3,r.b.y-3);
  line(r.a.x+5,r.b.y-3,r.b.x-3,r.a.y+5);
  setcolor(c_white);
  line(r.a.x,r.b.y,r.b.x,r.b.y);
  line(r.b.x,r.a.y,r.b.x,r.b.y-1);
  setcolor(c_shadow);
  line(r.a.x+1,r.a.y+1,r.b.x-2,r.a.y+1);
  line(r.a.x+1,r.a.y+2,r.a.x+1,r.b.y-2);
  showmouse;
end;

procedure tclosebutton.drawrelease;
var
  r:trect;
begin
  hidemouse;
  setfillstyle(1,c_base);
  getextend(r);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(c_basetext);
  line(r.b.x,r.a.y,r.b.x,r.b.y);
  line(r.a.x,r.b.y,r.b.x-1,r.b.y);
  line(r.a.x+4,r.a.y+4,r.b.x-4,r.b.y-4);
  line(r.a.x+4,r.b.y-4,r.b.x-4,r.a.y+4);
  setcolor(c_shadow);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
  line(r.a.x+1,r.b.y-1,r.b.x-2,r.b.y-1);
  setcolor(c_white);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  showmouse;
end;

constructor twindow.init;
begin
  title:=atitle;
  buttons:=abuttons;
  titlefont:=afont;
  settextstyle(titlefont.font,0,titlefont.charsize);
  titleheight:=textheight(title)+7;
  inherited init(r);
  plat:=@self;
  options:=options or oftopselect;
  movflag:=false;
  eventmask:=eventmask and not evmousemove;
  buttsize:=titleheight-4;
  if buttons and btclose<>0 then
   insert(new(pclosebutton,init(r.b.x-buttsize-5,r.a.y+7,buttsize)));
end;

procedure twindow.draw;
var
  r:trect;
begin
  getextend(r);
  hidemouse;
  setfillstyle(1,c_base);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  if stateview and sffocused<>0 then
    setfillstyle(1,c_frameactive)
   else
    setfillstyle(1,c_framepassive);
  bar(r.a.x+4,r.a.y+4,r.b.x-4,r.a.y+titleheight+4);
  setcolor(c_basetext);
  line(r.b.x,r.a.y,r.b.x,r.b.y);
  line(r.a.x,r.b.y,r.b.x-1,r.b.y);
  setcolor(c_shadow);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
  line(r.b.x-2,r.b.y-1,r.a.x+1,r.b.y-1);
  setcolor(c_white);
  line(r.a.x+1,r.a.y+1,r.b.x-2,r.a.y+1);
  line(r.a.x+1,r.a.y+2,r.a.x+1,r.b.y-2);
  settextstyle(titlefont.font,0,titlefont.charsize);
  if stateview and sffocused=0 then
   setcolor(c_base);
  outtextxy(r.a.x+8,r.a.y+6,title);
  showmouse;
  inherited draw;
end;

procedure twindow.handlevent;
begin
  inherited handlevent(event);
  if (event.what and evmouseldown<>0)and
     (event.global.y-global.y<=titleheight+4) then
   begin
     movflag:=true;
     movframe.ddx:=event.global.x-global.x;
     movframe.ddy:=event.global.y-global.y;
     movframe.x0:=event.global.x;
     movframe.y0:=event.global.y;
   end;
  if (event.what and evmouselup<>0)and movflag and
     ((abs(movframe.x0-event.global.x)>3)or(abs(movframe.y0-event.global.y)>3)) then
   begin
     owner^.clear(@self);
     move(event.global.x-movframe.x0,event.global.y-movframe.y0);
     draw;
     movflag:=false;
   end;
  if (event.what and evcommand<>0)and(event.command=cmclose) then
   done;
end;

procedure twindow.setstate;
begin
  inherited setstate(enable,astate);
  if (astate and sffocused<>0)and(state and sfdraw<>0) then
   draw;
end;

destructor twindow.done;
begin
  inherited done;
  owner^.delete(@self);
end;

procedure tfolderman.draw;
var
  r:trect;
begin
  hidemouse;
  getextend(r);
  setfillstyle(1,c_white);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  setcolor(c_shadow);
  line(r.a.x,r.a.y,r.b.x-1,r.a.y);
  line(r.a.x,r.a.y+1,r.a.x,r.b.y-1);
  setcolor(c_basetext);
  line(r.a.x+1,r.a.y+1,r.a.x+1,r.b.y-2);
  line(r.a.x+2,r.a.y+1,r.b.x-2,r.a.y+1);
  setcolor(c_base);
  line(r.b.x-1,r.a.y+1,r.b.x-1,r.b.y-1);
  line(r.b.x-2,r.b.y-1,r.a.x+1,r.b.y-1);
  setcolor(c_white);
  line(r.a.x,r.b.y,r.b.x,r.b.y);
  line(r.b.x,r.a.y,r.b.x,r.b.y-1);
  showmouse;
end;

end.