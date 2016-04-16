program vgadrv;
uses graph,crt,winapi;
type
  pword=^word;
const
  size=61440;
var
  gd,gm:integer;
  flags,nh,yh,offset,adr,i,j,x,y:word;
  handle:array[0..9]of pointer;
  b:byte;
function getptr(x,y:integer):pointer;
begin
  nh:=y div 48;
  yh:=y mod 48;
  offset:=(yh*640+x)shl 1;
  getptr:=ptr(seg(handle[nh]^),ofs(handle[nh]^)+offset);
end;
procedure putpixel(x,y,owner:word;color:word);
begin
  nh:=y div 48;
  yh:=y mod 48;
  offset:=(yh*640+x)shl 1;
  if pword(ptr(seg(handle[nh]^),ofs(handle[nh]^)+offset))^=owner then
   begin
     port[$3ce]:=5;
     port[$3cf]:=2;
     adr:=y shl 6+y shl 4+x div 8;
     port[$3ce]:=8;
     port[$3cf]:=128 shr (x mod 8);
     b:=mem[sega000:adr];
     mem[sega000:adr]:=color;
   end;
end;
begin
  gd:=vga;
  gm:=vgahi;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  setfillstyle(1,1);
  bar(0,0,639,479);
  for i:=0 to 9 do
   handle[i]:=globalallocptr(gmem_fixed+gmem_nodiscard+gmem_zeroinit,size);
  readkey;
  for j:=0 to 179 do
   for i:=0 to 239 do
    pword(getptr(i,j))^:=random(3);
  for y:=0 to 179 do
   for x:=0 to 239 do
    begin
      nh:=y div 48;
      yh:=y mod 48;
      offset:=(yh*640+x)shl 1;
      if pword(ptr(seg(handle[nh]^),ofs(handle[nh]^)+offset))^<>1 then
       begin
         port[$3ce]:=5;
         port[$3cf]:=2;
         adr:=y shl 6+y shl 4+x div 8;
         port[$3ce]:=8;
         port[$3cf]:=128 shr (x mod 8);
         b:=mem[sega000:adr];
         mem[sega000:adr]:=3;
       end;
    end;
  readkey;
  closegraph;
end.