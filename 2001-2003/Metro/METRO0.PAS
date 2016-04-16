program metro;
uses crt,graph;
const
  nstation=10;
  ndrive=nstation-1;
  drivespeed:shortint=1;
type
  tdrive=record
    x,y,color:integer;
    speed:shortint;
  end;
var
  gd,gm:integer;
  i,xx,yy,sp,dx:integer;
  drivers:array[1..ndrive]of tdrive;
  ch:char;
begin
  gd:=0;
  initgraph(gd,gm,'');
  for i:=1 to nstation do
   rectangle(50+(i-1)*50,50,50+(i-1)*50+10,60);
  for i:=1 to nstation-1 do
   line(50+10+(i-1)*50,55,50+10+40+(i-1)*50,55);
  xx:=0;
  yy:=-20;
  sp:=drivespeed;
  dx:=100;
  for i:=1 to ndrive do
   with drivers[i] do
    begin
      x:=xx;
      y:=yy;
      speed:=sp;
      color:=random(7)+9;
      xx:=xx+dx;
      if xx>=ndrive*50 then
       begin
         sp:=-sp;
         yy:=0;
       end;
      if xx>ndrive*50 then
       begin
         xx:=xx-dx;
         dx:=-dx;
       end;
    end;
  repeat
    for i:=1 to ndrive do
     with drivers[i] do
      begin
        setcolor(color);
        circle(x+55,65+y,2);
      end;
    delay(8000);
    setcolor(0);
    for i:=1 to ndrive do
     circle(drivers[i].x+55,65+drivers[i].y,2);
    for i:=1 to ndrive do
     with drivers[i] do
      begin
        x:=x+speed;
        if (x>ndrive*50)or(x<0) then
         begin
           x:=x-speed;
           speed:=-speed;
           if y=0 then
             y:=-20
            else
             y:=0;
         end;
      end;
  until keypressed;
  closegraph;
end.