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
  sflife=$1;
  sfauto=$2;
  sffocused=$4;
  sfselected=$8;
  {"options"}
  oftopselect=$1;
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
          0:(infolong:longint));
  end;

  tfont=record
    font,charsize:word;
  end;
  pview=^tview;
  pgroup=^tgroup;
  tview=object
    origin:tpoint;{координаты ел-та отн-но владельца}
    size:tpoint;{размеры}
    first:pview;{1-й подэл-т}
    next:pview;{следующий ел-т}
    owner:pgroup;{владелец}
    state:word;
    options:word;
    hideflag:boolean;
    {eventmask:word;}
    constructor init(r:trect);{!!!! r-local !!!!}
    procedure draw;virtual;
    procedure handlevent(var event:tevent);virtual;
    procedure setstate(enable:boolean;astate:word);virtual;
    destructor done;virtual;
    procedure free;
    procedure getextend(var r:trect);
    procedure iostop(r:trect);
    procedure iorun;
  end;

  tgroup=object(tview)
    auto:pview;
    current:pview;
    constructor init(r:trect);{!!!! r-local !!!!}
    procedure draw;virtual;
    procedure handlevent(var event:tevent);virtual;
    procedure insert(view:pview);
    procedure delete(view:pview);
    procedure setstate(enable:boolean;astate:word);virtual;
    destructor done;virtual;
    procedure clear(view:pview);
    procedure clean(r:trect);virtual;
    procedure select(view:pview);
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
    command:word;{команда}
    owner:pview;{владелец}
    next:ptask;{следующая задача в списке}
    event:tevent;
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
const
  enablevents:integer=0;
  mousevisible:integer=0;
  mousewhere:tpoint=(x:320;y:240);
  oldmousewhere:tpoint=(x:320;y:240);
  egacolors:array[0..15]of byte=
      (0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
  disableview:pview=nil;
  sizemouse:tpoint=(x:32;y:32);
  rscreen:trect=(a:(x:0;y:0);b:(x:639;y:479));
  windowtitlefont:tfont=(font:2;charsize:4);
var
  syspalette:tpalette;
  clock_val:longint absolute $0040:$006c;
  serve_val:byte absolute $0000:$0417;
implementation

uses mouse;

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
  origin.x:=r.a.x;
  origin.y:=r.a.y;
  size.x:=r.b.x-r.a.x;
  size.y:=r.b.y-r.a.y;
  first:=nil;
  next:=nil;
  owner:=nil;
  state:=0;
  options:=0;
  hideflag:=false;
end;
procedure tview.draw;
begin
end;
procedure tview.handlevent;
begin
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
begin
  if owner<>nil then
   owner^.delete(@self);
  done;
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
  if enablevents=0 then
   asm
     cli
   end;
  inc(enablevents);
  hideflag:=((mousewhere.x>=r.a.x-sizemouse.x)and(mousewhere.y>=r.a.y-sizemouse.y)and
            (mousewhere.x<=r.b.x)and(mousewhere.y<=r.b.y))or
            ((oldmousewhere.x>=r.a.x-sizemouse.x)and(oldmousewhere.y>=r.a.y-sizemouse.y)and
            (oldmousewhere.x<=r.b.x)and(oldmousewhere.y<=r.b.y));
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
  if enablevents=0 then
   asm
     sti
   end;
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
     t^.draw;
     t:=t^.next;
   end;
end;
procedure tgroup.handlevent;
var
  st:tviewsteck;
  t,view:pview;
  f:boolean;
  wh:tpoint;
begin
  if event.what and evmouse<>0 then
   if auto<>nil then
     begin
       wh:=event.where;
       event.where.x:=event.where.x-auto^.origin.x;
       event.where.y:=event.where.y-auto^.origin.y;
       f:=event.what and evmouseauto=0;
       if auto<>disableview then
        auto^.handlevent(event);
       if f and(auto<>nil)and(auto<>disableview) then
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
           if (event.where.x>=t^.origin.x)and
              (event.where.y>=t^.origin.y)and
              (event.where.x<=t^.origin.x+t^.size.x)and
              (event.where.y<=t^.origin.y+t^.size.y) then
           view:=t;
           st.pop(t);
         end;
        st.done;
        if (view<>nil)and(view<>disableview) then
         begin
           if event.what and evmouseldown<>0 then
            begin
              if auto<>nil then
               auto^.setstate(false,sfauto);
              auto:=view;
              auto^.setstate(true,sfauto);
              if current<>view then
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
end;
procedure tgroup.insert;
var
  t:pview;
  r:trect;
begin
  if view=nil then
   exit;
  view^.getextend(r);
  if state and sflife<>0 then
   iostop(r);
  if first=nil then
    first:=view
   else
    begin
      t:=first;
      while t^.next<>nil do
       t:=t^.next;
      t^.next:=view;
    end;
  view^.owner:=@self;
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
  t:pview;
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
    first:=view^.next
   else
    begin
      t:=first;
      while (t^.next<>view)and(t^.next<>nil) do
       t:=t^.next;
      if t^.next<>nil then
       t^.next:=t^.next^.next;
    end;
  clear(view);
  view^.next:=nil;
  view^.owner:=nil;
  if state and sflife<>0 then
   view^.setstate(false,sflife);
  if current=view then
   begin
     current:=nil;
     if first=nil then
       first:=view
      else
       begin
         t:=first;
         while t^.next<>nil do
          t:=t^.next;
         current:=t;
         if t^.owner^.state and sffocused<>0 then
          t^.setstate(true,sffocused);
         t^.setstate(true,sfselected);
       end;
   end;
  if state and sflife<>0 then
   iorun;
end;
procedure tgroup.clear;
var
  r:trect;
  t:pview;
begin
  if view<>nil then
   begin
     view^.getextend(r);
     view^.iostop(r);
     clean(r);
     view^.iorun;
     t:=first;
     while t<>nil do
      begin
        if t<>view then
         t^.draw;
        t:=t^.next;
      end;
   end;
end;
procedure tgroup.clean;
begin
  if owner<>nil then
   owner^.clean(r);
end;
procedure tgroup.select;
var
  t:pview;
  r:trect;
begin
  view^.getextend(r);
  iostop(r);
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
  if (view^.options and oftopselect<>0)and
     (view^.next<>nil) then
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
     while t^.next<>nil do
      t:=t^.next;
     t^.next:=view;
     view^.next:=nil;
   end;
  iorun;
end;

constructor ttask.init;
begin
  command:=acommand;
  owner:=aowner;
  kill:=false;
  next:=nil;
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
  disableview:=owner;
  owner^.handlevent(event);
  disableview:=nil;
end;

procedure tkeybtask.run;
begin
  if keypressed then
   begin
     event.what:=evkeyboard;
     event.charcode:=readkey;
     if event.charcode=#0 then
     event.scancode:=ord(readkey);
     event.serve:=mem[$0000:$0417];
     disableview:=owner;
     owner^.handlevent(event);
     disableview:=nil;
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
     disableview:=owner;
     owner^.handlevent(event);
     if once then
      kill:=true;
     disableview:=nil;
   end;
end;

end.