program sysdown;
uses crt,graph;
var
  sh:word;
  gd,gm:integer;
begin
  gd:=0;
  initgraph(gd,gm,'c:\programs\bp\bgi');
  repeat
    sh:=random(480*80);
    port[$3ce]:=5;
    port[$3cf]:=random(16);
    port[$3ce]:=8;
    port[$3cf]:=128 shr random(9);
    {gm:=mem[$a000:sh];}
    mem[$a000:sh]:=random(256);
  until keypressed;
  closegraph;
end.