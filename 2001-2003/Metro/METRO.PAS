program metro;
uses crt,graph;
const
  maxn=10;
  distance=800/maxn;
  ddist=distance*0.4;
  angle=pi/4-pi/12;
  dangle=pi/2;
type
  tstation=record
    x,y:integer;
  end;
var
  station:array[1..maxn]of tstation;
  gd,gm,i:integer;
  l,ang:extended;
begin
  gd:=0;
  initgraph(gd,gm,'..\..\bp\bgi');
  repeat
    cleardevice;
    randomize;
    station[1].x:=40+random(20);
    station[1].y:=40+random(20);
    for i:=2 to maxn do
     with station[i] do
      begin
        l:=distance-random*ddist;
        ang:=angle+random*dangle-dangle/2;
        x:=station[i-1].x+round(l*cos(ang));
        y:=station[i-1].y+round(l*sin(ang));
      end;
    moveto(station[1].x,station[1].y);
    for i:=2 to maxn do
     begin
       lineto(station[i].x,station[i].y);
       circle(station[i].x,station[i].y,3);
     end;
    circle(station[1].x,station[1].y,3);
  until readkey=#27;
  closegraph;
end.