program TestHiResMode;
uses crt;
const
        SeqP = $3c4;    { ������� ����� ����� } 
                                        { ����������� ������������� }
        CrtP = $3d4;    { ������� ����� ����� ����������� ��� }
        GraP = $3ce;    { ������� ����� ����� }
                                        { ������������ ����������� }
        SegA000=$a000;  { ������� ����������� }
        SegB000=$b000;  { ������� ����������� }
        Seg0040=$0040;  { ������� ������� ������ BIOS }

{var
	P                       - ������� ����� ��������
	New_v   	- ����� ��������,������� ����� �������� � �������,
	Mask           	- �����,
	Number  	- ������ ��������}

Procedure SetVgaReg(P:word;New_V,Mask,Number:byte);
 Begin
  Inline($0FA);{ Cli - ��������� ����������}
  Port[P] := Number;
  Port[P+1] := (Port[P+1] and (not Mask))or (New_V and Mask);
  Inline($0FB);{ Sti - ��������� ����������}
End;

{������� ������������ �������� ��� ����}
Procedure WaitRetrace;
 Begin
  While(Port[$3DA] and $08)=0 do;
 End;

{������������� ��������� ���������� 3h}
Procedure SetTextMode;
 Begin
	asm
	mov ax,3
	int $10       {��������� �����������}
 end;
End;

{������ ������� ��������� ��������� �����}
function clock:longint;
 begin
  clock:=MemL[Seg0040:$6c];
 end;

{������������� ���������� 800x600x256}
Procedure SetHiResMode;
var OutStatus:word;
 Begin
  SetVgaReg(SeqP,$20,$20,1);        { ��������� ����� }
  asm
	mov ax,$4f02 {�������� ���������� ����� 800x600x256}
	mov bx,$101  		{ ��� ������ 640x480x256 - �������� �� $101}
	int $10
	mov OutStatus,ax   	{ � ������, ��� �� ����� ����������}
  end;
  if Lo(OutStatus)=$4f then begin 	{VESA �� ��������������}
    SetTextMode;
    writeln('Your card is not VESA-compartible');
    halt;             		{ ��������� ������ ���������}
  end;
  if Hi(OutStatus)=0 then begin 	{ ���������� �� �������������� }
    SetTextMode;
    writeln('Videomode is not supported');
    halt;             		{��������� ������ ���������}
  end;
  WaitRetrace;
  SetVgaReg(CrtP,$40,$40,$17); 	{ ������������� ����� ������ ����������� ��� }
  SetVgaReg(CrtP,0,$40,$14);  	{ ���������� ����� "������� �����" �����.���}
  WaitRetrace;
  SetVgaReg(SeqP,0,$08,4);  	{ ���������� ����� "������� 4"}
  SetVgaReg(SeqP,$0F,$0F,2); 	{ ��������� ��� ��������� ��� ������ }
  SetVgaReg(GraP,0,$0C,6); { �������� ������� ����������� A000:0000-B000:FFFF}
  FillChar(mem[SegA000:0],64000,0);    	{ ������� ������ }
  SetVgaReg(SeqP,0,$20,1);      { �������� ����� }
End;

{������ ����� �� ������}
procedure PutPixel(X, Y : word; Color : byte);
 begin
 { ������������� ����� ��� ������ ������ ��������� }
 PortW[SeqP] := 2 + $100 shl (X and 3);
 { ��������� �������� (Y * 800 div 4 + X div 4) � ������ ����� }
 { ��� ������ 640x480x256 �������� � ���� ������ 200 �� 160 }
 if (longint(Y) * 200 + X div 4)=$10000 then
   Mem[SegA000 : Y * 200 + X shr 2] := Color
 else
   Mem[SegB000 : word(longint(Y) * 200 + X shr 2-$10000)] := Color;
 end;

{������ ����� �� ������ � ������������}
procedure PutPixel1(X, Y : word; Color : byte);assembler;
 asm
	mov dx,SeqP
	mov cx,X
	and cx,3
	mov ax,$100
	shl ax,cl
	add ax,2
	out dx,ax  {������������� �����}
	mov ax,200
	mul Y
	mov bx,X
	shr bx,2   {ax = X div 2}
	add bx,ax  {bx - 16 ������� ����� ��������}
	adc dx,dx  { ���� dx �� ����� 0, �� ���������� ������� SegB000}
	mov ax,SegA000
	jz @l
	mov ax,SegB000
	@l: mov es,ax
	mov al,Color
	mov es:[bx],al
 end;

const b:byte = 255; {����� ���������, � ������� ���� ��������� ���������}
{������ ����� �� ������ � ������������ (2-� �������)}
procedure PutPixel2(X, Y : word; Color : byte);assembler;
 asm
	mov dx,SeqP
	mov cx,X
	and cx,3
	cmp cl,b
	jz @l1
	mov b,cl
	mov ax,$100
	shl ax,cl
	add ax,2
	out dx,ax  {������������� �����}
	@l1: mov ax,200
	mul Y
	mov bx,X
	shr bx,2   {ax = X div 2}
	add bx,ax  {bx - 16 ������� ����� ��������}
	adc dx,dx  {���� dx �� ����� 0, �� ���������� ������� SegB000}
	mov ax,SegA000
	jz @l2
	mov ax,SegB000
	@l2: mov es,ax
	mov al,Color
	mov es:[bx],al
 end;

{�������� ���������}
var i,j,k:integer;
    c1,c2,c3,c4,c5:longint;
begin
  SetHiResMode;
  {������� ��������� ����� ���� 256 ������}
  {��� ������ 640x480x256 �������������� ��������� ����� ������}
  c1 := clock;
  for k := 0 to 9 do for i:=0 to 799 do
    for j:=0 to 599 do PutPixel(i,j,lo(i+j));{}
  c2 := clock;
  for k := 0 to 9 do for i:=0 to 799 do
    for j:=0 to 599 do PutPixel1(i,j,lo(i+j));{}
  c3 := clock;
  for k := 0 to 9 do for i:=0 to 799 do
    for j:=0 to 599 do PutPixel2(i,j,lo(i+j));{}
  c4 := clock;
  for k := 0 to 9 do
    for i:=0 to 799 do for j:=0 to 599 do
  asm   { ��������� ����� ��������������� �� ���� ��������� }
	mov dx,SeqP
	mov cx,i
	and cx,3
	cmp cl,b
	jz @l1
	mov b,cl
	mov ax,$100
	shl ax,cl
	add ax,2
	out dx,ax  {������������� �����}
	@l1: mov ax,200
	mul j
	mov bx,i
	shr bx,2   {ax = X div 2}
	add bx,ax  {bx - 16 ������� ����� ��������}
	adc dx,dx  {���� dx �� ����� 0, �� ���������� ������� SegB000}
	mov ax,SegA000
	jz @l2
	mov ax,SegB000
	@l2: mov es,ax
	mov ax,i
	add ax,j
	mov es:[bx],al
  end;
  c5 := clock;{}
  SetTextMode;
  writeln('Elapsed time - PutPixel:',c2-c1,' PutPixel1:',
          c3-c2,' PutPixel2:', c4-c3,' Direct:',c5-c4);
end.
