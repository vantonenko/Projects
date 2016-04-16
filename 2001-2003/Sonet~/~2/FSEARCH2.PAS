program f;
uses dos,crt;
const
  disk:pathstr='';
  searchname:string[12]='';
type
  ppathstr=^pathstr;
  string12=string[12];
  plist=^tlist;
  tlist=record
    s:searchrec;
    path:ppathstr;
    next:plist;
  end;
var
  t,list,find:plist;
  s:searchrec;
  path:pathstr;
  i:byte;
  col:longint;
  log:text;
  c:char;
  olddisk:pathstr;
  curpath:ppathstr;
  name:string12;
procedure push(var list:plist;s:searchrec;path:pathstr;name:string12);
var
  t:plist;
begin
  new(t);
  if path=curpath^ then
    t^.path:=curpath
   else
    begin
      new(t^.path);
      t^.path^:=path;
      curpath:=t^.path;
    end;
  t^.s:=s;
  t^.next:=list;
  list:=t;
end;
procedure pop(var list:plist;var s:searchrec;var path:pathstr;var name:string12);
var
  t:plist;
begin
  s:=list^.s;
  path:=list^.path^;
  t:=list;
  list:=list^.next;
  name:=s.name;
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
  write('Enter the name of the directory:');
  textcolor(15);
  readln(disk);
  if disk='' then
   disk:=olddisk;
  olddisk:=disk;
  if disk[length(disk)]='\' then
   disk[0]:=chr(ord(disk[0])-1);
  findfirst(disk+'\*.*',anyfile,s);
  if disk[1]in ['a'..'z'] then
   disk[1]:=upcase(disk[1]);
  if ((doserror<>0)and(doserror<>2)and(doserror<>18))or(disk='') then
   begin
     writeln('Invalid directory.');
     textcolor(7);
     writeln;
     goto m2;
   end;
  textcolor(7);
  write('Enter the name of the file:');
  textcolor(15);
  readln(searchname);
  textcolor(7);
  if searchname='' then
   searchname:='*';
  writeln;
  for i:=1 to length(searchname) do
   if searchname[i] in ['a'..'z'] then
    searchname[i]:=upcase(searchname[i]);
  writeln('Searching...');
  list:=nil;
  s.name:='';
  s.attr:=directory;
  push(list,s,disk,'');
  col:=0;
  new(curpath);
  curpath^:='';
  while list<>nil do
   begin
     pop(list,s,path,name);
     inc(col);
     path:=path+name;
     delline;
     writeln('Directory-',col,' ',path);
     gotoxy(wherex,wherey-1);
     findfirst(path+'\*.*',anyfile,s);
     if length(path)>2 then
      begin
        findnext(s);
        findnext(s);
      end;
     while doserror=0 do
      begin
        if s.attr and directory<>0 then
         push(list,s,path,s.name);
        if unmask(s.name,searchname) then
         begin
           if s.attr and directory=0 then
            for i:=1 to length(s.name) do
             if s.name[i] in ['A'..'Z'] then
              s.name[i]:=chr(ord(s.name[i])+ord('a')-ord('A'));
           push(find,s,path,s.name);
         end;
        findnext(s);
      end;
   end;
  delline;
  while keypressed do readkey;
  writeln('Done...');
  textcolor(15);
  if find=nil then
    writeln('File not found.')
   else
    begin
      t:=find;
      col:=0;
      while t<>nil do
       begin
         inc(col);
         path:=t^.path^;
         t:=t^.next;
         writeln(path);
       end;
      textcolor(7);
      write('Quantity of the founded file-');
      textcolor(15);
      writeln(col);
      textcolor(7);
      write('The name of the directory -');
      textcolor(15);
      writeln('"',disk,'"');
      textcolor(7);
      write('The name of the searching file -');
      textcolor(15);
      writeln('"',searchname,'"');
    end;
  textcolor(7);
  writeln;
  if find<>nil then
   begin
     writeln('Do you want to save this list to the file "fsearch.log"(y/n)');
     repeat
       c:=readkey
     until (upcase(c)='Y')or(upcase(c)='N');
     if upcase(c)='Y' then
      begin
        writeln('Saveing...');
        assign(log,'fsearch.log');
        rewrite(log);
        while find<>nil do
         begin
           pop(find,s,path,name);
           writeln(log,path+'\'+name);
         end;
        writeln;
        writeln(log,'Quantity of the founded file-',col);
        writeln(log,'The name of the directory -"',disk,'"');
        writeln(log,'The name of the searching file -"',searchname,'"');
        close(log);
      end
     else
      while find<>nil do
       pop(find,s,path,name);
   end;
m2:writeln('Press Esc to quit or Enter to continue...');
  repeat
    c:=readkey;
  until (c=#27)or(c=#13);
  if c=#13 then
   goto m1;
end.