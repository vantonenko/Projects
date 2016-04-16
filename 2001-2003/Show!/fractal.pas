program fractal;
uses crt,graph;
const
  maxh=6;
type
  tline=record
    a:extended;
    len:extended;
    ang:extended;
  end;
const
  collines=12;
  lines:array[1..collines]of tline=
   ((a:0.2;len:0.4;ang:pi/3),
    (a:0.45;len:0.28;ang:pi/3),
    (a:0.62;len:0.2;ang:pi/3),
    (a:0.75;len:0.13;ang:pi/3),
    (a:0.85;len:0.09;ang:pi/3),
    (a:0.92;len:0.05;ang:pi/3),
    (a:0.25;len:0.4;ang:-pi/3),
    (a:0.48;len:0.28;ang:-pi/3),
    (a:0.64;len:0.2;ang:-pi/3),
    (a:0.76;len:0.13;ang:-pi/3),
    (a:0.86;len:0.09;ang:-pi/3),
    (a:0.93;len:0.05;ang:-pi/3));
var
  height:word;
procedure draw(x,y,length,angle:extended);
var
  x0,y0,xi,yi,i:integer;
begin
  if keypressed then
   exit;
  inc(height);
  x0:=round(x);
  y0:=getmaxy-round(y);
  xi:=round(x+length*sin(angle));
  yi:=getmaxy-round(y+length*cos(angle));
  line(x0,y0,xi,yi);
  if height<maxh then
   for i:=1 to collines do
    with lines[i] do
     draw(x+length*a*sin(angle),y+length*a*cos(angle),
          length*len,angle+ang);
  dec(height);
end;
var
  gd,gm:integer;
begin
  gd:=vga;
  gm:=vgahi;
  initgraph(gd,gm,'..\..\bp\bgi');
  height:=0;
  setcolor(10);
  draw(getmaxx div 2,getmaxy div 20,getmaxy*7 div 8,0);
  readkey;
  closegraph;
end.