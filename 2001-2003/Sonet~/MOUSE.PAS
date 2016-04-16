unit mouse;
{--------}
interface
{--------}
uses kernel;
type
  tproc=procedure(event:tevent);
procedure mousehandleron(proc:tproc);
procedure mousehandleroff;
procedure swapbuttons(f:boolean);
function getbuttconfig:boolean;
procedure setmousespeed(hor,ver:integer);
procedure setdoublespeed(speed:word);
procedure showmouse;
procedure hidemouse;
const
  show:boolean=false;
  cursorsizex=32;
  cursorsizey=32;
  inhandlerproc:boolean=true;
  color_:word=15;
{------------}
implementation
{------------}
uses f_mouse,graph;
const
  count:byte=0;
  doubtime:longint=0;
  lup:integer=0;
  ldown:integer=0;
  rdown:integer=0;
  rup:integer=0;
  handler:tproc=nil;
  doubletime:longint=9;
  flag:boolean=false;
  swap:boolean=true;
  oldbutt:integer=0;
var
  c,i,j:byte;
  adr,b:longint;
  d:integer;
  bb:byte absolute b;
  buttst,maskst,xst,yst:integer;
procedure userproc(mask,butt,x,y,dx,dy:integer);far;
var
  t:longint;
  event:tevent;
begin
  inhandlerproc:=false;
  t:=meml[$0040:$006c];
  fillchar(event,sizeof(event),0);
  mousewhere.x:=x;
  mousewhere.y:=y;
  event.putflag:=false;
  event.global.x:=x;
  event.global.y:=y;
  event.buttons:=butt;
  event.ctrl:=mem[$0000:$0417] and svctrl<>0;
  event.lshift:=mem[$0000:$0417] and svlshift<>0;
  event.rshift:=mem[$0000:$0417] and svrshift<>0;
  event.shift:=event.lshift or event.rshift;
  if mask and 1=1 then
   event.what:=event.what or evmousemove;
  if (mask and lup<>0)or((oldbutt and 1<>0)and(butt and 1=0))then
   event.what:=event.what or evmouselup;
  if (mask and rup<>0)or((oldbutt and 2<>0)and(butt and 2=0))then
   event.what:=event.what or evmouserup;
  if (mask and ldown<>0)or((oldbutt and 1=0)and(butt and 1<>0)) then
   event.what:=event.what or evmouseldown;
  if (mask and rdown<>0)or((oldbutt and 2=0)and(butt and 2<>0))then
   event.what:=event.what or evmouserdown;
  oldbutt:=butt;
  if (mask and ldown<>0)and(count mod 2=0) then
   begin
     if count=0 then doubtime:=t;
     if t-doubtime>=doubletime then
       begin
         count:=1;
         doubtime:=t;
       end
      else
       inc(count);
   end;
  if (mask and lup<>0)and(count mod 2<>0) then
   begin
     if t-doubtime>=doubletime then
       count:=0
      else
       inc(count);
     if count=4 then
      begin
        event.double:=true;
        count:=0;
      end;
   end;
  if butt and 1=1 then
   event.what:=event.what or evmouseauto;
  buttst:=butt;
  handler(event);
  inhandlerproc:=true;
end;
procedure setmousespeed;
begin
  f_mouse.setsteptopixel(hor,ver);
end;
procedure setdoublespeed;
begin
  doubletime:=round(speed*18.5/1000);
end;
procedure swapbuttons;
begin
  swap:=f;
  if swap then
   if numbutton=0 then
    begin
      lup:=4;
      ldown:=2;
      rdown:=8;
      rup:=16;
    end
   else
    begin
      lup:=16;
      ldown:=2;
      rdown:=4;
      rup:=32;
    end
  {else
   if numbutton=0 then
    begin
      lup:=16;
      ldown:=8;
      rdown:=2;
      rup:=4;
    end
   else
    begin
      lup:=32;
      ldown:=4;
      rdown:=2;
      rup:=16;
    end}
end;
function getbuttconfig;
begin
  getbuttconfig:=swap;
end;
procedure mousehandleron;
var
  butt:integer;
begin
  if flag then exit;
  handler:=proc;
  initmouse;
  setmousehandler(1+ldown+rdown+lup+rup,userproc);
  getmousestate(butt,mousewhere.x,mousewhere.y);
  flag:=true;
end;
procedure mousehandleroff;
begin
  if not flag then exit;
  clearmousehandler;
  flag:=false;
end;
procedure showmouse;
var
  x,y:integer;
begin
  setcolor(color_);
  if not show then
   begin
     show:=true;
     f_mouse.showmouse;
   end;
  if inhandlerproc then
   asm
     sti
   end;
end;
procedure hidemouse;
begin
  if show then
   begin
     f_mouse.hidemouse;
     show:=false;
   end;
  if inhandlerproc then
   asm
     cli
   end;
end;

begin
  swapbuttons(true);
end.
