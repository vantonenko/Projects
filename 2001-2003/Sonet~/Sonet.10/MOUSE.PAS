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
procedure userproc(mask,butt,x,y,dx,dy:integer);far;
var
  t:longint;
  event:tevent;
begin
  if enablevents<>0 then
   exit;
  t:=meml[$0040:$006c];
  fillchar(event,sizeof(event),0);
  oldmousewhere:=mousewhere;
  mousewhere.x:=x;
  mousewhere.y:=y;
  event.global.x:=x;
  event.global.y:=y;
  event.where:=event.global;
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
  handler(event);
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
    end;
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
begin
  if not show then
   begin
     show:=true;
     f_mouse.showmouse;
   end;
end;
procedure hidemouse;
begin
  if show then
   begin
     f_mouse.hidemouse;
     show:=false;
   end;
end;

begin
  swapbuttons(true);
end.
