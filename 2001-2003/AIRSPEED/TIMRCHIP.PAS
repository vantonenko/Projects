program _delay;
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
function readoscelator:longint;
begin
  readoscelator:=((readtimer and $7fff)*$10000)or
  (65535-readtimerchipcount);
end;
procedure delay(ms:word);
const
  k=1193180/1000;
var
  t:longint;
begin
  t:=readoscelator+trunc(ms*k);
  repeat until t<=readoscelator;
end;
var
  t1,t2:longint;
begin
  clrscr;
  writeln('Press any key to continue...');
  readkey;
  writeln('Determing...');
  delay(1000);
  writeln('Done.');
  readln;
end.