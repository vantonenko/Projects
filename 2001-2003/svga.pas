program TestHiResMode;
{Демонстрация работы в режиме 640х400х256 цветов}
{$x+}
uses crt;

const
   SeqP = $3c4;    { Базовый номер порта контроллера синхронизации }
   CrtP = $3d4;    { Базовый номер порта контроллера ЭЛТ }
   SegA000=$a000;  { Сегмент видеопамяти }

{Устанавливает один из регистров VGA:
P      - Базовый адрес регистра
New_v  - новое значение, которое нужно записать в регистр,
Mask   - маска,
Number - индекс регистра}
Procedure SetVgaReg(P:word;New_V,Mask,Number:byte);
Begin
   Inline($0FA);{ Cli - запрещает прерывания}
   Port[P] := Number;
   Port[P+1] := (Port[P+1] and (not Mask))or (New_V and Mask);
   Inline($0FB);{ Sti - разрешает прерывания}
End;

{Ожидает вертикальный обратный ход луча}
Procedure WaitRetrace;
Begin
   While(Port[$3DA]and $08)=0 do;
End;

{Устанавливает текстовый видеорежим 3h}
Procedure SetTextMode;
Begin
   asm
      mov ax,3
      int $10       {установка видеомоды}
   end;
End;

{Устанавливает видеорежим 640x400x256}
Procedure SetHiResMode;
var OutStatus:word;
Begin
   SetVgaReg(SeqP,$20,$20,1);          { выключаем экран }
   asm
      mov ax,$4f02 {пытаемся установить режим 640х400х256}
      mov bx,$101
      int $10
      mov OutStatus,ax  {и узнаем, что из этого получилось}
   end;
   if Lo(OutStatus)=$4f then begin {VESA не поддерживается}
      SetTextMode;
      writeln('Your card is not VESA-compartible');
      halt;             {завершаем работу программы}
   end;
   if Hi(OutStatus)=0 then begin
{видеорежим не поддерживается}
      SetTextMode;
      writeln('Videomode is not supported');
      halt;             {завершаем работу программы}
   end;
   WaitRetrace;
   SetVgaReg(CrtP,$40,$40,$17);
{устанавливаем режим байтов контроллера ЭЛТ}
   SetVgaReg(CrtP,0,$40,$14);  
{сбрасываем режим "двойное слово" контр.ЭЛТ}
   WaitRetrace;
   SetVgaReg(SeqP,0,$08,4);  {сбрасываем режим "цепочка 4"}
   SetVgaReg(SeqP,$0F,$0F,2);          
{разрешаем все плоскости для записи} 
   FillChar(mem[SegA000:0],64000,0);    {очистка экрана}
   SetVgaReg(SeqP,0,$20,1);            {включаем экран}
End;

{Рисует точку на экране}
procedure PutPixel(X, Y : word; Color : byte);
begin
  PortW[SeqP] := 2 + $100 shl (X and 3); 
{выбор нужной плоскости}
{Вычисляем смещение (Y * (640 div 4) + X div 4) и рисуем точку}
  Mem[SegA000 : Y shl 7 + Y shl 5 + X shr 2] := Color;
end;

{Основная программа}
var i,j:integer;
begin
   SetHiResMode;
   for i:=0 to 639 do for j:=0 to 399 do PutPixel(i,j,lo(i+j));
                {выводим наклонные линии всех 256 цветов}
   ReadKey;                  { ждем нажатия на клавишу }
   SetTextMode;
end.
