program square;
uses crt;
var
  a,b,c,d,x1,x2:extended;
  ch:char;
begin
  clrscr;
  repeat
    write('Enter A,B,C:');
    readln(a,b,c);
    write('Answer:');
    if (a=0)and(b=0)and(c=0) then
      writeln('X=R')
     else
      if a=0 then
        if b=0 then
          writeln('X=@')
         else
          writeln('X=',-c/b:0:2)
       else
        begin
          d:=b*b-4*a*c;
          if d<0 then
           writeln('X=@');
          if d=0 then
           writeln('X=',-b/2/a:0:2);
          if d>0 then
           begin
             writeln('X1=',(-b+sqrt(d))/2/a:0:2);
             writeln('X2=',(-b-sqrt(d))/2/a:0:2);
           end;
        end;
    writeln;
  until readkey=#27;
end.