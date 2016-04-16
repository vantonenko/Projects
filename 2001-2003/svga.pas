program TestHiResMode;
{���������� ࠡ��� � ०��� 640�400�256 梥⮢}
{$x+}
uses crt;

const
   SeqP = $3c4;    { ������ ����� ���� ����஫��� ᨭ�஭���樨 }
   CrtP = $3d4;    { ������ ����� ���� ����஫��� ��� }
   SegA000=$a000;  { ������� ���������� }

{��⠭�������� ���� �� ॣ���஢ VGA:
P      - ������ ���� ॣ����
New_v  - ����� ���祭��, ���஥ �㦭� ������� � ॣ����,
Mask   - ��᪠,
Number - ������ ॣ����}
Procedure SetVgaReg(P:word;New_V,Mask,Number:byte);
Begin
   Inline($0FA);{ Cli - ����頥� ���뢠���}
   Port[P] := Number;
   Port[P+1] := (Port[P+1] and (not Mask))or (New_V and Mask);
   Inline($0FB);{ Sti - ࠧ�蠥� ���뢠���}
End;

{������� ���⨪���� ����� 室 ���}
Procedure WaitRetrace;
Begin
   While(Port[$3DA]and $08)=0 do;
End;

{��⠭�������� ⥪�⮢� �����०�� 3h}
Procedure SetTextMode;
Begin
   asm
      mov ax,3
      int $10       {��⠭���� ���������}
   end;
End;

{��⠭�������� �����०�� 640x400x256}
Procedure SetHiResMode;
var OutStatus:word;
Begin
   SetVgaReg(SeqP,$20,$20,1);          { �몫�砥� �࠭ }
   asm
      mov ax,$4f02 {��⠥��� ��⠭����� ०�� 640�400�256}
      mov bx,$101
      int $10
      mov OutStatus,ax  {� 㧭���, �� �� �⮣� ����稫���}
   end;
   if Lo(OutStatus)=$4f then begin {VESA �� �����ন������}
      SetTextMode;
      writeln('Your card is not VESA-compartible');
      halt;             {�����蠥� ࠡ��� �ணࠬ��}
   end;
   if Hi(OutStatus)=0 then begin
{�����०�� �� �����ন������}
      SetTextMode;
      writeln('Videomode is not supported');
      halt;             {�����蠥� ࠡ��� �ணࠬ��}
   end;
   WaitRetrace;
   SetVgaReg(CrtP,$40,$40,$17);
{��⠭�������� ०�� ���⮢ ����஫��� ���}
   SetVgaReg(CrtP,0,$40,$14);  
{���뢠�� ०�� "������� ᫮��" �����.���}
   WaitRetrace;
   SetVgaReg(SeqP,0,$08,4);  {���뢠�� ०�� "楯�窠 4"}
   SetVgaReg(SeqP,$0F,$0F,2);          
{ࠧ�蠥� �� ���᪮�� ��� �����} 
   FillChar(mem[SegA000:0],64000,0);    {���⪠ �࠭�}
   SetVgaReg(SeqP,0,$20,1);            {����砥� �࠭}
End;

{����� ��� �� �࠭�}
procedure PutPixel(X, Y : word; Color : byte);
begin
  PortW[SeqP] := 2 + $100 shl (X and 3); 
{�롮� �㦭�� ���᪮��}
{����塞 ᬥ饭�� (Y * (640 div 4) + X div 4) � ��㥬 ���}
  Mem[SegA000 : Y shl 7 + Y shl 5 + X shr 2] := Color;
end;

{�᭮���� �ணࠬ��}
var i,j:integer;
begin
   SetHiResMode;
   for i:=0 to 639 do for j:=0 to 399 do PutPixel(i,j,lo(i+j));
                {�뢮��� �������� ����� ��� 256 梥⮢}
   ReadKey;                  { ���� ������ �� ������� }
   SetTextMode;
end.
