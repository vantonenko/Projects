Uses CRT, GrafixX, GfxFont;

Var
  I, J : Word;
  K : LongInt;
  P : Pointer;

Begin
  InitGraphX;
  ClearScreenX (Green);
  BoxX (8, 8, 320-16, 240-16, Brown, True);
  LineX (0, 0, 319, 239, White);
  LineX (319, 0, 0, 239, White);
  setfont (@font6x7);
  WriteSX (70, 114, Blue, LightCyan, 'You''re in 320x240x256 now!!!');
  ReadLn;
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
  CircleX (160, 120, 119, LightRed, True);
  GetMem (P, ImageSizeX (320, 200));
  GetImageX (10, 10, 300, 200, P^);
  ReadLn;
  BoxX (10, 10, 300, 200, Black, True);
  ReadLn;
{  PutImageX (10, 10, P^);}
  PutImagePartX (20, 20, P^, 10, 10, 280, 180);
  FreeMem (P, ImageSizeX (320, 200));
  ReadLn;
  For J := 0 to 239 do
    LineHX (0, J, 320, Blue);
  ReadLn;
  For I := 0 to 319 do
    LineVX (I, 0, 240, Green);
  ReadLn;
  For K := 0 to 300000 do
    PutPixelX (Random(320), Random(240), Black);
  CloseGraphX
End.
