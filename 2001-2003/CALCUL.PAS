procedure Poliz(var a: string);  {��ॢ���� ��ࠦ���� � "�������" ������}
type
  chars=string[1];            {����� ���ᯥ�� ����஥ �������⭮�}
var
  b: string;                   {���᫥��� ��ࠦ����}
  c,d,e: array[0..20] of chars;   {20 - �� ����. �᫮ ��������� ᪮���}
  i,m: byte;
begin
  b:='';
  m:=0;
  c[m]:='';
  d[m]:='';
  e[m]:='';
  for i:=1 to length(a) do
   case a[i] of
     'a'..'z':b:=b+a[i];
     '+','-':begin
               b:=b+d[m]+c[m]+e[m];
               c[m]:='';
               d[m]:='';
               e[m]:=a[i]
             end;
     '*','/':begin
               b:=b+d[m]+c[m];
               c[m]:=a[i];
               d[m]:=''
             end;
         '^':begin
               b:=b+d[m];
               d[m]:=a[i]
             end;
         '(':begin
               m:=m+1;
               c[m]:='';
               d[m]:='';
               e[m]:=''
             end;
         ')':begin
               b:=b+d[m]+c[m]+e[m];
               m:=m-1
             end
   end;
  a:=b+d[m]+c[m]+e[m]
end;
var
  s:string;
begin
  readln(s);
  poliz(s);
  writeln(s);
  readln;
end.
