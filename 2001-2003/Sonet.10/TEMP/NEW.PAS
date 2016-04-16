program new;
uses graph,crt;
var
  gd,gm:integer;
  yy,y1,x,y,adr:word;
  i,b:byte;
procedure moveimage(x1,y1,x2,y2,dx,dy:word);
var
  xx,yy,y,x:word;
  dxx,dyy:integer;
begin
  port[$3ce]:=5;
  port[$3cf]:=1;
  if dx>0 then
    begin
      xx:=x2+1;
      dxx:=-1;
    end
   else
    begin
      xx:=x1-1;
      dxx:=1;
    end;
  if dy>0 then
    begin
      yy:=(y2+1)*80;
      dyy:=-80;
    end
   else
    begin
      yy:=y1-80;
      dyy:=80;
    end;
  for y:=y1 to y2 do
   begin
     yy:=yy+dyy;
     for x:=x1 to x2 do
      begin
        xx:=xx+dxx;
        mem[sega000:yy+80*dy+xx+dx]:=
         mem[sega000:yy+xx];
      end;
   end;
end;
begin
  gd:=vga;
  gm:=vgahi;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  for i:=1 to 20 do
   begin
     setcolor(random(15)+1);
     circle(320,240,i*20);
   end;
  readkey;
  port[$3ce]:=5;
  port[$3cf]:=1;
  yy:=240*80;
  for y:=239 downto 0 do
   begin
     yy:=yy-80;
     for x:=39 downto 0 do
      mem[sega000:yy+80*8+x+1]:=
       mem[sega000:yy+x];
   end;
  {moveimage(1,8,10,80,1,8);}
  readkey;
  closegraph;
end.