{
ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
³                             GRAPHICS-SHARP                                ³
³ ¨¡«¨®â¥ª  ¤«ï à ¡®âë á £à ä¨ª®© ¢ à¥¦¨¬ å VGA ¨§ ¯à®£à ¬¬ ­  TPascal 7.0 ³
³                      Writed and tested By VanDamM                         ³
³                            ShareWare Release                              ³
ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
}
{F+}
Unit G_SHARP;
Interface
Const

 Title = '****** Graphics-Sharp. Writed and tested By VanDamM. 1997 ******';

 LowVga256   = $13; {        ‘â ­¤ àâ­ë© à¥¦¨¬ VGA 320*200 256 æ¢¥â®¢
                                                  ( 1 ¢¨¤¥®áâà ­¨æ  ) }
 ExtVga256   = $14; { ¥¤®ªã¬¥­â¨à®¢ ­ë© à¥¦¨¬ VGA 320*400 256 æ¢¥â®¢
                                                  ( 2 ¢¨¤¥®áâà ­¨æë ) }
 HiVga256    = $15; { ¥¤®ªã¬¥­â¨à®¢ ­ë© à¥¦¨¬ VGA 360*480 256 æ¢¥â®¢
                                                  ( 1 ¢¨¤¥®áâà ­¨æ  ) }
 XModeVga256 = $16; { ¥¤®ªã¬¥­â¨à®¢ ­ë© à¥¦¨¬ VGA 320*240 256 æ¢¥â®¢
                                                  ( 3 ¢¨¤¥®áâà ­¨æë ) }
 CrossVga256 = $17; { ¥¤®ªã¬¥­â¨à®¢ ­ë© à¥¦¨¬ VGA 320*200 256 æ¢¥â®¢
                                                  ( 4 ¢¨¤¥®áâà ­¨æë ) }
Type
 RGBColor = record
             R : byte;
             G : byte;
             B : byte;
            end;

Var
 VideoMode    : byte;
 PageBase     : Word;
 BytesPerLine : Word;
 PaletteTmp   : array[0..255] of RGBColor;
 Palette4User : array[0..255] of RGBColor;

Procedure InitStdVga256;

Procedure InitExtVga256;

Procedure InitXModeVga256;

Procedure InitCrossVga256;

Procedure InitHiVga256;

Procedure CloseGraph;

Procedure FillScreen(ColorS: byte);

Procedure PutPixel(X, Y: Integer; Pixel: Byte);

Function  GetPixel(X, Y: Integer) : Byte;

Procedure SetVisualPage(Page : Word);

Procedure SetActivePage(Page : Word);

Procedure Wait4Sync;

Procedure SetUserPalette(Var P);

Procedure SetUserColor(Color: Word; R, G, B: Byte);

Procedure PaletteSlowOn;

Procedure PaletteSlowOff;

Procedure GetRealPalette; { ®ç¥¬ã â® ®ç¥­ì ¬¥¤«¥­­®, BIOS ¯ àâ ç¨â }

Procedure SetBorderColor(BColor : byte);

Procedure PaletteRightRoll(CBegin, CEnd: byte);

Procedure PaletteLeftRoll(CBegin, CEnd: byte);

Implementation

Procedure PaletteLeftRoll(CBegin, CEnd: byte);
Var
  C : RGBColor;
  i : byte;
 Begin
  C:=Palette4User[CBegin];
   For i:=CBegin to CEnd-1 do
    begin
     Palette4User[i]:=Palette4User[i+1];
    end;
  Palette4User[CEnd]:=C;
 End;

Procedure PaletteRightRoll(CBegin, CEnd: byte);
Var
  C : RGBColor;
  i : byte;
 Begin
  C:=Palette4User[CEnd];
   For i:=CEnd downto CBegin+1 do
    begin
     Palette4User[i]:=Palette4User[i-1];
    end;
  Palette4User[CBegin]:=C;
 End;

Procedure SetBorderColor(BColor : byte); Assembler;
 Asm
  mov ah, 10h
  mov al, 01h
  mov bh, BColor
  int 10h
 End;

Procedure GetRealPalette;
Var i : word;
    C : RGBColor;
 Begin
  For i:=0 to 255 do
   Begin
    asm
     mov ah, 10h
     mov al, 15h
     mov bx, i
     int 10h
     mov C.R, dh
     mov C.G, ch
     mov C.B, cl
    end;
     Palette4User[i]:=C;
   End;
 End;

Procedure PaletteSlowOff;
Const
  ZeroTime : LongInt = 0;
Var
  i, j     : Byte;
  Time     : LongInt absolute $0040:$006C;
Begin
  For j:=64 downto 1 do begin
    For i:=0 to 255 do
      With PaletteTmp[i] do begin
        R := Palette4User[i].R * j div 64;
        G := Palette4User[i].G * j div 64;
        B := Palette4User[i].B * j div 64;
      end;
    Repeat Until Time - ZeroTime > 0;
    ZeroTime := Time;
    SetUserPalette (PaletteTmp);
  end;
End;

Procedure PaletteSlowOn;
Const
  ZeroTime : LongInt = 0;
Var
  i, j     : Byte;
  Time     : LongInt absolute $0040:$006C;

Begin
  For j:=1 to 64 do begin
    For i:=0 to 255 do
      With PaletteTmp[i] do begin
        R := Palette4User[i].R * j div 64;
        G := Palette4User[i].G * j div 64;
        B := Palette4User[i].B * j div 64;
      end;
    Repeat Until Time - ZeroTime > 0;
    ZeroTime := Time;
    SetUserPalette (PaletteTmp);
  end;
End;

Procedure Wait4Sync; assembler;
Asm
  mov  dx, 3DAh
@@Wait:
  in   al, dx
  test al, 08h
  jz @@Wait
End;

Procedure SetUserColor(Color: Word; R, G, B: Byte); assembler;
Asm
  mov  ax, 1010h
  mov  bx, Color
  mov  dh, R
  mov  ch, G
  mov  cl, B
  int  10h
End;

Procedure SetUserPalette(Var P); assembler;
 Asm
   mov   dx, 3C8h
   mov   al, 0
   out   dx, al
   push  ds
   lds   si, P
   mov   bx, 2
 @@Nxt:
   cli
   mov   dx, 3DAh
 @@Wait2:
   in    al, dx
   test  al, 08h
   jz    @@Wait2
   mov   cx, 128*3
   mov   dx, 3C9h
 @@PalLoop:
   lodsb
   out   dx, al
   loop  @@PalLoop
   dec   bx
   cmp   bx, 0
   jne   @@Nxt
   sti
   pop   ds
 End;

Procedure InitStdVga256;
 Begin
  asm
   mov ah, 00
   mov al, 13h
   int 10h
  end;
  VideoMode:= LowVga256;
  PageBase := $0a000;
 End;

Procedure InitExtVga256;
 Begin
  asm
   mov ah, 00
   mov al, 13h
   int 10h

   mov dx, 3c4h
   mov al, 4
   out dx, al
   inc dx
   in al, dx
   and al, not 08h
   or al, 04h
   out dx, al
   mov dx, 3ceh
   mov al, 5
   out dx, al
   inc dx
   in al, dx
   and al, not 10h
   out dx, al
   dec dx
   mov al, 6
   out dx, al
   inc dx
   in al, dx
   and al, not 02h
   out dx, al
   mov dx, 3c4h
   mov ax, (0fh shl 8) + 2
   out dx, ax
   mov ax, 0a000h
   mov es, ax
   sub di, di
   mov ax, di
   mov cx, 8000h
   cld
   rep stosw

   mov dx, 3d4h
   mov al, 9
   out dx, al
   inc dx
   in al, dx
   and al, not 1fh
   out dx, al
   dec dx

   mov al, 14h
   out dx, al
   inc dx
   in al, dx
   and al, not 40h
   out dx, al
   dec dx
   mov al, 17h
   out dx, al
   inc dx
   in al, dx
   or al, 40h

   out dx, al
  end;
  VideoMode:= ExtVga256;
  PageBase := $0a000;
  BytesPerLine:=80;
 End;

Procedure WriteReg( Base, Reg, Value : integer);
   Begin
    Port[Base]:=Reg;
    Port[Base+1]:=Value;
   End;

Function ReadReg( Base, Reg : integer) : Byte;
   Begin
    Port[Base]:=Reg;
    ReadReg:=Port[Base+1];
   End;

Procedure InitCrossVga256;
 Begin
  asm
   mov ah, 00
   mov al, 13h
   int 10h
  end;
  WriteReg($3c4, 4, 6);
  WriteReg($3d4, $17, $e3);
  WriteReg($3d4, $14, 0);
  asm
   mov ax, 0a000h
   mov es, ax
   sub di, di
   sub ax, ax
   mov cx, 8000h
   rep stosw
  end;
  VideoMode:= CrossVga256;
  PageBase := $0a000;
  BytesPerLine:=80;
 End;

Procedure InitHiVga256;
 Const
  CRTCTable : Array[0..16] of Word =
                             ( $6b00, $5901, $5a02, $8e03, $5e04,
                               $8a05, $0d06, $3e07, $4009, $ea10, $ac11,
                               $df12, $2d13, $0014, $e715, $0616, $e317 );
 Var
  h : byte;
 Begin
  asm
   mov ah, 00
   mov al, 13h
   int 10h
  end;
  WriteReg($3c4, 4, 6);
  WriteReg($3d4, $17, $e3);
  WriteReg($3d4, $14, 0);
  WriteReg($3c4, 0, 1);
  Port[$3c2]:=$e7;
  WriteReg($3c4, 0, 3);
  WriteReg($3d4, $11, ReadReg($3d4, $11) And $7f);
  For h:=0 to 16 do PortW[$3d4]:=CRTCTable[h];
  WriteReg($3c4, 2, $0f);
  asm
   mov ax, 0a000h
   mov es, ax
   sub di, di
   sub ax, ax
   mov cx, 8000h
   rep stosw
  end;
  VideoMode:=HiVga256;
  PageBase := $0a000;
  BytesPerLine:=90;
 End;

Procedure InitXModeVga256;
 Const
  CRTCTable : Array[0..9] of Word = ( $0d06, $3e07, $4109, $ea10, $ac11,
                                      $df12, $0014, $e715, $0616, $e317 );
 Var
  h : byte;
 Begin
  asm
   mov ah, 00
   mov al, 13h
   int 10h
  end;
  WriteReg($3c4, 4, 6);
  WriteReg($3d4, $17, $e3);
  WriteReg($3d4, $14, 0);
  WriteReg($3c4, 0, 1);
  Port[$3c2]:=$e3;
  WriteReg($3c4, 0, 3);
  WriteReg($3d4, $11, ReadReg($3d4, $11) And $7f);
  For h:=0 to 9 do PortW[$3d4]:=CRTCTable[h];
  WriteReg($3c4, 2, $0f);
  asm
   mov ax, 0a000h
   mov es, ax
   sub di, di
   sub ax, ax
   mov cx, 8000h
   rep stosw
  end;
  VideoMode:=XModeVga256;
  PageBase := $0a000;
  BytesPerLine:=80;
 End;

Procedure CloseGraph;
 Begin
  asm
   mov ah, 00
   mov al, 3h
   int 10h
  end;
 End;

Procedure FillScreen(ColorS: byte);
 Begin
  asm
   mov ax, PageBase
   mov es, ax
   xor di, di
   mov cx, 32000
   mov al, byte ptr ColorS
   mov ah, al
   rep stosw
  end;
 End;

Procedure PutPixel(X, Y: Integer; Pixel: Byte);
 Var
  XY, R : longint;
 Begin
  If VideoMode = LowVga256 then
   Begin
    R:=Y;
    XY:=R shl 8+R shl 6+X;
    mem[PageBase:XY]:=Pixel;
    Exit;
   End;
  If (VideoMode = ExtVga256) Or (VideoMode = XModeVga256)
                             Or (VideoMode = CrossVga256)
                             Or (VideoMode = HiVga256)
  then
    asm
     mov cx, X
     mov dx, Y
     mov bl, Pixel

     mov ax, PageBase
     mov es, ax
     mov ax, BytesPerLine
     mul dx
     push cx
     shr cx, 1
     shr cx, 1

     add ax, cx
     mov di, ax
     pop cx
     and cl, 3

     mov ah, 1
     shl ah, cl

     mov al, 2
     mov dx, 3c4h

     out dx, ax
     mov es:[di], bl
    end;
 End;

Function  GetPixel(X, Y: Integer) : Byte;
 Var
  R : longint;
  A : byte;
  B : Word;
 Begin
  If VideoMode = LowVga256 then
   Begin
    R:=Y;
    B:=R shl 8+R shl 6+X;
    asm
     mov ax, PageBase
     mov es, ax
     mov si, B
     mov al, ES:[si]
     mov A, al
    end;
    GetPixel:=A;
    Exit;
   End;
  If (VideoMode = ExtVga256) Or (VideoMode = XModeVga256)
                             Or (VideoMode = CrossVga256)
                             Or (VideoMode = HiVga256)
  then
   Begin
    asm
     mov cx, X
     mov dx, Y

     mov ax, PageBase
     mov es, ax
     mov ax, BytesPerLine

     mul dx
     push cx
     shr cx, 1
     shr cx, 1
     add ax, cx
     mov si, ax
     pop ax
     and al, 3
     mov ah, al
     mov al, 4
     mov dx, 3ceh

     out dx, ax
     mov al, ES:[si]
     mov A, al
    end;
    GetPixel:=A;
   End;
 End;

Procedure SetVisualPage(Page : Word);
 Var
  Addr : Word;
 Begin
  If (VideoMode = XModeVga256) then
   Begin
    Addr:=Page * $4b00;
    While ((Port[$3da] And $08) = 0) do;
    WriteReg($3d4, $0c, Addr shr 8);
    WriteReg($3d4, $dc, Addr And $0f);
    Exit;
   End;
  If VideoMode = CrossVga256 then
   Begin
    Addr:=Page * $4000;
    While ((Port[$3da] And $08) = 0) do;
    WriteReg($3d4, $0c, Addr shr 8);
    WriteReg($3d4, $dc, Addr And $0f);
   End;
  If VideoMode = ExtVga256 then
   Begin
    Addr:=Page * $7d00;
    While ((Port[$3da] And $08) = 0) do;
    WriteReg($3d4, $0c, Addr shr 8);
    WriteReg($3d4, $dc, Addr And $0f);
   End;
  End;

Procedure SetActivePage(Page : Word);
 Begin
  If VideoMode = XModeVga256 then PageBase:=$0a000 + Page*$4b0;
  If VideoMode = CrossVga256 then PageBase:=$0a000 + Page*$400;
  If VideoMode = ExtVga256   then PageBase:=$0a000 + Page*$7d0;
 End;
End.