program calc_;
uses crt;
const
  maxextended=1.7e38;
type
  string4=string[4];
var
  expr,ch:string;
  error:integer;
  p:byte;
  r:extended;
function calcexpr(sign:string4):extended;
var
  res:extended;
begin
  res:=0;
  ch:='';
  while pos(expr[p+1],sign+')')=0 do
   begin
     inc(p);
     case expr[p] of
       '0'..'9','.':
         begin
           ch:=ch+expr[p];
           val(ch,res,error);
         end;
       '(':
         begin
           res:=calcexpr('');
           inc(p);
         end;
       '+':res:=res+calcexpr('+-');
       '-':res:=res-calcexpr('+-');
       '*':res:=res*calcexpr('+-*/');
       '/':
         begin
           r:=calcexpr('+-*/');
           if r<>0 then
             res:=res/r
            else
             if res<>0 then
              if res>0 then
                res:=maxextended
               else
                res:=-maxextended;
         end;
       '^':if res<>0 then
            res:=exp(ln(res)*calcexpr(''));
       'p':
         if expr[p+1]='i' then
          begin
            res:=pi;
            inc(p);
          end;
       'c':
         if (expr[p+1]='o')and(expr[p+2]='s') then
          res:=cos(calcexpr(''));
       's':
         if (expr[p+1]='i')and(expr[p+2]='n') then
          res:=sin(calcexpr(''));
     end;
   end;
  calcexpr:=res;
end;
label m1;
begin
  clrscr;
m1:write('Enter the expression:');
  readln(expr);
  if expr='' then
   exit;
  p:=0;
  expr:=expr+')';
  write('Result:');
  r:=calcexpr('');
  if frac(r)=0 then
    writeln(r:0:0)
   else
    begin
      str(r:0:18,ch);
      while ch[length(ch)]='0' do
       delete(ch,length(ch),1);
      writeln(ch);
    end;
  goto m1;
end.