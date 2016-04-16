program machine;
uses crt,graph;
const
  len=80.0;
  lenrect=20;
  rad=20;
  dr=5;
  daa:extended=pi/4000;
  temp=2000;
var
  gd,gm,x1,y1,x2,y2:integer;
  a,speed,da:extended;
  c:char;
  serve:byte absolute $0000:$0417;
procedure draw(a:extended);
begin
  setcolor(14);
  rectangle(420-rad-round(len)-lenrect-10,239-rad div 2,420+rad-round(len)+10,242+rad div 2);
  setcolor(7);
  circle(420,240,rad+dr);
  circle(420,240,3);
  line(round(420+rad*sin(a)),round(240+rad*cos(a)),round(420-rad*sin(a)),round(240-rad*cos(a)));
  line(round(420+rad*sin(a+pi/2)),round(240+rad*cos(a+pi/2)),round(420-rad*sin(a+pi/2)),round(240-rad*cos(a+pi/2)));
  circle(420,240,rad);
  setcolor(11);
  line(round(420-sqrt(sqr(len)-sqr(rad*cos(a)))-rad*sin(a)),
       240,round(420-rad*sin(a)),round(240-rad*cos(a)));
  setcolor(12);
  rectangle(round(420-lenrect-sqrt(sqr(len)-sqr(rad*cos(a)))-rad*sin(a)),241-rad div 2,
       round(420-sqrt(sqr(len)-sqr(rad*cos(a)))-rad*sin(a)),240+rad div 2);
end;
begin
  gd:=vga;
  gm:=vgahi;
  initgraph(gd,gm,'..\bp\bgi');
  randomize;
  a:=random*pi*2;
  speed:=0;
  setbkcolor(0);
  setfillstyle(1,0);
  x1:=420-round(len)-rad-lenrect-1;
  x2:=420+rad+dr+1;
  y1:=240-rad-dr-1;
  y2:=240+rad+dr+1;
  repeat
    if serve and 8<>0 then
      da:=daa*10
     else
      da:=daa;
    if serve and 4<>0 then
     speed:=speed+extended(da);
    if serve and 2<>0 then
     speed:=speed-extended(da);
    bar(x1,y1,x2,y2);
    draw(a);
    delay(temp);
    a:=a+speed;
    if a>2*pi then
     a:=a-2*pi;
  until keypressed;
  while keypressed do
   readkey;
  closegraph;
end.