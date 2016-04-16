program test;
uses graph,crt;
const
  text:string='ABCDIFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  {textkoeffx=10;}
  textkoeffy=3;
var
  gd,gm:integer;
  s1,s2:char;
  font,size,x1,y1,x2,y2:integer;
  c:char;
  back,color:integer;
  power:byte;
  r,g,b,x50,y50:integer;
  fl:boolean;
function f(i:integer):integer;
begin
  f:=i;
  if i<0 then
   f:=0;
  if i>63 then
   f:=63;
end;
begin
  gd:=vga;
  gm:=vgahi;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  color:=2;
  back:=1;
  setrgbpalette(color,47,49,47);
  setrgbpalette(back,0,38,38);
  setfillstyle(1,back);
  bar(0,0,getmaxx,getmaxy);
  r:=0;
  g:=0;
  b:=42;
  x50:=30;
  y50:=30;
  settextjustify(lefttext,toptext);
  font:=2;
  size:=5;
  fl:=true;
  setfillstyle(1,3);
  bar(x50-25,y50-25,x50+100,y50-10);
  repeat
    setrgbpalette(3,r,g,b);
    settextstyle(font,0,size);
    s1:=text[1];
    s2:=text[length(text)];
    if textwidth(s1)>textwidth(s2) then
     s2:=s1;
    if textwidth(s2)>textwidth(s1) then
     s1:=s2;
    setfillstyle(1,color);
    x1:=x50;
    y1:=y50;
    x2:=x50+textwidth(s1+text+s2)+3;
    y2:=y50+round((1+1/textkoeffy)*textheight(text))+3;
    bar(x50-25,y50-10,x2+25,y2+10);
    bar(x50,y50,x2,y2);
    setcolor(0);
    if fl then
      outtextxy(x1+textwidth(s1)+2,y1+1,text)
     else
      outtextxy(x1+textwidth(s1)+3,y1+2,text);
    rectangle(x1,y1,x2,y2);
    if fl then
      setcolor(8)
     else
      setcolor(15);
    line(x2-1,y1+2,x2-1,y2-1);
    line(x1+2,y2-1,x2-2,y2-1);
    if fl then
      setcolor(15)
     else
      setcolor(8);
    line(x1+1,y1+1,x2-2,y1+1);
    line(x1+1,y1+1,x1+1,y2-2);
    c:=readkey;
    if c=#0 then
     case readkey of
      #72:inc(size);
      #80:dec(size);
      #77:inc(font);
      #75:dec(font);
      #71:inc(power);
      #79:dec(power);
     end;
    case c of
     'q':inc(r);
     'a':dec(r);
     'w':inc(g);
     's':dec(g);
     'e':inc(b);
     'd':dec(b);
    end;
    r:=f(r);
    g:=f(g);
    b:=f(b);
    if c=#13 then
     fl:=not fl;
    if power<0 then
     power:=0;
    if power>63 then
     power:=63;
    if size<1 then
     size:=1;
    if size>10 then
     size:=10;
    if font<1 then
     font:=1;
    if font>9 then
     font:=9;
    setfillstyle(1,back);
    bar(x1-25,y1-10,x2+25,y2+10);
  until c=#27;
  closegraph;
end.