program fersi;
uses crt;
const
  n=8;
var
  usedv:array[1..n]of boolean;
  used1:array[2..n+n]of boolean;
  used2:array[1-n..n-1]of boolean;
  quant:longint;
  x:array[1..n]of byte;
  k:byte;
procedure generation(j:byte);
var
  i:byte;
begin
  if j=n+1 then
   begin
     inc(quant);
     gotoxy(1,3);
     for i:=1 to n do
      begin
        for k:=1 to n do
         if k=x[i] then
           begin
             textbackground(7);
             textcolor(12);
             write(chr(2));
           end
          else
           begin
             textbackground(7);
             textcolor(15);
             write(chr(1));
           end;
        writeln;
      end;
     textbackground(0);
     textcolor(15);
     writeln('Номер варианта:',quant);
     if readkey=#27 then
      halt;
     exit;
   end;
  for i:=1 to n do
   if usedv[i] and used1[j+i] and used2[j-i] then
    begin
      x[j]:=i;
      usedv[i]:=false;
      used1[j+i]:=false;
      used2[j-i]:=false;
      generation(j+1);
      usedv[i]:=true;
      used1[j+i]:=true;
      used2[j-i]:=true;
    end;
end;
label m1;
begin
m1:clrscr;
  fillchar(usedv,sizeof(usedv),true);
  fillchar(used1,sizeof(used1),true);
  fillchar(used2,sizeof(used2),true);
  quant:=0;
  generation(1);
  writeln('Количество расстановок:',quant);
  textbackground(0);
  writeln('Vsyo!');
  if readkey=#13 then
   goto m1;
end.