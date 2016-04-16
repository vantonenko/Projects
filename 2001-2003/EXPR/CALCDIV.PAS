function calc(sign:string3):longint;
var
  d:longint;
begin
  d:=0;
  b:='';
  while pos(expr[p+1],sign+')')=0 do
   begin
     inc(p);
     case expr[p] of
      '0'..'9':begin
                 b:=b+expr[p];
                 val(b,d,code);
               end;
           '+':d:=d+calc('+-');
           '-':d:=d-calc('+-');
           '*':d:=d*calc('+-*');
     end;
   end;
  calc:=d;
end;
function calcexpr:longint;
begin
  expr:=expr+')';
  p:=0;
  calcexpr:=calc('');
end;