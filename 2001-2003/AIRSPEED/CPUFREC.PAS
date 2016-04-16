program _getCPUclock;
uses crt;
var
  readtimer:longint absolute $0:$46c;
function getcpuclock:longint;assembler;
asm
  db 0fh,31h
  mov bx,00fh
  db 66h,0c1h,0e3h,10h
  mov bx,4240h
  db 66h,0f7h,0f3h
  db 66h,8bh,0d8h
  db 66h,0c1h,0e8h,10h
  db 66h,33h,0d2h
  mov dx,ax
  db 66h,8bh,0c3h
end;
function getcpufrec:word;
var
  start,finish,t:longint;
begin
  t:=readtimer+1;
  repeat until t<=readtimer;
  start:=getcpuclock;
  t:=readtimer+18;
  repeat until t<=readtimer;
  finish:=getcpuclock;
  getcpufrec:=finish-start;
end;
var
  frec:word;
begin
  clrscr;
  writeln('Determing...');
  frec:=getcpufrec;
  writeln('CPUfrec:',frec);
  readln
end.