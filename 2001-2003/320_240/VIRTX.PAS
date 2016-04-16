Uses CRT, GrafixX, GFXFont;

Const
  Width = 64*8;                         { Width = some integer * 8 >= 320 !!! }
  Height = 3*Width div 4;               { Width*Height <= 3 * 320*240 !!! }

Var
  C : Char;

Begin
  If not MousePresent then Begin
    WriteLn ('Microsoft-compatible mouse not found.');
    Exit
  End;
  SetFont (@Font6x7);
  MouseInit;
  InitGraphX;
  ClearAllPagesX (Black);
  Border (Blue);

  MouseXmin := 0;
  MouseYmin := 0;
  MouseXmax := Width-1;
  MouseYmax := Height-1;
  ClipXmin := 0;
  ClipYmin := 0;
  ClipXmax := Width-1;
  ClipYmax := Height-1;
  SetLogicalWidthX (Width div 8);
  XVirtualScreenX := 0;
  XVirtualScreenY := 0;
  XVirtualScreenMode := True;

  BoxX (0, 0, Width, Height, LightCyan, False);
  CircleX (Width div 2, Height div 2, (Height div 2) - 2, Red, True);
  LineX (0, 0, Width-1, Height-1, LightGreen);
  LineX (0, Height-1, Width-1, 0, LightGreen);
  WriteSX (151, 188, Black, White, 'This is a 512x384x256 virtual mode!');
  MouseShow;

  Repeat
    If KeyPressed then C := ReadKey
    Else C := #$FF;
  Until C = #27;
  MouseDone;
  Border (Black);
  CloseGraphX
End.
