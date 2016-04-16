uses Crt;
Const NumMax=10;
var Numbers: array[1..NumMax] of integer;     {содержит числа выражения}
    AmountNumbers: integer;                   {кол-во чисел}
    AmountAnagrams: Longint;                  {кол-во анаграмм}
    AmountRearrangements: Longint;            {кол-во перестановок}
    OriginalExpression,Expression: string;    {исходное выражение, польская запись}
    Original: integer;                        {число-анаграмма}
    f: text;

  procedure ChooseNumbers(var st: string); {Выбирает из выражения числа.}
  var i,s: byte;                           {Числа разделенные действиями}
      Code: integer;                 {храним в разных элементах массива.}
      stv: string;                   {Заменяем числа латинскими буквами.}
  begin
    i:=1;
    repeat

      if st[i] in ['0'..'9'] then    {если нашли число: запомин. его начало}
        begin
          s:=i; Inc(AmountNumbers); stv:=''; {увел. счетчик; stv - пустая стр.}

          repeat
            stv:=stv+st[i];                     {считываем число в stv}
            Inc(i)
          until (i>Length(st)) or not(st[i] in ['0'..'9']);

          val(stv,Numbers[AmountNumbers],Code); {переводим строку в число}
          Delete(st,s,i-s);                     {удаляем число из строки}
          Insert(chr(96+AmountNumbers),st,s); {заменяем его латинской буквой}

          i:=s+1;
        end;

      Inc(i)
    until i>Length(st)
  end; {ChooseNumbers}

  procedure SortNumbers;                 {Сортируем массив чисел Numbers}
  var i,j,m,a,b: integer;                {и меняем соответственно буквы в}
      ch: char;                           {Expression}
  begin
    for i:=1 to AmountNumbers-1 do
      for j:=i+1 to AmountNumbers do     {Быстрая сортировка не нужна, т.к.}
        if Numbers[i]>Numbers[j] then    {кол-во чисел небольшое}
          begin
            m:=Numbers[i];
            Numbers[i]:=Numbers[j];      {Обмен Numbers[i] и Numbers[j]}
            Numbers[j]:=m;

            a:=Pos(chr(96+i),Expression);   {находим ссылку на Numbers[i]}
            b:=Pos(chr(96+j),Expression);   {находим ссылку на Numbers[j]}

            ch:=Expression[a];
            Expression[a]:=Expression[b];   {Обен букв Expression[i] и}
            Expression[b]:=ch               {Expression[j] }
          end
  end; {SortNumbers}

  function Rearrangements: boolean;      {Получаем следующую перестановку}
  Var i,k,m: Integer;                    {Лексическая перестановка}
  Begin
    Rearrangements:=True;

    i:=AmountNumbers; k:=0;
    while (k=0) and (i>1) do                {Ищем a[i-1]<a[i]}
      begin
        if Numbers[i-1]<Numbers[i] then k:=i-1;
        i:=i-1
      end;

    if k=0 then begin Rearrangements:=False; Exit end;   {если не нашли}

    i:=AmountNumbers;
    m:=0;

    While m=0 do                        {Ищем минимальный элемент,}
      begin                             {но больший a[k] }
        if Numbers[k]<Numbers[i] then m:=i;
        i:=i-1
      end;

    i:=Numbers[k];
    Numbers[k]:=Numbers[m];     {Обмен значениями a[k] и a[m]}
    Numbers[m]:=i;

    m:=1;
    while m<(AmountNumbers-k+1)/2 do
      begin
        i:=Numbers[k+m];     {упорядочиваем хвост по возрастанию}
        Numbers[k+m]:=Numbers[AmountNumbers+1-m];
        Numbers[AmountNumbers+1-m]:=i;
        m:=m+1
     end;

     Inc(AmountRearrangements)  {увеличиваем счетчик перестановок}
  end; {Rearrangements}

  procedure Poliz(var a: string);  {Переводит выражение в "Польскую" запись}
  type chars=string[1];            {которая обеспечит быстрое многократное}
  var b: string;                   {вычисление выражения}
      c,d,e: array[0..20] of chars;   {20 - это макс. число вложенных скобок}
      i,m: byte;
  begin
    b:=''; m:=0; c[m]:=''; d[m]:=''; e[m]:='';
    for i:=1 to length(a) do
      case a[i] of
        'a'..'z': b:=b+a[i];
        '+','-': begin b:=b+d[m]+c[m]+e[m]; c[m]:=''; d[m]:=''; e[m]:=a[i] end;
        '*','/': begin b:=b+d[m]+c[m]; c[m]:=a[i]; d[m]:='' end;
        '^': begin b:=b+d[m]; d[m]:=a[i] end;
        '(': begin m:=m+1; c[m]:=''; d[m]:=''; e[m]:='' end;
        ')': begin b:=b+d[m]+c[m]+e[m]; m:=m-1 end
      end;
    a:=b+d[m]+c[m]+e[m]
  end;

  function Calc: integer;     {вычисляет Expression}
  var i,Top: integer;         {вместо 'a'..'z' подставляет числа из Numbers}
      steck: array[1..NumMax] of integer;
      Len: byte absolute Expression;
  begin
    Top:=0;
    for i:=1 to Len do
      case Expression[i] of
        'a'..'z': begin Inc(Top); Steck[Top]:=Numbers[Ord(Expression[i])-96] end;
        '+': begin Dec(Top); Steck[Top]:=Steck[Top]+Steck[Top+1] end;
        '-': begin Dec(Top); Steck[Top]:=Steck[Top]-Steck[Top+1] end;
        '*': begin Dec(Top); Steck[Top]:=Steck[Top]*Steck[Top+1] end;
        '/': begin Dec(Top); Steck[Top]:=Steck[Top] div Steck[Top+1] end
      end;
    Calc:=Steck[1]
  end; {Calc}

  procedure InputData;                        {вводим исходные данные}
  begin
    ClrScr;
    Write('Введите выражение: ');
    ReadLn(Expression)
  end; {InputData}

  procedure OutAnagram;
  var i: integer;
  begin
    Inc(AmountAnagrams);         {увелич. кол-во найденных анаграмм}

    for i:=1 to Length(OriginalExpression) do
      if OriginalExpression[i] in ['a'..'z'] then
        begin
          Write(Numbers[Ord(OriginalExpression[i])-96]);    {если буква - выводим}
          Write(f,Numbers[Ord(OriginalExpression[i])-96])   {число из Numbers}
        end
      else
        begin
          Write(OriginalExpression[i]);
          Write(f,OriginalExpression[i])
        end;

    WriteLn(' = ',Original);    {печать результата, переход на новую строку}
    WriteLn(f,' = ',Original)
  end; {OutAnagram}

begin
  AmountNumbers:=0;
  AmountAnagrams:=-1;        {Исходное выражение не считать анаграммой}
  AmountRearrangements:=1;   {Исходное выражение считать за перестановку}

  InputData;                 {Вводим данные}
  ChooseNumbers(Expression); {Выбираем числа из выражения, заменяем их буквами}
  SortNumbers;               {Сортируем числа, и буквы}

  OriginalExpression:=Expression;
  Poliz(Expression);         {переводим в "Польскую" запись}
  Original:=Calc;            {Вычисляем выражение}

  Assign(f,'anagram.out');
  ReWrite(f);

  Write('> ');   {выводим в файл исходное выражение}
  Write(f,'> ');
  OutAnagram;

  While Rearrangements do              {Если проверены не все перестановки}
    if Calc=Original then OutAnagram;  {перестанавливаем, проверяем, выводим}

  WriteLn('Всего перестановок - ',AmountRearrangements,', из них анаграмм - ',
                                                          AmountAnagrams);
  WriteLn(f,'Всего перестановок - ',AmountRearrangements,', из них анаграмм - ',
                                                          AmountAnagrams);
  Close(f)
end.