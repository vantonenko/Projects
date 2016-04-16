program calc_;
uses crt;
type
  string3=string[3];
var
  expr,b:string;
  code:integer;
  p:byte;
function calc(sign:string3):real;
var
  d:real;
begin
  b:='';
  d:=0;

  while pos(expr[p],sign+')')=0 do
	begin
	  inc(p);
	  case expr[p-1] of
		'0'..'9':begin
					  b:=b+expr[p-1];
					  val(b,d,code);
					end;
			  '+':d:=d+calc('+-');
			  '-':d:=d-calc('+-');
			  '*':d:=d*calc('+-*/');
                          '/':d:=d/calc('+-*/');
	  end;
	end;
  calc:=d;
end;
label m1;
begin
  clrscr;
  repeat
  write('Enter the expression: ');
  readln(expr);
  if expr='' then
    exit;
  p:=0;{tekushaya posiciya v stroke}
  expr:=expr+')';
  writeln('Result: ',calc(''):0:2);
  until false;
end.