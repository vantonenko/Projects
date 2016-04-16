program klava;
uses crt,dos;
const
  f:boolean=false;
var
  p:pointer;
  c:char;
procedure int9;
begin
  port[$20]:=$20;
end;
begin
  getintvec(9,p);
  setintvec(9,@int9);
  c:=readkey;
end.