Unit GrafixX;
{$G+}

Interface

Type
  PFont = Pointer;                      { Тип - указатель на матричный шрифт }
  TPal = Array [0..255, 1..3] of Byte;  { Тип - палитра, хранит компоненты 256-ти }
                                        { цветов: красную, зеленую и синюю }
  TPoint = Record                       { Тип - точка. Нужен для рисования }
    X, Y : Integer                      { ломаных линий и многоугольников  }
  End;
  TPCXHeader = Record                   { Структура заголовка PCX-файла }
    Manufact,
    Ver,
    Encoding,
    BitsPerPixel : Byte;
    X1, Y1, X2, Y2,
    Hdpi, Vdpi : Word;
    ColorMap : Array [0..47] of Byte;
    Res,
    Planes : Byte;
    BytesPerLine,
    PalInfo,
    HScrSize,
    VScrSize : Word;
    Filler : Array [0..53] of Byte;
  End;

Const
  MaxX        = 319;
  MaxY        = 239;
  MaxColor    = 255;
  GetMaxX     = MaxX;
  GetMaxY     = MaxY;
  GetMaxColor = MaxColor;
  GrOk        = 0;                      { Нет ошибки }
  GrInit      = -1;                     { Ошибка при инициализации графики }
  GrLoadFont  = -2;                     { Ошибка при загрузке шрифта }
  GrLoadObj   = -3;                     { Ошибка при загрузке картинки }
  GrSaveObj   = -4;                     { Ошибка при записи картинки }

  ClipXmin : Integer = 0;
  ClipXmax : Integer = 319;
  ClipYmin : Integer = 0;
  ClipYmax : Integer = 239;

  Seq_Addr          = $3C4;
  CRTC_Addr         = $3D4;
  Misc_Output_Addr  = $3C2;
  Graph_Cntrl_Addr  = $3CE;

  XBytesPerLine   : Byte = 40;          { Логическая ширина экрана }
  XActiveOffset   : Word = 0;           { Смещение в памяти активной страницы }
  XVisibleOffset  : Word = 0;           { Смещение в памяти видимой страницы }

  XVirtualScreenMode : Boolean = False; { Переключатель виртуального режима }
  XVirtualScreenX : Integer = 0;        { Гориз. смещение дисплея на вирт. экране }
  XVirtualScreenY : Integer = 0;        { Верт. смещение дисплея на вирт. экране }

  MouseXhot     : Integer = 0;          { Координаты указывающего пиксела в указателе мыши: (0,0) - }
  MouseYhot     : Integer = 0;          { левый верхний для стрелки; например, (8,8) - для крестика }
  MouseXmin     : Integer = 0;          { Левая граница разрешенной мыши области }
  MouseXmax     : Integer = 319;        { Правая граница разрешенной мыши области }
  MouseYmin     : Integer = 0;          { Верхняя граница разрешенной мыши области }
  MouseYmax     : Integer = 239;        { Нижняя граница разрешенной мыши области }

  MouseImage : Array [1..4+256] of Byte =     { Графический  указатель мыши, }
                                              { который можно переопределить }
  { Здесь черный (0-й) цвет не выводится - определяет прозрачность указателя }
  (16, 0, 16, 0,                              { 16x16 - для процедур *ImageX }
  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  1, 15,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  1, 15, 15, 15,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  1, 15, 15, 15, 15, 15,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  1, 15, 15, 15,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  1, 15,  1, 15, 15,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  1,  1,  0,  1, 15, 15,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  1, 15,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  1,  1,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0);

Var
  GrResult      : Integer;              { Ошибка операции }
  CurFont       : PFont;                { Указатель на текущий шрифт }
  FontSize      : Word;                 { Объем текущего шрифта }
  FontX, FontY  : Byte;                 { Гориз. и верт. размеры шрифта }
  TranspColor   : Byte;                 { Цвет прозрачности спрайта }

  _Poly : Array [0..719,1..2] of Integer;       { Под рисование многоуг-ков }

  MousePresent  : Boolean;              { Признак наличия мыши }
  MouseX,                               { X-координата мыши }
  MouseY        : Integer;              { Y-координата мыши }
  MouseButtons  : Byte;                 { 1-й бит-левая кнопка мыши,0-й-правая }

Function IsVGA : Boolean;
{ Возвращает TRUE, если в системе установлена VGA-карта }

Procedure InitGraphX;
{ Инициализирует графику - 320x240x256; состояние в переменной GrResult }

Procedure CloseGraphX;
{ Закрывает графику (устанавливает цветной текстовый режим 80x25) }

Procedure SetLogicalWidthX (Width : Byte);              { 40 ... 40*3 }
{ Устанавливает логическую ширину экрана - кол-во пикселов деленное
  на 8; используется для организации логического экрана большего по
  размерам чем 320x240 и его последующего гориз./верт. скороллинга }

Procedure SetVisibleOffsetX (Offs : Word);
{ Указывает смещение от начала VGA-памяти с которого будет производится
  вывод в левый верхний угол дисплея; изменение смещения на 1 приведет
  к смещению логического экрана относительно дисплея на 4 пиксела по
  горизонтали, а его изменение на 2 ширины логического экрана - к
  смещению на 1 пиксел по вертикали. Т.е. это мощное средство для
  организации полноэкранного скроллинга. }

Procedure SetActivePageX (Page : Byte);                 { Page = 0,1,2 }
{ Выбирает активную страницу VGA-памяти - все графические операции
  будут производиться в ней; активная и видимая страницы могут
  быть различны }

Procedure SetVisiblePageX (Page : Byte);                { Page = 0,1,2 }
{ Выбирает видимую страницу VGA-памяти - отображаться будет именно она;
  активная и видимая страницы могут быть различны }

Procedure ClearScreenX (Color : Byte);
{ Очищает экран цветом Color; на активной странице }

Procedure ClearAllPagesX (Color : Byte);
{ Очищает все страницы цветом Color }

Procedure Border (Color : Byte);
{ Устанавливает цвет Color рамки экрана }

Procedure PutPixelX (X, Y : Word; Color : Byte);
{ Рисует точку в позиции (X,Y) цветом Color; на активной странице }

Function GetPixelX (X, Y : Word) : Byte;
{ Возвращет цвет точки в позиции (X,Y); а/с }

Procedure LineHX (X, Y, L : integer; Color : Byte);
{ Рисует горизонтальную линию от точки (X,Y) длины L цветом Color; a/c }

Procedure LineVX (X, Y, H : integer; Color : Byte);
{ Рисует вертикальную линию от точки (X,Y) высоты H цветом Color; a/c }

Procedure LineX (X1, Y1, X2, Y2 : integer; Color : Byte);
{ Рисует линию, соединяющую точки (X1,Y1) и (X2,Y2), цветом Color; a/c }

Procedure BoxX (X, Y, L, H : Word; Color : Byte; Fill : Boolean);
{ Рисует прямоугольник от точки (X,Y) длины L и высоты H цветом Color,
  если Fill = True, то прямоугольник закрашивается тем же цветом; а/с }

Procedure CircleX (X, Y, R : Word; Color : Byte; Fill : Boolean);
{ Рисует окружность цвета Color с центром в точке (X,Y) радиуса R;
  если Fill = True, то окружность закрашивается тем же цветом; а/с }

Procedure DrawPolyX (Num : Word; PolyPoints : Array of TPoint; Color : Byte);
{ Рисует ломаную цвета C по ее Num вершинам в PolyPoints; а/с }

Procedure DrawPoly2X (Num : Word; PolyPoints : Array of TPoint; Color : Byte);
{ Рисует замкнутую ломаную цвета C по ее Num вершинам в
  PolyPoints; а/с }

Procedure FillPolyX (Num : Word; PolyPoints : Array of TPoint; Color : Byte);
{ Рисует сплошной многоугольник цвета C по его Num вершинам в
  PolyPoints; а/с }

Procedure FillPolyPatX (Num : Word; PolyPoints : Array of TPoint;
                                                L, H : Word; Var Pat);
{ Заполняет многоугольник с Num вершинами в PolyPoints одинаковыми
  прямоугольниками (размер LxH точек), изображение которых хранится
  в L*H-байтном массиве Pat; а/с }

Procedure LoadFont (Name : String; Var PF : PFont; Var Size : Word);
{ Загружает матричный шрифт с дисковым именем Name, резервируя память
  для PF, в Size возвращается объем зарезервированной памяти;
  состояние в переменной GrResult }

Procedure SetFont (PF : PFont);
{ Устанавливает текущий шрифт, по указателю на него PF }

Procedure WriteCX (X, Y : Word; B, T : Byte; C : Char);
{ Отображает символ C в позиции (X,Y), цветом T на фоне B;
  если B = T, то фон не изменяется; а/с }

Procedure WriteSX (X, Y : Word; B, T : Byte; S : String);
{ Аналогично процедуре WriteC отображает строку S; а/с }

Procedure ReadSX (X, Y : Word; B, T : Byte; Var S : String; N : Byte);
{ Считывает (изменяет) с клавиатуры строку S максимальной длины N,
  одновременно производится ее отображение на экране, условия
  отображения такие же как и в процедуре WriteC; примеч.: по клавише
  ESC ввод заканчивается с возвращением пустой строки; а/с }

Function ImageSizeX (L, H : Word) : Word;
{ Возвращает объем требуемой памяти для сохранения в ней
  прямоугольного участка изображения размером L x H }

Procedure GetImageX (X, Y, L, H : Word; Var BitMap);
{ Сохраняет в переменной BitMap прямоугольный участок изображения
  из позиции (X,Y) размером L x H; а/с }

Procedure PutImageX (X, Y : Word; Var BitMap);
{ Восстанавливает из переменной BitMap прямоугольный участок
  изображения в позицию (X,Y); а/с }

Procedure PutTranspImageX (X, Y : Word; Var BitMap);
{ Восстанавливает из переменной BitMap "прозрачный" прямоугольный
  участок изображения в позицию (X,Y); цвет прозрачности хранится
  в TranspColor; а/с }

Procedure PutImagePartX (X, Y : Word; Var BitMap; PX, PY, PL, PH : Word);
{ Отображает прямоугольную часть от картинки BitMap в позицию (X,Y) на
  экране; (PX,PY) - левый верхний угол прямоугольника в картинке, PL и
  PH задают размер прямоугольника; а/с }

Procedure PutTranspImagePartX (X, Y : Word; Var BitMap; PX, PY, PL, PH : Word);
{ Отображает прямоугольную часть от "прозрачной" картинки BitMap в
  позицию (X,Y) на экране; (PX,PY) - левый верхний угол прямоугольника
  в картинке, PL и PH задают размер прямоугольника; а/с }

Procedure PutClippedImageX (X, Y : Integer; Var BitMap);
{ Делает то же, что и PutImage, с той лишь разницей, что картинка не
  обязательно должна полностью умещаться на экране, что было необходимо
  для правильной работы PutImage }

Procedure PutTranspClippedImageX (X, Y : Integer; Var BitMap);
{ Делает то же, что и PutImage, с той лишь разницей, что "прозрачная"
  картинка не обязательно должна полностью умещаться на экране,
  что было необходимо для правильной работы PutImage }

Procedure LoadPCX256 (Name : String; Var PBitMap : Pointer; Var Size : Word;
                      Var Pal : TPal);
{ Загружает прямоугольную 256 цветную PCX-картинку с дисковым именем
  Name, резервируя память для PBitMap, в Size возвращается объем
  зарезервированной памяти; возможно последующее отображение
  с помощью всех PutImage'й }

Procedure SavePCX256 (Name : String; VSegA, X, Y, L, H : Word);
{ Записывает в PCX-файл с именем Name прямоугольный участок
  изображения, сохраненный в сегменте VSegA процедурой GetImage;
  (X,Y) и LxH - координаты и размеры участка изображения на странице }

Procedure GetCRGB (C : Byte; Var R, G, B : Byte);
{ Возвращает содержание красной, зеленой и синей компонент для
  цвета C в текущей палитре }

Procedure SetCRGB (C : Byte; R, G, B : Byte);
{ Устанавливает содержание красной, зеленой и синей компонент для
  цвета C в текущей палитре }

Procedure GetPal (Var Pal);
{ Возвращает в Pal текущую палитру }

Procedure SetPal (Var Pal);
{ Устанавливает палитру Pal текущей }

Procedure WaitRetrace;
{ Дожидается момента возврата луча из правого нижнего угла электронно- }
{ лучевой трубки в левый верхний. В этот момент безопасно изменять     }
{ видимую страницу - будет отсутствовать мелькание на экране (при этом }
{ программа несколько замедлится). В этот момент также удобно          }
{ менять палитру; восстанавливать фоновое изображение под спрайтом и   }
{ рисовать другой спрайт в этой позиции или тот что был, но в другой   }
{ позиции.                                                             }

Procedure FadeUp (Pal : TPal);
{ Плавно "проявляет" текущую палитру до палитры Pal }

Procedure FadeDown;
{ Плавно "гасит" текущую палитру }

Procedure BlackOutPut;
{ Обнуляет текущую палитру, делая ее черной }

Procedure DisplayOff;
{ "Выключает" дисплей - он становится черным (графический режим) }

Procedure DisplayOn;
{ "Включает" дисплей - изображение появляется вновь (графический режим) }

Function MouseFound : Boolean;
{ Возвращает True если найдена на COM1 или COM2 последовательная мышь }
{ совместимая с Microsoft'овской, в противном случае возвращает False }

Procedure MouseInit;
{ Устанавливает свой обработчик прерываний мыши, позиционирует мышь в }
{ центр экрана. Сначала мышю не видима }

Procedure MouseShow;
{ Показывает на экране указатель мыши }

Function MousePressed : Boolean;
{ Возвращает True если нажата клавиша мыши, в противном случае }
{ возвращает False }

Procedure MouseMoveTo (X, Y : Word);
{ Перемещает указатель мыши в позицию (X,Y), фон сохраняется - т.е. }
{ вызывать MouseHide и MouseShow не нужно }

Function MouseIn (X, Y, L, H : Word) : Boolean;
{ Возвращает True, если указатель мыши находится в прямоугольной области, }
{ определяемой координатами верхнего-левого угла (X,Y), длиной L и        }
{ высотой H. В противном случае возвращается False                        }

Procedure MouseHide;
{ Прячет указатель мыши }

Function MouseVisible : Boolean;
{ Возвращает True если виден указатель мыши, в противном случае }
{ возвращает False }

Procedure MouseDone;
{ Восстанавливает старый обработчик прерываний мыши, одновременно }
{ пряча ее указатель }

{ Procedure VirtualSupport; }
{ Обеспечивает режим виртуального экрана - большего чем тот, который     }
{ реально умещается на дисплее. Дисплей становится окном, через кторое   }
{ можно увидеть виртуальный экран. Перемещая мышь можно менять положение }
{ окна (дисплея) относительно виртуального экрана - т.е. просматривать   }
{ виртуальный экран. Этот режим не имеет смысла в случае отсутствия      }
{ мыши. Включается (выключается) режим установкой переменной             }
{ XVirtualScreenMode в True(False).                                      }

Implementation

Uses
  CRT, Packer, DOS;

Var
  MouseVisibl  : Boolean;               { Признак видимости указателя маши }
  MouseArea    : Array [1..4+256] of Byte; { Область сохранения изображения }
                                                      { под указателем мыши }

Function Sgn (I : Integer) : Integer; Assembler;
Asm
  Mov   AX, I
  Or    AX, AX
  JZ    @end
  ShL   AX, 1
  JC    @1
  Mov   AX, 1
  Jmp   @end
@1:
  Mov   AX, -1
@end:
End;

Function _Abs (I : Integer) : Integer; Assembler;
Asm
  Mov   AX, I
  Test  AX, 8000h
  JZ    @end
  Neg   AX
@end:
End;

Function SqrWN (X : Word) : Byte; Assembler; { Yi+1 = (Yi + X/Yi) / 2 }
{ Возвращает корень, квадрат которого является ближайшим к аргумету }
Asm
  Mov   CX, X
  Push  BP
  Mov   BP, 1
  Mov   BX, CX
  JCXZ  @end2
  Cmp   CX, 0FFFFH
  JNE   @cycle
  Mov   BX, 0FFH
  Jmp   @end2
@cycle:
  Xor   DX, DX
  Mov   AX, CX
  Div   BX
  Add   AX, BX
  Shr   AX, 1
  Mov   DI, SI
  Mov   SI, BX
  Mov   BX, AX
  Inc   BP
  Cmp   BX, SI
  JE    @end
  Cmp   BP, 3
  JC    @cycle
  Cmp   BX, DI
  JNE   @cycle
  Cmp   SI, BX
  JNC   @end
  Mov   BX, SI
@end:
  Mov   AX, BX
  Mul   BX
  Sub   AX, CX
  Neg   AX
  Inc   AX
  Mov   SI, AX                  { разница аргумента и квадрата корня }
  Inc   BX
  Mov   AX, BX
  Mul   BX
  Sub   AX, CX                  { разница арг. и квадрата увеличенного корня }
  Cmp   AX, SI
  JC    @end2
  Dec   BX
@end2:
  Pop   BP
  Mov   AX, BX
End;

Function IsVGA : Boolean; Assembler;
Asm
  Mov   AX, 1A00h
  Int   10h
  Cmp   AL, 1Ah
  JNE   @@NotVGA
  Cmp   BL, 7
  JE    @@VGA
  Cmp   BL, 8
  JE    @@VGA
@@NotVGA:
  Mov   AL, 0
  Jmp   @@Quit
@@VGA:
  Mov   AL, 1
@@Quit:
End;

Procedure InitGraphX; Assembler;
Asm
  Call  IsVGA
  Or    AL, AL
  JNZ   @@OK
  Mov   GrResult, GrInit
  Jmp   @@Done
@@OK:
  Mov   GrResult, GrOK
  Mov   AX, 013H
  Int   010H

  Mov   DX, Misc_output_Addr
  Mov   AL, 0E3h                { 480 линий на экране; 2 линии дублируются }
  Out   DX, AL                  { по умолчанию,- т.е. остается 240 линий }
  Mov   DX, Seq_Addr
  Mov   AX, 0604h
  Out   DX, AX
  Mov   DX, CRTC_Addr
  Mov   AX, 0E317h
  Out   DX, AX
  Mov   AX, 0014h
  Out   DX, AX
  Mov   AX, 2C11h
  Out   DX, AX
  Mov   AX, 0D06h
  Out   DX, AX
  Mov   AX, 3E07h
  Out   DX, AX
  Mov   AX, 0EA10h
  Out   DX, AX
  Mov   AX, 0AC11h
  Out   DX, AX
  Mov   AX, 0DF12h
  Out   DX, AX
  Mov   AX, 0E715h
  Out   DX, AX
  Mov   AX, 0616h
  Out   DX, AX

  Mov   DX, Seq_Addr
  Mov   AX, 0F02h
  Out   DX, AX                  { Выбрали все 4 плоскости }
  Mov   AX, SegA000
  Mov   ES, AX
  Xor   DI, DI
  Mov   CX, 320*240/8
  Xor   AX, AX
  CLD
  Rep   STOSW                   { Очистили экран - сделали черным }
  Mov   XActiveOffset, CX       { Текущая и видимая -   }
  Mov   XVisibleOffset, CX      { самая первая страница }
  Mov   DX, CRTC_Addr
  Mov   AX, 000Ch
  Out   DX, AX
  Inc   AL
  Out   DX, AX                  { Теперь по-настоящему она видимая }
@@Done:
End;

Procedure CloseGraphX; Assembler;
Asm
  Mov   AX, 003H
  Int   010H
End;

Procedure Border (Color : Byte); Assembler;
Asm
  Mov   AX, 01001H
  Mov   BH, Color
  Int   010H
End;

Procedure SetLogicalWidthX (Width : Byte); Assembler;   { 40 ... 40*3 }
Asm
  Mov   AH, Width
  Mov   XBytesPerLine, AH
  Mov   DX, CRTC_Addr
  Mov   AL, 13h
  Out   DX, AX
End;

Procedure ClearScreenX (Color : Byte); Assembler;
Asm
  Mov   DX, Seq_Addr
  Mov   AX, 0F02h
  Out   DX, AX
  Mov   AX, SegA000
  Mov   ES, AX
  Mov   DI, XActiveOffset
  Mov   CX, 320*240/8
  Mov   AL, Color
  Mov   AH, AL
  CLD
  Rep   STOSW
End;

Procedure ClearAllPagesX (Color : Byte);
Var X, Z : Word;
Begin
  X := XActiveOffset;
  For Z := 0 to 3 do Begin
    SetActivePageX (Z);
    ClearScreenX (Color)
  End;
  XActiveOffset := X
End;

Procedure SetActivePageX (Page : Byte); Assembler;      { Page = 0,1,2 }
Asm
  Mov   AL, Page
  CBW
  Mov   BX, 320/4 * 240         { Mul L/4 * H }
  Mul   BX
  Mov   XActiveOffset, AX
End;

Procedure SetVisibleOffsetX (Offs : Word); Assembler;
Asm
  Mov   AX, Offs
  Mov   XVisibleOffset, AX
  Mov   DX, CRTC_Addr
  Mov   AH, Byte Ptr Offs+1
  Mov   AL, 0Ch
  Out   DX, AX
  Mov   AH, Byte Ptr Offs
  Inc   AL
  Out   DX, AX
End;

Procedure SetVisiblePageX (Page : Byte);                { Page = 0,1,2 }
Begin
  Asm
    Mov   AL, Page
    CBW
    Mov   BX, 320/4 * 240         { Mul L/4 * H }
    Mul   BX
    Mov   XVisibleOffset, AX
  End;
  SetVisibleOffsetX (XVisibleOffset)
End;

Procedure PutPixelX (X, Y : Word; Color : Byte); Assembler;
Asm
  MOV   AX, Y                   { Get the row. }
  XOR   BH, BH
  MOV   BL, XBytesPerLine       { Get number of bytes per line. }
  MUL   BX                      { Mul this with the y-coordinate. }
  SHL   AX, 1                   { Result times 2. }
  MOV   BX, AX                  { Save this. }
  MOV   AX, X                   { Get the x-coordinate. }
  MOV   CX, AX                  { Save this. }
  SHR   AX, 2                   { DIV by 4. }
  ADD   BX, AX                  { Add this to the y. }
  ADD   BX, XActiveOffset       { Add the screen offset. }
  AND   CX, 00000011b           { This will do x MOD 4. }
  MOV   AH, 1
  SHL   AH, CL
  MOV   DX, Seq_Addr
  MOV   AL, 2
  OUT   DX, AX
  MOV   AX, SegA000
  MOV   ES, AX
  MOV   AL, color
  MOV   ES:[BX], AL
End;

Function GetPixelX (X, Y : Word) : Byte; Assembler;
Asm
  MOV   AX, Y                   { Get the row. }
  XOR   BH, BH
  MOV   BL, XBytesPerLine       { Get number of bytes per line. }
  MUL   BX                      { Mul this with the y-coordinate. }
  SHL   AX, 1                   { Result times 2. }
  MOV   BX, AX                  { Save this. }
  MOV   AX, X                   { Get the x-coordinate. }
  MOV   CX, AX                  { Save this. }
  SHR   AX, 2                   { DIV by 4. }
  ADD   BX, AX                  { Add this to the y. }
  ADD   BX, XActiveOffset       { Add the screen offset. }
  AND   CX, 00000011b           { This will do x MOD 4. }
  MOV   AH, CL
  MOV   DX, Graph_Cntrl_Addr
  MOV   AL, 4
  OUT   DX, AX
  MOV   AX, SegA000
  MOV   ES, AX
  MOV   AL, ES:[BX]
End;

Procedure LineHX (X, Y, L : integer; Color : Byte); Assembler;
Asm
  CLD
  Mov   AX, SegA000
  Mov   ES, AX
  Mov   AX, Y
  Xor   BH, BH
  Mov   BL, XBytesPerLine
  Mul   BX
  Mov   DX, Seq_Addr            { DX = Sequencer port no }
  Mov   DI, AX
  Add   DI, AX
  Mov   AX, X
  Shr   AX, 2
  Add   DI, AX                  { ES:DI = ^Screen - left point }
  Mov   CX, L
  Mov   BX, X
  And   BX, 3
  Sub   BX, 4
  Neg   BX
  And   BX, 3                   { BX = left part points count }
  JZ    @noleft
  Mov   SI, L
  Sub   SI, BX                  { Bad difference of left part and length }
  JC    @bad
  Xor   SI, SI
@bad:
  Neg   SI
  Mov   AL, 0F0h
  Mov   CL, BL
  Shr   AL, CL
  And   AL, 0Fh
  Mov   CX, SI
  JCXZ  @ok
  Shl   AL, CL
  And   AL, 0Fh
  Shr   AL, CL
  Sub   BX, SI                  { Difference corrected }
@ok:
  Mov   AH, AL
  Mov   AL, 2
  Out   DX, AX
  Mov   AL, Color
  STOSB
@noleft:
  Mov   SI, L
  Sub   SI, BX
  And   SI, 3                   { SI = right part points count }
  Mov   CX, L
  Sub   CX, BX
  Sub   CX, SI
  JZ    @nomiddle
  Mov   AX, 0F02h
  Out   DX, AX
  Shr   CX, 2
  Mov   AL, Color
  Rep   STOSB
@nomiddle:
  Or    SI, SI
  JZ    @noright
  Mov   AX, 0F0h
  Mov   CX, SI
  Shl   AX, CL
  Mov   AL, 2
  Out   DX, AX
  Mov   AL, Color
  STOSB
@noright:
End;

Procedure LineVX (X, Y, H : integer; Color : Byte); Assembler;
Asm
  CLD
  Mov   AX, SegA000
  Mov   ES, AX
  Mov   AX, Y
  Xor   BH, BH
  Mov   BL, XBytesPerLine
  Mul   BX
  Mov   DI, AX
  Add   DI, AX
  Mov   AX, X
  Mov   CX, AX
  Shr   AX, 2
  Add   DI, AX                  { ES:DI = ^Screen - left point }
  Mov   DX, Seq_Addr            { DX = Sequencer port no }
  And   CX, 3
  Mov   AX, 0102h
  Shl   AH, CL
  Out   DX, AX
  Add   BX, BX
  Dec   BX
  Mov   CX, H
  Mov   AL, Color
@cycle:
  STOSB
  Add   DI, BX
  Loop  @cycle
End;

Procedure BoxX (X, Y, L, H : Word; Color : Byte; Fill : Boolean);
Begin
  If L or H = 0 then Exit;
  If not Fill then
    Begin
      LineHX (X, Y, L, Color);
      LineHX (X, Y+H-1, L, Color);
      LineVX (X, Y, H, Color);
      LineVX (X+L-1, Y, H, Color)
    End
  Else
    Repeat
      LineHX (X, Y, L, Color);
      Inc (Y);
      Dec (H)
    Until H = 0
End;

Procedure LineX (X1, Y1, X2, Y2 : integer; Color : Byte);
Var
  SX, SY, M, N,
  DX1, DY1, DX2, DY2, Cnt, K : Integer;
Begin
  SX := X2-X1;
  SY := Y2-Y1;
  DX1 := Sgn (SX);
  DY1 := Sgn (SY);
  M := _Abs (SX);
  N := _Abs (SY);
  DX2 := DX1;
  DY2 := 0;
  If M < N then
    Begin
      M := _Abs (SY);
      N := _Abs (SX);
      DX2 := 0;
      DY2 := DY1
    End;
  Cnt := M+1;
  K := 0;
  Repeat
    PutPixelX (X1, Y1, Color);
    Inc (K, N);
    If K < M then Begin
      Inc (X1, DX2);
      Inc (Y1, DY2)
    End
    Else Begin
      Dec (K, M);
      Inc (X1, DX1);
      Inc (Y1, DY1)
    End;
    Dec (Cnt)
  Until Cnt = 0
End;

Procedure CircleX (X, Y, R : Word; Color : Byte; Fill : Boolean);
Var
  A, B : Word;
Begin
  If R = 0 then Exit;
  If not Fill then
    For A := 0 to R do
      Begin
        B := SqrWN(Sqr(R)-Sqr(A));
        PutPixelX (X-A, Y-B, Color);
        PutPixelX (X+A, Y-B, Color);
        PutPixelX (X-A, Y+B, Color);
        PutPixelX (X+A, Y+B, Color);
        PutPixelX (X-B, Y-A, Color);
        PutPixelX (X-B, Y+A, Color);
        PutPixelX (X+B, Y-A, Color);
        PutPixelX (X+B, Y+A, Color)
      End
  Else
    For A := 0 to R do
      Begin
        B := SqrWN(Sqr(R)-Sqr(A));
        LineHX (X-B, Y-A, 1+B shl 1, Color);
        LineHX (X-B, Y+A, 1+B shl 1, Color)
      End
End;

Procedure DrawPolyX (Num : Word; PolyPoints : Array of TPoint; Color : Byte);
Var I : Word;
Begin
  If Num > 1 then
    For I := 0 to Num-2 do Begin
      LineX (PolyPoints[I].X, PolyPoints[I].Y,
            PolyPoints[I+1].X, PolyPoints[I+1].Y, Color)
    End
End;

Procedure DrawPoly2X (Num : Word; PolyPoints : Array of TPoint; Color : Byte);
Var I : Word;
Begin
  If Num > 0 then Begin
    For I := 0 to Num-2 do Begin
      LineX (PolyPoints[I].X, PolyPoints[I].Y,
            PolyPoints[I+1].X, PolyPoints[I+1].Y, Color)
    End;
    LineX (PolyPoints[Num-1].X, PolyPoints[Num-1].Y,
          PolyPoints[0].X, PolyPoints[0].Y, Color)
  End
End;

Procedure FillPolyX (Num : Word; PolyPoints : Array of TPoint; Color : Byte);
Var I, Y, Ymin, Ymax : Integer;
  Procedure DoSide (X1, Y1, X2, Y2 : Integer);
  Var
    Temp, I, X, Y,
    SX, SY, M, N,
    DX1, DY1, DX2, DY2 : Integer;
  Begin
    SX := X2-X1; SY := Y2-Y1;
    DX1 := Sgn(SX); DY1 := Sgn(SY);
    M := _Abs(SX); N := _Abs(SY);
    DX2 := DX1; DY2 := 0;
    If M < N then Begin
      M := _Abs(SY); N := _Abs(SX);
      DX2 := 0; DY2 := DY1
    End;
    X := X1; Y := Y1;
    Temp := 0;
    For I := 0 to M do Begin
      If (Y >= ClipYmin) and (Y <= ClipYmax) then Begin
        If X < _Poly[Y,1] then _Poly[Y,1] := X;
        If X > _Poly[Y,2] then _Poly[Y,2] := X
      End;
      Inc (Temp, N);
      If Temp < M then Begin
        Inc (X, DX2); Inc (Y, DY2)
      End
      Else Begin
        Dec (Temp, M);
        Inc (X, DX1); Inc (Y, DY1)
      End
    End
  End;
Begin
  If Num < 3 then Exit;
  Ymin := PolyPoints[0].Y; Ymax := Ymin;
  For I := 0 to Num-1 do Begin
    If PolyPoints[I].Y < Ymin then Ymin := PolyPoints[I].Y;
    If PolyPoints[I].Y > Ymax then Ymax := PolyPoints[I].Y
  End;
  If (Ymin > ClipYmax) or (Ymax < ClipYmin) then Exit;
  If Ymin < ClipYmin then Ymin := ClipYmin;
  If Ymax > ClipYmax then Ymax := ClipYmax;
  For Y := Ymin to Ymax do Begin
    _Poly[Y,1] := ClipXmax+1; _Poly[Y,2] := ClipXmin-1
  End;
  For I := 0 to Num-2 do
    DoSide (PolyPoints[I].X, PolyPoints[I].Y,
            PolyPoints[I+1].X, PolyPoints[I+1].Y);
  DoSide (PolyPoints[Num-1].X, PolyPoints[Num-1].Y,
          PolyPoints[0].X, PolyPoints[0].Y);
  For Y := Ymin to Ymax do Begin
    If _Poly[Y,1] < ClipXmin then _Poly[Y,1] := ClipXmin;
    If _Poly[Y,2] > ClipXmax then _Poly[Y,2] := ClipXmax;
     LineHX (_Poly[Y,1], Y, _Poly[Y,2]-_Poly[Y,1]+1, Color)
  End
End;

Procedure FillPolyPatX (Num : Word; PolyPoints : Array of TPoint;
                                                L, H : Word; Var Pat);
Var
  I, X, Y, Ymin, Ymax : Integer;
  PA : Array [0..63999] of byte absolute Pat;
  Procedure DoSide (X1, Y1, X2, Y2 : Integer);
  Var
    Temp, I, X, Y,
    SX, SY, M, N,
    DX1, DY1, DX2, DY2 : Integer;
  Begin
    SX := X2-X1; SY := Y2-Y1;
    DX1 := Sgn(SX); DY1 := Sgn(SY);
    M := _Abs(SX); N := _Abs(SY);
    DX2 := DX1; DY2 := 0;
    If M < N then Begin
      M := _Abs(SY); N := _Abs(SX);
      DX2 := 0; DY2 := DY1
    End;
    X := X1; Y := Y1;
    Temp := 0;
    For I := 0 to M do Begin
      If (Y >= ClipYmin) and (Y <= ClipYmax) then Begin
        If X < _Poly[Y,1] then _Poly[Y,1] := X;
        If X > _Poly[Y,2] then _Poly[Y,2] := X
      End;
      Inc (Temp, N);
      If Temp < M then Begin
        Inc (X, DX2); Inc (Y, DY2)
      End
      Else Begin
        Dec (Temp, M);
        Inc (X, DX1); Inc (Y, DY1)
      End
    End
  End;
Begin
  If Num < 3 then Exit;
  Ymin := PolyPoints[0].Y; Ymax := Ymin;
  For I := 0 to Num-1 do Begin
    If PolyPoints[I].Y < Ymin then Ymin := PolyPoints[I].Y;
    If PolyPoints[I].Y > Ymax then Ymax := PolyPoints[I].Y
  End;
  If (Ymin > ClipYmax) or (Ymax < ClipYmin) then Exit;
  If Ymin < ClipYmin then Ymin := ClipYmin;
  If Ymax > ClipYmax then Ymax := ClipYmax;
  For Y := Ymin to Ymax do Begin
    _Poly[Y,1] := ClipXmax+1; _Poly[Y,2] := ClipXmin-1
  End;
  For I := 0 to Num-2 do
    DoSide (PolyPoints[I].X, PolyPoints[I].Y,
            PolyPoints[I+1].X, PolyPoints[I+1].Y);
  DoSide (PolyPoints[Num-1].X, PolyPoints[Num-1].Y,
          PolyPoints[0].X, PolyPoints[0].Y);
  For Y := Ymin to Ymax do Begin
    If _Poly[Y,1] < ClipXmin then _Poly[Y,1] := ClipXmin;
    If _Poly[Y,2] > ClipXmax then _Poly[Y,2] := ClipXmax;
    I := L * (Y mod H);
    For X := _Poly[Y,1] to _Poly[Y,2] do
      PutPixelX (X, Y, PA[I + (X mod 8)])
  End
End;

Procedure LoadFont (Name : String; Var PF : PFont; Var Size : Word);
Var
  F : File;
Label
  LErr;
Begin
  PF := nil;
  Assign (F, Name);
  {$i-}
  Reset (F, 1);
  {$i+}
  If IOResult <> 0 then
    Begin
LErr:
      If PF <> nil then
        FreeMem (PF, Size);
      PF := nil;
      Size := 0;
      GrResult := GrLoadFont;
      Exit
    End;
  {$i-} Size := FileSize(F); {$i+}
  If IOResult <> 0 then Goto LErr;
  GetMem (PF, Size);
  {$i-} BlockRead (F, PF^, Size); {$i+}
  If IOResult <> 0 then Goto LErr;
  {$i-} Close (F); {$i+}
  If IOResult <> 0 then Goto LErr;
  GrResult := GrOk
End;

Procedure SetFont (PF : PFont);
Begin
  FontX := Lo(Word(PF^));
  FontY := Hi(Word(PF^));
  CurFont := PF
End;

Procedure WriteCX (X, Y : Word; B, T : Byte; C : Char);
Var
  I, J : Word;
  P : ^Byte;
  D : Byte;
Begin
  P := CurFont;
  Inc (Word(P), 2 + (Ord(C) shl 3));
  For J := 0 to FontY-1 do Begin
    D := P^;
    For I := 0 to FontX-1 do Begin
      If D and $80 <> 0 then PutPixelX (X+I, Y+J, T)
      Else If B <> T then PutPixelX (X+I, Y+J, B);
      D := D shl 1
    End;
    Inc (Word(P))
  End
End;

Procedure WriteSX (X, Y : Word; B, T : Byte; S : String);
Var
  N  : Byte;
Begin
  If S = '' then Exit;
  For N := 1 to Length(S) do
    Begin
      WriteCX (X, Y, B, T, S[N]);
      Inc (X, FontX)
    End
End;

Procedure ReadSX (X, Y : Word; B, T : Byte; Var S : String; N : Byte);
Const
  CM = 20;
Var
  C : Char;
  P : Byte;
  Cnt : Byte;
Begin
  BoxX (X, Y, N*FontX, FontY, B, True);
  WriteSX (X, Y, B, T, S);
  P := Length(S);
  If P < N then
    WriteCX (X+P*FontX, Y, B, T, '_');
  Cnt := 0;
  Repeat
    If KeyPressed then C := ReadKey
    Else C := #$FF;
    If C = #0 then
      Begin
        ReadKey;
        C := #$FF
      End;
    If C = #27 then
      Begin
        S := '';
        Break
      End;
    If C = #13 then Break;
    If (C = #8) and (P > 0) then
      Begin
        Dec (S[0]);
        If P < N then
          WriteCX (X+P*FontX, Y, B, T, ' ');
        Dec (P);
        WriteCX (X+P*FontX, Y, B, T, '_');
        Continue
      End;
    If (C in [#32..#254]) and (P < N) then
      Begin
        S := S + C;
        WriteCX (X+P*FontX, Y, B, T, C);
        Inc (P);
        If P < N then
          WriteCX (X+P*FontX, Y, B, T, '_')
      End;
      Delay (20);
      Inc (Cnt);
      If Cnt = CM then Cnt := 0;
      If P < N then
        If Cnt < CM div 2 then
          WriteCX (X+P*FontX, Y, B, T, '_')
        Else
          WriteCX (X+P*FontX, Y, B, T, ' ')
  Until False
End;

Function ImageSizeX (L, H : Word) : Word;
Begin
  ImageSizeX := 4+L*H
End;

Procedure GetImageX (X, Y, L, H : Word; Var BitMap); Assembler;
Var
  DeltaY : Word;
Asm
  Push  DS
  Mov   AX, Y
  Xor   BH, BH
  Mov   BL, XBytesPerLine
  Add   BX, BX
  Mov   DeltaY, BX
  Mul   BX
  Mov   SI, AX
  Mov   AX, X
  Mov   CL, AL
  Shr   AX, 2
  Add   SI, AX
  Add   SI, XActiveOffset
  Mov   DS, SegA000                     { DS:SI = ^Screen }
  LES   DI, BitMap                      { ES:DI = ^BitMap }
  Mov   AX, L
  Mov   ES:[DI], AX                     { Save length to the BitMap }
  Mov   AX, H
  Mov   ES:[DI+2], AX                   { Save height to the BitMap }
  Add   DI, 4
  CLD
  Mov   DX, Graph_Cntrl_Addr
  Mov   AH, CL
  And   AH, 3                           { AH = Plane no }
  Mov   CX, H
@cycle1:
  Mov   BX, L
  Push  AX
  Push  SI
@cycle2:
  Mov   AL, 4
  Out   DX, AX                          { Select plane }
  Mov   AL, DS:[SI]
  STOSB
  Inc   AH
  And   AH, 3
  JNZ   @noinc
  Inc   SI                              { Next byte because plane 0 }
@noinc:
  Dec   BX
  JNZ   @cycle2
  Pop   SI
  Add   SI, DeltaY
  Pop   AX
  Loop  @cycle1
  Pop   DS
End;

Procedure PutImageX (X, Y : Word; Var BitMap); Assembler;
Var
  DeltaY,
  L : Word;
Asm
  Push  DS
  Mov   AX, Y
  Xor   BH, BH
  Mov   BL, XBytesPerLine
  Add   BX, BX
  Mov   DeltaY, BX
  Mul   BX
  Mov   DI, AX
  Mov   AX, X
  Mov   CL, AL
  Shr   AX, 2
  Add   DI, AX
  Add   DI, XActiveOffset
  Mov   ES, SegA000                     { ES:DI = ^Screen }
  LDS   SI, BitMap                      { DS:SI = ^BitMap }
  Mov   AX, DS:[SI]
  Mov   L, AX
  CLD
  Mov   DX, Seq_Addr
  And   CL, 3
  Mov   AH, 1
  Shl   AH, CL                          { AH = Plane mask }
  Mov   CX, DS:[SI+2]
  Add   SI, 4
@cycle1:
  Mov   BX, L
  Push  AX
  Push  DI
@cycle2:
  Mov   AL, 2
  Out   DX, AX                          { Select plane }
  LODSB
  Mov   ES:[DI], AL
  Add   AH, AH
  And   AH, 0Fh
  JNZ   @noinc
  Inc   AH                              { Plane 0 }
  Inc   DI                              { Next byte because plane 0 }
@noinc:
  Dec   BX
  JNZ   @cycle2
  Pop   DI
  Add   DI, DeltaY
  Pop   AX
  Loop  @cycle1
  Pop   DS
End;

Procedure PutTranspImageX (X, Y : Word; Var BitMap); Assembler;
Var
  DeltaY,
  L : Word;
  Transparent : Byte;
Asm
  Mov   AL, TranspColor
  Mov   Transparent, AL
  Push  DS
  Mov   AX, Y
  Xor   BH, BH
  Mov   BL, XBytesPerLine
  Add   BX, BX
  Mov   DeltaY, BX
  Mul   BX
  Mov   DI, AX
  Mov   AX, X
  Mov   CL, AL
  Shr   AX, 2
  Add   DI, AX
  Add   DI, XActiveOffset
  Mov   ES, SegA000                     { ES:DI = ^Screen }
  LDS   SI, BitMap                      { DS:SI = ^BitMap }
  Mov   AX, DS:[SI]
  Mov   L, AX
  CLD
  Mov   DX, Seq_Addr
  And   CL, 3
  Mov   AH, 1
  Shl   AH, CL                          { AH = Plane mask }
  Mov   CX, DS:[SI+2]
  Add   SI, 4
@cycle1:
  Mov   BX, L
  Push  AX
  Push  DI
@cycle2:
  Mov   AL, 2
  Out   DX, AX                          { Select plane }
  LODSB
  Cmp   AL, Transparent
  JE    @transp
  Mov   ES:[DI], AL
@transp:
  Add   AH, AH
  And   AH, 0Fh
  JNZ   @noinc
  Inc   AH                              { Plane 0 }
  Inc   DI                              { Next byte because plane 0 }
@noinc:
  Dec   BX
  JNZ   @cycle2
  Pop   DI
  Add   DI, DeltaY
  Pop   AX
  Loop  @cycle1
  Pop   DS
End;

Procedure PutImagePartX (X, Y : Word; Var BitMap; PX, PY, PL, PH : Word); Assembler;
Var
  DeltaY,
  Skip : Word;
Asm
  Push  DS
  Mov   AX, Y
  Xor   BH, BH
  Mov   BL, XBytesPerLine
  Add   BX, BX
  Mov   DeltaY, BX
  Mul   BX
  Mov   DI, AX
  Mov   AX, X
  Mov   CL, AL
  Shr   AX, 2
  Add   DI, AX
  Add   DI, XActiveOffset
  Mov   ES, SegA000                     { ES:DI = ^Screen }
  LDS   SI, BitMap                      { DS:SI = ^BitMap }
  Mov   BX, DS:[SI]
  Mov   Skip, BX
  Mov   AX, PY
  Mul   BX
  Add   SI, AX
  Add   SI, PX
  Add   SI, 4                           { DS:SI = corrected ^BitMap }
  CLD
  Mov   DX, Seq_Addr
  And   CL, 3
  Mov   AH, 1
  Shl   AH, CL                          { AH = Plane mask }
  Mov   CX, PH
@cycle1:
  Mov   BX, PL
  Push  AX
  Push  SI
  Push  DI
@cycle2:
  Mov   AL, 2
  Out   DX, AX                          { Select plane }
  LODSB
  Mov   ES:[DI], AL
  Add   AH, AH
  And   AH, 0Fh
  JNZ   @noinc
  Inc   AH                              { Plane 0 }
  Inc   DI                              { Next byte because plane 0 }
@noinc:
  Dec   BX
  JNZ   @cycle2
  Pop   DI
  Add   DI, DeltaY
  Pop   SI
  Add   SI, Skip
  Pop   AX
  Loop  @cycle1
  Pop   DS
End;

Procedure PutTranspImagePartX (X, Y : Word; Var BitMap; PX, PY, PL, PH : Word); Assembler;
Var
  DeltaY,
  Skip : Word;
  Transparent : Byte;
Asm
  Mov   AL, TranspColor
  Mov   Transparent, AL
  Push  DS
  Mov   AX, Y
  Xor   BH, BH
  Mov   BL, XBytesPerLine
  Add   BX, BX
  Mov   DeltaY, BX
  Mul   BX
  Mov   DI, AX
  Mov   AX, X
  Mov   CL, AL
  Shr   AX, 2
  Add   DI, AX
  Add   DI, XActiveOffset
  Mov   ES, SegA000                     { ES:DI = ^Screen }
  LDS   SI, BitMap                      { DS:SI = ^BitMap }
  Mov   BX, DS:[SI]
  Mov   Skip, BX
  Mov   AX, PY
  Mul   BX
  Add   SI, AX
  Add   SI, PX
  Add   SI, 4                           { DS:SI = corrected ^BitMap }
  CLD
  Mov   DX, Seq_Addr
  And   CL, 3
  Mov   AH, 1
  Shl   AH, CL                          { AH = Plane mask }
  Mov   CX, PH
@cycle1:
  Mov   BX, PL
  Push  AX
  Push  SI
  Push  DI
@cycle2:
  Mov   AL, 2
  Out   DX, AX                          { Select plane }
  LODSB
  Cmp   AL, Transparent
  JE    @transp
  Mov   ES:[DI], AL
@transp:
  Add   AH, AH
  And   AH, 0Fh
  JNZ   @noinc
  Inc   AH                              { Plane 0 }
  Inc   DI                              { Next byte because plane 0 }
@noinc:
  Dec   BX
  JNZ   @cycle2
  Pop   DI
  Add   DI, DeltaY
  Pop   SI
  Add   SI, Skip
  Pop   AX
  Loop  @cycle1
  Pop   DS
End;

Procedure PutClippedImageX (X, Y : Integer; Var BitMap);
Var
  Dims : Array [0..1] of Word absolute BitMap; {Dims[0]=Length;Dims[1]=Height}
  RX, RY, RL, RH, IX, IY : Integer;
Begin
  If (X > ClipXmax) or (Y > ClipYmax) then Exit;{ Image is out of screen }
  RX := X; RY := Y;                             { Start X & Y at screen }
  RL := Dims[0]; RH := Dims[1];                 { Length & Height at begining }
  IX := 0; IY := 0;                             { IX & IY - coos in image to }
                                                { start drawing it (at begining) }
  If RX < ClipXmin then Begin
    Dec (RL, ClipXmin-RX);                      { Output length corrected }
    Inc (IX, ClipXmin-RX);                      { IX corrected }
    RX := ClipXmin                              { Screen X corrected }
  End;
  If RY < ClipYmin then Begin
    Dec (RH, ClipYmin-RY);                      { Output height corrected }
    Inc (IY, ClipYmin-RY);                      { IY corrected }
    RY := ClipYmin                              { Screen Y corrected }
  End;
  If (RL <= 0) or (RH <= 0) then Exit;          { Image is out of screen }
  If RX+RL > ClipXmax+1 then RL := ClipXmax+1-RX;{ Last correct in a length }
  If RY+RH > ClipYmax+1 then RH := ClipYmax+1-RY;{ Last correct in a height }
  PutImagePartX (RX, RY, BitMap, IX, IY, RL, RH){ Drawing clipped image... }
End;

Procedure PutTranspClippedImageX (X, Y : Integer; Var BitMap);
Var
  Dims : Array [0..1] of Word absolute BitMap; {Dims[0]=Length;Dims[1]=Height}
  RX, RY, RL, RH, IX, IY : Integer;
Begin
  If (X > ClipXmax) or (Y > ClipYmax) then Exit;{ Image is out of screen }
  RX := X; RY := Y;                             { Start X & Y at screen }
  RL := Dims[0]; RH := Dims[1];                 { Length & Height at begining }
  IX := 0; IY := 0;                             { IX & IY - coos in image to }
                                                { start drawing it (at begining) }
  If RX < ClipXmin then Begin
    Dec (RL, ClipXmin-RX);                      { Output length corrected }
    Inc (IX, ClipXmin-RX);                      { IX corrected }
    RX := ClipXmin                              { Screen X corrected }
  End;
  If RY < ClipYmin then Begin
    Dec (RH, ClipYmin-RY);                      { Output height corrected }
    Inc (IY, ClipYmin-RY);                      { IY corrected }
    RY := ClipYmin                              { Screen Y corrected }
  End;
  If (RL <= 0) or (RH <= 0) then Exit;          { Image is out of screen }
  If RX+RL > ClipXmax+1 then RL := ClipXmax+1-RX;{ Last correct in a length }
  If RY+RH > ClipYmax+1 then RH := ClipYmax+1-RY;{ Last correct in a height }
  PutTranspImagePartX (RX, RY, BitMap, IX, IY, RL, RH){ Drawing clipped image... }
End;

Procedure LoadPCX256 (Name : String; Var PBitMap : Pointer; Var Size : Word;
                      Var Pal : TPal);
Var
  Hd : TPCXHeader;
  F : File;
  L, H : Word;
  PFBuf, Temp : Pointer;
  Sz : Word;
Label LErr;
Begin
  GrResult := GrOk;
  Temp := nil;
  Assign (F, Name);
  {$I-} Reset (F, 1); {$I+}
  If IOResult <> 0 then Begin
LErr:
    If Temp <> nil then FreeMem (Temp, Size);
    GrResult := GrLoadObj;
    PBitMap := nil;
    Size := 0;
    Exit
  End;
  {$I-} BlockRead (F, Hd, 128); {$I+}           { Load header }
  If IOResult <> 0 then Goto LErr;
  If (Hd.BitsPerPixel <> 8) or (Hd.Planes <> 1) then Goto LErr;
  L := Hd.X2 - Hd.X1 + 1;
  H := Hd.Y2 - Hd.Y1 + 1;
  Size := 4 + L*H;
  If Size > 64004 then Goto LErr;               { If not in the range }
  GetMem (Temp, Size);                          { Allocate memory for unpacked bitmap }
  {$I-} Seek (F, FileSize(F)-768); {$I+}
  If IOResult <> 0 then Goto LErr;
  {$I-} BlockRead (F, Pal, 768); {$I+}          { Load palette part }
  If IOResult <> 0 then Goto LErr;
  {$I-} Seek (F, 128); {$I+}
  If IOResult <> 0 then Goto LErr;
  Sz := FileSize(F)-896;
  GetMem (PFBuf, Sz);                           { Allocate memory for file buffer }
  {$I-} BlockRead (F, PFBuf^, Sz); {$I+}        { Load picture body }
  If IOResult <> 0 then Begin
    FreeMem (PFBuf, Sz);
    Goto LErr
  End;
  {$I-} Close (F); {$I+}
  If IOResult <> 0 then Begin
    FreeMem (PFBuf, Sz);
    Goto LErr
  End;
  Asm
    Push  DS
    Mov   SI, Word Ptr Pal;
    Mov   DI, SI
    Mov   AX, Word Ptr Pal+2;
    Mov   DS, AX
    Mov   ES, AX
    Mov   CX, 768
    CLD
@loop:
    LODSB
    Shr   AL, 2                                 { Normalizing palette }
    STOSB
    Loop  @loop
    Pop   DS
  End;
  Asm
    Push  DS
    Push  BP
    LES   DI, Temp                      { ES:DI = ^ unpacking buffer }
    CLD
    Mov   AX, L                         { Picture length stored to memory }
    STOSW
    Push  AX                            { Local constant L }
    Mov   AX, H
    STOSW                               { Picture height stored to memory }
    Mov   BX, H
    Push  Hd.BytesPerLine               { Local constant Hd.BytesPerLine }
    LDS   SI, PFBuf                     { DS:SI = ^ file buffer with packed pic }
    Mov   BP, SP                        { Pointer to the local constants }
    Xor   CH, CH                        { Hi byte of repeat counter,always 0 }
    Xor   DX, DX                        { Written pixels counter }
@cyc:
    LODSB
    Cmp   AL, 0C0h
    JNC   @repeat                       { If need to repeat pixel }
    Cmp   DX, SS:[BP+2]
    JNC   @1                            { If run off the line }
    STOSB                               { Writing if all right }
@1:
    Inc   DX
    Jmp   @next
@repeat:
    And   AL, 3Fh
    Mov   CL, AL                        { CX = repeat count }
    Add   DX, CX
    LODSB                               { AL = repeated pixel (color) }
    Cmp   DX, SS:[BP+2]
    JG    @2                            { If run off the line }
    Rep   STOSB                         { Writing if all right }
    Jmp   @next
@2:
    Add   CX, SS:[BP+2]
    Sub   CX, DX                        { CX = corrected repeat count }
    Rep   STOSB
@next:
    Cmp   DX, SS:[BP]
    JNE   @cyc                          { Line isn't done }
    Xor   DX, DX
    Dec   BX
    JNZ   @cyc                          { Going to the next line }
    Add   SP, 4                         { Remove local constants from stack }
    Pop   BP                            { Restore original BP }
    Pop   DS                            { Restore original DS }
  End;
  FreeMem (PFBuf, Sz);                  { Deallocating file buffer }
  PBitMap := Temp                       { Returning address of our bitmap }
End;

Procedure SavePCX256 (Name : String; VSegA, X, Y, L, H : Word);
Const
  Z : Byte = 12;
Var
  F : File;
  Hd : TPCXHeader;
  Pal,
  Buf : Array [0..767] of Byte;
  J, Cnt,
  Len : Word;
  Rep, B : Byte;
  PLeft, P : ^Byte;
Label
  LErr;
Begin
  FillChar (Hd, SizeOf(Hd), 0);
  Hd.X1 := 0; Hd.Y1 := 0; Hd.X2 := L-1; Hd.Y2 := H-1;
  Hd.Manufact := 10; Hd.Ver := 5; Hd.Encoding := 1;
  Hd.BitsPerPixel := 8; Hd.Planes := 1; Hd.PalInfo := 1;
  Hd.BytesPerLine := L + (L and 1);
  Assign (F, Name);
  {$I-} Rewrite (F, 1); {$I+}
  If IOResult <> 0 then Begin
LErr:
    GrResult := GrSaveObj;
    Exit
  End;
  {$I-} BlockWrite (F, Hd, SizeOf(Hd)); {$I+}
  If IOResult <> 0 then Begin
    {$I-} Close (F); {$I+}
    Goto LErr
  End;
  PLeft := Ptr (VSegA, Y*320+X);
  For J := 0 to H-1 do Begin
    Cnt := 0;
    Len := 0;
    P := PLeft;
    Repeat
      B := P^; Inc (Word(P)); Inc (Cnt);
      Rep := 1;
      While (B = P^) and (Rep < 63) and (Cnt < L) do Begin
        Inc (Rep);
        Inc (Cnt);
        Inc (Word(P))
      End;
      If Rep > 1 then Begin
        Buf[Len] := $C0 or Rep;
        Buf[Len+1] := B;
        Inc (Len, 2)
      End
      Else Begin
        If B >= $C0 then Begin
          Buf[Len] := $C1; Inc (Len)
        End;
        Buf[Len] := B;
        Inc (Len)
      End
    Until Cnt = L;
    Buf[Len] := 0;
    {$I-} BlockWrite (F, Buf, Len + (L and 1)); {$I+}
    If IOResult <> 0 then Begin
      {$I-} Close (F); {$I+}
      Goto LErr
    End;
    Inc (Word(PLeft), 320)
  End;
  BlockWrite (F, Z, 1);
  GetPal (Pal);
  For J := 0 to 767 do Pal[J] := Pal[J] shl 2;
  BlockWrite (F, Pal, 768);
  Close (F)
End;

Procedure WaitRetrace; Assembler;
  { This waits until you are in a Verticle Retrace ... this means that all
    screen manipulation you do only appears on screen in the next verticle
    retrace ... this removes most of the "fuzz" that you see on the screen
    when changing the pallette. It unfortunately slows down your program
    by "synching" your program with your monitor card ... it does mean
    that the program will run at almost the same speed on different
    speeds of computers which have similar monitors. In our SilkyDemo,
    we used a WaitRetrace, and it therefore runs at the same (fairly
    fast) speed when Turbo is on or off. }

Label
  L1, L2;
Asm
    Mov DX, 3DAH
L1:
    In AL,DX
    And AL,08H
    JNZ L1
L2:
    In AL,DX
    And AL,08H
    JZ  L2
End;

Procedure GetCRGB (C : Byte; Var R, G, B : Byte);
Begin
  Port[$3C7] := C;
  R := Port[$3C9];
  G := Port[$3C9];
  B := Port[$3C9]
End;

Procedure SetCRGB (C : Byte; R, G, B : Byte);
Begin
  Port[$3C8] := C;
  Port[$3C9] := R;
  Port[$3C9] := G;
  Port[$3C9] := B
End;

Procedure GetPal (Var Pal); Assembler;
Asm
  LES   DI, Pal
  Mov   CX, 768
  CLD
  Mov   DX, 3C7h
  Xor   AL, AL
  Out   DX, AL
  Inc   DX
  Inc   DX
  Rep   InSB
End;

Procedure SetPal (Var Pal); Assembler;
Asm
  Mov   BX, DS
  LDS   SI, Pal
  Mov   CX, 768
  CLD
  Mov   DX, 3C8h
  Xor   AL, AL
  Out   DX, AL
  Inc   DX
  Rep   OutSB
  Mov   DS, BX
End;

Procedure FadeUp (Pal : TPal);
Var
  Cnt, C,
  R, G, B : Byte;
Begin
  For Cnt := 0 to 63 do
    Begin
      WaitRetrace;
      For C := 0 to 255 do
        Begin
          GetCRGB (C, R, G, B);
          If 64-Cnt <= Pal[C,1]-R then
            Inc (R);
          If 64-Cnt <= Pal[C,2]-G then
            Inc (G);
          If 64-Cnt <= Pal[C,3]-B then
            Inc (B);
          SetCRGB (C, R, G, B)
        End
    End
End;

Procedure FadeDown;
Var
  Cnt, C,
  R, G, B : Byte;
Begin
  For Cnt := 0 to 63 do
    Begin
      WaitRetrace;
      For C := 0 to 255 do
        Begin
          GetCRGB (C, R, G, B);
          If R > 0 then Dec (R);
          If G > 0 then Dec (G);
          If B > 0 then Dec (B);
          SetCRGB (C, R, G, B)
        End
    End
End;

Procedure BlackOutPut;
Var C : Byte;
Begin
  For C := 0 to 255 do
    SetCRGB (C, 0, 0, 0)
End;

Procedure DisplayOff; Assembler;
Asm
  CLI
  Mov   DX, Seq_Addr
  Mov   AL, 1
  Out   DX, AL
  Inc   DX
  In    AL, DX
  Or    AL, 20h
  Mov   AH, AL
  Mov   AL, 1
  Dec   DX
  Out   DX, AX
  STI
End;

Procedure DisplayOn; Assembler;
Asm
  CLI
  Mov   DX, Seq_Addr
  Mov   AL, 1
  Out   DX, AL
  Inc   DX
  In    AL, DX
  And   AL, 0DFh
  Mov   AH, AL
  Mov   AL, 1
  Dec   DX
  Out   DX, AX
  STI
End;

Function MouseFound : Boolean;
Var
  R : Registers;
Begin
  R.AX := 0;
  Intr ($33, R);
  MouseFound := R.AX = $FFFF
End;

Procedure GetImageMX (X, Y : Integer);
{ Используется исключительно для сохранения изображения под указателем мыши }
Var
  DX, DY, Delta : Integer;
Begin
  DX := X - MouseXmin;
  DY := Y - MouseYmin;
  If DX < 0 then
    X := MouseXmin;
  If DY < 0 then
    Y := MouseYmin;
  GetImageX (X, Y, 16, 16, MouseArea);
  Delta := 0;
  If DY < 0 then Dec (Delta, DY shl 4);
  If DX < 0 then Dec (Delta, DX);
  If Delta > 0 then Asm
    LEA   DI, MouseArea+4+256-1
    Mov   SI, DI
    Sub   SI, Delta
    Mov   AX, DS
    Mov   ES, AX
    Mov   CX, 256
    Sub   CX, Delta
    STD
    Rep   MOVSB
  End;
End;

Procedure MouseShow;
Var X : Byte;
Begin
  If not MousePresent then Exit;
  If MouseVisibl then Exit;
  GetImageMX (MouseX-MouseXhot, MouseY-MouseYhot);
  X := TranspColor; TranspColor := 0;
  PutTranspClippedImageX (MouseX-MouseXhot, MouseY-MouseYhot, MouseImage);
  TranspColor := X;
  MouseVisibl := True
End;

Procedure MouseHide;
Var X : Byte;
Begin
  If not MousePresent then Exit;
  If not MouseVisibl then Exit;
  X := TranspColor; TranspColor := 0;
  PutClippedImageX (MouseX-MouseXhot, MouseY-MouseYhot, MouseArea);
  TranspColor := X;
  MouseVisibl := False
End;

Function MousePressed : Boolean;
Begin
  MousePressed := MouseButtons and 3 <> 0
End;

Function MouseIn (X, Y, L, H : Word) : Boolean;
Begin
  MouseIn := (MouseX >= X) and (MouseY >= Y) and
             (MouseX < X+L) and (MouseY < Y+H)
End;

Function MouseVisible : Boolean;
Begin
  MouseVisible := MouseVisibl
End;

Procedure MouseUpdate (X0, Y0 : Integer);
Var X : Byte;
Begin
  If not MouseVisibl then Exit;
  X := TranspColor; TranspColor := 0;
  PutClippedImageX (X0-MouseXhot, Y0-MouseYhot, MouseArea);
  GetImageMX (MouseX-MouseXhot, MouseY-MouseYhot);
  PutTranspClippedImageX (MouseX-MouseXhot, MouseY-MouseYhot, MouseImage);
  TranspColor := X
End;

Procedure VirtualSupport;
Begin
  If not MousePresent then Exit;
  While MouseX >= XVirtualScreenX+320 do Begin
    Inc (XVirtualScreenX, 4);
    SetVisibleOffsetX (XVisibleOffset+1)
  End;
  While MouseX < XVirtualScreenX do Begin
    Dec (XVirtualScreenX, 4);
    SetVisibleOffsetX (XVisibleOffset-1)
  End;
  While MouseY >= XVirtualScreenY+240 do Begin
    Inc (XVirtualScreenY, 4);
    SetVisibleOffsetX (XVisibleOffset+(XBytesPerLine shl 3))
  End;
  While MouseY < XVirtualScreenY do Begin
    Dec (XVirtualScreenY, 4);
    SetVisibleOffsetX (XVisibleOffset-(XBytesPerLine shl 3))
  End
End;

Procedure MouseMoveTo (X, Y : Word);
Var X0, Y0 : Word;
Begin
  If not MousePresent then Exit;
  X0 := MouseX; Y0 := MouseY;
  MouseX := X; MouseY := Y;
  If XVirtualScreenMode then VirtualSupport;
  MouseUpdate (X0, Y0)
End;

{$F+}
Procedure MouseHandler; Assembler;
Asm
  PushF
  PushA
  Push  DS
  Mov   AX, Seg MouseButtons
  Mov   DS, AX                  { load data segment into DS register }

  Mov   MouseButtons, BL        { Save buttons state }
  Mov   AX, 0Bh
  Int   33h                     { get deltas in mickey after last read fn calling }
  Mov   AX, MouseX
  Mov   BX, MouseY
  Mov   SI, AX                  { X0 }
  Mov   DI, BX                  { Y0 }
  Sar   CX, 1                   { Speed down: }
  Sar   DX, 1                   { Speed=Speed/2 }
  Add   MouseX, CX
  Add   MouseY, DX

  Mov   AX, MouseX
  Mov   BX, MouseY
@1:
  Cmp   AX, MouseXmin
  JNS   @2                      { MouseX >= MouseXmin }
  Mov   AX, MouseXmin
@2:
  Cmp   MouseXmax, AX
  JNS   @3                      { MouseXmax >= MouseX }
  Mov   AX, MouseXmax

@3:
  Cmp   BX, MouseYmin
  JNS   @4                      { MouseY >= MouseYmin }
  Mov   BX, MouseYmin
@4:
  Cmp   MouseYmax, BX
  JNS   @5                      { MouseYmax >= MouseY }
  Mov   BX, MouseYmax
@5:
  Mov   MouseX, AX
  Mov   MouseY, BX

  Or    CX, DX
  JZ    @noupdate
@update:
  Push  SI
  Push  DI
  Call  MouseUpdate             { MouseUpdate (X0, Y0) }
@noupdate:
  Cmp   XVirtualScreenMode, TRUE
  JNE   @novirtual
  Call  VirtualSupport
@novirtual:
  Mov   AX, 3
  Int   33h                     { "last" read fn call }
  Pop   DS
  PopA
  PopF
End;
{$F-}

Procedure MouseInit;
Var
  R : Registers;
Begin
  If not MousePresent then Exit;
  MouseVisibl := False;
  MouseX := 160;
  MouseY := 120;
  MouseButtons := 0;
  with R do Begin
    AX := $C;
    CX := $1F;  { Mask <- interrupt on mouse moving and it's key pressing/releasing }
    ES := Seg(MouseHandler);          { The new }
    DX := Ofs(MouseHandler);          { handler address }
    Intr ($33, R)
  End
End;

Procedure MouseDone;
Var
  R : Registers;
Begin
  If not MousePresent then Exit;
  MouseHide;
  with R do Begin
    AX := 0;                            { Reset mouse driver }
    Intr ($33, R)
  End
End;

Begin
  GrResult := GrOk;
  CurFont := nil;
  FontX := 0;
  FontY := 0;
  TranspColor := Black;
  MousePresent := MouseFound
End.
