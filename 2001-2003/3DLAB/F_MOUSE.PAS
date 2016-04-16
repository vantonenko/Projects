{==============} UNIT F_Mouse; {===============}
{+---------------------------------------------+
 |  В этом модуле собраны процедуры и функции, |
 |    обеспечивающие работу устройства ввода   |
 |                типа мышь                    |
 +---------------------------------------------+}
                  INTERFACE

{Следующий тип используется для определения
 элементов, выбираемых мышью (см.SetMouseOption)}
type
  MouseItemType = record
    X1,Y1,X2,Y2: Integer;  {Координаты области}
    Butt: Word;            {Условия вызова}
    Key : Word             {Скан-код клавиши}
  end;

{Тип MouseHandlerType определяет процедуру
обработки событий от мыши}
type
  MouseHandlerType = Procedure(Mask,Buttons, 					X,Y,DX,DY: Integer);
{Константы выбора кнопок мыши}
const
  LeftButton   = 1;   		{Левая кнопка}
  RightButton  = 2;   		{Правая кнопка}
  CenterButton = 4;   		{Средняя кнопка}
  AnyButton    = 7;   		{Любая кнопка}
{Коэффициенты пересчета виртуальных координат в текстовые}
const
  TextRatioX: Byte = 8;
  TextRatioY: Byte = 8;
{+---------------------------------------------+
 |                Инициация мыши               |
 +---------------------------------------------+}
Function IsMouse: Boolean;
  {Возвращает TRUE, если мышь доступна}

Function InitMouse: Boolean;
  {Инициация мыши}

Procedure SetMousePage(Page: Byte);
  {Устанавливает страницу для указателя мыши}

Function GetMousePage: Byte;
  {Возвращает номер страницы с указателем}

Procedure SetStepToPixel(Hor,Ver: Integer);
  {Устанавливает чувствительность мыши}

Procedure GetStepToPixel(var Hor,Ver: Integer);
  {Возвращает чувствительность мыши}

Procedure SetDoubleSpeed(Speed: Word);
 {Устанавливает порог удвоения скорости перемещения указателя}

Function GetDoubleSpeed: Word;
  {Возвращает порог удвоения скорости}
{+---------------------------------------------+
 |                  Координаты                 |
 ----------------------------------------------+}
Function MouseTextCooX(X: Integer): Byte;
  {Возвращает текстовую координату по заданной виртуальной}

Function MouseTextCooY(Y: Integer): Byte;
  {Возвращает текстовую координату по заданной виртуальной}

Function MouseGraphCooX(X: Byte): Integer;
  {Возвращает виртуальную координату по заданной текстовой}

Function MouseGraphCooY(Y: Byte): Integer;
  {Возвращает виртуальную координату по заданной текстовой}

Procedure MouseWhereXY(var X,Y: Integer);
  {Возвращает виртуальные координаты мыши}

Procedure MouseGotoXY(X,Y: Integer);
  {Переводит указатель мыши в новое положение
   X,Y - виртуальные координаты}

Function MouseWhereX: Byte;
 {Возвращает горизонтальную текстовую координату}

Function MouseWhereY: Byte;
  {Возвращает вертикальную текстовую координату}

Function MouseIn(X1,Y1,X2,Y2: Integer): Boolean;
  {Возвращает TRUE, если указатель находится
   в заданном прямоугольнике}
{+---------------------------------------------+
 |             Состояние кнопок                |
 +---------------------------------------------+}
Function NumButton: Byte;
  {Возвращает количество кнопок мыши}

Procedure GetMouseState(var Butt,X,Y: Integer);
  {Возвращает текущее состояние мыши:
   BUTT - флаг состояния кнопок;
   X,Y  - текущие виртуальные координаты}

Function MousePressed: Boolean;
  {Возвращает TRUE, если нажата любая кнопка}

Procedure MouseButtPressed(Butt: Integer;
                   var Stat,Count,X,Y: Integer);
  {Возвращает информацию о нажатой клавише:
   BUTT - флаг выбора клавиши;
   STAT - состояние клавиш;
   COUNT - количество нажатий, X,Y - координаты}

Procedure MouseButtReleased(Butt: Integer;
                   var Stat,Count,X,Y: Integer);
  {Возвращает информацию об отпущенной клавише:
   BUTT - флаг выбора клавиши;
   STAT - состояние клавиш;
   COUNT - количество отпусканий;
   X,Y - координаты}
{+---------------------------------------------+
 |                   Окна                      |
 +---------------------------------------------+}
Procedure MouseWindow(X1,Y1,X2,Y2: Integer);
  {Задает координаты области перемещения
  указателя. X1...Y2 - виртуальные координаты}

Procedure MouseScreen;
  {Устанавливает окно во весь экран}
{+---------------------------------------------+
 |             Форма указателя                 |
 +---------------------------------------------+}
Procedure ShowMouse;
  {Показать указатель мыши}

Procedure HideMouse;
  {Убрать указатель мыши}

Procedure MouseTextCursor(ScrMask,CurMask: Word);
  {Устанавливает новый вид текстового указателя}

Procedure MouseBlink(YUp,YDn: Byte);
  {Задает аппаратный курсор нужного размера}

Procedure MouseGraphCursor(var ScrCurMask;X,Y: Byte);
  {Задает вид графического указателя}
{+---------------------------------------------+
 |     Сохранение/восстановление состояния     |
 +---------------------------------------------+}
Function MouseBuffSize: Word;
  {Возвращает длину буфера для сохранения параметров}

Procedure SaveMouse(var Buff);
  {Сохраняет в буфере текущее состояние мыши}

Procedure RestoreMouse(var Buff);
  {Восстанавливает сохраненное состояние мыши}
{+---------------------------------------------+
 |              Эмуляция клавиатуры            |
 +---------------------------------------------+}
Procedure SetMouseItem(NItem: Byte; var Items);
  {Устанавливает элементы для выбора мышью:
   NItem - количество элементов;
   Items - array [1..NItem] of MouseItemType;
   Старые установки сбрасываются}

Procedure AddMouseItem(Item: MouseItemType);
  {Добавляет еще один элемент для выбора мышью.
   Старые установки сохраняются}

Procedure ClearMouseItems;
  {Сбрасывает ранее установленные элементы}

Procedure GetMouseItem(var NItem: Byte; var Items);
  {Возвращает установленные элементы}

Function KeyOrMousePressed: Boolean;
  {Возвращает TRUE, если нажата клавиша или активна мышь}

Function ReadKeyOrMouse: Char;
  {Возвращает символ нажатой клавиши или выбранной опции}
{+---------------------------------------------+
 |        Обработка событий от мыши            |
 +---------------------------------------------+}
Procedure SetMouseHandler(Mask: Word; Proc: MouseHandlerType);
  {Устанавливает адрес и условия вызова обработчика}

Procedure ChangeMouseHandler(Mask: Word;  Proc: MouseHandlerType;
                        	var OldMask: Word; var OldProc: Pointer);
  {Заменяет старый обработчик новым}

Procedure ClearMouseHandler;
  {Удаляет обработчик событий}

                 IMPLEMENTATION
{+---------------------------------------------+
 |               Инициация мыши                |
 +---------------------------------------------+}
Uses DOS,CRT;
type
  MouseItems = array [1..2*MaxInt div
         SizeOf(MouseItemType)] of MouseItemType;
  PMouseIt =^MouseItems;
const
  MousePresent: Boolean = False; 	{Признак наличия мыши}
  ItemsList   : PMouseIt = NIL;  	{Массив элементов выбора}
  NMouseItem  : Byte = 0;        	{Количество элементов выбора}
  MouseVisible: Boolean = False; 	{Признак видимого указателя}
  x1m: Integer = 0;       	        {Координаты области}
  y1m: Integer = 0;       	        {перемещения указателя}
  x2m: Integer = 639;
  y2m: Integer = 199;
  Speed2: Word = 128;   		{Порог удвоения скорости}
  VerRat: Integer = 8;  		{Чувствительность мыши}
  HorRat: Integer = 8;
  NButton: Byte = 0;    		{Количество кнопок мыши}
var
  Reg: registers;

Function IsMouse: Boolean;
  {Возвращает TRUE, если мышь доступна}
var
  p    : Pointer;
  k,x,y: Integer;
  Is   : Boolean;
begin
  if NButton=0 then
    begin
      GetIntVec($33,p);
      Is := p<>NIL;
      if Is then with Reg do
        begin
          ax := $3;
          bx := $FFFF;
          Intr($33,Reg);
          Is := bx<>$FFFF
        end;
      MousePresent := Is
    end;
  IsMouse := MousePresent
end;   {IsMouse}
{-----------------------}
Function InitMouse: Boolean;
  {Инициация мыши}
begin
  with Reg do
    begin
      ax := 0;
      Intr($33,Reg);
      MousePresent := ax=$FFFF;
      NButton := bx
    end;
  ClearMouseItems;
  SetMousePage(0);
  HideMouse;
  MouseScreen
end;   {InitMouse}
{-----------------------}
Procedure SetMousePage(Page: Byte);
  {Устанавливает страницу для указателя мыши}
begin
  with Reg do
    begin
      ax := $1D;
      bl := Page;
      bh := 0;
      Intr($33,Reg)
    end
end;   {SetMousePage}
{-----------------------}
Function GetMousePage: Byte;
  {Возвращает номер страницы с указателем}
begin
  with Reg do
    begin
      ax := $1E;
      Intr($33,Reg);
      GetMousePage := bl
    end
end;   {GetMousePage}
{-----------------------}
Procedure SetStepToPixel(Hor,Ver: Integer);
  {Устанавливает чувствительность мыши}
begin
  if IsMouse then with Reg do
    begin
      ax := $0F;
      cx := Hor and $7FFF;
      dx := Ver and $7FFF;
      HorRat := cx;
      VerRat := dx;
      Intr($33,Reg)
    end
end;   {SetStepToPixel}
{-----------------------}
Procedure GetStepToPixel(var Hor,Ver: Integer);
  {Возвращает чувствительность мыши}
begin
  if IsMouse then with Reg do
    begin
      Hor := HorRat;
      Ver := VerRat
    end
end;   {GetStepToPixel}
{-----------------------}
Procedure SetDoubleSpeed(Speed: Word);
 {Устанавливает порог удвоения скорости перемещения указателя}
begin
  if IsMouse then with Reg do
    begin
      ax := $13;
      dx := Speed;
      Speed2 := Speed;
      Intr($33,Reg);
    end
end;   {SetDoubleSpped}
{-----------------------}
Function GetDoubleSpeed: Word;
  {Возвращает порог удвоения скорости}
begin
  GetDoubleSpeed := Speed2
end;   {GetDoubleSpped}
{+---------------------------------------------+
 |                  Координаты                 |
 +---------------------------------------------+}
Function MouseTextCooX(X: Integer): Byte;
  {Возвращает текстовую координату по заданной виртуальной}
begin
  MouseTextCooX := X div TextRatioX+1
end;   {MouseTextCooX}
{-----------------------}
Function MouseTextCooY(Y: Integer): Byte;
  {Возвращает текстовую координату по заданной виртуальной}
begin
  MouseTextCooY := Y div TextRatioY+1
end;   {MouseTextCooY}
{-----------------------}
Function MouseGraphCooX(X: Byte): Integer;
  {Возвращает виртуальную координату по заданной текстовой}
begin
  MouseGraphCooX := (X-1)*TextRatioX
end;   {MouseGraphCooX}
{-----------------------}
Function MouseGraphCooY(Y: Byte): Integer;
  {Возвращает виртуальную координату по заданной текстовой}
begin
  MouseGraphCooY := (Y-1)*TextRatioY
end;   {MouseGraphCooY}
{-----------------------}
Procedure MouseWhereXY(var X,Y: Integer);
  {Возвращает виртуальные координаты мыши}
begin
  if IsMouse then with Reg do
    begin
      ax := $3;
      Intr($33,Reg);
      X := cx;
      Y := dx
    end
  else
    begin
      X := -1;
      Y := -1
    end
end;   {MouseWhereXY}
{-----------------------}
Procedure MouseGotoXY(X,Y: Integer);
  {Переводит указатель мыши в новое положение
   X,Y - виртуальные координаты}
begin
  if IsMouse then with Reg do

    begin
      ax := $4;
      cx := X;
      dx := Y;
      Intr($33,Reg)
    end
end;   {MouseGotoXY}
{-----------------------}
Function MouseWhereX: Byte;
 {Возвращает горизонтальную текстовую координату}
begin
  if IsMouse then with Reg do
    begin
      ax := $3;
      Intr($33,Reg);
      MouseWhereX := MouseTextCooX(cx)
    end
  else
    MouseWhereX := 0
end;   {MouseWhereX}
{-----------------------}
Function MouseWhereY: Byte;
  {Возвращает текстовую координату по вертикали}
begin
  if IsMouse then with Reg do
    begin
      ax := $3;
      Intr($33,Reg);
      MouseWhereY := MouseTextCooY(dx)
    end
  else
    MouseWhereY := 0
end;   {MoueseWhereY}
{-----------------------}
Function MouseIn(X1,Y1,X2,Y2: Integer): Boolean;
  {Возвращает TRUE, если указатель находится
   в заданном прямоугольнике}
begin
  if IsMouse then with Reg do
    begin
      ax := $3;
      Intr($33,Reg);
      MouseIn := (cx>=X1) and (cx<=X2) and
                 (dx>=Y1) and (dx<=Y2)
    end
  else
    MouseIn := False
end;   {MouseIn}
{+--------------------------------------------+
 |            Состояние кнопок                |
 +--------------------------------------------+}
Function NumButton: Byte;
  {Возвращает количество кнопок мыши}
begin
  NumButton := NButton
end;   {NumButton}
{----------------------}
Procedure GetMouseState(var Butt,X,Y: Integer);
  {Возвращает текущее состояние мыши:
   BUTT - флаг состояния кнопок;
   X,Y  - текущие виртуальные координаты}
begin
  if IsMouse then with Reg do
    begin
      ax := $3;
      Intr($33,Reg);
      Butt := bx;
      X := cx;
      Y := dx
    end
  else
    begin
      Butt := 0;
      X := 0;
      Y := 0
    end
end;   {GetMouseState}
{-----------------------}
Function MousePressed: Boolean;
  {Возвращает TRUE, если нажата любая кнопка}
begin
  if IsMouse then with Reg do
    begin
      ax := $3;
      Intr($33,Reg);
      MousePressed := bx<>0
    end
  else
    MousePressed := False
end;   {MousePressed}
{-----------------------}
Procedure MouseButtPressed(Butt: Integer;
                   var Stat,Count,X,Y: Integer);
  {Возвращает информацию о нажатой клавише:
   BUTT - флаг выбора клавиши;
   STAT - состояние клавиш;
   COUNT - количество нажатий, X,Y - координаты}
begin
  if IsMouse then with Reg do
    begin
      ax := $5;
      bx := Butt;
      Intr($33,Reg);
      Count := bx;
      X := cx;
      Y := dx;
      Stat := bx
    end
  else
end;   {MouseButtPressed}
{-----------------------}
Procedure MouseButtReleased(Butt: Integer;
                   var Stat,Count,X,Y: Integer);
  {Возвращает информацию об отпущенной клавише:
   BUTT - флаг выбора клавиши;
   STAT - состояние клавиш;
   COUNT - количество отпусканий;
   X,Y - координаты}
begin
  if IsMouse then with Reg do
    begin
      ax := $6;
      bx := Butt;
      Intr($33,Reg);
      Count := bx;
      X := cx;
      Y := dx;
      Stat := bx
    end
  else
end;   {MouseButtReleased}
{+---------------------------------------------+
 |                   Окна                      |
 +---------------------------------------------+}
Procedure MouseWindow(X1,Y1,X2,Y2: Integer);
  {Задает координаты области перемещения указателя.
	X1...Y2 - виртуальные координаты}
begin
  if IsMouse then
    begin
      x1m := X1;
      y1m := Y1;
      x2m := X2;
      y2m := Y2;
      with Reg do
        begin
          ax := $7;
          cx := X1;
          dx := X2;
          Intr($33,Reg);
          ax := $8;
          cx := Y1;
          dx := Y2;
          Intr($33,Reg)
        end
    end
end;   {MouseWindow}
{-----------------------}
Procedure MouseScreen;
  {Устанавливает окно во весь экран}
var
  x2,y2: Integer;
begin
  if IsMouse then with Reg do
    begin
      ah := $F;
      Intr($10,Reg);
      case al of
      1,4,5,13: begin
                  x2 := 319;
                  y2 := 199
                end;
      15,16: begin
               x2 := 639;
               y2 := 349
             end;
      17,18: begin
               x2 := 639;
               y2 := 479
             end;
      else
        x2 := 639;
        y2 := 199
      end
    end;
  MouseWindow(0,0,x2,y2)
end;   {MouseScreen}
{+---------------------------------------------+
 |             Форма указателя                 |
 +---------------------------------------------+}
Procedure ShowMouse;
  {Показать указатель мыши}
begin
  if IsMouse and not MouseVisible then
    with Reg do begin
      ax := $1;
      Intr($33,Reg);
      MouseVisible := True
    end
end;   {ShowMouse}
{-----------------------}
Procedure HideMouse;
  {Убрать указатель мыши}
begin
  if IsMouse and MouseVisible then with Reg do
    begin
      ax := $2;
      Intr($33,Reg);
      MouseVisible := False
    end
end;   {HideMouse}
{-----------------------}
Procedure MouseTextCursor(ScrMask,CurMask: Word);
  {Устанавливает новый вид текстового указателя}
begin
  if IsMouse then with Reg do
    begin
      ax := $A;
      bx := 0;
      cx := ScrMask;
      dx := CurMask;
      Intr($33,Reg)
    end
end;   {MouseTextCursor}
{-----------------------}
Procedure MouseBlink(YUp,YDn: Byte);
  {Задает аппаратный курсор нужного размера}
begin
  if IsMouse then with Reg do
    begin
      ax := $A;
      bx := 1;
      cx := YUp;
      dx := YDn;
      Intr($33,Reg)
    end
end;   {MouseBlink}
{-----------------------}
Procedure MouseGraphCursor(var ScrCurMask;X,Y: Byte);
  {Задает вид графического указателя}
begin
  if IsMouse then with Reg do
    begin
      ax := $9;
      bx := X;
      cx := Y;
      es := seg(ScrCurMask);
      dx := ofs(ScrCurMask);
      Intr($33,Reg)
    end
end;   {MouseGraphCursor}
{+---------------------------------------------+
 |    Сохранение/восстановление состояния      |
 +---------------------------------------------+}
Function MouseBuffSize: Word;
  {Возвращает длину буфера для сохранения параметров}
begin
  if IsMouse then with Reg do
    begin
      ax := $15;
      bx := 0;
      Intr($33,Reg);
      MouseBuffSize := bx
    end
  else
    MouseBuffSize := 0
end;   {MouseBuffSize}
{-----------------------}
Procedure SaveMouse(var Buff);
  {Сохраняет в буфере текущее состояние мыши}
begin
  if IsMouse then with Reg do
    begin
      ax := $16;
      es := seg(Buff);
      dx := ofs(Buff);
      Intr($33,Reg)
    end
end;   {SaveMouse}
{-----------------------}
Procedure RestoreMouse(var Buff);
  {Восстанавливает сохраненное состояние мыши}
begin
  if IsMouse then with Reg do
    begin
      ax := $17;
      es := seg(Buff);
      dx := ofs(Buff);
      Intr($33,Reg)
    end
end;   {RestoreMouse}
{+---------------------------------------------+
 |              Эмуляция клавиатуры            |
 +---------------------------------------------+}
const
  DoubleChars: Boolean = False;
var
  SecChar: Char;

Procedure SetMouseItem(NItem: Byte; var Items);
  {Устанавливает элементы для выбора мышью:
   NItem - количество элементов;
   Items - array [1..NItem] of MouseItemType;
   Старые установки сбрасываются}
begin
  if IsMouse then
    begin
      ClearMouseItems;
      GetMem(ItemsList,NItem*SizeOf(MouseItemType));
      Move(Items,ItemsList^,NItem*SizeOf(MouseItemType));
      NMouseItem := NItem
    end
end;   {SetMouseItem}
{---------------------}
Procedure AddMouseItem(Item: MouseItemType);
  {Добавляет еще один элемент для выбора мышью.
   Старые установки сохраняются}
var
  p: PMouseIt;
  k: Byte;
begin
  if IsMouse then
    begin
      k := NMouseItem;
      GetMem(P,(k+1)*SizeOf(MouseItemType));
      Move(ItemsList^,P^,k*SizeOf(MouseItemType));
      Move(Item,P^[k+1],SizeOf(MouseItemType));
      ClearMouseItems;
      NMouseItem := k+1;
      ItemsList := P
    end
end;   {AddMouseItem}
{-----------------------}
Procedure ClearMouseItems;
  {Сбрасывает ранее установленные элементы}
begin
  if IsMouse and (NMouseItem <>0) then
    begin
      FreeMem(ItemsList,NMouseItem*SizeOf(MouseItemType));
      NMouseItem := 0
    end
end;   {ClearMouseItem}
{-----------------------}
Procedure GetMouseItem(var NItem: Byte; var Items);
  {Возвращает установленные элементы}
begin
  if IsMouse and (NMouseItem<>0) then
    begin
      NItem := NMouseItem;
      Move(ItemsList^,Items,NMouseItem*SizeOf(MouseItemType))
    end
end;   {GetMouseItem}
{-----------------------}
Function KeyOrMousePressed: Boolean;
  {Возвращает TRUE, если нажата клавиша
   клавиатуры или кнопка мыши}
var
  b,k: Integer;
  MouseActive: Boolean;
begin
{Сначала проверяем клавиатуру}
  if KeyPressed then
    KeyOrMousePressed := True
{Если не нажата никакая клавиша, проверяем нажатие кнопок мыши}
  else with Reg do
    begin
      ax := $3;
      Intr($33,Reg);
      if (bx<>0) and (NMouseItem<>0) then
{Да, кнопка нажата.
 Организуем цикл проверки по всем элементам}
        begin
          MouseActive := False;
          for k := 1 to NMouseItem do
          if not MouseActive then
            with ItemsList^[k] do
	   begin
              case Butt of
                LeftButton  : b :=bx and LeftButton;
                RightButton : b :=bx and RightButton;
                CenterButton: b :=bx and CenterButton;
                AnyButton   : b := bx
              else
                b := 0;
              end;  {case}
              MouseActive := (b<>0) and
                MouseIn(MouseGraphCooX(X1),MouseGraphCooY(Y1),
                        MouseGraphCooX(X2),MouseGraphCooY(Y2))
            end;  {for,if}
          KeyOrMousePressed := MouseActive
        end  {if (bx<>0) and...}
{Если не активна клавиатура или не выбран элемент, возвращаем False}
      else  {bx=0 или NMouseItem=0}
        KeyOrMousePressed := False
    end {with Reg}
end;   {KeyOrMousePressed}
{-----------------------}
Function ReadKeyOrMouse: Char;
  {Возвращает символ нажатой клавиши или выбранного элемента}
var
  k: Byte;
  b,bb: Word;
  MouseActive: Boolean;
label
  loop;
begin
{Сначала проверяем нажатие клавиши}
loop:
  if not IsMouse or KeyPressed then
    ReadKeyOrMouse := ReadKey
{Теперь проверим эмуляцию служебной клавиши}
  else if DoubleChars then
    begin
      DoubleChars := False;
      ReadKeyOrMouse := SecChar
    end
{Проверяем необходимость контроля
 элементов экрана для эмуляции клавиатуры}
  else if NMouseItem<>0 then with Reg do
    begin  {Да, нужна проверка}
      MouseActive := False;
{Контролируем выбор мышью одного из элементов}
      ax := $3;
      Intr($33,Reg); {Получаем статус кнопок}
      bb := bx;      {Запоминаем его в bb}
      if bb<>0 then  {Если нажата любая кнопка, то организуем проверку всех 
                     элементов до нужного (ActiveMouse станет True)}
      for k := 1 to NMouseItem do
        if not MouseActive then
          with ItemsList^[k] do begin
            case Butt of
              LeftButton  : b :=bb and LeftButton;
              RightButton : b :=bb and RightButton;
              CenterButton: b :=bb and CenterButton;
              AnyButton   : b := bb;
            else
              b := 0;
            end;
            if (b<>0) and MouseIn(
                   MouseGraphCooX(X1),MouseGraphCooY(Y1),
                   MouseGraphCooX(X2),MouseGraphCooY(Y2)) then
              begin              {Найден отмеченный элемент}
                MouseActive := True;
                ReadKeyOrMouse := Char(Lo(Key));
                if Lo(Key)=0 then
                  begin          {Эмуляцияслужебной клавиши}
                    DoubleChars := True;
                    SecChar := chr(Hi(Key))
                  end
              end
          end;  {for ... if not MouseActive}
{Если мышь не отметила элемент, повторяем с начала}
      if not MouseActive then
        goto loop
    end {if NMouseItem<>0}
{Если не установлен ни один элемент для мыши,
 ждем нажатия любой клавиши}
  else
    ReadKeyOrMouse := ReadKey
end;   {ReadKeyOrMouse}
{+---------------------------------------------+
 |        Обработка событий от мыши            |
 +---------------------------------------------+}
const
  OldUserProc: Pointer = NIL;
var
  UserProc: MouseHandlerType absolute OldUserProc;
  OldAX: Word;

Procedure MouseHandler; Far; Assembler;
  {Ассемблерный интерфейс для вызова обработчика}
ASM
{Сохраняем в стеке регистры}
  push bp
  push ds
  push es
  push ax
  mov  ax,SEG @DATA
  mov  ds,ax
  pop  ax
  mov  OldAX,ax
{Проверяем условия вызова}
  mov  ax,Word ptr [OldUserProc]   {ax = сегментадреса}
  or   ax,Word ptr [OldUserProc+2] {Адрес = NIL?}
  jz   @                       	   {Да - не вызывать}
{Готовим вызов процедуры пользователя}
  mov  ax,OldAX
  push ax  			{Mask := ax}
  push bx  			{Buttons := bx}
  push cx  			{X := cx}
  push dx  			{Y := dx}
  push di  			{DX := di}
  push si  			{DY := si}
{Вызываем процедуру пользователя}
  call [UserProc]
{Выход из процедуры: восстанавливаем регистры}
@:  pop  es
  pop  ds
  pop  bp
  ret  far
end;  {MouseHandler}
{---------------------}
Procedure SetMouseHandler(Mask: Word; Proc: MouseHandlerType);
  {Устанавливает адрес и условия вызова обработчика}
begin
  if IsMouse then with Reg do
    begin
      UserProc := Proc;
      ax := $0C;
      cx := Mask;
      es := seg(MouseHandler);
      dx := ofs(MouseHandler);
      Intr($33,Reg)
    end
end;   {SetMouseHandler}
{-----------------------}
Procedure ChangeMouseHandler(Mask: Word;
	Proc: MouseHandlerType;	var OldMask: Word; var OldProc: Pointer);
  {Заменяет старый обработчик новым}
begin
  if IsMouse then with Reg do
    begin
      OldProc := OldUserProc;
      ax := $14;
      cx := Mask;
      es := seg(MouseHandler);
      dx := ofs(MouseHandler);
      Intr($33,Reg);
      OldMask := cx
    end
end;   {ChangeMouseHandler}
{------------------------}
Procedure ClearMouseHandler;
  {Удаляет обработчик событий}
begin
  if IsMouse then with Reg do
    begin
      ax := $0C;
      cx := 0;
      es := 0;
      dx := 0;
      Intr($33,Reg)
    end;
end;   {ClearMouseHandler}
{==============} end. {F_Mouse} {===============}
