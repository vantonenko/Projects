program loto;
uses crt;
var
  cmn,m,i:extended;
  d,c,mul:extended;
label m1;
begin
  clrscr;
m1:write('������ ���-�� ��ਠ�⮢("0"-��室):');
  readln(cmn);
  if cmn=0 then
   exit;
  write('������ ��饥 ���-�� �ਪ��:');
  readln(m);
  d:=m;
  i:=0;
  c:=cmn;
  mul:=2;
  while (abs(c-d)>0.01)and(d>0) do
   begin
     i:=i+1;
     c:=c/d*mul;
     mul:=mul+1;
     d:=m-i;
   end;
  if d=0 then
    writeln('����� �����४��')
   else
    writeln('���-�� �먣���� �ਪ��:',i+1:0:0);
  goto m1;
end.