program keyb2;
uses crt,dos;
procedure int9;assembler;
asm
  mov al,20h
  out 20h,al
  mov al,20h
  out 0a0h,al
end;
var
  i:longint;
begin
  setintvec($9,@int9);
  for i:=1 to 50 do
   begin
     if keypressed then
      break;
     delay(100);
   end;
end.