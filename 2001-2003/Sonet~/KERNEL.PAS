unit kernel;
{---------}
interface
{---------}
const
  maxcolor=16;
  maxcol_windows=255;
  menuopeninterval=6;
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
  sflight=$1;
  sfdislight=$2;
  sfauto=$4;
  sfselected=$8;
  sffocused=$10;
  sfinserted=$20;
  sfuseing=$40;
  sfdisable=$80;
  sfdraw=$100;
  {"options"}
  ofselectable=$1;
  oftopselect=$2;
  offirstclic=$4;
  ofauto=$8;
  {"commands"}
  cmnothing=0;
  cmshutdown=1;
  cmclose=2;
  cmokay=3;
  cmcencel=4;
  cmtask=5;
  cmtime=6;
  cmrefresh=7;
  cmexec=8;
  {"colors"}
  c_back=3;
  c_base=7;
  c_basetext=0;
  c_frameactive=1;
  c_framepassive=8;
  c_shadow=8;
  c_red=12;
  c_blue=13;
  c_white=15;
type
  tfont=record
    font,charsize:word;
  end;

  tpoint=record
    x,y:integer;
  end;

  pview=^tview;

  pgroup=^tgroup;

  tevent=record
    what:word;
    sign:pview;
    putflag:boolean;
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

  tputpixel=procedure(window:pview;p:tpoint;color:word);

  tview=object
    stateview:word;
    owner:pgroup;
    eventmask:word;
    options:word;
    growmode:word;
    first,next:pview;
    global,origin,size:tpoint;
    plat:pview;
    constructor init(r:trect);
    procedure handlevent(var event:tevent);virtual;
    procedure draw;virtual;
    destructor done;virtual;
    procedure setstate(enable:boolean;astate:word);virtual;
    procedure clearevent(var event:tevent);
    procedure putevent(var event:tevent);
    procedure getextend(var r:trect);{r-global}
    function state:word;
    function contains(p:tpoint):boolean;virtual;
    procedure grow(dx,dy:integer);virtual;
    procedure move(dx,dy:integer);virtual;
    procedure fillevent(var event:tevent);
    procedure putpixel(x,y:integer;color:byte);
    function visiblepoint(windownum:word;x,y:integer):boolean;
    procedure hidemouse;
  end;

  tgroup=object(tview)
    current,auto,light:pview;
    constructor init(r:trect);
    procedure handlevent(var event:tevent);virtual;
    procedure draw;virtual;
    destructor done;virtual;
    procedure setstate(enable:boolean;astate:word);virtual;
    procedure clear(view:pview);
    procedure clean(r:trect);virtual;
    {procedure grow(dx,dy:integer);virtual;}
    procedure move(dx,dy:integer);virtual;
    procedure insert(view:pview);
    procedure delete(view:pview);
    procedure select(view:pview);
    procedure selectnext(dir:boolean);
   private
    procedure passevent(view:pview;var event:tevent);
    function findview(where:tpoint):pview;
    procedure setlightview(view:pview);
  end;

  trgb=record
    r,g,b:integer;
  end;

  trgbpalette=array[0..maxcolor-1] of trgb;

  ptask=^ttask;

  ptasklist=^ttasklist;
  ttasklist=record
    task:ptask;
    next:ptasklist;
  end;

  ttask=object
    owner:pview;
    command:word;
    event:tevent;
    kill:boolean;
    constructor init(view:pview;acommand:word);
    procedure run;virtual;
    destructor done;virtual;
  end;

  pkernel=^tkernel;

  tkernel=object(tgroup)
    palette:trgbpalette;
    tasks,newtasks:ptasklist;
    shutdown:boolean;
    constructor init;
    procedure run;
    procedure handlevent(var event:tevent);virtual;
    procedure clean(r:trect);virtual;
    procedure execute(event:tevent);{обработчик событий}
    procedure newtask(task:ptask;priv:word);
    procedure killtask(task:ptask);
    destructor done;virtual;
  end;

  pkeybtask=^tkeybtask;
  tkeybtask=object(ttask)
    constructor init;
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
const
  mousewhere:tpoint=(x:320;y:240);
  oldmousewhere:tpoint=(x:320;y:240);
  put_move:boolean=false;
  colwindows:word=0;
var
  self: pkernel;
  clock_val:longint absolute $40:$6c;
  windows_a,windows_b:array[0..maxcol_windows-1]of tpoint;
  i:word;
  f:boolean;
{---------}
implementation
{---------}
uses graph,mouse,crt;
var
  oldx,oldy:integer;
const
  egacolors:array[0..15]of byte=
      (0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);

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

type
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

{"tviewsteck"}

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
  owner:=nil;
  first:=nil;
  next:=nil;
  global.x:=r.a.x;
  global.y:=r.a.y;
  origin.x:=0;
  origin.y:=0;
  size.x:=r.b.x-r.a.x;
  size.y:=r.b.y-r.a.y;
  eventmask:=$ffff;
  options:=ofselectable+offirstclic+ofauto;
  stateview:=0;
  plat:=nil;
end;

procedure tview.clearevent;
begin
  event.sign:=@self;
  event.what:=evnothing;
  event.double:=false;
end;

procedure tview.handlevent;
begin
end;

procedure tview.draw;
begin
end;

destructor tview.done;
begin
end;

procedure tview.setstate;
begin
  if enable then
    stateview:=stateview or astate
   else
    stateview:=stateview and not astate;
end;

procedure tview.putevent;
begin
  event.putflag:=true;
  event.sign:=@self;
end;

procedure tview.getextend;
begin
  r.a.x:=global.x;
  r.a.y:=global.y;
  r.b.x:=r.a.x+size.x;
  r.b.y:=r.a.y+size.y;
end;

function tview.state;
begin
  state:=stateview;
end;

function tview.contains;
begin
  contains:=(p.x>=global.x)and(p.y>=global.y)and
            (p.x<=global.x+size.x)and(p.y<=global.y+size.y);
end;

procedure tview.grow;
begin
  size.x:=size.x+dx;
  size.y:=size.y+dy;
end;

procedure tview.move;{от-но границ владельца}
begin
  global.x:=global.x+dx;
  global.y:=global.y+dy;
  origin.x:=origin.x+dx;
  origin.y:=origin.y+dy;
end;

procedure tview.fillevent;
begin
  fillchar(event,sizeof(tevent),0);
end;

procedure tview.putpixel;
var
  t:pview;
  p:tpoint;
  adr:word;
  b:byte;
begin
  if plat=nil then
   exit;
  t:=plat^.next;
  p.x:=x;
  p.y:=y;
  if contains(p) then
   begin
     while (t<>nil)and not t^.contains(p) do
      t:=t^.next;
     if t=nil then
      if (x>=mousewhere.x-16)and(x<=mousewhere.x+32)and
         (y>=mousewhere.y-1)and(y<=mousewhere.y+16){and
         (x>=oldmousewhere.x-16)and(x<=oldmousewhere.x+32)and
         (y>=oldmousewhere.y-1)and(y<=oldmousewhere.y+16)} then
        begin
          if not((x>=0)and(x<=639)and(y>=0)and(y<=479)) then
           exit;
          mouse.hidemouse;
          port[$3ce]:=5;
          port[$3cf]:=2;
          adr:=y shl 6+y shl 4+x div 8;
          port[$3ce]:=8;
          port[$3cf]:=128 shr (x mod 8);
          b:=mem[sega000:adr];
          mem[sega000:adr]:=color;
          mouse.showmouse;
        end
       else
        begin
          if not((x>=0)and(x<=639)and(y>=0)and(y<=479)) then
           exit;
          if inhandlerproc then
           asm
             cli
           end;
          port[$3ce]:=5;
          port[$3cf]:=2;
          adr:=y shl 6+y shl 4+x div 8;
          port[$3ce]:=8;
          port[$3cf]:=128 shr (x mod 8);
          b:=mem[sega000:adr];
          mem[sega000:adr]:=color;
          if inhandlerproc then
           asm
             sti
           end;
        end;
   end;
end;

procedure tview.hidemouse;
begin
  color_:=getcolor;
  if ((mousewhere.x>=global.x-cursorsizex)and(mousewhere.y>=global.y-cursorsizey)and
     (mousewhere.x<=global.x+size.x+4)and(mousewhere.y<=global.y+size.y+4))or
     ((oldmousewhere.x>=global.x-cursorsizex)and(oldmousewhere.y>=global.y-cursorsizey)and
     (oldmousewhere.x<=global.x+size.x+4)and(oldmousewhere.y<=global.y+size.y+4))then
     mouse.hidemouse;
end;

constructor tgroup.init;
begin
  inherited init(r);
  current:=nil;
  auto:=nil;
  light:=nil;
end;

procedure tgroup.handlevent;
var
  t,view:pview;
  f:boolean;
begin
  if event.what and evmouse<>0 then
   if (event.what and (evmouseauto+evmouselup)<>0)and
      (auto<>nil) then
    begin
      f:=(event.what and evmouselup<>0)and(auto<>nil);
      passevent(auto,event);
      if auto^.stateview and sfuseing=0 then
       begin
         clearevent(event);
         exit;
       end;
      if f then
       begin
         auto^.setstate(false,sfauto);
         auto:=nil;
       end;
      view:=findview(mousewhere);
      if light<>view then
       setlightview(view);
      if event.sign=nil then
       clearevent(event);
    end
   else
    begin
      view:=findview(event.global);
      if view<>light then
       setlightview(view);
      if view=nil then exit;
      if (event.what and evmouseldown<>0)and
         (view^.options and ofauto<>0) then
       begin
         if auto<>nil then
          auto^.setstate(false,sfauto);
         auto:=view;
         view^.setstate(true,sfauto);
       end;
      if (event.what and evmouseldown<>0)and
         (view^.options and (offirstclic+ofselectable)<>0)and
         (view^.state and sfdisable=0)and(current<>view) then
        select(view);
      if not((auto=nil)and(stateview and sfauto<>0)) then
       passevent(view,event);
      {if event.sign=nil then
       clearevent(event);}
    end;
end;

procedure tgroup.select;
var
  t:pview;
begin
  if view=nil then
   begin
     if current<>nil then
      begin
        current^.setstate(false,sfselected);
        current^.setstate(false,sffocused);
      end;
     current:=nil;
     exit;
   end;
  if (first=nil)or(view^.options and ofselectable=0)and
     (view^.state and sfdisable<>0) then
   exit;
  if current<>nil then
    begin
      current^.setstate(false,sfselected);
      if current^.state and sffocused<>0 then
       begin
         current^.setstate(false,sffocused);
         view^.setstate(true,sffocused);
       end;
      current:=view;
    end
   else
    begin
      current:=view;
      if view^.owner^.stateview and sffocused<>0 then
       view^.setstate(true,sffocused);
    end;
  t:=first;
  while (t<>nil)and(view<>t) do
   t:=t^.next;
  if t=nil then
   exit;
  view^.setstate(true,sfselected);
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
  {if (view^.state and sfuseing<>0)and(view^.options and ofselectable=0) then
   view^.draw;}
end;

procedure tgroup.selectnext;
var
  t:pview;
begin
  if first=nil then
   exit;
  if first^.next=nil then
   begin
     select(nil);
     exit;
   end;
  if current=nil then
   current:=first;
  if dir then
    if current^.next<>nil then
      select(current^.next)
     else
      select(first)
   else
    begin
      t:=first;
      while (t^.next<>nil)and(t^.next<>current) do
       t:=t^.next;
      select(t);
    end;
end;

procedure tgroup.insert;
var
  t:pview;
begin
  if view=nil then
   exit;
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
  view^.setstate(true,sfinserted);
  if view^.plat=nil then
   view^.plat:=plat;
  if state and sfuseing<>0 then
   view^.setstate(true,sfuseing);
  select(view);
  if stateview and sfuseing<>0 then
   view^.draw;
  put_move:=true;
end;

procedure tgroup.draw;
var
  t:pview;
begin
  tview.setstate(true,sfdraw);
  t:=first;
  while t<>nil do
   begin
     t^.draw;
     if t^.first=nil then
      t^.setstate(true,sfdraw);
     t:=t^.next;
   end;
end;

destructor tgroup.done;
var
  t:pview;
begin
  t:=first;
  while t<>nil do
   begin
     dispose(t,done);
     t:=t^.next;
   end;
  inherited done;
end;

procedure tgroup.delete;
var
  t,tv:pview;
begin
  if (view=nil)or(first=nil) then
   exit;
  tv:=nil;
  if current=view then
   begin
     {t:=first;
     while (t^.next<>nil)and(t^.next<>current) do
      t:=t^.next;
     tv:=t;}
     selectnext(false);
   end;
  if auto=view then
   begin
     auto^.setstate(false,sfauto);
     auto:=nil;
   end;
  if light=view then
   begin
     light^.setstate(false,sflight);
     light:=nil;
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
  {select(tv);}
  view^.next:=nil;
  view^.owner:=nil;
  view^.plat:=nil;
  view^.setstate(false,sfuseing);
  put_move:=true;
end;
procedure tgroup.setstate;
var
  t:pview;
begin
  inherited setstate(enable,astate);
  if (astate and sffocused<>0)and
     (current<>nil) then
   current^.setstate(enable,sffocused);
  if (astate and sfauto<>0)and
     (auto<>nil)and not enable then
   begin
     auto^.setstate(false,sfauto);
     auto:=nil;
   end;
  if astate and sfuseing<>0 then
   begin
     t:=first;
     while t<>nil do
      begin
        t^.setstate(enable,sfuseing);
        t:=t^.next;
      end;
   end;
end;

procedure tgroup.clear;
var
  r:trect;
  t:pview;
begin
  if view<>nil then
   begin
     view^.getextend(r);
     clean(r);
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
end;

procedure tgroup.move;
var
  t:pview;
begin
  inherited move(dx,dy);
  t:=first;
  while t<>nil do
   begin
     t^.global.x:=t^.global.x+dx;
     t^.global.y:=t^.global.y+dy;
     t:=t^.next;
   end;
end;

function tgroup.findview;
var
  t,view:pview;
  st:tviewsteck;
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
     if t^.contains(where) then
     view:=t;
     st.pop(t);
   end;
  st.done;
  findview:=view;
end;

procedure tgroup.setlightview(view:pview);
begin
  if ((view=nil)or(view^.state and (sfdislight+sflight)=0))and(light<>view) then
   begin
     if light<>nil then
      light^.setstate(false,sflight);
     light:=view;
     if light<>nil then
      light^.setstate(true,sflight);
   end;
end;

procedure tgroup.passevent;
begin
  if view<>nil then
   if view^.eventmask and event.what<>0 then
    view^.handlevent(event);
end;

procedure handlermouse(event:tevent);far;
begin
  if (oldx=-1)or(oldy=-1) then
    begin
      event.dx:=0;
      event.dy:=0;
      oldmousewhere.x:=event.global.x;
      oldmousewhere.y:=event.global.y;
    end
   else
    begin
      event.dx:=event.global.x-oldx;
      event.dy:=event.global.y-oldy;
      oldmousewhere.x:=oldx;
      oldmousewhere.y:=oldy;
    end;
  oldx:=event.global.x;
  oldy:=event.global.y;
  kernel.self^.execute(event);
end;

constructor ttask.init;
begin
  command:=acommand;
  owner:=view;
  kill:=false;
end;

procedure ttask.run;
begin
  fillchar(event,sizeof(event),0);
  event.what:=evcommand;
  event.command:=command;
  owner^.handlevent(event);
end;

destructor ttask.done;
begin
end;

{procedure drawpixel(window:pview;p:tpoint;color:word);far;
var
  t:pview;
  flag:boolean;
begin
  if window=nil then
   exit;
  t:=window;
  while (t<>nil)and not t^.contains(p) do
   t:=t^.next;
  if t=nil then
   graph.putpixel(p.x,p.y,color);
end;}
function tview.visiblepoint(windownum:word;x,y:integer):boolean;
begin
  f:=(x>=windows_a[windownum].x)and(x<=windows_b[windownum].x)and
     (y>=windows_a[windownum].y)and(y<=windows_b[windownum].y);
  if f then
    begin
      i:=windownum;
      while (i<=colwindows)and
            (x<windows_a[windownum].x)or(x>windows_b[windownum].x)or
            (y<windows_a[windownum].y)or(y>windows_b[windownum].y) do
       inc(i);
      visiblepoint:=(i>colwindows);
    end
   else
    visiblepoint:=f;
end;

constructor tkernel.init;
var
  r:trect;
  gd,gm,i:integer;
begin
  kernel.self:=@self;
  oldx:=-1;
  oldy:=-1;
  r.a.x:=0;
  r.a.y:=0;
  r.b.x:=639;
  r.b.y:=479;
  colwindows:=0;
  randomize;
  inherited init(r);
  stateview:=stateview or(sfselected+sffocused+sfinserted+sflight+sfuseing);
  options:=0;
  gd:=vga;
  gm:=vgahi;
  initgraph(gd,gm,'');
  newtasks:=nil;
  for i:=0 to maxcolor-1 do
   with palette[i] do
    setrgbpalette(egacolors[i],r,g,b);
  setfillstyle(1,c_back);
  bar(0,0,639,479);
  mousehandleron(handlermouse);
  showmouse;
  newtask(new(pkeybtask,init),0);
end;

procedure tkernel.run;
var
  t,t1:ptasklist;
  event:tevent;
begin
  repeat
    while (tasks<>nil)and tasks^.task^.kill do
     begin
       t:=tasks;
       tasks:=tasks^.next;
       dispose(t);
     end;
    t:=tasks;
    while t<>nil do
     begin
       if (t^.next<>nil)and(t^.next^.task^.kill) then
        begin
          t1:=t^.next;
          t^.next:=t^.next^.next;
          dispose(t1^.task,done);
          dispose(t1);
        end;
       t^.task^.run;
       if t^.task^.kill then
        t^.task^.done;
       if shutdown then
        break;
       if put_move then
        begin
          fillevent(event);
          event.what:=evmousemove;
          event.global:=mousewhere;
          execute(event);
          put_move:=false;
        end;
       t:=t^.next;
     end;
  until shutdown;
  mousehandleroff;
end;

procedure tkernel.handlevent;
begin
  inherited handlevent(event);
  if event.what and evcommand<>0 then
   begin
     case event.command of
       cmshutdown:shutdown:=true;
       cmrefresh:begin
                   hidemouse;
                   setfillstyle(1,c_back);
                   bar(0,0,639,479);
                   showmouse;
                   draw;
                 end;
      else
       exit;
     end;
     clearevent(event);
   end;
end;

procedure tkernel.clean;
begin
  hidemouse;
  setfillstyle(1,c_back);
  bar(r.a.x,r.a.y,r.b.x,r.b.y);
  showmouse;
end;

procedure tkernel.execute;
begin
  event.putflag:=true;
  while event.putflag do
   begin
     event.putflag:=false;
     if event.what and eventmask<>0 then
      handlevent(event);
   end;
end;

procedure tkernel.newtask;
var
  t:ptasklist;
begin
  new(t);
  t^.next:={new}tasks;
  t^.task:=task;
  {new}tasks:=t;
end;

procedure tkernel.killtask;
begin
  if task<>nil then
   task^.kill:=true;
end;

{procedure tkernel.newwindow;
begin
  insert(view);
  view^.putpixel:=}

destructor tkernel.done;
var
  t,tt:ptasklist;
begin
  t:=tasks;
  while t<>nil do
   begin
     dispose(t^.task,done);
     tt:=t;
     t:=t^.next;
     dispose(tt);
   end;
  inherited done;
  mousehandleroff;
  hidemouse;
  closegraph;
end;

constructor tkeybtask.init;
begin
  inherited init(kernel.self,0);
end;

procedure tkeybtask.run;
begin
  if keypressed then
   begin
     fillchar(event,sizeof(event),0);
     event.what:=evkeyboard;
     event.charcode:=readkey;
     if event.charcode=#0 then
     event.scancode:=ord(readkey);
     event.serve:=mem[$0000:$0417];
     kernel.self^.execute(event);
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
      kernel.self^.killtask(@self);
   end;
end;

end.