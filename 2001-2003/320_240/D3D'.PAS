program draw3d;

uses crt, grafixX;

type
  ptrig = ^ttrig;
  ttrig = array[-360..360] of real;
  pobj3d = ^tobj3d;
  tobj3d = record
    x1, y1, z1, x2, y2, z2 : real;
    next : pobj3d
  end;

var
  psin, pcos : ptrig;

procedure setuptrig (var psin, pcos : ptrig);
var
  i   : integer;
  rad : real;
begin
  new (psin); new (pcos);
  for i := -360 to 360 do
    begin
      rad := i*pi/180;
      psin^[i] := sin(rad);
      pcos^[i] := cos(rad)
    end
end;

procedure setupquad (var po : pobj3d; a : real);
var p1, p2 : pobj3d;
begin
  new (po);
  p2 := po;
  p1 := p2;
  p1^.x1 := -a/2;  p1^.y1 := a/2;  p1^.z1 := 0;
  p1^.x2 := a/2;  p1^.y2 := a/2;  p1^.z2 := 0;
  new (p2);
  p1^.next := p2;
  p1 := p2;
  p1^.x1 := a/2;  p1^.y1 := a/2;  p1^.z1 := 0;
  p1^.x2 := a/2;  p1^.y2 := -a/2;  p1^.z2 := 0;
  new (p2);
  p1^.next := p2;
  p1 := p2;
  p1^.x1 := a/2;  p1^.y1 := -a/2;  p1^.z1 := 0;
  p1^.x2 := -a/2;  p1^.y2 := -a/2;  p1^.z2 := 0;
  new (p2);
  p1^.next := p2;
  p1 := p2;
  p1^.x1 := -a/2;  p1^.y1 := a/2;  p1^.z1 := 0;
  p1^.x2 := -a/2;  p1^.y2 := -a/2;  p1^.z2 := 0;
  p1^.next := nil
end;

procedure rotate (var pobj : pobj3d; dx, dy, dz : integer);
var
  p : pobj3d;
  x, y, z : real;
begin
  p := pobj;
  while p <> nil do
    begin
      if dz <> 0 then
        begin
          x := p^.x1*pcos^[dz]-p^.y1*psin^[dz];
          y := p^.x1*psin^[dz]+p^.y1*pcos^[dz];
          p^.x1 := x;
          p^.y1 := y;
          x := p^.x2*pcos^[dz]-p^.y2*psin^[dz];
          y := p^.x2*psin^[dz]+p^.y2*pcos^[dz];
          p^.x2 := x;
          p^.y2 := y
        end;
      if dy <> 0 then
        begin
          z := p^.z1*pcos^[dy]-p^.x1*psin^[dy];
          x := p^.z1*psin^[dy]+p^.x1*pcos^[dy];
          p^.z1 := z;
          p^.x1 := x;
          z := p^.z2*pcos^[dy]-p^.x2*psin^[dy];
          x := p^.z2*psin^[dy]+p^.x2*pcos^[dy];
          p^.z2 := z;
          p^.x2 := x
        end;
      if dx <> 0 then
        begin
          y := p^.y1*pcos^[dx]-p^.z1*psin^[dx];
          z := p^.y1*psin^[dx]+p^.z1*pcos^[dx];
          p^.y1 := y;
          p^.z1 := z;
          y := p^.y2*pcos^[dx]-p^.z2*psin^[dx];
          z := p^.y2*psin^[dx]+p^.z2*pcos^[dx];
          p^.y2 := y;
          p^.z2 := z
        end;
      p := p^.next
    end;
end;
{
procedure wobj (pobj : pobj3d; x, y, z : integer; c : byte);
var
  x1, y1, x2, y2 : real;
begin
  while pobj <> nil do
    begin
      x1 := x + 256*pobj^.x1 / (z-pobj^.z1);
      y1 := y + 256*pobj^.y1 / (z-pobj^.z1);
      x2 := x + 256*pobj^.x2 / (z-pobj^.z2);
      y2 := y + 256*pobj^.y2 / (z-pobj^.z2);
      if (x1 >= 0) and (x1 <= maxx) and (y1 >= 0) and (y1 <= maxy) and
         (x2 >= 0) and (x2 <= maxx) and (y2 >= 0) and (y2 <= maxy) then
            lineX (round(x1), round(y1), round(x2), round(y2), c);
      pobj := pobj^.next
    end;
end;
}
procedure fill_quad (pobj : pobj3d; x,y,z:integer;c : byte);
var
  p : array [1..4] of tpoint;
begin
  p[1].x := round( x + 256 * pobj^.x1 / (z-pobj^.z1) );
  p[1].y := round( y + 256 * pobj^.y1 / (z-pobj^.z1) );
  p[2].x := round( x + 256 * pobj^.x2 / (z-pobj^.z2) );
  p[2].y := round( y + 256 * pobj^.y2 / (z-pobj^.z2) );
  pobj := pobj^.next^.next;
  p[3].x := round( x + 256 * pobj^.x1 / (z-pobj^.z1) );
  p[3].y := round( y + 256 * pobj^.y1 / (z-pobj^.z1) );
  p[4].x := round( x + 256 * pobj^.x2 / (z-pobj^.z2) );
  p[4].y := round( y + 256 * pobj^.y2 / (z-pobj^.z2) );
  fillpolyX (4, p, c);
  if c <> 0 then drawpoly2X (4, p, 15-c)
  else drawpoly2X (4, p, 0)
end;

var
  c : char;
  pquad1, pquad2 : pobj3d;
  deg, x1, y1, z1, x2, y2, z2 : integer;
  pagea, pagev : byte;

procedure swapb (var b1, b2 : byte);
var x : byte;
begin
  x := b1;
  b1 := b2;
  b2 := x
end;

begin
  setuptrig (psin, pcos);
  initgraphX;
  pquad1 := nil;
  setupquad (pquad1, 40);
  pquad2 := nil;
  setupquad (pquad2, 40);
  x1 := maxx div 4; x2 := maxx - x1;
  y1 := maxy div 2; y2 := y1;
  z1 := -128; z2 := -96;
  pagev := 0;
  pagea := 0;
  deg := 0;
  border (magenta);
  repeat
    if keypressed then c := readkey
    else c := #$FF;
    if c = #27 then break;

    swapb (pagea, pagev);
    waitretrace;                        { NO FUZZ! - NORMAL FLIPPING! }
    setvisiblepagex (pagev);
    setactivepagex (pagea);
    clearscreenx (0);
    fill_quad (pquad1, x1, y1, z1, cyan);
    fill_quad (pquad2, x2, y2, z2, green);
    delay (100);

    rotate (pquad1, 0, 0, deg);
    rotate (pquad2, deg, deg, -deg);
    deg := (deg+1) mod 360
  until false;
  border (black);
  closegraphX
end.
