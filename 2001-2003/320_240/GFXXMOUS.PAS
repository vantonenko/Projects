uses crt, grafixx, gfxfont;

const
  mouseimage2 : array [1..4+256] of byte = (16,0,16,0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0, 15,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0, 15,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0, 15,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0, 15,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0, 15, 15, 15, 15,  0,  0,  0, 15, 15, 15, 15,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0, 15,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0, 15,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0, 15,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0, 15,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0);

var
  c : char;
  i, j : word;
  s : string;

begin
  if not mousepresent then begin
    writeln ('Microsoft-compatible mouse not found.');
    exit
  end;
  setfont (@font6x7);
  initgraphx;
  border (red);
  mouseinit;
  ClearScreenX (LightGray);
  For J := 0 to 239 do Begin
    LineHX (0, J, 320, Blue);
    Inc (J, 3);
    If J >= 239 then Break
  End;
  For I := 0 to 319 do Begin
    LineVX (I, 0, 240, Blue);
    Inc (I, 3);
    If I >= 319 then Break
  End;
  move(mouseimage2,mouseimage,4+256);       { this sets a }
  mousexhot := 7; mouseyhot := 7;     { new graph pointer }
  mouseshow;
  repeat
    if keypressed then c := readkey
    else c := #$ff;
    case upcase(c) of
      'H' : mousehide;
      'S' : mouseshow;
    end;
    if mousebuttons and 1 = 1 then border (blue);       { left key }
    if mousebuttons and 2 = 2 then border (green);      { right key }
    str (mousex:3, s);
    writesx (140, 80, lightgray, black, s);
    str (mousey:3, s);
    writesx (140+18, 80, lightgray, black, ':'+s);
  until c=#27;
  mousedone;
  border (black);
  closegraphx;
end.
