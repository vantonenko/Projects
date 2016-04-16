Uses CRT, GrafixX;

Const
  scr : array [1..4] of TPoint = ((X:0;Y:0), (X:319;Y:0), (X:319;Y:239), (X:0;Y:239));
  pat : array [0..7,0..7] of byte =
  (
    (4,0,0,0,0,0,0,0),
    (0,4,0,0,0,0,2,0),
    (0,0,4,0,0,2,0,0),
    (0,0,0,0,2,0,0,0),
    (0,0,0,2,0,0,0,0),
    (0,0,2,0,0,4,0,0),
    (0,2,0,0,0,0,4,0),
    (0,0,0,0,0,0,0,4)
  );

Var
  PB, P : Pointer;
  X, Y, DX, DY, X0, Y0 : Integer;

Procedure Bum;
Begin
  Sound (100); Delay(10); NoSound;
  DX:=(Random(8)+4)*Abs(DX) Div DX;
  DY:=(Random(8)+4)*Abs(DY) Div DY;
End;

Begin
  GetMem (P, ImageSizeX(24,24));
  GetMem (PB, ImageSizeX(24,24));
  InitGraphX;
  Border (Brown);
  CircleX (12, 12, 11, LightBlue, True);
  GetImageX (0, 0, 24, 24, P^);
  FillPolyPatX (4, scr, 8, 8, pat);
  X := 0; Y := 0; DX := 8; DY := 8;
  GetImageX (X, Y, 24, 24, PB^);
  PutTranspImageX (X, Y, P^);
  Randomize;
  Repeat
    X0 := X;
    Y0 := Y;
    Inc (X, DX);
    If X > 320-24 then Begin
      X := 320-24;
      DX := -DX;
      Bum
    End;
    If X < 0 then Begin
      X := 0;
      DX := -DX;
      Bum
    End;
    Inc (Y, DY);
    If Y > 240-24 then Begin
      Y := 240-24;
      DY := -DY;
      Bum
    End;
    If Y < 0 then Begin
      Y := 0;
      DY := -DY;
      Bum
    End;
    Delay (10);
    WaitRetrace;                                { NO FUZZ! }
    PutImageX (X0, Y0, PB^);
    GetImageX (X, Y, 24, 24, PB^);
    PutTranspImageX (X, Y, P^)
  Until KeyPressed;
  While KeyPressed do ReadKey;
  Border (Black);
  CloseGraphX;
  FreeMem (PB, ImageSizeX(24,24));
  FreeMem (P, ImageSizeX(24,24))
End.
