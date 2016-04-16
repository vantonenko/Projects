program setup;
{программа определения номера режима 640х400х256}
const Seg0040 = $40; {область данных BIOS}

Procedure SetVideoMode(Mode:byte); {устанавливает видеорежим}
Begin
    asm
    mov al,Mode
    xor ah,ah
    int 10h
    end;
End;

Function GetVideoMode:byte;        {читает видеорежим}
Begin
    asm
    mov ah,$0f
    int 10h
    mov @Result,al
    end;
End;

type
  vidrec=record   {структура, характеризующая видеорежим}
     mode:byte;                 {номер видеорежима}
     wide:Word;     {предполагаемая ширина экрана в точках}
     Heig:Word;     {предполагаемая высота экрана в точках}
     pixel:boolean; {можно ли прочитать нарисованную точку}
     Graph1,Graph2:boolean;    
{является ли режим графическим (2 варианта)}
     c256:boolean;         {является ли режим 256-цветным}
  end;
var
   i,k:integer;
   vr:vidrec;         {параметры текущего режима}
   q:array[0..$7f]of vidrec; {массив для выбранных режимов}
   m:byte;        {для номера VESA-режима}

procedure GetConst; {заполняет структуру видеопараметров}
var
   colpix:byte;
begin
   vr.mode := mem[Seg0040:$49];   {Номер видеорежима}
   vr.wide := memW[Seg0040:$4a] * 8;  
{Ширина экрана, если в знаке 8 точек}
   vr.Heig := (mem[Seg0040:$84] + 1) * memW[Seg0040:$85];  {Линий растра}
   asm
      mov ah,$0c  {проверка методом записи и чтения точки}
      mov al,$aa  {номер цвета}
      mov bh,0
      mov cx,639  {X-координата}
      mov dx,399  {Y-координата}
      int $10     {пишем точку}
      mov ah,$0d
      mov bh,0
      mov cx,639  {X}
      mov dx,399  {Y}
      int $10     {читаем точку}
      mov colpix,al
   end;
   vr.pixel :=  (colpix = $aa);
   colpix := Port[$3da];         { чтение регистра MCR }
   Port[$3c0] := $10;   { контроллера }
   colpix := Port[$3c1];        { атрибутов   }
   vr.Graph1 := (colpix and 1) = 1;     { графический?}
   Port[$3ce] := 6;     {            }
   vr.Graph2 := (Port[$3cf] and 1) = 1; { графический?}
   Port[$3ce] := 5;     {            }
   vr.c256 := (Port[$3cf] and $40) = $40;       { 256 цветов? }
end;

begin                    {основная программа}
   Port[$3c4] := 1;
   Port[$3c5] := Port[$3c5] or $20;  {выключаем экран}
   k := 0;
   for i := $14 to $7f do begin {перебираем по всем номерам}
      SetVideoMode(i);
      if i = GetVideoMode then begin 
{отбираем только существующие режимы}
         GetConst;
         if (vr.Wide = 640) and (vr.Heig = 400) then begin 
{отбираем по размерам}
            q[k] := vr;
            k := k + 1;
         end;
      end;
   end;
   SetVideoMode(3);
   asm                 {проверка VESA}
      mov ax,$4f02
      mov bx,$100
      int $10
   end;
   m := GetVideoMode;
   Port[$3c4] := 1;
   Port[$3c5] := Port[$3c5] and $DF;  {включаем экран}
   SetVideoMode(3);
   if k=0 then          {если отобран хотя бы один режим}
      for i := 0 to k-1 do 
{выводим на печать его параметры}
         writeln('Mode=',q[i].mode,' Wid=',q[i].Wide,'Hei=',q[i].Heig,
         ' Pixel:',q[i].pixel,'Graphic:',q[i].Graph1,'/',q[i].Graph2,
         ' 256colors:',q[i].c256)
   else writeln('Suitable mode not detected');
   if m=$13 then      writeln('VESA mode:',m)
   else                 writeln('VESA not supported');
end.
