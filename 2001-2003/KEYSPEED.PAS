program setkeybspeed;
procedure setkeyspeed(del,rate:byte);assembler;
asm
  mov ax,0305h
  mov bh,del
  and bh,3
  mov bl,rate
  and bl,1fh
  int 16h
end;
begin
  setkeyspeed(0,0);
end.