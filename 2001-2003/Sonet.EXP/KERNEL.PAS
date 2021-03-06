unit kernel;

interface

uses crt;
const
  {"commands"}
  cmnothing=0;
  cmshutdown=1;
  cmclose=2;
  cmzoom=3;
  cmdown=4;
  cmrefresh=5;
  cmtime=6;
  cmok=7;
  cmcencel=8;
  cmhalt=9;
  {"events"}
  evnothing=0;
  evmouse=$7f;
  evkeyboard=$80;
  evmessage=$300;
  {"evmouse"}
  evmouseldown=$1;
  evmouselup=$2;
  evmouserdown=$4;
  evmouserup=$8;
  evmousemove=$10;
  evmouseauto=$20;
  evmousepromt=$40;
  {"evkeyboard"}
  evkeydown=$80;
  {"evmessage"}
  evcommand=$100;
  evbroadcast=$200;
  {"serve"}
  svrshift=$1;
  svlshift=$2;
  svctrl=$4;
  svalt=$8;
  svscrolllock=$10;
  svnumlock=$20;
  svcapslock=$40;
  svinsert=$80;
  {"state"}
  sflife=$1;{��ꥪ� ��ᮥ����� � ���}
  sfauto=$2;{}
  sffocused=$4;
  sfselected=$8;
  sfmove=$10;
  sfgrowx=$20;
  sfgrowy=$40;
  sfzoom=$80;
  {"options"}
  oftopselect=$1;
  offullvisible=$2;{��ꥪ� �� ������ �᫨ �� ���筮 ��४��� ��. ��������}
  oftopview=$4;
  ofrefresh=$8;
  ofselectable=$10;
  ofcenterx=$20;
  ofcentery=$40;
  ofcleared=$80;
  {"growmode"}
  gfgrowhix=$1;
  gfgrowhiy=$2;
  gfgrowlox=$4;
  gfgrowloy=$8;
  {"appflags"}

type
  tpoint=object
    x,y:integer;
  end;
  trect=object
    a,b:tpoint;
    procedure assign(ax,ay,bx,by:integer);
    procedure copy(r:trect);
    procedure move(dx,dy:integer);
    procedure grow(dx,dy:integer);
    procedure inter(r:trect);
    procedure union(r:trect);
    function contains(p:tpoint):boolean;
    function equals(r:trect):boolean;
    function empty:boolean;
  end;

  tevent=record
    what:word;
    case word of
      evnothing:();
      evmouse:(
        where,global:tpoint;
        dx,dy:integer;
        double:boolean;
        buttons:byte;
        ctrl,shift,lshift,rshift:boolean);
      evkeyboard:(
        serve:byte;
        case integer of
          0:(keycode:word);
          1:(charcode:char;
             scancode:byte));
      evmessage:(
        command:word;
        case integer of
          0:(infoptr:pointer);
          1:(infolong:longint);
          2:(infoword:word));
  end;

  peventlist=^teventlist;
  teventlist=record
    event:tevent;
    next:peventlist;
  end;
  pscreenlist=^tscreenlist;
  tscreenlist=record
    r:trect;
    next:pscreenlist;
  end;
  tfont=record
    font,charsize:integer;
  end;
  pview=^tview;
  pgroup=^tgroup;

  tview=object
    origin:tpoint;{���न���� ��-� ��-�� ��������}
    size:tpoint;{ࠧ����}
    first:pview;{1-� �����-�}
    next:pview;{᫥���騩 ��-�}
    owner:pgroup;{��������}
    state:word;
    options:word;
    growmode:byte;
    hideflag:boolean;
    refresh:boolean;
    screenlist:pscreenlist;{ᯨ᮪ ��४�뢠��� ��אַ㣮�쭨��� r-local}
    {eventmask:word;}
    constructor init(r:trect);{!!!! r-local !!!!}
    procedure draw;virtual;
    procedure handlevent(var event:tevent);virtual;
    procedure setstate(enable:boolean;astate:word);virtual;
    procedure growing(dx,dy:integer);virtual;
    procedure setscreens;virtual;
    procedure moveing(dx,dy:integer);
    function intersect(view:pview):boolean;{true-"intersect"}
    destructor done;virtual;
    procedure free;virtual;
    procedure getextend(var r:trect);
    procedure iostop(r:trect);
    procedure iorun;
    procedure putpixel(x,y:integer;color:word);
    function visible(x,y:integer;var gx,gy:integer):boolean;
    procedure linex(x1,x2,y,color:integer);
    procedure liney(x,y1,y2,color:integer);
    procedure drawrect(x1,y1,x2,y2,color:integer);
  end;

  tgroup=object(tview)
    auto:pview;
    current:pview;
    constructor init(r:trect);{!!!! r-local !!!!}
    procedure draw;virtual;
    procedure handlevent(var event:tevent);virtual;
    procedure growing(dx,dy:integer);virtual;
    procedure insert(view:pview);
    procedure delete(view:pview);
    procedure setstate(enable:boolean;astate:word);virtual;
    destructor done;virtual;
    procedure clear(view:pview);
    procedure clean(r:trect);virtual;
    procedure select(view:pview);
    procedure interrefresh(t:pview);
  end;

  plist=^tlist;
  tlist=record
    view:pview;
    next:plist;
  end;

  tviewsteck=object
    list:plist;
    constructor init;
    procedure push(view:pview);
    procedure pop(var view:pview);
    destructor done;
  end;

  ptask=^ttask;
  ttask=object
    command:word;{�������}
    owner:pview;{��������}
    next:ptask;{᫥����� ����� � ᯨ᪥}
    event:tevent;
    block:boolean;
    kill:boolean;
    constructor init(aowner:pview;acommand:word);
    procedure run;virtual;
    destructor done;virtual;
    procedure passcommand;
  end;

  pkeybtask=^tkeybtask;
  tkeybtask=object(ttask)
    procedure run;virtual;
  end;

  peventtask=^teventtask;
  teventtask=object(ttask)
    constructor init(aowner:pview;acommand:word);
    procedure run;virtual;
  end;

  ptimertask=^ttimertask;
  ttimertask=object(ttask)
    time:longint;
    period:word;
    once:boolean;
    constructor init(view:pview;acommand:word;per:word;en:boolean);
    procedure run;virtual;
  end;

  trgb=record
    r,g,b:integer;
  end;
  tpalette=array[0..15]of trgb;

procedure newtask(task:ptask);

const
  enablevents:integer=0;
  mousevisible:integer=0;
  mousecheck:boolean=false;
  mousewhere:tpoint=(x:320;y:240);
  oldmousewhere:tpoint=(x:320;y:240);
  mousecursorposition:tpoint=(x:320;y:240);
  oldmousecursorposition:tpoint=(x:320;y:240);
  egacolors:array[0..15]of byte=
      (0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
  {disableview:pview=nil;}
  sizemouse:tpoint=(x:32;y:32);
  rscreen:trect=(a:(x:0;y:0);b:(x:0;y:0));
  windowtitlefont:tfont=(font:2;charsize:4);
  blocktask:boolean=true;
  countwindow:word=0;
  sonetself:pgroup=nil;
  pointlist:byte=0;
type
  teventqueque=record
    firstevent,lastevent:peventlist;
  end;
const
  eventqueque:array[0..1] of teventqueque=((firstevent:nil;lastevent:nil),
                                           (firstevent:nil;lastevent:nil));

var
  syspalette:tpalette;
  clock_val:longint absolute $0040:$006c;
  serve_val:byte absolute $0040:$0017;
  tasklist:array[0..1]of ptask;
  task_point:byte;

procedure addevent(event:tevent);
procedure getevent(var event:tevent);

const
  scrtime:longint=0;

implementation

uses mouse,graph;

procedure trect.assign;
begin
  a.x:=ax;
  a.y:=ay;
  b.x:=bx;
  b.y:=by;
end;
procedure trect.copy;
begin
  a:=r.a;
  b:=r.b;
end;
procedure trect.move;
begin
  a.x:=a.x+dx;
  a.y:=a.y+dy;
  b.x:=b.x+dx;
  b.y:=b.y+dy;
end;
procedure trect.grow;
begin
  b.x:=b.x+dx;
  b.y:=b.y+dy;
end;
procedure trect.inter;
begin
  if r.a.x>a.x then
   a.x:=r.a.x;
  if r.b.x<b.x then
   b.x:=r.b.x;
  if r.a.y>a.y then
   a.y:=r.a.y;
  if r.b.y<b.y then
   b.y:=r.b.y;
end;
procedure trect.union;
begin
  if r.a.x<a.x then
   a.x:=r.a.x;
  if r.b.x>b.x then
   b.x:=r.b.x;
  if r.a.y<a.y then
   a.y:=r.a.y;
  if r.b.y>b.y then
   b.y:=r.b.y;
end;
function trect.contains;
begin
  contains:=(p.x>=a.x)and
            (p.x<=b.x)and
            (p.y>=a.y)and
            (p.y<=b.y);
end;
function trect.equals;
begin
  equals:=(a.x=r.a.x)and
          (b.x=r.b.x)and
          (a.y=r.a.y)and
          (b.y=r.b.y);
end;
function trect.empty;
begin
  empty:=(b.x>=a.x)and
         (b.y>=a.y);
end;

constructor tviewsteck.init;
begin
  list:=nil;
end;
procedure tviewsteck.push;
var
  t:plist;
begin
  new(t);
  t^.view:=view;
  t^.next:=list;
  list:=t;
end;
procedure tviewsteck.pop;
var
  t:plist;
begin
  view:=nil;
  if list=nil then
    exit
   else
    view:=list^.view;
  t:=list;
  list:=list^.next;
  dispose(t);
end;
destructor tviewsteck.done;
var
  t:plist;
begin
  while list<>nil do
   begin
     t:=list;
     list:=list^.next;
     dispose(t);
   end;
end;

constructor tview.init;
begin
  refresh:=false;
  origin.x:=r.a.x;
  origin.y:=r.a.y;
  size.x:=r.b.x-r.a.x;
  size.y:=r.b.y-r.a.y;
  first:=nil;
  next:=nil;
  owner:=nil;
  state:=0;
  options:=offullvisible+ofselectable+ofcleared;
  growmode:=gfgrowhix+gfgrowhiy;
  hideflag:=false;
  screenlist:=nil;
end;
procedure tview.draw;
begin
end;
procedure tview.handlevent;
begin
end;
procedure tview.growing;
begin
  size.x:=size.x+dx;
  size.y:=size.y+dy;
end;
procedure tview.moveing;
begin
  origin.x:=origin.x+dx;
  origin.y:=origin.y+dy;
end;
procedure tview.setscreens;
var
  tl:pscreenlist;
  tv:pview;
  rview,rscr:trect;
begin
  rview.a:=origin;
  rview.b.x:=origin.x+size.x;
  rview.b.y:=origin.y+size.y;
  if (owner<>nil)and(owner^.screenlist<>nil) then
   begin
     tl:=owner^.screenlist;
     while tl<>nil do
      begin
        rscr:=tl^.r;
        rscr.inter(rview);
        if rscr.empty then
         {addscreen(rscr);}
      end;
   end;
  tv:=next;
end;
function tview.intersect;
var
  r1,r2:trect;
begin
  r1.a:=origin;
  r1.b.x:=origin.x+size.x;
  r1.b.y:=origin.y+size.y;
  r2.a:=view^.origin;
  r2.b.x:=view^.origin.x+view^.size.x;
  r2.b.y:=view^.origin.y+view^.size.y;
  r1.inter(r2);
  intersect:=r1.empty;
end;
procedure tview.setstate;
begin
  if enable then
    state:=state or astate
   else
    state:=state and not astate;
end;
destructor tview.done;
begin
end;
procedure tview.free;
var
  t:pview;
begin
  if owner<>nil then
   owner^.delete(@self);
  t:=@self;
  dispose(t,done);
end;
procedure tview.getextend;
var
  rr:trect;
begin
  if owner<>nil then
    begin
      owner^.getextend(rr);
      r.a.x:=rr.a.x+origin.x;
      r.a.y:=rr.a.y+origin.y;
    end
   else
    begin
      r.a.x:=origin.x;
      r.a.y:=origin.y;
    end;
  r.b.x:=r.a.x+size.x;
  r.b.y:=r.a.y+size.y;
end;
procedure tview.iostop;
begin
  {if enablevents=0 then
   asm
     cli
   end;}
  inc(enablevents);
  hideflag:=((mousecursorposition.x>=r.a.x-sizemouse.x)and(mousecursorposition.y>=r.a.y-sizemouse.y)and
            (mousecursorposition.x<=r.b.x+2)and(mousecursorposition.y<=r.b.y+2))or
            ((oldmousecursorposition.x>=r.a.x-sizemouse.x)and(oldmousecursorposition.y>=r.a.y-sizemouse.y)and
            (oldmousecursorposition.x<=r.b.x+2)and(oldmousecursorposition.y<=r.b.y+2));
  if hideflag then
   begin
     if mousevisible=0 then
      hidemouse;
     inc(mousevisible);
   end;
end;
procedure tview.iorun;
begin
  if enablevents=0 then
   exit;
  if hideflag then
   begin
     dec(mousevisible);
     if mousevisible=0 then
      showmouse;
     hideflag:=false;
   end;
  dec(enablevents);
  {if enablevents=0 then
   asm
     sti
   end;}
end;
procedure tview.putpixel;
var
  t:pview;
  xx,yy:integer;
begin
  t:=next;
  xx:=x+origin.x;
  yy:=y+origin.y;
  while (t<>nil)and not((xx>=t^.origin.x)and(yy>=t^.origin.y)
          and(xx<=t^.origin.x+t^.size.x)and(yy<=t^.origin.y+t^.size.y)) do
   t:=t^.next;
  if t=nil then
   if owner<>nil then
     owner^.putpixel(origin.x+x,origin.y+y,color)
    else
     if state and sflife<>0 then
      {begin
        asm
          cli
        end;}
        graph.putpixel(x,y,color);
        {asm
          sti
        end;
      end;}
end;
function tview.visible;
var
  t:pview;
  xx,yy:integer;
begin
  t:=next;
  xx:=x+origin.x;
  yy:=y+origin.y;
  while (t<>nil)and not((xx>=t^.origin.x)and(yy>=t^.origin.y)
          and(xx<=t^.origin.x+t^.size.x)and(yy<=t^.origin.y+t^.size.y)) do
   t:=t^.next;
  if t=nil then
   if owner<>nil then
     visible:=owner^.visible(origin.x+x,origin.y+y,gx,gy)
    else
     visible:=state and sflife<>0;
end;
procedure tview.linex;
var
  i:integer;
begin
  if x1>x2 then
   begin
     x1:=x1+x2;
     x2:=x1-x2;
     x1:=x1-x2;
   end;
  for i:=x1 to x2 do
   putpixel(i,y,color);
  {i:=x1;
  setcolor(color);
  while i<x2 do
   begin
     while (i<x2)and visible(i,y) do
      inc(i);
     line(x1,y,i,y);
     while (i<x2)and not visible(i,y) do
      inc(i);
     x1:=i;
   end;}
end;
procedure tview.liney;
var
  i:integer;
begin
  if y1>y2 then
   begin
     y1:=y1+y2;
     y2:=y1-y2;
     y1:=y1-y2;
   end;
  for i:=y1 to y2 do
   putpixel(x,i,color);
end;
procedure tview.drawrect;
begin
  linex(x1,x2,y1,color);
  linex(x1,x2,y2,color);
  liney(x1,y1,y2,color);
  liney(x2,y1,y2,color);
end;

destructor tgroup.done;
var
  t,tt:pview;
begin
  t:=first;
  while t<>nil do
   begin
     tt:=t^.next;
     dispose(t,done);
     t:=tt;
   end;
end;
procedure tgroup.setstate;
var
  t:pview;
begin
  inherited setstate(enable,astate);
  if astate and sflife<>0 then
   begin
     t:=first;
     while t<>nil do
      begin
        t^.setstate(enable,astate);
        t:=t^.next;
      end;
   end;
  if (astate and sfauto<>0)and(auto<>nil)and not enable then
   begin
     auto^.setstate(false,sfauto);
     auto:=nil;
   end;
  if (astate and sffocused<>0)and(current<>nil) then
   current^.setstate(enable,sffocused);
  if (options and ofrefresh<>0)and(astate and sffocused<>0)and
     (state and sflife<>0) then
   draw;
end;

constructor tgroup.init;
begin
  inherited init(r);
  auto:=nil;
  current:=nil;
end;
procedure tgroup.draw;
var
  t:pview;
begin
  t:=first;
  while t<>nil do
   begin
     if not((t^.options and offullvisible<>0)and((t^.origin.x+t^.size.x>size.x)or
            (t^.origin.y+t^.size.y>size.y)or(t^.origin.x<0)or(t^.origin.y<0))) then
      t^.draw;
     t:=t^.next;
   end;
  t:=next;
  while (t<>nil)and not((t^.options and oftopview<>0)and intersect(t)) do
   t:=t^.next;
  if (t<>nil)and(t^.options and oftopview<>0)and
      intersect(t) and(t^.state and sflife<>0) then
   t^.draw;
end;
procedure tgroup.handlevent;
var
  st:tviewsteck;
  t,view:pview;
  f:boolean;
  wh:tpoint;
  ev:tevent;
begin
  if event.what and evmouse<>0 then
   if auto<>nil then
     begin
       wh:=event.where;
       event.where.x:=event.where.x-auto^.origin.x;
       event.where.y:=event.where.y-auto^.origin.y;
       f:=event.what and evmouseauto=0;
        auto^.handlevent(event);
       if f and(auto<>nil) then
        begin
          auto^.setstate(false,sfauto);
          auto:=nil;
        end;
       if event.what and evmouse<>0 then
        event.where:=wh;
     end
    else
     if not((state and sfauto<>0)and(event.what and evmouseldown=0)) then
      begin
        st.init;
        t:=first;
        while t<>nil do
         begin
           st.push(t);
           t:=t^.next;
         end;
        st.pop(t);
        view:=nil;
        while (t<>nil)and(view=nil) do
         begin
           if (not((t^.options and offullvisible<>0)and((t^.origin.x+t^.size.x>size.x)or
              (t^.origin.y+t^.size.y>size.y)or(t^.origin.x<0)or(t^.origin.y<0))))and
              (event.where.x>=t^.origin.x)and
              (event.where.y>=t^.origin.y)and
              (event.where.x<=t^.origin.x+t^.size.x)and
              (event.where.y<=t^.origin.y+t^.size.y) then
           view:=t;
           st.pop(t);
         end;
        st.done;
        if view<>nil then
         begin
           if event.what and evmouseldown<>0 then
            begin
              if auto<>nil then
               auto^.setstate(false,sfauto);
              auto:=view;
              auto^.setstate(true,sfauto);
              if (current<>view)and(view^.options and ofselectable<>0) then
               select(view);
            end;
           wh:=event.where;
           event.where.x:=event.where.x-view^.origin.x;
           event.where.y:=event.where.y-view^.origin.y;
           view^.handlevent(event);
           if event.what and evmouse<>0 then
            event.where:=wh;
         end;
      end;
  if event.what and evbroadcast<>0 then
   begin
     t:=first;
     ev:=event;
     while t<>nil do
      begin
        view:=t^.next;
        t^.handlevent(event);
        event:=ev;
        t:=view;
      end;
   end;
end;
procedure tgroup.insert;
var
  t,tt:pview;
  r:trect;
begin
  if view=nil then
   exit;
  getextend(r);
  if state and sflife<>0 then
   iostop(r);
  view^.owner:=@self;
  if view^.options and ofcenterx<>0 then
   view^.origin.x:=size.x div 2-view^.size.x div 2;
  if view^.options and ofcentery<>0 then
   view^.origin.y:=size.y div 2-view^.size.y div 2;
  if first=nil then
    first:=view
   else
    if (first^.options and oftopview<>0)and
       (view^.options and oftopview=0) then
      begin
        t:=first;
        first:=view;
        first^.next:=t;
      end
     else
      begin
        t:=first;
        if view^.options and oftopview<>0 then
          while t^.next<>nil do
           t:=t^.next
         else
          while (t^.next<>nil)and(t^.next^.options and oftopview=0) do
           t:=t^.next;
        if t^.next=nil then
          t^.next:=view
         else
          begin
            tt:=t^.next;
            t^.next:=view;
            view^.next:=tt;
          end;
      end;
  if view^.options and ofselectable<>0 then
  if current<>nil then
    begin
      current^.setstate(false,sfselected);
      if current^.state and sffocused<>0 then
       begin
         current^.setstate(false,sffocused);
         view^.setstate(true,sffocused);
       end;
      view^.setstate(true,sfselected);
      current:=view;
    end
   else
    begin
      current:=view;
      if view^.owner^.state and sffocused<>0 then
       view^.setstate(true,sffocused);
      view^.setstate(true,sfselected);
    end;
  if state and sflife<>0 then
   view^.setstate(true,sflife);
  if state and sflife<>0 then
   view^.draw;
  if state and sflife<>0 then
   iorun;
end;
procedure tgroup.delete;
var
  t,tt:pview;
  r:trect;
begin
  if (view=nil)or(first=nil) then
   exit;
  view^.getextend(r);
  if state and sflife<>0 then
   iostop(r);
  if auto=view then
   begin
     auto^.setstate(false,sfauto);
     auto:=nil;
   end;
  if first=view then
   t:=nil;
  if first=view then
    first:=view^.next
   else
    begin
      t:=first;
      while (t^.next<>view)and(t^.next<>nil) do
       t:=t^.next;
      if t^.next<>nil then
       t^.next:=t^.next^.next;
    end;
  if view^.options and ofcleared<>0 then
   clear(view);
  view^.next:=nil;
  view^.owner:=nil;
  if state and sflife<>0 then
   view^.setstate(false,sflife);
  if current=view then
   begin
     tt:=view;
     t:=first;
     view:=nil;
     while t<>nil do
      begin
        if t^.options and ofselectable<>0 then
         view:=t;
        t:=t^.next;
      end;
     current:=view;
     if (view<>nil)and(view^.owner^.state and sffocused<>0) then
       view^.setstate(true,sffocused);
     if view<>nil then
      view^.setstate(true,sfselected);
     view:=tt;
   end;
  if state and sflife<>0 then
   iorun;
end;
procedure tgroup.growing;
var
  t:pview;
  gx,gy,mx,my:integer;
begin
  tview.growing(dx,dy);
  t:=first;
  while t<>nil do
   begin
     mx:=0;
     my:=0;
     gx:=0;
     gy:=0;
     if (t^.growmode and gfgrowhix<>0)and
        (t^.growmode and gfgrowlox<>0) then
      gx:=dx;
     if (t^.growmode and gfgrowhiy<>0)and
        (t^.growmode and gfgrowloy<>0) then
      gy:=dy;
     if (t^.growmode and gfgrowhix=0)and
        (t^.growmode and gfgrowlox<>0) then
      mx:=dx;
     if (t^.growmode and gfgrowhiy=0)and
        (t^.growmode and gfgrowloy<>0) then
      my:=dy;
     if (mx<>0)or(my<>0) then
      t^.moveing(mx,my);
     if (gx<>0)or(gy<>0) then
      t^.growing(gx,gy);
     t:=t^.next;
   end;
end;
procedure tgroup.interrefresh;
var
  tt:pview;
begin
  tt:=t^.next;
  while tt<>nil do
   begin
     if tt^.intersect(t) and not tt^.refresh then
      begin
        tt^.refresh:=true;
        interrefresh(tt);
      end;
     tt:=tt^.next;
   end;
end;
procedure tgroup.clear;
var
  r:trect;
  t,tt:pview;
begin
  if view<>nil then
   begin
     view^.getextend(r);
     view^.iostop(r);
     clean(r);
     view^.iorun;
     t:=first;
     view^.refresh:=true;
     while t<>nil do
      begin
        if (t<>view)and view^.intersect(t) then
         begin
           t^.refresh:=true;
           interrefresh(t);
         end;
        t:=t^.next;
      end;
     t:=first;
     while t<>nil do
      begin
        if (t<>view)and t^.refresh then
         begin
           t^.refresh:=false;
           t^.draw;
         end;
        t:=t^.next;
      end;
     view^.refresh:=false;
   end;
end;
procedure tgroup.clean;
begin
  if owner<>nil then
   owner^.clean(r);
end;
procedure tgroup.select;
var
  t,tt:pview;
  r:trect;
begin
  if current=view then
   exit;
  if view=nil then
   begin
     if current<>nil then
      current^.setstate(false,sfselected+sffocused);
     current:=nil;
     exit;
   end;
  view^.getextend(r);
  iostop(r);
  if (view^.options and oftopselect<>0)and
     (view^.next<>nil)and(view^.next^.options and oftopview=0) then
   begin
     t:=first;
     if first<>view then
       begin
          while t^.next<>view do
           t:=t^.next;
          t^.next:=view^.next;
       end
      else
       first:=first^.next;
     t:=view;
     while (t^.next<>nil)and(t^.next^.options and oftopview=0) do
      t:=t^.next;
     if t^.next=nil then
       begin
         t^.next:=view;
         view^.next:=nil;
       end
      else
       begin
         tt:=t^.next;
         t^.next:=view;
         view^.next:=tt;
       end;
   end;
  if current<>nil then
    begin
      current^.setstate(false,sfselected);
      if current^.state and sffocused<>0 then
       begin
         current^.setstate(false,sffocused);
         view^.setstate(true,sffocused);
       end;
      view^.setstate(true,sfselected);
      current:=view;
    end
   else
    begin
      current:=view;
      if view^.owner^.state and sffocused<>0 then
       view^.setstate(true,sffocused);
      view^.setstate(true,sfselected);
    end;
  iorun;
end;

constructor ttask.init;
begin
  command:=acommand;
  owner:=aowner;
  kill:=false;
  next:=nil;
  block:=false;
end;
procedure ttask.run;
begin
  passcommand;
end;
destructor ttask.done;
begin
end;
procedure ttask.passcommand;
begin
  event.what:=evcommand;
  event.command:=command;
  owner^.handlevent(event);
end;

procedure tkeybtask.run;
begin
  if keypressed then
   begin
     event.what:=evkeyboard;
     event.charcode:=readkey;
     if event.charcode=#0 then
      event.scancode:=ord(readkey);
     event.serve:=serve_val;
     addevent(event);
     scrtime:=clock_val;
   end;
end;

constructor ttimertask.init;
begin
  inherited init(view,acommand);
  period:=per;
  time:=clock_val;
  once:=en;
end;
procedure ttimertask.run;
begin
  if clock_val>time+period then
   begin
     time:=clock_val;
     event.what:=evcommand;
     event.command:=command;
     event.infolong:=time;
     owner^.handlevent(event);
     if once then
      kill:=true;
   end;
end;
procedure newtask;
var
  t:ptask;
begin
  if tasklist[task_point]=nil then
    tasklist[task_point]:=task
   else
    begin
      t:=tasklist[task_point];
      while t^.next<>nil do
       t:=t^.next;
      t^.next:=task;
    end;
end;

constructor teventtask.init;
begin
  inherited init(aowner,acommand);
  block:=true;
end;
procedure teventtask.run;
begin
  climouse:=true;
  if eventqueque[pointlist].lastevent<>nil then
   begin
     while eventqueque[pointlist].lastevent<>nil do
      begin
        getevent(event);
        if event.what and evmouse<>0 then
         begin
           oldmousewhere:=mousewhere;
           mousewhere:=event.global;
         end;
        climouse:=false;
        sonetself^.handlevent(event);
        climouse:=true;
      end;
   end;
  climouse:=false;
end;
procedure addevent;
var
  t:peventlist;
begin
  with eventqueque[pointlist] do
   begin
     if maxavail<=4096 then
      begin
        sound(1000);
        delay(10);
        nosound;
        exit;
      end;
     new(t);
     t^.event:=event;
     t^.next:=nil;
     if lastevent=nil then
      lastevent:=t;
     firstevent^.next:=t;
     firstevent:=t;
   end;
end;
procedure getevent;
var
  t:peventlist;
begin
  with eventqueque[pointlist] do
   begin
     event:=lastevent^.event;
     t:=lastevent;
     lastevent:=lastevent^.next;
     if lastevent=nil then
      firstevent:=nil;
     dispose(t);
   end;
end;

end.