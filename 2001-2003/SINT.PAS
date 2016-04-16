program sintezator;
uses crt;
const
  colfrec=47;
  minfrec=20;
  maxfrec=7000;
  koeff:extended=0;
  temp=50;
  chars:string[47]='`1234567890-=\qwertyuiop[]asdfghjkl;''zxcvbnm,./';
var
  c:char;
  i,p:integer;
  frec:array[0..colfrec-1]of extended;
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
  clrscr;
  koeff:=exp(1/(colfrec-1)*ln(maxfrec/minfrec));
  frec[0]:=minfrec;
  for i:=1 to colfrec-1 do
   frec[i]:=frec[i-1]*koeff;
  setkeyspeed(0,4);
  repeat
    c:=readkey;
    p:=pos(c,chars);
    if p<>0 then
     begin
       sound(round(frec[p-1]));
       writeln('— αβ®β :',round(frec[p-1]));
       delay(temp);
       nosound;
     end;
    if c=#8 then
     clrscr;
  until c=#27;
end.