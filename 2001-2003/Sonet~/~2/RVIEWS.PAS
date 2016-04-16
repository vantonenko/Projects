unit views;
{-------}
interface
{-------}
uses rect;
const
  {"events"}
  evnothing=0;
  evmouse=$4f;
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
  sfvisible=$1;{разрешает рисовать себя}
  sfactive=$2;
  sfselected=$4;
  sffocused=$8;
  sfdisable=$10;
  sflight=$20;
  sfdislight=$40;
  sfautoview=$80;
  sfinsert=$100;
  sfearlyins=$200;
  {"options"}
  ofselectable=$1;
  oftopselect=$2;
  offirstclic=$4;
  ofpreprocess=$8;
  ofpostprocess=$10;
  ofcenterx=$20;
  ofcentery=$40;
  ofcenter=$60;
  oftransparent=$80;
  ofimagic=$100;
  ofautoview=$200;
  {"growmode"}
  gfgrowhix=$1;
  gfgrowhiy=$2;
  gfgrowlox=$4;
  gfgrowloy=$8;
  {"phase"}
  phnothing=0;
  phpreprocess=$1;
  phpostprocess=$2;
  phfocused=$4;

type

  pview=^tview;

  pgroup=^tgroup;

  pcleaner=^tcleaner;

  tcleaner=procedure(r:trect);

  tevent=record
    what:word;
    sign:pview;
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
          0:(keykode:word);
          1:(charcode:char;
             scancode:byte));
      evmessage:(
        command:word;
        inf:pointer);
  end;

  tview=object
   private
     stateview:word;
     viewport:trect;{"global"}
     screen:trect;{"global coord"}
     block:boolean;

   public
     options,eventmask:word;
     growmode:byte;
     origin,size:tpoint;{origin-"local"}
     first,next:pview;
     owner:pgroup;
     cleaner:pcleaner;
    constructor init(r:trect);{r-"global"}
    procedure handlevent(var event:tevent);virtual;
    procedure draw;virtual;
    procedure clean;{stiraet sebya s ecrana}
    destructor done;virtual;
    function contains(p:tpoint):boolean;virtual;
    procedure growing(dx,dy:integer);virtual;
    procedure moveing(dx,dy:integer);virtual;
    procedure setstate(enable:boolean;astate:word);virtual;
    function state:word;
    procedure clearevent(var event:tevent);
    procedure putevent(var event:tevent);
    procedure getextend(var r:trect);{r-"global"}
    procedure makelocal(g:tpoint;var loc:tpoint);
    procedure makeglobal(loc:tpoint;var g:tpoint);
  end;

  tgroup=object(tview)
   private
     ph:byte;
     current,lightview,autoview:pview;
   public
    constructor init(r:trect);
    procedure handlevent(var event:tevent);virtual;
    procedure draw;virtual;
    destructor done;virtual;
    function contains(p:tpoint):boolean;virtual;
    procedure growing(dx,dy:integer);virtual;
    procedure moveing(dx,dy:integer);virtual;
    procedure select(view:pview);{nedopisan}
    procedure selectnext(dir:boolean);{nedopisan}
    procedure insert(view:pview);
    procedure delete(view:pview);
    function phase:byte;
    procedure setstate(enable:boolean;astate:word);virtual;
    procedure putmove;
   private
    function findview(where:tpoint):pview;
    procedure setlightview(view:pview);
  end;

var
  mousewhere:tpoint;
{------------}
implementation
{------------}
uses gdi;
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

{"tview"}

constructor tview.init;
begin
  stateview:=sfvisible;
  screen:=r;
  viewport:=screen;
  options:=ofselectable+offirstclic+ofautoview;
  eventmask:=$ffff;
  growmode:=gfgrowhix+gfgrowhiy;
  origin.x:=0;
  origin.y:=0;
  size.x:=0;
  size.y:=0;
  first:=nil;
  next:=nil;
  owner:=nil;
  fillchar(viewport,sizeof(viewport),0);
  cleaner:=nil;
  block:=true;
end;
procedure tview.handlevent;
begin
end;
procedure tview.draw;
begin
  setoxy(screen.a.x,screen.a.y);
  setviewport(viewport.a.x,viewport.a.y,
              viewport.b.x,viewport.b.y);
end;
procedure tview.clean;
var
  t:pview;
  rv:trect;
  pr:tcleaner;
begin
  pr:=cleaner^;
  pr(screen);
  setbaseview(screen);
  if owner=nil then
   exit;
  t:=owner^.first;
  while t<>nil do
   begin
     rv:=t^.screen;
     rv.inter(screen);
     if rv.empty then
      t^.draw;
     t:=t^.next;
   end;
  setmaxbaseview;
end;
destructor tview.done;
begin
  if owner<>nil then
   owner^.delete(@self);
end;
function tview.contains;
begin
  if stateview and sfvisible<>0 then
    contains:=screen.contains(p)
   else
    contains:=false;
end;
procedure tview.growing;
begin
  if ((dx<0)or(dy<0))and block then
   clean;
  size.x:=size.x+dx;
  size.y:=size.y+dy;
  screen.grow(dx,dy);
  viewport:=screen;
  viewport.inter(owner^.viewport);
  if block then
   draw;
end;
procedure tview.moveing;
begin
  if block then
   clean;
  origin.x:=origin.x+dx;
  origin.y:=origin.y+dy;
  screen.move(dx,dy);
  viewport:=screen;
  viewport.inter(owner^.viewport);
  if block then
   draw;
end;
procedure tview.setstate;
begin
  if enable then
    stateview:=stateview or astate
   else
    stateview:=stateview and not astate;
end;
function tview.state;
begin
  state:=stateview;
end;
procedure tview.clearevent;
begin
  event.what:=evnothing;
  event.sign:=@self;
end;
procedure tview.putevent;
begin
  event.sign:=pview(owner);
end;
procedure tview.getextend;
begin
  r:=screen;
end;
procedure tview.makelocal;
begin
  loc.x:=g.x-screen.a.x;
  loc.y:=g.y-screen.a.y;
end;
procedure tview.makeglobal;
begin
  g.x:=screen.a.x+loc.x;
  g.y:=screen.a.y+loc.y;
end;

{"tgroup"}

constructor tgroup.init;
begin
  inherited init(r);
  ph:=phnothing;
  current:=nil;
  lightview:=nil;
  autoview:=nil;
end;
procedure tgroup.handlevent;
var
  t,view:pview;
  f:boolean;
 procedure passevent(view:pview;var event:tevent);
 begin
   if view<>nil then
    if view^.eventmask and event.what<>0 then
     view^.handlevent(event);
 end;
begin
  inherited handlevent(event);
  if event.what and evmouse<>0 then
   if (event.what and (evmouseauto+evmouselup)<>0)and
      (autoview<>nil) then
    begin
      f:=(event.what and evmouselup<>0)and(autoview<>nil);
      passevent(autoview,event);
      if f then
       begin
         autoview^.setstate(false,sfautoview);
         autoview:=nil;
       end;
      view:=findview(event.where);
      setlightview(view);
    end
   else
    begin
      view:=findview(event.where);
      setlightview(view);
      if view=nil then exit;
      if (event.what and evmouseldown<>0)and
         (view^.options and ofautoview<>0) then
       begin
         if autoview<>nil then
          autoview^.setstate(false,sfautoview);
         autoview:=view;
         view^.setstate(true,sfautoview);
       end;
      if (event.what and (evmouseldown+evmouserdown)<>0)and
         (view^.options and (offirstclic+ofselectable)<>0)and
         (view^.state and sfdisable=0) then
       select(view);
      passevent(view,event);
    end;
  if (event.what and evbroadcast<>0)and
     (event.sign=nil) then
   begin
     t:=first;
     while (t<>nil)and(event.sign=nil) do
      begin
        passevent(t,event);
        t:=t^.next;
      end;
   end;
  ph:=phpreprocess;
  if (event.what and (evcommand+evkeyboard)<>0)and
     (event.sign=nil) then
   begin
     t:=first;
     while (t<>nil)and(event.sign=nil) do
      begin
        if t^.options and ofpreprocess<>0 then
         passevent(t,event);
        t:=t^.next;
      end;
   end;
  ph:=phfocused;
  if (event.what and (evcommand+evkeyboard)<>0)and
     (event.sign=nil) then
   passevent(current,event);
  ph:=phpostprocess;
  if (event.what and (evcommand+evkeyboard)<>0)and
     (event.sign=nil) then
   begin
     t:=first;
     while (t<>nil)and(event.sign=nil) do
      begin
        if t^.options and ofpostprocess<>0 then
         passevent(t,event);
        t:=t^.next;
      end;
   end;
  ph:=phnothing;
  if event.sign=@self then
   event.sign:=owner;
end;
procedure tgroup.draw;
var
  t:pview;
begin
  t:=first;
  while t<>nil do
   begin
     if t^.state and sfvisible<>0 then
      t^.draw;
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
function tgroup.contains;
var
  t:pview;
  pp:boolean;
begin
  pp:=inherited contains(p);
  contains:=pp;
  if not pp then
   exit;
  if options and oftransparent=0 then
    exit
   else
    pp:=false;
  t:=first;
  while (t<>nil)and not pp do
   begin
     pp:=t^.contains(p);
     t:=t^.next;
   end;
  contains:=pp;
end;
procedure tgroup.growing;
var
  t:pview;
  gx,gy,mx,my:integer;
begin
  if ((dx<0)or(dy<0))and block then
   clean;
  if block then
    begin
      block:=false;
      inherited growing(dx,dy);
      block:=true;
    end
   else
    inherited growing(dx,dy);
  t:=first;
  mx:=0;
  my:=0;
  gx:=0;
  gy:=0;
  while t<>nil do
   begin
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
     t^.block:=false;
     if (mx<>0)or(my<>0) then
      t^.moveing(mx,my);
     if (gx<>0)or(gy<>0) then
      t^.growing(gx,gy);
     t^.block:=true;
     t:=t^.next;
   end;
  if block then
   draw;
end;
procedure tgroup.moveing;
var
  t:pview;
begin
  if block then
   clean;
  if block then
    begin
      block:=false;
      inherited moveing(dx,dy);
      block:=true;
    end
   else
    inherited moveing(dx,dy);
  t:=first;
  while t<>nil do
   begin
     t^.origin.x:=t^.origin.x+dx;
     t^.origin.y:=t^.origin.y+dy;
     t^.block:=false;
     t^.moveing(dx,dy);
     t^.block:=true;
     t:=t^.next;
   end;
  if block then
   draw;
end;
procedure tgroup.select;
var
  t:pview;
begin
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
     while view^.next<>nil do
      t:=t^.next;
     t^.next:=view;
     view^.next:=nil;
   end;
  view^.draw;
end;
procedure tgroup.selectnext;
var
  t:pview;
begin
  if (first=nil)or(first^.next=nil) then
   exit;
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
  if view^.cleaner=nil then
   view^.cleaner:=cleaner;
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
  view^.viewport.inter(screen);
  if view^.state and sfearlyins=0 then
   begin
     if view^.options and ofcenterx<>0 then
      view^.origin.x:=(size.x-view^.size.x)div 2;
     if view^.options and ofcentery<>0 then
      view^.origin.y:=(size.y-view^.size.y)div 2;
     view^.setstate(true,sfearlyins);
   end;
  if state and sfinsert<>0 then
   begin
     view^.setstate(true,sfinsert);
     if view^.state and sfvisible<>0 then
      view^.draw;
   end;
  {if (view^.options and ofselectable<>0)and
     (view^.state and sfdisable=0)then
   begin
     if current<>nil then
       begin
         current^.setstate(false,sfselected);
         if current^.state and sffocused<>0 then
          begin
            current^.setstate(false,sffocused);
            view^.setstate(true,sffocused);
          end;
       end
      else
       if state and sffocused<>0 then
        view^.setstate(true,sffocused);
     view^.setstate(true,sfselected);
     current:=view;
   end;}
  select(view);
  putmove;
end;
procedure tgroup.delete;
var
  t:pview;
begin
  if (view=nil)or(first=nil) then
   exit;
  if current=view then
   selectnext(false);
  if autoview=view then
   begin
     autoview^.setstate(false,sfautoview);
     autoview:=nil;
   end;
  if lightview=view then
   begin
     lightview^.setstate(false,sflight);
     lightview:=nil;
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
  view^.clean;
  view^.next:=nil;
  view^.owner:=nil;
  view^.setstate(false,sfinsert);
  putmove;
end;
function tgroup.phase;
begin
  phase:=ph;
end;
procedure tgroup.setstate;
var
  t:pview;
begin
  inherited setstate(enable,astate);
  if (astate and sffocused<>0)and
     (current<>nil) then
   current^.setstate(enable,sffocused);
  if (astate and sfautoview<>0)and
     (autoview<>nil)and not enable then
   begin
     autoview^.setstate(false,sfautoview);
     autoview:=nil;
   end;
  if astate and sfinsert<>0 then
   begin
     t:=first;
     while t<>nil do
      begin
        t^.setstate(enable,sfinsert);
        t:=t^.next;
      end;
   end;
end;
procedure tgroup.putmove;
var
  event:tevent;
begin
  fillchar(event,sizeof(event),0);
  event.what:=evmousemove;
  event.where:=mousewhere;
  putevent(event);
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
  if (view=nil)or(view^.state and (sfdislight+sflight)=0) then
   begin
     if lightview<>nil then
      lightview^.setstate(false,sflight);
     lightview:=view;
     if lightview<>nil then
      lightview^.setstate(true,sflight);
   end;
end;
end.