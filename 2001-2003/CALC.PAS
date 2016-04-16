program calc_;
uses crt;
type
  string5=string[5];
const
  cmaxreal=1.7e+38;
  ks:array[1..3]of string5=('','+-','+-*/');
var
  a,b:string;
  c:byte;
  p:byte;
  code:integer;
  d1:real;
function maxreal(a:real):real;
begin
  if a=0 then
    maxreal:=0
   else
    if a>0 then
      maxreal:=cmaxreal
     else
      maxreal:=-cmaxreal;
end;
function calc(is:byte):real;
var
  d:real;
  k:string5;
begin
  k:=ks[is];
  b:='';
  d:=0;
  p:=pos(a[c+1],k+')');
  while (p=0)and not keypressed do
   begin
     inc(c);
     case a[c] of
       '0'..'9','.':begin
                      b:=b+a[c];
                      val(b,d,code);
                    end;
                '+':d:=d+calc(2);
                '-':d:=d-calc(2);
                '*':d:=d*calc(3);
                '/':begin
                      d1:=calc(3);
                      if d1<>0 then
                        d:=d/d1
                       else
                        d:=maxreal(d);
                    end;
                '(':begin
                      d:=calc(1);
                      inc(c);
                    end;
                '^':if d<>0 then
                     d:=exp(ln(d)*calc(1));
                'c':if a[c+1]+a[c+2]='os' then
                     begin
                       inc(c,2);
                       d:=cos(calc(1));
                     end;
                's':if a[c+1]+a[c+2]='in' then
                     begin
                       inc(c,2);
                       d:=sin(calc(1));
                     end;
                't':if a[c+1]='g' then
                     begin
                       inc(c);
                       d1:=calc(1);
                       if cos(d1)=0 then
                         d:=maxreal(sin(d1))
                        else
                         d:=sin(d1)/cos(d1);
                     end;
                'p':if a[c+1]='i' then
                     begin
                       inc(p);
                       d:=pi;
                     end;
     end;
     p:=pos(a[c+1],k+')');
   end;
  calc:=d;
end;
label m1;
begin
  clrscr;
m1:write('Enter the expression:');
  readln(a);
  a:=a+')';
  c:=0;
  writeln('Result:',calc(1):0:20);
  writeln('Press Esc to quit or other key to continue...');
  if readkey<>#27 then
   goto m1;
end.