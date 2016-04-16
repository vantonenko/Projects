program robot;
uses crt;
var
  n,n1,n2,n3,n0,dr,years,i:longint;
label m1;
begin
  clrscr;
m1:write('Enter the quantity of the robots and years:');
  readln(n0,years);
  n1:=0;
  n2:=0;
  n3:=0;
  for i:=1 to years do
   begin
     n:=n0+n1+n2+n3;
     case n mod 5 of
      0:dr:=n div 5*9;
      1:if n=1 then
          dr:=0
         else
          dr:=(n-6)div 5*9+10;
      2:if n=2 then
          dr:=0
         else
          if n=7 then
            dr:=9
           else
            dr:=(n-12)div 5*9+20;
      3:dr:=(n-3)div 5*9+5;
      4:if n=4 then
          dr:=5
         else
          dr:=(n-9)div 5*9+15;
     end;
     n3:=n2;
     n2:=n1;
     n1:=n0;
     n0:=dr;
   end;
  n:=n0+n1+n2+n3;
  writeln('The quantity of the robots for ',years,' years ago:',n);
  writeln('Press Esc to quit or other key to continue...');
  if readkey<>#27 then
   goto m1;
end.