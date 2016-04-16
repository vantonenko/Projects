{236-4 skyline.pas}
program skyline;
{$b-}
const
  maxn=5000;
type
  tevents=record
    x:word;{vcluchaet esli h>0,else h<0}
    h:integer;
    x1:word;{vtoroy conets}
  end;
var
  events:array[1..maxn*2]of tevents;
  colrect,nevents,i,j,oldi,min,imin,curh,newh,max:word;
  t:tevents;
  line:longint;
  fdat,fsol:text;
begin
  assign(fdat,'skyline.dat');
  reset(fdat);
  read(fdat,colrect);
  nevents:=0;
  fillchar(events,sizeof(events),0);
  {input}
  for i:=1 to colrect do
   begin
     inc(nevents,2);
     read(fdat,events[nevents-1].x);
     read(fdat,events[nevents].x);
     read(fdat,events[nevents-1].h);
     events[nevents].h:=-events[nevents-1].h;
     events[nevents-1].x1:=events[nevents].x;
   end;
  {sortirovka po "x"}
  close(fdat);
  j:=1;
  while j<nevents do
   begin
     min:=65535;
     imin:=0;
     for i:=j to nevents do
      if events[i].x<min then
       begin
         min:=events[i].x;
         imin:=i;
       end;
     if imin<>0 then
      begin
        {swap items:"j" i "imin"}
        t:=events[j];
        events[j]:=events[imin];
        events[imin]:=t;
        inc(j);
      end;
   end;
  line:=0;
  curh:=0;
  oldi:=0;
  for i:=1 to nevents do
   begin
     if events[i].h>0 then{tochca vcluchayushaya}
      if events[i].h>curh then
       newh:=events[i].h;
     if events[i].h<0 then
      begin
        max:=0;
        for j:=1 to nevents do
         if (events[j].h>0)and(events[i].x>events[j].x)and
            (events[i].x<events[j].x1)and(abs(events[j].h)>max) then
          max:=abs(events[j].h);
        newh:=max;
      end;
     if curh<>newh then
      if i=1 then
        line:=line+abs(integer(newh)-integer(curh))
       else
        begin
          line:=line+abs(integer(newh)-integer(curh));
          line:=line+events[i].x-events[oldi].x;
        end;
     if curh<>newh then
      oldi:=i;
     curh:=newh;
   end;
  assign(fsol,'skyline.sol');
  rewrite(fsol);
  write(fsol,line);
  close(fsol);
end.