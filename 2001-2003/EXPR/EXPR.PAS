{$b-}
program expr_;
uses crt;
const
  pathinp='expr.dat';
  pathout='expr.out';
type
  string3=string[3];
var
  finp,fout:text;
  exprchar,expr0,expr,b,out:string;
  charset:array[chr(0)..chr(255)]of char;
  first:array[1..10]of byte;
  chars:array[1..10]of char;
  x:array[1..10]of byte;
  result:longint;
  code:integer;
  p,count:byte;
  used:set of byte;
  openf:boolean;
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
procedure generation(j:byte);
var
  i:byte;
begin
  if keypressed then
   begin
     if openf then
      begin
        close(fout);
        openf:=false;
        writeln('Operation was interrupted...');
      end;
     exit;
   end;
  if j=count+1 then{найден вариант}
   begin
     expr:=exprchar;
     for i:=1 to length(expr) do
      if expr[i] in ['a'..'z'] then
       expr[i]:=chr(ord('0')+x[ord(expr[i])-ord('a')+1]);
     if calcexpr=result then
      begin
        out[0]:=chr(10);
        for i:=0 to 9 do
         out[i+1]:=chr(ord('0')+i);
        for i:=1 to count do
         out[x[i]+1]:=chars[i];
        writeln(fout,out);
      end;
     exit;
   end;
  for i:=first[j] to 9 do
   if not(i in used) then
    begin
      include(used,i);
      x[j]:=i;
      generation(j+1);
      exclude(used,i);
    end;
end;
procedure init;
var
  i:byte;
  ch:char;
begin
  count:=0;
  exprchar:=expr0;
  fillchar(charset,sizeof(charset),32);
  fillchar(first,count,0);
  for i:=1 to length(expr0) do
   if expr0[i] in ['a'..'z'] then
     begin
       if charset[expr0[i]]=' ' then
         begin
           inc(count);
           chars[count]:=expr0[i];
           ch:=chr(ord('a')+count-1);
           exprchar[i]:=ch;
           charset[expr0[i]]:=ch;
         end
        else
         exprchar[i]:=charset[expr0[i]];
       if ((i=1)or(expr0[i-1] in ['+','-','*']))and
          not((i=length(expr0))or(expr0[i+1] in ['+','-','*'])) then
         first[ord(exprchar[i])-ord('a')+1]:=1
     end
    else
     if expr0[i] in ['0'..'9'] then
      include(used,ord(expr0[i])-ord('0'));
end;
begin
  clrscr;
  assign(finp,pathinp);
  reset(finp);
  readln(finp,expr0);
  read(finp,result);
  close(finp);
  used:=[];
  init;
  assign(fout,pathout);
  rewrite(fout);
  openf:=true;
  fillchar(x,count,0);
  writeln('I''am digiting...');
  generation(1);
  if openf then close(fout);
end.