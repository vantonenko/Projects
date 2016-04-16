program TestHiResMode;
uses crt;
const
        SeqP = $3c4;    { Базовый номер порта } 
                                        { контроллера синхронизации }
        CrtP = $3d4;    { Базовый номер порта контроллера ЭЛТ }
        GraP = $3ce;    { Базовый номер порта }
                                        { графического контроллера }
        SegA000=$a000;  { Сегмент видеопамяти }
        SegB000=$b000;  { Сегмент видеопамяти }
        Seg0040=$0040;  { Сегмент области данных BIOS }

{var
	P                       - Базовый адрес регистра
	New_v   	- новое значение,которое нужно записать в регистр,
	Mask           	- маска,
	Number  	- индекс регистра}

Procedure SetVgaReg(P:word;New_V,Mask,Number:byte);
 Begin
  Inline($0FA);{ Cli - запрещаем прерывания}
  Port[P] := Number;
  Port[P+1] := (Port[P+1] and (not Mask))or (New_V and Mask);
  Inline($0FB);{ Sti - разрешаем прерывания}
End;

{Ожидаем вертикальный обратный ход луча}
Procedure WaitRetrace;
 Begin
  While(Port[$3DA] and $08)=0 do;
 End;

{Устанавливаем текстовый видеорежим 3h}
Procedure SetTextMode;
 Begin
	asm
	mov ax,3
	int $10       {установка видеорежима}
 end;
End;

{Читаем текущее показание системных часов}
function clock:longint;
 begin
  clock:=MemL[Seg0040:$6c];
 end;

{Устанавливаем видеорежим 800x600x256}
Procedure SetHiResMode;
var OutStatus:word;
 Begin
  SetVgaReg(SeqP,$20,$20,1);        { выключаем экран }
  asm
	mov ax,$4f02 {пытаемся установить режим 800x600x256}
	mov bx,$101  		{ для режима 640x480x256 - заменить на $101}
	int $10
	mov OutStatus,ax   	{ и узнаем, что из этого получилось}
  end;
  if Lo(OutStatus)=$4f then begin 	{VESA не поддерживается}
    SetTextMode;
    writeln('Your card is not VESA-compartible');
    halt;             		{ завершаем работу программы}
  end;
  if Hi(OutStatus)=0 then begin 	{ видеорежим не поддерживается }
    SetTextMode;
    writeln('Videomode is not supported');
    halt;             		{завершаем работу программы}
  end;
  WaitRetrace;
  SetVgaReg(CrtP,$40,$40,$17); 	{ устанавливаем режим байтов контроллера ЭЛТ }
  SetVgaReg(CrtP,0,$40,$14);  	{ сбрасываем режим "двойное слово" контр.ЭЛТ}
  WaitRetrace;
  SetVgaReg(SeqP,0,$08,4);  	{ сбрасываем режим "цепочка 4"}
  SetVgaReg(SeqP,$0F,$0F,2); 	{ разрешаем все плоскости для записи }
  SetVgaReg(GraP,0,$0C,6); { диапазон адресов видеопамяти A000:0000-B000:FFFF}
  FillChar(mem[SegA000:0],64000,0);    	{ очистка экрана }
  SetVgaReg(SeqP,0,$20,1);      { включаем экран }
End;

{Рисуем точку на экране}
procedure PutPixel(X, Y : word; Color : byte);
 begin
 { Устанавливаем маску для выбора нужной плоскости }
 PortW[SeqP] := 2 + $100 shl (X and 3);
 { Вычисляем смещение (Y * 800 div 4 + X div 4) и рисуем точку }
 { Для режима 640x480x256 заменить в трех местах 200 на 160 }
 if (longint(Y) * 200 + X div 4)=$10000 then
   Mem[SegA000 : Y * 200 + X shr 2] := Color
 else
   Mem[SegB000 : word(longint(Y) * 200 + X shr 2-$10000)] := Color;
 end;

{Рисуем точку на экране с оптимизацией}
procedure PutPixel1(X, Y : word; Color : byte);assembler;
 asm
	mov dx,SeqP
	mov cx,X
	and cx,3
	mov ax,$100
	shl ax,cl
	add ax,2
	out dx,ax  {устанавливаем маску}
	mov ax,200
	mul Y
	mov bx,X
	shr bx,2   {ax = X div 2}
	add bx,ax  {bx - 16 младших битов смещения}
	adc dx,dx  { если dx не равен 0, то используем сегмент SegB000}
	mov ax,SegA000
	jz @l
	mov ax,SegB000
	@l: mov es,ax
	mov al,Color
	mov es:[bx],al
 end;

const b:byte = 255; {номер плоскости, к которой было последнее обращение}
{Рисуем точку на экране с оптимизацией (2-й вариант)}
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
	out dx,ax  {устанавливаем маску}
	@l1: mov ax,200
	mul Y
	mov bx,X
	shr bx,2   {ax = X div 2}
	add bx,ax  {bx - 16 младших битов смещения}
	adc dx,dx  {если dx не равен 0, то используем сегмент SegB000}
	mov ax,SegA000
	jz @l2
	mov ax,SegB000
	@l2: mov es,ax
	mov al,Color
	mov es:[bx],al
 end;

{Основная программа}
var i,j,k:integer;
    c1,c2,c3,c4,c5:longint;
begin
  SetHiResMode;
  {выводим наклонные линии всех 256 цветов}
  {для режима 640x480x256 соответственно уменьшить длину циклов}
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
  asm   { рисование точки непосредственно из тела программы }
	mov dx,SeqP
	mov cx,i
	and cx,3
	cmp cl,b
	jz @l1
	mov b,cl
	mov ax,$100
	shl ax,cl
	add ax,2
	out dx,ax  {устанавливаем маску}
	@l1: mov ax,200
	mul j
	mov bx,i
	shr bx,2   {ax = X div 2}
	add bx,ax  {bx - 16 младших битов смещения}
	adc dx,dx  {если dx не равен 0, то используем сегмент SegB000}
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
