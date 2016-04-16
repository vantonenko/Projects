unit timerman;

interface

procedure initdelay(ms:word);
procedure donedelay;
procedure delay(ms:word);

implementation

uses crt;
var
  readtimer:longint absolute $0:$046c;
function readtimerchipcount:word;
var
  frec:word;
begin
  frec:=port[$40];
  frec:=frec or (port[$40] shl 8);
  readtimerchipcount:=frec;
end;
function readoscelator:extended;
begin
  readoscelator:=((readtimer and $7fff)*$10000)or
  (65535-readtimerchipcount);
end;
var
  t:extended;
const
  k=1193180/1000;
procedure initdelay;
begin
  t:=readoscelator+trunc(ms*k);
end;
procedure donedelay;
begin
  repeat until (t<=readoscelator);
end;
{procedure delay(ms:word);
begin
  t:=readoscelator+trunc(ms*k);
  repeat until (t<=readoscelator);
end;}
procedure delay(ms:Word);assembler;
asm
  mov ax, 1000;
  mul ms;
  mov cx, dx;
  mov dx, ax;
  mov ah, $86;
  int $15;
end;
end.