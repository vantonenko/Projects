unit long;
{--------}
interface
{--------}
const
  max=255;
type
  tlong=record
    sign:char;
    len:byte;
    number:array[1..maxlen]of byte;
  end;
procedure input(s:string;var a:tlong);
procedure output(var s:string;a:tlong);
function compare(a,b:tlong):shortint;
function compareabs(a,b:tlong):boolean;
procedure summaabs(a,b:tlong;var result:tlong);
procedure minusabs(a,b:tlong;var result:tlong);
procedure suma(operand1,operand2:tlong;var result:tlong);
procedure minus(operand1,operand2;tlong;var result:tlong);
procedure multiplay(a,b:tlong;var res:tlong);
procedure divmod(a,b:tlong;var res,ost:tlong);
{------------}
implementation
{------------}
procedure input;
var
  i,k:byte;
begin
  if(s[1]='-')or(s[1]='+')then
    begin
      a.sign:=s[1];
      a.len:=length(s)-1;
      k:=2;
    end
   else
    begin
      a.sign:='+';
      a.len:=length(s);
      k:=1;
    end;
   for i:=length(s) downto k do
    a.digit[i+max-length(s)]:=ord(s[i])-ord('0');
end;
procedure output;
begin
end;
function compare;
var
  i:byte;
begin
  if (a.sign='-')and(b.sign='+') then
   compare:=-1;
  if (a.sign='+')and(b.sign='-') then
   compare:=1;
  if (a.sign='-')and(b.sign='-') then
   begin
     if a.len<b.len then
      compare:=1;
     if a.len>b.len then
      compare:=-1;
   end;
  if (a.sign='+')and(b.sign='+') then
   begin
     if a.len<b.len then
      compare:=-1;
     if a.len>b.len then
      compare:=1;
   end;
  if (a.sign=b.sign)and(a.len=b.len) then
   begin
     compare:=1;
     i:=max-a.len+1;
     while (a.number[i]=b.number[i])and(i<=max) do
      inc(i);
     if i>max then
       compare:=0
      else
       begin
         if (a.sign='-')and(a.number[i]>b.number) then
          compare:=-1;
         if (a.sign='+')and(a.number[i]<b.number) then
          compare:=-1;
       end;
   end;
end;
function compareabs;
var
  i:byte;
begin
  compareabs:=true;
  if a.len<b.len then
   compareabs:=false;
  if a.len=b.len then
   begin
     i:=max-a.len+1;
     while (a.number[i]=b.number[i])and(i<=max) do
      inc(i);
     if a.number[i]<b.number[i] then
      compareabs:=false;
   end;
end;
procedure summaabs;
var
  i,p,len:byte;
begin
  p:=0;
  if a.len>b.len then
    len:=a.len+1
   else
    len:=b.len+1;
  for i:=max downto max-len do
   begin
     result.number[i]:=(a.number[i]+b.number[i]+p) mod 10;
     p:=(a.number[i]+b.number[i]+p) div 10;
   end;
  i:=1;
  while (result.number[i]=0)and(i<max) do
   inc(i);
  result.len:=max-i+1;
end;
procedure minusabs;
var
  i,z,len:byte;
begin
  z:=0;
  if a.len>b.len then
    len:=a.len
   else
    len:=b.len;
  for i:=max downto max-len do
   begin
     result.number[i]:=a.number[i]-b.number[i]-z;
     if result.number[i]<0 then
       begin
         result.number[i]:=result.number[i]+10;
         z:=1;
       end
      else
       z:=0;
   end;
  i:=1;
  while (result.number[i]=0)and(i<max)do
   inc(i);
  result.len:=max-i+1;
end;
procedure suma;
begin
  if (operand1.sign=operand2.sign) then
    begin
      sumaabs(operand1,operand2,result);
      result.sign:=operand1.sign;
    end
   else
    begin
      if compareabs(operand1,operand2)=true then
        begin
          minusabs(operand1,operand2,result);
          result.sign:=operand1.sign;
        end
       else
        begin
          minusabs(operand2,operand1,result)
          result.sign:=operand2.sign;
        end;
    end;
end;
procedure minus;
begin
  if operand2.sign='-' then
    operand2.sign:='+'
   else
    operand2.sign:='-';
  suma(operand1,operand2,result);
end;
procedure multiplay;
var
  i,j,p,mulcifra:byte;
begin
  for i:=1 to max do
   res.number[i]:=0;
  p:=0;
  for j:=max downto max-b.len+1 do
   begin
     for i:=max downto max-a.len+1 do
      begin
        mulcifra:=res.number[i-p]+a.number[i]*b.number[j];
        res.number[i-p]:=mulcifra mod 10;
        res.number[i-p-1]:=res.number[i-p-1]+mulcifra div 10;
      end;
     p:=p+1;
   end;
  i:=1;
  while (result.number[i]=0)and(i<max) do
   inc(i);
  result.len:=max-i+1;
  if a.sign=b.sign then
    res.sign:='+'
   else
    res.sign:='-'
end;
procedure divmod;
var
  i,p,s:byte;
 procedure sdvig(var a:tlong;k:byte);
 var
   i:byte;
 begin
   for i:=1 to max-k do
    a.number[i]:=a.number[i+k];
   for i:=max-k+1 to max do
    a.nuber[i]:=0;
 end;
 function dlina(a:tlong):byte;
 var
   i:byte;
 begin
   i:=1;
   while (a.number[i]=0)and(i<max) do
    i:=i+1;
   dlina:=max-i+1;
 end;
 function comp0(x:tlong):boolean;
 var
   i:byte;
 begin
   comp0:=true;
   i:=1;
   while (x.number[i]=0)and(i<=max) do
    i:=i+1;
   if i<=max then
    comp0:=false;
 end;
begin
  for i:=1 to max do
   begin
     res.number[i]:=0;
     ost.number[i]:=0;
   end;

end.