Unit Packer;

Interface

Function Pack (Var Source, Dest; Count : Word) : Word;
{ Упаковывает Count байт из Source в Dest, возвращая длину упакованного }

Function UnPack (Var Source, Dest; Count : Word) : Word;
{ Распаковывает Count байт из Source в Dest, возвращая длину распакованного }

Implementation

Const
  RP = $FE;

Function Pack (Var Source, Dest; Count : Word) : Word; Assembler;
Asm
  Push  DS
  Mov   BX, Count                               { BX = Count }
  Mov   AX, Word Ptr Dest
  Mov   DI, AX
  Mov   AX, Word Ptr Dest+2
  Mov   ES, AX                                  { ES:DI - Dest }
  Mov   AX, Word Ptr Source
  Mov   SI, AX
  Mov   AX, Word Ptr Source+2
  Mov   DS, AX                                  { DS:SI - Source }
  Xor   DX, DX                                  { Packed size }
  CLD
@Cycle:
  Or    BX, BX
  JZ    @End                                    { Done }
  LODSB
  Mov   CX, BX
  Cmp   CX, 100H
  JC    @1
  Mov   CX, 0FFH
@1:
  Mov   AH, CL
  Push  ES
  Push  DI                                      { Save ES:DI before scan }
  Push  SI
  Pop   DI
  Push  DS
  Pop   ES                                      { ES:DI = DS:SI for scan }
  RepE  ScaSB
  Dec   DI
  Push  DI
  Pop   SI
  Push  ES
  Pop   DS                                      { DS:SI = ES:DI for next }
  Pop   DI
  Pop   ES                                      { Restore ES:DI after scan }
  Sub   AH, CL
  Mov   CL, AH                                  { CX = repeat count }
  Cmp   AH, 3
  JNC   @3                                      { Repeat count >= 3 }
  Cmp   AL, RP
  JNE   @2                                      { Not a RepeatPrefix byte }
  STOSW                                         { Save RP, repeat count < 3 }
  Sub   BX, CX                                  { Actually count in source }
  Add   DX, 2                                   { Actually packed size }
  Jmp   @Cycle
@2:
  Sub   BX, CX                                  { Actually count in source }
  Add   DX, CX                                  { Actually packed size }
  Rep   STOSB                                   { Save bytes }
  Jmp   @Cycle
@3:
  Sub   BX, CX                                  { Actually count in source }
  Add   DX, 3                                   { Actually packed size }
  Mov   CL, AL
  Mov   AL, RP
  STOSW                                         { Save RP, repeat count < 3 }
  Mov   AL, CL
  STOSB                                         { Save repeating byte }
  Jmp   @Cycle
@End:
  Pop   DS
  Mov   AX, DX                                  { Return packed size }
End;

Function UnPack (Var Source, Dest; Count : Word) : Word; Assembler;
Asm
  Push  DS
  Mov   BX, Count                               { BX = Count }
  Mov   AX, Word Ptr Dest
  Mov   DI, AX
  Mov   AX, Word Ptr Dest+2
  Mov   ES, AX                                  { ES:DI - Dest }
  Mov   AX, Word Ptr Source
  Mov   SI, AX
  Mov   AX, Word Ptr Source+2
  Mov   DS, AX                                  { DS:SI - Source }
  Xor   DX, DX                                  { Packed size }
  Xor   AH, AH
  CLD
@Cycle:
  Or    BX, BX
  JZ    @End                                    { Done }
  LODSB
  Dec   BX
  Cmp   AL, RP
  JE    @1
  STOSB
  Inc   DX
  Jmp   @Cycle
@1:
  LODSB
  Mov   CX, AX
  Add   DX, CX
  Dec   BX
  Cmp   AL, 3
  JNC   @2
  Mov   AL, RP
  Rep   STOSB
  Jmp   @Cycle
@2:
  LODSB
  Dec   BX
  Rep   STOSB
  Jmp   @Cycle
@End:
  Pop   DS
  Mov   AX, DX
End;

End.
