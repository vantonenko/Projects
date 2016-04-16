program pix;
uses crt,graph;
var
  gd,gm,i,j:integer;
  adr:word;
  b:byte;
label m;
begin
  gd:=0;
  initgraph(gd,gm,'c:\programs\bp\bgi');
m:cleardevice;
  {setfillstyle(1,3);
  bar(0,0,639,479);
  readkey;
  cleardevice;}
  port[$3ce]:=5;
  port[$3cf]:=2;
  port[$3ce]:=8;
  port[$3cf]:=255;
  asm
    mov ax,segA000
    mov es,ax
    mov cx,480
    mov di,0
 @2:mov dx,cx
    mov cx,80
 @1:mov ax,3
    mov es:[di],ax
    inc di
    loop @1
    mov cx,dx
    loop @2
  end;
  if readkey=#13 then
   goto m;
  closegraph;
end.