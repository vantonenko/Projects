program rimdigit;
uses crt;
var
  s:string;
  m:array[1..255]of word;
  sum:word;
  lastsign:boolean;
  maxi,i:byte;
  c:char;
label m1;
begin
  clrscr;
m1:writeln('Vvedite chislo(rimskoe):');
  readln(s);
  sum:=0;
  maxi:=length(s);
  for i:=1 to maxi do
   begin
    s[i]:=upcase(s[i]);
    case s[i] of
     'I':m[i]:=1;
     'V':m[i]:=5;
     'X':m[i]:=10;
     'L':m[i]:=50;
     'C':m[i]:=100;
     'D':m[i]:=500;
     'M':m[i]:=1000;
    else goto m1;
    end;
   end;
  sum:=m[maxi];
  lastsign:=true;
  for i:=maxi-1 downto 1 do
   begin
     if m[i]>m[i+1] then lastsign:=true;
     if m[i]<m[i+1] then lastsign:=false;
     if lastsign then sum:=sum+m[i]
      else sum:=sum-m[i];
   end;
  writeln(sum);
  writeln('Press Esc to quit or Enter to continue...');
  c:=readkey;
  if c<>#27 then goto m1;
end.