program test;
uses graph,crt;
var
  gd,gm,i:integer;
{$F+}
function DetectVGA256:Integer;
begin
end;
{$F-}
begin
  gd:=InstallUserDriver('VGA256',@DetectVGA256);
  InitGraph(gd,gm,'');
  for i:=0 to 255 do
   begin
     setcolor(i);
     line(i,0,i,199);
   end;
  readkey;
  Closegraph;
end.