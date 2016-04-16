program matrix;
uses graph,crt;
const
  col:array[0..15]of byte=
      (0,1,2,3,4,5,20,7,56,57,58,59,60,61,62,63);
  str:array[0..5]of char='matrix';
var
  gd,gm,i,x:integer;
  c:char;
begin
  initgraph(gd,gm,'c:\programs\bp\bgi');
  for i:=1 to 14 do
   setrgbpalette(col[i],0,i+25,0);
  setrgbpalette(col[15],0,63,0);
  for x:=0 to 63 do
   begin
     c:=str[x mod 6];
     for i:=0 to 59 do
      begin
        setcolor(random(14)+1);
        outtextxy(x*10,i*8,c);
        if keypressed then
         break;
     end;
   end;
  repeat
    x:=random(64)*10;
    c:=str[x mod 6];
    for i:=0 to 59 do
     begin
       setcolor(0);
       outtextxy(x,i*8,#219);
       setcolor(15);
       outtextxy(x,i*8,c);
       delay(30);
       setcolor(0);
       outtextxy(x,i*8,#219);
       setcolor(random(14)+1);
       outtextxy(x,i*8,c);
       if keypressed then
        break;
     end;
  until keypressed;
  closegraph;
end.