program nothing;
uses crt,graph;
const
  da=pi/300;
  c=60;
  l=240;
var
  gd,gm,page,r:integer;
  a:extended;
begin
  gd:=vga;
  gm:=vgahi;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  page:=0;
  r:=3;
  a:=0;
  cleardevice;
  repeat
    {setactivepage(page);
    setvisualpage(1-page);}
    page:=1-page;
    setcolor(0);
    {circle(320,150,r-2);}
    line(320,240,320+round(l*cos(a-c*da)),240+round(l*sin(a-c*da)));
    setcolor(10);
    {circle(320,150,r);}
    line(320,240,320+round(l*cos(a)),240+round(l*sin(a)));
    inc(r);
    if r=14 then
     r:=3;
    a:=a+da;
  until keypressed;
  closegraph;
end.