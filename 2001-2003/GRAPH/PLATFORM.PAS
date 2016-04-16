unit platform;
{-------}
interface
{-------}
uses views;
type

  pplatform=^tplatform;

  tplatform=object(tgroup)
   private
     oldx,oldy:integer;
   public
    constructor init;
    procedure execute(event:tevent);
    destructor done;virtual;
  end;
{------------}
implementation
{------------}
uses mouse,gdi;
var
  platf:pplatform;
procedure handlermouse(event:tevent);far;
begin
  if (oldx=-1)or(oldy=-1) then
    begin
      event.dx:=0;
      event.dy:=0;
    end
   else
    begin
      dx:=event.where.x-oldx;
      dy:=event.where.y-oldy;
    end;
  oldx:=event.where.x;
  oldy:=event.where.y;
  platf^.execute(event);
end;
constructor tplatform.init;
var
  r:trect;
begin
  platf:=@self;
  r.a.x:=0;
  r.a.y:=0;
  r.b.x:=639;
  r.b.y:=479;
  oldx:=-1;
  oldy:=-1;
  inherited init(r);
  setstate(true,sfselected+sffocused+sflight+sfinsert+sfearlyins);
  options:=options or oftransparent;
  initgraph;
  mousehandleron(handlermouse);
end;
procedure tplatform.execute;
begin
  event.sign:=@self;
  while event.sign=@self do
   begin
     event.sign:=nil;
     if event.what and eventmask<>0 then
      handlevent(event);
   end;
end;
destructor tplatform.done;
begin
  inherited done;
  mousehandleroff;
  closegraph;
end;
end.