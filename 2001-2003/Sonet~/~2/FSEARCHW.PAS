program f;
uses windos,wincrt;
type
  pathstr=string[79];
  searchrec=tsearchrec;
  tmas=array[0..255]of char;
const
  disk:pathstr='';
  searchname:string[12]='';
type
  plist=^tlist;
  tlist=record
    s:searchrec;
    path:pathstr;
    next:plist;
  end;
function oa(s:string):string;
var
  k:integer;
begin
  for k:=1 to length(s) do
   case s[k] of
    'А'..'Я':s[k]:=chr(ord(s[k])-ord('А')+192);
    'а'..'п':s[k]:=chr(ord(s[k])-ord('а')+224);
    'р'..'я':s[k]:=chr(ord(s[k])-ord('р')+240);
   end;
  oa:=s;
end;
procedure fmas(s:string;var mas:tmas);
var
  k:integer;
begin
  for k:=0 to length(s)-1 do
   mas[k]:=s[k+1];
  mas[k+2]:=#0;
end;
var
  t,list,find:plist;
  s:searchrec;
  path:pathstr;
  i:byte;
  col,quant:longint;
  log:text;
  c:char;
  olddisk:pathstr;
  mas:tmas;
  pc:pchar;
procedure push(var list:plist;s:searchrec;path:pathstr);
var
  t:plist;
begin
  if t=find then
   inc(quant);
  new(t);
  t^.path:=path;
  t^.s:=s;
  t^.next:=list;
  list:=t;
end;
procedure pop(var list:plist;var s:searchrec;var path:pathstr);
var
  t:plist;
begin
  s:=list^.s;
  path:=list^.path;
  t:=list;
  list:=list^.next;
  dispose(t);
end;
 function unmask(s,mask:string):boolean;
 var
   first,f:boolean;
   p:byte;
   ss:string;
 begin
   if (length(mask)=1)and(mask[1]<>'*')then
    begin
      unmask:=s=mask;
      exit;
    end;
   if mask[length(mask)]='*'then
    mask:=mask+s[length(s)];
   first:=true;
   while s<>'' do
    begin
      f:=false;
      if first and(mask[1]='*') then
       begin
         delete(mask,1,1);
         first:=false;
       end;
      p:=pos('*',mask);
      if p=0 then
        ss:=mask
       else
        ss:=copy(mask,1,p-1);
      delete(mask,1,p);
      p:=pos(ss,s);
      if (p=0)or((p<>1)and first) then
        break;
      f:=true;
      first:=false;
      delete(s,1,length(ss)+p-1);
    end;
   unmask:=f;
 end;
label m1,m2;
begin
  for i:=1 to 4 do
   writeln;
  writeln('Copyright (c) 2003,jan 11 by Vladislav Antonenko,Ukraine');
  writeln;
  olddisk:='';
m1:find:=nil;
  while keypressed do readkey;
  write(oa('Введите имя директории:'));
  {textcolor(15);}
  readln(disk);
  if disk='' then
   disk:=olddisk;
  olddisk:=disk;
  if disk[length(disk)]='\' then
   disk[0]:=chr(ord(disk[0])-1);
  fmas(disk+'\*.*',mas);
  pc:=mas;
  findfirst(pc,faanyfile,s);
  if disk[1]in ['a'..'z'] then
   disk[1]:=upcase(disk[1]);
  if ((doserror<>0)and(doserror<>2)and(doserror<>18))or(disk='') then
   begin
     writeln(oa('Директория не найдена.'));
     {textcolor(7);}
     writeln;
     goto m2;
   end;
  {textcolor(7);}
  write(oa('Введите имя файла:'));
  {textcolor(15);}
  readln(searchname);
  {textcolor(7);}
  if searchname='' then
   searchname:='*';
  writeln;
  for i:=1 to length(searchname) do
   if searchname[i] in ['a'..'z'] then
    searchname[i]:=upcase(searchname[i]);
  writeln(oa('Идёт поиск...'));
  list:=nil;
  s.name[0]:=#0;
  s.attr:=fadirectory;
  push(list,s,disk);
  col:=0;
  quant:=0;
  while list<>nil do
   begin
     pop(list,s,path);
     inc(col);
     {delline;}
     gotoxy(0,wherey);
     clreol;
     if s.name='' then
       writeln(oa('Текущая директория-'),col,' Корневой каталог')
      else
       writeln(oa('Текущая директория-'),col,' ',s.name);
     gotoxy(wherex,wherey-1);
     fmas(path+'*.*',mas);
     pc:=mas;
     findfirst(pc,faanyfile,s);
     if length(path)>2 then
      begin
        findnext(s);
        findnext(s);
      end;
     while doserror=0 do
      begin
        if s.attr and fadirectory<>0 then
         push(list,s,path+'\'+s.name);
        if unmask(s.name,searchname) then
         begin
           if s.attr and fadirectory=0 then
            for i:=1 to length(s.name) do
             if s.name[i] in ['A'..'Z'] then
              s.name[i]:=chr(ord(s.name[i])+ord('a')-ord('A'));
           push(find,s,path+'\'+s.name);
         end;
        findnext(s);
      end;
   end;
  {delline;}
  gotoxy(0,wherey);
  clreol;
  while keypressed do readkey;
  writeln(oa('Поиск завершён...'));
  {textcolor(15);}
  if find=nil then
    writeln(oa('Файлы не найдены.'))
   else
    begin
      t:=find;
      col:=0;
      while t<>nil do
       begin
         inc(col);
         path:=t^.path;
         t:=t^.next;
         writeln(path);
       end;
      {textcolor(7);}
      write(oa('Количество найденных файлов-'));
      {textcolor(15);}
      writeln(col);
      {textcolor(7);}
      write(oa('Директория -'));
      {textcolor(15);}
      writeln('"',disk,'"');
      {textcolor(7);}
      write(oa('Имя файла-'));
      {textcolor(15);}
      writeln('"',searchname,'"');
    end;
  {textcolor(7);}
  writeln;
  if find<>nil then
   begin
     writeln(oa('Сохранить список найденных файлов в')+' "fsearch.log"(y/n)?');
     repeat
       c:=readkey
     until (upcase(c)='Y')or(upcase(c)='N');
     if upcase(c)='Y' then
      begin
        writeln(oa('Сохраняю...'));
        assign(log,'fsearch.log');
        rewrite(log);
        while find<>nil do
         begin
           pop(find,s,path);
           writeln(log,path);
         end;
        writeln;
        writeln(log,'Quantity of the founded file-',col);
        writeln(log,'The name of the directory -"',disk,'"');
        writeln(log,'The name of the searching file -"',searchname,'"');
        close(log);
      end
     else
      while find<>nil do
       pop(find,s,path);
   end;
m2:writeln(oa('Нажмите Enter для продолжения,Esc-для выхода...'));
  repeat
    c:=readkey;
  until (c=#27)or(c=#13);
  if c=#13 then
   goto m1;
  donewincrt;
end.