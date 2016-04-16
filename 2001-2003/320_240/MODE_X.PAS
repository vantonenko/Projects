Uses CRT, GrafixX, GfxFont;

Var
  R : Word;
  C : Char;
  X, Y : Word;

Begin
  ClrScr;
  MouseInit;
  SetFont (@Font6x7);
  WriteLn ('This demo based on "Mode X" (320x240x256) alow you to:');
  WriteLn ('  1) make up to 3 graphics pages in VGA''s memory (not in conventional)');
  WriteLn ('  2) make your screen full-scrolling in horizontal or vertical direction');
  WriteLn ('  3) have a normal aspect ratio = 1:1, because screen is 320x240 now!'#13#10);
  WriteLn ('In 1-st part of demo you can change visible pages by pressing <1>,<2>,<3>.');
  WriteLn ('End of part - <Enter> key.'#13#10'Press <Enter> to continue...');
  ReadLn;
  InitGraphX;
  ClearAllPagesX (0);
  SetActivePageX (0); ClearScreenX (LightRed);
  WriteSX (8, 8, 15, 15, '1-st page');
  BoxX (100, 100, 100, 50, Blue, True);
  SetActivePageX (1); ClearScreenX (LightGreen);
  WriteSX (8, 8, 0, 0, '2-nd page');
  For R := 1 to 119 do
    CircleX (160, 120, R, Random(256), False);
  SetActivePageX (2); ClearScreenX (LightBlue);
  WriteSX (8, 8, 15, 15, '3-rd page');
  LineX (16, 16, 304, 224, Yellow);
  SetActivePageX (0); MouseShow;
  Repeat
    If KeyPressed then C := ReadKey
    Else C := #$FF;
    Case C of
      '1' : Begin MouseHide; SetVisiblePageX (0); SetActivePageX (0); MouseShow End;
      '2' : Begin MouseHide; SetVisiblePageX (1); SetActivePageX (1); MouseShow End;
      '3' : Begin MouseHide; SetVisiblePageX (2); SetActivePageX (2); MouseShow End;
     End
  Until C = #13;
  MouseHide;
  CloseGraphX;


  WriteLn ('In 2-nd part of demo you can scroll horizontal logical screen by'#13#10+
           'pressing <1> & <2>. Logical screen equals 3 horizontal screens.');
  WriteLn ('End of part - <Enter> key.'#13#10'Press <Enter> to continue...');
  ReadLn;
  InitGraphX;
  ClearAllPagesX (0);
  SetLogicalWidthX (40*3);                      { 3 horizontal screens }
  BoxX (0, 0, 320, 240, LightRed, True);
  BoxX (320, 0, 320, 240, LightGreen, True);
  BoxX (640, 0, 320, 240, LightBlue, True);
  For R := 1 to 119 do
    CircleX (320+160, 120, R, Random(256), False);
  WriteSX (8, 8, 15, 15, 'left part of logical screen');
  WriteSX (320+8, 8, 0, 15, 'middle part of logical screen');
  WriteSX (640+8, 8, 15, 15, 'right part of logical screen');
  MouseXmin := 0; MouseXmax := 3*320-1;
  MouseYmin := 0; MouseYmax := 239;
  ClipXmin := 0; ClipXmax := 3*320-1;
  ClipYmin := 0; ClipYmax := 239;
  MouseX := 160; MouseY := 120;
  MouseShow;
  Repeat
    If KeyPressed then C := ReadKey
    Else C := #$FF;
    Case C of
      '1' : If XVisibleOffset < 320/4 * 2 then SetVisibleOffsetX (XVisibleOffset+1);
      '2' : If XVisibleOffset > 0 then SetVisibleOffsetX (XVisibleOffset-1);
     End
  Until C = #13;
  MouseHide;
  CloseGraphX;


  WriteLn ('In 3-rd part of demo you can scroll vertical logical screen by'#13#10+
           'pressing <3> & <4>. Logical screen equals 3 vertical screens.');
  WriteLn ('End of part - <Enter> key.'#13#10'Press <Enter> to continue...');
  ReadLn;
  InitGraphX;
  ClearAllPagesX (0);
  SetLogicalWidthX (40);                        { 3 vertical screens }
  BoxX (0, 0, 320, 240, LightRed, True);
  BoxX (0, 240, 320, 240, LightGreen, True);
  BoxX (0, 480, 320, 240, LightBlue, True);
  For R := 1 to 119 do
    CircleX (160, 120+240, R, Random(256), False);
  WriteSX (8, 8, 15, 15, 'top part of logical screen');
  WriteSX (8, 240+8, 0, 15, 'middle part of logical screen');
  WriteSX (8, 480+8, 15, 15, 'bottom part of logical screen');
  MouseXmin := 0; MouseXmax := 319;
  MouseYmin := 0; MouseYmax := 3*240-1;
  ClipXmin := 0; ClipXmax := 319;
  ClipYmin := 0; ClipYmax := 3*240-1;
  MouseX := 160; MouseY := 120;
  MouseShow;
  Repeat
    If KeyPressed then C := ReadKey
    Else C := #$FF;
    Case C of
      '4' : If XVisibleOffset < 320/4*240 * 2 then SetVisibleOffsetX (XVisibleOffset+2*40);
      '3' : If XVisibleOffset > 0 then SetVisibleOffsetX (XVisibleOffset-2*40);
     End
  Until C = #13;
  MouseHide;
  CloseGraphX;
  MouseDone
End.
