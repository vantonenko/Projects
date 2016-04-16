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