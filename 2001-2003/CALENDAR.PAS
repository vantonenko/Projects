program calendar;
uses crt;
type
  monthtype=record
    numberofdays:byte;
    monthname:string[9];
  end;
var
  month,year,startday,totaldays,numdays,i,n:word;
const
  monthdata:array[1..12]of monthtype=
   ((numberofdays:31;monthname:'������'),
    (numberofdays:28;monthname:'���ࠫ�'),
    (numberofdays:31;monthname:'����'),
    (numberofdays:30;monthname:'��५�'),
    (numberofdays:31;monthname:'���'),
    (numberofdays:30;monthname:'���'),
    (numberofdays:31;monthname:'���'),
    (numberofdays:31;monthname:'������'),
    (numberofdays:30;monthname:'�������'),
    (numberofdays:31;monthname:'������'),
    (numberofdays:30;monthname:'�����'),
    (numberofdays:31;monthname:'�������'));
  dayofweek:array[1..7]of string[2]=
   (('��'),('��'),('��'),('��'),('��'),('��'),('��'));
  leap=2;
  normal=1;
label m1;
begin
m1:writeln;
  write('������ ���(1899-2099):');
  readln(year);
  write('������ ���浪��� ����� �����(1-12):');
  readln(month);
  if (year<1899)or(year>2099)or(month<1)or(month>12) then
   goto m1;
  numdays:=0;
  for i:=1899 to year-1 do
   if ((i mod 4=0)and(i mod 100<>0))or(i mod 400=0) then
     inc(numdays,leap)
    else
     inc(numdays,normal);
  for i:=1 to month-1 do
   inc(numdays,monthdata[i].numberofdays);
  totaldays:=monthdata[month].numberofdays;
  if ((year mod 4=0)and(year mod 100<>0))or(year mod 400=0) then
   if month>2 then
     inc(numdays)
    else
     if month=2 then
      inc(totaldays,1);
  startday:=numdays mod 7;
  clrscr;
  writeln('  ',year,' ���. ',monthdata[month].monthname);
  writeln;
  textcolor(12);
  write(dayofweek[1]:5);
  textcolor(yellow);
  for i:=2 to 7 do
   write(dayofweek[i]:5);
  textcolor(white);
  writeln;
  writeln;
  gotoxy(5*startday+1,4);
  for i:=1 to totaldays do
   begin
     write(i:5);
     if (wherex>32)and(i<>totaldays) then
      writeln;
   end;
  textcolor(7);
  writeln;
  writeln('������ <Enter> ��� �த������� ��� ���� ����� ������� ��� ��室�...');
  if readkey=#13 then
   goto m1;
end.