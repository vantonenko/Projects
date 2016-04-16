program konik;
uses crt;
const
  k=20;
  n=k*2+1;
var
  m:array[1..n,1..n]of byte;
  quant,npath:longint;
procedure gen(i,j,l:byte);
begin
  if (i>0)and(i<n+1)and(j>0)and(j<n+1) then
   if l<k then
     begin
       gen(i-1,j,l+1);
       gen(i,j-1,l+1);
       gen(i+1,j,l+1);
       gen(i,j+1,l+1);
     end
    else
     begin
       inc(npath);
       if m[i,j]=0 then
        begin
          m[i,j]:=1;
          inc(quant);
        end;
     end;
end;
begin
  clrscr;
  writeln('I''am digit...');
  fillchar(m,sizeof(m),0);
  quant:=0;
  gen(k+1,k+1,1);
  writeln('Answer:',quant);
  writeln('Npath:',npath);
  readln;
end.