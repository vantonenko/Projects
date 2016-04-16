unit rect;
{-------}
interface
{-------}
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
{------------}
implementation
{------------}
{"trect"}

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
end.