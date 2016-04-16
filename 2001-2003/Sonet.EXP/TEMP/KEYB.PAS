program keyb;
uses crt;
const
  maxfrec=7000;
  minfrec=20;
  colfrec=53-16+1;
var
  c,c1,i:word;
  frec:array[16..53]of extended;
  koeff:extended;
begin
  clrscr;
  koeff:=exp(1/(colfrec-1)*ln(maxfrec/minfrec));
  frec[16]:=minfrec;
  for i:=17 to 53 do
   frec[i]:=frec[i-1]*koeff;
  repeat
    c:=port[$60];
    if (c<=53)and(c>=16) then
     begin
       sound(round(frec[byte(c)]));
       writeln(round(frec[byte(c)]));
     end;
    c1:=c;
    while c1=c do
     begin
       c1:=port[$60];
       if keypressed then
        readkey;
     end;
    if (c<=53)and(c>=16) then
     nosound;
  until c=1;
end.