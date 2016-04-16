program msk;
uses crt;
var
  s,mask:string;
 function unmask(s,mask:string):boolean;
 var
   first,f:boolean;
   p:byte;
   ss:string;
 begin
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
label m1;
begin
m1:readln(s);
  readln(mask);
  writeln(unmask(s,mask));
  if readkey<>#27 then
   goto m1;
end.