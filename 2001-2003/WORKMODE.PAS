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
   ((numberofdays:31;monthname:'Январь'),
    (numberofdays:28;monthname:'Февраль'),
    (numberofdays:31;monthname:'Март'),
    (numberofdays:30;monthname:'Апрель'),
    (numberofdays:31;monthname:'Май'),
    (numberofdays:30;monthname:'Июнь'),
    (numberofdays:31;monthname:'Июль'),
    (numberofdays:31;monthname:'Август'),
    (numberofdays:30;monthname:'Сентябрь'),
    (numberofdays:31;monthname:'Октябрь'),
    (numberofdays:30;monthname:'Ноябрь'),
    (numberofdays:31;monthname:'Декабрь'));
  dayofweek:array[1..8]of string[2]=
   (('Д'),('Д'),('В'),('В'),('Н'),('Н'),('В'),('В'));
  leap=366 mod 8;
  normal=365 mod 8;
label m1;
begin
m1:writeln;
  write('Введите год(1899-2099):');
  readln(year);
  write('Введите порядковый номер месяца(1-12):');
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
  startday:=(numdays+3) mod 8;
  clrscr;
  writeln('  ',year,' год. ',monthdata[month].monthname);
  writeln;
  textcolor(yellow);
  for i:=1 to 8 do
   write(dayofweek[i]:5);
  textcolor(white);
  writeln;
  writeln;
  gotoxy(5*startday+1,4);
  for i:=1 to totaldays do
   begin
     write(i:5);
     if (wherex>37)and(i<>totaldays) then
      writeln;
   end;
  textcolor(7);
  writeln;
  writeln('Нажмите <Enter> для продолжения или любую другую клавишу для выхода...');
  if readkey=#13 then
   goto m1;
end.